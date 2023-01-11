/*



  parameter int pLLR_W         = 1 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_W        = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;
  parameter bit pUSE_NORM      = 1 ;
  parameter bit pUSE_SC_MODE   = 0 ;



  logic        gsfc_ldpc_dec_vnode_engine__iclk             ;
  logic        gsfc_ldpc_dec_vnode_engine__ireset           ;
  logic        gsfc_ldpc_dec_vnode_engine__iclkena          ;
  logic        gsfc_ldpc_dec_vnode_engine__isop             ;
  logic        gsfc_ldpc_dec_vnode_engine__ival             ;
  logic        gsfc_ldpc_dec_vnode_engine__ieop             ;
  llr_t        gsfc_ldpc_dec_vnode_engine__iLLR             ;
  node_t       gsfc_ldpc_dec_vnode_engine__icnode  [pC][pW] ;
  node_state_t gsfc_ldpc_dec_vnode_engine__icstate [pC]     ;
  logic        gsfc_ldpc_dec_vnode_engine__osop             ;
  logic        gsfc_ldpc_dec_vnode_engine__oval             ;
  logic        gsfc_ldpc_dec_vnode_engine__oeop             ;
  node_t       gsfc_ldpc_dec_vnode_engine__ovnode  [pC][pW] ;
  node_state_t gsfc_ldpc_dec_vnode_engine__ovstate [pC]     ;
  logic        gsfc_ldpc_dec_vnode_engine__obitsop          ;
  logic        gsfc_ldpc_dec_vnode_engine__obitval          ;
  logic        gsfc_ldpc_dec_vnode_engine__obiteop          ;
  logic        gsfc_ldpc_dec_vnode_engine__obitdat          ;
  logic        gsfc_ldpc_dec_vnode_engine__obiterr          ;



  gsfc_ldpc_dec_vnode_engine
  #(
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pUSE_NORM      ( pUSE_NORM      ) ,
    .pUSE_SC_MODE   ( pUSE_SC_MODE   )
  )
  gsfc_ldpc_dec_vnode_engine
  (
    .iclk    ( gsfc_ldpc_dec_vnode_engine__iclk    ) ,
    .ireset  ( gsfc_ldpc_dec_vnode_engine__ireset  ) ,
    .iclkena ( gsfc_ldpc_dec_vnode_engine__iclkena ) ,
    .isop    ( gsfc_ldpc_dec_vnode_engine__isop    ) ,
    .ival    ( gsfc_ldpc_dec_vnode_engine__ival    ) ,
    .ieop    ( gsfc_ldpc_dec_vnode_engine__ieop    ) ,
    .iLLR    ( gsfc_ldpc_dec_vnode_engine__iLLR    ) ,
    .icnode  ( gsfc_ldpc_dec_vnode_engine__icnode  ) ,
    .icstate ( gsfc_ldpc_dec_vnode_engine__icstate ) ,
    .osop    ( gsfc_ldpc_dec_vnode_engine__osop    ) ,
    .oval    ( gsfc_ldpc_dec_vnode_engine__oval    ) ,
    .oeop    ( gsfc_ldpc_dec_vnode_engine__oeop    ) ,
    .ovnode  ( gsfc_ldpc_dec_vnode_engine__ovnode  ) ,
    .ovstate ( gsfc_ldpc_dec_vnode_engine__ovstate ) ,
    .obitsop ( gsfc_ldpc_dec_vnode_engine__obitsop ) ,
    .obitval ( gsfc_ldpc_dec_vnode_engine__obitval ) ,
    .obiteop ( gsfc_ldpc_dec_vnode_engine__obiteop ) ,
    .obitdat ( gsfc_ldpc_dec_vnode_engine__obitdat ) ,
    .obiterr ( gsfc_ldpc_dec_vnode_engine__obiterr )
  );


  assign gsfc_ldpc_dec_vnode_engine__iclk    = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__ireset  = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__iclkena = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__isop    = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__ival    = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__ieop    = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__iLLR    = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__icnode  = '0 ;
  assign gsfc_ldpc_dec_vnode_engine__icstate = '0 ;



*/

