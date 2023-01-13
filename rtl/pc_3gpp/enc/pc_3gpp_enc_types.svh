//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_enc_types.svh
// Description   : Encoder parameters, constants and types
//

  parameter int pN_MAX  = 1024; // fixed. don't change

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

  //------------------------------------------------------------------------------------------------------
  // alu opcodes
  //------------------------------------------------------------------------------------------------------

  typedef enum bit [2 : 0] {
    cNOP        = 3'b0_00 ,

    cDO_8x8     = 3'b0_01 ,

    cCOMB_int   = 3'b1_00 ,   // internal reg
    cCOMB_intc  = 3'b1_01 ,   // internal cache
    cCOMB_ext   = 3'b1_10 ,   // external ram
    cCOMB_last  = 3'b1_11     // last comb
  } alu_opcode_e;

  typedef logic [2 : 0] alu_opcode_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic  [cBIT_ADDR_W-1 : 0] bit_addr_t;

  typedef logic [cWORD_ADDR_W-1 : 0] beta_w_addr_t;
  typedef logic      [pWORD_W-1 : 0] beta_w_dat_t;

  typedef logic       [cCRC_W-1 : 0] crc_t;

  typedef logic       [pTAG_W-1 : 0] tag_t;

  `include "../pc_3gpp_functions.svh"
