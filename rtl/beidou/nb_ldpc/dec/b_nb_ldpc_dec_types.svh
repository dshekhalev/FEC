//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_dec_types.svh
// Description   : decoder parameters/types & etc
//

  `include "../b_nb_ldpc_constants.svh"

  //------------------------------------------------------------------------------------------------------
  // paramteres
  //------------------------------------------------------------------------------------------------------

  localparam int cBIT_ERR_W  = $clog2(cN_MAX * cGF_M);
  localparam int cSYMB_ERR_W = $clog2(cN_MAX);

  //------------------------------------------------------------------------------------------------------
  // used data types
  //------------------------------------------------------------------------------------------------------

  // control strobes type
  typedef struct packed {
    logic sof;
    logic sop;
    logic eop;
    logic eof;
  } strb_t;

  typedef logic  [cBIT_ERR_W-1 : 0] bit_err_t;
  typedef logic [cSYMB_ERR_W-1 : 0] symb_err_t;

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------



