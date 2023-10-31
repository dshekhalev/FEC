/*






  logic           btc_enc_col_code__iclk    ;
  logic           btc_enc_col_code__ireset  ;
  logic           btc_enc_col_code__iclkena ;
  //
  btc_code_mode_t btc_enc_col_code__imode   ;
  //
  logic           btc_enc_col_code__isop    ;
  logic           btc_enc_col_code__ieop    ;
  logic           btc_enc_col_code__ieof    ;
  logic           btc_enc_col_code__ival    ;
  logic           btc_enc_col_code__idat    ;
  //
  logic           btc_enc_col_code__osop    ;
  logic           btc_enc_col_code__oeop    ;
  logic           btc_enc_col_code__oval    ;
  logic           btc_enc_col_code__odat    ;



  btc_enc_col_code
  btc_enc_col_code
  (
    .iclk    ( btc_enc_col_code__iclk    ) ,
    .ireset  ( btc_enc_col_code__ireset  ) ,
    .iclkena ( btc_enc_col_code__iclkena ) ,
    //
    .imode   ( btc_enc_col_code__imode   ) ,
    //
    .isop    ( btc_enc_col_code__isop    ) ,
    .ieop    ( btc_enc_col_code__ieop    ) ,
    .ieof    ( btc_enc_col_code__ieof    ) ,
    .ival    ( btc_enc_col_code__ival    ) ,
    .idat    ( btc_enc_col_code__idat    ) ,
    //
    .osop    ( btc_enc_col_code__osop    ) ,
    .oeop    ( btc_enc_col_code__oeop    ) ,
    .oval    ( btc_enc_col_code__oval    ) ,
    .odat    ( btc_enc_col_code__odat    )
  );


  assign btc_enc_col_code__iclk    = '0 ;
  assign btc_enc_col_code__ireset  = '0 ;
  assign btc_enc_col_code__iclkena = '0 ;
  assign btc_enc_col_code__imode   = '0 ;
  assign btc_enc_col_code__isop    = '0 ;
  assign btc_enc_col_code__ieop    = '0 ;
  assign btc_enc_col_code__ieof    = '0 ;
  assign btc_enc_col_code__ival    = '0 ;
  assign btc_enc_col_code__idat    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_enc_col_code.sv
// Description   : BTC column bit serial SPC/extended Hamming encoder
//

module btc_enc_col_code
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  imode   ,
  //
  isop    ,
  ieop    ,
  ieof    ,
  ival    ,
  idat    ,
  //
  osop    ,
  oeop    ,
  oval    ,
  odat
);

  `include "../btc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk    ;
  input  logic           ireset  ;
  input  logic           iclkena ;
  //
  input  btc_code_mode_t imode   ;
  //
  input  logic           isop    ;
  input  logic           ieop    ;
  input  logic           ieof    ;
  input  logic           ival    ;
  input  logic           idat    ;
  //
  output logic           osop    ;
  output logic           oeop    ;
  output logic           oval    ;
  output logic           odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic   even;
  state_t state;

  state_t used_poly;
  logic   used_state_msb;

  logic   data_n_code;

  //------------------------------------------------------------------------------------------------------
  // encoding
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    used_poly       = cPRIM_POLY_8;
    used_state_msb  = state[2];
    //
    case (imode.size)
      cBSIZE_8  : begin used_poly = cPRIM_POLY_8;  used_state_msb = state[2]; end
      cBSIZE_16 : begin used_poly = cPRIM_POLY_16; used_state_msb = state[3]; end
      cBSIZE_32 : begin used_poly = cPRIM_POLY_32; used_state_msb = state[4]; end
      cBSIZE_64 : begin used_poly = cPRIM_POLY_64; used_state_msb = state[5]; end
    endcase
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // FSM
      if (ival) begin
        if (isop) begin
          data_n_code <= 1'b1;
        end
        else if (ieop) begin
          data_n_code <= 1'b0;
        end
      end
      //
      if (ival) begin
        if (isop) begin
          // spc
          even  <= idat;
          // hamming
          state <= {8{idat}} & used_poly;
        end
        else if (data_n_code) begin
          // spc
          even  <= even ^ idat;
          // hamming
          state <= (state << 1) ^ ({8{idat ^ used_state_msb}} & used_poly);
        end
        else begin
          // extended hamming
          even  <= even ^ used_state_msb;
          state <= (state << 1);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
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
      osop <=  ival & isop;
      oeop <=  ival & ieof;
      odat <= (isop | data_n_code) ? idat : (ieof ? even : used_state_msb);
    end
  end

endmodule
