/*


  parameter int pTAG_W = 3;




  logic                rsc2_enc_conv_engine__iclk     ;
  logic                rsc2_enc_conv_engine__ireset   ;
  logic                rsc2_enc_conv_engine__iclkena  ;
  logic                rsc2_enc_conv_engine__iclear   ;
  logic                rsc2_enc_conv_engine__iload    ;
  logic        [3 : 0] rsc2_enc_conv_engine__istate   ;
  logic                rsc2_enc_conv_engine__isop     ;
  logic                rsc2_enc_conv_engine__ival     ;
  logic                rsc2_enc_conv_engine__ieop     ;
  logic        [1 : 0] rsc2_enc_conv_engine__idat     ;
  logic [pTAG_W-1 : 0] rsc2_enc_conv_engine__itag     ;
  logic                rsc2_enc_conv_engine__osop     ;
  logic                rsc2_enc_conv_engine__oval     ;
  logic                rsc2_enc_conv_engine__oeop     ;
  logic        [1 : 0] rsc2_enc_conv_engine__odat     ;
  logic                rsc2_enc_conv_engine__odaty    ;
  logic                rsc2_enc_conv_engine__odatw    ;
  logic [pTAG_W-1 : 0] rsc2_enc_conv_engine__otag     ;
  logic        [3 : 0] rsc2_enc_conv_engine__ostate   ;



  c
  #(
    .pTAG_W ( pTAG_W )
  )
  rsc2_enc_conv_engine
  (
    .iclk    ( rsc2_enc_conv_engine__iclk    ) ,
    .ireset  ( rsc2_enc_conv_engine__ireset  ) ,
    .iclkena ( rsc2_enc_conv_engine__iclkena ) ,
    .iclear  ( rsc2_enc_conv_engine__iclear  ) ,
    .iload   ( rsc2_enc_conv_engine__iload   ) ,
    .istate  ( rsc2_enc_conv_engine__istate  ) ,
    .isop    ( rsc2_enc_conv_engine__isop    ) ,
    .ival    ( rsc2_enc_conv_engine__ival    ) ,
    .ieop    ( rsc2_enc_conv_engine__ieop    ) ,
    .idat    ( rsc2_enc_conv_engine__idat    ) ,
    .itag    ( rsc2_enc_conv_engine__itag    ) ,
    .osop    ( rsc2_enc_conv_engine__osop    ) ,
    .oval    ( rsc2_enc_conv_engine__oval    ) ,
    .oeop    ( rsc2_enc_conv_engine__oeop    ) ,
    .odat    ( rsc2_enc_conv_engine__odat    ) ,
    .odaty   ( rsc2_enc_conv_engine__odaty   ) ,
    .odatw   ( rsc2_enc_conv_engine__odatw   ) ,
    .otag    ( rsc2_enc_conv_engine__otag    ) ,
    .ostate  ( rsc2_enc_conv_engine__ostate  )
  );


  assign rsc2_enc_conv_engine__iclk    = '0 ;
  assign rsc2_enc_conv_engine__ireset  = '0 ;
  assign rsc2_enc_conv_engine__iclkena = '0 ;
  assign rsc2_enc_conv_engine__iclear  = '0 ;
  assign rsc2_enc_conv_engine__iload   = '0 ;
  assign rsc2_enc_conv_engine__istate  = '0 ;
  assign rsc2_enc_conv_engine__isop    = '0 ;
  assign rsc2_enc_conv_engine__ival    = '0 ;
  assign rsc2_enc_conv_engine__ieop    = '0 ;
  assign rsc2_enc_conv_engine__idat    = '0 ;
  assign rsc2_enc_conv_engine__itag    = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_enc_conv_engine.sv
// Description   : rsc2 convolution engine
//

module rsc2_enc_conv_engine
#(
  parameter int pTAG_W = 3
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iclear  ,
  iload   ,
  istate  ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat    ,
  itag    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  odaty   ,
  odatw   ,
  otag    ,
  //
  ostate
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                iclear  ;
  input  logic                iload   ;
  input  logic        [3 : 0] istate  ;
  //
  input  logic                isop    ;
  input  logic                ival    ;
  input  logic                ieop    ;
  input  logic        [1 : 0] idat    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  //
  output logic                osop    ;
  output logic                oval    ;
  output logic                oeop    ;
  output logic        [1 : 0] odat    ;
  output logic                odaty   ;
  output logic                odatw   ;
  output logic [pTAG_W-1 : 0] otag    ;
  //
  output logic        [3 : 0] ostate  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [3 : 0] state;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osop  <= 1'b0;
      oval  <= 1'b0;
      oeop  <= 1'b0;
    end
    else if (iclkena) begin
      osop <= ival & isop;
      oval <= ival;
      oeop <= ival & ieop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        otag <= itag;
        odat <= idat;
        {odaty, odatw, state} <= do_encode(idat[1], idat[0], state);
      end
      //
      if (iclear)
        state <= '0;
      else if (iload)
        state <= istate;
    end
  end

  assign ostate = state;

  function logic [5 : 0] do_encode (input logic a, b, input logic [3 : 0] state);
    logic [3 : 0] nstate;
    logic         y, w;
  begin
    nstate = {a ^ state[0] ^ state[1], state[3:1]}; // feedback poly [1 0 0 1 1]
    nstate = nstate ^ {b, b, 1'b0, b};

    y = nstate[3] ^ state[3] ^ state[2] ^            state[0]; // poly [1 1 1 0 1]
    w = nstate[3] ^            state[2] ^ state[1] ^ state[0]; // poly [1 0 1 1 1]

    do_encode = {y, w, nstate};
  end
  endfunction

endmodule
