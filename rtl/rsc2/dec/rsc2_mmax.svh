//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_mmax.svh
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

  //
  // module parallel max selector
  function trel_state_t st_m_p_mmax (input trel_state_t a, b, c, d);
    trel_state_t tmp_ab;
    trel_state_t tmp_ac;
    trel_state_t tmp_ad;
    trel_state_t tmp_bc;
    trel_state_t tmp_bd;
    trel_state_t tmp_cd;
    //
    bit b_more_a, c_more_a, d_more_a;
    bit c_more_b, d_more_b;
    bit d_more_c;
    //
    trel_state_t tmpH;
    trel_state_t tmpL;
  begin
    tmp_ab = a - b; tmp_ac = a - c; tmp_ad = a - d;
    tmp_bc = b - c; tmp_bd = b - d;
    tmp_cd = c - d;
    //
    b_more_a = tmp_ab[cSTATE_W-1];
    c_more_a = tmp_ac[cSTATE_W-1];
    d_more_a = tmp_ad[cSTATE_W-1];
    c_more_b = tmp_bc[cSTATE_W-1];
    d_more_b = tmp_bd[cSTATE_W-1];
    d_more_c = tmp_cd[cSTATE_W-1];
    //
    tmpH = b_more_a ? b : a;
    tmpL = d_more_c ? d : c;

    case ({b_more_a, d_more_c})
      2'b00   : st_m_p_mmax = c_more_a ? tmpL : tmpH;
      2'b01   : st_m_p_mmax = d_more_a ? tmpL : tmpH;
      2'b10   : st_m_p_mmax = c_more_b ? tmpL : tmpH;
      default : st_m_p_mmax = d_more_b ? tmpL : tmpH;
    endcase
  end
  endfunction

  //
  // parallel max selector
  function trel_state_t st_p_mmax (input trel_state_t a, b, c, d);
    bit a_more_b, a_more_c, a_more_d;
    bit b_more_c, b_more_d;
    bit c_more_d;
    bit [1 : 0] sel;
  begin
    a_more_b = (a > b); a_more_c = (a > c); a_more_d = (a > d);
    b_more_c = (b > c); b_more_d = (b > d);
    c_more_d = (c > d);
    //
    if (a_more_b) begin
      if (c_more_d)
        sel = a_more_c ? 2'b00 : 2'b10;
      else // d_more_c
        sel = a_more_d ? 2'b00 : 2'b11;
    end
    else begin // b_more_a
      if (c_more_d)
        sel = b_more_c ? 2'b01 : 2'b10;
      else // d_more_c
        sel = b_more_d ? 2'b01 : 2'b11;
    end
    //
    case (sel)
      2'b00   : st_p_mmax = a;
      2'b01   : st_p_mmax = b;
      2'b10   : st_p_mmax = c;
      2'b11   : st_p_mmax = d;
      default : st_p_mmax = a;
    endcase
  end
  endfunction

