/*


  parameter int m      =   4 ;
  parameter int k_max  =   5 ;
  parameter int d      =   7 ;
  parameter int n      =  15 ;
  parameter int irrpol = 285 ;


  logic  bch_enc__iclk    ;
  logic  bch_enc__ireset  ;
  logic  bch_enc__iclkena ;
  //
  logic  bch_enc__isop    ;
  logic  bch_enc__ieop    ;
  logic  bch_enc__ieof    ;
  logic  bch_enc__ival    ;
  logic  bch_enc__idat    ;
  //
  logic  bch_enc__osop    ;
  logic  bch_enc__oval    ;
  logic  bch_enc__oeop    ;
  logic  bch_enc__odat    ;



  bch_enc_ext
  #(
    .m       ( m       ) ,
    .k_max   ( k_max   ) ,
    .d       ( d       ) ,
    .n       ( n       ) ,
    .irrpol  ( irrpol  )
  )
  bch_enc
  (
    .iclk    ( bch_enc__iclk    ) ,
    .ireset  ( bch_enc__ireset  ) ,
    .iclkena ( bch_enc__iclkena ) ,
    //
    .isop    ( bch_enc__isop    ) ,
    .ieop    ( bch_enc__ieop    ) ,
    .ieof    ( bch_enc__ieof    ) ,
    .ival    ( bch_enc__ival    ) ,
    .idat    ( bch_enc__idat    ) ,
    //
    .osop    ( bch_enc__osop    ) ,
    .oval    ( bch_enc__oval    ) ,
    .oeop    ( bch_enc__oeop    ) ,
    .odat    ( bch_enc__odat    )
  );


  assign bch_enc__iclk    = '0 ;
  assign bch_enc__ireset  = '0 ;
  assign bch_enc__iclkena = '0 ;
  assign bch_enc__isop    = '0 ;
  assign bch_enc__ieop    = '0 ;
  assign bch_enc__ieof    = '0 ;
  assign bch_enc__ival    = '0 ;
  assign bch_enc__idat    = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_enc_ext.sv
// Description   : extended bch encoder top module. last bit is even bit
//


module bch_enc_ext
(
  iclk   ,
  ireset ,
  iclkena,
  //
  isop   ,
  ieop   ,
  ieof   ,
  ival   ,
  idat   ,
  //
  osop   ,
  oeop   ,
  oval   ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk    ;
  input  logic  ireset  ;
  input  logic  iclkena ;
  //
  input  logic  isop    ; // start of payload/frame
  input  logic  ieop    ; // end of payload
  input  logic  ieof    ; // end of frame
  input  logic  ival    ; // valid of frame
  input  logic  idat    ; // frame data
  //
  output logic  osop    ; // start of packet
  output logic  oval    ; // valid of packer
  output logic  oeop    ; // end of packer
  output logic  odat    ; // packet data

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "bch_parameters.svh"
  `include "bch_functions.svh"

  typedef logic [gf_n_max-k_max-1 : 0] state_t;

  localparam state_t ZERO  = {gf_n_max-k_max{1'b0}};

  gpoly_t GPOLY;

  state_t state;
  state_t state_next;

  logic   dat2mult;
  logic   data_n_code;

  logic   even;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    rom_t ALPHA_TO  ;
    rom_t INDEX_OF  ;

    ALPHA_TO  = generate_gf_alpha_to_power(irrpol);
    INDEX_OF  = generate_gf_index_of_alpha(ALPHA_TO);

`ifdef __BCH_USING_GEN_POLY_TAB__
    GPOLY     = generate_pol_coeficients_tab (gf_n_max, k_max, d, INDEX_OF, ALPHA_TO);
`else
    GPOLY     = generate_pol_coeficients (gf_n_max, k_max, d, INDEX_OF, ALPHA_TO);
`endif
  end

  //------------------------------------------------------------------------------------------------------
  // BCH encoder is simple LFSR register
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      data_n_code <= 1'b1;
      state       <= ZERO;
      odat        <= 1'b0;
      oval        <= 1'b0;
      osop        <= 1'b0;
      oeop        <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
      osop <= isop;
      oeop <= ieof; // output end of packet is the input end of frame
      if (ival) begin
        // coding "FSM"
        if (isop) begin
          data_n_code <= 1'b1;
        end
        else if (ieop) begin
          data_n_code <= 1'b0;
        end
        // coding itself
        even  <=  isop ? idat : (even ^ (data_n_code ? idat : state[$high(state)]));
        odat  <= (isop | data_n_code) ? idat : (ieof ? even : state[$high(state)]);
        state <= state_next;
      end
    end
  end

  assign dat2mult = (isop | data_n_code) ? (idat ^ state[$high(state)]) : 1'b0;

  always_comb begin
    for (int i = 0; i < $size(state); i++) begin
      if (i == 0) begin
        state_next[i] = (GPOLY[i] & dat2mult);
      end
      else begin
        state_next[i] = (GPOLY[i] & dat2mult) ^ state[i-1];
      end
    end
  end

endmodule
