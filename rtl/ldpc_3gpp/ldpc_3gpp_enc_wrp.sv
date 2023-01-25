/*



  parameter int pDAT_W    = 8 ;
  parameter int pTAG_W    = 4 ;
  //
  parameter bit pIDX_GR   = 0 ;
  parameter int pIDX_LS   = 0 ;
  parameter int pIDX_ZC   = 7 ;
  parameter int pCODE     = 4 ;
  parameter int pDO_PUNCT = 1 ;


  logic                ldpc_3gpp_enc_wrp__iclk      ;
  logic                ldpc_3gpp_enc_wrp__ireset    ;
  logic                ldpc_3gpp_enc_wrp__iclkena   ;
  //
  logic                ldpc_3gpp_enc_wrp__isop      ;
  logic                ldpc_3gpp_enc_wrp__ival      ;
  logic                ldpc_3gpp_enc_wrp__ieop      ;
  logic [pDAT_W-1 : 0] ldpc_3gpp_enc_wrp__idat      ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_enc_wrp__itag      ;
  //
  logic                ldpc_3gpp_enc_wrp__obusy     ;
  logic                ldpc_3gpp_enc_wrp__ordy      ;
  logic                ldpc_3gpp_enc_wrp__osrc_err  ;
  //
  logic                ldpc_3gpp_enc_wrp__ireq      ;
  logic                ldpc_3gpp_enc_wrp__ofull     ;
  //
  logic                ldpc_3gpp_enc_wrp__osop      ;
  logic                ldpc_3gpp_enc_wrp__oval      ;
  logic                ldpc_3gpp_enc_wrp__oeop      ;
  logic [pDAT_W-1 : 0] ldpc_3gpp_enc_wrp__odat      ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_enc_wrp__otag      ;



  ldpc_3gpp_enc_wrp
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pTAG_W    ( pTAG_W    ) ,
    //
    .pIDX_GR   ( pIDX_GR   ) ,
    .pIDX_LS   ( pIDX_LS   ) ,
    .pIDX_ZC   ( pIDX_ZC   ) ,
    .pCODE     ( pCODE     ) ,
    .pDO_PUNCT ( pDO_PUNCT )
  )
  ldpc_3gpp_enc_wrp
  (
    .iclk      ( ldpc_3gpp_enc_wrp__iclk      ) ,
    .ireset    ( ldpc_3gpp_enc_wrp__ireset    ) ,
    .iclkena   ( ldpc_3gpp_enc_wrp__iclkena   ) ,
    //
    .isop      ( ldpc_3gpp_enc_wrp__isop      ) ,
    .ival      ( ldpc_3gpp_enc_wrp__ival      ) ,
    .ieop      ( ldpc_3gpp_enc_wrp__ieop      ) ,
    .idat      ( ldpc_3gpp_enc_wrp__idat      ) ,
    .itag      ( ldpc_3gpp_enc_wrp__itag      ) ,
    //
    .obusy     ( ldpc_3gpp_enc_wrp__obusy     ) ,
    .ordy      ( ldpc_3gpp_enc_wrp__ordy      ) ,
    .osrc_err  ( ldpc_3gpp_enc_wrp__osrc_err  ) ,
    //
    .ireq      ( ldpc_3gpp_enc_wrp__ireq      ) ,
    .ofull     ( ldpc_3gpp_enc_wrp__ofull     ) ,
    //
    .osop      ( ldpc_3gpp_enc_wrp__osop      ) ,
    .oval      ( ldpc_3gpp_enc_wrp__oval      ) ,
    .oeop      ( ldpc_3gpp_enc_wrp__oeop      ) ,
    .odat      ( ldpc_3gpp_enc_wrp__odat      ) ,
    .otag      ( ldpc_3gpp_enc_wrp__otag      )
  );


  assign ldpc_3gpp_enc_wrp__iclk      = '0 ;
  assign ldpc_3gpp_enc_wrp__ireset    = '0 ;
  assign ldpc_3gpp_enc_wrp__iclkena   = '0 ;
  //
  assign ldpc_3gpp_enc_wrp__isop      = '0 ;
  assign ldpc_3gpp_enc_wrp__ival      = '0 ;
  assign ldpc_3gpp_enc_wrp__ieop      = '0 ;
  assign ldpc_3gpp_enc_wrp__idat      = '0 ;
  assign ldpc_3gpp_enc_wrp__itag      = '0 ;
  //
  assign ldpc_3gpp_enc_wrp__ireq      = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_wrp.sv
// Description   : Static 3GPP LDPC RTL encoder wrapper
//


module ldpc_3gpp_enc_wrp
#(
  parameter int pDAT_W    = 8 , // 1/2/4/8/16/32 supported
  parameter int pTAG_W    = 4 ,
  //
  parameter bit pIDX_GR   = 0 , // use graph1/graph2
  parameter int pIDX_LS   = 0 ,
  parameter int pIDX_ZC   = 7 ,
  parameter int pCODE     = 4 , // code rate using (46 for graph1 and 42 for graph2)
  parameter bit pDO_PUNCT = 1   // use puncture

)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  isop      ,
  ival      ,
  ieop      ,
  idat      ,
  itag      ,
  //
  obusy     ,
  ordy      ,
  osrc_err  ,
  //
  ireq      ,
  ofull     ,
  //
  osop      ,
  oval      ,
  oeop      ,
  odat      ,
  otag
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk      ;
  input  logic                ireset    ;
  input  logic                iclkena   ;
  //
  input  logic                isop      ;
  input  logic                ival      ;
  input  logic                ieop      ;
  input  logic [pDAT_W-1 : 0] idat      ;
  input  logic [pTAG_W-1 : 0] itag      ;
  //
  output logic                obusy     ;
  output logic                ordy      ;
  output logic                osrc_err  ; // source error if handshake is not using
  //
  input  logic                ireq      ;
  output logic                ofull     ;
  //
  output logic                osop      ;
  output logic                oval      ;
  output logic                oeop      ;
  output logic [pDAT_W-1 : 0] odat      ;
  output logic [pTAG_W-1 : 0] otag      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc
  #(
    .pDAT_W          ( pDAT_W          ) ,
    .pTAG_W          ( pTAG_W          ) ,
    //
    .pIDX_GR         ( pIDX_GR         ) ,
    .pIDX_LS         ( pIDX_LS         ) ,
    .pIDX_ZC         ( pIDX_ZC         ) ,
    .pCODE           ( pCODE           ) ,
    .pDO_PUNCT       ( pDO_PUNCT       ) ,
    //
    .pUSE_HSHAKE     ( 0               ) ,
    .pUSE_FIXED_CODE ( 1               ) ,
    .pUSE_P1_SLOW    ( 1               )
  )
  enc
  (
    .iclk      ( iclk      ) ,
    .ireset    ( ireset    ) ,
    .iclkena   ( iclkena   ) ,
    //
    .inidx     ( '0        ) ,
    .icode     ( '0        ) ,
    .ido_punct ( '0        ) ,
    //
    .isop      ( isop      ) ,
    .ival      ( ival      ) ,
    .ieop      ( ieop      ) ,
    .idat      ( idat      ) ,
    .itag      ( itag      ) ,
    //
    .obusy     ( obusy     ) ,
    .ordy      ( ordy      ) ,
    .osrc_err  ( osrc_err  ) ,
    //
    .ireq      ( ireq      ) ,
    .ofull     ( ofull     ) ,
    //
    .osop      ( osop      ) ,
    .oval      ( oval      ) ,
    .oeop      ( oeop      ) ,
    .odat      ( odat      ) ,
    .otag      ( otag      )
  );

endmodule
