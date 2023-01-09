//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Workfile      : golay24_dec_types.svh
// Description   : file with all decoder used types
//

//------------------------------------------------------------------------------------------------------
// used types for decoder
//------------------------------------------------------------------------------------------------------

  parameter pLLR_W = 4;
  parameter pTAG_W = 4;

  localparam int cMETRIC_W = $clog2(24) + pLLR_W;

  typedef logic signed    [pLLR_W-1 : 0] llr_t;
  typedef logic signed    [pTAG_W-1 : 0] tag_t;

  typedef logic signed [cMETRIC_W-1 : 0] metric_t;

  typedef logic                  [4 : 0] idx_t;

  typedef logic                 [23 : 0] dat_t;
  typedef logic                 [11 : 0] syndrome_t;

