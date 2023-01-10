/*



  parameter int pDAT_W                  =  8;
  parameter int pSYMB_M_W               =  4;
  parameter int pERR_CNT_W              = 16;
  parameter int pTRB_LENGTH             = 64;
  parameter bit pUSE_TRB_FAST_DECISION  =  1;
  parameter bit pSOP_STATE_SYNC_DISABLE =  0;



  logic                    tcm_dec__iclk    ;
  logic                    tcm_dec__ireset  ;
  logic                    tcm_dec__iclkena ;
  logic            [1 : 0] tcm_dec__icode   ;
  logic                    tcm_dec__i1sps   ;
  logic                    tcm_dec__isop    ;
  logic                    tcm_dec__isop    ;
  logic                    tcm_dec__ival    ;
  logic                    tcm_dec__ieop    ;
  logic     [pDAT_W-1 : 0] tcm_dec__idat_re ;
  logic     [pDAT_W-1 : 0] tcm_dec__idat_im ;
  logic                    tcm_dec__osop    ;
  logic                    tcm_dec__oval    ;
  logic                    tcm_dec__oeop    ;
  logic           [10 : 0] tcm_dec__odat    ;
  logic            [3 : 0] tcm_dec__obiterr ;
  logic [pERR_CNT_W-1 : 0] tcm_dec__oerrcnt ;



  tcm_dec
  #(
    .pDAT_W                  ( pDAT_W                  ) ,
    .pSYMB_M_W               ( pSYMB_M_W               ) ,
    .pERR_CNT_W              ( pERR_CNT_W              ) ,
    .pTRB_LENGTH             ( pTRB_LENGTH             ) ,
    .pUSE_TRB_FAST_DECISION  ( pUSE_TRB_FAST_DECISION  ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE )
  )
  tcm_dec
  (
    .iclk    ( tcm_dec__iclk    ) ,
    .ireset  ( tcm_dec__ireset  ) ,
    .iclkena ( tcm_dec__iclkena ) ,
    .icode   ( tcm_dec__icode   ) ,
    .i1sps   ( tcm_dec__i1sps   ) ,
    .isop    ( tcm_dec__isop    ) ,
    .ival    ( tcm_dec__ival    ) ,
    .ieop    ( tcm_dec__ieop    ) ,
    .idat_re ( tcm_dec__idat_re ) ,
    .idat_im ( tcm_dec__idat_im ) ,
    .osop    ( tcm_dec__osop    ) ,
    .oval    ( tcm_dec__oval    ) ,
    .oeop    ( tcm_dec__oeop    ) ,
    .odat    ( tcm_dec__odat    ) ,
    .obiterr ( tcm_dec__obiterr ) ,
    .oerrcnt ( tcm_dec__oerrcnt )
  );


  assign tcm_dec__iclk    = '0 ;
  assign tcm_dec__ireset  = '0 ;
  assign tcm_dec__iclkena = '0 ;
  assign tcm_dec__icode   = '0 ;
  assign tcm_dec__i1sps   = '0 ;
  assign tcm_dec__isop    = '0 ;
  assign tcm_dec__ival    = '0 ;
  assign tcm_dec__ieop    = '0 ;
  assign tcm_dec__idat_re = '0 ;
  assign tcm_dec__idat_im = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec.sv
// Description   : 4D-8PSK TCM decoder top
//

`include "define.vh"

module tcm_dec
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  //
  i1sps   ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat_re ,
  idat_im ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  obiterr ,
  oerrcnt
);

  parameter int pDAT_W                  = 8;
  parameter bit pUSE_TRB_FAST_DECISION  = 1; // use fast decision (state 0) for usual (not flush) treaceback
  parameter bit pSOP_STATE_SYNC_DISABLE = 0; // disable recursive processor state initialization at sop

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                    iclk    ;
  input  logic                    ireset  ;
  input  logic                    iclkena ;
  //
  input  logic            [1 : 0] icode   ; // 0/1/2/3 - 2/2.25/2.5/2.75
  //
  input  logic                    i1sps   ; // 8PSK symbol val
  //
  input  logic                    isop    ;
  input  logic                    ival    ; // 4D 8PSK start symbol label
  input  logic                    ieop    ;
  input  logic     [pDAT_W-1 : 0] idat_re ;
  input  logic     [pDAT_W-1 : 0] idat_im ;
  //
  output logic                    osop    ;
  output logic                    oval    ;
  output logic                    oeop    ;
  output logic           [10 : 0] odat    ;
  output logic            [3 : 0] obiterr ;
  output logic [pERR_CNT_W-1 : 0] oerrcnt ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // metric calculator
  logic           symb_mc__o1sps        ;
  logic           symb_mc__osop         ;
  logic           symb_mc__oval         ;
  logic           symb_mc__oeop         ;
  symb_m_t        symb_mc__osymb_m      ;
  symb_m_sign_t   symb_mc__osymb_m_sign ;

  // 4D assembler
  logic           symb_m_asm__osop              ;
  logic           symb_m_asm__oval              ;
  logic           symb_m_asm__oeop              ;
  symb_m_t        symb_m_asm__osymb_m       [4] ;
  symb_m_sign_t   symb_m_asm__osymb_m_sign  [4] ;

  // tmu
  logic           tmu__osop                  ;
  logic           tmu__oval                  ;
  logic           tmu__oeop                  ;
  bm_t            tmu__obm                   ;
  symb_m_idx_t    tmu__osymb_m_idx      [16] ;
  symb_m_sign_t   tmu__osymb_m_sign      [4] ;
  symb_hd_t       tmu__osymb_hd              ;

  // recursive processor
  logic           rp__osop                   ;
  logic           rp__oval                   ;
  logic           rp__oeop                   ;
  statem_t        rp__ostatem                ;
  decision_t      rp__odecision              ;

  symb_m_idx_t    rp_symb_m_idx         [16] ;
  symb_m_sign_t   rp_symb_m_sign         [4] ;
  symb_hd_t       rp_symb_hd                 ;

  // traceback
  logic           trb__osop                  ;
  logic           trb__oval                  ;
  logic           trb__oeop                  ;
  trel_bm_idx_t   trb__obm_idx               ;
  symb_m_idx_t    trb__osymb_m_idx           ;
  symb_m_sign_t   trb__osymb_m_sign      [4] ;
  symb_hd_t       trb__osymb_hd              ;

  // demapper
  logic           demapper__osop             ;
  logic           demapper__oval             ;
  logic           demapper__oeop             ;
  logic   [2 : 0] demapper__osymb        [4] ;
  logic   [3 : 0] demapper__obiterr          ;

  //------------------------------------------------------------------------------------------------------
  // symbol metric calculator and 4D symbol assembler
  //------------------------------------------------------------------------------------------------------

  tcm_dec_symb_mc
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pSYMB_M_W ( pSYMB_M_W )
  )
  symb_mc
  (
    .iclk         ( iclk                  ) ,
    .ireset       ( ireset                ) ,
    .iclkena      ( iclkena               ) ,
    //
    .i1sps        ( i1sps                 ) ,
    .isop         ( isop                  ) ,
    .ival         ( ival                  ) ,
    .ieop         ( ieop                  ) ,
    .idat_re      ( idat_re               ) ,
    .idat_im      ( idat_im               ) ,
    //
    .o1sps        ( symb_mc__o1sps        ) ,
    .osop         ( symb_mc__osop         ) ,
    .oval         ( symb_mc__oval         ) ,
    .oeop         ( symb_mc__oeop         ) ,
    .osymb_m      ( symb_mc__osymb_m      ) ,
    .osymb_m_sign ( symb_mc__osymb_m_sign )
  );

  //------------------------------------------------------------------------------------------------------
  // 4D symbol assembler
  //------------------------------------------------------------------------------------------------------

  tcm_dec_symb_m_asm
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  symb_m_asm
  (
    .iclk         ( iclk                     ) ,
    .ireset       ( ireset                   ) ,
    .iclkena      ( iclkena                  ) ,
    //
    .i1sps        ( symb_mc__o1sps           ) ,
    .isop         ( symb_mc__osop            ) ,
    .ival         ( symb_mc__oval            ) ,
    .ieop         ( symb_mc__oeop            ) ,
    .isymb_m      ( symb_mc__osymb_m         ) ,
    .isymb_m_sign ( symb_mc__osymb_m_sign    ) ,
    //
    .osop         ( symb_m_asm__osop         ) ,
    .oval         ( symb_m_asm__oval         ) ,
    .oeop         ( symb_m_asm__oeop         ) ,
    .osymb_m      ( symb_m_asm__osymb_m      ) ,
    .osymb_m_sign ( symb_m_asm__osymb_m_sign )
  );

  //------------------------------------------------------------------------------------------------------
  // trellis transition metric unit (TMU)
  //------------------------------------------------------------------------------------------------------

  tcm_dec_tmu
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tmu
  (
    .iclk         ( iclk                     ) ,
    .ireset       ( ireset                   ) ,
    .iclkena      ( iclkena                  ) ,
    //
    .icode        ( icode                    ) ,
    //
    .isop         ( symb_m_asm__osop         ) ,
    .ival         ( symb_m_asm__oval         ) ,
    .ieop         ( symb_m_asm__oeop         ) ,
    .isymb_m      ( symb_m_asm__osymb_m      ) ,
    .isymb_m_sign ( symb_m_asm__osymb_m_sign ) ,
    //
    .osop         ( tmu__osop                ) ,
    .oval         ( tmu__oval                ) ,
    .oeop         ( tmu__oeop                ) ,
    //
    .obm          ( tmu__obm                 ) ,
    //
    .osymb_m_idx  ( tmu__osymb_m_idx         ) ,
    .osymb_m_sign ( tmu__osymb_m_sign        ) ,
    .osymb_hd     ( tmu__osymb_hd            )
  );

  //------------------------------------------------------------------------------------------------------
  // add compare select (recursive processor)
  //------------------------------------------------------------------------------------------------------

  tcm_dec_rp
  #(
    .pSYMB_M_W               ( pSYMB_M_W               ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE )
  )
  rp
  (
    .iclk      ( iclk          ) ,
    .ireset    ( ireset        ) ,
    .iclkena   ( iclkena       ) ,
    //
    .isop      ( tmu__osop     ) ,
    .ival      ( tmu__oval     ) ,
    .ieop      ( tmu__oeop     ) ,
    .ibm       ( tmu__obm      ) ,
    //
    .osop      ( rp__osop      ) ,
    .oval      ( rp__oval      ) ,
    .oeop      ( rp__oeop      ) ,
    .ostatem   ( rp__ostatem   ) ,
    .odecision ( rp__odecision )
  );

  //------------------------------------------------------------------------------------------------------
  // align delay of rp (1 tick)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      rp_symb_m_idx  <= tmu__osymb_m_idx  ;
      rp_symb_m_sign <= tmu__osymb_m_sign ;
      rp_symb_hd     <= tmu__osymb_hd;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Traceback unit
  //------------------------------------------------------------------------------------------------------

  tcm_dec_trb
  #(
    .pSYMB_M_W          ( pSYMB_M_W              ) ,
    .pTRB_LENGTH        ( pTRB_LENGTH            ) ,
    .pUSE_FAST_DECISION ( pUSE_TRB_FAST_DECISION )
  )
  traceback
  (
    .iclk         ( iclk              ) ,
    .ireset       ( ireset            ) ,
    .iclkena      ( iclkena           ) ,
    //
    .isop         ( rp__osop          ) ,
    .ival         ( rp__oval          ) ,
    .ieop         ( rp__oeop          ) ,
    .istatem      ( rp__ostatem       ) ,
    .idecision    ( rp__odecision     ) ,
    .isymb_m_idx  ( rp_symb_m_idx     ) ,
    .isymb_m_sign ( rp_symb_m_sign    ) ,
    .isymb_hd     ( rp_symb_hd        ) ,
    //
    .osop         ( trb__osop         ) ,
    .oval         ( trb__oval         ) ,
    .oeop         ( trb__oeop         ) ,
    .obm_idx      ( trb__obm_idx      ) ,
    .osymb_m_idx  ( trb__osymb_m_idx  ) ,
    .osymb_m_sign ( trb__osymb_m_sign ) ,
    .osymb_hd     ( trb__osymb_hd     )
  );

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  tcm_dec_demapper
  demapper
  (
    .iclk         ( iclk              ) ,
    .ireset       ( ireset            ) ,
    .iclkena      ( iclkena           ) ,
    //
    .icode        ( icode             ) ,
    //
    .isop         ( trb__osop         ) ,
    .ival         ( trb__oval         ) ,
    .ieop         ( trb__oeop         ) ,
    .ibm_idx      ( trb__obm_idx      ) ,
    .isymb_m_idx  ( trb__osymb_m_idx  ) ,
    .isymb_m_sign ( trb__osymb_m_sign ) ,
    .isymb_hd     ( trb__osymb_hd     ) ,
    //
    .osop         ( demapper__osop    ) ,
    .oval         ( demapper__oval    ) ,
    .oeop         ( demapper__oeop    ) ,
    .osymb        ( demapper__osymb   ) ,
    .obiterr      ( demapper__obiterr )
  );

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  tcm_dec_dfd
  dfd
  (
    .iclk    ( iclk            ) ,
    .ireset  ( ireset          ) ,
    .iclkena ( iclkena         ) ,
    //
    .icode   ( icode           ) ,
    //
    .isop    ( demapper__osop  ) ,
    .ival    ( demapper__oval  ) ,
    .ieop    ( demapper__oeop  ) ,
    .isymb   ( demapper__osymb ) ,
    //
    .osop    ( osop            ) ,
    .oval    ( oval            ) ,
    .oeop    ( oeop            ) ,
    .odat    ( odat            )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (demapper__oval) begin
        obiterr <= demapper__obiterr;
        oerrcnt <= demapper__osop ? demapper__obiterr : (oerrcnt + demapper__obiterr);
      end
    end
  end

endmodule
