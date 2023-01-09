//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_dec_types.svh
// Description   : viterbi codec parameters and types
//

  //------------------------------------------------------------------------------------------------------
  // used parameters
  //------------------------------------------------------------------------------------------------------

  parameter int pTAG_W            = 4;
  parameter int pERR_CNT_W        = 16; // error counter width

  // traceback parameters
  parameter int pTRB_LENGTH       = 64;

  localparam int cTRB_RAM_ADDR_W  = $clog2(pTRB_LENGTH) + 2;  // 4D buffer
  localparam int cTRB_LIFO_ADDR_W = $clog2(pTRB_LENGTH);

  // LLR metric for each bit
  parameter int pLLR_W            = 4;

  // trellis branch metric == sum of 4 metric, 16 metric in all
  localparam int cBM_W            = pLLR_W + 2;
  localparam int cBM_NUM          = 16;

  // trellis state path metric (search minumum, metric is positive)
  localparam int cSTATEM_W        = cBM_W + 1 + 2; // 2*BM + 2 bits for module arithmetic (!!!)

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  typedef logic           [pTAG_W-1 : 0] tag_t ;
  typedef logic       [pERR_CNT_W-1 : 0] errcnt_t;

  typedef logic signed    [pLLR_W-1 : 0] llr_t;

  // trellis metrics
  typedef logic signed     [cBM_W-1 : 0] trel_bm_t       ;
  typedef logic signed [cSTATEM_W-1 : 0] trel_statem_t   ;
  typedef logic                  [2 : 0] trel_decision_t ;

  // trellis array metrics
  typedef trel_bm_t       bm_t       [cBM_NUM];
  typedef trel_statem_t   statem_t   [cSTATE_NUM];
  typedef trel_decision_t decision_t [cSTATE_NUM];

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
