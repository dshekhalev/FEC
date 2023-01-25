/*



  parameter int pADDR_W = 8 ;
  parameter int pDAT_W  = 8 ;
  parameter int pPIPE   = 1 ;



  logic          ldpc_3gpp_enc_reg_spram__iclk    ;
  logic          ldpc_3gpp_enc_reg_spram__ireset  ;
  logic          ldpc_3gpp_enc_reg_spram__iclkena ;
  //
  logic          ldpc_3gpp_enc_reg_spram__iwrite  ;
  logic          ldpc_3gpp_enc_reg_spram__iwstart ;
  dat_t          ldpc_3gpp_enc_reg_spram__iwdat   ;
  //
  logic          ldpc_3gpp_enc_reg_spram__iread   ;
  logic          ldpc_3gpp_enc_reg_spram__irstart ;
  //
  logic          ldpc_3gpp_enc_reg_spram__oval    ;
  logic          ldpc_3gpp_enc_reg_spram__ostart  ;
  dat_t          ldpc_3gpp_enc_reg_spram__odat    ;


  ldpc_3gpp_enc_reg_spram
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pPIPE   ( pPIPE   )
  )
  ldpc_3gpp_enc_reg_spram
  (
    .iclk    ( ldpc_3gpp_enc_reg_spram__iclk    ) ,
    .ireset  ( ldpc_3gpp_enc_reg_spram__ireset  ) ,
    .iclkena ( ldpc_3gpp_enc_reg_spram__iclkena ) ,
    //
    .iwrite  ( ldpc_3gpp_enc_reg_spram__iwrite  ) ,
    .iwstart ( ldpc_3gpp_enc_reg_spram__iwstart ) ,
    .iwdat   ( ldpc_3gpp_enc_reg_spram__iwdat   ) ,
    //
    .iread   ( ldpc_3gpp_enc_reg_spram__iread   ) ,
    .irstart ( ldpc_3gpp_enc_reg_spram__irstart ) ,
    //
    .oval    ( ldpc_3gpp_enc_reg_spram__oval    ) ,
    .ostart  ( ldpc_3gpp_enc_reg_spram__ostart  ) ,
    .odat    ( ldpc_3gpp_enc_reg_spram__odat    )
  );


  assign ldpc_3gpp_enc_reg_spram__iclk    = '0 ;
  assign ldpc_3gpp_enc_reg_spram__ireset  = '0 ;
  assign ldpc_3gpp_enc_reg_spram__iclkena = '0 ;
  //
  assign ldpc_3gpp_enc_reg_spram__iwrite  = '0 ;
  assign ldpc_3gpp_enc_reg_spram__iwstart = '0 ;
  assign ldpc_3gpp_enc_reg_spram__iwdat   = '0 ;
  //
  assign ldpc_3gpp_enc_reg_spram__iread   = '0 ;
  assign ldpc_3gpp_enc_reg_spram__irstart = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_reg_spram.sv
// Description   : matrix register based upon single port ram.
//                  write/update/read cycle take Zc/pDAT_W cycles
//                  read latency pPIPE (0/1) = 3/4 tick
//

`include "define.vh"

module ldpc_3gpp_enc_reg_spram
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  iwrite   ,
  iwstart  ,
  iwdat    ,
  //
  iread    ,
  irstart  ,
  //
  oval     ,
  ostart   ,
  odat
);

  parameter int pADDR_W = 8 ;
  parameter bit pPIPE   = 0 ; // use matrix multiply pipeline or not

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic iclk     ;
  input  logic ireset   ;
  input  logic iclkena  ;
  //
  input  logic iwrite   ;
  input  logic iwstart  ;
  input  dat_t iwdat    ;
  //
  input  logic iread    ;
  input  logic irstart  ;
  //
  output logic oval     ;
  output logic ostart   ;
  output dat_t odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic  [pADDR_W-1 : 0] addr_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  dat_t         ram  [2**pADDR_W] /* synthesis ramstyle = "no_rw_check" */;

  addr_t        addr;
  logic         write;
  dat_t         wdat;

  dat_t         rdat [3];

  logic [4 : 0] read;
  logic [4 : 0] rstart;

  //------------------------------------------------------------------------------------------------------
  //
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
      wdat    <= iwdat;
      //
      if (iwrite | iread) begin
        if (iwrite) begin
          addr <= iwstart ? '0 : (addr + 1'b1);
        end
        else begin
          addr <= irstart ? '0 : (addr + 1'b1);
        end
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (write) begin
        ram[addr] <= wdat;
      end
      //
      rdat [0] <= ram [addr];
      rdat [1] <= rdat[0];
      rdat [2] <= rdat[1];
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      read <= '0;
    end
    else if (iclkena) begin
      read <= (read << 1) | iread;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      rstart  <= (rstart << 1) | irstart;
      odat    <= rdat[1 + pPIPE];
    end
  end

  assign oval   = read  [2 + pPIPE];
  assign ostart = rstart[2 + pPIPE];

endmodule
