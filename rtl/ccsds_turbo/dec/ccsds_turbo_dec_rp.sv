/*



  parameter bit pB_nF        = 0 ;
  parameter int pLLR_W       = 5 ;
  parameter int pLLR_FP      = 3 ;
  parameter int pMMAX_TYPE   = 0 ;



  logic           ccsds_turbo_dec_rp__iclk        ;
  logic           ccsds_turbo_dec_rp__ireset      ;
  logic           ccsds_turbo_dec_rp__iclkena     ;
  logic   [1 : 0] ccsds_turbo_dec_rp__icode       ;
  logic           ccsds_turbo_dec_rp__istate_clr  ;
  logic           ccsds_turbo_dec_rp__ival        ;
  gamma_t         ccsds_turbo_dec_rp__igamma      ;
  logic           ccsds_turbo_dec_rp__oval        ;
  state_t         ccsds_turbo_dec_rp__ostate      ;
  gamma_t         ccsds_turbo_dec_rp__ogamma      ;
  state_t         ccsds_turbo_dec_rp__ostate2mm   ;



  ccsds_turbo_dec_rp
  #(
    .pB_nF      ( pB_nF      ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  ccsds_turbo_dec_rp
  (
    .iclk        ( ccsds_turbo_dec_rp__iclk        ) ,
    .ireset      ( ccsds_turbo_dec_rp__ireset      ) ,
    .iclkena     ( ccsds_turbo_dec_rp__iclkena     ) ,
    .icode       ( ccsds_turbo_dec_rp__icode       ) ,
    .istate_clr  ( ccsds_turbo_dec_rp__istate_clr  ) ,
    .ival        ( ccsds_turbo_dec_rp__ival        ) ,
    .igamma      ( ccsds_turbo_dec_rp__igamma      ) ,
    .oval        ( ccsds_turbo_dec_rp__oval        ) ,
    .ostate      ( ccsds_turbo_dec_rp__ostate      ) ,
    .ogamma      ( ccsds_turbo_dec_rp__ogamma      ) ,
    .ostate2mm   ( ccsds_turbo_dec_rp__ostate2mm   ) ,
    .ostate_last ( ccsds_turbo_dec_rp__ostate_last )
  );


  assign ccsds_turbo_dec_rp__iclk       = '0 ;
  assign ccsds_turbo_dec_rp__ireset     = '0 ;
  assign ccsds_turbo_dec_rp__iclkena    = '0 ;
  assign ccsds_turbo_dec_rp__icode      = '0 ;
  assign ccsds_turbo_dec_rp__istate_clr = '0 ;
  assign ccsds_turbo_dec_rp__istate     = '0 ;
  assign ccsds_turbo_dec_rp__ival       = '0 ;
  assign ccsds_turbo_dec_rp__igamma     = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_rp.sv
// Description   : recursive processor for state metrics with module ariphmetic
//                 Module latency is 1 tick
//

module ccsds_turbo_dec_rp
#(
  parameter bit pB_nF       = 0 ,  // 0/1 - forward/backward recursion
  parameter int pLLR_W      = 5 ,
  parameter int pLLR_FP     = 3 ,
  parameter int pMMAX_TYPE  = 1
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  icode       ,
  istate_clr  ,
  //
  ival        ,
  igamma      ,
  //
  oval        ,
  ostate      ,
  ogamma      ,
  ostate2mm
);

  `include "../ccsds_turbo_parameters.svh"
  `include "../ccsds_turbo_trellis.svh"

  `include "ccsds_turbo_dec_types.svh"
  `include "ccsds_turbo_mmax.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk       ;
  input  logic         ireset     ;
  input  logic         iclkena    ;
  //
  input  logic [1 : 0] icode      ;
  input  logic         istate_clr ; // clear init state
  //
  input  logic         ival       ;
  input  gamma_t       igamma     ; // gamma(s, s')
  //
  output logic         oval       ;
  output state_t       ostate     ; // alpha[k+1] / beta[k]
  //
  output gamma_t       ogamma     ; // alpha(s, k) * gamma(s, s') / beta(s, k) * gamma(s, s')
  output state_t       ostate2mm  ; // alpha[k] / beta[k+1]

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  gamma_t   gamma;
  state_t   state;
  state_t   next_state;

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
        for (int i = 1; i < cSTATE_NUM; i++) begin
          state[i] <= '0;
        end
        //
        state[0] <= 4*(2**(pLLR_W-1));
        case (icode)
          cCODE_1by2 : state[0] <= 1*(2**(pLLR_W-1));
          cCODE_1by3 : state[0] <= 2*(2**(pLLR_W-1));
          cCODE_1by4 : state[0] <= 3*(2**(pLLR_W-1));
          cCODE_1by6 : state[0] <= 4*(2**(pLLR_W-1));
        endcase
      end
      else if (ival) begin
        state <= next_state;
      end
      //
      ogamma      <= gnormalize(gamma, norm_value);
      ostate2mm   <=  normalize(state, norm_value);
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
    for (int state = 0; state < cSTATE_NUM; state++) begin
      for (int inb = 0; inb < cBIT_NUM; inb++) begin
        gamma_p_alpha[state][inb] = gamma[state][inb] + alpha_in[state];
      end
    end
  endfunction

  // alpha(s', k+1) = sum(alpha(s, k) * gamma(s, s'))
  function state_t get_next_alpha (input gamma_t gamma);
    for (int nstate = 0; nstate < cSTATE_NUM; nstate++) begin
      get_next_alpha[nstate] =  st_m_mmax  (gamma[trel.preStates[nstate][0]][0], gamma[trel.preStates[nstate][1]][1]);
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // functions for beta recursions
  //------------------------------------------------------------------------------------------------------

  // beta(s, k) * gamma(s, s')
  function gamma_t gamma_p_beta (input gamma_t gamma, input state_t beta_in);
    for (int state = 0; state < cSTATE_NUM; state++) begin
      for (int inb = 0; inb < cBIT_NUM; inb++) begin
        gamma_p_beta[state][inb] = gamma[state][inb] + beta_in[trel.nextStates[state][inb]];
      end
    end
  endfunction

  // sum(beta(s', k+1) * gamma(s, s'))
  function state_t get_next_beta (input gamma_t gamma);
    for (int state = 0; state < cSTATE_NUM; state++) begin
      get_next_beta[state] =  st_m_mmax (gamma[state][0], gamma[state][1]);
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
    for (int state = 0; state < cSTATE_NUM; state++) begin
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
    for (int state = 0; state < cSTATE_NUM; state++) begin
      normalize[state] = state_in[state] + nvalue;
    end
  endfunction

  function gamma_t gnormalize (input gamma_t gamma, input trel_state_t nvalue);
    for (int state = 0; state < cSTATE_NUM; state++) begin
      for (int inb = 0; inb < cBIT_NUM; inb++) begin
        gnormalize[state][inb] = gamma[state][inb] + nvalue;
      end
    end
  endfunction

endmodule
