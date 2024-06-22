/*



  parameter int pRADDR_W  = 8 ;
  parameter int pWADDR_W  = 8 ;
  //
  parameter int pTAG_W    = 4 ;
  //
  parameter int pCODEGR   = 1 ;
  parameter int pCODERATE = 0 ;
  parameter bit pXMODE    = 0 ;



  logic                       ldpc_dvb_enc_engine_fix__iclk        ;
  logic                       ldpc_dvb_enc_engine_fix__ireset      ;
  logic                       ldpc_dvb_enc_engine_fix__iclkena     ;
  //
  logic                       ldpc_dvb_enc_engine_fix__irbuf_full  ;
  //
  logic       [cZC_MAX-1 : 0] ldpc_dvb_enc_engine_fix__irdat       ;
  logic        [pTAG_W-1 : 0] ldpc_dvb_enc_engine_fix__irtag       ;
  logic                       ldpc_dvb_enc_engine_fix__orempty     ;
  logic      [pRADDR_W-1 : 0] ldpc_dvb_enc_engine_fix__oraddr      ;
  //
  logic                       ldpc_dvb_enc_engine_fix__iwbuf_empty ;
  //
  logic      [pWADDR_W-1 : 0] ldpc_dvb_enc_engine_fix__owcol       ;
  logic      [pWADDR_W-1 : 0] ldpc_dvb_enc_engine_fix__owdata_col  ;
  logic      [pWADDR_W-1 : 0] ldpc_dvb_enc_engine_fix__owrow       ;
  //
  logic                       ldpc_dvb_enc_engine_fix__owrite      ;
  logic                       ldpc_dvb_enc_engine_fix__owfull      ;
  logic      [pWADDR_W-1 : 0] ldpc_dvb_enc_engine_fix__owaddr      ;
  logic       [cZC_MAX-1 : 0] ldpc_dvb_enc_engine_fix__owdat       ;
  logic        [pTAG_W-1 : 0] ldpc_dvb_enc_engine_fix__owtag       ;
  //
  logic                       ldpc_dvb_enc_engine_fix__opwrite     ;
  logic      [pWADDR_W-1 : 0] ldpc_dvb_enc_engine_fix__opwaddr     ;



  ldpc_dvb_enc_engine_fix
  #(
    .pRADDR_W  ( pRADDR_W  ) ,
    .pWADDR_W  ( pWADDR_W  ) ,
    //
    .pTAG_W    ( pTAG_W    ) ,
    //
    .pCODEGR   ( pCODEGR   ) ,
    .pCODRATE  ( pCODERATE ) ,
    .pXMODE    ( pXMODE    )
  )
  ldpc_dvb_enc_engine_fix
  (
    .iclk        ( ldpc_dvb_enc_engine_fix__iclk        ) ,
    .ireset      ( ldpc_dvb_enc_engine_fix__ireset      ) ,
    .iclkena     ( ldpc_dvb_enc_engine_fix__iclkena     ) ,
    //
    .irbuf_full  ( ldpc_dvb_enc_engine_fix__irbuf_full  ) ,
    //
    .irdat       ( ldpc_dvb_enc_engine_fix__irdat       ) ,
    .irtag       ( ldpc_dvb_enc_engine_fix__irtag       ) ,
    .orempty     ( ldpc_dvb_enc_engine_fix__orempty     ) ,
    .oraddr      ( ldpc_dvb_enc_engine_fix__oraddr      ) ,
    //
    .iwbuf_empty ( ldpc_dvb_enc_engine_fix__iwbuf_empty ) ,
    //
    .owcol       ( ldpc_dvb_enc_engine_fix__owcol       ) ,
    .owdata_col  ( ldpc_dvb_enc_engine_fix__owdata_col  ) ,
    .owrow       ( ldpc_dvb_enc_engine_fix__owrow       ) ,
    //
    .owrite      ( ldpc_dvb_enc_engine_fix__owrite      ) ,
    .owfull      ( ldpc_dvb_enc_engine_fix__owfull      ) ,
    .owaddr      ( ldpc_dvb_enc_engine_fix__owaddr      ) ,
    .owdat       ( ldpc_dvb_enc_engine_fix__owdat       ) ,
    .owtag       ( ldpc_dvb_enc_engine_fix__owtag       )
    //
    .opwrite     ( ldpc_dvb_enc_engine_fix__opwrite     ) ,
    .opwaddr     ( ldpc_dvb_enc_engine_fix__opwaddr     )
  );


  assign ldpc_dvb_enc_engine_fix__iclk        = '0 ;
  assign ldpc_dvb_enc_engine_fix__ireset      = '0 ;
  assign ldpc_dvb_enc_engine_fix__iclkena     = '0 ;
  assign ldpc_dvb_enc_engine_fix__irbuf_full  = '0 ;
  assign ldpc_dvb_enc_engine_fix__irdat       = '0 ;
  assign ldpc_dvb_enc_engine_fix__irtag       = '0 ;
  assign ldpc_dvb_enc_engine_fix__iwbuf_empty = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_engine_fix.sv
// Description   : variable mode DVB LDPC RTL encoder engine
//

module ldpc_dvb_enc_engine_fix
#(
  parameter int pRADDR_W  = 8 ,
  parameter int pWADDR_W  = 8 ,
  //
  parameter int pTAG_W    = 4 ,
  //
  parameter int pCODEGR   = 1 , // short(0)/large(1)/medium(2) graph
  parameter int pCODERATE = 1 , // coderate table see in ldpc_dvb_constants.svh
  parameter bit pXMODE    = 0   // DVB-S2X code tables using
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  irbuf_full  ,
  //
  irdat       ,
  irtag       ,
  orempty     ,
  oraddr      ,
  //
  iwbuf_empty ,
  //
  owcol       ,
  owdata_col  ,
  owrow       ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  owtag       ,
  //
  opwrite     ,
  opwaddr
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk        ;
  input  logic                       ireset      ;
  input  logic                       iclkena     ;
  // input ram interface
  input  logic                       irbuf_full  ;
  //
  input  logic       [cZC_MAX-1 : 0] irdat       ;
  input  logic        [pTAG_W-1 : 0] irtag       ;
  output logic                       orempty     ;
  output logic      [pRADDR_W-1 : 0] oraddr      ;
  // output ram interface
  input  logic                       iwbuf_empty ;
  // transponse info
  output logic      [pWADDR_W-1 : 0] owcol       ;
  output logic      [pWADDR_W-1 : 0] owdata_col  ;
  output logic      [pWADDR_W-1 : 0] owrow       ;
  //
  output logic                       owrite      ;
  output logic                       owfull      ;
  output logic      [pWADDR_W-1 : 0] owaddr      ;
  output logic       [cZC_MAX-1 : 0] owdat       ;
  output logic        [pTAG_W-1 : 0] owtag       ;
  //
  output logic                       opwrite     ;
  output logic      [pWADDR_W-1 : 0] opwaddr     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam                   int cRDAT_DELAY   = 2;                // read ram delay

  localparam  [cLOG2_ZC_MAX-1 : 0] cBS_PIPE_LINE = 9'b1_0010_0100;   // 3 pipeline stage
  localparam                   int cBS_DELAY     = 3 + cRDAT_DELAY;  // barrel shifter delay

  // parity bit RAM settings
  localparam int cPRAM_ADDR_W = (pCODEGR == cCODEGR_LARGE) ? cLOG2_ROW_MAX : ((pCODEGR == cCODEGR_MEDIUM) ? cLOG2_ROW_MEDIUM_MAX :  cLOG2_ROW_SHORT_MAX);
  localparam int cPRAM_DAT_W  = cZC_MAX;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // Hs gen
  code_ctx_t                  hs_gen__icode_ctx      ;
  //
  col_t                       hs_gen__oused_col      ;
  col_t                       hs_gen__oused_data_col ;
  row_t                       hs_gen__oused_row      ;
  cycle_idx_t                 hs_gen__ocycle_max_num ;
  //
  logic                       hs_gen__icycle_read    ;
  cycle_idx_t                 hs_gen__icycle_idx     ;
  //
  logic                       hs_gen__ocycle_read    ;
  strb_t                      hs_gen__ocycle_strb    ;
  col_t                       hs_gen__ocycle_col_idx ;
  shift_t                     hs_gen__ocycle_shift   ;

  //
  // ctrl
  logic                       ctrl__ibuf_full      ;
  logic                       ctrl__obuf_empty     ;
  logic                       ctrl__iobuf_empty    ;
  //
  col_t                       ctrl__iused_col      ;
  col_t                       ctrl__iused_data_col ;
  row_t                       ctrl__iused_row      ;
  //
  cycle_idx_t                 ctrl__icycle_max_num ;
  //
  logic                       ctrl__ostart         ;
  //
  logic                       ctrl__ip_busy        ;
  logic                       ctrl__ocycle_read    ;
  cycle_idx_t                 ctrl__ocycle_idx     ;
  //
  logic                       ctrl__ip_read_busy   ;
  logic                       ctrl__op_read        ;
  strb_t                      ctrl__op_strb        ;
  row_t                       ctrl__op_row_idx     ;

  //
  // barrel shifter
  //
  logic                       bs__ival    ;
  zdat_t                      bs__idat    ;
  shift_t                     bs__ishift  ;
  //
  logic                       bs__oval    ;
  zdat_t                      bs__odat    ;

  //
  // plogic
  logic                       plogic__istart        ;
  //
  logic                       plogic__ival          ;
  strb_t                      plogic__istrb         ;
  zdat_t                      plogic__idat          ;
  //
  logic                       plogic__oval          ;
  row_t                       plogic__opacc_row_idx ;
  zdat_t                      plogic__opacc_word    ;
  zdat_t                      plogic__opacc         ;

  //
  // pram
  logic                       pram__iwrite  ;
  logic [cPRAM_ADDR_W-1 : 0]  pram__iwaddr  ;
  logic  [cPRAM_DAT_W-1 : 0]  pram__iwdat   ;

  logic [cPRAM_ADDR_W-1 : 0]  pram__iraddr  ;
  logic  [cPRAM_DAT_W-1 : 0]  pram__ordat   ;

  //
  // output mux
  col_t                       mux__iused_data_col ;
  //
  logic                       mux__ival           ;
  col_t                       mux__icol           ;
  zdat_t                      mux__idat           ;
  //
  logic                       mux__ipval          ;
  strb_t                      mux__ipstrb         ;
  zdat_t                      mux__ipacc          ;
  zdat_t                      mux__ipline         ;
  //
  logic                       mux__owfull         ;
  logic                       mux__owrite         ;
  col_t                       mux__owaddr         ;
  zdat_t                      mux__owdat          ;
  //
  logic                       mux__opwrite        ;
  col_t                       mux__opwaddr        ;

  //------------------------------------------------------------------------------------------------------
  // Hs "generator"
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_hs
  #(
    .pXMODE ( pXMODE ) ,
    .pPIPE  ( 1      )  // 2 tick latency
  )
  hs
  (
    .iclk           ( iclk                   ) ,
    .ireset         ( ireset                 ) ,
    .iclkena        ( iclkena                ) ,
    //
    .icode_ctx      ( hs_gen__icode_ctx      ) ,
    //
    .oused_col      ( hs_gen__oused_col      ) ,
    .oused_data_col ( hs_gen__oused_data_col ) ,
    .oused_row      ( hs_gen__oused_row      ) ,
    .ocycle_max_num ( hs_gen__ocycle_max_num ) ,
    //
    .icycle_read    ( hs_gen__icycle_read    ) ,
    .icycle_idx     ( hs_gen__icycle_idx     ) ,
    //
    .ocycle_read    ( hs_gen__ocycle_read    ) ,
    .ocycle_strb    ( hs_gen__ocycle_strb    ) ,
    .ocycle_col_idx ( hs_gen__ocycle_col_idx ) ,
    .ocycle_shift   ( hs_gen__ocycle_shift   )
  );

  assign hs_gen__icode_ctx    = '{xmode : pXMODE, gr : pCODEGR, coderate : pCODERATE};

  assign hs_gen__icycle_read  = ctrl__ocycle_read;
  assign hs_gen__icycle_idx   = ctrl__ocycle_idx;

  assign oraddr               = hs_gen__ocycle_col_idx;

  //------------------------------------------------------------------------------------------------------
  // ctrl signal allign delays
  //------------------------------------------------------------------------------------------------------

  logic [cBS_DELAY-1 : 0] rdat_val                ;
  strb_t                  rdat_strb    [cBS_DELAY];
  shift_t                 rdat_shift   [cBS_DELAY];
  col_t                   rdat_col_idx [cBS_DELAY];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      rdat_val <= '0;
    end
    else if (iclkena) begin
      rdat_val <= (rdat_val << 1) | hs_gen__ocycle_read;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < cBS_DELAY; i++) begin
        if (i == 0) begin
          rdat_strb   [i] <= hs_gen__ocycle_strb    ;
          rdat_shift  [i] <= hs_gen__ocycle_shift   ;
          rdat_col_idx[i] <= hs_gen__ocycle_col_idx ;
        end
        else begin
          rdat_strb   [i] <= rdat_strb   [i-1] ;
          rdat_shift  [i] <= rdat_shift  [i-1] ;
          rdat_col_idx[i] <= rdat_col_idx[i-1] ;
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_ctrl
  ctrl
  (
    .iclk           ( iclk                ) ,
    .ireset         ( ireset              ) ,
    .iclkena        ( iclkena             ) ,
    //
    .ibuf_full      ( ctrl__ibuf_full      ) ,
    .obuf_empty     ( ctrl__obuf_empty     ) ,
    .iobuf_empty    ( ctrl__iobuf_empty    ) ,
    //
    .iused_col      ( ctrl__iused_col      ) ,
    .iused_data_col ( ctrl__iused_data_col ) ,
    .iused_row      ( ctrl__iused_row      ) ,
    //
    .icycle_max_num ( ctrl__icycle_max_num ) ,
    //
    .ostart         ( ctrl__ostart         ) ,
    //
    .ip_busy        ( ctrl__ip_busy        ) ,
    .ocycle_read    ( ctrl__ocycle_read    ) ,
    .ocycle_idx     ( ctrl__ocycle_idx     ) ,
    //
    .ip_read_busy   ( ctrl__ip_read_busy   ) ,
    .op_read        ( ctrl__op_read        ) ,
    .op_strb        ( ctrl__op_strb        ) ,
    .op_row_idx     ( ctrl__op_row_idx     )
  );

  assign ctrl__ibuf_full      = irbuf_full  ;
  assign ctrl__iobuf_empty    = iwbuf_empty ;

  assign orempty              = ctrl__obuf_empty;

  assign ctrl__iused_col      = hs_gen__oused_col      ;
  assign ctrl__iused_data_col = hs_gen__oused_data_col ;
  assign ctrl__iused_row      = hs_gen__oused_row      ;

  assign ctrl__icycle_max_num = hs_gen__ocycle_max_num ;

  assign ctrl__ip_busy        = rdat_val[cBS_DELAY-3]  ; // 2 tick is pram read latency (can use for codes used_row >= 4)

  assign ctrl__ip_read_busy   = mux__owrite; // wait until write all to buffer

  //------------------------------------------------------------------------------------------------------
  // barrel shifter
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_barrel_shifter
  #(
    .pW         ( cZC_MAX       ) ,
    .pSHIFT_W   ( cLOG2_ZC_MAX  ) ,
    .pR_SHIFT   ( 0             ) ,
    .pPIPE_LINE ( cBS_PIPE_LINE )
  )
  bs
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .ival    ( bs__ival   ) ,
    .idat    ( bs__idat   ) ,
    .ishift  ( bs__ishift ) ,
    //
    .oval    ( bs__oval   ) ,
    .odat    ( bs__odat   )
  );

  assign bs__idat   = irdat;

  assign bs__ival   = rdat_val  [cRDAT_DELAY-1];
  assign bs__ishift = rdat_shift[cRDAT_DELAY-1];

  //------------------------------------------------------------------------------------------------------
  // parity block logic
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_pblock_logic
  #(
    .pPACC_SPLIT ( 4 )  // spit on 4 block is optimal
  )
  plogic
  (
    .iclk          ( iclk                  ) ,
    .ireset        ( ireset                ) ,
    .iclkena       ( iclkena               ) ,
    //
    .istart        ( plogic__istart        ) ,
    //
    .ival          ( plogic__ival          ) ,
    .istrb         ( plogic__istrb         ) ,
    .idat          ( plogic__idat          ) ,
    //
    .oval          ( plogic__oval          ) ,
    .opacc_row_idx ( plogic__opacc_row_idx ) ,
    .opacc_word    ( plogic__opacc_word    ) ,
    .opacc         ( plogic__opacc         )
  );

  assign plogic__istart  = ctrl__ostart ;

  assign plogic__ival    = bs__oval ;
  assign plogic__idat    = bs__odat ;

  assign plogic__istrb   = rdat_strb[cBS_DELAY-1] ;

  //------------------------------------------------------------------------------------------------------
  // parity block ram
  //------------------------------------------------------------------------------------------------------

  codec_mem_block
  #(
    .pADDR_W ( cPRAM_ADDR_W  ) ,
    .pDAT_W  ( cPRAM_DAT_W   ) ,
    .pPIPE   ( 1             )
  )
  pram
  (
    .iclk    ( iclk          ) ,
    .ireset  ( ireset        ) ,
    .iclkena ( iclkena       ) ,
    //
    .iwrite  ( pram__iwrite  ) ,
    .iwaddr  ( pram__iwaddr  ) ,
    .iwdat   ( pram__iwdat   ) ,
    //
    .iraddr  ( pram__iraddr  ) ,
    .ordat   ( pram__ordat   )
  );

  assign pram__iwrite  = plogic__oval;
  assign pram__iwaddr  = plogic__opacc_row_idx[cPRAM_ADDR_W-1 : 0];
  assign pram__iwdat   = plogic__opacc_word;
  //
  assign pram__iraddr  = ctrl__op_row_idx[cPRAM_ADDR_W-1 : 0];

  //------------------------------------------------------------------------------------------------------
  // allign parity block ram delay
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] p_read;
  strb_t        p_strb [2];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      p_read <= '0;
    end
    else if (iclkena) begin
      p_read <= (p_read << 1) | ctrl__op_read;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      {p_strb[1], p_strb[0]} <= {p_strb[0], ctrl__op_strb};
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output data/parity muxer
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_mux
  mux
  (
    .iclk           ( iclk                ) ,
    .ireset         ( ireset              ) ,
    .iclkena        ( iclkena             ) ,
    //
    .iused_data_col ( mux__iused_data_col ) ,
    //
    .ival           ( mux__ival           ) ,
    .icol           ( mux__icol           ) ,
    .idat           ( mux__idat           ) ,
    //
    .ipval          ( mux__ipval          ) ,
    .ipstrb         ( mux__ipstrb         ) ,
    .ipacc          ( mux__ipacc          ) ,
    .ipline         ( mux__ipline         ) ,
    //
    .owfull         ( mux__owfull         ) ,
    .owrite         ( mux__owrite         ) ,
    .owaddr         ( mux__owaddr         ) ,
    .owdat          ( mux__owdat          ) ,
    //
    .opwrite        ( mux__opwrite        ) ,
    .opwaddr        ( mux__opwaddr        )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ctrl__ostart) begin
        mux__iused_data_col <= hs_gen__oused_data_col;
      end
    end
  end

  assign mux__ival    = rdat_val    [cRDAT_DELAY-1] ;
  assign mux__icol    = rdat_col_idx[cRDAT_DELAY-1] ;
  assign mux__idat    = irdat ;

  assign mux__ipval   = p_read[1]     ;
  assign mux__ipstrb  = p_strb[1]     ;
  assign mux__ipacc   = pram__ordat   ;
  assign mux__ipline  = plogic__opacc ;

  //------------------------------------------------------------------------------------------------------
  // output data mapping
  //------------------------------------------------------------------------------------------------------

  assign owfull = mux__owfull;
  assign owrite = mux__owrite;
  assign owaddr = mux__owaddr[pWADDR_W-1 : 0];
  assign owdat  = mux__owdat;

  assign opwrite  = mux__opwrite;
  assign opwaddr  = mux__opwaddr[pWADDR_W-1 : 0];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ctrl__ostart) begin
        owcol       <= hs_gen__oused_col;
        owdata_col  <= hs_gen__oused_data_col;
        owrow       <= hs_gen__oused_row;
        owtag       <= irtag;
      end
    end
  end

endmodule
