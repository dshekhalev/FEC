//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_dec_types.svh
// Description   : decoder parameters/types & etc
//

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

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------


