//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_types.svh
// Description   : decoder parameters/types & etc
//

  //------------------------------------------------------------------------------------------------------
  // common code context parameter to contstraint fixed or variable decoder
  //------------------------------------------------------------------------------------------------------

  parameter bit pIDX_GR   =  0 ; // use graph1/graph2 (0) or graph2 only (1)
  parameter int pIDX_LS   =  0 ;
  parameter int pIDX_ZC   =  7 ;
  parameter int pCODE     = 46 ; // maximum code rate using (46 for graph1 and 42 for graph2)
  parameter bit pDO_PUNCT =  0 ; // use puncture any time (1) or context defined (0)

  //------------------------------------------------------------------------------------------------------
  // decoder parameters
  //
  // the decoder performance rate is pLLR_BY_CYCLE * pROW_BY_CYCLE * pCOL_BY_CYCLE cnode/vnode per clock cycle
  // maximum amount of nodes per code block is
  //  graph 1 zc*(4*26 + 42*(26+1))
  //  graph 2 zc*(4*14 + 38*(14+1))
  //
  //------------------------------------------------------------------------------------------------------

  // arithmetic bitwidth
  parameter int pLLR_W          = 4;      // <= 8
  parameter int pNODE_W         = pLLR_W; // extend internal node bitwidth to increase fixed point part when normaliation used

  // parallelization settings
  parameter int pLLR_BY_CYCLE   = 1;      // amount of metric per clock cycle. == 1/2/4/8 & <= minimum used cZC & integer multiply of minimum used cZC
  parameter int pROW_BY_CYCLE   = 4;      // amount of rows per cycle. maximum number of row for graph1/2 is 46/42
  // fixed. don't change
  localparam int cCOL_BY_CYCLE  = 26;     // amount of major decoder collumns per cycle. maximum number of col for graph1/2 is 26/14

  parameter bit pUSE_SC_MODE    = 1;      // use self corrected mode (with vnode erasure)

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_LLR_BY_CYCLE = (pLLR_BY_CYCLE == 1) ? 1 : clogb2(pLLR_BY_CYCLE);

  typedef logic [cLOG2_LLR_BY_CYCLE-1 : 0] bshift_t;

  // matrix multiply value type
  typedef struct packed {
    bshift_t bshift;    // bit  shift == Hb[c][t] % pLLR_BY_CYCLE
    hb_zc_t  wshift;    // word shift == Hb[c][t] / pLLR_BY_CYCLE
    logic    is_masked; // Hb[c][t] < 0
    logic    is_max;    // (Hb[c][t] / pLLR_BY_CYCLE) == used_zc-1
  } mm_hb_value_t;

  //------------------------------------------------------------------------------------------------------
  // used data types
  //------------------------------------------------------------------------------------------------------

  typedef logic signed  [pLLR_W-1 : 0] llr_t;
  typedef logic signed [pNODE_W-1 : 0] node_t;

  typedef struct packed {
    logic pre_sign, pre_zero;
  } node_state_t;

  localparam int cNODE_STATE_W  = $bits(node_state_t);

  // control strobes type
  typedef struct packed {
    logic sof;  // start of node frame working (row == 0 & zc == 0)
    logic sop;  // start of node block working cnode_mode ? (zc  == 0)         : (row == 0)
    logic eop;  // end   of node block working cnode_mode ? (zc  == used_zc-1) : (row == used_row-1)
    logic eof;  // end   of node frame working (row == used_row-1 & zc == used_zc-1)
  } strb_t;

  //------------------------------------------------------------------------------------------------------
  // node/LLR memory parameters
  //------------------------------------------------------------------------------------------------------

  localparam int cMAX_ROW_STEP_NUM  = get_max_row_step_num(pIDX_GR, pCODE);

  localparam int cMAX_COL_STEP_NUM  = 26/cCOL_BY_CYCLE;

  // node mem : pMAX_ROW_STEP_NUM of Zc*Zc block
  localparam int cMEM_ADDR_MAX      = cMAX_ROW_STEP_NUM * cMAX_COL_STEP_NUM * cZC_MAX/pLLR_BY_CYCLE;
  localparam int cMEM_ADDR_W        = clogb2(cMEM_ADDR_MAX);

  // data LLR mem : one Zc*Zc block
  localparam int cD_MEM_ADDR_MAX    = cMAX_COL_STEP_NUM * cZC_MAX/pLLR_BY_CYCLE;
  localparam int cD_MEM_ADDR_W      = clogb2(cD_MEM_ADDR_MAX);

  // parity LLR mem : pMAX_ROW_STEP_NUM of Zc*Zc block
  localparam int cP_MEM_ADDR_MAX    = cMEM_ADDR_MAX;
  localparam int cP_MEM_ADDR_W      = clogb2(cP_MEM_ADDR_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function int get_max_row_step_num (int idxGr, code);
  begin
    if (code < 4) begin
      get_max_row_step_num = ceil(4, pROW_BY_CYCLE);
    end
    else begin
      get_max_row_step_num = ceil((code > cGR_MAX_ROW[idxGr]) ? cGR_MAX_ROW[idxGr] : code, pROW_BY_CYCLE);
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // horizontal step (cnode engine) node types
  //------------------------------------------------------------------------------------------------------

  typedef logic       [pNODE_W-1 : 0] vnode_t;        // != node_t because unsigned !!!!!
  typedef logic [cCOL_BY_CYCLE-1 : 0] vnode_sign_t;
  typedef logic               [4 : 0] min_col_idx_t;  //  0...26 (cGR_MAJOR_BIT_COL[])

  typedef struct packed {
    // common fields
    logic         prod_sign;
    vnode_sign_t  vn_sign;
    // partial fields
    vnode_t       min1;
    vnode_t       min2;
    min_col_idx_t min1_col;
  } vn_min_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
