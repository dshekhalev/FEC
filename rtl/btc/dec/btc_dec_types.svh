//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_types.svh
// Description   : decoder parameters/types & etc
//

  //------------------------------------------------------------------------------------------------------
  // decoder parameters
  //------------------------------------------------------------------------------------------------------

  parameter int pLLR_W    = 4;
  parameter int pEXTR_W   = pLLR_W  + 1; // +1 bit at least

  parameter int pMETRIC_W = pEXTR_W + 3; // * 4 times for fast chase + 1 for decision

  //------------------------------------------------------------------------------------------------------
  // used data types
  //------------------------------------------------------------------------------------------------------

  // control strobes type
  typedef struct packed {
    logic sof;
    logic sop;
    logic eop;
    logic eof;
    //
    logic mask; // mask of rows decoder
  } strb_t;

  //------------------------------------------------------------------------------------------------------
  // soft decoders types
  //------------------------------------------------------------------------------------------------------

  typedef logic signed    [pLLR_W-1 : 0] llr_t;
  typedef logic signed   [pEXTR_W-1 : 0] extr_t;
  typedef logic signed   [pEXTR_W   : 0] extr_p1_t; // +1 for add functions
  typedef logic signed [pMETRIC_W-1 : 0] metric_t;

  typedef logic          [pEXTR_W-1 : 0] uextr_t;   // unsigned for search

  //------------------------------------------------------------------------------------------------------
  // extrinsic scale types
  //------------------------------------------------------------------------------------------------------

  typedef logic [3 : 0] alpha_t;

  localparam alpha_t cALPHA_0     = 0;//4'b0000;
  localparam alpha_t cALPHA_0p125 = 1;//4'b0001;
  localparam alpha_t cALPHA_0p25  = 2;//4'b0010;
  localparam alpha_t cALPHA_0p5   = 4;//4'b0100;
  localparam alpha_t cALPHA_1     = 8;//4'b1000;

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  function extr_t do_scale (input extr_t data, alpha_t alpha);
    bit mask;
  begin
    do_scale = '0;
    casex(alpha)
      cALPHA_1      : do_scale = data;
      cALPHA_0p5    : begin
        mask      =  data[0] & data[$high(data)];
        do_scale  = ((data <<< 2) + (mask ? 0 : 4)) >>> 3;
      end
      cALPHA_0p25   : begin
        mask      =  !data[0] & data[$high(data)];
        do_scale  = ((data <<< 1) + (mask ? 0 : 4)) >>> 3;
      end
      cALPHA_0p125  : begin;
        mask      =  (data[1:0] == 0) & data[$high(data)];
        do_scale  = (data + (mask ? 0 : 4)) >>> 3;
      end
    endcase
  end
  endfunction

