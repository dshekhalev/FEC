/*



  parameter bit pUSE_L_POLY = 0 ;
  parameter int pLLR_W      = 4 ;
  parameter int pADDR_W     = 6 ;



  logic                 b_bch_dec_source__iclk       ;
  logic                 b_bch_dec_source__ireset     ;
  logic                 b_bch_dec_source__iclkena    ;
  //
  logic                 b_bch_dec_source__isop       ;
  logic                 b_bch_dec_source__ival       ;
  logic                 b_bch_dec_source__ieop       ;
  logic  [pLLR_W-1 : 0] b_bch_dec_source__iLLR       ;
  //
  logic                 b_bch_dec_source__oframe_err ;
  //
  logic                 b_bch_dec_source__owrite     ;
  logic [pADDR_W-1 : 0] b_bch_dec_source__owaddr     ;
  logic  [pLLR_W-1 : 0] b_bch_dec_source__owLRR      ;



  b_bch_dec_source
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pLLR_W      ( pLLR_W      ) ,
    .pADDR_W     ( pADDR_W     )
  )
  b_bch_dec_source
  (
    .iclk       ( b_bch_dec_source__iclk       ) ,
    .ireset     ( b_bch_dec_source__ireset     ) ,
    .iclkena    ( b_bch_dec_source__iclkena    ) ,
    //
    .isop       ( b_bch_dec_source__isop       ) ,
    .ival       ( b_bch_dec_source__ival       ) ,
    .ieop       ( b_bch_dec_source__ieop       ) ,
    .iLLR       ( b_bch_dec_source__iLLR       ) ,
    //
    .oframe_err ( b_bch_dec_source__oframe_err ) ,
    //
    .owrite     ( b_bch_dec_source__owrite     ) ,
    .owaddr     ( b_bch_dec_source__owaddr     ) ,
    .owLRR      ( b_bch_dec_source__owLRR      )
  );


  assign b_bch_dec_source__iclk    = '0 ;
  assign b_bch_dec_source__ireset  = '0 ;
  assign b_bch_dec_source__iclkena = '0 ;
  assign b_bch_dec_source__isop    = '0 ;
  assign b_bch_dec_source__ival    = '0 ;
  assign b_bch_dec_source__ieop    = '0 ;
  assign b_bch_dec_source__iLLR    = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_dec_source.svh
// Description   : source & frame check unot
//

module b_bch_dec_source
#(
  parameter bit pUSE_L_POLY = 0 ,
  parameter int pLLR_W      = 4 ,
  parameter int pADDR_W     = 6
)
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  isop       ,
  ival       ,
  ieop       ,
  iLLR       ,
  //
  oframe_err ,
  //
  owrite     ,
  owaddr     ,
  owLRR
);

  `include "b_bch_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk       ;
  input  logic                 ireset     ;
  input  logic                 iclkena    ;
  //
  input  logic                 isop       ;
  input  logic                 ival       ;
  input  logic                 ieop       ;
  input  logic  [pLLR_W-1 : 0] iLLR       ;
  //
  output logic                 oframe_err ;
  //
  output logic                 owrite     ;
  output logic [pADDR_W-1 : 0] owaddr     ;
  output logic  [pLLR_W-1 : 0] owLRR      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_MAX = cBIT_NUM[pUSE_L_POLY];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owrite <= ival;
      if (ival) begin
        owaddr <= isop ? '0 : (owaddr + 1'b1);
        owLRR  <= iLLR;
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oframe_err <= 1'b0;
    end
    else if (iclkena) begin
      oframe_err <= (ival & isop & ieop) | (ival & ieop & (owaddr != (cADDR_MAX-2)));
    end
  end

endmodule
