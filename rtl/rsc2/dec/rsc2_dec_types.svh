//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_types.sv
// Description   : file with all decoder used types
//

//------------------------------------------------------------------------------------------------------
// used types for decoder
//------------------------------------------------------------------------------------------------------

  localparam int cDLLR_W        = pLLR_W   + 1; // duo-bin LLR
  localparam int cL_EXT_W       = cDLLR_W  + 2; // Lextrinsic ~= 4*cDLLR_W
  localparam int cSTATE_W       = cL_EXT_W + 3; // state(k) ~= Lextrinsic + gamma + state(k)
  localparam int cGAMMA_W       = cSTATE_W + 1; // Lextrinsic + gammaL + alpha(k) + beta(k+1)

  localparam int cSTATE_DIFF_W  = cSTATE_W - 2; // State difference is 2 bit less then state

  //
  // single word type
  typedef logic signed        [pLLR_W-1 : 0] bit_llr_t;
  typedef logic signed       [cDLLR_W-1 : 0] dbit_llr_t;

  typedef logic signed      [cL_EXT_W-1 : 0] extr_llr_t;

  typedef logic signed      [cSTATE_W-1 : 0] trel_state_t;
  typedef logic signed [cSTATE_DIFF_W-1 : 0] trel_state_diff_t;

  typedef logic signed      [cGAMMA_W-1 : 0] trel_branch_t;
  typedef logic signed      [cGAMMA_W   : 0] trel_branch_p1_t;
  typedef logic signed      [cGAMMA_W+1 : 0] trel_branch_p2_t;

  //
  // arrays type
  typedef dbit_llr_t    dbit_allr_t [1:3];

  typedef extr_llr_t    Lextr_t     [1:3];
  typedef trel_state_t  Lapri_t     [1:3];
  typedef trel_branch_t Lapo_t      [1:3];

  typedef trel_state_t  state_t     [16];
  typedef trel_state_t  gamma_t     [16][4];

  typedef trel_branch_t bm_t        [16][4];

  //
  // packed types for metric memory : TODO in future
  typedef struct packed {
    trel_state_t        basea;
    trel_state_diff_t   diffa0, diffa1, diff2;
    trel_state_t        baseb;
    trel_state_diff_t   diffb0, diffb1, diffb2;
  } metric_mem_t;


