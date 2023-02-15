/*



  parameter int pPIPE = 1 ;



  logic       ldpc_dvb_dec_hs__iclk              ;
  logic       ldpc_dvb_dec_hs__ireset            ;
  logic       ldpc_dvb_dec_hs__iclkena           ;
  //
  code_ctx_t  ldpc_dvb_dec_hs__icode_ctx         ;
  //
  col_t       ldpc_dvb_dec_hs__oused_col         ;
  col_t       ldpc_dvb_dec_hs__oused_data_col    ;
  row_t       ldpc_dvb_dec_hs__oused_row         ;
  cycle_idx_t ldpc_dvb_dec_hs__ocycle_max_num    ;
  //
  logic       ldpc_dvb_dec_hs__icycle_start      ;
  logic       ldpc_dvb_dec_hs__ic_nv_mode        ;
  logic       ldpc_dvb_dec_hs__icycle_read       ;
  strb_t      ldpc_dvb_dec_hs__icycle_strb       ;
  cycle_idx_t ldpc_dvb_dec_hs__icycle_idx        ;
  //
  logic       ldpc_dvb_dec_hs__ocycle_read       ;
  col_t       ldpc_dvb_dec_hs__ocycle_LLR_raddr  ;
  cycle_idx_t ldpc_dvb_dec_hs__ocycle_node_raddr ;
  //
  strb_t      ldpc_dvb_dec_hs__ocnode_strb       ;
  cnode_ctx_t ldpc_dvb_dec_hs__ocnode_ctx        ;
  //
  strb_t      ldpc_dvb_dec_hs__ovnode_strb       ;
  vnode_ctx_t ldpc_dvb_dec_hs__ovnode_ctx        ;


  ldpc_dvb_dec_hs
  #(
    .pPIPE ( pPIPE )
  )
  ldpc_dvb_dec_hs
  (
    .iclk              ( ldpc_dvb_dec_hs__iclk              ) ,
    .ireset            ( ldpc_dvb_dec_hs__ireset            ) ,
    .iclkena           ( ldpc_dvb_dec_hs__iclkena           ) ,
    //
    .icode_ctx         ( ldpc_dvb_dec_hs__icode_ctx         ) ,
    //
    .oused_col         ( ldpc_dvb_dec_hs__oused_col         ) ,
    .oused_data_col    ( ldpc_dvb_dec_hs__oused_data_col    ) ,
    .oused_row         ( ldpc_dvb_dec_hs__oused_row         ) ,
    .ocycle_max_num    ( ldpc_dvb_dec_hs__ocycle_max_num    ) ,
    //
    .icycle_start      ( ldpc_dvb_dec_hs__icycle_start      ) ,
    .ic_nv_mode        ( ldpc_dvb_dec_hs__ic_nv_mode        ) ,
    .icycle_read       ( ldpc_dvb_dec_hs__icycle_read       ) ,
    .icycle_strb       ( ldpc_dvb_dec_hs__icycle_strb       ) ,
    .icycle_idx        ( ldpc_dvb_dec_hs__icycle_idx        ) ,
    //
    .ocycle_read       ( ldpc_dvb_dec_hs__ocycle_read       ) ,
    .ocycle_LLR_radd   ( ldpc_dvb_dec_hs__ocycle_LLR_raddr  ) ,
    .ocycle_node_raddr ( ldpc_dvb_dec_hs__ocycle_node_raddr ) ,
    //
    .ocnode_strb       ( ldpc_dvb_dec_hs__ocnode_strb       ) ,
    .ocnode_ctx        ( ldpc_dvb_dec_hs__ocnode_ctx        ) ,
    //
    .ovnode_strb       ( ldpc_dvb_dec_hs__ovnode_strb       ) ,
    .ovnode_ctx        ( ldpc_dvb_dec_hs__ovnode_ctx        )
  );


  assign ldpc_dvb_dec_hs__iclk         = '0 ;
  assign ldpc_dvb_dec_hs__ireset       = '0 ;
  assign ldpc_dvb_dec_hs__iclkena      = '0 ;
  assign ldpc_dvb_dec_hs__icode_ctx    = '0 ;
  assign ldpc_dvb_dec_hs__icycle_start = '0 ;
  assign ldpc_dvb_dec_hs__ic_nv_mode   = '0 ;
  assign ldpc_dvb_dec_hs__icycle_read  = '0 ;
  assign ldpc_dvb_dec_hs__icycle_strb  = '0 ;
  assign ldpc_dvb_dec_hs__icycle_idx   = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_hs.sv
// Description   : Hs coe code context based table
//

module ldpc_dvb_dec_hs
(
  iclk              ,
  ireset            ,
  iclkena           ,
  //
  icode_ctx         ,
  //
  oused_col         ,
  oused_data_col    ,
  oused_row         ,
  ocycle_max_num    ,
  //
  icycle_start      ,
  ic_nv_mode        ,
  icycle_read       ,
  icycle_strb       ,
  icycle_idx        ,
  //
  ocycle_read       ,
  ocycle_LLR_raddr  ,
  ocycle_node_raddr ,
  //
  ocnode_strb       ,
  ocnode_ctx        ,
  //
  ovnode_strb       ,
  ovnode_ctx
);

  parameter int pPIPE = 1;

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic       iclk              ;
  input  logic       ireset            ;
  input  logic       iclkena           ;
  //
  input  code_ctx_t  icode_ctx         ;
  //
  output col_t       oused_col         ;
  output col_t       oused_data_col    ;
  output row_t       oused_row         ;
  output cycle_idx_t ocycle_max_num    ;
  //
  input  logic       icycle_start      ;
  input  logic       ic_nv_mode        ;
  input  logic       icycle_read       ;
  input  strb_t      icycle_strb       ;
  input  cycle_idx_t icycle_idx        ;
  //
  output logic       ocycle_read       ;
  output col_t       ocycle_LLR_raddr  ;
  output cycle_idx_t ocycle_node_raddr ;
  //
  output strb_t      ocnode_strb       ;
  output cnode_ctx_t ocnode_ctx        ;
  //
  output strb_t      ovnode_strb       ;
  output vnode_ctx_t ovnode_ctx        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "ldpc_dvb_dec_hs_short_packed.svh"
  `include "ldpc_dvb_dec_hs_large_packed.svh"

  typedef struct packed {
    // vertical step context (col idx += veop)
    col_t       vcol_idx;
    logic       veop;
    cycle_idx_t vpacked_addr;
    // horizontal step context (packed addr == cycle idx, row idx += eop)
    logic       mask_0_bit;
    logic       eop;
    col_t       col_idx;
    shift_t     shift;
  } cycle_ctx_t;

  //------------------------------------------------------------------------------------------------------
  // cycle constanst
  //------------------------------------------------------------------------------------------------------

  assign oused_col      = get_used_col       (icode_ctx);
  assign oused_data_col = get_used_data_col  (icode_ctx);
  assign oused_row      = get_used_row       (icode_ctx);

  assign ocycle_max_num = get_used_cycle_num (icode_ctx);

  //------------------------------------------------------------------------------------------------------
  // cycle context rom reading
  // used offset access to save ROM resourses
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] cycle_ctx_read;
  strb_t        cycle_ctx_strb [2];
  cycle_ctx_t   cycle_ctx_rdat [2];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      cycle_ctx_read <= '0;
    end
    else if (iclkena) begin
      cycle_ctx_read <= (cycle_ctx_read << 1) | icycle_read;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      cycle_ctx_strb[0] <= icycle_strb;
      cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_8BY9_PACKED[icycle_idx], cSHORT_HS_TAB_8BY9_PACKED[icycle_idx]};
      case (icode_ctx.gr)
        cCODEGR_SHORT : begin
          case (icode_ctx.coderate)
            cCODERATE_1by4  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_1BY4_PACKED[icycle_idx], cSHORT_HS_TAB_1BY4_PACKED[icycle_idx]};
            cCODERATE_1by3  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_1BY3_PACKED[icycle_idx], cSHORT_HS_TAB_1BY3_PACKED[icycle_idx]};
            cCODERATE_2by5  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_2BY5_PACKED[icycle_idx], cSHORT_HS_TAB_2BY5_PACKED[icycle_idx]};
            cCODERATE_1by2  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_1BY2_PACKED[icycle_idx], cSHORT_HS_TAB_1BY2_PACKED[icycle_idx]};
            cCODERATE_3by5  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_3BY5_PACKED[icycle_idx], cSHORT_HS_TAB_3BY5_PACKED[icycle_idx]};
            cCODERATE_2by3  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_2BY3_PACKED[icycle_idx], cSHORT_HS_TAB_2BY3_PACKED[icycle_idx]};
            cCODERATE_3by4  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_3BY4_PACKED[icycle_idx], cSHORT_HS_TAB_3BY4_PACKED[icycle_idx]};
            cCODERATE_4by5  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_4BY5_PACKED[icycle_idx], cSHORT_HS_TAB_4BY5_PACKED[icycle_idx]};
            cCODERATE_5by6  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_5BY6_PACKED[icycle_idx], cSHORT_HS_TAB_5BY6_PACKED[icycle_idx]};
            cCODERATE_8by9  : cycle_ctx_rdat[0] <= {cSHORT_HS_V_TAB_8BY9_PACKED[icycle_idx], cSHORT_HS_TAB_8BY9_PACKED[icycle_idx]};
          endcase
        end
        //
        cCODEGR_LARGE : begin
          case (icode_ctx.coderate)
            cCODERATE_1by4  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_1BY4_PACKED [icycle_idx], cLARGE_HS_TAB_1BY4_PACKED [icycle_idx]};
            cCODERATE_1by3  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_1BY3_PACKED [icycle_idx], cLARGE_HS_TAB_1BY3_PACKED [icycle_idx]};
            cCODERATE_2by5  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_2BY5_PACKED [icycle_idx], cLARGE_HS_TAB_2BY5_PACKED [icycle_idx]};
            cCODERATE_1by2  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_1BY2_PACKED [icycle_idx], cLARGE_HS_TAB_1BY2_PACKED [icycle_idx]};
            cCODERATE_3by5  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_3BY5_PACKED [icycle_idx], cLARGE_HS_TAB_3BY5_PACKED [icycle_idx]};
            cCODERATE_2by3  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_2BY3_PACKED [icycle_idx], cLARGE_HS_TAB_2BY3_PACKED [icycle_idx]};
            cCODERATE_3by4  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_3BY4_PACKED [icycle_idx], cLARGE_HS_TAB_3BY4_PACKED [icycle_idx]};
            cCODERATE_4by5  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_4BY5_PACKED [icycle_idx], cLARGE_HS_TAB_4BY5_PACKED [icycle_idx]};
            cCODERATE_5by6  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_5BY6_PACKED [icycle_idx], cLARGE_HS_TAB_5BY6_PACKED [icycle_idx]};
            cCODERATE_8by9  : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_8BY9_PACKED [icycle_idx], cLARGE_HS_TAB_8BY9_PACKED [icycle_idx]};
            cCODERATE_9by10 : cycle_ctx_rdat[0] <= {cLARGE_HS_V_TAB_9BY10_PACKED[icycle_idx], cLARGE_HS_TAB_9BY10_PACKED[icycle_idx]};
          endcase
        end
      endcase
      //
      cycle_ctx_strb[1] <= cycle_ctx_strb[0];
      cycle_ctx_rdat[1] <= cycle_ctx_rdat[0];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  logic  used_cycle_ctx_read;
  strb_t used_cycle_ctx_strb;

  assign used_cycle_ctx_read = cycle_ctx_read[pPIPE];
  assign used_cycle_ctx_strb = cycle_ctx_strb[pPIPE];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ocycle_read <= 1'b0;
    end
    else if (iclkena) begin
      ocycle_read <= used_cycle_ctx_read;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      //
      // cycle controls
      if (icycle_start) begin
        ocycle_LLR_raddr  <= '0;
        ocycle_node_raddr <= '1;  // -1 offset
      end
      else if (used_cycle_ctx_read) begin
        if (ic_nv_mode) begin // horizontal step
          ocycle_LLR_raddr  <= cycle_ctx_rdat[pPIPE].col_idx;
          ocycle_node_raddr <= ocycle_node_raddr + 1'b1;
        end
        else begin
          ocycle_LLR_raddr  <= cycle_ctx_rdat[pPIPE].vcol_idx;
          ocycle_node_raddr <= cycle_ctx_rdat[pPIPE].vpacked_addr;
        end
      end
      //
      // cnode controls
      ocnode_strb.sof <= used_cycle_ctx_strb.sof;
      ocnode_strb.eof <= used_cycle_ctx_strb.eof;
      //
      ocnode_strb.eop <= cycle_ctx_rdat[pPIPE].eop;
      //
      // regenerate sop
      if (icycle_start | ocnode_strb.eop) begin
        ocnode_strb.sop <= 1'b1;
      end
      else if (ocycle_read) begin
        ocnode_strb.sop <= 1'b0;
      end
      //
      ocnode_ctx.mask_0_bit <= cycle_ctx_rdat[pPIPE].mask_0_bit;
      ocnode_ctx.shift      <= cycle_ctx_rdat[pPIPE].shift;
      //
      // vnode controls
      ovnode_strb.sof <= used_cycle_ctx_strb.sof;
      ovnode_strb.eof <= used_cycle_ctx_strb.eof;
      //
      ovnode_strb.eop <= cycle_ctx_rdat[pPIPE].veop;
      //
      // regenerate sop
      if (icycle_start | ovnode_strb.eop) begin
        ovnode_strb.sop <= 1'b1;
      end
      else if (ocycle_read) begin
        ovnode_strb.sop <= 1'b0;
      end
    end
  end

  assign ovnode_ctx.col_idx = ocycle_LLR_raddr;
  assign ovnode_ctx.paddr   = ocycle_node_raddr;

  //------------------------------------------------------------------------------------------------------
  // function to get cycle max num
  //------------------------------------------------------------------------------------------------------

  function automatic int get_used_cycle_num (code_ctx_t code_ctx);
  begin
    case (code_ctx.gr)
      cCODEGR_SHORT : begin
        case (code_ctx.coderate)
          cCODERATE_1by4  : get_used_cycle_num = cSHORT_HS_TAB_1BY4_PACKED_SIZE;
          cCODERATE_1by3  : get_used_cycle_num = cSHORT_HS_TAB_1BY3_PACKED_SIZE;
          cCODERATE_2by5  : get_used_cycle_num = cSHORT_HS_TAB_2BY5_PACKED_SIZE;
          cCODERATE_1by2  : get_used_cycle_num = cSHORT_HS_TAB_1BY2_PACKED_SIZE;
          cCODERATE_3by5  : get_used_cycle_num = cSHORT_HS_TAB_3BY5_PACKED_SIZE;
          cCODERATE_2by3  : get_used_cycle_num = cSHORT_HS_TAB_2BY3_PACKED_SIZE;
          cCODERATE_3by4  : get_used_cycle_num = cSHORT_HS_TAB_3BY4_PACKED_SIZE;
          cCODERATE_4by5  : get_used_cycle_num = cSHORT_HS_TAB_4BY5_PACKED_SIZE;
          cCODERATE_5by6  : get_used_cycle_num = cSHORT_HS_TAB_5BY6_PACKED_SIZE;
          cCODERATE_8by9  : get_used_cycle_num = cSHORT_HS_TAB_8BY9_PACKED_SIZE;
        endcase
      end
      //
      cCODEGR_LARGE : begin
        case (code_ctx.coderate)
          cCODERATE_1by4  : get_used_cycle_num = cLARGE_HS_TAB_1BY4_PACKED_SIZE;
          cCODERATE_1by3  : get_used_cycle_num = cLARGE_HS_TAB_1BY3_PACKED_SIZE;
          cCODERATE_2by5  : get_used_cycle_num = cLARGE_HS_TAB_2BY5_PACKED_SIZE;
          cCODERATE_1by2  : get_used_cycle_num = cLARGE_HS_TAB_1BY2_PACKED_SIZE;
          cCODERATE_3by5  : get_used_cycle_num = cLARGE_HS_TAB_3BY5_PACKED_SIZE;
          cCODERATE_2by3  : get_used_cycle_num = cLARGE_HS_TAB_2BY3_PACKED_SIZE;
          cCODERATE_3by4  : get_used_cycle_num = cLARGE_HS_TAB_3BY4_PACKED_SIZE;
          cCODERATE_4by5  : get_used_cycle_num = cLARGE_HS_TAB_4BY5_PACKED_SIZE;
          cCODERATE_5by6  : get_used_cycle_num = cLARGE_HS_TAB_5BY6_PACKED_SIZE;
          cCODERATE_8by9  : get_used_cycle_num = cLARGE_HS_TAB_8BY9_PACKED_SIZE;
          cCODERATE_9by10 : get_used_cycle_num = cLARGE_HS_TAB_9BY10_PACKED_SIZE;
        endcase
      end
    endcase
  end
  endfunction

endmodule
