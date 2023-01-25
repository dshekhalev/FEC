//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_types.svh
// Description   : encoder parameters/types & etc
//

  //------------------------------------------------------------------------------------------------------
  // common code context parameter to contstraint fixed or variable decoder
  //------------------------------------------------------------------------------------------------------

  parameter bit pIDX_GR   =  0 ; // use graph1/graph2 (0) or graph2 only (1). graph1 has major matrix 26x4, graph2 14x4
  parameter int pIDX_LS   =  0 ;
  parameter int pIDX_ZC   =  7 ;
  parameter int pCODE     = 46 ; // maximum code rate using (46 for graph1 and 42 for graph2)
  parameter bit pDO_PUNCT =  0 ; // use puncture any time (1) or context defined (0)

  //------------------------------------------------------------------------------------------------------
  // encoder engine/interface parameters
  //------------------------------------------------------------------------------------------------------

  parameter int pDAT_W = 8; // 1/2/4/8/16/32 supported

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DAT_W = (pDAT_W == 1) ? 1 : clogb2(pDAT_W);

  typedef logic [cLOG2_DAT_W-1 : 0] bshift_t;

  // matrix multiply value type
  typedef struct packed {
    bshift_t bshift;     // bit  shift == Hb[c][t] % pDAT_W
    hb_zc_t  wshift;     // word shift == Hb[c][t] / pDAT_W
    logic    is_masked;  // Hb[c][t] < 0
    logic    is_max;     // wshift(Hb[c][t] / pDAT_W) == used_zc/pDAT_W-1
  } mm_hb_value_t;

  //------------------------------------------------------------------------------------------------------
  // used data types
  //------------------------------------------------------------------------------------------------------

  typedef logic [pDAT_W-1 : 0] dat_t;

  // control strobes type
  typedef struct packed {
    logic sof;  // start of node frame working (acu ? col/row == 0 & zc == 0)
    logic sop;  // start of node block working (zc  == 0)
    logic eop;  // end   of node block working (zc  == used_zc-1)
    logic eof;  // end   of node frame working (acu ? col/row == used_col/used_row-1 & zc == used_zc-1)
  } strb_t;
