/*



  parameter int pADDR_W   = 8 ;
  parameter int pDAT_W    = 8 ;
  parameter bit pSHIFT_R  = 0 ;
  parameter bit pPIPE     = 0 ;



  logic         ldpc_3gpp_enc_mm__iclk     ;
  logic         ldpc_3gpp_enc_mm__ireset   ;
  logic         ldpc_3gpp_enc_mm__iclkena  ;
  //
  hb_zc_t       ldpc_3gpp_enc_mm__iused_zc ;
  //
  logic         ldpc_3gpp_enc_mm__iwrite   ;
  logic         ldpc_3gpp_enc_mm__iwstart  ;
  dat_t         ldpc_3gpp_enc_mm__iwdat    ;
  //
  logic         ldpc_3gpp_enc_mm__iread    ;
  logic         ldpc_3gpp_enc_mm__irstart  ;
  mm_hb_value_t ldpc_3gpp_enc_mm__irHb     ;
  logic         ldpc_3gpp_enc_mm__irval    ;
  strb_t        ldpc_3gpp_enc_mm__irstrb   ;
  //
  logic         ldpc_3gpp_enc_mm__oval     ;
  strb_t        ldpc_3gpp_enc_mm__ostrb    ;
  dat_t         ldpc_3gpp_enc_mm__odat     ;



  ldpc_3gpp_enc_mm_spram
  #(
    .pADDR_W  ( pADDR_W  ) ,
    .pDAT_W   ( pDAT_W   ) ,
    .pSHIFT_R ( pSHIFT_R ) ,
    .pPIPE    ( pPIPE    )
  )
  ldpc_3gpp_enc_mm
  (
    .iclk     ( ldpc_3gpp_enc_mm__iclk     ) ,
    .ireset   ( ldpc_3gpp_enc_mm__ireset   ) ,
    .iclkena  ( ldpc_3gpp_enc_mm__iclkena  ) ,
    //
    .iused_zc ( ldpc_3gpp_enc_mm__iused_zc ) ,
    //
    .iwrite   ( ldpc_3gpp_enc_mm__iwrite   ) ,
    .iwstart  ( ldpc_3gpp_enc_mm__iwstart  ) ,
    .iwdat    ( ldpc_3gpp_enc_mm__iwdat    ) ,
    //
    .iread    ( ldpc_3gpp_enc_mm__iread    ) ,
    .irstart  ( ldpc_3gpp_enc_mm__irstart  ) ,
    .irHb     ( ldpc_3gpp_enc_mm__irHb     ) ,
    .irval    ( ldpc_3gpp_enc_mm__irval    ) ,
    .irstrb   ( ldpc_3gpp_enc_mm__irstrb   ) ,
    //
    .oval     ( ldpc_3gpp_enc_mm__oval     ) ,
    .ostrb    ( ldpc_3gpp_enc_mm__ostrb    ) ,
    .odat     ( ldpc_3gpp_enc_mm__odat     )
  );


  assign ldpc_3gpp_enc_mm__iclk     = '0 ;
  assign ldpc_3gpp_enc_mm__ireset   = '0 ;
  assign ldpc_3gpp_enc_mm__iclkena  = '0 ;
  //
  assign ldpc_3gpp_enc_mm__iused_zc = '0 ;
  //
  assign ldpc_3gpp_enc_mm__iwrite   = '0 ;
  assign ldpc_3gpp_enc_mm__iwstart  = '0 ;
  assign ldpc_3gpp_enc_mm__iwdat    = '0 ;
  //
  assign ldpc_3gpp_enc_mm__iread    = '0 ;
  assign ldpc_3gpp_enc_mm__irstart  = '0 ;
  assign ldpc_3gpp_enc_mm__irHb     = '0 ;
  assign ldpc_3gpp_enc_mm__irval    = '0 ;
  assign ldpc_3gpp_enc_mm__irstrb   = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_mm_spram.sv
// Description   : matrix multiplier based upon single port ram. shift left by default
//                  write cycle take Zc/pDAT_W cycles
//                  read  cycle take 1+Zc/pDAT_W cycles (+1 cycle for upload pipeline)
//                  read  latency  pPIPE (0/1) = 3/4 tick
//

`include "define.vh"

module ldpc_3gpp_enc_mm_spram
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  iused_zc ,
  //
  iwrite   ,
  iwstart  ,
  iwdat    ,
  //
  iread    ,
  irstart  ,
  irHb     ,
  irval    ,
  irstrb   ,
  //
  oval     ,
  ostrb    ,
  odat
);

  parameter int pADDR_W   = 8 ;
  parameter bit pSHIFT_R  = 0 ; // circshift right(1)/left (0)
  parameter bit pPIPE     = 0 ; // use matrix multiply pipeline or not

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk     ;
  input  logic         ireset   ;
  input  logic         iclkena  ;
  //
  input  hb_zc_t       iused_zc ;
  //
  input  logic         iwrite   ;
  input  logic         iwstart  ;
  input  dat_t         iwdat    ;
  //
  input  logic         iread    ;
  input  logic         irstart  ;
  input  mm_hb_value_t irHb     ;
  input  logic         irval    ;
  input  strb_t        irstrb   ;
  //
  output logic         oval     ;
  output strb_t        ostrb    ;
  output dat_t         odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic  [pADDR_W-1 : 0] addr_t;
  typedef logic [2*pDAT_W-1 : 0] shift_dat_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  dat_t         ram  [2**pADDR_W] /* synthesis ramstyle = "no_rw_check" */;

  addr_t        addr;
  logic         addr_max;

  hb_zc_t       used_zc_m1;
  hb_zc_t       used_zc_m2;

  logic         write;
  dat_t         wdat;

  dat_t         rdat     [3];

  mm_hb_value_t rHb          ;
  mm_hb_value_t rHb_line [2] ;

  shift_dat_t   shift_dat_right;
  shift_dat_t   shift_dat_left;

  logic [3 : 0] rval;
  strb_t        rstrb [4];

  //------------------------------------------------------------------------------------------------------
  // write :
  //    iwrite  __1111___
  //    iwstart __1______
  // read :
  //    iread   __11111__
  //    irstart __1______
  //    irsop   ___1_____
  //    irval   ___1111__
  //    ireop   ______1__
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      write <= 1'b0;
    end
    else if (iclkena) begin
      write <= iwrite;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // can do so, because iused_zc set at write phase
      used_zc_m1 <= iused_zc-1;
      used_zc_m2 <= iused_zc-2;
      //
      wdat    <= iwdat;
      rHb     <= irHb;
      //
      if (iwrite | iread) begin
        if (iwrite) begin
          if (iwstart) begin
            addr      <= '0;
            addr_max  <= 1'b0;
          end
          else begin
            addr      <= addr_max ? '0 : (addr + 1'b1);
            addr_max  <= (addr == used_zc_m2);
          end
        end
        else begin
          if (pSHIFT_R) begin
            if (irstart) begin
              addr     <= used_zc_m1 - irHb.wshift;
              addr_max <= (irHb.wshift == 0);
            end
            else begin
              addr     <= addr_max ? '0 : (addr + 1'b1);
              addr_max <= (addr == used_zc_m2);
            end
          end
          else begin
            if (irstart) begin
              addr     <= irHb.wshift;
