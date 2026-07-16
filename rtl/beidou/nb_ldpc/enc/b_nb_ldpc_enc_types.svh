//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_enc_types.svh
// Description   : encoder parameters/types & etc
//

  `include "../b_nb_ldpc_constants.svh"

  //------------------------------------------------------------------------------------------------------
  // constants
  //------------------------------------------------------------------------------------------------------

  // parity G matrix for {200, 100} is 6899 non null elements
  localparam int cCYCLE_IDX_W = 13;

  //------------------------------------------------------------------------------------------------------
  // used data types
  //------------------------------------------------------------------------------------------------------

  typedef logic [cCYCLE_IDX_W-1 : 0] cycle_idx_t;

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


