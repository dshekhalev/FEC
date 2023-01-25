/*



  parameter int pIDX_GR         =  0 ;
  parameter int pCODE           =  4 ;
  parameter int pDO_PUNCT       =  0 ;
  //
  parameter int pLLR_W          =  8 ;
  parameter int pNODE_W         =  8 ;
  //
  parameter int pADDR_W         =  8 ;
  //
  parameter int pTAG_W          =  4 ;
  //
  parameter int pERR_W          = 16 ;
  //
  parameter int pLLR_BY_CYCLE   =  1 ;
  parameter int pROW_BY_CYCLE   =  8 ;
  //
  parameter int pVNORM_FACTOR   =  7 ;
  parameter int pCNORM_FACTOR   =  7 ;
  //
  parameter int pUSE_FIXED_CODE =  0 ;
  parameter bit pUSE_SC_MODE    =  1 ;
  parameter bit pUSE_DBYPASS    =  0 ;
  parameter bit pUSE_HC_SROM    =  0 ;



  logic                            ldpc_3gpp_dec_engine__iclk                                                      ;
  logic                            ldpc_3gpp_dec_engine__ireset                                                    ;
  logic                            ldpc_3gpp_dec_engine__iclkena                                                   ;
  //
  logic                    [7 : 0] ldpc_3gpp_dec_engine__iNiter                                                    ;
  logic                            ldpc_3gpp_dec_engine__ifmode                                                    ;
  //
  logic                            ldpc_3gpp_dec_engine__ibuf_full                                                 ;
  logic                            ldpc_3gpp_dec_engine__obuf_rempty                                               ;
  //
  code_ctx_t                       ldpc_3gpp_dec_engine__icode_ctx                                                 ;
  //
  logic             [pTAG_W-1 : 0] ldpc_3gpp_dec_engine__itag                                                      ;
  llr_t                            ldpc_3gpp_dec_engine__iLLR                       [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  llr_t                            ldpc_3gpp_dec_engine__ipLLR       [pROW_BY_CYCLE]               [pLLR_BY_CYCLE] ;
  logic            [pADDR_W-1 : 0] ldpc_3gpp_dec_engine__oLLR_raddr                                                ;
  //
  logic                            ldpc_3gpp_dec_engine__iobuf_empty                                               ;
  //
  code_ctx_t                       ldpc_3gpp_dec_engine__ocode_ctx                                                 ;
  //
  logic                            ldpc_3gpp_dec_engine__oval                                                      ;
  logic                            ldpc_3gpp_dec_engine__osop                                                      ;
  logic                            ldpc_3gpp_dec_engine__oeop                                                      ;
  logic      [pLLR_BY_CYCLE-1 : 0] ldpc_3gpp_dec_engine__odat                       [cCOL_BY_CYCLE]                ;
  logic             [pTAG_W-1 : 0] ldpc_3gpp_dec_engine__otag                                                      ;
  //
  logic                            ldpc_3gpp_dec_engine__odecfail                                                  ;
  logic             [pERR_W-1 : 0] ldpc_3gpp_dec_engine__oerr                                                      ;



  ldpc_3gpp_dec_engine
  #(
    .pIDX_GR         ( pIDX_GR         ) ,
    .pCODE           ( pCODE           ) ,
    .pDO_PUNCT       ( pDO_PUNCT       ) ,
    //
    .pLLR_W          ( pLLR_W          ) ,
    .pNODE_W         ( pNODE_W         ) ,
    //
    .pADDR_W         ( pADDR_W         ) ,
    .pTAG_W          ( pTAG_W          ) ,
    //
    .pERR_W          ( pERR_W          ) ,
    //
    .pLLR_BY_CYCLE   ( pLLR_BY_CYCLE   ) ,
    .pROW_BY_CYCLE   ( pROW_BY_CYCLE   ) ,
    //
    .pVNORM_FACTOR   ( pVNORM_FACTOR   ) ,
    .pCNORM_FACTOR   ( pCNORM_FACTOR   ) ,
    //
    .pUSE_FIXED_CODE ( pUSE_FIXED_CODE ) ,
    .pUSE_SC_MODE    ( pUSE_SC_MODE    ) ,
    .pUSE_DBYPASS    ( pUSE_DBYPASS    ) ,
    .pUSE_HC_SROM    ( pUSE_HC_SROM    )
  )
  ldpc_3gpp_dec_engine
  (
    .iclk        ( ldpc_3gpp_dec_engine__iclk        ) ,
    .ireset      ( ldpc_3gpp_dec_engine__ireset      ) ,
    .iclkena     ( ldpc_3gpp_dec_engine__iclkena     ) ,
    //
    .iNiter      ( ldpc_3gpp_dec_engine__iNiter      ) ,
    .ifmode      ( ldpc_3gpp_dec_engine__ifmode      ) ,
    //
    .ibuf_full   ( ldpc_3gpp_dec_engine__ibuf_full   ) ,
    .obuf_rempty ( ldpc_3gpp_dec_engine__obuf_rempty ) ,
    //
    .icode_ctx   ( ldpc_3gpp_dec_engine__icode_ctx   ) ,
    //
    .itag        ( ldpc_3gpp_dec_engine__itag        ) ,
    .iLLR        ( ldpc_3gpp_dec_engine__iLLR        ) ,
    .ipLLR       ( ldpc_3gpp_dec_engine__ipLLR       ) ,
    .oLLR_raddr  ( ldpc_3gpp_dec_engine__oLLR_raddr  ) ,
    //
    .iobuf_empty ( ldpc_3gpp_dec_engine__iobuf_empty ) ,
    //
    .ocode_ctx   ( ldpc_3gpp_dec_engine__ocode_ctx   ) ,
    //
    .oval        ( ldpc_3gpp_dec_engine__oval        ) ,
    .osop        ( ldpc_3gpp_dec_engine__osop        ) ,
    .oeop        ( ldpc_3gpp_dec_engine__oeop        ) ,
    .odat        ( ldpc_3gpp_dec_engine__odat        ) ,
    .otag        ( ldpc_3gpp_dec_engine__otag        ) ,
    //
    .odecfail    ( ldpc_3gpp_dec_engine__odecfail    ) ,
    .oerr        ( ldpc_3gpp_dec_engine__oerr        )
  );


  assign ldpc_3gpp_dec_engine__iclk        = '0 ;
  assign ldpc_3gpp_dec_engine__ireset      = '0 ;
  assign ldpc_3gpp_dec_engine__iclkena     = '0 ;
  assign ldpc_3gpp_dec_engine__iNiter      = '0 ;
  assign ldpc_3gpp_dec_engine__ifmode      = '0 ;
  assign ldpc_3gpp_dec_engine__ibuf_full   = '0 ;
  assign ldpc_3gpp_dec_engine__icode_ctx   = '0 ;
  assign ldpc_3gpp_dec_engine__itag        = '0 ;
  assign ldpc_3gpp_dec_engine__iLLR        = '0 ;
  assign ldpc_3gpp_dec_engine__ipLLR       = '0 ;
  assign ldpc_3gpp_dec_engine__iobuf_empty = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_engine.sv
// Description   : LDPC decoder engine with variable parameters based upon duo-phase decoding
//

`include "define.vh"

module ldpc_3gpp_dec_engine
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  iNiter      ,
  ifmode      ,
  //
  ibuf_full   ,
  obuf_rempty ,
  //
  icode_ctx   ,
  //
  itag        ,
  iLLR        ,
  ipLLR       ,
  oLLR_raddr  ,
  //
  iobuf_empty ,
  //
  ocode_ctx   ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  otag        ,
  //
  odecfail    ,
  oerr
);

  parameter int pADDR_W         =  8 ;
  parameter int pTAG_W          =  4 ;
  //
  parameter int pERR_W          = 16 ;
  //
  parameter int pVNORM_FACTOR   =  7 ;
  parameter int pCNORM_FACTOR   =  7 ;
  //
  parameter bit pUSE_FIXED_CODE =  0 ;  // use variable of fixed mode engine
  parameter bit pUSE_DBYPASS    =  0 ;  // use no decoding(bypass) mode if Niter == 0
  parameter bit pUSE_HC_SROM    =  0 ;  // use small rom for HC

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                            iclk                                                      ;
  input  logic                            ireset                                                    ;
  input  logic                            iclkena                                                   ;
  //
  input  logic                    [7 : 0] iNiter                                                    ;
  input  logic                            ifmode                                                    ; // fast work mode with early stop
  //
  input  logic                            ibuf_full                                                 ;
  output logic                            obuf_rempty                                               ;
  //
  input  code_ctx_t                       icode_ctx                                                 ;
  //
  input  logic             [pTAG_W-1 : 0] itag                                                      ;
  input  llr_t                            iLLR                       [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  input  llr_t                            ipLLR       [pROW_BY_CYCLE]               [pLLR_BY_CYCLE] ;
  output logic            [pADDR_W-1 : 0] oLLR_raddr                                                ;
  //
  input  logic                            iobuf_empty                                               ;
  //
  output code_ctx_t                       ocode_ctx                                                 ;
  //
  output logic                            owrite                                                    ;
  output logic                            owfull                                                    ;
  output logic            [pADDR_W-1 : 0] owaddr                                                    ;
  output logic      [pLLR_BY_CYCLE-1 : 0] owdat                      [cCOL_BY_CYCLE]                ;
  output logic             [pTAG_W-1 : 0] otag                                                      ;
  //
  output logic                            odecfail                                                  ;
  output logic             [pERR_W-1 : 0] oerr                                                      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // table generator
  logic                           hb_tab__ibuf_full    ;
  logic                           hb_tab__obuf_rempty  ;
  //
  code_ctx_t                      hb_tab__icode_ctx    ;
  //
  logic                           hb_tab__ictrl_rempty ;
  logic                           hb_tab__octrl_full   ;

  code_ctx_t                      hb_tab__ocode_ctx    ;
  logic                           hb_tab__oupdate_done ;

  hb_zc_t                         hb_tab__oused_zc                       ;
  hb_row_t                        hb_tab__oused_row                      ;
  //
  hb_row_t                        hb_tab__iwrow                          ;
  hb_row_t                        hb_tab__irrow                          ;
  //
  mm_hb_value_t                   hb_tab__orHb       [pROW_BY_CYCLE][26] ;
  mm_hb_value_t                   hb_tab__owHb       [pROW_BY_CYCLE][26] ;
  logic                           hb_tab__orHb_pmask [pROW_BY_CYCLE]     ;

  //
  // ctrl
  logic                           ctrl__ibuf_full      ;
  logic                           ctrl__iobuf_empty    ;
  logic                           ctrl__obuf_rempty    ;
  //
  hb_zc_t                         ctrl__iused_zc       ;
  hb_row_t                        ctrl__iused_row      ;
  //
  logic                           ctrl__ivnode_busy    ;
  //
  logic                           ctrl__icnode_busy    ;
  logic                           ctrl__icnode_decfail ;
  //
  logic                           ctrl__oload_mode     ;
  logic                           ctrl__oc_nv_mode     ;
  //
  logic                           ctrl__oread          ;
  logic                           ctrl__orstart        ;
  logic                           ctrl__orval          ;
  strb_t                          ctrl__orstrb         ;
  hb_row_t                        ctrl__orrow          ;

  logic                           ctrl__olast_iter     ;

  //
  // address gen
  logic                           LLR_addr_gen__ic_nv_mode                 ;
  hb_zc_t                         LLR_addr_gen__iused_zc                   ;
  //
  logic                           LLR_addr_gen__iread                      ;
  logic                           LLR_addr_gen__irstart                    ;
  logic                           LLR_addr_gen__irmask     [pROW_BY_CYCLE] ;
  logic                           LLR_addr_gen__irval                      ;
  strb_t                          LLR_addr_gen__irstrb                     ;

  logic                           LLR_addr_gen__orval                      ;
  strb_t                          LLR_addr_gen__orstrb                     ;
  logic                           LLR_addr_gen__ormask     [pROW_BY_CYCLE] ;

  //
  // mem
  hb_zc_t                         mem__iused_zc                                                    ;
  logic                           mem__ic_nv_mode                                                  ;
  //
  logic                           mem__iwrite                                                      ;
  mm_hb_value_t                   mem__iwHb          [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  strb_t                          mem__iwstrb                                                      ;
  node_t                          mem__iwdat         [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t                    mem__iwstate       [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic                           mem__iread                                                       ;
  logic                           mem__irstart                                                     ;
  mm_hb_value_t                   mem__irHb          [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  logic                           mem__irval                                                       ;
  strb_t                          mem__irstrb                                                      ;
  //
  logic                           mem__ocnode_rval                                                 ;
  strb_t                          mem__ocnode_rstrb                                                ;
  logic                           mem__ocnode_rmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t                          mem__ocnode_rdat   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t                    mem__ocnode_rstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic                           mem__ovnode_rval                                                 ;
  strb_t                          mem__ovnode_rstrb                                                ;
  logic                           mem__ovnode_rmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t                          mem__ovnode_rdat   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t                    mem__ovnode_rstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;

  //
  // cnode
  logic                           cnode__ival                                                   ;
  strb_t                          cnode__istrb                                                  ;
  logic                           cnode__ivmask   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t                          cnode__ivnode   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t                    cnode__ivstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic                           cnode__ipmask   [pROW_BY_CYCLE]                               ;
  llr_t                           cnode__ipLLR    [pROW_BY_CYCLE]               [pLLR_BY_CYCLE] ;
  //
  logic                           cnode__oval                                                   ;
  strb_t                          cnode__ostrb                                                  ;
  hb_row_t                        cnode__orow                                                   ;
  node_t                          cnode__ocnode   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t                    cnode__ocstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic                           cnode__odecfail                                               ;
  logic                           cnode__obusy                                                  ;

  //
  // vnode
  logic                           vnode__iidxGr                                                ;
  logic                           vnode__ido_punct                                             ;
  hb_row_t                        vnode__iused_row                                             ;
  //
  logic                           vnode__ival                                                  ;
  strb_t                          vnode__istrb                                                 ;
  llr_t                           vnode__iLLR                   [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_t                          vnode__icnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic                           vnode__icmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_state_t                    vnode__icstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic                           vnode__iuval                                                 ;
  strb_t                          vnode__iustrb                                                ;
  llr_t                           vnode__iuLLR                  [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic                           vnode__oval                                                  ;
  strb_t                          vnode__ostrb                                                 ;
  node_t                          vnode__ovnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t                    vnode__ovstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic                           vnode__obitval                                               ;
  logic                           vnode__obitsop                                               ;
  logic                           vnode__obiteop                                               ;
  logic     [pLLR_BY_CYCLE-1 : 0] vnode__obitdat                [cCOL_BY_CYCLE]                ;
  logic     [pLLR_BY_CYCLE-1 : 0] vnode__obiterr                [cCOL_BY_CYCLE]                ;
  //
  logic                           vnode__obusy                                                 ;

  //------------------------------------------------------------------------------------------------------
  // hb
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_FIXED_CODE) begin
      ldpc_3gpp_dec_hb
      #(
        .pIDX_GR       ( pIDX_GR       ) ,
        .pIDX_LS       ( pIDX_LS       ) ,
        .pIDX_ZC       ( pIDX_ZC       ) ,
        .pCODE         ( pCODE         ) ,
        .pDO_PUNCT     ( pDO_PUNCT     ) ,
        //
        .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
        .pROW_BY_CYCLE ( pROW_BY_CYCLE )
      )
      hb_tab
      (
        .iclk       ( iclk               ) ,
        .ireset     ( ireset             ) ,
        .iclkena    ( iclkena            ) ,
        //
        .oused_zc   ( hb_tab__oused_zc   ) ,
        .oused_row  ( hb_tab__oused_row  ) ,
        //
        .irrow      ( hb_tab__irrow      ) ,
        .iwrow      ( hb_tab__iwrow      ) ,
        //
        .orHb       ( hb_tab__orHb       ) ,
        .owHb       ( hb_tab__owHb       ) ,
        .orHb_pmask ( hb_tab__orHb_pmask )
      );

      assign hb_tab__obuf_rempty        = ctrl__obuf_rempty;

      assign hb_tab__ocode_ctx.idxGr    = pIDX_GR;
      assign hb_tab__ocode_ctx.idxLs    = pIDX_LS;
      assign hb_tab__ocode_ctx.idxZc    = pIDX_ZC;
      assign hb_tab__ocode_ctx.code     = pCODE;
      assign hb_tab__ocode_ctx.do_punct = pDO_PUNCT;

      assign hb_tab__octrl_full         = ibuf_full;

      assign hb_tab__oupdate_done       = 1'b1;

    end
    else begin
      ldpc_3gpp_dec_hb_gen
      #(
        .pIDX_GR       ( pIDX_GR       ) ,
        .pCODE         ( pCODE         ) ,
        //
        .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
        .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
        //
        .pUSE_HC_SROM  ( pUSE_HC_SROM  )
      )
      hb_tab
      (
        .iclk         ( iclk                 ) ,
        .ireset       ( ireset               ) ,
        .iclkena      ( iclkena              ) ,
        //
        .ibuf_full    ( hb_tab__ibuf_full    ) ,
        .obuf_rempty  ( hb_tab__obuf_rempty  ) ,
        //
        .icode_ctx    ( hb_tab__icode_ctx    ) ,
        //
        .ictrl_rempty ( hb_tab__ictrl_rempty ) ,
        .octrl_full   ( hb_tab__octrl_full   ) ,
        //
        .ocode_ctx    ( hb_tab__ocode_ctx    ) ,
        .oupdate_done ( hb_tab__oupdate_done ) ,
        //
        .oused_llr_bc (                      ) ,  // n.u.
        .oused_zc     ( hb_tab__oused_zc     ) ,
        .oused_row    ( hb_tab__oused_row    ) ,
        //
        .irrow        ( hb_tab__irrow        ) ,
        .iwrow        ( hb_tab__iwrow        ) ,
        //
        .orHb         ( hb_tab__orHb         ) ,
        .owHb         ( hb_tab__owHb         ) ,
        .orHb_pmask   ( hb_tab__orHb_pmask   )
      );

      assign hb_tab__ibuf_full    = ibuf_full;
      assign hb_tab__icode_ctx    = icode_ctx;

      assign hb_tab__ictrl_rempty = ctrl__obuf_rempty;

    end
  endgenerate

  assign hb_tab__irrow        = ctrl__orrow;
  assign hb_tab__iwrow        = cnode__orow;

  assign obuf_rempty          = hb_tab__obuf_rempty;

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  logic cnode_busy;
  logic vnode_busy;

  ldpc_3gpp_dec_ctrl
  #(
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    .pUSE_DBYPASS  ( pUSE_DBYPASS  )
  )
  ctrl
  (
    .iclk           ( iclk                 ) ,
    .ireset         ( ireset               ) ,
    .iclkena        ( iclkena              ) ,
    //
    .iNiter         ( iNiter               ) ,
    .ifmode         ( ifmode               ) ,
    //
    .ibuf_full      ( ctrl__ibuf_full      ) ,
    .iobuf_empty    ( ctrl__iobuf_empty    ) ,
    .obuf_rempty    ( ctrl__obuf_rempty    ) ,
    //
    .iused_zc       ( ctrl__iused_zc       ) ,
    .iused_row      ( ctrl__iused_row      ) ,
    //
    .ivnode_busy    ( ctrl__ivnode_busy    ) ,
    //
    .icnode_busy    ( ctrl__icnode_busy    ) ,
    .icnode_decfail ( ctrl__icnode_decfail ) ,
    //
    .oload_mode     ( ctrl__oload_mode     ) ,
    .oc_nv_mode     ( ctrl__oc_nv_mode     ) ,
    //
    .oread          ( ctrl__oread          ) ,
    .orstart        ( ctrl__orstart        ) ,
    .orval          ( ctrl__orval          ) ,
    .orstrb         ( ctrl__orstrb         ) ,
    .orrow          ( ctrl__orrow          ) ,
    //
    .olast_iter     ( ctrl__olast_iter     )
  );

  assign ctrl__ibuf_full      = hb_tab__octrl_full ;

  assign ctrl__iobuf_empty    = iobuf_empty ;

  assign ctrl__iused_zc       = hb_tab__oused_zc;
  assign ctrl__iused_row      = hb_tab__oused_row ;

  assign ctrl__ivnode_busy    = (ctrl__oread | vnode_busy) | !hb_tab__oupdate_done; // delay first iteration (upload) if need

  assign ctrl__icnode_busy    = (ctrl__oread | cnode_busy);
  assign ctrl__icnode_decfail = cnode__odecfail;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      vnode_busy <= 1'b0;
      cnode_busy <= 1'b0;
    end
    else if (iclkena) begin
      if (ctrl__oread & ctrl__orstrb.sof & !ctrl__oc_nv_mode) begin
        vnode_busy <= 1'b1;
      end
      else if (vnode__oval & vnode__ostrb.eof & vnode__ostrb.eop) begin
        vnode_busy <= 1'b0;
      end
      //
      if (ctrl__oread & ctrl__orstrb.sof &  ctrl__oc_nv_mode) begin
        cnode_busy <= 1'b1;
      end
      else if (cnode__oval & cnode__ostrb.eof & cnode__ostrb.eop) begin
        cnode_busy <= 1'b0;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // LLR/pLLR read address generator
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_LLR_addr_gen
  #(
    .pADDR_W       ( pADDR_W       ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE )
  )
  LLR_addr_gen
  (
    .iclk       ( iclk                     ) ,
    .ireset     ( ireset                   ) ,
    .iclkena    ( iclkena                  ) ,
    //
    .iused_zc   ( LLR_addr_gen__iused_zc   ) ,
    .ic_nv_mode ( LLR_addr_gen__ic_nv_mode ) ,
    //
    .iread      ( LLR_addr_gen__iread      ) ,
    .irstart    ( LLR_addr_gen__irstart    ) ,
    .irmask     ( LLR_addr_gen__irmask     ) ,
    .irval      ( LLR_addr_gen__irval      ) ,
    .irstrb     ( LLR_addr_gen__irstrb     ) ,
    //
    .oLLR_raddr ( oLLR_raddr               ) ,
    //
    .orval      ( LLR_addr_gen__orval      ) ,
    .orstrb     ( LLR_addr_gen__orstrb     ) ,
    .ormask     ( LLR_addr_gen__ormask     )
  );

  assign LLR_addr_gen__ic_nv_mode = ctrl__oc_nv_mode;

  assign LLR_addr_gen__iused_zc   = hb_tab__oused_zc;

  assign LLR_addr_gen__iread      = ctrl__oread;
  assign LLR_addr_gen__irstart    = ctrl__orstart;

  assign LLR_addr_gen__irmask     = hb_tab__orHb_pmask;

  assign LLR_addr_gen__irval      = ctrl__orval;
  assign LLR_addr_gen__irstrb     = ctrl__orstrb;

  //------------------------------------------------------------------------------------------------------
  // mem
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_mem
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pCODE         ( pCODE         ) ,  // need to optimize ram HC_MASK
    //
    .pADDR_W       ( pADDR_W       ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pUSE_SC_MODE  ( pUSE_SC_MODE  )
  )
  mem
  (
    .iclk          ( iclk               ) ,
    .ireset        ( ireset             ) ,
    .iclkena       ( iclkena            ) ,
    //
    .iused_zc      ( mem__iused_zc      ) ,
    .ic_nv_mode    ( mem__ic_nv_mode    ) ,
    //
    .iwrite        ( mem__iwrite        ) ,
    .iwHb          ( mem__iwHb          ) ,
    .iwstrb        ( mem__iwstrb        ) ,
    .iwdat         ( mem__iwdat         ) ,
    .iwstate       ( mem__iwstate       ) ,
    //
    .iread         ( mem__iread         ) ,
    .irstart       ( mem__irstart       ) ,
    .irHb          ( mem__irHb          ) ,
    .irval         ( mem__irval         ) ,
    .irstrb        ( mem__irstrb        ) ,
    //
    .ocnode_rval   ( mem__ocnode_rval   ) ,
    .ocnode_rstrb  ( mem__ocnode_rstrb  ) ,
    .ocnode_rmask  ( mem__ocnode_rmask  ) ,
    .ocnode_rdat   ( mem__ocnode_rdat   ) ,
    .ocnode_rstate ( mem__ocnode_rstate ) ,
    //
    .ovnode_rval   ( mem__ovnode_rval   ) ,
    .ovnode_rstrb  ( mem__ovnode_rstrb  ) ,
    .ovnode_rmask  ( mem__ovnode_rmask  ) ,
    .ovnode_rdat   ( mem__ovnode_rdat   ) ,
    .ovnode_rstate ( mem__ovnode_rstate )
  );

  assign mem__iused_zc    = hb_tab__oused_zc;
  assign mem__iwHb        = hb_tab__owHb ;    // 1 tick read delay

  assign mem__ic_nv_mode  = ctrl__oc_nv_mode;

  // align Hb table read delay
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ctrl__oc_nv_mode) begin
        mem__iwrite   <= cnode__oval   ;
        mem__iwstrb   <= cnode__ostrb  ;
        mem__iwdat    <= cnode__ocnode ;
        mem__iwstate  <= cnode__ocstate;
      end
      else begin
        mem__iwrite   <= vnode__oval   ;
        mem__iwstrb   <= vnode__ostrb  ;
        mem__iwdat    <= vnode__ovnode ;
        mem__iwstate  <= vnode__ovstate;
      end
    end
  end

  assign mem__irHb      = hb_tab__orHb ;  // 1 tick read delay

  assign mem__iread     = ctrl__oread  ;
  assign mem__irstart   = ctrl__orstart;
  assign mem__irval     = ctrl__orval  ;
  assign mem__irstrb    = ctrl__orstrb ;

  //------------------------------------------------------------------------------------------------------
  // cnode
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_cnode
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pNORM_FACTOR  ( pCNORM_FACTOR )
  )
  cnode
  (
    .iclk     ( iclk            ) ,
    .ireset   ( ireset          ) ,
    .iclkena  ( iclkena         ) ,
    //
    .ival     ( cnode__ival     ) ,
    .istrb    ( cnode__istrb    ) ,
    .ivmask   ( cnode__ivmask   ) ,
    .ivnode   ( cnode__ivnode   ) ,
    .ivstate  ( cnode__ivstate  ) ,
    .ipmask   ( cnode__ipmask   ) ,
    .ipLLR    ( cnode__ipLLR    ) ,
    //
    .oval     ( cnode__oval     ) ,
    .ostrb    ( cnode__ostrb    ) ,
    .orow     ( cnode__orow     ) ,
    .ocnode   ( cnode__ocnode   ) ,
    .ocstate  ( cnode__ocstate  ) ,
    //
    .odecfail ( cnode__odecfail ) ,
    .obusy    ( cnode__obusy    )
  );

  generate
    if (pLLR_BY_CYCLE == 1) begin
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          cnode__ival <= 1'b0;
        end
        else if (iclkena) begin
          cnode__ival <= mem__ocnode_rval;
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          cnode__istrb   <= mem__ocnode_rstrb;
          //
          cnode__ivmask  <= mem__ocnode_rmask;
          cnode__ivnode  <= mem__ocnode_rdat;
          cnode__ivstate <= mem__ocnode_rstate;
          //
          cnode__ipLLR   <= ipLLR;
          cnode__ipmask  <= LLR_addr_gen__ormask;
        end
      end
    end
    else begin
      logic   cnode_pmask [pROW_BY_CYCLE]                ;
      llr_t   cnode_pLLR  [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;

      assign cnode__ival    = mem__ocnode_rval;
      assign cnode__istrb   = mem__ocnode_rstrb;

      assign cnode__ivmask  = mem__ocnode_rmask;
      assign cnode__ivnode  = mem__ocnode_rdat;
      assign cnode__ivstate = mem__ocnode_rstate;

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          cnode_pLLR    <= ipLLR;
          cnode_pmask   <= LLR_addr_gen__ormask;
          //
          cnode__ipLLR  <= cnode_pLLR;
          cnode__ipmask <= cnode_pmask;
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // vnode
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_vnode
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pCODE         ( pCODE         ) ,  // need to optimize cnode delay's
    .pDO_PUNCT     ( pDO_PUNCT     ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pNORM_FACTOR  ( pVNORM_FACTOR ) ,
    .pUSE_SC_MODE  ( pUSE_SC_MODE  ) ,
    .pUSE_DBYPASS  ( pUSE_DBYPASS  )
  )
  vnode
  (
    .iclk      ( iclk             ) ,
    .ireset    ( ireset           ) ,
    .iclkena   ( iclkena          ) ,
    //
    .iidxGr    ( vnode__iidxGr    ) ,
    .ido_punct ( vnode__ido_punct ) ,
    .iused_row ( vnode__iused_row ) ,
    //
    .ival      ( vnode__ival      ) ,
    .istrb     ( vnode__istrb     ) ,
    .iLLR      ( vnode__iLLR      ) ,
    .icnode    ( vnode__icnode    ) ,
    .icmask    ( vnode__icmask    ) ,
    .icstate   ( vnode__icstate   ) ,
    //
    .iuval     ( vnode__iuval     ) ,
    .iustrb    ( vnode__iustrb    ) ,
    .iuLLR     ( vnode__iuLLR     ) ,
    //
    .oval      ( vnode__oval      ) ,
    .ostrb     ( vnode__ostrb     ) ,
    .ovnode    ( vnode__ovnode    ) ,
    .ovstate   ( vnode__ovstate   ) ,
    //
    .obitval   ( vnode__obitval   ) ,
    .obitsop   ( vnode__obitsop   ) ,
    .obiteop   ( vnode__obiteop   ) ,
    .obitdat   ( vnode__obitdat   ) ,
    .obiterr   ( vnode__obiterr   ) ,
    //
    .obusy     ( vnode__obusy     )
  );

  assign vnode__iidxGr    = hb_tab__ocode_ctx.idxGr;
  assign vnode__ido_punct = hb_tab__ocode_ctx.do_punct;
  assign vnode__iused_row = hb_tab__oused_row;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      vnode__ival   <= 1'b0;
      vnode__iuval  <= 1'b0;
    end
    else if (iclkena) begin
      vnode__ival   <= mem__ovnode_rval & !ctrl__oload_mode;
      vnode__iuval  <= mem__ovnode_rval &  ctrl__oload_mode ;
    end
  end

  always_ff @(posedge iclk) begin
    vnode__istrb    <= mem__ovnode_rstrb ;
    // need to hold for correct multi row initialization
    if (mem__ovnode_rval & mem__ovnode_rstrb.sop) begin
      vnode__iLLR   <= iLLR ;
    end
    //
    vnode__icnode   <= mem__ovnode_rdat ;
    vnode__icmask   <= mem__ovnode_rmask ;
    vnode__icstate  <= mem__ovnode_rstate ;
    //
    vnode__iustrb   <= mem__ovnode_rstrb ;
  end

  assign vnode__iuLLR = vnode__iLLR; // it's the same

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
      owdat <= vnode__obitdat;
      //
      if (vnode__obitval) begin
        owaddr  <= vnode__obitsop ? '0 : (owaddr + 1'b1);
      end
      //
      // output tags hold for all cycle
      if (vnode__obitval & vnode__obitsop) begin
        otag      <= itag;
        ocode_ctx <= hb_tab__ocode_ctx;
        odecfail  <= ctrl__oload_mode ? 1'b0 : cnode__odecfail;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output error mapping
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_biterr_cnt
  #(
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pCOL_BY_CYCLE ( cCOL_BY_CYCLE ) ,
    .pERR_W        ( pERR_W        )
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
    .oerr    ( oerr                              )
  );

endmodule
