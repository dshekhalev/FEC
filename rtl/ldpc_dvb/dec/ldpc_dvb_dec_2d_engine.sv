/*



  parameter int pLLR_W            =  8 ;
  parameter int pNODE_W           =  8 ;
  //
  parameter int pRADDR_W          =  8 ;
  parameter int pWADDR_W          =  8 ;
  //
  parameter int pTAG_W            =  4 ;
  //
  parameter int pERR_W            = 16 ;
  //
  parameter bit pCODEGR           =  1 ;
  parameter bit pXMODE            =  0 ;
  //
  parameter int pNORM_FACTOR      =  7 ;
  parameter int pNORM_OFFSET      =  1 ;
  //
  parameter bit pDO_LLR_INVERSION =  1 ;
  parameter bit pUSE_SRL_FIFO     =  1 ;
  parameter bit pUSE_SC_MODE      =  1 ;
  //
  parameter bit pFIX_MODE         =  1 ;



  logic                            ldpc_dvb_dec_2d_engine__iclk         ;
  logic                            ldpc_dvb_dec_2d_engine__ireset       ;
  logic                            ldpc_dvb_dec_2d_engine__iclkena      ;
  //
  logic                            ldpc_dvb_dec_2d_engine__irbuf_full   ;
  code_ctx_t                       ldpc_dvb_dec_2d_engine__icode_ctx    ;
  logic                    [7 : 0] ldpc_dvb_dec_2d_engine__iNiter       ;
  logic                            ldpc_dvb_dec_2d_engine__ifmode       ;
  //
  logic             [pTAG_W-1 : 0] ldpc_dvb_dec_2d_engine__irtag        ;
  zllr_t                           ldpc_dvb_dec_2d_engine__irLLR        ;
  logic           [pRADDR_W-1 : 0] ldpc_dvb_dec_2d_engine__oraddr       ;
  logic                            ldpc_dvb_dec_2d_engine__orempty      ;
  //
  logic                            ldpc_dvb_dec_2d_engine__iwbuf_empty  ;
  //
  logic           [pWADDR_W-1 : 0] ldpc_dvb_dec_2d_engine__owcol        ;
  logic           [pWADDR_W-1 : 0] ldpc_dvb_dec_2d_engine__owdata_col   ;
  logic           [pWADDR_W-1 : 0] ldpc_dvb_dec_2d_engine__owrow        ;
  //
  logic                            ldpc_dvb_dec_2d_engine__owrite       ;
  logic                            ldpc_dvb_dec_2d_engine__owfull       ;
  logic           [pWADDR_W-1 : 0] ldpc_dvb_dec_2d_engine__owaddr       ;
  zdat_t                           ldpc_dvb_dec_2d_engine__owdat        ;
  logic             [pTAG_W-1 : 0] ldpc_dvb_dec_2d_engine__owtag        ;
  //
  logic                            ldpc_dvb_dec_2d_engine__owdecfail    ;
  logic             [pERR_W-1 : 0] ldpc_dvb_dec_2d_engine__owerr        ;



  ldpc_dvb_dec_2d_engine
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pNODE_W           ( pNODE_W           ) ,
    //
    .pRADDR_W          ( pRADDR_W          ) ,
    .pWADDR_W          ( pWADDR_W          ) ,
    //
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pERR_W            ( pERR_W            ) ,
    //
    .pCODEGR           ( pCODEGR           ) ,
    .pXMODE            ( pXMODE            ) ,
    .pNORM_FACTOR      ( pNORM_FACTOR      ) ,
    .pNORM_OFFSET      ( pNORM_OFFSET      ) ,
    //
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION ) ,
    .pUSE_SRL_FIFO     ( pUSE_SRL_FIFO     ) ,
    .pUSE_SC_MODE      ( pUSE_SC_MODE      ) ,
    //
    .pFIX_MODE         ( pFIX_MODE         )
  )
  ldpc_dvb_dec_2d_engine
  (
    .iclk        ( ldpc_dvb_dec_2d_engine__iclk        ) ,
    .ireset      ( ldpc_dvb_dec_2d_engine__ireset      ) ,
    .iclkena     ( ldpc_dvb_dec_2d_engine__iclkena     ) ,
    //
    .irbuf_full  ( ldpc_dvb_dec_2d_engine__irbuf_full  ) ,
    .icode_ctx   ( ldpc_dvb_dec_2d_engine__icode_ctx   ) ,
    .iNiter      ( ldpc_dvb_dec_2d_engine__iNiter      ) ,
    .ifmode      ( ldpc_dvb_dec_2d_engine__ifmode      ) ,
    //
    .irtag       ( ldpc_dvb_dec_2d_engine__itag        ) ,
    .irLLR       ( ldpc_dvb_dec_2d_engine__iLLR        ) ,
    .orempty     ( ldpc_dvb_dec_2d_engine__orempty     ) ,
    .oraddr      ( ldpc_dvb_dec_2d_engine__oraddr      ) ,
    //
    .iwbuf_empty ( ldpc_dvb_dec_2d_engine__iwbuf_empty ) ,
    //
    .owcol       ( ldpc_dvb_dec_2d_engine__owcol       ) ,
    .owdata_col  ( ldpc_dvb_dec_2d_engine__owdata_col  ) ,
    .owrow       ( ldpc_dvb_dec_2d_engine__owrow       ) ,
    //
    .owrite      ( ldpc_dvb_dec_2d_engine__owrite      ) ,
    .owfull      ( ldpc_dvb_dec_2d_engine__owfull      ) ,
    .owaddr      ( ldpc_dvb_dec_2d_engine__owaddr      ) ,
    .owdat       ( ldpc_dvb_dec_2d_engine__owdat       ) ,
    .owtag       ( ldpc_dvb_dec_2d_engine__owtag       ) ,
    //
    .owdecfail   ( ldpc_dvb_dec_2d_engine__owdecfail   ) ,
    .owerr       ( ldpc_dvb_dec_2d_engine__owerr       )
  );


  assign ldpc_dvb_dec_2d_engine__iclk        = '0 ;
  assign ldpc_dvb_dec_2d_engine__ireset      = '0 ;
  assign ldpc_dvb_dec_2d_engine__iclkena     = '0 ;
  assign ldpc_dvb_dec_2d_engine__irbuf_full  = '0 ;
  assign ldpc_dvb_dec_2d_engine__ircode_ctx  = '0 ;
  assign ldpc_dvb_dec_2d_engine__iNiter      = '0 ;
  assign ldpc_dvb_dec_2d_engine__ifmode      = '0 ;
  assign ldpc_dvb_dec_2d_engine__irtag       = '0 ;
  assign ldpc_dvb_dec_2d_engine__irLLR       = '0 ;
  assign ldpc_dvb_dec_2d_engine__iwbuf_empty = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_2d_engine.sv
// Description   : LDPC decoder engine with variable parameters based upon 2D normalized/offset min-sum decoding
//

`include "define.vh"

module ldpc_dvb_dec_2d_engine
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  irbuf_full  ,
  icode_ctx   ,
  iNiter      ,
  ifmode      ,
  //
  irLLR       ,
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
  //
  owtag       ,
  owdecfail   ,
  owerr
);

  parameter int pRADDR_W          =  8 ;
  parameter int pWADDR_W          =  8 ;
  //
  parameter int pTAG_W            =  4 ;
  //
  parameter int pERR_W            = 16 ;
  //
  parameter bit pDO_LLR_INVERSION =  1 ;  // do metric inversion inside decoder

  parameter bit pUSE_SRL_FIFO     =  1 ;  // use SRL based internal FIFO
  //
  parameter int pFIX_MODE         =  0 ;  // fix mode decoder

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  parameter int pCODEGR           = cCODEGR_LARGE ;  // maximum used graph short(0)/large(1)/medium(2)
  parameter bit pXMODE            = 0 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk        ;
  input  logic                       ireset      ;
  input  logic                       iclkena     ;
  // input ram interface
  input  logic                       irbuf_full  ;
  input  code_ctx_t                  icode_ctx   ;
  input  logic               [7 : 0] iNiter      ;
  input  logic                       ifmode      ; // fast work mode with early stop
  //
  input  zllr_t                      irLLR       ;
  input  logic        [pTAG_W-1 : 0] irtag       ;
  output logic                       orempty     ;
  output logic      [pRADDR_W-1 : 0] oraddr      ;
  // output ram interface
  input  logic                       iwbuf_empty ;
  //
  output logic      [pWADDR_W-1 : 0] owcol       ;
  output logic      [pWADDR_W-1 : 0] owdata_col  ;
  output logic      [pWADDR_W-1 : 0] owrow       ;
  //
  output logic                       owrite      ;
  output logic                       owfull      ;
  output logic      [pWADDR_W-1 : 0] owaddr      ;
  output zdat_t                      owdat       ;
  output logic        [pTAG_W-1 : 0] owtag       ;
  //
  output logic                       owdecfail   ;
  output logic        [pERR_W-1 : 0] owerr       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cNODE_RAM_ADDR_W   = cGET_CYCLE_W[pCODEGR];
  localparam int cNODE_RAM_DAT_W    = pNODE_W * cZC_MAX;

  localparam int cSTATE_RAM_ADDR_W  = cNODE_RAM_ADDR_W ;
  localparam int cSTATE_RAM_DAT_W   = (1 + (pUSE_SC_MODE ? cNODE_STATE_W : 0)) * cZC_MAX; // +1 for syndrome decision

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // hs generator
  code_ctx_t                      hs_gen__icode_ctx         ;
  //
  col_t                           hs_gen__oused_col         ;
  col_t                           hs_gen__oused_data_col    ;
  row_t                           hs_gen__oused_row         ;
  cycle_idx_t                     hs_gen__ocycle_max_num    ;
  //
  logic                           hs_gen__icycle_start      ;
  logic                           hs_gen__ic_nv_mode        ;
  logic                           hs_gen__icycle_read       ;
  strb_t                          hs_gen__icycle_strb       ;
  cycle_idx_t                     hs_gen__icycle_idx        ;
  //
  logic                           hs_gen__ocycle_read       ;
  col_t                           hs_gen__ocycle_LLR_raddr  ;
  cycle_idx_t                     hs_gen__ocycle_node_raddr ;
  //
  strb_t                          hs_gen__ocnode_strb       ;
  cnode_ctx_t                     hs_gen__ocnode_ctx        ;
  //
  strb_t                          hs_gen__ovnode_strb       ;
  vnode_ctx_t                     hs_gen__ovnode_ctx        ;

  //
  // ctrl
  logic                   [7 : 0] ctrl__iNiter         ;
  logic                           ctrl__ifmode         ;
  //
  logic                           ctrl__ibuf_full      ;
  logic                           ctrl__obuf_empty     ;
  logic                           ctrl__iobuf_empty    ;
  //
  col_t                           ctrl__iused_col      ;
  col_t                           ctrl__iused_data_col ;
  row_t                           ctrl__iused_row      ;
  cycle_idx_t                     ctrl__icycle_max_num ;
  //
  logic                           ctrl__ivnode_busy    ;
  //
  logic                           ctrl__icnode_busy    ;
  logic                           ctrl__icnode_decfail ;
  //
  logic                           ctrl__oload_mode     ;
  logic                           ctrl__oc_nv_mode     ;
  logic                           ctrl__ocycle_start   ;
  logic                           ctrl__ocycle_read    ;
  strb_t                          ctrl__ocycle_strb    ;
  cycle_idx_t                     ctrl__ocycle_idx     ;
  //
  logic                           ctrl__olast_iter     ;

  //
  // node ram
  logic                           node_ram__iwrite ;
  logic  [cNODE_RAM_ADDR_W-1 : 0] node_ram__iwaddr ;
  logic   [cNODE_RAM_DAT_W-1 : 0] node_ram__iwdat  ;

  logic  [cNODE_RAM_ADDR_W-1 : 0] node_ram__iraddr ;
  logic   [cNODE_RAM_DAT_W-1 : 0] node_ram__ordat  ;

  //
  // state ram
  logic                           state_ram__iwrite ;
  logic [cSTATE_RAM_ADDR_W-1 : 0] state_ram__iwaddr ;
  logic  [cSTATE_RAM_DAT_W-1 : 0] state_ram__iwdat  ;

  logic [cSTATE_RAM_ADDR_W-1 : 0] state_ram__iraddr ;
  logic  [cSTATE_RAM_DAT_W-1 : 0] state_ram__ordat  ;

  //
  // cnode
  //
  logic                           cnode__istart      ;
  logic                           cnode__iload_iter  ;
  //
  logic                           cnode__ival        ;
  strb_t                          cnode__istrb       ;
  cnode_ctx_t                     cnode__icnode_ctx  ;
  zllr_t                          cnode__iLLR        ;
  znode_t                         cnode__ivnode      ;
  zdat_t                          cnode__ivnode_hd   ;
  //
  logic                           cnode__ocnode_val  ;
  cycle_idx_t                     cnode__ocnode_addr ;
  znode_t                         cnode__ocnode      ;
  //
  logic                           cnode__odecfail    ;
  logic                           cnode__obusy       ;

  //
  // vnode
  logic                           vnode__istart       ;
  logic                           vnode__iload_iter   ;
  //
  logic                           vnode__ival         ;
  strb_t                          vnode__istrb        ;
  vnode_ctx_t                     vnode__ivnode_ctx   ;
  zllr_t                          vnode__iLLR         ;
  znode_t                         vnode__icnode       ;
  znode_state_t                   vnode__ivnode_state ;
  //
  logic                           vnode__ovnode_val   ;
  cycle_idx_t                     vnode__ovnode_addr  ;
  znode_t                         vnode__ovnode       ;
  zdat_t                          vnode__ovnode_hd    ;
  znode_state_t                   vnode__ovnode_state ;
  //
  logic                           vnode__obitval      ;
  logic                           vnode__obitsop      ;
  logic                           vnode__obiteop      ;
  zdat_t                          vnode__obitdat      ;
  zdat_t                          vnode__obiterr      ;
  col_t                           vnode__obitaddr     ;
  //
  logic                           vnode__obusy        ;

  //------------------------------------------------------------------------------------------------------
  // Hs "generator"
  //------------------------------------------------------------------------------------------------------

  generate
    if (pFIX_MODE) begin
      if (pXMODE) begin
        ldpc_dvb_x_dec_hs
        #(
          .pPIPE ( 1 ) // 2 tick latency
        )
        hs
        (
          .iclk              ( iclk                      ) ,
          .ireset            ( ireset                    ) ,
          .iclkena           ( iclkena                   ) ,
          //
          .icode_ctx         ( hs_gen__icode_ctx         ) ,
          //
          .oused_col         ( hs_gen__oused_col         ) ,
          .oused_data_col    ( hs_gen__oused_data_col    ) ,
          .oused_row         ( hs_gen__oused_row         ) ,
          .ocycle_max_num    ( hs_gen__ocycle_max_num    ) ,
          //
          .icycle_start      ( hs_gen__icycle_start      ) ,
          .ic_nv_mode        ( hs_gen__ic_nv_mode        ) ,
          .icycle_read       ( hs_gen__icycle_read       ) ,
          .icycle_strb       ( hs_gen__icycle_strb       ) ,
          .icycle_idx        ( hs_gen__icycle_idx        ) ,
          //
          .ocycle_read       ( hs_gen__ocycle_read       ) ,
          .ocycle_LLR_raddr  ( hs_gen__ocycle_LLR_raddr  ) ,
          .ocycle_node_raddr ( hs_gen__ocycle_node_raddr ) ,
          //
          .ocnode_strb       ( hs_gen__ocnode_strb       ) ,
          .ocnode_ctx        ( hs_gen__ocnode_ctx        ) ,
          //
          .ovnode_strb       ( hs_gen__ovnode_strb       ) ,
          .ovnode_ctx        ( hs_gen__ovnode_ctx        )
        );
      end
      else begin
        ldpc_dvb_dec_hs
        #(
          .pPIPE ( 1 ) // 2 tick latency
        )
        hs
        (
          .iclk              ( iclk                      ) ,
          .ireset            ( ireset                    ) ,
          .iclkena           ( iclkena                   ) ,
          //
          .icode_ctx         ( hs_gen__icode_ctx         ) ,
          //
          .oused_col         ( hs_gen__oused_col         ) ,
          .oused_data_col    ( hs_gen__oused_data_col    ) ,
          .oused_row         ( hs_gen__oused_row         ) ,
          .ocycle_max_num    ( hs_gen__ocycle_max_num    ) ,
          //
          .icycle_start      ( hs_gen__icycle_start      ) ,
          .ic_nv_mode        ( hs_gen__ic_nv_mode        ) ,
          .icycle_read       ( hs_gen__icycle_read       ) ,
          .icycle_strb       ( hs_gen__icycle_strb       ) ,
          .icycle_idx        ( hs_gen__icycle_idx        ) ,
          //
          .ocycle_read       ( hs_gen__ocycle_read       ) ,
          .ocycle_LLR_raddr  ( hs_gen__ocycle_LLR_raddr  ) ,
          .ocycle_node_raddr ( hs_gen__ocycle_node_raddr ) ,
          //
          .ocnode_strb       ( hs_gen__ocnode_strb       ) ,
          .ocnode_ctx        ( hs_gen__ocnode_ctx        ) ,
          //
          .ovnode_strb       ( hs_gen__ovnode_strb       ) ,
          .ovnode_ctx        ( hs_gen__ovnode_ctx        )
        );
      end
    end
    else begin
      if (pXMODE) begin
        ldpc_dvb_x_dec_hs_gen // 2 tick latency
        #(
          .pPIPE ( 1 )
        )
        hs_gen
        (
          .iclk              ( iclk                      ) ,
          .ireset            ( ireset                    ) ,
          .iclkena           ( iclkena                   ) ,
          //
          .icode_ctx         ( hs_gen__icode_ctx         ) ,
          //
          .oused_col         ( hs_gen__oused_col         ) ,
          .oused_data_col    ( hs_gen__oused_data_col    ) ,
          .oused_row         ( hs_gen__oused_row         ) ,
          .ocycle_max_num    ( hs_gen__ocycle_max_num    ) ,
          //
          .icycle_start      ( hs_gen__icycle_start      ) ,
          .ic_nv_mode        ( hs_gen__ic_nv_mode        ) ,
          .icycle_read       ( hs_gen__icycle_read       ) ,
          .icycle_strb       ( hs_gen__icycle_strb       ) ,
          .icycle_idx        ( hs_gen__icycle_idx        ) ,
          //
          .ocycle_read       ( hs_gen__ocycle_read       ) ,
          .ocycle_LLR_raddr  ( hs_gen__ocycle_LLR_raddr  ) ,
          .ocycle_node_raddr ( hs_gen__ocycle_node_raddr ) ,
          //
          .ocnode_strb       ( hs_gen__ocnode_strb       ) ,
          .ocnode_ctx        ( hs_gen__ocnode_ctx        ) ,
          //
          .ovnode_strb       ( hs_gen__ovnode_strb       ) ,
          .ovnode_ctx        ( hs_gen__ovnode_ctx        )
        );
      end
      else begin
        ldpc_dvb_dec_hs_gen // 2 tick latency
        #(
          .pPIPE ( 1 )
        )
        hs_gen
        (
          .iclk              ( iclk                      ) ,
          .ireset            ( ireset                    ) ,
          .iclkena           ( iclkena                   ) ,
          //
          .icode_ctx         ( hs_gen__icode_ctx         ) ,
          //
          .oused_col         ( hs_gen__oused_col         ) ,
          .oused_data_col    ( hs_gen__oused_data_col    ) ,
          .oused_row         ( hs_gen__oused_row         ) ,
          .ocycle_max_num    ( hs_gen__ocycle_max_num    ) ,
          //
          .icycle_start      ( hs_gen__icycle_start      ) ,
          .ic_nv_mode        ( hs_gen__ic_nv_mode        ) ,
          .icycle_read       ( hs_gen__icycle_read       ) ,
          .icycle_strb       ( hs_gen__icycle_strb       ) ,
          .icycle_idx        ( hs_gen__icycle_idx        ) ,
          //
          .ocycle_read       ( hs_gen__ocycle_read       ) ,
          .ocycle_LLR_raddr  ( hs_gen__ocycle_LLR_raddr  ) ,
          .ocycle_node_raddr ( hs_gen__ocycle_node_raddr ) ,
          //
          .ocnode_strb       ( hs_gen__ocnode_strb       ) ,
          .ocnode_ctx        ( hs_gen__ocnode_ctx        ) ,
          //
          .ovnode_strb       ( hs_gen__ovnode_strb       ) ,
          .ovnode_ctx        ( hs_gen__ovnode_ctx        )
        );
      end
    end
  endgenerate

  assign hs_gen__icode_ctx    = icode_ctx ;

  assign hs_gen__icycle_start = ctrl__ocycle_start;
  assign hs_gen__ic_nv_mode   = ctrl__oc_nv_mode;

  assign hs_gen__icycle_read  = ctrl__ocycle_read;
  assign hs_gen__icycle_strb  = ctrl__ocycle_strb;
  assign hs_gen__icycle_idx   = ctrl__ocycle_idx;

  assign oraddr               = hs_gen__ocycle_LLR_raddr;

  //------------------------------------------------------------------------------------------------------
  // ctrl signal allign read data delays
  //------------------------------------------------------------------------------------------------------

  localparam int cRDAT_DELAY = 2;// read ram delay

  logic [cRDAT_DELAY-1 : 0] rdat_val                    ;
  strb_t                    rdat_vnode_strb[cRDAT_DELAY];
  vnode_ctx_t               rdat_vnode_ctx [cRDAT_DELAY];
  strb_t                    rdat_cnode_strb[cRDAT_DELAY];
  cnode_ctx_t               rdat_cnode_ctx [cRDAT_DELAY];

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
      for (int i = 0; i < cRDAT_DELAY; i++) begin
        if (i == 0) begin
          rdat_vnode_strb [i] <= hs_gen__ovnode_strb ;
          rdat_vnode_ctx  [i] <= hs_gen__ovnode_ctx  ;
          //
          rdat_cnode_strb [i] <= hs_gen__ocnode_strb ;
          rdat_cnode_ctx  [i] <= hs_gen__ocnode_ctx  ;
        end
        else begin
          rdat_vnode_strb [i] <= rdat_vnode_strb[i-1] ;
          rdat_vnode_ctx  [i] <= rdat_vnode_ctx [i-1] ;
          //
          rdat_cnode_strb [i] <= rdat_cnode_strb[i-1] ;
          rdat_cnode_ctx  [i] <= rdat_cnode_ctx [i-1] ;
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_2d_ctrl
  ctrl
  (
    .iclk           ( iclk                 ) ,
    .ireset         ( ireset               ) ,
    .iclkena        ( iclkena              ) ,
    //
    .iNiter         ( ctrl__iNiter         ) ,
    .ifmode         ( ctrl__ifmode         ) ,
    //
    .ibuf_full      ( ctrl__ibuf_full      ) ,
    .obuf_empty     ( ctrl__obuf_empty     ) ,
    .iobuf_empty    ( ctrl__iobuf_empty    ) ,
    //
    .iused_col      ( ctrl__iused_col      ) ,
    .iused_data_col ( ctrl__iused_data_col ) ,
    .iused_row      ( ctrl__iused_row      ) ,
    .icycle_max_num ( ctrl__icycle_max_num ) ,
    //
    .ivnode_busy    ( ctrl__ivnode_busy    ) ,
    //
    .icnode_busy    ( ctrl__icnode_busy    ) ,
    .icnode_decfail ( ctrl__icnode_decfail ) ,
    //
    .oload_mode     ( ctrl__oload_mode     ) ,
    .oc_nv_mode     ( ctrl__oc_nv_mode     ) ,
    .ocycle_start   ( ctrl__ocycle_start   ) ,
    .ocycle_read    ( ctrl__ocycle_read    ) ,
    .ocycle_strb    ( ctrl__ocycle_strb    ) ,
    .ocycle_idx     ( ctrl__ocycle_idx     ) ,
    //
    .olast_iter     ( ctrl__olast_iter     )
  );

  assign ctrl__iNiter         = iNiter;
  assign ctrl__ifmode         = ifmode;

  assign ctrl__ibuf_full      = irbuf_full ;
  assign ctrl__iobuf_empty    = iwbuf_empty ;

  assign orempty              = ctrl__obuf_empty;

  assign ctrl__iused_col      = hs_gen__oused_col;
  assign ctrl__iused_data_col = hs_gen__oused_data_col;
  assign ctrl__iused_row      = hs_gen__oused_row;
  assign ctrl__icycle_max_num = hs_gen__ocycle_max_num;

  assign ctrl__ivnode_busy    = (ctrl__ocycle_read | vnode__obusy);

  assign ctrl__icnode_busy    = (ctrl__ocycle_read | cnode__obusy);
  assign ctrl__icnode_decfail = cnode__odecfail;

  //------------------------------------------------------------------------------------------------------
  // node ram with dynamic addressing
  //------------------------------------------------------------------------------------------------------

  znode_t node_ram_wdat     ;
  znode_t node_ram_rdat     ;

  codec_mem_block
  #(
    .pADDR_W ( cNODE_RAM_ADDR_W ) ,
    .pDAT_W  ( cNODE_RAM_DAT_W  ) ,
    .pPIPE   ( 1                )
  )
  node_ram
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( node_ram__iwrite ) ,
    .iwaddr  ( node_ram__iwaddr ) ,
    .iwdat   ( node_ram__iwdat  ) ,
    //
    .iraddr  ( node_ram__iraddr ) ,
    .ordat   ( node_ram__ordat  )
  );

  assign node_ram__iraddr = hs_gen__ocycle_node_raddr[cNODE_RAM_ADDR_W-1 : 0];

  always_comb begin
    for (int z = 0; z < cZC_MAX; z++) begin
      node_ram__iwdat[z*pNODE_W +: pNODE_W] = node_ram_wdat[z];
      //
      node_ram_rdat[z]                      = node_ram__ordat[z*pNODE_W +: pNODE_W];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      node_ram__iwrite <= cnode__ocnode_val | vnode__ovnode_val;
      //
      if (cnode__ocnode_val) begin
        node_ram__iwaddr  <= cnode__ocnode_addr[cNODE_RAM_ADDR_W-1 : 0];
        node_ram_wdat     <= cnode__ocnode;
      end
      else begin
        node_ram__iwaddr  <= vnode__ovnode_addr[cNODE_RAM_ADDR_W-1 : 0];
        node_ram_wdat     <= vnode__ovnode;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // state ram with dynamic addressing
  //------------------------------------------------------------------------------------------------------

  zdat_t        state_ram_rdat_hd;
  znode_state_t state_ram_rdat_node_state;

  codec_mem_block
  #(
    .pADDR_W ( cSTATE_RAM_ADDR_W ) ,
    .pDAT_W  ( cSTATE_RAM_DAT_W  ) ,
    .pPIPE   ( 1                 )
  )
  state_ram
  (
    .iclk    ( iclk              ) ,
    .ireset  ( ireset            ) ,
    .iclkena ( iclkena           ) ,
    //
    .iwrite  ( state_ram__iwrite ) ,
    .iwaddr  ( state_ram__iwaddr ) ,
    .iwdat   ( state_ram__iwdat  ) ,
    //
    .iraddr  ( state_ram__iraddr ) ,
    .ordat   ( state_ram__ordat  )
  );

  assign state_ram__iraddr = hs_gen__ocycle_node_raddr[cSTATE_RAM_ADDR_W-1 : 0];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      state_ram__iwrite <= vnode__ovnode_val;
      state_ram__iwaddr <= vnode__ovnode_addr[cSTATE_RAM_ADDR_W-1 : 0];
      if (pUSE_SC_MODE) begin
        state_ram__iwdat[cSTATE_RAM_DAT_W-1 -: cZC_MAX] <= vnode__ovnode_hd;
        //
        for (int i = 0; i < cZC_MAX; i++) begin
          state_ram__iwdat[i*cNODE_STATE_W +: cNODE_STATE_W] <= vnode__ovnode_state[i];
        end
      end
      else begin
        state_ram__iwdat <= vnode__ovnode_hd;
      end
    end
  end

  always_comb begin
    if (pUSE_SC_MODE) begin
      state_ram_rdat_hd = state_ram__ordat[cSTATE_RAM_DAT_W-1 -: cZC_MAX];
      //
      for (int i = 0; i < cZC_MAX; i++) begin
        state_ram_rdat_node_state[i] = state_ram__ordat[i*cNODE_STATE_W +: cNODE_STATE_W];
      end
    end
    else begin
      state_ram_rdat_hd         = state_ram__ordat;
      state_ram_rdat_node_state = '{default : '0};
    end
  end

  //------------------------------------------------------------------------------------------------------
  // cnode logic
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_cnode
  #(
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pNORM_FACTOR  ( pNORM_FACTOR  ) ,
    .pNORM_OFFSET  ( pNORM_OFFSET  ) ,
    //
    .pUSE_SRL_FIFO ( pUSE_SRL_FIFO )
  )
  cnode
  (
    .iclk        ( iclk               ) ,
    .ireset      ( ireset             ) ,
    .iclkena     ( iclkena            ) ,
    //
    .istart      ( cnode__istart      ) ,
    .iload_iter  ( cnode__iload_iter  ) ,
    //
    .ival        ( cnode__ival        ) ,
    .istrb       ( cnode__istrb       ) ,
    .icnode_ctx  ( cnode__icnode_ctx  ) ,
    .iLLR        ( cnode__iLLR        ) ,
    .ivnode      ( cnode__ivnode      ) ,
    .ivnode_hd   ( cnode__ivnode_hd   ) ,
    //
    .ocnode_val  ( cnode__ocnode_val  ) ,
    .ocnode_addr ( cnode__ocnode_addr ) ,
    .ocnode      ( cnode__ocnode      ) ,
    //
    .odecfail    ( cnode__odecfail    ) ,
    .obusy       ( cnode__obusy       )
  );

  assign cnode__istart     = ctrl__ocycle_start & ctrl__oc_nv_mode;
  assign cnode__iload_iter = ctrl__oload_mode;

  assign cnode__ival       = rdat_val       [cRDAT_DELAY-1] & ctrl__oc_nv_mode;
  assign cnode__istrb      = rdat_cnode_strb[cRDAT_DELAY-1];
  assign cnode__icnode_ctx = rdat_cnode_ctx [cRDAT_DELAY-1];
  //
  assign cnode__iLLR       = irLLR ;
  assign cnode__ivnode     = node_ram_rdat ;
  assign cnode__ivnode_hd  = state_ram_rdat_hd;

  //------------------------------------------------------------------------------------------------------
  // vnode logic
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_vnode
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pNODE_W           ( pNODE_W           ) ,
    //
    .pUSE_SC_MODE      ( pUSE_SC_MODE      ) ,
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION ) ,
    //
    .pUSE_SRL_FIFO     ( pUSE_SRL_FIFO     )
  )
  vnode
  (
    .iclk         ( iclk                ) ,
    .ireset       ( ireset              ) ,
    .iclkena      ( iclkena             ) ,
    //
    .istart       ( vnode__istart       ) ,
    .iload_iter   ( vnode__iload_iter   ) ,
    //
    .ival         ( vnode__ival         ) ,
    .istrb        ( vnode__istrb        ) ,
    .ivnode_ctx   ( vnode__ivnode_ctx   ) ,
    .iLLR         ( vnode__iLLR         ) ,
    .icnode       ( vnode__icnode       ) ,
    .ivnode_state ( vnode__ivnode_state ) ,
    //
    .ovnode_val   ( vnode__ovnode_val   ) ,
    .ovnode_addr  ( vnode__ovnode_addr  ) ,
    .ovnode       ( vnode__ovnode       ) ,
    .ovnode_hd    ( vnode__ovnode_hd    ) ,
    .ovnode_state ( vnode__ovnode_state ) ,
    //
    .obitval      ( vnode__obitval      ) ,
    .obitsop      ( vnode__obitsop      ) ,
    .obiteop      ( vnode__obiteop      ) ,
    .obitdat      ( vnode__obitdat      ) ,
    .obiterr      ( vnode__obiterr      ) ,
    .obitaddr     ( vnode__obitaddr     ) ,
    //
    .obusy        ( vnode__obusy        )
  );

  assign vnode__istart       = ctrl__ocycle_start & !ctrl__oc_nv_mode;
  assign vnode__iload_iter   = ctrl__oload_mode;

  assign vnode__ival         = rdat_val       [cRDAT_DELAY-1] & !ctrl__oc_nv_mode;
  assign vnode__istrb        = rdat_vnode_strb[cRDAT_DELAY-1];
  assign vnode__ivnode_ctx   = rdat_vnode_ctx [cRDAT_DELAY-1];
  //
  assign vnode__iLLR         = irLLR;
  assign vnode__icnode       = node_ram_rdat;
  assign vnode__ivnode_state = state_ram_rdat_node_state;

  //------------------------------------------------------------------------------------------------------
  // output data mapping
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
    end
    else if (iclkena) begin
      owrite <= vnode__obitval & ctrl__olast_iter;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owdat   <= vnode__obitdat;
      owaddr  <= vnode__obitaddr[pWADDR_W-1 : 0];
      //
      // output tags hold for all cycle
      if (vnode__obitval & vnode__obitsop) begin
        owcol       <= hs_gen__oused_col;
        owdata_col  <= hs_gen__oused_data_col;
        owrow       <= hs_gen__oused_row;
        //
        owtag       <= irtag;
        owdecfail   <= ctrl__oload_mode ? 1'b0 : cnode__odecfail;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output error mapping
  //------------------------------------------------------------------------------------------------------

  codec_biterr_cnt
  #(
    .pBIT_ERR_W ( cZC_MAX ) ,
    .pERR_W     ( pERR_W  )
  )
  biterr_cnt
  (
    .iclk    ( iclk                              ) ,
    .ireset  ( ireset                            ) ,
    .iclkena ( iclkena                           ) ,
    //
    .ival    ( vnode__obitval & ctrl__olast_iter ) ,
    .isop    ( vnode__obitsop                    ) ,
    .ieop    ( vnode__obiteop                    ) ,
    .ibiterr ( vnode__obiterr                    ) ,
    //
    .oval    ( owfull                            ) ,
    .oerr    ( owerr                             )
  );

endmodule
