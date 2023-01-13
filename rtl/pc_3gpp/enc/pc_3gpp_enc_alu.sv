/*



  parameter int pN_MAX  = 1024 ;
  parameter int pWORD_W =    8 ;



  logic         pc_3gpp_enc_alu__iclk            ;
  logic         pc_3gpp_enc_alu__ireset          ;
  logic         pc_3gpp_enc_alu__iclkena         ;
  alu_opcode_t  pc_3gpp_enc_alu__iopcode         ;
  beta_w_dat_t  pc_3gpp_enc_alu__idat            ;
  beta_w_addr_t pc_3gpp_enc_alu__ibeta_raddr     ;
  logic         pc_3gpp_enc_alu__ibeta_rsel      ;
  beta_w_dat_t  pc_3gpp_enc_alu__ibeta_rdat  [2] ;
  beta_w_addr_t pc_3gpp_enc_alu__iaddr2write     ;
  logic         pc_3gpp_enc_alu__isel2write      ;
  logic         pc_3gpp_enc_alu__ifull2write     ;
  logic         pc_3gpp_enc_alu__obeta_write     ;
  beta_w_addr_t pc_3gpp_enc_alu__obeta_waddr     ;
  logic         pc_3gpp_enc_alu__obeta_wsel      ;
  beta_w_dat_t  pc_3gpp_enc_alu__obeta_wdat      ;
  logic         pc_3gpp_enc_alu__owfull          ;
  logic         pc_3gpp_enc_alu__owrite          ;
  beta_w_addr_t pc_3gpp_enc_alu__owaddr          ;
  beta_w_dat_t  pc_3gpp_enc_alu__owdat           ;



  pc_3gpp_enc_alu
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W )
  )
  pc_3gpp_enc_alu
  (
    .iclk        ( pc_3gpp_enc_alu__iclk        ) ,
    .ireset      ( pc_3gpp_enc_alu__ireset      ) ,
    .iclkena     ( pc_3gpp_enc_alu__iclkena     ) ,
    .iopcode     ( pc_3gpp_enc_alu__iopcode     ) ,
    .idat        ( pc_3gpp_enc_alu__idat        ) ,
    .ibeta_raddr ( pc_3gpp_enc_alu__ibeta_raddr ) ,
    .ibeta_rsel  ( pc_3gpp_enc_alu__ibeta_rsel  ) ,
    .ibeta_rdat  ( pc_3gpp_enc_alu__ibeta_rdat  ) ,
    .iaddr2write ( pc_3gpp_enc_alu__iaddr2write ) ,
    .isel2write  ( pc_3gpp_enc_alu__isel2write  ) ,
    .ifull2write ( pc_3gpp_enc_alu__ifull2write ) ,
    .obeta_write ( pc_3gpp_enc_alu__obeta_write ) ,
    .obeta_waddr ( pc_3gpp_enc_alu__obeta_waddr ) ,
    .obeta_wsel  ( pc_3gpp_enc_alu__obeta_wsel  ) ,
    .obeta_wdat  ( pc_3gpp_enc_alu__obeta_wdat  ) ,
    .owfull      ( pc_3gpp_enc_alu__owfull      ) ,
    .owrite      ( pc_3gpp_enc_alu__owrite      ) ,
    .owaddr      ( pc_3gpp_enc_alu__owaddr      ) ,
    .owdat       ( pc_3gpp_enc_alu__owdat       )
  );


  assign pc_3gpp_enc_alu__iclk        = '0 ;
  assign pc_3gpp_enc_alu__ireset      = '0 ;
  assign pc_3gpp_enc_alu__iclkena     = '0 ;
  assign pc_3gpp_enc_alu__iopcode     = '0 ;
  assign pc_3gpp_enc_alu__idat        = '0 ;
  assign pc_3gpp_enc_alu__ibeta_raddr = '0 ;
  assign pc_3gpp_enc_alu__ibeta_rsel  = '0 ;
  assign pc_3gpp_enc_alu__ibeta_rdat  = '0 ;
  assign pc_3gpp_enc_alu__iaddr2write = '0 ;
  assign pc_3gpp_enc_alu__isel2write  = '0 ;
  assign pc_3gpp_enc_alu__ifull2write = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_enc_ctrl.sv
// Description   : Recursive polar encoder arithmetic unit.
//


module pc_3gpp_enc_alu
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  iopcode     ,
  idat        ,
  ibeta_raddr ,
  ibeta_rsel  ,
  ibeta_rdat  ,
  //
  iaddr2write ,
  isel2write  ,
  ifull2write ,
  //
  obeta_write ,
  obeta_waddr ,
  obeta_wsel  ,
  obeta_wdat  ,
  //
  owfull      ,
  owrite      ,
  owaddr      ,
  owdat
);

  `include "pc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk            ;
  input  logic          ireset          ;
  input  logic          iclkena         ;
  //
  input  alu_opcode_t   iopcode         ;
  input  beta_w_dat_t   idat            ;
  input  beta_w_addr_t  ibeta_raddr     ;
  input  logic          ibeta_rsel      ;
  input  beta_w_dat_t   ibeta_rdat  [2] ;
  //
  input  beta_w_addr_t  iaddr2write     ;
  input  logic          isel2write      ;
  input  logic          ifull2write     ;
  //
  output logic          obeta_write     ;
  output beta_w_addr_t  obeta_waddr     ;
  output logic          obeta_wsel      ;
  output beta_w_dat_t   obeta_wdat      ;
  //
  output logic          owfull          ;
  output logic          owrite          ;
  output beta_w_addr_t  owaddr          ;
  output beta_w_dat_t   owdat           ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  beta_w_dat_t do_8x8_rslt;

  beta_w_dat_t comb8_ext_rslt;

  beta_w_dat_t comb8_int_rslt;

  beta_w_dat_t comb8_intc_rslt [2];

  // internal small caches
  beta_w_dat_t do_8x8_rslt_reg [2];
  beta_w_dat_t comb8_cache     [2][2];

  //------------------------------------------------------------------------------------------------------
  // base engine functions
  //------------------------------------------------------------------------------------------------------

  assign do_8x8_rslt        = do_ns_encode_8x8(idat);

  assign comb8_ext_rslt     = do_comb8(ibeta_rdat[0],       ibeta_rdat[1],      ibeta_rsel);

  assign comb8_int_rslt     = do_comb8(do_8x8_rslt_reg[0],  do_8x8_rslt_reg[1], ibeta_rsel);

  assign comb8_intc_rslt[0] = do_comb8(comb8_cache[0][0],   comb8_cache[1][0],  ibeta_rsel);
  assign comb8_intc_rslt[1] = do_comb8(comb8_cache[0][1],   comb8_cache[1][1],  ibeta_rsel);

  //
  //
  //

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owaddr      <= iaddr2write;
      obeta_waddr <= iaddr2write;
      obeta_wsel  <= isel2write;
      //
      unique case (iopcode)
        cDO_8x8 : begin
          do_8x8_rslt_reg[1] <= do_8x8_rslt;
          do_8x8_rslt_reg[0] <= do_8x8_rslt_reg[1];
        end
        //
        cCOMB_int : begin
          obeta_wdat <= comb8_int_rslt;
          //
          comb8_cache[isel2write][iaddr2write[0]] <= comb8_int_rslt;
        end
        //
        cCOMB_intc : begin
          obeta_wdat <= comb8_intc_rslt[ibeta_raddr[0]];
        end
        //
        cCOMB_ext, cCOMB_last : begin
          obeta_wdat <= comb8_ext_rslt;
        end
        default : begin end
      endcase
    end
  end

  assign owdat = obeta_wdat;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obeta_write <= 1'b0;
      owrite      <= 1'b0;
      owfull      <= 1'b0;
    end
    else if (iclkena) begin
      obeta_write <= (iopcode == cCOMB_int) | (iopcode == cCOMB_ext) | (iopcode == cCOMB_intc);
      owrite      <= (iopcode == cCOMB_last);
      owfull      <= ifull2write;
    end
  end

endmodule
