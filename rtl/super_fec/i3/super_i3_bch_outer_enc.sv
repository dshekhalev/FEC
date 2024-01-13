/*






  logic          super_i3_bch_outer_enc__iclk    ;
  logic          super_i3_bch_outer_enc__ireset  ;
  logic          super_i3_bch_outer_enc__iclkena ;
  //
  logic          super_i3_bch_outer_enc__ival    ;
  logic          super_i3_bch_outer_enc__isop    ;
  logic [15 : 0] super_i3_bch_outer_enc__idat    ;
  //
  logic          super_i3_bch_outer_enc__oval    ;
  logic          super_i3_bch_outer_enc__osop    ;
  logic          super_i3_bch_outer_enc__oeop    ;
  logic [15 : 0] super_i3_bch_outer_enc__odat    ;



  super_i3_bch_outer_enc
  super_i3_bch_outer_enc
  (
    .iclk    ( super_i3_bch_outer_enc__iclk    ) ,
    .ireset  ( super_i3_bch_outer_enc__ireset  ) ,
    .iclkena ( super_i3_bch_outer_enc__iclkena ) ,
    //
    .ival    ( super_i3_bch_outer_enc__ival    ) ,
    .isop    ( super_i3_bch_outer_enc__isop    ) ,
    .idat    ( super_i3_bch_outer_enc__idat    ) ,
    //
    .oval    ( super_i3_bch_outer_enc__oval    ) ,
    .osop    ( super_i3_bch_outer_enc__osop    ) ,
    .oeop    ( super_i3_bch_outer_enc__oeop    ) ,
    .odat    ( super_i3_bch_outer_enc__odat    )
  );


  assign super_i3_bch_outer_enc__iclk    = '0 ;
  assign super_i3_bch_outer_enc__ireset  = '0 ;
  assign super_i3_bch_outer_enc__iclkena = '0 ;
  assign super_i3_bch_outer_enc__ival    = '0 ;
  assign super_i3_bch_outer_enc__isop    = '0 ;
  assign super_i3_bch_outer_enc__idat    = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_bch_outer_enc.sv
// Description   : I.3 outer BCH(3860,3824) encoder with 16 bit data interface
//

module super_i3_bch_outer_enc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  idat    ,
  //
  oval    ,
  osop    ,
  oeop    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk    ;
  input  logic          ireset  ;
  input  logic          iclkena ;
  //
  input  logic          ival    ;
  input  logic          isop    ;
  input  logic [15 : 0] idat    ;
  //
  output logic          oval    ;
  output logic          osop    ;
  output logic          oeop    ;
  output logic [15 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W         = 16;
  localparam int cMAX_GENPOLY_W = 37;

  typedef logic         [cDAT_W-1 : 0] dat_t;
  typedef logic [cMAX_GENPOLY_W-2 : 0] state_t; // - 1 bit
  typedef logic [cMAX_GENPOLY_W-1 : 0] gpoly_t;

  localparam int     cEOP_EDGE  = 3824/16;      // 239 words
  localparam int     cEOF_EDGE  = 3860/16 + 1;  // 241.25 words (+36 pbits  = 2.25 pbits)

  localparam gpoly_t cGPOLY     = 37'h104ACC7845;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  state_t       GPOLY;

  state_t       state;
  state_t       state_next;

  logic         dat2mult;
  logic         data_n_code;

  logic [7 : 0] cnt;
  logic         eop;
  logic         eof;

  //------------------------------------------------------------------------------------------------------
  // shift genpoly is reverse order (!!!!) because msb must use for coding and we do shift rigth
  // don't use msb bit of genpoly it's not used
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int i = 0; i < $bits(GPOLY); i++) begin
      GPOLY[i] = cGPOLY[$high(cGPOLY)-i-1];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // BCH encoder is simple LFSR register
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
      osop <= isop;
      oeop <= eof;
      //
      if (ival) begin
        cnt <=  isop ? 1'b1 : (cnt + 1'b1);   // look ahead count input data
        eop <= !isop & (cnt == cEOP_EDGE-2);
        eof <= !isop & (cnt == cEOF_EDGE-2);
        // coding "FSM"
        if (isop) begin
          data_n_code <= 1'b1;
        end
        else if (eop) begin
          data_n_code <= 1'b0;
        end
        // coding itself
        if (isop | data_n_code) begin
          odat <= idat;
        end
        else begin
          odat <= eof ? {6'h0, state[3 : 2], 6'h0, state[1 : 0]} : state[cDAT_W-1 : 0];
        end
        state <= state_next;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // encoding itself, LSB first (!!!!)
  // data payload size is multiply pDAT_W
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    state_next = isop ? '0 : state;
    //
    for (int b = 0; b < cDAT_W; b++) begin
      dat2mult    = (isop | data_n_code) ? (idat[b] ^ state_next[0]) : 1'b0;
      state_next  = encode_bit (dat2mult, state_next);
    end
  end

  function state_t encode_bit (input bit dat, input state_t state);
    for (int i = 0; i < $size(state); i++) begin
      if (i == $high(state)) begin
        encode_bit[i] = (GPOLY[i] & dat);
      end
      else begin
        encode_bit[i] = (GPOLY[i] & dat) ^ state[i+1];
      end
    end
  endfunction

endmodule
