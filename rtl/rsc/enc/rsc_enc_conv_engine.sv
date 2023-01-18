/*


  parameter int pTAG_W = 3;




  logic                rsc_enc_conv_engine__iclk     ;
  logic                rsc_enc_conv_engine__ireset   ;
  logic                rsc_enc_conv_engine__iclkena  ;
  logic                rsc_enc_conv_engine__iclear   ;
  logic                rsc_enc_conv_engine__iload    ;
  logic        [2 : 0] rsc_enc_conv_engine__istate   ;
  logic                rsc_enc_conv_engine__isop     ;
  logic                rsc_enc_conv_engine__ival     ;
  logic                rsc_enc_conv_engine__ieop     ;
  logic        [1 : 0] rsc_enc_conv_engine__idat     ;
  logic [pTAG_W-1 : 0] rsc_enc_conv_engine__itag     ;
  logic                rsc_enc_conv_engine__osop     ;
  logic                rsc_enc_conv_engine__oval     ;
  logic                rsc_enc_conv_engine__oeop     ;
  logic        [1 : 0] rsc_enc_conv_engine__odat     ;
  logic                rsc_enc_conv_engine__odaty    ;
  logic                rsc_enc_conv_engine__odatw    ;
  logic [pTAG_W-1 : 0] rsc_enc_conv_engine__otag     ;
  logic        [2 : 0] rsc_enc_conv_engine__ostate   ;



  rsc_enc_conv_engine
  #(
    .pTAG_W ( pTAG_W )
  )
  rsc_enc_conv_engine
  (
    .iclk    ( rsc_enc_conv_engine__iclk    ) ,
    .ireset  ( rsc_enc_conv_engine__ireset  ) ,
    .iclkena ( rsc_enc_conv_engine__iclkena ) ,
    .iclear  ( rsc_enc_conv_engine__iclear  ) ,
    .iload   ( rsc_enc_conv_engine__iload   ) ,
    .istate  ( rsc_enc_conv_engine__istate  ) ,
    .isop    ( rsc_enc_conv_engine__isop    ) ,
    .ival    ( rsc_enc_conv_engine__ival    ) ,
    .ieop    ( rsc_enc_conv_engine__ieop    ) ,
    .idat    ( rsc_enc_conv_engine__idat    ) ,
    .itag    ( rsc_enc_conv_engine__itag    ) ,
    .osop    ( rsc_enc_conv_engine__osop    ) ,
    .oval    ( rsc_enc_conv_engine__oval    ) ,
    .oeop    ( rsc_enc_conv_engine__oeop    ) ,
    .odat    ( rsc_enc_conv_engine__odat    ) ,
    .odaty   ( rsc_enc_conv_engine__odaty   ) ,
    .odatw   ( rsc_enc_conv_engine__odatw   ) ,
    .otag    ( rsc_enc_conv_engine__otag    ) ,
    .ostate  ( rsc_enc_conv_engine__ostate  )
  );


  assign rsc_enc_conv_engine__iclk    = '0 ;
  assign rsc_enc_conv_engine__ireset  = '0 ;
  assign rsc_enc_conv_engine__iclkena = '0 ;
  assign rsc_enc_conv_engine__iclear  = '0 ;
  assign rsc_enc_conv_engine__iload   = '0 ;
  assign rsc_enc_conv_engine__istate  = '0 ;
  assign rsc_enc_conv_engine__isop    = '0 ;
  assign rsc_enc_conv_engine__ival    = '0 ;
  assign rsc_enc_conv_engine__ieop    = '0 ;
  assign rsc_enc_conv_engine__idat    = '0 ;
  assign rsc_enc_conv_engine__itag    = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_enc_conv_engine.sv
// Description   : rsc convolution engine
//

module rsc_enc_conv_engine
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
  input  logic        [2 : 0] istate  ;
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
  output logic        [2 : 0] ostate  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [2 : 0] state;

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
      if (iclear) begin
        state <= '0;
      end
      else if (iload) begin
        state <= istate;
      end
    end
  end

  assign ostate = state;

  function logic [4 : 0] do_encode (input logic a, b, input logic [2 : 0] state);
    logic [2 : 0] nstate;
    logic         y, w;
  begin
    nstate = {a ^ state[2] ^ state[0], state[2:1]}; // feedback poly [1 1 0 1]
    nstate = nstate ^ {3{b}};

    y = nstate[2] ^ state[1] ^ state[0]; // poly [1 0 1 1]
    w = nstate[2] ^            state[0]; // poly [1 0 0 1]

    do_encode = {y, w, nstate};
  end
  endfunction

endmodule
