//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_enc_types.svh
// Description   : encoder parameters/types & etc
//

  `include "../b_nb_ldpc_constants.svh"

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


