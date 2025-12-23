/*



  parameter int pTAG_W  = 1 ;



  logic                golay24_enc__iclk     ;
  logic                golay24_enc__ireset   ;
  logic                golay24_enc__iclkena  ;
  logic                golay24_enc__ival     ;
  logic [pTAG_W-1 : 0] golay24_enc__itag     ;
  logic       [11 : 0] golay24_enc__idat     ;
  logic                golay24_enc__oval     ;
  logic [pTAG_W-1 : 0] golay24_enc__otag     ;
  logic       [23 : 0] golay24_enc__odat     ;



  golay24_enc
  #(
    .pTAG_W ( pTAG_W )
  )
  golay24_enc
  (
    .iclk    ( golay24_enc__iclk    ) ,
    .ireset  ( golay24_enc__ireset  ) ,
    .iclkena ( golay24_enc__iclkena ) ,
    .ival    ( golay24_enc__ival    ) ,
    .itag    ( golay24_enc__itag    ) ,
    .idat    ( golay24_enc__idat    ) ,
    .oval    ( golay24_enc__oval    ) ,
    .otag    ( golay24_enc__otag    ) ,
    .odat    ( golay24_enc__odat    )
  );


  assign golay24_enc__iclk    = '0 ;
  assign golay24_enc__ireset  = '0 ;
  assign golay24_enc__iclkena = '0 ;
  assign golay24_enc__ival    = '0 ;
  assign golay24_enc__itag    = '0 ;
  assign golay24_enc__idat    = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Workfile      : golay24_enc.sv
// Description   : golay extened code {24, 12, 8} encoder. g(x) = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1 (12'hC75)
//

module golay24_enc
#(
  parameter int pTAG_W  = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  itag    ,
  idat    ,
  //
  oval    ,
  otag    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk     ;
  input  logic                ireset   ;
  input  logic                iclkena  ;
  //
  input  logic                ival     ;
  input  logic [pTAG_W-1 : 0] itag     ;
  input  logic       [11 : 0] idat     ;
  //
  output logic                oval     ;
  output logic [pTAG_W-1 : 0] otag     ;
  output logic       [23 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "golay24_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                val;
  logic [pTAG_W-1 : 0] tag;
  logic       [23 : 0] dat;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      {oval, val} <= 2'b00;
    end
    else if (iclkena) begin
      {oval, val} <= {val, ival};
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dat   <= {get_syndrome({idat, 12'h0}), idat};
      tag   <= itag;
      //
      odat  <= dat;
      otag  <= tag;
    end
  end

endmodule
