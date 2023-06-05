//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_types.svh
// Description   : decoder parameters/types & etc
//

  //------------------------------------------------------------------------------------------------------
  // decoder parameters
  //------------------------------------------------------------------------------------------------------

  // arithmetic bitwidth
  parameter int pLLR_W        = 4;            // <= 8
  parameter int pNODE_W       = pLLR_W  + 2;  // extend internal node bitwidth
  parameter int pNODE_ACC_W   = pNODE_W + 1;  // extend internal node accumularo bitwidth for layered/hybrid decoder

  // parallelization settings
//parameter int pROW_BY_CYCLE = 1;  // amount of rows per cycle. only 1 support now

  // algoritm settings
  parameter bit pUSE_SC_MODE  = 1;  // use self corrected mode (with vnode erasure)
  parameter int pNORM_FACTOR  = 7;  // scale factor = pNORM_FACTOR/8
  parameter bit pNORM_OFFSET  = 0;  // use offset (1) or scale (0) normalization
                                      // for pLLR_W == 4 pNORM_OFFSET don't work (!!!)

  //------------------------------------------------------------------------------------------------------
  // used data types
  //------------------------------------------------------------------------------------------------------

  typedef logic signed  [pLLR_W-1 : 0] llr_t;
  typedef llr_t                        zllr_t  [cZC_MAX];

  typedef logic signed [pNODE_W-1 : 0] node_t;
  typedef node_t                       znode_t [cZC_MAX];

  // control strobes type
  typedef struct packed {
    logic sof;
    logic sop;
    logic eop;
    logic eof;
  } strb_t;

  typedef struct packed {
    col_t       col_idx;
    cycle_idx_t paddr;
  } vnode_ctx_t;

  typedef struct packed {
    bit     mask_0_bit;
    shift_t shift;
  } cnode_ctx_t;

  //------------------------------------------------------------------------------------------------------
  // vertical step (vnode engine) node types
  //------------------------------------------------------------------------------------------------------

  typedef struct packed {
    logic pre_sign, pre_zero; // self-corrected bits
  } node_state_t;

  typedef node_state_t znode_state_t [cZC_MAX];

  localparam int cNODE_STATE_W = $bits(node_state_t);

  localparam int cNODE_PER_COL_NUM_W  = $clog2(cHS_NON_ZERO_ROW_PER_COL_MAX);
  localparam int cNODE_SUM_W          = pNODE_W + cNODE_PER_COL_NUM_W;

  typedef logic        [cNODE_PER_COL_NUM_W-1 : 0] node_num_t;
  typedef logic signed         [cNODE_SUM_W-1 : 0] node_sum_t;

  //------------------------------------------------------------------------------------------------------
  // horizontal step (cnode engine) node types
  //------------------------------------------------------------------------------------------------------

  localparam int cNODE_PER_ROW_NUM_W  = $clog2(cHS_NON_ZERO_COL_PER_ROW_MAX);

  typedef logic             [pNODE_W-1 : 0] vnode_t;       // != node_t because unsigned !!!!!
  typedef logic [cNODE_PER_ROW_NUM_W-1 : 0] vn_min_col_t;  // cCOL_MAX is max, but use less

  typedef struct packed {
    // common fields
    logic         prod_sign;
    // partial fields
    vnode_t       min1;
    vnode_t       min2;
    vn_min_col_t  min1_col;
  } vn_min_t;

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  //
  // function to get optimal input buffer LLR num to save resources of source unit & ram
  //
  function automatic int get_buffer_llr_num (input int llr_w, llr_num);
  begin
    get_buffer_llr_num = llr_num;
    // make common for all llr_w. do optimization in future
    case (llr_num)
      1,   2,  4, 8 : get_buffer_llr_num = 8;
      3,   6,  9    : get_buffer_llr_num = 9;
      5,  10        : get_buffer_llr_num = 10;
      12, 18, 36    : get_buffer_llr_num = 36;
      15, 30        : get_buffer_llr_num = 30;
//    20, 40        : get_buffer_llr_num = 40;
//    24,  72       : get_buffer_llr_num = 72;
//    45, 90        : get_buffer_llr_num = 90;
//    60, 180       : get_buffer_llr_num = 180;
//    120, 360      : get_buffer_llr_num = 360;
    endcase
  end
  endfunction

  //
  // function to get maximum buffer ram address. Decoder use same address for output and input
  //
  function automatic int get_buff_max_addr (input int gr);
  begin
    get_buff_max_addr = cGET_USED_COL_TAB[cCODEGR_LARGE];
    if (gr <= 2) begin
      get_buff_max_addr = cGET_USED_COL_TAB[gr];
    end
  end
  endfunction

