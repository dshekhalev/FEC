/*



  parameter int pCONSTR_LENGTH            = 3;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};
  parameter int pLLR_W                    = 4 ;
  parameter int pTRB_LENGTH               = 5*pCONSTR_LENGTH;
  parameter int pERR_CNT_W                = 16;
  parameter int pTAG_W                    = 4 ;
  parameter bit pSOP_STATE_SYNC_DISABLE   = 0 ;
  parameter bit pUSE_ACSU_LA              = 0 ;



  logic                       vit_dec__iclk                     ;
  logic                       vit_dec__ireset                   ;
  logic                       vit_dec__iclkena                  ;
  logic                       vit_dec__isop                     ;
  logic                       vit_dec__ival                     ;
  logic                       vit_dec__ieop                     ;
  logic        [pTAG_W-1 : 0] vit_dec__itag                     ;
  logic [pCODE_GEN_NUM-1 : 0] vit_dec__idat                     ;
  logic        [pLLR_W-1 : 0] vit_dec__iLLR     [pCODE_GEN_NUM] ;
  logic                       vit_dec__osop                     ;
  logic                       vit_dec__oval                     ;
  logic                       vit_dec__oeop                     ;
  logic        [pTAG_W-1 : 0] vit_dec__otag                     ;
  logic                       vit_dec__odat                     ;
  logic [pCODE_GEN_NUM-1 : 0] vit_dec__obiterr                  ;
  logic    [pERR_CNT_W-1 : 0] vit_dec__oerrcnt                  ;



  vit_dec
  #(
    .pCONSTR_LENGTH          ( pCONSTR_LENGTH          ) ,
    .pCODE_GEN_NUM           ( pCODE_GEN_NUM           ) ,
    .pCODE_GEN               ( pCODE_GEN               ) ,
    .pLLR_W                  ( pLLR_W                  ) ,
    .pTRB_LENGTH             ( pTRB_LENGTH             ) ,
    .pERR_CNT_W              ( pERR_CNT_W              ) ,
    .pTAG_W                  ( pTAG_W                  ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE ) ,
    .pUSE_ACSU_LA            ( pUSE_ACSU_LA            )
  )
  vit_dec
  (
    .iclk    ( vit_dec__iclk    ) ,
    .ireset  ( vit_dec__ireset  ) ,
    .iclkena ( vit_dec__iclkena ) ,
    .isop    ( vit_dec__isop    ) ,
    .ival    ( vit_dec__ival    ) ,
    .ieop    ( vit_dec__ieop    ) ,
    .itag    ( vit_dec__itag    ) ,
    .idat    ( vit_dec__idat    ) ,
    .iLLR    ( vit_dec__iLLR    ) ,
    .osop    ( vit_dec__osop    ) ,
    .oval    ( vit_dec__oval    ) ,
    .oeop    ( vit_dec__oeop    ) ,
    .otag    ( vit_dec__otag    ) ,
    .odat    ( vit_dec__odat    ) ,
    .obiterr ( vit_dec__obiterr ) ,
    .oerrcnt ( vit_dec__oerrcnt )
  );


  assign vit_dec__iclk    = '0 ;
  assign vit_dec__ireset  = '0 ;
  assign vit_dec__iclkena = '0 ;
  assign vit_dec__isop    = '0 ;
  assign vit_dec__ival    = '0 ;
  assign vit_dec__ieop    = '0 ;
  assign vit_dec__itag    = '0 ;
  assign vit_dec__idat    = '0 ;
  assign vit_dec__iLLR    = '0 ;



*/

//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_dec.sv
// Description   : viteri hard(pLLR_W == 1)/soft(pLLR_W > 1) decoder to use with terminated trellis.
//                 The termination bits cut off from output data automatically
//


