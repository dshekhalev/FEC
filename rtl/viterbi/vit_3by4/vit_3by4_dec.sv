/*



  parameter int pLLR_W                    = 4 ;
  parameter int pERR_CNT_W                = 16;
  parameter int pTAG_W                    = 4 ;
  parameter bit pUSE_TRB_FAST_DECISION    =  1;
  parameter bit pSOP_STATE_SYNC_DISABLE   = 0 ;



  logic                    vit_3by4_dec__iclk         ;
  logic                    vit_3by4_dec__ireset       ;
  logic                    vit_3by4_dec__iclkena      ;
  logic                    vit_3by4_dec__isop         ;
  logic                    vit_3by4_dec__ival         ;
  logic                    vit_3by4_dec__ieop         ;
  logic     [pTAG_W-1 : 0] vit_3by4_dec__itag         ;
  logic     [pLLR_W-1 : 0] vit_3by4_dec__iLLR     [4] ;
  logic                    vit_3by4_dec__osop         ;
  logic                    vit_3by4_dec__oval         ;
  logic                    vit_3by4_dec__oeop         ;
  logic     [pTAG_W-1 : 0] vit_3by4_dec__otag         ;
  logic            [2 : 0] vit_3by4_dec__odat         ;
  logic            [1 : 0] vit_3by4_dec__obiterr      ;
  logic [pERR_CNT_W-1 : 0] vit_3by4_dec__oerrcnt      ;



  vit_3by4_dec
  #(
    .pLLR_W                  ( pLLR_W                  ) ,
    .pERR_CNT_W              ( pERR_CNT_W              ) ,
    .pTAG_W                  ( pTAG_W                  ) ,
    .pUSE_TRB_FAST_DECISION  ( pUSE_TRB_FAST_DECISION  ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE )
  )
  vit_3by4_dec
  (
    .iclk    ( vit_3by4_dec__iclk    ) ,
    .ireset  ( vit_3by4_dec__ireset  ) ,
    .iclkena ( vit_3by4_dec__iclkena ) ,
    .isop    ( vit_3by4_dec__isop    ) ,
    .ival    ( vit_3by4_dec__ival    ) ,
    .ieop    ( vit_3by4_dec__ieop    ) ,
    .itag    ( vit_3by4_dec__itag    ) ,
    .iLLR    ( vit_3by4_dec__iLLR    ) ,
    .osop    ( vit_3by4_dec__osop    ) ,
    .oval    ( vit_3by4_dec__oval    ) ,
    .oeop    ( vit_3by4_dec__oeop    ) ,
    .otag    ( vit_3by4_dec__otag    ) ,
    .odat    ( vit_3by4_dec__odat    ) ,
    .obiterr ( vit_3by4_dec__obiterr ) ,
    .oerrcnt ( vit_3by4_dec__oerrcnt )
  );


  assign vit_3by4_dec__iclk    = '0 ;
  assign vit_3by4_dec__ireset  = '0 ;
  assign vit_3by4_dec__iclkena = '0 ;
  assign vit_3by4_dec__isop    = '0 ;
  assign vit_3by4_dec__ival    = '0 ;
  assign vit_3by4_dec__ieop    = '0 ;
  assign vit_3by4_dec__itag    = '0 ;
  assign vit_3by4_dec__iLLR    = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_dec.sv
// Description   : viteri 3/4 soft decoder top
//


module vit_3by4_dec
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  itag    ,
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

  parameter bit pUSE_TRB_FAST_DECISION  = 1; // use fast decision (state 0) for usual (not flush) treaceback
  parameter bit pSOP_STATE_SYNC_DISABLE = 0; // disable recursive processor state initialization at sop

  `include "vit_3by4_trellis.svh"
  `include "vit_3by4_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk         ;
  input  logic                       ireset       ;
  input  logic                       iclkena      ;
  //
  input  logic                       isop         ;
  input  logic                       ival         ;
  input  logic                       ieop         ;
  input  logic        [pTAG_W-1 : 0] itag         ;
  input  logic signed [pLLR_W-1 : 0] iLLR     [4] ;
  //
  output logic                       osop         ;
  output logic                       oval         ;
  output logic                       oeop         ;
  output logic        [pTAG_W-1 : 0] otag         ;
  output logic               [2 : 0] odat         ;
  output logic               [1 : 0] obiterr      ;
  output logic    [pERR_CNT_W-1 : 0] oerrcnt      ;

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

  vit_3by4_dec_bmc
  #(
    .pLLR_W ( pLLR_W ) ,
    .pTAG_W ( pTAG_W )
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

  vit_3by4_dec_rp
  #(
    .pLLR_W                  ( pLLR_W                  ) ,
    .pTAG_W                  ( pTAG_W                  ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE )
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

  vit_3by4_dec_trb
  #(
    .pLLR_W         ( pLLR_W         ) ,
    .pTRB_LENGTH    ( pTRB_LENGTH    ) ,
    .pERR_CNT_W     ( pERR_CNT_W     ) ,
    .pTAG_W         ( pTAG_W         )
  )
  trb
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
