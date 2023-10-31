/*



  parameter int pDAT_W   = 4 ;
  parameter int pDEC_NUM = 8 ;



  logic                 btc_dec_comp_code_asm__iclk               ;
  logic                 btc_dec_comp_code_asm__ireset             ;
  logic                 btc_dec_comp_code_asm__iclkena            ;
  //
  logic                 btc_dec_comp_code_asm__ival               ;
  strb_t                btc_dec_comp_code_asm__istrb              ;
  logic  [pDAT_W-1 : 0] btc_dec_comp_code_asm__idat               ;
  //
  logic                 btc_dec_comp_code_asm__oval               ;
  strb_t                btc_dec_comp_code_asm__ostrb              ;
  logic  [pDAT_W-1 : 0] btc_dec_comp_code_asm__odat    [pDEC_NUM] ;



  btc_dec_comp_code_asm
  #(
    .pDAT_W   ( pDAT_W   ) ,
    .pDEC_NUM ( pDEC_NUM )
  )
  btc_dec_comp_code_asm
  (
    .iclk    ( btc_dec_comp_code_asm__iclk    ) ,
    .ireset  ( btc_dec_comp_code_asm__ireset  ) ,
    .iclkena ( btc_dec_comp_code_asm__iclkena ) ,
    //
    .ival    ( btc_dec_comp_code_asm__ival    ) ,
    .istrb   ( btc_dec_comp_code_asm__istrb   ) ,
    .idat    ( btc_dec_comp_code_asm__idat    ) ,
    //
    .oval    ( btc_dec_comp_code_asm__oval    ) ,
    .ostrb   ( btc_dec_comp_code_asm__ostrb   ) ,
    .odat    ( btc_dec_comp_code_asm__odat    )
  );


  assign btc_dec_comp_code_asm__iclk    = '0 ;
  assign btc_dec_comp_code_asm__ireset  = '0 ;
  assign btc_dec_comp_code_asm__iclkena = '0 ;
  assign btc_dec_comp_code_asm__ival    = '0 ;
  assign btc_dec_comp_code_asm__istrb   = '0 ;
  assign btc_dec_comp_code_asm__idat    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code_asm.sv
// Description   : component code assembler unit for row mode
//                 get pDEC_NUM vector from serial stream
//

module btc_dec_comp_code_asm
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  istrb   ,
  idat    ,
  //
  oval    ,
  ostrb   ,
  odat
);

  parameter int pDAT_W   = 4 ;
  parameter int pDEC_NUM = 8 ;

  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk               ;
  input  logic                 ireset             ;
  input  logic                 iclkena            ;
  //
  input  logic                 ival               ;
  input  strb_t                istrb              ;
  input  logic  [pDAT_W-1 : 0] idat               ;
  //
  output logic                 oval               ;
  output strb_t                ostrb              ;
  output logic  [pDAT_W-1 : 0] odat    [pDEC_NUM] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DEC_NUM = $clog2(pDEC_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  struct packed {
    logic                       zero;
    logic                       done;
    logic [cLOG2_DEC_NUM-1 : 0] value;
  } cnt;

  //------------------------------------------------------------------------------------------------------
  // data is LSB first
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival & !istrb.sop & (cnt.value == pDEC_NUM-1);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (istrb.sop) begin
          cnt <= 1'b1;  // look ahead
        end
        else begin
          cnt.value <=  cnt.done ? '0 : (cnt.value + 1'b1);
          cnt.done  <= (cnt.value == pDEC_NUM-2);
          cnt.zero  <=  cnt.done;
        end
        //
        ostrb <= (istrb.sop | cnt.zero) ? istrb : (ostrb | istrb);
        //
        odat[pDEC_NUM-1] <= idat;
        for (int i = 0; i < pDEC_NUM-1; i++) begin
          odat[i] <= odat[i+1];
        end
      end
    end
  end

endmodule
