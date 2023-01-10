//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_types.sv
// Description   : file with all decoder used types
//

  localparam int cSTATE_NUM = 16;
  localparam int cBIT_NUM   =  2;

  localparam int cBLLR_W    = pLLR_W   + 2; // +2 bit parity metric is b0 + b1 + b2
  localparam int cL_EXT_W   = pLLR_W   + 3; // Lextrinsic ~= 8*pLLR_W

  localparam int cSTATE_W   = cL_EXT_W + 3; // state(k) ~= Lextrinsic + gamma + state(k)
  localparam int cGAMMA_W   = cSTATE_W + 1; // Lextrinsic + gammaL + alpha(k) + beta(k+1)

  //
  // single word type
  typedef logic signed   [pLLR_W-1 : 0] bit_llr_t;
  typedef logic signed  [cBLLR_W-1 : 0] pbit_llr_t;
  typedef logic signed [cL_EXT_W-1 : 0] extr_llr_t;

  typedef logic signed [cSTATE_W-1 : 0] trel_state_t;

  typedef logic signed [cGAMMA_W-1 : 0] trel_branch_t;
  typedef logic signed [cGAMMA_W   : 0] trel_branch_p1_t;

  // complex types
  typedef trel_state_t  Lapri_t ;
  typedef trel_branch_t Lapo_t  ;

  typedef struct packed {
    logic      pre_sign;
    logic      pre_zero;
    extr_llr_t value;
  } Lextr_t;

  //
  // arrays type
  typedef pbit_llr_t    pbit_allr_t [1:7];

  typedef trel_state_t  state_t     [cSTATE_NUM];
  typedef trel_state_t  gamma_t     [cSTATE_NUM][cBIT_NUM];

  typedef trel_branch_t bm_t        [cSTATE_NUM][cBIT_NUM];

