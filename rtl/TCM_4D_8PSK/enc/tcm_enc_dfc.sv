/*






  logic          tcm_enc_dfc__iclk     ;
  logic          tcm_enc_dfc__ireset   ;
  logic          tcm_enc_dfc__iclkena  ;
  logic  [1 : 0] tcm_enc_dfc__icode    ;
  logic          tcm_enc_dfc__i1sps    ;
  logic          tcm_enc_dfc__isop     ;
  logic          tcm_enc_dfc__ieop     ;
  logic          tcm_enc_dfc__ival     ;
  logic [11 : 1] tcm_enc_dfc__idat     ;
  logic          tcm_enc_dfc__o1sps    ;
  logic          tcm_enc_dfc__osop     ;
  logic          tcm_enc_dfc__oeop     ;
  logic          tcm_enc_dfc__oval     ;
  logic [11 : 1] tcm_enc_dfc__odat     ;



  tcm_enc_dfc
  tcm_enc_dfc
  (
    .iclk    ( tcm_enc_dfc__iclk    ) ,
    .ireset  ( tcm_enc_dfc__ireset  ) ,
    .iclkena ( tcm_enc_dfc__iclkena ) ,
    .icode   ( tcm_enc_dfc__icode   ) ,
    .i1sps   ( tcm_enc_dfc__i1sps   ) ,
    .isop    ( tcm_enc_dfc__isop    ) ,
    .ieop    ( tcm_enc_dfc__ieop    ) ,
    .ival    ( tcm_enc_dfc__ival    ) ,
    .idat    ( tcm_enc_dfc__idat    ) ,
    .o1sps   ( tcm_enc_dfc__o1sps   ) ,
    .osop    ( tcm_enc_dfc__osop    ) ,
    .oeop    ( tcm_enc_dfc__oeop    ) ,
    .oval    ( tcm_enc_dfc__oval    ) ,
    .odat    ( tcm_enc_dfc__odat    )
  );


  assign tcm_enc_dfc__iclk    = '0 ;
  assign tcm_enc_dfc__ireset  = '0 ;
  assign tcm_enc_dfc__iclkena = '0 ;
  assign tcm_enc_dfc__icode   = '0 ;
  assign tcm_enc_dfc__i1sps   = '0 ;
  assign tcm_enc_dfc__isop    = '0 ;
  assign tcm_enc_dfc__ieop    = '0 ;
  assign tcm_enc_dfc__ival    = '0 ;
  assign tcm_enc_dfc__idat    = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_enc_dfc.v
// Description   : data word differential coder
//

module tcm_enc_dfc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
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
  input  logic  [1 : 0] icode    ;  // 0/1/2/3 - 2/2.25/2.5/2.75
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
  output logic [11 : 1] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [2 : 0] state;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval  <= 1'b0;
      o1sps <= 1'b0;
    end
    else if (iclkena) begin
      oval  <= ival & i1sps;
      o1sps <= i1sps;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & i1sps) begin
        osop <= isop;
        oeop <= ieop;
        odat <= idat;
        case (icode)
          2'b00 : {state,  odat[8], odat[5], odat[1]} <= encode({ idat[8], idat[5], idat[1]}, isop ? 3'h0 : state);
          2'b01 : {state,  odat[9], odat[6], odat[2]} <= encode({ idat[9], idat[6], idat[2]}, isop ? 3'h0 : state);
          2'b10 : {state, odat[10], odat[7], odat[3]} <= encode({idat[10], idat[7], idat[3]}, isop ? 3'h0 : state);
          2'b11 : {state, odat[11], odat[8], odat[4]} <= encode({idat[11], idat[8], idat[4]}, isop ? 3'h0 : state);
        endcase
      end
    end
  end

  function logic [5 : 0] encode (input logic [2 : 0] w, input logic [2 : 0] state);
    logic [2 : 0] x;
  begin
    x = w + state;
    encode = {x, x};
  end
  endfunction

endmodule