//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_dec_vnode_engine.v
// Description   : LDPC decoder variable node arithmetic eengine: read cnode and count vnode. Count aposteriory  L(Qi)   = L(Pi) + sum(L(rji) and
//                  vnode update values L(qij)  = L(Pi) + sum(Lrij)|(i ~= j) = L(Qi) - L(rji)|(i == j)
//


module gsfc_ldpc_dec_vnode_engine
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  iLLR    ,
  icnode  ,
  icstate ,
  //
  osop    ,
  oval    ,
  oeop    ,
  ovnode  ,
  ovstate ,
  //
  obitsop ,
  obitval ,
  obiteop ,
  obitdat ,
  obiterr
);

  parameter bit pUSE_NORM = 1;  // use normalization

  `include "../gsfc_ldpc_parameters.svh"
  `include "gsfc_ldpc_dec_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic        iclk             ;
  input  logic        ireset           ;
  input  logic        iclkena          ;
  //
  input  logic        isop             ;
  input  logic        ival             ;
  input  logic        ieop             ;
  input  llr_t        iLLR             ;
  input  node_t       icnode  [pC][pW] ;
  input  node_state_t icstate [pC][pW] ;
  //
  output logic        osop             ;
  output logic        oval             ;
  output logic        oeop             ;
  output node_t       ovnode  [pC][pW] ;
  output node_state_t ovstate [pC][pW] ;
  //
  output logic        obitsop          ;
  output logic        obitval          ;
  output logic        obiteop          ;
  output logic        obitdat          ;
  output logic        obiterr          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCN_SUM_STAGE_NUM     = $clog2(pC*pW+1);
  localparam int cCN_SUM_NUM_PER_STAGE = 2**(cCN_SUM_STAGE_NUM-1);

  localparam int cCN_SUM_W             = pNODE_W + cCN_SUM_STAGE_NUM;

  typedef logic signed [cCN_SUM_W-1 : 0] cn_sum_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  node_t        cnode2sum   [2*cCN_SUM_NUM_PER_STAGE];

  node_t        cnode       [cCN_SUM_STAGE_NUM][pC][pW] ;
  node_state_t  cstate      [cCN_SUM_STAGE_NUM][pC][pW] ;
  logic         LLR_leq_0   [cCN_SUM_STAGE_NUM]         ;  // LLR less of equal zero

  cn_sum_t      cn_sum      [cCN_SUM_STAGE_NUM][cCN_SUM_NUM_PER_STAGE];

  cn_sum_t      vnode       [pC][pW];
  node_state_t  vnode_state [pC][pW];
  cn_sum_t      vnode_norm  [pC][pW];

  logic  [cCN_SUM_STAGE_NUM : 0] sop  ; // + 1 bit
  logic  [cCN_SUM_STAGE_NUM : 0] eop  ;
  logic  [cCN_SUM_STAGE_NUM : 0] val  ;

  //------------------------------------------------------------------------------------------------------
  // controls
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | isop;
      eop <= (eop << 1) | ieop;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // L(Qi) = L(Pi) + sum(L(rji)
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int i = 0; i < 2*cCN_SUM_NUM_PER_STAGE; i++) begin
      if (i == 0) begin
        cnode2sum[i] = iLLR <<< (pNODE_W - pLLR_W); // align fixed point
      end
      else if (i < (pC*pW + 1)) begin
        cnode2sum[i] = icnode[(i-1) % pW][(i-1) / pC];
      end
      else begin
        cnode2sum[i] = '0;
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int stage = 0; stage < cCN_SUM_STAGE_NUM; stage++) begin
        if (stage == 0) begin
          cnode     [stage] <= icnode;
          cstate    [stage] <= icstate;
          LLR_leq_0 [stage] <= (iLLR <= 0);
          for (int i = 0; i < cCN_SUM_NUM_PER_STAGE; i++) begin
            cn_sum[stage][i] <= cnode2sum[2*i] + cnode2sum[2*i+1];
          end
        end
        else begin
          cnode     [stage] <= cnode     [stage-1];
          cstate    [stage] <= cstate    [stage-1];
          LLR_leq_0 [stage] <= LLR_leq_0 [stage-1];
          for (int i = 0; i < (cCN_SUM_NUM_PER_STAGE >> stage); i++) begin
            cn_sum[stage][i] <= cn_sum[stage-1][2*i] + cn_sum[stage-1][2*i+1];
          end
        end
      end // stage
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // L(qij) = = L(Qi) - L(rji)|(i == j)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int c = 0; c < pC; c++) begin
        for (int w = 0; w < pW; w++) begin
          vnode_state [c][w] <= cstate[cCN_SUM_STAGE_NUM-1][c][w];
          vnode       [c][w] <= cn_sum[cCN_SUM_STAGE_NUM-1][0] - cnode[cCN_SUM_STAGE_NUM-1][c][w];
        end
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= val[cCN_SUM_STAGE_NUM];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop  <= sop[cCN_SUM_STAGE_NUM];
      oeop  <= eop[cCN_SUM_STAGE_NUM];
      for (int c = 0; c < pC; c++) begin
        for (int w = 0; w < pW; w++) begin
          if (pUSE_SC_MODE & !vnode_state[c][w].pre_zero & (vnode_state[c][w].pre_sign ^ vnode[c][w][cCN_SUM_W-1])) begin // not zero and sign changed
            vnode_norm[c][w] <= '0;
          end
          else begin
            vnode_norm[c][w] <= normalize(vnode[c][w]);
          end
        end
      end
    end
  end

  // register for ovnode is outside
  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int w = 0; w < pW; w++) begin
        ovstate[c][w].pre_sign = pUSE_SC_MODE &  vnode_norm[c][w][cCN_SUM_W-1];
        ovstate[c][w].pre_zero = pUSE_SC_MODE & (vnode_norm[c][w] == 0);
        ovnode [c][w]          = saturate(vnode_norm[c][w]);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // aposteriory LLR decoding
  // metric is inverted (minus zero occured) -> 0 metric is 1'b1 too
  //------------------------------------------------------------------------------------------------------

  assign obitdat = cn_sum[cCN_SUM_STAGE_NUM-1][0][cCN_SUM_W-1];
  assign obiterr = cn_sum[cCN_SUM_STAGE_NUM-1][0][cCN_SUM_W-1] ^ LLR_leq_0[cCN_SUM_STAGE_NUM-1];  // metric is inverted (minus zero occured) -> 0 metric is 1'b1

  assign obitsop = sop[cCN_SUM_STAGE_NUM-1];
  assign obitval = val[cCN_SUM_STAGE_NUM-1];
  assign obiteop = eop[cCN_SUM_STAGE_NUM-1];

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  function automatic cn_sum_t normalize (input cn_sum_t dat);
    logic signed [cCN_SUM_W+2 : 0] tmp; // +3 bit
  begin
    if (pUSE_NORM) begin
      case (cNORM_FACTOR)
        4       : begin // 0.5
          tmp = (dat <<< 2) + 4;
        end
        5       : begin // 0.625
          tmp = (dat <<< 2) + dat + 4;
        end
        6       : begin // 0.75
          tmp = (dat <<< 2) + (dat <<< 1) + 4;
        end
        default : begin //0.875
//        tmp = (dat <<< 3) - dat + (dat[cCN_SUM_W-1] ? 3 : 4);
          tmp = (dat <<< 3) - dat + 4;
        end
      endcase
      normalize = tmp[cCN_SUM_W+2 : 3];
    end
    else begin
      normalize = dat;
    end
  end
  endfunction

  function automatic node_t saturate (input cn_sum_t dat);
    logic                           sign;
    logic [cCN_SUM_W-1 : pNODE_W-1] sbits;
    logic                           overflow;
  begin
    sign      = dat[cCN_SUM_W-1];

    sbits     = sign ? ~dat[cCN_SUM_W-1 : pNODE_W-1] : dat[cCN_SUM_W-1 : pNODE_W-1];

    overflow  = (sbits != 0);

    saturate  = overflow ? {sign, {(pNODE_W-1){~sign}}} : dat[pNODE_W-1 : 0];
  end
  endfunction

endmodule
