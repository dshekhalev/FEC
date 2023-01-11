//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_parameters.svh
// Description   : Decoder parameters & types declaration file
//

  //------------------------------------------------------------------------------------------------------
  // decoder parameters
  //------------------------------------------------------------------------------------------------------

  parameter int pLLR_W          = 4;
  parameter int pLLR_BY_CYCLE   = 8;      // amount of metric per clock cycle. must be multiple of pZF
  parameter int pNODE_W         = pLLR_W; // extend internal node bitwidth to increase fixed point part when normaliation used
  parameter int pNODE_BY_CYCLE  = 24;     // amount of one metric cnode/vnode per clock cycle. must be multiple of pT
                                          // the decoder rate is pLLR_BY_CYCLE * pNODE_BY_CYCLE cnode/vnode per clock cycle
  parameter bit pUSE_SC_MODE    = 0;      // use self corrected mode (with vnode erasure)

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  typedef logic signed  [pLLR_W-1 : 0] llr_t;
  typedef logic signed [pNODE_W-1 : 0] node_t;
  typedef logic        [pNODE_W-1 : 0] vnode_t; // != node_t because unsigned !!!!!

  typedef struct packed {
    logic pre_sign, pre_zero;
  } node_state_t;

  //------------------------------------------------------------------------------------------------------
  // used bitwidths
  //------------------------------------------------------------------------------------------------------

  // buffer/shift memory address
  localparam int cADDR_MAX    = cLDPC_NUM/(pLLR_BY_CYCLE * pNODE_BY_CYCLE);
  localparam int cADDR_W      = clogb2(cADDR_MAX);

  // shift memory multiplexing address
  localparam int cSELA_W      = (pLLR_BY_CYCLE == 1) ? 1 : clogb2(pLLR_BY_CYCLE);

  //
  localparam int cNODE_CNT_W  = clogb2(pNODE_BY_CYCLE);

  // H matrix t counter :: scaled by pNODE_BY_CYCLE
  localparam int cT_MAX       = pT/pNODE_BY_CYCLE;
  localparam int cTCNT_W      = (cT_MAX == 1) ? 1 : clogb2(cT_MAX);

  // expansion factor counter :: scaled by pLLR_BY_CYCLE
  localparam int cZ_MAX       = pZF/pLLR_BY_CYCLE;
  localparam int cZCNT_W      = clogb2(cZ_MAX);

  // block (data + parity) size in pLLR_BY_CYCLE * pNODE_BY_CYCLE
  localparam int cBLOCK_SIZE  = cLDPC_NUM/(pLLR_BY_CYCLE * pNODE_BY_CYCLE);
  // data size in pLLR_BY_CYCLE for pNODE_BY_CYCLE == 1
  localparam int cDATA_SIZE   = cLDPC_DNUM/pLLR_BY_CYCLE;

  // bit errors per cycle
  localparam int cBIT_ERR_MAX = pLLR_BY_CYCLE * pNODE_BY_CYCLE;
  localparam int cBIT_ERR_W   = clogb2(cBIT_ERR_MAX) + 1; // +1 to prevent overflow if cBIT_ERR_MAX = 2^N

  typedef bit   [cADDR_W-1 : 0] mem_addr_t;
  typedef bit   [cSELA_W-1 : 0] mem_sela_t;

  typedef logic [cTCNT_W-1 : 0] tcnt_t;
  typedef logic [cZCNT_W-1 : 0] zcnt_t;

  typedef logic [cNODE_CNT_W-1 : 0] node_cnt_t;

  typedef struct packed {
    logic             prod_sign;
    vnode_t           min1;
    vnode_t           min2;
    tcnt_t            min1_idx;
    node_cnt_t        min1_node;
    //
    logic  [pT-1 : 0] vn_sign;
    //
    zcnt_t            vn_zcnt;
  } vn_min_t;

  //------------------------------------------------------------------------------------------------------
  // generation of Hb to pipeline decoder by pNODE_BY_CYCLE processing
  //------------------------------------------------------------------------------------------------------

  typedef int mH_t [pC][pNODE_BY_CYCLE][0 : cT_MAX-1];
/*
  function automatic mH_t get_mHb (input H_t tHb);
  begin
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        for (int t = 0; t < cT_MAX; t++) begin
          get_mHb[c][n][t] = tHb[c][n*cT_MAX + t];
        end
      end
    end
  end
  endfunction
*/
  //------------------------------------------------------------------------------------------------------
  // generation of address table to pipeline decoder by pLLR_BY_CYCLE processing
  //------------------------------------------------------------------------------------------------------

  localparam int cFADDR_W     = clogb2(cLDPC_NUM/pLLR_BY_CYCLE); // full address width only for tables (do single table for variable pNODE_BY_CYCLE)

  typedef struct {
    bit [cFADDR_W-1 : 0] baddr;
    bit [cFADDR_W-1 : 0] offset  [pLLR_BY_CYCLE];
    bit [cFADDR_W-1 : 0] offsetm [pLLR_BY_CYCLE];  // offset mask :: true_offset = (baddr == 0 & ofsetm != 0) ? (offset + cZ_MAX) : offset
    mem_sela_t           sela    [pLLR_BY_CYCLE];
    mem_sela_t           invsela [pLLR_BY_CYCLE];
  } paddr_t;

  typedef paddr_t addr_tab_t [pC][pT][cZ_MAX];

  //------------------------------------------------------------------------------------------------------
  // generation of bitmask table to optimize decoder resources
  //------------------------------------------------------------------------------------------------------

  typedef bit bitmask_tab_t [pC][pNODE_BY_CYCLE]; // valid remap_t label
