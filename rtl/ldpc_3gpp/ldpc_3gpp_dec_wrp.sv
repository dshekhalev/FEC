/*



  parameter bit pIDX_GR       = 0 ;
  parameter int pIDX_LS       = 0 ;
  parameter int pIDX_ZC       = 7 ;
  parameter int pCODE         = 4 ;
  parameter int pDO_PUNCT     = 1 ;
  //
  parameter int pLLR_W        =  4 ;
  parameter int pLLR_NUM      =  8 ;
  //
  parameter int pDAT_W        =  8 ;
  parameter int pTAG_W        =  4 ;
  //
  parameter int pERR_W        = 16 ;
  //
  parameter int pNODE_SCALE_W =  0 ;
  parameter int pNODE_W       =  4 ;
  //
  parameter int pNORM_FACTOR  =  6 ;
  //
  parameter int pMEM_ADDR_MAX =  0 ;
  parameter bit pUSE_HSHAKE   =  0 ;
  parameter bit pUSE_HC_SROM  =  1 ;



  logic                ldpc_3gpp_dec__iclk                ;
  logic                ldpc_3gpp_dec__ireset              ;
  logic                ldpc_3gpp_dec__iclkena             ;
  //
  logic        [7 : 0] ldpc_3gpp_dec__iNiter              ;
  logic                ldpc_3gpp_dec__ifmode              ;
  logic        [6 : 0] ldpc_3gpp_dec__inidx               ;
  logic        [5 : 0] ldpc_3gpp_dec__icode               ;
  logic                ldpc_3gpp_dec__ido_punct           ;
  //
  logic                ldpc_3gpp_dec__ival                ;
  logic                ldpc_3gpp_dec__isop                ;
  logic                ldpc_3gpp_dec__ieop                ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_dec__itag                ;
  llr_t                ldpc_3gpp_dec__iLLR     [pLLR_NUM] ;
  //
  logic                ldpc_3gpp_dec__obusy               ;
  logic                ldpc_3gpp_dec__ordy                ;
  logic                ldpc_3gpp_dec__osrc_err            ;
  //
  logic                ldpc_3gpp_dec__ireq                ;
  logic                ldpc_3gpp_dec__ofull               ;
  //
  logic                ldpc_3gpp_dec__oval                ;
  logic                ldpc_3gpp_dec__osop                ;
  logic                ldpc_3gpp_dec__oeop                ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_dec__otag                ;
  logic [pDAT_W-1 : 0] ldpc_3gpp_dec__odat                ;
  //
  logic                ldpc_3gpp_dec__odecfail            ;
  logic [pERR_W-1 : 0] ldpc_3gpp_dec__oerr                ;



  ldpc_3gpp_dec_seq
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
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
    .pNODE_SCALE_W ( pNODE_SCALE_W ) ,
    .pNODE_W       ( pNODE_W       ) ,
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    //
    .pNORM_FACTOR  ( pNORM_FACTOR  ) ,
    //
    .pMEM_ADDR_MAX ( pMEM_ADDR_MAX ) ,
    .pUSE_HSHAKE   ( pUSE_HSHAKE   ) ,
    .pUSE_HC_SROM  ( pUSE_HC_SROM  )
  )
  ldpc_3gpp_dec
  (
    .iclk      ( ldpc_3gpp_dec__iclk      ) ,
    .ireset    ( ldpc_3gpp_dec__ireset    ) ,
    .iclkena   ( ldpc_3gpp_dec__iclkena   ) ,
    //
    .iNiter    ( ldpc_3gpp_dec__iNiter    ) ,
    .ifmode    ( ldpc_3gpp_dec__ifmode    ) ,
    .inidx     ( ldpc_3gpp_dec__inidx     ) ,
    .icode     ( ldpc_3gpp_dec__icode     ) ,
    .ido_punct ( ldpc_3gpp_dec__ido_punct ) ,
    //
    .ival      ( ldpc_3gpp_dec__ival      ) ,
    .isop      ( ldpc_3gpp_dec__isop      ) ,
    .ieop      ( ldpc_3gpp_dec__ieop      ) ,
    .itag      ( ldpc_3gpp_dec__itag      ) ,
    .iLLR      ( ldpc_3gpp_dec__iLLR      ) ,
    //
    .obusy     ( ldpc_3gpp_dec__obusy     ) ,
    .ordy      ( ldpc_3gpp_dec__ordy      ) ,
    .osrc_err  ( ldpc_3gpp_dec__osrc_err  ) ,
    //
    .ireq      ( ldpc_3gpp_dec__ireq      ) ,
    .ofull     ( ldpc_3gpp_dec__ofull     ) ,
    //
    .oval      ( ldpc_3gpp_dec__oval      ) ,
    .osop      ( ldpc_3gpp_dec__osop      ) ,
    .oeop      ( ldpc_3gpp_dec__oeop      ) ,
    .otag      ( ldpc_3gpp_dec__otag      ) ,
    .odat      ( ldpc_3gpp_dec__odat      ) ,
    //
    .odecfail  ( ldpc_3gpp_dec__odecfail  ) ,
    .oerr      ( ldpc_3gpp_dec__oerr      )
  );


  assign ldpc_3gpp_dec__iclk      = '0 ;
  assign ldpc_3gpp_dec__ireset    = '0 ;
  assign ldpc_3gpp_dec__iclkena   = '0 ;
  //
  assign ldpc_3gpp_dec__iNiter    = '0 ;
  assign ldpc_3gpp_dec__ifmode    = '0 ;
  assign ldpc_3gpp_dec__inidx     = '0 ;
  assign ldpc_3gpp_dec__icode     = '0 ;
  assign ldpc_3gpp_dec__ido_punct = '0 ;
  //
  assign ldpc_3gpp_dec__ival      = '0 ;
  assign ldpc_3gpp_dec__isop      = '0 ;
  assign ldpc_3gpp_dec__ieop      = '0 ;
  assign ldpc_3gpp_dec__itag      = '0 ;
  assign ldpc_3gpp_dec__iLLR      = '0 ;
  //
  assign ldpc_3gpp_dec__ireq      = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_wrp.sv
// Description   : Static 3GPP LDPC RTL decoder wrapper
//


module ldpc_3gpp_dec_wrp
#(
  parameter bit pIDX_GR       =  0 ,  // use graph1/graph2
  parameter int pIDX_LS       =  0 ,
  parameter int pIDX_ZC       =  7 ,
  parameter int pCODE         =  4 ,  // code rate using (46 for graph1 and 42 for graph2)
  parameter bit pDO_PUNCT     =  1 ,  // use puncture
  //
  parameter int pLLR_W        =  4 ,
  parameter int pLLR_NUM      =  4 ,  // == 1/2/4/8/16 & <= minimum cZC & integer multiply of minimum cZC
  //
  parameter int pDAT_W        =  4 ,  // == 1/2/4/8/16 <= minimum cZC & integer multiply of minimum cZC
  parameter int pTAG_W        =  4 ,
  //
  parameter int pERR_W        = 16 ,
  //
  parameter int pNODE_W       =  4 ,
  parameter int pROW_BY_CYCLE =  4
)
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
  oerr
);

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

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec
  #(
    .pIDX_GR         ( pIDX_GR         ) ,
    .pIDX_LS         ( pIDX_LS         ) ,
    .pIDX_ZC         ( pIDX_ZC         ) ,
    .pCODE           ( pCODE           ) ,
    .pDO_PUNCT       ( pDO_PUNCT       ) ,
    //
    .pLLR_W          ( pLLR_W          ) ,
    .pLLR_NUM        ( pLLR_NUM        ) ,
    //
    .pDAT_W          ( pDAT_W          ) ,
    .pTAG_W          ( pTAG_W          ) ,
    //
    .pERR_W          ( pERR_W          ) ,
    //
    .pNODE_W         ( pNODE_W         ) ,
    .pLLR_BY_CYCLE   ( 1               ) ,
    .pROW_BY_CYCLE   ( pROW_BY_CYCLE   ) ,
    //
    .pUSE_FIXED_CODE ( 1               ) ,
    .pUSE_SC_MODE    ( 1               )
  )
  ldpc_3gpp_dec
  (
    .iclk      ( iclk      ) ,
    .ireset    ( ireset    ) ,
    .iclkena   ( iclkena   ) ,
    //
    .iNiter    ( iNiter    ) ,
    .ifmode    ( ifmode    ) ,
    .inidx     ( '0        ) ,
    .icode     ( '0        ) ,
    .ido_punct ( '0        ) ,
    //
    .ival      ( ival      ) ,
    .isop      ( isop      ) ,
    .ieop      ( ieop      ) ,
    .itag      ( itag      ) ,
    .iLLR      ( iLLR      ) ,
    //
    .obusy     ( obusy     ) ,
    .ordy      ( ordy      ) ,
    .osrc_err  ( osrc_err  ) ,
    //
    .ireq      ( ireq      ) ,
    .ofull     ( ofull     ) ,
    //
    .oval      ( oval      ) ,
    .osop      ( osop      ) ,
    .oeop      ( oeop      ) ,
    .otag      ( otag      ) ,
    .odat      ( odat      ) ,
    //
    .odecfail  ( odecfail  ) ,
    .oerr      ( oerr      )
  );

endmodule
