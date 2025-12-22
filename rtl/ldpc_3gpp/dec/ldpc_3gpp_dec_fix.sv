/*



  parameter int pIDX_GR       =  0 ;
  parameter int pIDX_LS       =  0 ;
  parameter int pIDX_ZC       =  7 ;
  parameter int pCODE         =  4 ;
  parameter int pDO_PUNCT     =  0 ;
  //
  parameter int pLLR_W        =  8 ;
  parameter int pLLR_NUM      =  1 ;
  //
  parameter int pDAT_W        =  8 ;
  parameter int pTAG_W        =  4 ;
  //
  parameter int pERR_W        = 16 ;
  //
  parameter int pNODE_W       =  8 ;
  parameter int pROW_BY_CYCLE =  8 ;
  //
  parameter int pNORM_FACTOR  =  7 ;
  //
  parameter bit pUSE_HSHAKE   =  0 ;
  parameter bit pUSE_SC_MODE  =  1 ;



  logic                ldpc_3gpp_dec_fix__iclk                ;
  logic                ldpc_3gpp_dec_fix__ireset              ;
  logic                ldpc_3gpp_dec_fix__iclkena             ;
  //
  logic        [7 : 0] ldpc_3gpp_dec_fix__iNiter              ;
  logic                ldpc_3gpp_dec_fix__ifmode              ;
  //
  logic                ldpc_3gpp_dec_fix__ival                ;
  logic                ldpc_3gpp_dec_fix__isop                ;
  logic                ldpc_3gpp_dec_fix__ieop                ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_dec_fix__itag                ;
  llr_t                ldpc_3gpp_dec_fix__iLLR     [pLLR_NUM] ;
  //
  logic                ldpc_3gpp_dec_fix__obusy               ;
  logic                ldpc_3gpp_dec_fix__ordy                ;
  logic                ldpc_3gpp_dec_fix__osrc_err            ;
  //
  logic                ldpc_3gpp_dec_fix__ireq                ;
  logic                ldpc_3gpp_dec_fix__ofull               ;
  //
  logic                ldpc_3gpp_dec_fix__oval                ;
  logic                ldpc_3gpp_dec_fix__osop                ;
  logic                ldpc_3gpp_dec_fix__oeop                ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_dec_fix__otag                ;
  logic [pDAT_W-1 : 0] ldpc_3gpp_dec_fix__odat                ;
  //
  logic                ldpc_3gpp_dec_fix__odecfail            ;
  logic [pERR_W-1 : 0] ldpc_3gpp_dec_fix__oerr                ;
  logic [pERR_W-1 : 0] ldpc_3gpp_dec_fix__obitnum             ;
  logic        [7 : 0] ldpc_3gpp_dec_fix__ouNiter             ;



  ldpc_3gpp_dec_fix
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pIDX_LS       ( pIDX_LS       ) ,
    .pIDX_ZC       ( pIDX_ZC       ) ,
    .pCODE         ( pCODE         ) ,
    .pDO_PUNCT     ( pDO_PUNCT     ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pLLR_NUM      ( pLLR_NUM      ) ,
    //
    .pDAT_W        ( pDAT_W        ) ,
    .pTAG_W        ( pTAG_W        ) ,
    //
    .pERR_W        ( pERR_W        ) ,
    //
    .pNODE_W       ( pNODE_W       ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pNORM_FACTOR  ( pNORM_FACTOR  ) ,
    //
    .pUSE_HSHAKE   ( pUSE_HSHAKE   ) ,
    .pUSE_SC_MODE  ( pUSE_SC_MODE  )
  )
  ldpc_3gpp_dec_fix
  (
    .iclk      ( ldpc_3gpp_dec_fix__iclk      ) ,
    .ireset    ( ldpc_3gpp_dec_fix__ireset    ) ,
    .iclkena   ( ldpc_3gpp_dec_fix__iclkena   ) ,
    //
    .iNiter    ( ldpc_3gpp_dec_fix__iNiter    ) ,
    .ifmode    ( ldpc_3gpp_dec_fix__ifmode    ) ,
    //
    .ival      ( ldpc_3gpp_dec_fix__ival      ) ,
    .isop      ( ldpc_3gpp_dec_fix__isop      ) ,
    .ieop      ( ldpc_3gpp_dec_fix__ieop      ) ,
    .itag      ( ldpc_3gpp_dec_fix__itag      ) ,
    .iLLR      ( ldpc_3gpp_dec_fix__iLLR      ) ,
    //
    .obusy     ( ldpc_3gpp_dec_fix__obusy     ) ,
    .ordy      ( ldpc_3gpp_dec_fix__ordy      ) ,
    .osrc_err  ( ldpc_3gpp_dec_fix__osrc_err  ) ,
    //
    .ireq      ( ldpc_3gpp_dec_fix__ireq      ) ,
    .ofull     ( ldpc_3gpp_dec_fix__ofull     ) ,
    //
    .oval      ( ldpc_3gpp_dec_fix__oval      ) ,
    .osop      ( ldpc_3gpp_dec_fix__osop      ) ,
    .oeop      ( ldpc_3gpp_dec_fix__oeop      ) ,
    .otag      ( ldpc_3gpp_dec_fix__otag      ) ,
    .odat      ( ldpc_3gpp_dec_fix__odat      ) ,
    //
    .odecfail  ( ldpc_3gpp_dec_fix__odecfail  ) ,
    .oerr      ( ldpc_3gpp_dec_fix__oerr      ) ,
    .obitnum   ( ldpc_3gpp_dec_fix__obitnum   ) ,
    .ouNiter   ( ldpc_3gpp_dec_fix__ouNiter   )
  );


  assign ldpc_3gpp_dec_fix__iclk      = '0 ;
  assign ldpc_3gpp_dec_fix__ireset    = '0 ;
  assign ldpc_3gpp_dec_fix__iclkena   = '0 ;
  //
  assign ldpc_3gpp_dec_fix__iNiter    = '0 ;
  assign ldpc_3gpp_dec_fix__ifmode    = '0 ;
  //
  assign ldpc_3gpp_dec_fix__ival      = '0 ;
  assign ldpc_3gpp_dec_fix__isop      = '0 ;
  assign ldpc_3gpp_dec_fix__ieop      = '0 ;
  assign ldpc_3gpp_dec_fix__itag      = '0 ;
  assign ldpc_3gpp_dec_fix__iLLR      = '0 ;
  //
  assign ldpc_3gpp_dec_fix__ireq      = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_fix.sv
// Description   : fixed mode single clock 3GPP LDPC RTL decoder based upon duo phase parallel decoding
//

`include "define.vh"

module ldpc_3gpp_dec_fix
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  iNiter    ,
  ifmode    ,
  //
  ival      ,
  isop      ,
  ieop      ,
  itag      ,
  iLLR      ,
  //
  obusy     ,
  ordy      ,
  osrc_err  ,
  //
  ireq      ,
  ofull     ,
  //
  oval      ,
  osop      ,
  oeop      ,
  otag      ,
  odat      ,
  //
  odecfail  ,
  oerr      ,
  obitnum   ,
  ouNiter
);

  parameter int pDAT_W          =  8 ;  // == 1/2/4/8 & >= pLLR_BY_CYCLE & <= minimum cZC & integer multiply of minimum cZC
  //
  parameter int pTAG_W          =  4 ;
  //
  parameter int pERR_W          = 16 ;
  //
  parameter int pNORM_FACTOR    =  7 ;
  //
  parameter bit pUSE_HSHAKE     =  0 ;  // use(1) handshake ival & ordy iinterface or use simple

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  parameter int pLLR_NUM       = pLLR_BY_CYCLE; // == 1/2/4/8 & >= pLLR_BY_CYCLE & <= minimum cZC & integer multiply of minimum cZC

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                ;
  input  logic                       ireset              ;
  input  logic                       iclkena             ;
  //
  input  logic               [7 : 0] iNiter              ;
  input  logic                       ifmode              ;  // fast work mode with early stop
  //
  input  logic                       ival                ;
  input  logic                       isop                ;
  input  logic                       ieop                ;
  input  logic        [pTAG_W-1 : 0] itag                ;
  input  logic signed [pLLR_W-1 : 0] iLLR     [pLLR_NUM] ;
  //
  output logic                       obusy               ;
  output logic                       ordy                ;
  output logic                       osrc_err            ;  // source error if handshake is not using
  //
  input  logic                       ireq                ;
  output logic                       ofull               ;
  //
  output logic                       oval                ;
  output logic                       osop                ;
  output logic                       oeop                ;
  output logic        [pTAG_W-1 : 0] otag                ;
  output logic        [pDAT_W-1 : 0] odat                ;
  //
  output logic                       odecfail            ;
  output logic        [pERR_W-1 : 0] oerr                ;
  output logic        [pERR_W-1 : 0] obitnum             ;  // number of bits corresponded oerr
  output logic               [7 : 0] ouNiter             ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cZC              = cZC_TAB[pIDX_LS][pIDX_ZC];

  // ibuffer read & engine address is defined by cZC, pIDX_GR, pCODE, pROW_BY_CYCLE, pLLR_BY_CYCLE
  localparam int cIBUF_D_RNUM     = cMAX_COL_STEP_NUM * cZC/pLLR_BY_CYCLE;
  localparam int cIBUF_D_RADDR_W  = $clog2(cIBUF_D_RNUM);

  // select minimum parity addr width if constraint less then required. if minimum parity addr width is less then data addr width use data addr width
  localparam int cIBUF_P_RNUM     = cMAX_ROW_STEP_NUM * cMAX_COL_STEP_NUM * cZC/pLLR_BY_CYCLE;
  localparam int cIBUF_P_RADDR_W  = $clog2(cIBUF_P_RNUM);

  // ibuffer write address is defined by read address and pLLR_BY_CYCLE/pLLR_NUM scale
  localparam int cIBUF_D_WNUM     = cIBUF_D_RNUM * pLLR_BY_CYCLE/pLLR_NUM;
  localparam int cIBUF_D_WADDR_W  = max(1, $clog2(cIBUF_D_WNUM));

  localparam int cIBUF_P_WNUM     = cIBUF_P_RNUM * pLLR_BY_CYCLE/pLLR_NUM;
  localparam int cIBUF_P_WADDR_W  = max(1, $clog2(cIBUF_P_WNUM));

  localparam int cIBUF_TAG_W      = pTAG_W + 8 + 1; // {tag, Niter, fmode}

  // obuffer write is same as ibuffer read
  localparam int cOBUF_WNUM       = cIBUF_D_RNUM;
  localparam int cOBUF_WADDR_W    = $clog2(cOBUF_WNUM);
  localparam int cOBUF_WDAT_W     = pLLR_BY_CYCLE;

  // obuffer read address is defined by write address and pLLR_BY_CYCLE/pDAT_W scale
  localparam int cOBUF_RNUM       = cOBUF_WNUM * pLLR_BY_CYCLE/pDAT_W;
  localparam int cOBUF_RADDR_W    = $clog2(cOBUF_RNUM);
  localparam int cOBUF_RDAT_W     = pDAT_W;

  localparam int cOBUF_DAT_NUM    = cGR_SYST_BIT_COL[pIDX_GR];

  localparam int cOBUF_TAG_W      = pTAG_W + pERR_W + 1 + 8; // {tag, err, decfail, uNiter}

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                            source__ival                                                      ;
  code_ctx_t                       source__icode_ctx                                                 ;

  logic      [cCOL_BY_CYCLE-1 : 0] source__owrite                                                    ;
  logic                    [1 : 0] source__oclear                                                    ;
  logic    [cIBUF_D_WADDR_W-1 : 0] source__owaddr                                                    ;
  //
  logic      [pROW_BY_CYCLE-1 : 0] source__opwrite                                                   ;
  logic      [pROW_BY_CYCLE-1 : 0] source__opclear                                                   ;
  logic    [cIBUF_P_WADDR_W-1 : 0] source__opwaddr                                                   ;
  //
  logic                            source__owfull                                                    ;
  llr_t                            source__owLLR      [pLLR_NUM]                                     ;

  //
  // ibuf
  logic      [cCOL_BY_CYCLE-1 : 0] ibuffer__iwrite                                                   ;
  logic                    [1 : 0] ibuffer__iclear                                                   ;
  logic    [cIBUF_D_WADDR_W-1 : 0] ibuffer__iwaddr                                                   ;
  //
  logic      [pROW_BY_CYCLE-1 : 0] ibuffer__ipwrite                                                  ;
  logic      [pROW_BY_CYCLE-1 : 0] ibuffer__ipclear                                                  ;
  logic    [cIBUF_P_WADDR_W-1 : 0] ibuffer__ipwaddr                                                  ;
  //
  logic                            ibuffer__iwfull                                                   ;
  llr_t                            ibuffer__iLLR      [pLLR_NUM]                                     ;
  logic        [cIBUF_TAG_W-1 : 0] ibuffer__iwtag                                                    ;
  //
  logic                            ibuffer__irempty                                                  ;
  logic    [cIBUF_P_RADDR_W-1 : 0] ibuffer__iraddr                                                   ;
  llr_t                            ibuffer__oLLR                      [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  llr_t                            ibuffer__opLLR      [pROW_BY_CYCLE]               [pLLR_BY_CYCLE] ;
  logic        [cIBUF_TAG_W-1 : 0] ibuffer__ortag                                                    ;
  //
  logic                            ibuffer__oempty                                                   ;
  logic                            ibuffer__oemptya                                                  ;
  logic                            ibuffer__ofull                                                    ;
  logic                            ibuffer__ofulla                                                   ;

  //
  // engine
  logic                    [7 : 0] engine__iNiter                                                    ;
  logic                            engine__ifmode                                                    ;
  code_ctx_t                       engine__icode_ctx                                                 ;
  logic             [pTAG_W-1 : 0] engine__itag                                                      ;
  //
  logic                            engine__ibuf_full                                                 ;
  logic                            engine__obuf_rempty                                               ;
  //
  logic                            engine__iobuf_empty                                               ;
  //
  llr_t                            engine__iLLR                       [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  llr_t                            engine__ipLLR       [pROW_BY_CYCLE]               [pLLR_BY_CYCLE] ;
  logic    [cIBUF_P_RADDR_W-1 : 0] engine__oLLR_raddr                                                ;
  //
  code_ctx_t                       engine__owcode_ctx                                                ;
  //
  logic                            engine__owrite                                                    ;
  logic                            engine__owfull                                                    ;
  logic    [cIBUF_P_RADDR_W-1 : 0] engine__owaddr                                                    ;
  logic      [pLLR_BY_CYCLE-1 : 0] engine__owdat                      [cCOL_BY_CYCLE]                ;
  logic             [pTAG_W-1 : 0] engine__owtag                                                     ;
  //
  logic                            engine__owdecfail                                                 ;
  logic                    [7 : 0] engine__owNiter                                                   ;
  logic             [pERR_W-1 : 0] engine__owerr                                                     ;

  //
  // obuf
  logic                            obuffer__iwrite                  ;
  logic                            obuffer__iwfull                  ;
  logic      [cOBUF_WADDR_W-1 : 0] obuffer__iwaddr                  ;
  logic       [cOBUF_WDAT_W-1 : 0] obuffer__iwdat   [cOBUF_DAT_NUM] ;
  logic        [cOBUF_TAG_W-1 : 0] obuffer__iwtag                   ;
  //
  logic                            obuffer__irempty                 ;
  logic      [cOBUF_RADDR_W-1 : 0] obuffer__iraddr                  ;
  logic       [cOBUF_RDAT_W-1 : 0] obuffer__ordat   [cOBUF_DAT_NUM] ;
  logic        [cOBUF_TAG_W-1 : 0] obuffer__ortag                   ;
  //
  logic                            obuffer__oempty                  ;
  logic                            obuffer__oemptya                 ;
  logic                            obuffer__ofull                   ;
  logic                            obuffer__ofulla                  ;

  //
  // sink
  code_ctx_t                       sink__icode_ctx                  ;
  //
  logic                            sink__irfull                     ;
  logic       [cOBUF_RDAT_W-1 : 0] sink__irdat      [cOBUF_DAT_NUM] ;
  logic             [pTAG_W-1 : 0] sink__irtag                      ;
  //
  logic                            sink__irdecfail                  ;
  logic             [pERR_W-1 : 0] sink__irerr                      ;
  logic                    [7 : 0] sink__irNiter                    ;
  //
  logic                            sink__orempty                    ;
  logic      [cOBUF_RADDR_W-1 : 0] sink__oraddr                     ;

  //------------------------------------------------------------------------------------------------------
  // input source
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_source
  #(
    .pD_ADDR_W     ( cIBUF_D_WADDR_W ) ,
    .pP_ADDR_W     ( cIBUF_P_WADDR_W ) ,
    //
    .pLLR_W        ( pLLR_W          ) ,
    .pLLR_NUM      ( pLLR_NUM        ) ,
    //
    .pROW_BY_CYCLE ( pROW_BY_CYCLE   )
  )
  source
  (
    .iclk       ( iclk              ) ,
    .ireset     ( ireset            ) ,
    .iclkena    ( iclkena           ) ,
    //
    .isop       ( isop              ) ,
    .ieop       ( ieop              ) ,
    .ival       ( source__ival      ) ,
    .iLLR       ( iLLR              ) ,
    .iLLR_idx   ( '{default : 0}    ) , // n.u.
    //
    .icode_ctx  ( source__icode_ctx ) ,
    //
    .obusy      ( obusy             ) ,
    .ordy       ( ordy              ) ,
    //
    .iempty     ( ibuffer__oempty   ) ,
    .iemptya    ( ibuffer__oemptya  ) ,
    .ifull      ( ibuffer__ofull    ) ,
    .ifulla     ( ibuffer__ofulla   ) ,
    //
    .owrite     ( source__owrite    ) ,
    .oclear     ( source__oclear    ) ,
    .owaddr     ( source__owaddr    ) ,
    //
    .opwrite    ( source__opwrite   ) ,
    .opclear    ( source__opclear   ) ,
    .opwaddr    ( source__opwaddr   ) ,
    //
    .owfull     ( source__owfull    ) ,
    .owLLR      ( source__owLLR     ) ,
    //
    .ohd_write  (                   ) , // n.u.
    .ohd_waddr  (                   ) ,
    .ohd_wdat   (                   ) ,
    .ohd_widx   (                   )
  );

  assign source__ival               = pUSE_HSHAKE ? (ival & ordy) :  ival;
  assign osrc_err                   = pUSE_HSHAKE ? 1'b0          : (ival & !ordy);

  assign source__icode_ctx.idxGr    = pIDX_GR;
  assign source__icode_ctx.idxLs    = pIDX_LS;
  assign source__icode_ctx.idxZc    = pIDX_ZC;
  assign source__icode_ctx.code     = pCODE;
  assign source__icode_ctx.do_punct = pDO_PUNCT;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & isop) begin
        ibuffer__iwtag <= {ifmode, iNiter, itag};
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // input buffer
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_ibuffer
  #(
    .pIDX_GR       ( pIDX_GR         ) ,
    .pCODE         ( pCODE           ) ,
    .pDO_PUNCT     ( pDO_PUNCT       ) ,
    //
    .pD_WADDR_W    ( cIBUF_D_WADDR_W ) ,
    .pP_WADDR_W    ( cIBUF_P_WADDR_W ) ,
    //
    .pD_RADDR_W    ( cIBUF_D_RADDR_W ) ,
    .pP_RADDR_W    ( cIBUF_P_RADDR_W ) ,
    //
    .pLLR_W        ( pLLR_W          ) ,
    .pLLR_NUM      ( pLLR_NUM        ) ,
    //
    .pROW_BY_CYCLE ( pROW_BY_CYCLE   ) ,
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE   ) ,
    //
    .pTAG_W        ( cIBUF_TAG_W     )
  )
  ibuffer
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( ibuffer__iwrite  ) ,
    .iclear  ( ibuffer__iclear  ) ,
    .iwaddr  ( ibuffer__iwaddr  ) ,
    //
    .ipwrite ( ibuffer__ipwrite ) ,
    .ipclear ( ibuffer__ipclear ) ,
    .ipwaddr ( ibuffer__ipwaddr ) ,
    //
    .iwfull  ( ibuffer__iwfull  ) ,
    .iLLR    ( ibuffer__iLLR    ) ,
    .iwtag   ( ibuffer__iwtag   ) ,
    //
    .irempty ( ibuffer__irempty ) ,
    .iraddr  ( ibuffer__iraddr  ) ,
    .oLLR    ( ibuffer__oLLR    ) ,
    .opLLR   ( ibuffer__opLLR   ) ,
    .ortag   ( ibuffer__ortag   ) ,
    //
    .oempty  ( ibuffer__oempty  ) ,
    .oemptya ( ibuffer__oemptya ) ,
    .ofull   ( ibuffer__ofull   ) ,
    .ofulla  ( ibuffer__ofulla  )
  );

  assign ibuffer__iwrite  = source__owrite;
  assign ibuffer__iclear  = source__oclear;
  assign ibuffer__iwaddr  = source__owaddr;
  //
  assign ibuffer__ipwrite = source__opwrite;
  assign ibuffer__ipclear = source__opclear;
  assign ibuffer__ipwaddr = source__opwaddr;
  //
  assign ibuffer__iwfull  = source__owfull;
  assign ibuffer__iLLR    = source__owLLR;

  assign ibuffer__irempty = engine__obuf_rempty;
  assign ibuffer__iraddr  = engine__oLLR_raddr;

  //------------------------------------------------------------------------------------------------------
  // engine
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_engine
  #(
    .pIDX_GR         ( pIDX_GR         ) ,
    .pIDX_LS         ( pIDX_LS         ) ,
    .pIDX_ZC         ( pIDX_ZC         ) ,
    .pCODE           ( pCODE           ) ,
    .pDO_PUNCT       ( pDO_PUNCT       ) ,
    //
    .pLLR_W          ( pLLR_W          ) ,
    .pNODE_W         ( pNODE_W         ) ,
    //
    .pADDR_W         ( cIBUF_P_RADDR_W ) ,
    //
    .pTAG_W          ( pTAG_W          ) ,
    //
    .pERR_W          ( pERR_W          ) ,
    //
    .pLLR_BY_CYCLE   ( pLLR_BY_CYCLE   ) ,
    .pROW_BY_CYCLE   ( pROW_BY_CYCLE   ) ,
    //
    .pNORM_FACTOR    ( pNORM_FACTOR    ) ,
    //
    .pUSE_SC_MODE    ( pUSE_SC_MODE    ) ,
    .pUSE_FIXED_CODE ( 1               )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .iNiter      ( engine__iNiter      ) ,
    .ifmode      ( engine__ifmode      ) ,
    //
    .ibuf_full   ( engine__ibuf_full   ) ,
    .obuf_rempty ( engine__obuf_rempty ) ,
    //
    .icode_ctx   ( engine__icode_ctx   ) ,
    //
    .itag        ( engine__itag        ) ,
    .iLLR        ( engine__iLLR        ) ,
    .ipLLR       ( engine__ipLLR       ) ,
    .oLLR_raddr  ( engine__oLLR_raddr  ) ,
    //
    .iobuf_empty ( engine__iobuf_empty ) ,
    //
    .owcode_ctx  ( engine__owcode_ctx  ) ,
    //
    .owrite      ( engine__owrite      ) ,
    .owfull      ( engine__owfull      ) ,
    .owaddr      ( engine__owaddr      ) ,
    .owdat       ( engine__owdat       ) ,
    .owtag       ( engine__owtag       ) ,
    //
    .owdecfail   ( engine__owdecfail   ) ,
    .owNiter     ( engine__owNiter     ) ,
    .owerr       ( engine__owerr       )
  );

  assign engine__icode_ctx = '0;
  //
  assign {engine__ifmode,
          engine__iNiter,
          engine__itag     } = ibuffer__ortag;

  assign engine__iLLR         = ibuffer__oLLR;
  assign engine__ipLLR        = ibuffer__opLLR;

  assign engine__ibuf_full    = ibuffer__ofull;
  assign engine__iobuf_empty  = obuffer__oempty;

  //------------------------------------------------------------------------------------------------------
  // output buffer
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_obuffer
  #(
    .pWADDR_W ( cOBUF_WADDR_W ) ,
    .pWDAT_W  ( cOBUF_WDAT_W  ) ,
    //
    .pRADDR_W ( cOBUF_RADDR_W ) ,
    .pRDAT_W  ( cOBUF_RDAT_W  ) ,
    //
    .pDAT_NUM ( cOBUF_DAT_NUM ) ,
    //
    .pTAG_W   ( cOBUF_TAG_W   )
  )
  obuffer
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( obuffer__iwrite  ) ,
    .iwfull  ( obuffer__iwfull  ) ,
    .iwaddr  ( obuffer__iwaddr  ) ,
    .iwdat   ( obuffer__iwdat   ) ,
    .iwtag   ( obuffer__iwtag   ) ,
    //
    .irempty ( obuffer__irempty ) ,
    .iraddr  ( obuffer__iraddr  ) ,
    .ordat   ( obuffer__ordat   ) ,
    .ortag   ( obuffer__ortag   ) ,
    //
    .oempty  ( obuffer__oempty  ) ,
    .oemptya ( obuffer__oemptya ) ,
    .ofull   ( obuffer__ofull   ) ,
    .ofulla  ( obuffer__ofulla  )
  );

  assign obuffer__iwrite  = engine__owrite;
  assign obuffer__iwfull  = engine__owfull;
  assign obuffer__iwaddr  = engine__owaddr[cOBUF_WADDR_W-1 : 0];

  always_comb begin
    for (int i = 0; i < cOBUF_DAT_NUM; i++) begin
      obuffer__iwdat[i] = engine__owdat[i];
    end
  end

  assign obuffer__iwtag  = { engine__owdecfail,
                             engine__owerr,
                             engine__owtag};

  assign obuffer__irempty = sink__orempty;
  assign obuffer__iraddr  = sink__oraddr;

  //------------------------------------------------------------------------------------------------------
  // sink
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_sink
  #(
    .pIDX_GR  ( pIDX_GR       ) ,
    //
    .pADDR_W  ( cOBUF_RADDR_W ) ,
    //
    .pDAT_W   ( cOBUF_RDAT_W  ) ,
    .pDAT_NUM ( cOBUF_DAT_NUM ) ,
    //
    .pERR_W   ( pERR_W        ) ,
    .pTAG_W   ( pTAG_W        )
  )
  sink
  (
    .iclk      ( iclk            ) ,
    .ireset    ( ireset          ) ,
    .iclkena   ( iclkena         ) ,
    //
    .icode_ctx ( sink__icode_ctx ) ,
    //
    .irfull    ( sink__irfull    ) ,
    .irdat     ( sink__irdat     ) ,
    .irtag     ( sink__irtag     ) ,
    //
    .irdecfail ( sink__irdecfail ) ,
    .irerr     ( sink__irerr     ) ,
    .irNiter   ( sink__irNiter   ) ,
    //
    .orempty   ( sink__orempty   ) ,
    .oraddr    ( sink__oraddr    ) ,
    //
    .ireq      ( ireq            ) ,
    .ofull     ( ofull           ) ,
    //
    .oval      ( oval            ) ,
    .osop      ( osop            ) ,
    .oeop      ( oeop            ) ,
    .odat      ( odat            ) ,
    .otag      ( otag            ) ,
    //
    .odecfail  ( odecfail        ) ,
    .oerr      ( oerr            ) ,
    .obitnum   ( obitnum         ) ,
    .oNiter    ( ouNiter         ) ,
    //
    .ohd_start (  ) , // n.u.
    .ohd_punct (  ) ,
    .ohd_raddr (  )
  );

  assign sink__irfull             = obuffer__ofull;
  assign sink__irdat              = obuffer__ordat;

  assign sink__icode_ctx.idxGr    = pIDX_GR;
  assign sink__icode_ctx.idxLs    = pIDX_LS;
  assign sink__icode_ctx.idxZc    = pIDX_ZC;
  assign sink__icode_ctx.code     = pCODE;
  assign sink__icode_ctx.do_punct = pDO_PUNCT;
  //
  assign {sink__irdecfail ,
          sink__irNiter   ,
          sink__irerr     ,
          sink__irtag     }       = obuffer__ortag;

endmodule
