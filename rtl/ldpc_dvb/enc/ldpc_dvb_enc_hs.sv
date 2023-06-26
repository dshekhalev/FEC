/*



  parameter bit pXMODE  = 0 ;
  parameter bit pPIPE   = 1 ;



  logic       ldpc_dvb_enc_hs__iclk           ;
  logic       ldpc_dvb_enc_hs__ireset         ;
  logic       ldpc_dvb_enc_hs__iclkena        ;
  //
  code_ctx_t  ldpc_dvb_enc_hs__icode_ctx      ;
  //
  col_t       ldpc_dvb_enc_hs__oused_col      ;
  col_t       ldpc_dvb_enc_hs__oused_data_col ;
  row_t       ldpc_dvb_enc_hs__oused_row      ;
  cycle_idx_t ldpc_dvb_enc_hs__ocycle_max_num ;
  //
  logic       ldpc_dvb_enc_hs__icycle_read    ;
  cycle_idx_t ldpc_dvb_enc_hs__icycle_idx     ;
  //
  logic       ldpc_dvb_enc_hs__ocycle_read    ;
  strb_t      ldpc_dvb_enc_hs__ocycle_strb    ;
  col_t       ldpc_dvb_enc_hs__ocycle_col_idx ;
  shift_t     ldpc_dvb_enc_hs__ocycle_shift   ;



  ldpc_dvb_enc_hs
  #(
    .pXMODE ( pXMODE ) ,
    .pPIPE  ( pPIPE  )
  )
  ldpc_dvb_enc_hs
  (
    .iclk           ( ldpc_dvb_enc_hs__iclk           ) ,
    .ireset         ( ldpc_dvb_enc_hs__ireset         ) ,
    .iclkena        ( ldpc_dvb_enc_hs__iclkena        ) ,
    //
    .icode_ctx      ( ldpc_dvb_enc_hs__icode_ctx      ) ,
    //
    .oused_col      ( ldpc_dvb_enc_hs__oused_col      ) ,
    .oused_data_col ( ldpc_dvb_enc_hs__oused_data_col ) ,
    .oused_row      ( ldpc_dvb_enc_hs__oused_row      ) ,
    .ocycle_max_num ( ldpc_dvb_enc_hs__ocycle_max_num ) ,
    //
    .icycle_read    ( ldpc_dvb_enc_hs__icycle_read    ) ,
    .icycle_idx     ( ldpc_dvb_enc_hs__icycle_idx     ) ,
    //
    .ocycle_read    ( ldpc_dvb_enc_hs__ocycle_read    ) ,
    .ocycle_strb    ( ldpc_dvb_enc_hs__ocycle_strb    ) ,
    .ocycle_col_idx ( ldpc_dvb_enc_hs__ocycle_col_idx ) ,
    .ocycle_shift   ( ldpc_dvb_enc_hs__ocycle_shift   )
  );


  assign ldpc_dvb_enc_hs__iclk        = '0 ;
  assign ldpc_dvb_enc_hs__ireset      = '0 ;
  assign ldpc_dvb_enc_hs__iclkena     = '0 ;
  assign ldpc_dvb_enc_hs__icode_ctx   = '0 ;
  assign ldpc_dvb_enc_hs__icycle_read = '0 ;
  assign ldpc_dvb_enc_hs__icycle_idx  = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_hs.sv
// Description   : DVB-S2/S2X Hs coe code context based fixed table
//


module ldpc_dvb_enc_hs
#(
  parameter bit pXMODE  = 0 , // DVB-S2X code tables using
  parameter bit pPIPE   = 1
)
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  icode_ctx      ,
  //
  oused_col      ,
  oused_data_col ,
  oused_row      ,
  ocycle_max_num ,
  //
  icycle_read    ,
  icycle_idx     ,
  //
  ocycle_read    ,
  ocycle_strb    ,
  ocycle_col_idx ,
  ocycle_shift
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic       iclk           ;
  input  logic       ireset         ;
  input  logic       iclkena        ;
  //
  input  code_ctx_t  icode_ctx      ;
  //
  output col_t       oused_col      ;
  output col_t       oused_data_col ;
  output row_t       oused_row      ;
  output cycle_idx_t ocycle_max_num ;
  //
  input  logic       icycle_read    ;
  input  cycle_idx_t icycle_idx     ;
  //
  output logic       ocycle_read    ;
  output strb_t      ocycle_strb    ;
  output col_t       ocycle_col_idx ;
  output shift_t     ocycle_shift   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "ldpc_dvb_enc_hs_large_packed.svh"
  `include "ldpc_dvb_enc_hs_short_packed.svh"
  `include "ldpc_dvb_x_enc_hs_large_packed.svh"
  `include "ldpc_dvb_x_enc_hs_short_packed.svh"
  `include "ldpc_dvb_x_enc_hs_medium_packed.svh"

  typedef struct packed {
    logic   eop;
    col_t   col_idx;
    shift_t shift;
  } cycle_ctx_t;

  code_ctx_t  used_code_ctx;

  //------------------------------------------------------------------------------------------------------
  // mask if need
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    used_code_ctx       = icode_ctx;
    used_code_ctx.xmode = pXMODE;
  end

  //------------------------------------------------------------------------------------------------------
  // cycle constanst
  //------------------------------------------------------------------------------------------------------

  assign oused_col      = get_used_col       (used_code_ctx);
  assign oused_data_col = get_used_data_col  (used_code_ctx);
  assign oused_row      = get_used_row       (used_code_ctx);

  assign ocycle_max_num = get_used_cycle_num (used_code_ctx);

  //------------------------------------------------------------------------------------------------------
  // cycle context rom reading
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] cycle_ctx_read;
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
      cycle_ctx_rdat[0] <= cSHORT_HS_TAB_8BY9_PACKED_SIZE[icycle_idx];
      if (used_code_ctx.xmode) begin
        case (used_code_ctx.gr)
          cCODEGR_SHORT : begin
            case (used_code_ctx.coderate)
              cXCODERATE_S_11by45  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_11BY45_PACKED[icycle_idx];
              cXCODERATE_S_4by15   : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_4BY15_PACKED [icycle_idx];
              cXCODERATE_S_14by45  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_14BY45_PACKED[icycle_idx];
              cXCODERATE_S_7by15   : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_7BY15_PACKED [icycle_idx];
              cXCODERATE_S_8by15   : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_8BY15_PACKED [icycle_idx];
              cXCODERATE_S_26by45  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_26BY45_PACKED[icycle_idx];
              cXCODERATE_S_32by45  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_32BY45_PACKED[icycle_idx];
            endcase
          end
          //
          cCODEGR_MEDIUM : begin
            case (used_code_ctx.coderate)
              cXCODERATE_M_1by5    : cycle_ctx_rdat[0] <= cMEDIUM_HS_TAB_1BY5_PACKED  [icycle_idx];
              cXCODERATE_M_11by45  : cycle_ctx_rdat[0] <= cMEDIUM_HS_TAB_11BY45_PACKED[icycle_idx];
              cXCODERATE_M_1by3    : cycle_ctx_rdat[0] <= cMEDIUM_HS_TAB_1BY3_PACKED  [icycle_idx];
            endcase
          end
          //
          cCODEGR_LARGE : begin
            case (used_code_ctx.coderate)
              cXCODERATE_L_2by9     : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_2BY9_PACKED    [icycle_idx];
              cXCODERATE_L_13by45   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_13BY45_PACKED  [icycle_idx];
              cXCODERATE_L_9by20    : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_9BY20_PACKED   [icycle_idx];
              cXCODERATE_L_90by180  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_90BY180_PACKED [icycle_idx];
              cXCODERATE_L_96by180  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_96BY180_PACKED [icycle_idx];
              cXCODERATE_L_11by20   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_11BY20_PACKED  [icycle_idx];
              cXCODERATE_L_100by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_100BY180_PACKED[icycle_idx];
              cXCODERATE_L_26by45   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_26BY45_PACKED  [icycle_idx];
              cXCODERATE_L_104by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_104BY180_PACKED[icycle_idx];
              cXCODERATE_L_18by30   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_18BY30_PACKED  [icycle_idx];
              cXCODERATE_L_28by45   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_28BY45_PACKED  [icycle_idx];
              cXCODERATE_L_23by36   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_23BY36_PACKED  [icycle_idx];
              cXCODERATE_L_116by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_116BY180_PACKED[icycle_idx];
              cXCODERATE_L_20by30   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_20BY30_PACKED  [icycle_idx];
              cXCODERATE_L_124by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_124BY180_PACKED[icycle_idx];
              cXCODERATE_L_25by36   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_25BY36_PACKED  [icycle_idx];
              cXCODERATE_L_128by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_128BY180_PACKED[icycle_idx];
              cXCODERATE_L_13by18   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_13BY18_PACKED  [icycle_idx];
              cXCODERATE_L_132by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_132BY180_PACKED[icycle_idx];
              cXCODERATE_L_22by30   : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_22BY30_PACKED  [icycle_idx];
              cXCODERATE_L_135by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_135BY180_PACKED[icycle_idx];
              cXCODERATE_L_140by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_140BY180_PACKED[icycle_idx];
              cXCODERATE_L_7by9     : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_7BY9_PACKED    [icycle_idx];
              cXCODERATE_L_154by180 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_154BY180_PACKED[icycle_idx];
            endcase
          end
        endcase
      end
      else begin
        case (used_code_ctx.gr)
          cCODEGR_SHORT : begin
            case (used_code_ctx.coderate)
              cCODERATE_1by4  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_1BY4_PACKED[icycle_idx];
              cCODERATE_1by3  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_1BY3_PACKED[icycle_idx];
              cCODERATE_2by5  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_2BY5_PACKED[icycle_idx];
              cCODERATE_1by2  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_1BY2_PACKED[icycle_idx];
              cCODERATE_3by5  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_3BY5_PACKED[icycle_idx];
              cCODERATE_2by3  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_2BY3_PACKED[icycle_idx];
              cCODERATE_3by4  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_3BY4_PACKED[icycle_idx];
              cCODERATE_4by5  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_4BY5_PACKED[icycle_idx];
              cCODERATE_5by6  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_5BY6_PACKED[icycle_idx];
              cCODERATE_8by9  : cycle_ctx_rdat[0] <= cSHORT_HS_TAB_8BY9_PACKED[icycle_idx];
            endcase
          end
          //
          cCODEGR_LARGE : begin
            case (used_code_ctx.coderate)
              cCODERATE_1by4  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_1BY4_PACKED [icycle_idx];
              cCODERATE_1by3  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_1BY3_PACKED [icycle_idx];
              cCODERATE_2by5  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_2BY5_PACKED [icycle_idx];
              cCODERATE_1by2  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_1BY2_PACKED [icycle_idx];
              cCODERATE_3by5  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_3BY5_PACKED [icycle_idx];
              cCODERATE_2by3  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_2BY3_PACKED [icycle_idx];
              cCODERATE_3by4  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_3BY4_PACKED [icycle_idx];
              cCODERATE_4by5  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_4BY5_PACKED [icycle_idx];
              cCODERATE_5by6  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_5BY6_PACKED [icycle_idx];
              cCODERATE_8by9  : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_8BY9_PACKED [icycle_idx];
              cCODERATE_9by10 : cycle_ctx_rdat[0] <= cLARGE_HS_TAB_9BY10_PACKED[icycle_idx];
            endcase
          end
        endcase
      end
      //
      cycle_ctx_rdat[1] <= cycle_ctx_rdat[0];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  assign ocycle_read     = cycle_ctx_read[pPIPE];

  assign ocycle_strb.sof = 1'b0;
  assign ocycle_strb.sop = 1'b0; // goto parity logic unit
  assign ocycle_strb.eop = cycle_ctx_rdat[pPIPE].eop;
  assign ocycle_strb.eof = 1'b0;

  assign ocycle_col_idx  = cycle_ctx_rdat[pPIPE].col_idx;
  assign ocycle_shift    = cycle_ctx_rdat[pPIPE].shift;

  //------------------------------------------------------------------------------------------------------
  // function to get cycle max num
  //------------------------------------------------------------------------------------------------------

  function automatic int get_used_cycle_num (code_ctx_t code_ctx);
  begin
    get_used_cycle_num = cSHORT_HS_TAB_8BY9_PACKED_SIZE;
    if (code_ctx.xmode) begin
      case (code_ctx.gr)
        cCODEGR_SHORT : begin
          case (code_ctx.coderate)
            cXCODERATE_S_11by45  : get_used_cycle_num = cSHORT_HS_TAB_11BY45_PACKED_SIZE;
            cXCODERATE_S_4by15   : get_used_cycle_num = cSHORT_HS_TAB_4BY15_PACKED_SIZE;
            cXCODERATE_S_14by45  : get_used_cycle_num = cSHORT_HS_TAB_14BY45_PACKED_SIZE;
            cXCODERATE_S_7by15   : get_used_cycle_num = cSHORT_HS_TAB_7BY15_PACKED_SIZE;
            cXCODERATE_S_8by15   : get_used_cycle_num = cSHORT_HS_TAB_8BY15_PACKED_SIZE;
            cXCODERATE_S_26by45  : get_used_cycle_num = cSHORT_HS_TAB_26BY45_PACKED_SIZE;
            cXCODERATE_S_32by45  : get_used_cycle_num = cSHORT_HS_TAB_32BY45_PACKED_SIZE;
          endcase
        end
        //
        cCODEGR_MEDIUM : begin
          case (code_ctx.coderate)
            cXCODERATE_M_1by5    : get_used_cycle_num = cMEDIUM_HS_TAB_1BY5_PACKED_SIZE;
            cXCODERATE_M_11by45  : get_used_cycle_num = cMEDIUM_HS_TAB_11BY45_PACKED_SIZE;
            cXCODERATE_M_1by3    : get_used_cycle_num = cMEDIUM_HS_TAB_1BY3_PACKED_SIZE;
          endcase
        end
        //
        cCODEGR_LARGE : begin
          case (code_ctx.coderate)
            cXCODERATE_L_2by9     : get_used_cycle_num = cLARGE_HS_TAB_2BY9_PACKED_SIZE;
            cXCODERATE_L_13by45   : get_used_cycle_num = cLARGE_HS_TAB_13BY45_PACKED_SIZE;
            cXCODERATE_L_9by20    : get_used_cycle_num = cLARGE_HS_TAB_9BY20_PACKED_SIZE;
            cXCODERATE_L_90by180  : get_used_cycle_num = cLARGE_HS_TAB_90BY180_PACKED_SIZE;
            cXCODERATE_L_96by180  : get_used_cycle_num = cLARGE_HS_TAB_96BY180_PACKED_SIZE;
            cXCODERATE_L_11by20   : get_used_cycle_num = cLARGE_HS_TAB_11BY20_PACKED_SIZE;
            cXCODERATE_L_100by180 : get_used_cycle_num = cLARGE_HS_TAB_100BY180_PACKED_SIZE;
            cXCODERATE_L_26by45   : get_used_cycle_num = cLARGE_HS_TAB_26BY45_PACKED_SIZE;
            cXCODERATE_L_104by180 : get_used_cycle_num = cLARGE_HS_TAB_104BY180_PACKED_SIZE;
            cXCODERATE_L_18by30   : get_used_cycle_num = cLARGE_HS_TAB_18BY30_PACKED_SIZE;
            cXCODERATE_L_28by45   : get_used_cycle_num = cLARGE_HS_TAB_28BY45_PACKED_SIZE;
            cXCODERATE_L_23by36   : get_used_cycle_num = cLARGE_HS_TAB_23BY36_PACKED_SIZE;
            cXCODERATE_L_116by180 : get_used_cycle_num = cLARGE_HS_TAB_116BY180_PACKED_SIZE;
            cXCODERATE_L_20by30   : get_used_cycle_num = cLARGE_HS_TAB_20BY30_PACKED_SIZE;
            cXCODERATE_L_124by180 : get_used_cycle_num = cLARGE_HS_TAB_124BY180_PACKED_SIZE;
            cXCODERATE_L_25by36   : get_used_cycle_num = cLARGE_HS_TAB_25BY36_PACKED_SIZE;
            cXCODERATE_L_128by180 : get_used_cycle_num = cLARGE_HS_TAB_128BY180_PACKED_SIZE;
            cXCODERATE_L_13by18   : get_used_cycle_num = cLARGE_HS_TAB_13BY18_PACKED_SIZE;
            cXCODERATE_L_132by180 : get_used_cycle_num = cLARGE_HS_TAB_132BY180_PACKED_SIZE;
            cXCODERATE_L_22by30   : get_used_cycle_num = cLARGE_HS_TAB_22BY30_PACKED_SIZE;
            cXCODERATE_L_135by180 : get_used_cycle_num = cLARGE_HS_TAB_135BY180_PACKED_SIZE;
            cXCODERATE_L_140by180 : get_used_cycle_num = cLARGE_HS_TAB_140BY180_PACKED_SIZE;
            cXCODERATE_L_7by9     : get_used_cycle_num = cLARGE_HS_TAB_7BY9_PACKED_SIZE;
            cXCODERATE_L_154by180 : get_used_cycle_num = cLARGE_HS_TAB_154BY180_PACKED_SIZE;
          endcase
        end
      endcase
    end
    else begin
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
  end
  endfunction

endmodule