//            addr_max <= (irHb.wshift == used_zc_m1);
              addr_max <= irHb.is_max;
            end
            else begin
              addr     <= addr_max ? '0 : (addr + 1'b1);
              addr_max <= (addr == used_zc_m2);
            end
          end
        end
      end
    end
  end

  generate
    if (pPIPE) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (write) begin
            ram[addr] <= wdat;
          end
          //
          rdat    [0] <= ram[addr];
          rHb_line[0] <= rHb;

          rdat    [1] <= rdat    [0];
          rHb_line[1] <= rHb_line[0];
          //
          rdat    [2] <= rdat[1];
        end
      end
    end
    else begin

      assign rdat     [1] = rdat[0];
      assign rHb_line [1] = rHb_line[0];

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (write) begin
            ram[addr] <= wdat;
          end
          //
          rdat    [0] <= ram[addr];
          rHb_line[0] <= rHb;
          //
          rdat    [2] <= rdat[1];
        end
      end

    end
  endgenerate

  generate
    if (pDAT_W == 1) begin
      assign shift_dat_left  = {rdat[1], rdat[2]};
      assign shift_dat_right = {rdat[1], rdat[2]};
    end
    else begin
      assign shift_dat_left  = {rdat[1], rdat[2]} >> rHb_line[1].bshift;
      assign shift_dat_right = {rdat[1], rdat[2]} << rHb_line[1].bshift;
   end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      rval <= '0;
    end
    else if (iclkena) begin
      rval <= (rval << 1) | irval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < $size(rstrb); i++) begin
        rstrb[i] <= (i == 0) ? irstrb : rstrb[i-1];
      end
      //
      if (rHb_line[1].is_masked) begin
        odat <= '0;
      end
      else if (pSHIFT_R) begin
        odat <= shift_dat_right[pDAT_W +: pDAT_W];
      end
      else begin
        odat <= shift_dat_left [0      +: pDAT_W];
      end
    end
  end

  assign oval   = rval  [2 + pPIPE];
  assign ostrb  = rstrb [2 + pPIPE];

endmodule
