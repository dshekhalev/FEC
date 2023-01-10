/*






  logic          tcm_enc_conv__iclk     ;
  logic          tcm_enc_conv__ireset   ;
  logic          tcm_enc_conv__iclkena  ;
  logic          tcm_enc_conv__i1sps    ;
  logic          tcm_enc_conv__isop     ;
  logic          tcm_enc_conv__ieop     ;
  logic          tcm_enc_conv__ival     ;
  logic [11 : 1] tcm_enc_conv__idat     ;
  logic          tcm_enc_conv__o1sps    ;
  logic          tcm_enc_conv__osop     ;
  logic          tcm_enc_conv__oeop     ;
  logic          tcm_enc_conv__oval     ;
  logic [11 : 0] tcm_enc_conv__odat     ;



  tcm_enc_conv
  tcm_enc_conv
  (
    .iclk    ( tcm_enc_conv__iclk    ) ,
    .ireset  ( tcm_enc_conv__ireset  ) ,
    .iclkena ( tcm_enc_conv__iclkena ) ,
    .i1sps   ( tcm_enc_conv__i1sps   ) ,
    .isop    ( tcm_enc_conv__isop    ) ,
    .ieop    ( tcm_enc_conv__ieop    ) ,
    .ival    ( tcm_enc_conv__ival    ) ,
    .idat    ( tcm_enc_conv__idat    ) ,
    .osop    ( tcm_enc_conv__osop    ) ,
    .oeop    ( tcm_enc_conv__oeop    ) ,
    .oval    ( tcm_enc_conv__oval    ) ,
    .odat    ( tcm_enc_conv__odat    )
  );


  assign tcm_enc_conv__iclk    = '0 ;
  assign tcm_enc_conv__ireset  = '0 ;
  assign tcm_enc_conv__iclkena = '0 ;
  assign tcm_enc_conv__i1sps   = '0 ;
  assign tcm_enc_conv__isop    = '0 ;
  assign tcm_enc_conv__ieop    = '0 ;
  assign tcm_enc_conv__ival    = '0 ;
  assign tcm_enc_conv__idat    = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_enc_conv.sv
// Description   : 3/4 convolution encoder
//

module tcm_enc_conv
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  i1sps   ,
  //
  isop    ,
  ieop    ,
  ival    ,
  idat    ,
  //
  o1sps   ,
  //
  osop    ,
  oeop    ,
  oval    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk     ;
  input  logic          ireset   ;
  input  logic          iclkena  ;
  //
  input  logic          i1sps    ;  // symbol frequency
  //
  input  logic          isop     ;
  input  logic          ieop     ;
  input  logic          ival     ;  // one 4D symbol for 4 8PSK symbols (!!!)
  input  logic [11 : 1] idat     ;
  //
  output logic          o1sps    ;
  //
  output logic          osop     ;
  output logic          oeop     ;
  output logic          oval     ;
  output logic [11 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [5 : 0] state;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign o1sps = i1sps;
  assign osop  = isop;
  assign oeop  = ieop;
  assign oval  = ival;

  assign odat[11 : 1] = idat[11 : 1];
  assign odat[0]      = isop ? 1'b0 : state[0];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= '0;
    end
    else if (iclkena) begin
      if (ival & i1sps) begin
        state <= encode(idat[3:1], isop ? 6'h0 : state);
      end
    end
  end

  function logic [5 : 0] encode (input logic [3 : 1] x, input logic [5 : 0] state);
    encode  = {state[0], state[5 : 2], state[1] ^ state[0]};
    encode ^= 6'b0_10100 & {6{x[3]}};
    encode ^= 6'b0_01010 & {6{x[2]}};
    encode ^= 6'b0_00011 & {6{x[1]}};
  endfunction

endmodule
