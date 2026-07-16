//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_constants.svh
// Description   : LDPC codec constants, types, functions
//

  typedef logic [1 : 0] code_idx_t;  // 0...3

  //------------------------------------------------------------------------------------------------------
  // code context for variable decoder
  //------------------------------------------------------------------------------------------------------

  enum code_idx_t {
    cBCNV1_SF3  = 0,
    cBCNV1_SF2  = 1,
    cBCNV2      = 2,
    cBCNV3      = 3
  } code_t;

  //------------------------------------------------------------------------------------------------------
  // GF type
  //------------------------------------------------------------------------------------------------------

  localparam int cGF_M = 6;

  typedef logic [cGF_M-1 : 0] gf_data_t;

  //------------------------------------------------------------------------------------------------------
  // check matrix settings
  //------------------------------------------------------------------------------------------------------

  localparam int cCOL_TAB   [4] = '{ 88, 200,  96, 162};
  localparam int cROW_TAB   [4] = '{ 44, 100,  48,  81};

  localparam int cH_NUM_TAB [4] = '{176, 400, 192, 324};

  // the largest
  localparam int cN_MAX         = 200;
  localparam int cK_MAX         = 100;

  localparam int cH_N_MAX       = 400;

  localparam int cLOG2_N_MAX    = $clog2(cN_MAX);
  localparam int cLOG2_K_MAX    = $clog2(cK_MAX);
  localparam int cLOG2_H_N_MAX  = $clog2(cH_N_MAX);

  typedef logic [cLOG2_N_MAX-1 : 0] col_t;
  typedef logic [cLOG2_K_MAX-1 : 0] row_t;

