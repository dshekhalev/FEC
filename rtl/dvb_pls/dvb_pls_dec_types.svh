//
// Project       : PLS DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pls_dec_types.svh
// Description   : DVB PLS decoder types
//

  parameter int pDAT_W          = 8 ;

  localparam int cMETRIC_W      = pDAT_W + 1;     // pair sum

  localparam int cMETRIC_SUM_W  = cMETRIC_W + 5;  // hadamard32 sum

  localparam int cMETRIX_IDX_W  = $clog2(32);

  //------------------------------------------------------------------------------------------------------
  // simple types
  //------------------------------------------------------------------------------------------------------

  typedef logic signed        [pDAT_W-1 : 0] dat_t;
  typedef logic signed     [cMETRIC_W-1 : 0] metric_t;
  typedef logic signed [cMETRIC_SUM_W-1 : 0] metric_sum_t;

  typedef logic        [cMETRIX_IDX_W-1 : 0] metric_idx_t;

  //------------------------------------------------------------------------------------------------------
  // abs functions, remember there is saturation at input: value -2^(N-1) is immposible
  //------------------------------------------------------------------------------------------------------

  function automatic metric_t abs_metric (input metric_t dat);
  begin
    abs_metric = (dat ^ {cMETRIC_W{dat[cMETRIC_W-1]}}) + dat[cMETRIC_W-1];
  end
  endfunction

  function automatic metric_sum_t abs_metric_sum (input metric_sum_t dat);
  begin
    abs_metric_sum = (dat ^ {cMETRIC_SUM_W{dat[cMETRIC_SUM_W-1]}}) + dat[cMETRIC_SUM_W-1];
  end
  endfunction
