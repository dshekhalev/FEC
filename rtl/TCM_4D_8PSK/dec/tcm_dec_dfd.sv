/*






  logic          tcm_dec_dfd__iclk        ;
  logic          tcm_dec_dfd__ireset      ;
  logic          tcm_dec_dfd__iclkena     ;
  logic  [1 : 0] tcm_dec_dfd__icode       ;
  logic          tcm_dec_dfd__isop        ;
  logic          tcm_dec_dfd__ival        ;
  logic          tcm_dec_dfd__ieop        ;
  logic  [2 : 0] tcm_dec_dfd__isymb   [4] ;
  logic          tcm_dec_dfd__osop        ;
  logic          tcm_dec_dfd__oval        ;
  logic          tcm_dec_dfd__oeop        ;
  logic [10 : 0] tcm_dec_dfd__odat        ;



  tcm_dec_dfd
  tcm_dec_dfd
  (
    .iclk    ( tcm_dec_dfd__iclk    ) ,
    .ireset  ( tcm_dec_dfd__ireset  ) ,
    .iclkena ( tcm_dec_dfd__iclkena ) ,
    .icode   ( tcm_dec_dfd__icode   ) ,
    .isop    ( tcm_dec_dfd__isop    ) ,
    .ival    ( tcm_dec_dfd__ival    ) ,
    .ieop    ( tcm_dec_dfd__ieop    ) ,
    .isymb   ( tcm_dec_dfd__isymb   ) ,
    .osop    ( tcm_dec_dfd__osop    ) ,
    .oval    ( tcm_dec_dfd__oval    ) ,
    .oeop    ( tcm_dec_dfd__oeop    ) ,
    .odat    ( tcm_dec_dfd__odat    )
  );


  assign tcm_dec_dfd__iclk    = '0 ;
  assign tcm_dec_dfd__ireset  = '0 ;
  assign tcm_dec_dfd__iclkena = '0 ;
  assign tcm_dec_dfd__icode   = '0 ;
  assign tcm_dec_dfd__isop    = '0 ;
  assign tcm_dec_dfd__ival    = '0 ;
  assign tcm_dec_dfd__ieop    = '0 ;
  assign tcm_dec_dfd__isymb   = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_dfd.sv
// Description   : 4D symbol differential decoder
//

module tcm_dec_dfd
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  isop    ,
  ival    ,
  ieop    ,
  isymb   ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk        ;
  input  logic          ireset      ;
  input  logic          iclkena     ;
  //
  input  logic  [1 : 0] icode       ; // 0/1/2/3 - 2/2.25/2.5/2.75
  //
  input  logic          isop        ;
  input  logic          ival        ;
  input  logic          ieop        ;
  input  logic  [2 : 0] isymb   [4] ;
  //
  output logic          osop        ;
  output logic          oval        ;
  output logic          oeop        ;
  output logic [10 : 0] odat        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [2 : 0] symb_t;

  symb_t state;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= isop & ival;
      oeop <= ieop & ival;
      if (ival) begin
        case (icode)
          2'h0    : {state, odat} <= decode_200(isymb, isop ? 3'h0 : state);
          2'h1    : {state, odat} <= decode_225(isymb, isop ? 3'h0 : state);
          2'h2    : {state, odat} <= decode_250(isymb, isop ? 3'h0 : state);
          default : {state, odat} <= decode_275(isymb, isop ? 3'h0 : state);
        endcase
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // symbol decode functions
  //------------------------------------------------------------------------------------------------------

  function automatic logic [13 : 0] decode_200 (input symb_t symbol [4], symb_t state);
    symb_t tmp_symbol_Z1;
    symb_t tmp_symbol_Z2;
    symb_t tmp_symbol_Z3;
    logic [11 : 0] dx;
    logic  [2 : 0] nstate;
  begin
    // Z0
    dx[8]  = symbol[0][2];
    dx[5]  = symbol[0][1];
    dx[1]  = symbol[0][0];
    // Z1
    tmp_symbol_Z1 = symbol[1] - symbol[0];
    dx[7]  = tmp_symbol_Z1[2];
    dx[3]  = tmp_symbol_Z1[1];
    // Z2
    tmp_symbol_Z2 = symbol[2] - symbol[0];
    dx[6]  = tmp_symbol_Z2[2];
    dx[2]  = tmp_symbol_Z2[1];
    //Z3
    tmp_symbol_Z3 = symbol[3] - symbol[0] - tmp_symbol_Z1 - tmp_symbol_Z2;
    dx[4]  = tmp_symbol_Z3[2];
    dx[0]  = tmp_symbol_Z3[1];
    //
    nstate = {dx[8], dx[5], dx[1]};
    {dx[8], dx[5], dx[1]} = {dx[8], dx[5], dx[1]} - state;
    //
    decode_200 = {nstate, 3'b0, dx[8 : 1]};
  end
  endfunction

  function automatic logic [13 : 0] decode_225 (input symb_t symbol [4], symb_t state);
    symb_t tmp_symbol_Z1;
    symb_t tmp_symbol_Z2;
    symb_t tmp_symbol_Z3;
    logic [11 : 0] dx;
    logic  [2 : 0] nstate;
  begin
    // Z0
    dx[9]  = symbol[0][2];
    dx[6]  = symbol[0][1];
    dx[2]  = symbol[0][0];
    // Z1
    tmp_symbol_Z1 = symbol[1] - symbol[0];
    dx[8]  = tmp_symbol_Z1[2];
    dx[4]  = tmp_symbol_Z1[1];
    dx[0]  = tmp_symbol_Z1[0];
    // Z2
    tmp_symbol_Z2 = symbol[2] - symbol[0];
    dx[7]  = tmp_symbol_Z2[2];
    dx[3]  = tmp_symbol_Z2[1];
    //Z3
    tmp_symbol_Z3 = symbol[3] - symbol[0] - tmp_symbol_Z1 - tmp_symbol_Z2;
    dx[5]  = tmp_symbol_Z3[2];
    dx[1]  = tmp_symbol_Z3[1];
    //
    nstate = {dx[9], dx[6], dx[2]};
    {dx[9], dx[6], dx[2]} = {dx[9], dx[6], dx[2]} - state;
    //
    decode_225 = {nstate, 2'b0, dx[9 : 1]};
  end
  endfunction

  function automatic logic [13 : 0] decode_250 (input symb_t symbol [4], symb_t state);
    symb_t tmp_symbol_Z1;
    symb_t tmp_symbol_Z2;
    symb_t tmp_symbol_Z3;
    logic [11 : 0] dx;
    logic  [2 : 0] nstate;
  begin
    // Z0
    dx[10] = symbol[0][2];
    dx[7]  = symbol[0][1];
    dx[3]  = symbol[0][0];
    // Z1
    tmp_symbol_Z1 = symbol[1] - symbol[0];
    dx[9]  = tmp_symbol_Z1[2];
    dx[5]  = tmp_symbol_Z1[1];
    dx[1]  = tmp_symbol_Z1[0];
    // Z2
    tmp_symbol_Z2 = symbol[2] - symbol[0];
    dx[8]  = tmp_symbol_Z2[2];
    dx[4]  = tmp_symbol_Z2[1];
    dx[0]  = tmp_symbol_Z2[0];
    //Z3
    tmp_symbol_Z3 = symbol[3] - symbol[0] - tmp_symbol_Z1 - tmp_symbol_Z2;
    dx[6]  = tmp_symbol_Z3[2];
    dx[2]  = tmp_symbol_Z3[1];
    //
    nstate = {dx[10], dx[7], dx[3]};
    {dx[10], dx[7], dx[3]} = {dx[10], dx[7], dx[3]} - state;

    decode_250 = {nstate, 1'b0, dx[10 : 1]};
  end
  endfunction

  function automatic logic [13 : 0] decode_275 (input symb_t symbol [4], symb_t state);
    symb_t tmp_symbol_Z1;
    symb_t tmp_symbol_Z2;
    symb_t tmp_symbol_Z3;
    logic [11 : 0] dx;
    logic  [2 : 0] nstate;
  begin
    // Z0
    dx[11] = symbol[0][2];
    dx[8]  = symbol[0][1];
    dx[4]  = symbol[0][0];
    // Z1
    tmp_symbol_Z1 = symbol[1] - symbol[0];
    dx[10] = tmp_symbol_Z1[2];
    dx[6]  = tmp_symbol_Z1[1];
    dx[2]  = tmp_symbol_Z1[0];
    // Z2
    tmp_symbol_Z2 = symbol[2] - symbol[0];
    dx[9]  = tmp_symbol_Z2[2];
    dx[5]  = tmp_symbol_Z2[1];
    dx[1]  = tmp_symbol_Z2[0];
    //Z3
    tmp_symbol_Z3 = symbol[3] - symbol[0] - tmp_symbol_Z1 - tmp_symbol_Z2;
    dx[7]  = tmp_symbol_Z3[2];
    dx[3]  = tmp_symbol_Z3[1];
    dx[0]  = tmp_symbol_Z3[0];
    //
    nstate = {dx[11], dx[8], dx[4]};
    {dx[11], dx[8], dx[4]} = {dx[11], dx[8], dx[4]} - state;
    //
    decode_275 = {nstate, dx[11 : 1]};
  end
  endfunction

endmodule
