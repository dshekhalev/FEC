//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_types.svh
// Description   : Decoder parameters, constants and types
//

  parameter int pN_MAX  = 1024; // fixed. don't change

  parameter int pLLR_W  =    4;

  parameter int pTAG_W  =    4;

  // internal engine parameters
  parameter int pWORD_W =     8; // engine word width fixed. don't change

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cNLOG2         = $clog2(pN_MAX);

  localparam int cBIT_ADDR_W    = $clog2(pN_MAX);

  localparam int cWORD_ADDR_W   = $clog2(pN_MAX/pWORD_W);

  localparam int cCRC_W         = 5;

  localparam int cALPHA_TRUE_W  = pLLR_W + cNLOG2 - ($clog2(pWORD_W) - 1);
  localparam int cALPHA_W       = min(pLLR_W + 4, cALPHA_TRUE_W); // saturate data

  localparam int cDLEN_W        = 16;

  //------------------------------------------------------------------------------------------------------
  // alu opcodes
  //------------------------------------------------------------------------------------------------------

  typedef enum bit [3 : 0] {
    cNOP         = 4'b00_00 ,

    cDO_8x8      = 4'b00_01 ,
    cDO_8x8_W    = 4'b00_11 , // wait for

    cCALC_F4     = 4'b10_00 ,
    cCALC_F4LLR  = 4'b10_01 ,

    cCALC_G4     = 4'b11_00 ,
    cCALC_G4LLR  = 4'b11_01 ,
    cCALC_G4_int = 4'b11_10 , // internal reg

    cCOMB_int    = 4'b01_00 , // internal reg
    cCOMB_intc   = 4'b01_01 , // internal cache
    cCOMB_ext    = 4'b01_10 , // external ram
    cCOMB_last   = 4'b01_11   // last comb
  } alu_opcode_e;

  typedef logic [3 : 0] alu_opcode_t;

  //------------------------------------------------------------------------------------------------------
  // frozen bit decode opcodes to detect duration of alu execution
  //------------------------------------------------------------------------------------------------------

  typedef enum bit [2 : 0] {
    cDEC_RATE0_8      , // 1 tick decoding delay
    cDEC_RATE1_8      , // 1 tick decoding delay
    //
    cDEC_X_4_RATE0_4  , // 3 tick decoding delay
    cDEC_RATE0_4_X_4  , // 3 tick decoding delay
    //
    cDEC_X_8            // 5 tick decoding delay  :: usual decoding
  } frozenb_type_e;

  typedef logic [2 : 0] frozenb_type_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic               [cDLEN_W-1 : 0] dlen_t;
  typedef logic               [cDLEN_W-1 : 0] err_t;

  typedef logic           [cBIT_ADDR_W-1 : 0] bit_addr_t;

  typedef logic          [cWORD_ADDR_W-1 : 0] beta_w_addr_t;
  typedef logic               [pWORD_W-1 : 0] beta_w_dat_t;

  typedef logic                [cCRC_W-1 : 0] crc_t;

  typedef logic                [pTAG_W-1 : 0] tag_t;

  typedef logic                [pLLR_W-1 : 0] llr_t;
  typedef llr_t                               llr_w_t    [pWORD_W];

  typedef logic signed       [cALPHA_W-1 : 0] alpha_dat_t;
  typedef logic signed  [cALPHA_TRUE_W-1 : 0] alpha_tdat_t; // alpha true dat to simplify mathematic

  typedef logic          [cWORD_ADDR_W-1 : 0] alpha_w_addr_t;

  typedef alpha_dat_t                         alpha_w_t       [pWORD_W];    // word
  typedef alpha_dat_t                         alpha_hw_t      [pWORD_W/2];  // half word

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../pc_3gpp_functions.svh"
