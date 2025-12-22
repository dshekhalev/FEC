/*



  parameter int pIDX_GR         = 0 ;
  parameter int pCODE           = 4 ;
  //
  parameter int pRADDR_W        = 8 ;
  parameter int pWADDR_W        = 8 ;
  parameter int pDAT_W          = 8 ;
  parameter int pTAG_W          = 4 ;
  //
  parameter bit pUSE_FIXED_CODE = 0 ;
  parameter bit pUSE_P1_SLOW    = 0 ;
  parameter bit pUSE_HC_SROM    = 0 ;
  parameter bit pUSE_VAR_DAT_W  = 0 ;



  logic                       ldpc_3gpp_enc_engine__iclk        ;
  logic                       ldpc_3gpp_enc_engine__ireset      ;
  logic                       ldpc_3gpp_enc_engine__iclkena     ;
  //
  logic                       ldpc_3gpp_enc_engine__irbuf_full  ;
  //
  code_ctx_t                  ldpc_3gpp_enc_engine__icode_ctx   ;
  //
  logic        [pDAT_W-1 : 0] ldpc_3gpp_enc_engine__irdat       ;
  logic        [pTAG_W-1 : 0] ldpc_3gpp_enc_engine__irtag       ;
  logic                       ldpc_3gpp_enc_engine__orempty     ;
  logic      [pRADDR_W-1 : 0] ldpc_3gpp_enc_engine__oraddr      ;
  //
  logic                       ldpc_3gpp_enc_engine__iwbuf_empty ;
  //
  code_ctx_t                  ldpc_3gpp_enc_engine__ocode_ctx   ;
  //
  logic                       ldpc_3gpp_enc_engine__owrite      ;
  logic                       ldpc_3gpp_enc_engine__owfull      ;
  logic      [pWADDR_W-1 : 0] ldpc_3gpp_enc_engine__owaddr      ;
  logic        [pDAT_W-1 : 0] ldpc_3gpp_enc_engine__owdat       ;
  logic        [pTAG_W-1 : 0] ldpc_3gpp_enc_engine__owtag       ;



  ldpc_3gpp_enc_engine
  #(
    .pIDX_GR         ( pIDX_GR         ) ,
    .pCODE           ( pCODE           ) ,
    //
    .pRADDR_W        ( pRADDR_W        ) ,
    .pWADDR_W        ( pWADDR_W        ) ,
    .pDAT_W          ( pDAT_W          ) ,
    .pTAG_W          ( pTAG_W          ) ,
    //
    .pUSE_FIXED_CODE ( pUSE_FIXED_CODE ) ,
    .pUSE_P1_SLOW    ( pUSE_P1_SLOW    ) ,
    .pUSE_HC_SROM    ( pUSE_HC_SROM    ) ,
    .pUSE_VAR_DAT_W  ( pUSE_VAR_DAT_W  )
  )
  ldpc_3gpp_enc_engine
  (
    .iclk        ( ldpc_3gpp_enc_engine__iclk        ) ,
    .ireset      ( ldpc_3gpp_enc_engine__ireset      ) ,
    .iclkena     ( ldpc_3gpp_enc_engine__iclkena     ) ,
    //
    .irbuf_full  ( ldpc_3gpp_enc_engine__irbuf_full  ) ,
    //
    .icode_ctx   ( ldpc_3gpp_enc_engine__icode_ctx   ) ,
    //
    .irdat       ( ldpc_3gpp_enc_engine__irdat       ) ,
    .irtag       ( ldpc_3gpp_enc_engine__irtag       ) ,
    .orempty     ( ldpc_3gpp_enc_engine__orempty     ) ,
    .oraddr      ( ldpc_3gpp_enc_engine__oraddr      ) ,
    //
    .iwbuf_empty ( ldpc_3gpp_enc_engine__iwbuf_empty ) ,
    //
    .ocode_ctx   ( ldpc_3gpp_enc_engine__ocode_ctx   ) ,
    //
    .owrite      ( ldpc_3gpp_enc_engine__owrite      ) ,
    .owfull      ( ldpc_3gpp_enc_engine__owfull      ) ,
    .owaddr      ( ldpc_3gpp_enc_engine__owaddr      ) ,
    .owdat       ( ldpc_3gpp_enc_engine__owdat       ) ,
    .owtag       ( ldpc_3gpp_enc_engine__owtag       )
  );


  assign ldpc_3gpp_enc_engine__iclk        = '0 ;
  assign ldpc_3gpp_enc_engine__ireset      = '0 ;
  assign ldpc_3gpp_enc_engine__iclkena     = '0 ;
  assign ldpc_3gpp_enc_engine__irbuf_full  = '0 ;
  assign ldpc_3gpp_enc_engine__icode_ctx   = '0 ;
  assign ldpc_3gpp_enc_engine__irdat       = '0 ;
  assign ldpc_3gpp_enc_engine__irtag       = '0 ;
  assign ldpc_3gpp_enc_engine__iwbuf_empty = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_engine.sv
// Description   : variable mode 3GPP LDPC RTL encoder engine
//

module ldpc_3gpp_enc_engine
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  irbuf_full  ,
  //
  icode_ctx   ,
  //
  irdat       ,
  irtag       ,
  orempty     ,
  oraddr      ,
  //
  iwbuf_empty ,
  //
  ocode_ctx   ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  owtag
);

  parameter int pRADDR_W        = 8 ;
  parameter int pWADDR_W        = 8 ;
  parameter int pTAG_W          = 4 ;

  parameter bit pUSE_FIXED_CODE = 0 ; // use variable of fixed mode engine
  parameter bit pUSE_P1_SLOW    = 0 ; // use slow sequential mathematics for P1 couning
  parameter bit pUSE_HC_SROM    = 0 ; // use small rom for HC
  parameter bit pUSE_VAR_DAT_W  = 0 ; // used dat bitwidth is fixed pDAT_W or variable

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk        ;
  input  logic                       ireset      ;
  input  logic                       iclkena     ;
  //
  input  logic                       irbuf_full  ;
  //
  input  code_ctx_t                  icode_ctx   ;
  //
  input  logic        [pDAT_W-1 : 0] irdat       ;
  input  logic        [pTAG_W-1 : 0] irtag       ;
  output logic                       orempty     ;
  output logic      [pRADDR_W-1 : 0] oraddr      ;
  //
  input  logic                       iwbuf_empty ;
  //
  output code_ctx_t                  ocode_ctx   ;
  //
  output logic                       owrite      ;
  output logic                       owfull      ;
  output logic      [pWADDR_W-1 : 0] owaddr      ;
  output logic        [pDAT_W-1 : 0] owdat       ;
  output logic        [pTAG_W-1 : 0] owtag       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cZC            = pUSE_FIXED_CODE ? cZC_TAB[pIDX_LS][pIDX_ZC]/pDAT_W : cZC_MAX/pDAT_W;

  localparam int cMATRIX_ADDR_W = $clog2(cZC);
  localparam bit cMATRIX_PIPE   = 1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // read address generator
  logic                  raddr_gen__iclear  ;
  logic                  raddr_gen__ienable ;
  //
  logic [pRADDR_W-1 : 0] raddr_gen__oraddr  ;
  logic                  raddr_gen__orval   ;

  //
  // table generator
  logic                  hb_tab__ibuf_full         ;
  logic                  hb_tab__obuf_rempty       ;
  //
  code_ctx_t             hb_tab__icode_ctx         ;
  code_ctx_t             hb_tab__ocode_ctx         ;
  //
  logic                  hb_tab__ictrl_rempty      ;
  logic                  hb_tab__octrl_full        ;

  hb_row_t               hb_tab__irow              ;
  //
  hb_zc_t                hb_tab__oused_dat_w       ;
  hb_zc_t                hb_tab__oused_zc          ;
  hb_row_t               hb_tab__oused_row         ;
  hb_col_t               hb_tab__oused_col         ;
  //
  mm_hb_value_t          hb_tab__ou_AC     [4][22] ;

  mm_hb_value_t          hb_tab__oinvPsi           ;
  logic                  hb_tab__oinvPsi_zero      ;

  mm_hb_value_t          hb_tab__op1_B         [3] ;
  mm_hb_value_t          hb_tab__op12_P        [3] ;

  //
  // ctrl
  logic                  ctrl__ibuf_full    ;
  logic                  ctrl__obuf_rempty  ;
  logic                  ctrl__iobuf_empty  ;
  //
  logic                  ctrl__iinvPsi_zero ;
  hb_zc_t                ctrl__iused_zc     ;
  hb_row_t               ctrl__iused_row    ;
  hb_col_t               ctrl__iused_col    ;
  //
  logic                  ctrl__oaddr_clear  ;
  logic                  ctrl__oaddr_enable ;
  //
  hb_row_t               ctrl__ohb_row      ;
  //
  logic                  ctrl__oacu_write   ;
  logic                  ctrl__oacu_wstart  ;
  strb_t                 ctrl__oacu_wstrb   ;
  hb_col_t               ctrl__oacu_wcol    ;
  //
  logic                  ctrl__oacu_read    ;
  logic                  ctrl__oacu_rstart  ;
  logic                  ctrl__oacu_rval    ;
  strb_t                 ctrl__oacu_rstrb   ;
  hb_row_t               ctrl__oacu_rrow    ;
  //
  logic                  ctrl__op1_read     ;
  logic                  ctrl__op1_rstart   ;
  logic                  ctrl__op1_rval     ;
  strb_t                 ctrl__op1_rstrb    ;
  //
  logic                  ctrl__op2_read     ;
  logic                  ctrl__op2_rstart   ;
  logic                  ctrl__op2_rval     ;
  strb_t                 ctrl__op2_rstrb    ;
  hb_row_t               ctrl__op2_rrow     ;
  //
  logic                  ctrl__op3_read     ;
  logic                  ctrl__op3_rstart   ;
  logic                  ctrl__op3_rval     ;
  strb_t                 ctrl__op3_rstrb    ;

  //
  // acu
  hb_zc_t                acu__iused_dat_w         ;
  hb_zc_t                acu__iused_zc            ;
  //
  logic                  acu__iwrite              ;
  logic                  acu__iwstart             ;
  strb_t                 acu__iwstrb              ;
  hb_col_t               acu__iwcol               ;
  dat_t                  acu__iwdat               ;
  //
  logic                  acu__ip_nm_mode          ;
  //
  logic                  acu__iread               ;
  logic                  acu__irstart             ;
  logic                  acu__irval               ;
  strb_t                 acu__irstrb              ;
  hb_row_t               acu__irrow               ;
  mm_hb_value_t          acu__irHb        [4][22] ;
  //
  dat_t                  acu__irdat2au            ;
  //
  logic                  acu__oval                ;
  logic                  acu__opmask              ;
  strb_t                 acu__ostrb               ;
  dat_t                  acu__odat                ;
  //
  logic                  acu__owrite2p1           ;
  logic                  acu__owstart2p1          ;
  dat_t                  acu__owdat2p1            ;
  //
  logic [2 : 0]          acu__owrite2p2           ;
  logic                  acu__owstart2p2          ;
  dat_t                  acu__owdat2p2        [3] ;
  //
  logic                  acu__owrite2p3           ;
  logic                  acu__owstart2p3          ;
  dat_t                  acu__owdat2p3            ;

  //
  // p1
  hb_zc_t                p1__iused_dat_w  ;
  hb_zc_t                p1__iused_zc     ;
  logic                  p1__ibypass      ;
  //
  logic                  p1__iwrite       ;
  logic                  p1__iwstart      ;
  dat_t                  p1__iwdat        ;
  //
  logic                  p1__iread        ;
  logic                  p1__irstart      ;
  logic                  p1__irval        ;
  strb_t                 p1__irstrb       ;
  mm_hb_value_t          p1__iinvPsi      ;
  //
  logic                  p1__oval         ;
  strb_t                 p1__ostrb        ;
  dat_t                  p1__odat         ;
  //
  logic                  p1__owrite2p2    ;
  logic                  p1__owstart2p2   ;
  dat_t                  p1__owdat2p2     ;

  //
  // p2
  hb_zc_t                p2__iused_dat_w       ;
  hb_zc_t                p2__iused_zc          ;
  //
  logic [2 : 0]          p2__iwrite4au         ;
  logic                  p2__iwstart4au        ;
  dat_t                  p2__iwdat4au      [3] ;
  //
  logic                  p2__iwrite4p1         ;
  logic                  p2__iwstart4p1        ;
  dat_t                  p2__iwdat4p1          ;
  //
  logic                  p2__iread             ;
  logic                  p2__irstart           ;
  logic                  p2__irval             ;
  strb_t                 p2__irstrb            ;
  hb_row_t               p2__irrow             ;
  mm_hb_value_t          p2__irHb          [3] ;
  //
  logic                  p2__oval              ;
  strb_t                 p2__ostrb             ;
  dat_t                  p2__odat              ;
  //
  dat_t                  p2__ordat2au          ;
  //
  logic                  p2__owrite2p3_p1      ;
  logic                  p2__owstart2p3_p1     ;
  dat_t                  p2__owdat2p3_p1       ;
  //
  logic                  p2__owrite2p3_p2      ;
  logic                  p2__owstart2p3_p2     ;
  dat_t                  p2__owdat2p3_p2   [3] ;

  //
  // p3
  hb_zc_t                p3__iused_dat_w    ;
  hb_zc_t                p3__iused_zc       ;
  //
  logic                  p3__iwrite4p2      ;
  logic                  p3__iwstart4p2     ;
  dat_t                  p3__iwdat4p2   [3] ;
  //
  logic                  p3__iread          ;
  logic                  p3__irstart        ;
  logic                  p3__irval          ;
  strb_t                 p3__irstrb         ;
  mm_hb_value_t          p3__irHb       [3] ;
  //
  dat_t                  p3__irdat4acu      ;
  dat_t                  p3__irdat4p1       ;
  //
  logic                  p3__oval           ;
  strb_t                 p3__ostrb          ;
  dat_t                  p3__odat           ;

  //------------------------------------------------------------------------------------------------------
  // input buffer address generator
  //------------------------------------------------------------------------------------------------------

  assign orempty = hb_tab__obuf_rempty;

  assign oraddr  = raddr_gen__oraddr;

  ldpc_3gpp_enc_raddr_gen
  #(
    .pADDR_W        ( pRADDR_W       ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  raddr_gen
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .iused_dat_w ( hb_tab__oused_dat_w ) ,
    //
    .iclear      ( raddr_gen__iclear   ) ,
    .ienable     ( raddr_gen__ienable  ) ,
    //
    .oraddr      ( raddr_gen__oraddr   ) ,
    .orval       ( raddr_gen__orval    )
  );

  assign raddr_gen__iclear  = ctrl__oaddr_clear  ;
  assign raddr_gen__ienable = ctrl__oaddr_enable ;

  //------------------------------------------------------------------------------------------------------
  // Hb table
  //-----------------------------------------------------------------------------------------------------

  generate
    if (pUSE_FIXED_CODE) begin
      ldpc_3gpp_enc_hb
      #(
        .pDAT_W    ( pDAT_W    ) ,
        //
        .pIDX_GR   ( pIDX_GR   ) ,
        .pIDX_LS   ( pIDX_LS   ) ,
        .pIDX_ZC   ( pIDX_ZC   ) ,
        .pCODE     ( pCODE     ) ,
        .pDO_PUNCT ( pDO_PUNCT )
      )
      hb_tab
      (
        .iclk         ( iclk                 ) ,
        .ireset       ( ireset               ) ,
        .iclkena      ( iclkena              ) ,
        //
        .irow         ( hb_tab__irow         ) ,
        //
        .oused_zc     ( hb_tab__oused_zc     ) ,
        .oused_row    ( hb_tab__oused_row    ) ,
        .oused_col    ( hb_tab__oused_col    ) ,
        //
        .ou_AC        ( hb_tab__ou_AC        ) ,
        //
        .oinvPsi      ( hb_tab__oinvPsi      ) ,
        .oinvPsi_zero ( hb_tab__oinvPsi_zero ) ,
        //
        .op1_B        ( hb_tab__op1_B        ) ,
        .op12_P       ( hb_tab__op12_P       )
      );

      assign hb_tab__obuf_rempty        = ctrl__obuf_rempty;

      assign hb_tab__ocode_ctx.idxGr    = pIDX_GR;
      assign hb_tab__ocode_ctx.idxLs    = pIDX_LS;
      assign hb_tab__ocode_ctx.idxZc    = pIDX_ZC;
      assign hb_tab__ocode_ctx.code     = pCODE;
      assign hb_tab__ocode_ctx.do_punct = pDO_PUNCT;

      assign hb_tab__octrl_full         = irbuf_full;

      assign hb_tab__oused_dat_w        = pDAT_W;

    end
    else begin
      ldpc_3gpp_enc_hb_gen
      #(
        .pDAT_W         ( pDAT_W         ) ,
        //
        .pIDX_GR        ( pIDX_GR        ) ,
        .pCODE          ( pCODE          ) ,
        //
        .pUSE_HC_SROM   ( pUSE_HC_SROM   ) ,
        .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
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
        //
        .irow         ( hb_tab__irow         ) ,
        //
        .oused_dat_w  ( hb_tab__oused_dat_w  ) ,
        .oused_zc     ( hb_tab__oused_zc     ) ,
        .oused_row    ( hb_tab__oused_row    ) ,
        .oused_col    ( hb_tab__oused_col    ) ,
        //
        .ou_AC        ( hb_tab__ou_AC        ) ,
        //
        .oinvPsi      ( hb_tab__oinvPsi      ) ,
        .oinvPsi_zero ( hb_tab__oinvPsi_zero ) ,
        //
        .op1_B        ( hb_tab__op1_B        ) ,
        .op12_P       ( hb_tab__op12_P       )
      );

      assign hb_tab__ibuf_full    = irbuf_full;
      assign hb_tab__icode_ctx    = icode_ctx;

      assign hb_tab__ictrl_rempty = ctrl__obuf_rempty;

    end
  endgenerate

  assign hb_tab__irow         = ctrl__ohb_row;

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_ctrl
  #(
    .pPIPE        ( cMATRIX_PIPE ) ,
    .pUSE_P1_SLOW ( pUSE_P1_SLOW )
  )
  ctrl
  (
    .iclk         ( iclk               ) ,
    .ireset       ( ireset             ) ,
    .iclkena      ( iclkena            ) ,
    //
    .ibuf_full    ( ctrl__ibuf_full    ) ,
    .obuf_rempty  ( ctrl__obuf_rempty  ) ,
    .iobuf_empty  ( ctrl__iobuf_empty  ) ,
    //
    .iinvPsi_zero ( ctrl__iinvPsi_zero ) ,
    .iused_zc     ( ctrl__iused_zc     ) ,
    .iused_row    ( ctrl__iused_row    ) ,
    .iused_col    ( ctrl__iused_col    ) ,
    //
    .oaddr_clear  ( ctrl__oaddr_clear  ) ,
    .oaddr_enable ( ctrl__oaddr_enable ) ,
    //
    .ohb_row      ( ctrl__ohb_row      ) ,
    //
    .oacu_write   ( ctrl__oacu_write   ) ,
    .oacu_wstart  ( ctrl__oacu_wstart  ) ,
    .oacu_wstrb   ( ctrl__oacu_wstrb   ) ,
    .oacu_wcol    ( ctrl__oacu_wcol    ) ,
    //
    .oacu_read    ( ctrl__oacu_read    ) ,
    .oacu_rstart  ( ctrl__oacu_rstart  ) ,
    .oacu_rval    ( ctrl__oacu_rval    ) ,
    .oacu_rstrb   ( ctrl__oacu_rstrb   ) ,
    .oacu_rrow    ( ctrl__oacu_rrow    ) ,
    //
    .op1_read     ( ctrl__op1_read     ) ,
    .op1_rstart   ( ctrl__op1_rstart   ) ,
    .op1_rval     ( ctrl__op1_rval     ) ,
    .op1_rstrb    ( ctrl__op1_rstrb    ) ,
    //
    .op2_read     ( ctrl__op2_read     ) ,
    .op2_rstart   ( ctrl__op2_rstart   ) ,
    .op2_rval     ( ctrl__op2_rval     ) ,
    .op2_rstrb    ( ctrl__op2_rstrb    ) ,
    .op2_rrow     ( ctrl__op2_rrow     ) ,
    //
    .op3_read     ( ctrl__op3_read     ) ,
    .op3_rstart   ( ctrl__op3_rstart   ) ,
    .op3_rval     ( ctrl__op3_rval     ) ,
    .op3_rstrb    ( ctrl__op3_rstrb    )
  );

  assign ctrl__ibuf_full    = hb_tab__octrl_full;

  assign ctrl__iobuf_empty  = iwbuf_empty;

  assign ctrl__iinvPsi_zero = hb_tab__oinvPsi_zero;
  assign ctrl__iused_zc     = hb_tab__oused_zc;
  assign ctrl__iused_row    = hb_tab__oused_row;
  assign ctrl__iused_col    = hb_tab__oused_col;

  //------------------------------------------------------------------------------------------------------
  // A*u'
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_acu
  #(
    .pADDR_W        ( cMATRIX_ADDR_W ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pIDX_GR        ( pIDX_GR        ) ,
    //
    .pPIPE          ( cMATRIX_PIPE   ) ,
    .pUSE_P1_SLOW   ( pUSE_P1_SLOW   ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  acu
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .iused_dat_w ( acu__iused_dat_w    ) ,
    .iused_zc    ( acu__iused_zc       ) ,
    //
    .iwrite      ( acu__iwrite         ) ,
    .iwstart     ( acu__iwstart        ) ,
    .iwstrb      ( acu__iwstrb         ) ,
    .iwcol       ( acu__iwcol          ) ,
    .iwdat       ( acu__iwdat          ) ,
    //
    .iread       ( acu__iread          ) ,
    .irstart     ( acu__irstart        ) ,
    .irval       ( acu__irval          ) ,
    .irstrb      ( acu__irstrb         ) ,
    .irrow       ( acu__irrow          ) ,
    .irHb        ( acu__irHb           ) ,
    //
    .irdat2au    ( acu__irdat2au       ) ,
    //
    .oval        ( acu__oval           ) ,
    .opmask      ( acu__opmask         ) ,
    .ostrb       ( acu__ostrb          ) ,
    .odat        ( acu__odat           ) ,
    //
    .owrite2p1   ( acu__owrite2p1      ) ,
    .owstart2p1  ( acu__owstart2p1     ) ,
    .owdat2p1    ( acu__owdat2p1       ) ,
    //
    .owrite2p2   ( acu__owrite2p2      ) ,
    .owstart2p2  ( acu__owstart2p2     ) ,
    .owdat2p2    ( acu__owdat2p2       ) ,
    //
    .owrite2p3   ( acu__owrite2p3      ) ,
    .owstart2p3  ( acu__owstart2p3     ) ,
    .owdat2p3    ( acu__owdat2p3       )
  );

  assign acu__iused_dat_w = hb_tab__oused_dat_w;
  assign acu__iused_zc    = hb_tab__oused_zc;

  //
  // align input buffer delay & optional data -> zc bits converter
  generate
    if (pUSE_VAR_DAT_W) begin
      //
      // align input buffer delay
      logic     ctrl_acu_write   ;
      logic     ctrl_acu_wstart  ;
      strb_t    ctrl_acu_wstrb   ;
      hb_col_t  ctrl_acu_wcol    ;

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          {acu__iwrite , ctrl_acu_write } <= {ctrl_acu_write , ctrl__oacu_write };
          {acu__iwstart, ctrl_acu_wstart} <= {ctrl_acu_wstart, ctrl__oacu_wstart};
          {acu__iwstrb , ctrl_acu_wstrb } <= {ctrl_acu_wstrb , ctrl__oacu_wstrb };
          {acu__iwcol  , ctrl_acu_wcol  } <= {ctrl_acu_wcol  , ctrl__oacu_wcol  };
          //
          acu__iwdat <= raddr_gen__orval ? irdat : (acu__iwdat >> hb_tab__oused_dat_w);
        end
      end
    end
    else begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          acu__iwrite   <= ctrl__oacu_write  ;
          acu__iwstart  <= ctrl__oacu_wstart ;
          acu__iwstrb   <= ctrl__oacu_wstrb  ;
          acu__iwcol    <= ctrl__oacu_wcol   ;
        end
      end
      //
      assign acu__iwdat = irdat ;
    end
  endgenerate
  //
  assign acu__iread     = ctrl__oacu_read   ;
  assign acu__irstart   = ctrl__oacu_rstart ;
  assign acu__irval     = ctrl__oacu_rval   ;
  assign acu__irstrb    = ctrl__oacu_rstrb  ;
  assign acu__irrow     = ctrl__oacu_rrow   ;

  assign acu__irHb      = hb_tab__ou_AC     ;

  assign acu__irdat2au  = p2__ordat2au      ;

  //------------------------------------------------------------------------------------------------------
  // p1 = inv(-E*T^-1*B+D)*(E*(T^-1)*A*u' + C*u')
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_p1
  #(
    .pADDR_W        ( cMATRIX_ADDR_W ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pPIPE          ( cMATRIX_PIPE   ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  p1
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .iused_dat_w ( p1__iused_dat_w     ) ,
    .iused_zc    ( p1__iused_zc        ) ,
    .ibypass     ( p1__ibypass         ) ,
    //
    .iwrite      ( p1__iwrite          ) ,
    .iwstart     ( p1__iwstart         ) ,
    .iwdat       ( p1__iwdat           ) ,
    //
    .iread       ( p1__iread           ) ,
    .irstart     ( p1__irstart         ) ,
    .irval       ( p1__irval           ) ,
    .irstrb      ( p1__irstrb          ) ,
    .iinvPsi     ( p1__iinvPsi         ) ,
    //
    .oval        ( p1__oval            ) ,
    .ostrb       ( p1__ostrb           ) ,
    .odat        ( p1__odat            ) ,
    //
    .owrite2p2   ( p1__owrite2p2       ) ,
    .owstart2p2  ( p1__owstart2p2      ) ,
    .owdat2p2    ( p1__owdat2p2        )
  );

  assign p1__iused_dat_w = hb_tab__oused_dat_w;
  assign p1__iused_zc    = hb_tab__oused_zc;
  assign p1__ibypass     = hb_tab__oinvPsi_zero;

  assign p1__iwrite      = acu__owrite2p1  ;
  assign p1__iwstart     = acu__owstart2p1 ;
  assign p1__iwdat       = acu__owdat2p1   ;

  assign p1__iread       = ctrl__op1_read  ;
  assign p1__irstart     = ctrl__op1_rstart;
  assign p1__irval       = ctrl__op1_rval  ;
  assign p1__irstrb      = ctrl__op1_rstrb ;

  assign p1__iinvPsi     = hb_tab__oinvPsi ;

  //------------------------------------------------------------------------------------------------------
  // p2 = (T^-1)*(A*u'+B*p1')
  // T*p1
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_p2
  #(
    .pADDR_W        ( cMATRIX_ADDR_W ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pPIPE          ( cMATRIX_PIPE   ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  p2
  (
    .iclk          ( iclk                ) ,
    .ireset        ( ireset              ) ,
    .iclkena       ( iclkena             ) ,
    //
    .iused_dat_w   ( p2__iused_dat_w     ) ,
    .iused_zc      ( p2__iused_zc        ) ,
    //
    .iwrite4au     ( p2__iwrite4au       ) ,
    .iwstart4au    ( p2__iwstart4au      ) ,
    .iwdat4au      ( p2__iwdat4au        ) ,
    //
    .iwrite4p1     ( p2__iwrite4p1       ) ,
    .iwstart4p1    ( p2__iwstart4p1      ) ,
    .iwdat4p1      ( p2__iwdat4p1        ) ,
    //
    .iread         ( p2__iread           ) ,
    .irstart       ( p2__irstart         ) ,
    .irval         ( p2__irval           ) ,
    .irstrb        ( p2__irstrb          ) ,
    .irrow         ( p2__irrow           ) ,
    .irHb          ( p2__irHb            ) ,
    //
    .oval          ( p2__oval            ) ,
    .ostrb         ( p2__ostrb           ) ,
    .odat          ( p2__odat            ) ,
    //
    .ordat2au      ( p2__ordat2au        ) ,
    //
    .owrite2p3_p1  ( p2__owrite2p3_p1    ) ,
    .owstart2p3_p1 ( p2__owstart2p3_p1   ) ,
    .owdat2p3_p1   ( p2__owdat2p3_p1     ) ,
    //
    .owrite2p3_p2  ( p2__owrite2p3_p2    ) ,
    .owstart2p3_p2 ( p2__owstart2p3_p2   ) ,
    .owdat2p3_p2   ( p2__owdat2p3_p2     )
  );

  assign p2__iused_dat_w  = hb_tab__oused_dat_w;
  assign p2__iused_zc     = hb_tab__oused_zc;
  //
  assign p2__iwrite4au    = acu__owrite2p2  ;
  assign p2__iwstart4au   = acu__owstart2p2 ;
  assign p2__iwdat4au     = acu__owdat2p2   ;
  //
  assign p2__iwrite4p1    = p1__owrite2p2   ;
  assign p2__iwstart4p1   = p1__owstart2p2  ;
  assign p2__iwdat4p1     = p1__owdat2p2    ;
  //
  assign p2__iread        = ctrl__op2_read  ;
  assign p2__irstart      = ctrl__op2_rstart;
  assign p2__irval        = ctrl__op2_rval  ;
  assign p2__irstrb       = ctrl__op2_rstrb ;
  assign p2__irrow        = ctrl__op2_rrow  ;
  //
  assign p2__irHb         = hb_tab__op1_B   ;

  //------------------------------------------------------------------------------------------------------
  // T*p2
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_p3
  #(
    .pADDR_W        ( cMATRIX_ADDR_W ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pPIPE          ( cMATRIX_PIPE   ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  p3
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .iused_dat_w ( p3__iused_dat_w     ) ,
    .iused_zc    ( p3__iused_zc        ) ,
    //
    .iwrite4p2   ( p3__iwrite4p2       ) ,
    .iwstart4p2  ( p3__iwstart4p2      ) ,
    .iwdat4p2    ( p3__iwdat4p2        ) ,
    //
    .iread       ( p3__iread           ) ,
    .irstart     ( p3__irstart         ) ,
    .irval       ( p3__irval           ) ,
    .irstrb      ( p3__irstrb          ) ,
    .irHb        ( p3__irHb            ) ,
    //
    .irdat4acu   ( p3__irdat4acu       ) ,
    .irdat4p1    ( p3__irdat4p1        ) ,
    //
    .oval        ( p3__oval            ) ,
    .ostrb       ( p3__ostrb           ) ,
    .odat        ( p3__odat            )
  );

  assign p3__iused_dat_w  = hb_tab__oused_dat_w;
  assign p3__iused_zc     = hb_tab__oused_zc;
  //
  assign p3__iwrite4p2    = p2__owrite2p3_p2  ;
  assign p3__iwstart4p2   = p2__owstart2p3_p2 ;
  assign p3__iwdat4p2     = p2__owdat2p3_p2   ;
  //
  assign p3__iread        = ctrl__op3_read    ;
  assign p3__irstart      = ctrl__op3_rstart  ;
  assign p3__irval        = ctrl__op3_rval    ;
  assign p3__irstrb       = ctrl__op3_rstrb   ;

  assign p3__irHb         = hb_tab__op12_P    ;
  //
  assign p3__irdat4acu    = acu__owdat2p3     ;

  assign p3__irdat4p1     = p2__owdat2p3_p1   ;

  //------------------------------------------------------------------------------------------------------
  // output multiplexer
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_muxout
  #(
    .pDAT_W         ( pDAT_W         ) ,
    .pADDR_W        ( pWADDR_W       ) ,
    //
    .pTAG_W         ( pTAG_W         ) ,
    //
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  muxout
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .iused_dat_w ( hb_tab__oused_dat_w ) ,
    //
    .itag        ( irtag               ) ,
    .icode_ctx   ( hb_tab__ocode_ctx   ) ,
    //
    .iacu_val    ( acu__oval           ) ,
    .iacu_pmask  ( acu__opmask         ) ,
    .iacu_strb   ( acu__ostrb          ) ,
    .iacu_dat    ( acu__odat           ) ,
    //
    .ip1_val     ( p1__oval            ) ,
    .ip1_strb    ( p1__ostrb           ) ,
    .ip1_dat     ( p1__odat            ) ,
    //
    .ip2_val     ( p2__oval            ) ,
    .ip2_strb    ( p2__ostrb           ) ,
    .ip2_dat     ( p2__odat            ) ,
    //
    .ip3_val     ( p3__oval            ) ,
    .ip3_strb    ( p3__ostrb           ) ,
    .ip3_dat     ( p3__odat            ) ,
    //
    .owrite      ( owrite              ) ,
    .owfull      ( owfull              ) ,
    .owaddr      ( owaddr              ) ,
    .owdat       ( owdat               ) ,
    .owtag       ( owtag               ) ,
    .ocode_ctx   ( ocode_ctx           )
  );

endmodule
