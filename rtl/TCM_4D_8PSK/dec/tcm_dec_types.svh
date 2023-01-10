//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_types.svh
// Description   : tcm viterbi decoder parameters and types
//

  //------------------------------------------------------------------------------------------------------
  // used parameters
  //------------------------------------------------------------------------------------------------------

  parameter int pERR_CNT_W        = 16; // error counter width

  // traceback parameters
  parameter int pTRB_LENGTH       = 64;

  localparam int cTRB_RAM_ADDR_W  = $clog2(pTRB_LENGTH) + 2;  // 4D buffer
  localparam int cTRB_LIFO_ADDR_W = $clog2(pTRB_LENGTH);

  // symbol metric
  parameter int pSYMB_M_W   = 4;

  // trellis branch metric == sum of 4 metric
  localparam int cBM_W      = pSYMB_M_W + 2;
  localparam int cBM_NUM    = 16;

  // trellis state path metric (search minumum, metric is positive)
  localparam int cSTATEM_W  = cBM_W + 1; // BM + 1 bits for module arithmetic (!!!)

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  // error bit counter
  typedef logic       [pERR_CNT_W-1 : 0] errcnt_t;

  // symbol metric value
  typedef logic        [pSYMB_M_W-1 : 0] symb_m_value_t;  // unsigned (absolute value)

  // symbol metric {C0, C1, C2, C3) with context
  typedef symb_m_value_t                 symb_m_t     [4];
  typedef logic                  [3 : 0] symb_m_idx_t;
  typedef logic                  [3 : 0] symb_m_sign_t;
  typedef logic                  [1 : 0] symb_hd_t    [4];

  // trellis metrics
  typedef logic                  [3 : 0] trel_bm_idx_t   ;
  typedef logic            [cBM_W-1 : 0] trel_bm_t       ;  // unsigned (sum of absolute value)
  typedef logic signed [cSTATEM_W-1 : 0] trel_statem_t   ;
  typedef logic                  [2 : 0] trel_decision_t ;

  // trellis array metrics
  typedef trel_bm_t       bm_t       [cBM_NUM];
  typedef trel_statem_t   statem_t   [cSTATE_NUM];
  typedef trel_decision_t decision_t [cSTATE_NUM];

  // ram control types
  typedef struct packed {
    logic                 [1 : 0] bidx; // use 4D architecture
    logic [cTRB_RAM_ADDR_W-3 : 0] addr; //
  } trb_ram_addr_t;

  typedef logic [cTRB_LIFO_ADDR_W-1 : 0] trb_lifo_addr_t;

  //------------------------------------------------------------------------------------------------------
  // function for decision at module arithmetic
  //------------------------------------------------------------------------------------------------------

  function logic statem_a_max (input trel_statem_t a, b);
    trel_statem_t tmp;
  begin
    tmp = a - b;
    statem_a_max = !tmp[cSTATEM_W-1];
  end
  endfunction