module vit_dec
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  itag    ,
  idat    ,
  iLLR    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  otag    ,
  odat    ,
  obiterr ,
  oerrcnt
);

  parameter bit pSOP_STATE_SYNC_DISABLE = 0; // disable recursive processor state initialization at sop
  parameter bit pUSE_ACSU_LA            = 0; // use ACSU with look ahead

  `include "vit_trellis.svh"
  `include "vit_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                     ;
  input  logic                       ireset                   ;
  input  logic                       iclkena                  ;
  //
  input  logic                       isop                     ;
  input  logic                       ival                     ;
  input  logic                       ieop                     ;
  input  logic        [pTAG_W-1 : 0] itag                     ;
  input  logic [pCODE_GEN_NUM-1 : 0] idat                     ; // hard decision use if pLLR_W == 1
  input  logic signed [pLLR_W-1 : 0] iLLR     [pCODE_GEN_NUM] ; // use otherwise
  //
  output logic                       osop                     ;
  output logic                       oval                     ;
  output logic                       oeop                     ;
  output logic        [pTAG_W-1 : 0] otag                     ;
  output logic                       odat                     ;
  output logic [pCODE_GEN_NUM-1 : 0] obiterr                  ;
  output logic    [pERR_CNT_W-1 : 0] oerrcnt                  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic      bmc__osop     ;
  logic      bmc__oval     ;
  logic      bmc__oeop     ;
  tag_t      bmc__otag     ;
  bm_t       bmc__obm      ;
  boutputs_t bmc__ohd      ;

  logic      rp__osop      ;
  logic      rp__oval      ;
  logic      rp__oeop      ;
  tag_t      rp__otag      ;
  boutputs_t rp__ohd       ;
  statem_t   rp__ostatem   ;
  decision_t rp__odecision ;

  //------------------------------------------------------------------------------------------------------
  // branch metric calculator
  //------------------------------------------------------------------------------------------------------

  vit_dec_bmc
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    //
    .pLLR_W         ( pLLR_W         ) ,
    //
    .pTAG_W         ( pTAG_W         )
  )
  bmc
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .isop    ( isop       ) ,
    .ival    ( ival       ) ,
    .ieop    ( ieop       ) ,
    .itag    ( itag       ) ,
    .idat    ( idat       ) ,
    .iLLR    ( iLLR       ) ,
    //
    .osop    ( bmc__osop  ) ,
    .oval    ( bmc__oval  ) ,
    .oeop    ( bmc__oeop  ) ,
    .otag    ( bmc__otag  ) ,
    .ohd     ( bmc__ohd   ) ,
    .obm     ( bmc__obm   )
  );

  //------------------------------------------------------------------------------------------------------
  // add compare select (recursive processor)
  //------------------------------------------------------------------------------------------------------

  vit_dec_rp
  #(
    .pCONSTR_LENGTH          ( pCONSTR_LENGTH          ) ,
    .pCODE_GEN_NUM           ( pCODE_GEN_NUM           ) ,
    .pCODE_GEN               ( pCODE_GEN               ) ,
    //
    .pLLR_W                  ( pLLR_W                  ) ,
    //
    .pTAG_W                  ( pTAG_W                  ) ,
    //
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE ) ,
    .pUSE_ACSU_LA            ( pUSE_ACSU_LA            )
  )
  rp
  (
    .iclk      ( iclk          ) ,
    .ireset    ( ireset        ) ,
    .iclkena   ( iclkena       ) ,
    //
    .isop      ( bmc__osop     ) ,
    .ival      ( bmc__oval     ) ,
    .ieop      ( bmc__oeop     ) ,
    .itag      ( bmc__otag     ) ,
    .ihd       ( bmc__ohd      ) ,
    .ibm       ( bmc__obm      ) ,
    //
    .osop      ( rp__osop      ) ,
    .oval      ( rp__oval      ) ,
    .oeop      ( rp__oeop      ) ,
    .otag      ( rp__otag      ) ,
    .ohd       ( rp__ohd       ) ,
    .ostatem   ( rp__ostatem   ) ,
    .odecision ( rp__odecision )
  );

  //------------------------------------------------------------------------------------------------------
  // Traceback unit
  //------------------------------------------------------------------------------------------------------

  vit_trb
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    //
    .pLLR_W         ( pLLR_W         ) ,
    //
    .pTRB_LENGTH    ( pTRB_LENGTH    ) ,
    //
    .pERR_CNT_W     ( pERR_CNT_W     ) ,
    //
    .pTAG_W         ( pTAG_W         )
  )
  traceback
  (
    .iclk      ( iclk               ) ,
    .ireset    ( ireset             ) ,
    .iclkena   ( iclkena            ) ,
    //
    .isop      ( rp__osop           ) ,
    .ival      ( rp__oval           ) ,
    .ieop      ( rp__oeop           ) ,
    .itag      ( rp__otag           ) ,
    .ihd       ( rp__ohd            ) ,
    .istatem   ( rp__ostatem        ) ,
    .idecision ( rp__odecision      ) ,
    //
    .osop      ( osop               ) ,
    .oval      ( oval               ) ,
    .oeop      ( oeop               ) ,
    .otag      ( otag               ) ,
    .odat      ( odat               ) ,
    .obiterr   ( obiterr            ) ,
    .oerrcnt   ( oerrcnt            )
  );

endmodule
