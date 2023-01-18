/*



  parameter bit pB_nF        = 0 ;
  parameter int pLLR_W       = 5 ;
  parameter int pLLR_FP      = 3 ;
  parameter int pMMAX_TYPE   = 0 ;
  parameter bit pUSE_P_COMP  = 1 ;



  logic   rsc_dec_rp_mod__iclk        ;
  logic   rsc_dec_rp_mod__ireset      ;
  logic   rsc_dec_rp_mod__iclkena     ;
  logic   rsc_dec_rp_mod__istate_clr  ;
  logic   rsc_dec_rp_mod__istate_ld   ;
  state_t rsc_dec_rp_mod__istate      ;
  logic   rsc_dec_rp_mod__ival        ;
  gamma_t rsc_dec_rp_mod__igamma      ;
  logic   rsc_dec_rp_mod__oval        ;
  state_t rsc_dec_rp_mod__ostate      ;
  gamma_t rsc_dec_rp_mod__ogamma      ;
  state_t rsc_dec_rp_mod__ostate2mm   ;
  state_t rsc_dec_rp_mod__ostate_last ;



  rsc_dec_rp_mod
  #(
    .pB_nF        ( pB_nF        ) ,
    .pLLR_W       ( pLLR_W       ) ,
    .pLLR_FP      ( pLLR_FP      ) ,
    .pMMAX_TYPE   ( pMMAX_TYPE   ) ,
    .pUSE_P_COMP  ( pUSE_P_COMP  )
  )
  rsc_dec_rp_mod
  (
    .iclk        ( rsc_dec_rp_mod__iclk        ) ,
    .ireset      ( rsc_dec_rp_mod__ireset      ) ,
    .iclkena     ( rsc_dec_rp_mod__iclkena     ) ,
    .istate_clr  ( rsc_dec_rp_mod__istate_clr  ) ,
    .istate_ld   ( rsc_dec_rp_mod__istate_ld   ) ,
    .istate      ( rsc_dec_rp_mod__istate      ) ,
    .ival        ( rsc_dec_rp_mod__ival        ) ,
    .igamma      ( rsc_dec_rp_mod__igamma      ) ,
    .oval        ( rsc_dec_rp_mod__oval        ) ,
    .ostate      ( rsc_dec_rp_mod__ostate      ) ,
    .ogamma      ( rsc_dec_rp_mod__ogamma      ) ,
    .ostate2mm   ( rsc_dec_rp_mod__ostate2mm   ) ,
    .ostate_last ( rsc_dec_rp_mod__ostate_last )
  );


  assign rsc_dec_rp_mod__iclk       = '0 ;
  assign rsc_dec_rp_mod__ireset     = '0 ;
  assign rsc_dec_rp_mod__iclkena    = '0 ;
  assign rsc_dec_rp_mod__istate_clr = '0 ;
  assign rsc_dec_rp_mod__istate_ld  = '0 ;
  assign rsc_dec_rp_mod__istate     = '0 ;
  assign rsc_dec_rp_mod__ival       = '0 ;
  assign rsc_dec_rp_mod__igamma     = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_rp_mod.sv
// Description   : recursive processor for state metrics with module ariphmetic
//                 Module latency is 1 tick
//

module rsc_dec_rp_mod
#(
  parameter bit pB_nF        = 0 ,  // 0/1 - forward/backward recursion
  parameter int pLLR_W       = 5 ,
  parameter int pLLR_FP      = 3 ,
  parameter int pMMAX_TYPE   = 1 ,
  parameter bit pUSE_P_COMP  = 1    // use parallel comparator
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  istate_clr  ,
  istate_ld   ,
  istate      ,
  //
  ival        ,
  igamma      ,
  //
  oval        ,
  ostate      ,
  ogamma      ,
  ostate2mm   ,
  ostate_last
);

  `include "rsc_dec_types.svh"
  `include "rsc_trellis.svh"
  `include "rsc_mmax.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk        ;
  input  logic   ireset      ;
  input  logic   iclkena     ;
  //
  input  logic   istate_clr  ; // clear init state (used for look ahead)
  input  logic   istate_ld   ; // load init state
  input  state_t istate      ; // init_alpha/init_beta for iteration
  //
  input  logic   ival        ;
  input  gamma_t igamma      ; // gamma(s, s')
  //
  output logic   oval        ;
  output state_t ostate      ; // alpha[k+1] / beta[k]
  //
  output gamma_t ogamma      ; // alpha(s, k) * gamma(s, s') / beta(s, k) * gamma(s, s')
  output state_t ostate2mm   ; // alpha[k] / beta[k+1]
  output state_t ostate_last ; // circulation state

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  gamma_t       gamma;
  state_t       state;
  state_t       next_state;

  trel_state_t  norm_value;

  //------------------------------------------------------------------------------------------------------
  // state recursion
  //------------------------------------------------------------------------------------------------------

  assign gamma      = pB_nF ? gamma_p_beta  (igamma, state) : gamma_p_alpha  (igamma, state);
  assign next_state = pB_nF ? get_next_beta (gamma)         : get_next_alpha (gamma);

  assign norm_value = get_norm_value(state);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (istate_clr) begin
        state <= '{default : '0};
      end
      else if (istate_ld) begin
        state <= istate;
      end
      else if (ival) begin
        state <= next_state;
      end
      //
      ogamma      <= gnormalize(gamma, norm_value);
      ostate2mm   <=  normalize(state, norm_value);
      ostate_last <=  normalize(state, norm_value);
    end
  end

  assign ostate = state;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // functions for alpha recursion
  //------------------------------------------------------------------------------------------------------

  // alpha(s, k) * gamma(s, s')
  function gamma_t gamma_p_alpha (input gamma_t gamma, input state_t alpha_in);
    for (int state = 0; state < 8; state++) begin
      for (int inb = 0; inb < 4; inb++) begin
        gamma_p_alpha[state][inb] = gamma[state][inb] + alpha_in[state];
      end
    end
  endfunction

  // alpha(s', k+1) = sum(alpha(s, k) * gamma(s, s'))
  function state_t get_next_alpha (input gamma_t gamma);
    for (int nstate = 0; nstate < 8; nstate++) begin
      if (pUSE_P_COMP) begin
        get_next_alpha[nstate] =  st_m_p_mmax(gamma[trel.preStates[nstate][0]][0], gamma[trel.preStates[nstate][1]][1],
                                              gamma[trel.preStates[nstate][2]][2], gamma[trel.preStates[nstate][3]][3]);
      end
      else begin
        get_next_alpha[nstate] =  st_m_mmax  (
                                    st_m_mmax  (gamma[trel.preStates[nstate][0]][0], gamma[trel.preStates[nstate][1]][1]),
                                    st_m_mmax  (gamma[trel.preStates[nstate][2]][2], gamma[trel.preStates[nstate][3]][3])
                                  );
      end
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // functions for beta recursions
  //------------------------------------------------------------------------------------------------------

  // beta(s, k) * gamma(s, s')
  function gamma_t gamma_p_beta (input gamma_t gamma, input state_t beta_in);
    for (int state = 0; state < 8; state++) begin
      for (int inb = 0; inb < 4; inb++) begin
        gamma_p_beta[state][inb] = gamma[state][inb] + beta_in[trel.nextStates[state][inb]];
      end
    end
  endfunction

  // sum(beta(s', k+1) * gamma(s, s'))
  function state_t get_next_beta (input gamma_t gamma);
    for (int state = 0; state < 8; state++) begin
      if (pUSE_P_COMP) begin
        get_next_beta[state] =  st_m_p_mmax(gamma[state][0], gamma[state][1],
                                            gamma[state][2], gamma[state][3]);
      end
      else begin
        get_next_beta[state] =  st_m_mmax (
                                  st_m_mmax ( gamma[state][0], gamma[state][1]),
                                  st_m_mmax ( gamma[state][2], gamma[state][3])
                                );
      end
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // functions for normalization
  //------------------------------------------------------------------------------------------------------

  // define normalization value for module arithmetic
  function trel_state_t get_norm_value (input state_t state_in);
    logic [3 : 0] eq;
  begin
    // detect overflow type
    eq = '0;
    for (int state = 0; state < 8; state++) begin
      eq[0] |= (state_in[state][cSTATE_W-1 : cSTATE_W-2] == 2'b00);
      eq[1] |= (state_in[state][cSTATE_W-1 : cSTATE_W-2] == 2'b01);
      eq[2] |= (state_in[state][cSTATE_W-1 : cSTATE_W-2] == 2'b10);
      eq[3] |= (state_in[state][cSTATE_W-1 : cSTATE_W-2] == 2'b11);
    end
    //
    get_norm_value = '0;
    if (eq[3] & !eq[0]) begin
      get_norm_value = (2'b01 << (cSTATE_W-2));
    end
    else if (eq[2]) begin
      get_norm_value = (2'b10 << (cSTATE_W-2));
    end
    else if (eq[1]) begin
      get_norm_value = (2'b11 << (cSTATE_W-2));
    end
  end
  endfunction

  function state_t normalize (input state_t state_in, input trel_state_t nvalue);
    for (int state = 0; state < 8; state++) begin
      normalize[state] = state_in[state] + nvalue;
    end
  endfunction

  function gamma_t gnormalize (input gamma_t gamma, input trel_state_t nvalue);
    for (int state = 0; state < 8; state++) begin
      for (int inb = 0; inb < 4; inb++) begin
        gnormalize[state][inb] = gamma[state][inb] + nvalue;
      end
    end
  endfunction

endmodule
