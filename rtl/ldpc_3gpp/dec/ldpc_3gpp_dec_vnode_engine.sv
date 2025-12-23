/*


  parameter bit pIDX_GR       =  0 ;
  parameter int pCODE         = 46 ;
  //
  parameter int pLLR_W        =  8 ;
  parameter int pNODE_W       =  8 ;
  //
  parameter int pROW_BY_CYCLE =  8 ;
  //
  parameter bit pNORM_FACTOR  =  7 ;
  parameter bit pUSE_SC_MODE  =  1 ;



  logic        ldpc_3gpp_dec_vnode_engine__iclk                    ;
  logic        ldpc_3gpp_dec_vnode_engine__ireset                  ;
  logic        ldpc_3gpp_dec_vnode_engine__iclkena                 ;
  //
  hb_row_t     ldpc_3gpp_dec_vnode_engine__iused_row               ;
  //
  logic        ldpc_3gpp_dec_vnode_engine__ival                    ;
  strb_t       ldpc_3gpp_dec_vnode_engine__istrb                   ;
  llr_t        ldpc_3gpp_dec_vnode_engine__iLLR                    ;
  node_t       ldpc_3gpp_dec_vnode_engine__icnode  [pROW_BY_CYCLE] ;
  logic        ldpc_3gpp_dec_vnode_engine__icmask  [pROW_BY_CYCLE] ;
  node_state_t ldpc_3gpp_dec_vnode_engine__icstate [pROW_BY_CYCLE] ;
  //
  logic        ldpc_3gpp_dec_vnode_engine__oval                    ;
  strb_t       ldpc_3gpp_dec_vnode_engine__ostrb                   ;
  node_t       ldpc_3gpp_dec_vnode_engine__ovnode  [pROW_BY_CYCLE] ;
  node_state_t ldpc_3gpp_dec_vnode_engine__ovstate [pROW_BY_CYCLE] ;
  //
  logic        ldpc_3gpp_dec_vnode_engine__obitsop                 ;
  logic        ldpc_3gpp_dec_vnode_engine__obitval                 ;
  logic        ldpc_3gpp_dec_vnode_engine__obiteop                 ;
  logic        ldpc_3gpp_dec_vnode_engine__obitdat                 ;
  logic        ldpc_3gpp_dec_vnode_engine__obiterr                 ;



  ldpc_3gpp_dec_vnode_engine
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pCODE         ( pCODE         ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pNORM_FACTOR  ( pNORM_FACTOR  ) ,
    .pUSE_SC_MODE  ( pUSE_SC_MODE  )
  )
  ldpc_3gpp_dec_vnode_engine
  (
    .iclk      ( ldpc_3gpp_dec_vnode_engine__iclk      ) ,
    .ireset    ( ldpc_3gpp_dec_vnode_engine__ireset    ) ,
    .iclkena   ( ldpc_3gpp_dec_vnode_engine__iclkena   ) ,
    //
    .iused_row ( ldpc_3gpp_dec_vnode_engine__iused_row ) ,
    //
    .ival      ( ldpc_3gpp_dec_vnode_engine__ival      ) ,
    .istrb     ( ldpc_3gpp_dec_vnode_engine__istrb     ) ,
    .iLLR      ( ldpc_3gpp_dec_vnode_engine__iLLR      ) ,
    .icnode    ( ldpc_3gpp_dec_vnode_engine__icnode    ) ,
    .icmask    ( ldpc_3gpp_dec_vnode_engine__icmask    ) ,
    .icstate   ( ldpc_3gpp_dec_vnode_engine__icstate   ) ,
    //
    .oval      ( ldpc_3gpp_dec_vnode_engine__oval      ) ,
    .ostrb     ( ldpc_3gpp_dec_vnode_engine__ostrb     ) ,
    .ovnode    ( ldpc_3gpp_dec_vnode_engine__ovnode    ) ,
    .ovstate   ( ldpc_3gpp_dec_vnode_engine__ovstate   ) ,
    //
    .obitsop   ( ldpc_3gpp_dec_vnode_engine__obitsop   ) ,
    .obitval   ( ldpc_3gpp_dec_vnode_engine__obitval   ) ,
    .obiteop   ( ldpc_3gpp_dec_vnode_engine__obiteop   ) ,
    .obitdat   ( ldpc_3gpp_dec_vnode_engine__obitdat   ) ,
    .obiterr   ( ldpc_3gpp_dec_vnode_engine__obiterr   )
  );


  assign ldpc_3gpp_dec_vnode_engine__iclk      = '0 ;
  assign ldpc_3gpp_dec_vnode_engine__ireset    = '0 ;
  assign ldpc_3gpp_dec_vnode_engine__iclkena   = '0 ;
  //
  assign ldpc_3gpp_dec_vnode_engine__iused_row = '0 ;
  //
  assign ldpc_3gpp_dec_vnode_engine__ival      = '0 ;
  assign ldpc_3gpp_dec_vnode_engine__istrb     = '0 ;
  assign ldpc_3gpp_dec_vnode_engine__iLLR      = '0 ;
  assign ldpc_3gpp_dec_vnode_engine__icnode    = '0 ;
  assign ldpc_3gpp_dec_vnode_engine__icmask    = '0 ;
  assign ldpc_3gpp_dec_vnode_engine__icstate   = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_vnode_engine.sv
// Description   : LDPC decoder variable node arithmetic eengine: read cnode and count vnode. Count aposteriory L(Qi) = L(Pi) + sum(L(rji) and
//                  vnode update values L(qij)  = L(Pi) + sum(Lrij)|(i ~= j) = L(Qi) - L(rji)|(i == j)
//

module ldpc_3gpp_dec_vnode_engine
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  iused_row ,
  //
  ival      ,
  istrb     ,
  iLLR      ,
  icnode    ,
  icmask    ,
  icstate   ,
  //
  oval      ,
  ostrb     ,
  ovnode    ,
  ovstate   ,
  //
  obitsop   ,
  obitval   ,
  obiteop   ,
  obitdat   ,
  obiterr
);

  parameter int pNORM_FACTOR = 7; // pNORM_FACTOR/8 - normalization factor

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic        iclk                    ;
  input  logic        ireset                  ;
  input  logic        iclkena                 ;
  //
  input  hb_row_t     iused_row               ;
  // input LLR/node interface
  input  logic        ival                    ;
  input  strb_t       istrb                   ;
  input  llr_t        iLLR                    ;
  input  node_t       icnode  [pROW_BY_CYCLE] ;
  input  logic        icmask  [pROW_BY_CYCLE] ;
  input  node_state_t icstate [pROW_BY_CYCLE] ;
  // output node interface
  output logic        oval                    ;
  output strb_t       ostrb                   ;
  output node_t       ovnode  [pROW_BY_CYCLE] ;
  output node_state_t ovstate [pROW_BY_CYCLE] ;
  // output decoded bit interface
  output logic        obitsop                 ;
  output logic        obitval                 ;
  output logic        obiteop                 ;
  output logic        obitdat                 ;
  output logic        obiterr                 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCN_SUM_STAGE_NUM     = $clog2(pROW_BY_CYCLE + pROW_BY_CYCLE[0]);  // +1 for odd pROW_BY_CYCLE 1/3/5/7
  localparam int cCN_SUM_NUM_PER_STAGE = 2**(cCN_SUM_STAGE_NUM-1);

  localparam int cCN_SUM_W             = pNODE_W + $clog2(pCODE);

  localparam int cLOG2_MAX_ROW_NUM     = $clog2(cMAX_ROW_STEP_NUM);

  localparam int cVAR_DELAY_NUN        = cMAX_ROW_STEP_NUM + cCN_SUM_STAGE_NUM;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic signed [cCN_SUM_W-1 : 0] cn_sum_t;

  typedef logic [cLOG2_MAX_ROW_NUM : 0] update_cnt_t; // + 1bit

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         val;
  strb_t        strb;
  node_t        LLR;
  logic         hdLLR;
  node_t        cnode  [pROW_BY_CYCLE];
  node_state_t  cstate [pROW_BY_CYCLE];

  cn_sum_t      LLR_p_cnode0;

  // adder tree
  cn_sum_t      cnode2sum   [2*cCN_SUM_NUM_PER_STAGE];

  logic         LLR_leq_0   [cCN_SUM_STAGE_NUM] ;  // LLR less of equal zero

  logic [cCN_SUM_STAGE_NUM-1 : 0] cn_sum_val                                            ;
  strb_t                          cn_sum_strb [cCN_SUM_STAGE_NUM]                       ;
  cn_sum_t                        cn_sum      [cCN_SUM_STAGE_NUM][cCN_SUM_NUM_PER_STAGE];

  // accumulator
  logic         cn_acc_val  ;
  logic         cn_acc_sop  ;
  logic         cn_acc_eop  ;
  cn_sum_t      cn_acc      ;
  logic         LLR_hd      ;

  // vnode update
  node_t        cnode_var_line  [cVAR_DELAY_NUN][pROW_BY_CYCLE];
  node_state_t  cstate_var_line [cVAR_DELAY_NUN][pROW_BY_CYCLE];

  node_t        cnode2vnode  [pROW_BY_CYCLE];
  node_state_t  cstate2vnode [pROW_BY_CYCLE];
  cn_sum_t      cn_acc2vnode ;

  logic         vnode_update_val;
  strb_t        vnode_update_strb;
  update_cnt_t  vnode_update_cnt; // +1 bit

  logic         vnode_val                  ;
  strb_t        vnode_strb                 ;
  cn_sum_t      vnode      [pROW_BY_CYCLE] ;
  node_state_t  vstate     [pROW_BY_CYCLE] ;

  cn_sum_t      vnode_norm [pROW_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  // prepare data for sum(L(rji))
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= 1'b0;
    end
    else if (iclkena) begin
      val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      strb  <= istrb;
      //
      LLR   <= istrb.sop ? (iLLR <<< pNODE_SCALE_W) : 0;  // align fixed point
      hdLLR <= (iLLR <= 0);                               // share resources from upload data path
      //
      for (int row = 0; row < pROW_BY_CYCLE; row++) begin
        cnode [row] <= icmask [row] ? 0 : icnode [row];
        cstate[row] <= icstate[row];
      end
      // even 2/4/6/8 : compress line stage
      if (!pROW_BY_CYCLE[0]) begin
        LLR_p_cnode0 <= (istrb.sop ? (iLLR <<< pNODE_SCALE_W) : 0) + (icmask[0] ? 0 : icnode[0]);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // L(Qi) = L(Pi) + sum(L(rji))
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    cnode2sum = '{default : '0};
    //
    if (pROW_BY_CYCLE[0]) begin // odd 1/3/5/7
      cnode2sum[0] = LLR;
      //
      for (int row = 0; row < pROW_BY_CYCLE; row++) begin
        cnode2sum[1 + row] = cnode[row];
      end
    end
    else begin
      cnode2sum[0] = LLR_p_cnode0;
      //
      for (int row = 1; row < pROW_BY_CYCLE; row++) begin
        cnode2sum[row] = cnode[row];
      end
    end
  end

  //
  // adder tree
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      cn_sum_val <= '0;
    end
    else if (iclkena) begin
      cn_sum_val <= (cn_sum_val << 1) | val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int stage = 0; stage < cCN_SUM_STAGE_NUM; stage++) begin
        if (stage == 0) begin
          LLR_leq_0   [stage] <= hdLLR;
          cn_sum_strb [stage] <= strb;
          //
          for (int i = 0; i < cCN_SUM_NUM_PER_STAGE; i++) begin
            cn_sum[stage][i] <= cnode2sum[2*i] + cnode2sum[2*i+1];
          end
        end
        else begin
          LLR_leq_0   [stage] <= LLR_leq_0   [stage-1];
          cn_sum_strb [stage] <= cn_sum_strb [stage-1];
          //
          for (int i = 0; i < (cCN_SUM_NUM_PER_STAGE >> stage); i++) begin
            cn_sum[stage][i] <= cn_sum[stage-1][2*i] + cn_sum[stage-1][2*i+1];
          end
        end
      end
    end
  end

  //
  // accumulator
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      cn_acc_val <= 1'b0;
    end
    else if (iclkena) begin
      cn_acc_val <= cn_sum_val[cCN_SUM_STAGE_NUM-1] & cn_sum_strb[cCN_SUM_STAGE_NUM-1].eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      cn_acc_sop <= cn_sum_strb[cCN_SUM_STAGE_NUM-1].sof & cn_sum_strb[cCN_SUM_STAGE_NUM-1].eop;  // LLR payload end
      cn_acc_eop <= cn_sum_strb[cCN_SUM_STAGE_NUM-1].eof & cn_sum_strb[cCN_SUM_STAGE_NUM-1].eop;
      //
      if (cn_sum_val[cCN_SUM_STAGE_NUM-1]) begin
        if (cn_sum_strb[cCN_SUM_STAGE_NUM-1].sop) begin
          cn_acc <= cn_sum[cCN_SUM_STAGE_NUM-1][0];
        end
        else begin
          cn_acc <= cn_acc + cn_sum[cCN_SUM_STAGE_NUM-1][0];
        end
      end
      //
      if (cn_sum_val[cCN_SUM_STAGE_NUM-1] & cn_sum_strb[cCN_SUM_STAGE_NUM-1].sop) begin
        LLR_hd <= LLR_leq_0[cCN_SUM_STAGE_NUM-1];
      end
    end // iclkena
  end // iclk

  //------------------------------------------------------------------------------------------------------
  // aposteriory LLR decoding
  // metric is inverted (minus zero occured) -> 0 metric is 1'b1 too
  //------------------------------------------------------------------------------------------------------

  assign obitdat = cn_acc[cCN_SUM_W-1];
  assign obiterr = cn_acc[cCN_SUM_W-1] ^ LLR_hd;  // metric is inverted (minus zero occured) -> 0 metric is 1'b1

  assign obitsop = cn_acc_sop;
  assign obitval = cn_acc_val;
  assign obiteop = cn_acc_eop;

  //------------------------------------------------------------------------------------------------------
  // L(qij) = = L(Qi) - L(rji)|(i == j)
  //------------------------------------------------------------------------------------------------------

  localparam int cVAR_DELAY_IDX_W = $clog2(cVAR_DELAY_NUN);

  logic [cVAR_DELAY_IDX_W-1 : 0] var_line_idx;

  // variable shift register for cnode/cstate update context with dynamic constant offset
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int idx = 0; idx < cVAR_DELAY_NUN; idx++) begin
        cstate_var_line [idx] <= (idx == 0) ? cstate : cstate_var_line [idx-1];
        cnode_var_line  [idx] <= (idx == 0) ? cnode  : cnode_var_line  [idx-1];
      end
      // is constant for decoded block
      var_line_idx <= cCN_SUM_STAGE_NUM + iused_row - 1;
      //
      cstate2vnode <= cstate_var_line[var_line_idx];
      cnode2vnode  <= cnode_var_line [var_line_idx];
    end
  end

  //
  // regenerate vnode interface signals
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      vnode_update_cnt <= '0;
      vnode_update_cnt[$high(vnode_update_cnt)] <= 1'b1;
    end
    else if (iclkena) begin
      if (cn_acc_val) begin
        vnode_update_cnt <= iused_row - 1;
      end
      else if (vnode_update_val) begin
        vnode_update_cnt <= vnode_update_cnt - 1'b1;
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      vnode_update_strb.sop <= cn_acc_val;
      //
      if (cn_acc_val) begin
        cn_acc2vnode          <= cn_acc;
        vnode_update_strb.sof <= cn_acc_sop;
        vnode_update_strb.eof <= cn_acc_eop;
      end
    end
  end

  assign vnode_update_val       = !vnode_update_cnt[$high(vnode_update_cnt)];
  assign vnode_update_strb.eop  = (vnode_update_cnt == 0);

  //------------------------------------------------------------------------------------------------------
  // L(qij) = = L(Qi) - L(rji)|(i == j)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      vnode_val <= 1'b0;
      oval      <= 1'b0;
    end
    else if (iclkena) begin
      vnode_val <= vnode_update_val;
      oval      <= vnode_val;
    end
  end

  // count vnode
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      vnode_strb <= vnode_update_strb;
      //
      for (int row = 0; row < pROW_BY_CYCLE; row++) begin
        vstate [row] <=                cstate2vnode[row];
        vnode  [row] <= cn_acc2vnode - cnode2vnode [row];
      end
    end
  end

  // normalize & do self correction
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostrb <= vnode_strb;
      //
      for (int row = 0; row < pROW_BY_CYCLE; row++) begin
        vnode_norm[row] <= normalize(vnode[row]);
        //
        if (pUSE_SC_MODE) begin
          ovstate[row].pre_sign <= vnode[row][cCN_SUM_W-1];
          ovstate[row].pre_zero <= 1'b0;
          //
          if (!vstate[row].pre_zero) begin // if was not zero
            if (vstate[row].pre_sign ^ vnode[row][cCN_SUM_W-1]) begin // sign change -> clear vnode
              ovstate   [row].pre_sign <= 1'b0;
              ovstate   [row].pre_zero <= 1'b1;
              vnode_norm[row]          <= '0;
            end
          end
        end // pUSE_SC_MODE
      end // row
    end // iclkena
  end // iclk

  //
  // saturate vnode
  //  register for ovnode is outside
  always_comb begin
    for (int row = 0; row < pROW_BY_CYCLE; row++) begin
      ovnode [row] = saturate(vnode_norm[row]);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  function automatic cn_sum_t normalize (input cn_sum_t dat);
    logic signed [cCN_SUM_W+2 : 0] tmp; // +3 bit
    logic mask;
  begin
    if (pNORM_FACTOR[0]) begin
      mask = (dat[1 : 0] == 0) & dat[$high(dat)];
    end
    else begin
      mask = (dat[0] == 0) & dat[$high(dat)];
    end
    //
    if (pNORM_FACTOR != 0) begin
      case (pNORM_FACTOR)
        1       : begin // 0.125
          tmp = dat + (mask ? 0 : 4);
        end
        2       : begin // 0.25
          tmp = (dat <<< 1) + (mask ? 0 : 4);
        end
        3       : begin // 0.375
          tmp = (dat <<< 1) + dat + (mask ? 0 : 4);
        end
        4       : begin // 0.5 (exception point)
          mask = (dat[0] == 1) & dat[$high(dat)];
          //
          tmp = (dat <<< 2) + (mask ? 0 : 4);
        end
        5       : begin // 0.625
          tmp = (dat <<< 2) + dat + (mask ? 0 : 4);
        end
        6       : begin // 0.75
          tmp = (dat <<< 2) + (dat <<< 1) + (mask ? 0 : 4);
        end
        7       : begin // 0.875
          tmp = (dat <<< 3) - dat + (mask ? 0 : 4);
        end
        default : begin // no normalization
          tmp = (dat <<< 3);
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

    saturate  = overflow ? {sign, {(pNODE_W-2){~sign}}, 1'b1} : dat[pNODE_W-1 : 0];
  end
  endfunction

endmodule
