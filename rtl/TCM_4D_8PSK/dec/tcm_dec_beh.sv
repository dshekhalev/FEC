/*



  parameter int pDAT_W      = 8 ;
  parameter int pSYMB_M_W   = 4;
  parameter int pERR_CNT_W  = 16;



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
    .pDAT_W     ( pDAT_W      ) ,
    .pSYMB_M_W  ( pSYMB_M_W   ) ,
    .pERR_CNT_W ( pERR_CNT_W  )
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
// Workfile      : tcm_dec_beh.sv
// Description   : 4D-8PSK TCM decoder behaviour
//

`include "define.vh"

module tcm_dec_beh
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

  parameter int pDAT_W = 8;

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
  trel_bm_t       tmu__obm              [16] ;
  symb_m_idx_t    tmu__osymb_m_idx      [16] ;
  symb_m_sign_t   tmu__osymb_m_sign      [4] ;

  // recursive processor
  logic           rp__osop                   ;
  logic           rp__oval                   ;
  logic           rp__oeop                   ;
  trel_statem_t   rp__ostatem   [cSTATE_NUM] ;
  trel_decision_t rp__odecision [cSTATE_NUM] ;

  symb_m_idx_t    rp_symb_m_idx  [16] ;
  symb_m_sign_t   rp_symb_m_sign  [4] ;

  // traceback

  // demapper
  logic           demapper__isop              ;
  logic           demapper__ival              ;
  logic           demapper__ieop              ;
  trel_bm_idx_t   demapper__ibm_idx           ;
  symb_m_idx_t    demapper__isymb_m_idx       ;
  symb_m_sign_t   demapper__isymb_m_sign  [4] ;
  logic           demapper__osop              ;
  logic           demapper__oval              ;
  logic           demapper__oeop              ;
  logic   [2 : 0] demapper__osymb         [4] ;

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
    .osymb_m_sign ( tmu__osymb_m_sign        )
  );

  //------------------------------------------------------------------------------------------------------
  // add compare select (recursive processor)
  //------------------------------------------------------------------------------------------------------

  tcm_dec_rp
  #(
    .pSYMB_M_W ( pSYMB_M_W )
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
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "tcm_symb_m_group_tab.svh"

  struct {
    trel_decision_t decision [cSTATE_NUM] ;
//  acsu_decision_t acsu_decision;
    symb_m_idx_t    symb_m_idx    [16];
    symb_m_sign_t   symb_m_sign   [4];
  } decision [1024];


  int addr;
  stateb_t state;
  stateb_t pre_state;
  trel_decision_t used_decision;
  trel_bm_idx_t decoded_bm_idx;
  trel_bm_idx_t used_bm_idx;
  bit [1 : 0] decoded_symbol [4];
  int decoded_true_symbol [4];
  symb_m_sign_t used_sign [4];

  always_ff @(posedge iclk) begin
    int max;
    int max_idx;
    if (iclkena) begin
      if (rp__oval) begin
        if (rp__osop) addr = 0;

        decision[addr].symb_m_idx  = rp_symb_m_idx;
        decision[addr].symb_m_sign = rp_symb_m_sign;
        decision[addr++].decision  = rp__odecision;

        max_idx = 0;
        max     = rp__ostatem[0];
        for (int state = 1; state < cSTATE_NUM; state++) begin
          if (rp__ostatem[state] > max) begin
            max = rp__ostatem[state];
            max_idx = state;
          end
        end
//      $display("%0t decision[%0d] = %0d ", $time, max_idx, max);
        if (rp__oeop) begin
          $display("end trellis. do traceback");
          state = max_idx;
          addr--; // compensate
          //
          for (int i = addr; i >= 0; i--) begin
            used_decision = decision[i].decision[state];
            pre_state = trel.preStates[state][used_decision];
            //
            decoded_bm_idx = {used_decision, pre_state[0]};
            used_bm_idx     = decision[i].symb_m_idx[decoded_bm_idx];
            case (icode)
              0       : decoded_symbol  = cSM_IDX_200_TAB[decoded_bm_idx][used_bm_idx];
              1       : decoded_symbol  = cSM_IDX_225_TAB[decoded_bm_idx][used_bm_idx];
              2       : decoded_symbol  = cSM_IDX_250_TAB[decoded_bm_idx][used_bm_idx];
              default : decoded_symbol  = cSM_IDX_275_TAB[decoded_bm_idx][used_bm_idx];
            endcase

            used_sign       = decision[i].symb_m_sign;
            //
            for (int i = 0; i < 4; i++) begin
              decoded_true_symbol[i] = decoded_symbol[i];
              if (used_sign[i][decoded_symbol[i]])
                decoded_true_symbol[i] += 4;
            end
            //
            $display("%0d : state = %0d, decision = %0d, pre_state %0d, br_idx = %0d, %0d, symbol %0p -> %0p", i, state, used_decision, pre_state,
                     decoded_bm_idx, used_bm_idx, decoded_symbol, decoded_true_symbol);
            state = pre_state;
          end
          //
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Traceback unit
  //------------------------------------------------------------------------------------------------------
/*
  tcm_dec_trb
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
  s  .iclk      ( iclk               ) ,
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
*/

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  tcm_dec_demapper
  demapper
  (
    .iclk         ( iclk         ) ,
    .ireset       ( ireset       ) ,
    .iclkena      ( iclkena      ) ,
    //
    .icode        ( icode        ) ,
    //
    .isop         ( demapper__isop         ) ,
    .ival         ( demapper__ival         ) ,
    .ieop         ( demapper__ieop         ) ,
    .ibm_idx      ( demapper__ibm_idx      ) ,
    .isymb_m_idx  ( demapper__isymb_m_idx  ) ,
    .isymb_m_sign ( demapper__isymb_m_sign ) ,
    //
    .osop         ( demapper__osop         ) ,
    .oval         ( demapper__oval         ) ,
    .oeop         ( demapper__oeop         ) ,
    .osymb        ( demapper__osymb        )
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

endmodule
