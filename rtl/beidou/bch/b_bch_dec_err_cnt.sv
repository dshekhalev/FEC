/*



  parameter bit pUSE_L_POLY       = 0 ;
  parameter int pLLR_W            = 4 ;
  parameter int pTAG_W            = 8 ;
  //
  parameter bit pDO_LLR_INVERSION = 0 ;



  logic                b_bch_dec_err_cnt__iclk      ;
  logic                b_bch_dec_err_cnt__ireset    ;
  logic                b_bch_dec_err_cnt__iclkena   ;
  //
  logic                b_bch_dec_err_cnt__isop      ;
  logic                b_bch_dec_err_cnt__ival      ;
  logic                b_bch_dec_err_cnt__ieop      ;
  logic [pLLR_W-1 : 0] b_bch_dec_err_cnt__iLLR      ;
  logic                b_bch_dec_err_cnt__icand_dat ;
  //
  logic                b_bch_dec_err_cnt__oval      ;
  logic [cDAT_W-1 : 0] b_bch_dec_err_cnt__oerr      ;



  b_bch_dec_err_cnt
  #(
    .pUSE_L_POLY       ( pUSE_L_POLY       ) ,
    .pLLR_W            ( pLLR_W            ) ,
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  b_bch_dec_err_cnt
  (
    .iclk      ( b_bch_dec_err_cnt__iclk      ) ,
    .ireset    ( b_bch_dec_err_cnt__ireset    ) ,
    .iclkena   ( b_bch_dec_err_cnt__iclkena   ) ,
    //
    .isop      ( b_bch_dec_err_cnt__isop      ) ,
    .ival      ( b_bch_dec_err_cnt__ival      ) ,
    .ieop      ( b_bch_dec_err_cnt__ieop      ) ,
    .iLLR      ( b_bch_dec_err_cnt__iLLR      ) ,
    .icand_dat ( b_bch_dec_err_cnt__icand_dat ) ,
    //
    .oval      ( b_bch_dec_err_cnt__oval      ) ,
    .oerr      ( b_bch_dec_err_cnt__oerr      )
  );


  assign b_bch_dec_err_cnt__iclk      = '0 ;
  assign b_bch_dec_err_cnt__ireset    = '0 ;
  assign b_bch_dec_err_cnt__iclkena   = '0 ;
  assign b_bch_dec_err_cnt__isop      = '0 ;
  assign b_bch_dec_err_cnt__ival      = '0 ;
  assign b_bch_dec_err_cnt__ieop      = '0 ;
  assign b_bch_dec_err_cnt__iLLR      = '0 ;
  assign b_bch_dec_err_cnt__icand_dat = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_dec_err_cnt.svh
// Description   : sequential bit error accumulator
//

module b_bch_dec_err_cnt
#(
  parameter bit pUSE_L_POLY       = 0 ,
  parameter int pLLR_W            = 4 ,
  parameter int pTAG_W            = 8 ,
  //
  parameter bit pDO_LLR_INVERSION = 0
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  isop      ,
  ival      ,
  ieop      ,
  iLLR      ,
  icand_dat ,
  //
  oval      ,
  oerr
);

  `include "b_bch_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = cDBIT_NUM[pUSE_L_POLY] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk      ;
  input  logic                       ireset    ;
  input  logic                       iclkena   ;
  //
  input  logic                       isop      ;
  input  logic                       ival      ;
  input  logic                       ieop      ;
  input  logic signed [pLLR_W-1 : 0] iLLR      ;
  input  logic                       icand_dat ;
  //
  output logic                       oval      ;
  output logic        [cDAT_W-1 : 0] oerr      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival & ieop;
    end
  end

  wire bit_err = get_hd(iLLR) ^ icand_dat;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        oerr <= isop ? (bit_err) : (oerr + bit_err);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  function automatic logic get_hd (logic signed [pLLR_W-1 : 0] LLR);
  begin
    if (pLLR_W <= 1) begin
      get_hd = LLR;
    end
    else begin
      get_hd = pDO_LLR_INVERSION ? (LLR <= 0) : (LLR >= 0);
    end
  end
  endfunction

endmodule
