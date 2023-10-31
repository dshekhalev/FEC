/*






  logic                   btc_enc_row_code__iclk    ;
  logic                   btc_enc_row_code__ireset  ;
  logic                   btc_enc_row_code__iclkena ;
  //
  btc_code_mode_t         btc_enc_row_code__imode   ;
  //
  logic                   btc_enc_row_code__isop    ;
  logic                   btc_enc_row_code__ieop    ;
  logic                   btc_enc_row_code__ival    ;
  logic           [7 : 0] btc_enc_row_code__idat    ;
  //
  logic                   btc_enc_row_code__osop    ;
  logic                   btc_enc_row_code__oeop    ;
  logic                   btc_enc_row_code__oval    ;
  logic           [7 : 0] btc_enc_row_code__odat    ;



  btc_enc_row_code
  btc_enc_row_code
  (
    .iclk    ( btc_enc_row_code__iclk    ) ,
    .ireset  ( btc_enc_row_code__ireset  ) ,
    .iclkena ( btc_enc_row_code__iclkena ) ,
    //
    .imode   ( btc_enc_row_code__imode   ) ,
    //
    .isop    ( btc_enc_row_code__isop    ) ,
    .ieop    ( btc_enc_row_code__ieop    ) ,
    .ival    ( btc_enc_row_code__ival    ) ,
    .idat    ( btc_enc_row_code__idat    ) ,
    //
    .osop    ( btc_enc_row_code__osop    ) ,
    .oeop    ( btc_enc_row_code__oeop    ) ,
    .oval    ( btc_enc_row_code__oval    ) ,
    .odat    ( btc_enc_row_code__odat    )
  );


  assign btc_enc_row_code__iclk    = '0 ;
  assign btc_enc_row_code__ireset  = '0 ;
  assign btc_enc_row_code__iclkena = '0 ;
  assign btc_enc_row_code__imode   = '0 ;
  assign btc_enc_row_code__isop    = '0 ;
  assign btc_enc_row_code__ieop    = '0 ;
  assign btc_enc_row_code__ival    = '0 ;
  assign btc_enc_row_code__idat    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_enc_row_code.sv
// Description   : BTC row byte serial SPC/extended Hamming encoder
//

module btc_enc_row_code
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  imode   ,
  //
  isop    ,
  ieop    ,
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

  input  logic                   iclk    ;
  input  logic                   ireset  ;
  input  logic                   iclkena ;
  //
  input  btc_code_mode_t         imode   ;
  //
  input  logic                   isop    ;
  input  logic                   ieop    ;
  input  logic                   ival    ;
  input  logic           [7 : 0] idat    ;
  //
  output logic                   osop    ;
  output logic                   oeop    ;
  output logic                   oval    ;
  output logic           [7 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [7 : 0] data_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic   even;

  state_t state;
  state_t state_8;
  state_t state_16;
  state_t state_32;
  state_t state_64;

  //------------------------------------------------------------------------------------------------------
  // encoding by 8 bit
  //------------------------------------------------------------------------------------------------------

  //
  // different modes last word decoding
  always_comb begin
    // eham {8, 4}
    state_8   = do_ham_encode(idat,       4,      0,  cPRIM_POLY_8,   3);
    // eham {16, 11}
    state_16  = do_ham_encode(idat, (11 % 8), state,  cPRIM_POLY_16,  4);
    // eham {32, 26}
    state_32  = do_ham_encode(idat, (26 % 8), state,  cPRIM_POLY_32,  5);
    // eham {64, 57}
    state_64  = do_ham_encode(idat, (57 % 8), state,  cPRIM_POLY_64,  6);
  end

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
      osop <= isop;
      oeop <= ieop;
      odat <= idat;
      //
      if (ival) begin
        even <= (isop ? 1'b0 : even) ^ (^idat);
      end
      //
      if (imode.code_type == cSPC_CODE) begin
        if (ieop) begin // 8bit isop == 1 & ieop == 1 all time
          odat[7] <= ((imode.size != cBSIZE_8) & even) ^ (^idat[6 : 0]);
        end
      end
      else begin
        //
        case (imode.size)
          cBSIZE_8 : begin
            if (ieop) begin  // 8bit isop == 1 & ieop == 1 all time
              for (int i = 2; i >= 0; i--) begin
                odat[6-i] <=   state_8[i];
              end
              odat[7]     <= (^state_8[2 : 0]) ^ (^idat[3 : 0]);
            end
          end
          cBSIZE_16 : begin
            if (ieop) begin
              for (int i = 3; i >= 0; i--) begin
                odat[6-i] <=          state_16[i];
              end
              odat[7]     <= even ^ (^state_16[3 : 0]) ^ (^idat[2 : 0]);
            end
            if (ival) begin
              state <= do_ham_encode(idat, 8, isop ? 0 : state,  cPRIM_POLY_16,  4);
            end
          end
          cBSIZE_32 : begin
            if (ieop) begin
              for (int i = 4; i >= 0; i--) begin
                odat[6-i] <=          state_32[i];
              end
              odat[7]     <= even ^ (^state_32[4 : 0]) ^ (^idat[1 : 0]);
            end
            if (ival) begin
              state <= do_ham_encode(idat, 8, isop ? 0 : state,  cPRIM_POLY_32,  5);
            end
          end
          cBSIZE_64 : begin
            if (ieop) begin
              for (int i = 5; i >= 0; i--) begin
                odat[6-i] <=          state_64[i];
              end
              odat[7]     <= even ^ (^state_64[5 : 0]) ^ (^idat[0 : 0]);
            end
            if (ival) begin
              state <= do_ham_encode(idat, 8, isop ? 0 : state,  cPRIM_POLY_64,  6);
            end
          end
        endcase
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // encoding functions
  //------------------------------------------------------------------------------------------------------

  function automatic state_t do_ham_encode (input data_t data, int dbitnum, state_t state, poly, int m);
    state_t tstate;
  begin
    tstate = state;
    for (int i = 0; i < dbitnum; i++) begin
      tstate = do_ham_bit_encode(data[i], tstate, poly, m);
    end
    do_ham_encode = tstate;
  end
  endfunction

  function automatic state_t do_ham_bit_encode (input bit data, state_t state, poly, int m);
    bit msb;
  begin
    msb = data ^ state[m-1];
    do_ham_bit_encode = (state << 1) ^ ({$bits(state){msb}} & poly);
  end
  endfunction

endmodule
