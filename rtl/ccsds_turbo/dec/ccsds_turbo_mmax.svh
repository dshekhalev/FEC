//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_mmax.sv
// Description   : file with MAX* function realisation for different decoder data types
//

  //------------------------------------------------------------------------------------------------------
  // define used MAX* functions
  //------------------------------------------------------------------------------------------------------

  function trel_state_t st_mmax (input trel_state_t a, b);
    st_mmax = (a > b) ? a : b;
  endfunction

  //
  // module based max for state processor
  function trel_state_t st_m_mmax (input trel_state_t a, b);
    trel_state_t tmp;
  begin
    tmp = a - b;
    st_m_mmax = tmp[cSTATE_W-1] ? b : a;
  end
  endfunction

  function trel_branch_t bm_mmax (input trel_branch_t a, b);
    bm_mmax = (a > b) ? a : b;
  endfunction

  function trel_branch_t bm_mmax1 (input trel_branch_t a, b);
    trel_branch_p1_t tmp;
  begin
    tmp = a - b;
    bm_mmax1 = (tmp[cGAMMA_W] ? b : a) + (~|tmp[cGAMMA_W : pLLR_FP+1] | &tmp[cGAMMA_W : pLLR_FP+1]);
  end
  endfunction
