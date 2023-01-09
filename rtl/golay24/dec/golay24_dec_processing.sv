/*



  parameter int pLLR_W   = 4 ;
  parameter int pTAG_W   = 4 ;
  parameter int pIDX_NUM = 4 ;



  logic    golay24_dec_processing__iclk                    ;
  logic    golay24_dec_processing__ireset                  ;
  logic    golay24_dec_processing__iclkena                 ;
  logic    golay24_dec_processing__ival                    ;
  tag_t    golay24_dec_processing__itag                    ;
  dat_t    golay24_dec_processing__ich_hd                  ;
  metric_t golay24_dec_processing__ich_metric              ;
  llr_t    golay24_dec_processing__iLLR               [24] ;
  idx_t    golay24_dec_processing__iidx         [pIDX_NUM] ;
  logic    golay24_dec_processing__osop                    ;
  logic    golay24_dec_processing__oval                    ;
  logic    golay24_dec_processing__oeop                    ;
  tag_t    golay24_dec_processing__otag                    ;
  data_t   golay24_dec_processing__och_hd                  ;
  metric_t golay24_dec_processing__och_metric              ;
  data_t   golay24_dec_processing__ocand_dat               ;
  metric_t golay24_dec_processing__ocand_metric            ;



  golay24_dec_processing
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pTAG_W   ( pTAG_W   ) ,
    .pIDX_NUM ( pIDX_NUM )
  )
  golay24_dec_processing
  (
    .iclk         ( golay24_dec_processing__iclk         ) ,
    .ireset       ( golay24_dec_processing__ireset       ) ,
    .iclkena      ( golay24_dec_processing__iclkena      ) ,
    .ival         ( golay24_dec_processing__ival         ) ,
    .itag         ( golay24_dec_processing__itag         ) ,
    .ich_hd       ( golay24_dec_processing__ich_hd       ) ,
    .ich_metric   ( golay24_dec_processing__ich_metric   ) ,
    .iLLR         ( golay24_dec_processing__iLLR         ) ,
    .iidx         ( golay24_dec_processing__iidx         ) ,
    .osop         ( golay24_dec_processing__osop         ) ,
    .oval         ( golay24_dec_processing__oval         ) ,
    .oeop         ( golay24_dec_processing__oeop         ) ,
    .otag         ( golay24_dec_processing__otag         ) ,
    .och_hd       ( golay24_dec_processing__och_hd       ) ,
    .och_metric   ( golay24_dec_processing__och_metric   ) ,
    .ocand_dat    ( golay24_dec_processing__ocand_dat    ) ,
    .ocand_metric ( golay24_dec_processing__ocand_metric )
  );


  assign golay24_dec_processing__iclk       = '0 ;
  assign golay24_dec_processing__ireset     = '0 ;
  assign golay24_dec_processing__iclkena    = '0 ;
  assign golay24_dec_processing__ival       = '0 ;
  assign golay24_dec_processing__itag       = '0 ;
  assign golay24_dec_processing__ich_hd     = '0 ;
  assign golay24_dec_processing__ich_metric = '0 ;
  assign golay24_dec_processing__iLLR       = '0 ;
  assign golay24_dec_processing__iidx       = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision$
// Date          : $Date$
// Workfile      : golay24_dec_processing.sv
// Description   : the processing pipeline : generate candidates -> hd decode -> count metric
//


module golay24_dec_processing
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  ival         ,
  itag         ,
  ich_hd       ,
  ich_metric   ,
  iLLR         ,
  iidx         ,
  //
  osop         ,
  oval         ,
  oeop         ,
  otag         ,
  //
  och_hd       ,
  och_metric   ,
  //
  ocand_dat    ,
  ocand_metric
);

  parameter int pIDX_NUM  = 4;

  `include "golay24_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk                   ;
  input  logic    ireset                 ;
  input  logic    iclkena                ;
  //
  input  logic    ival                   ;
  input  tag_t    itag                   ;
  input  dat_t    ich_hd                 ;  // channel hard decision
  input  metric_t ich_metric             ;  // channel metric
  input  llr_t    iLLR              [24] ;  // saturated LLR
  input  idx_t    iidx        [pIDX_NUM] ;  // least reliable LLRs indexes
  //
  output logic    osop                   ;
  output logic    oval                   ;
  output logic    oeop                   ;
  output tag_t    otag                   ;
  //
  output dat_t    och_hd                 ;  // channel hard decision
  output metric_t och_metric             ;  // channel metric
  //
  output dat_t    ocand_dat              ;  // candidate data
  output metric_t ocand_metric           ;  // condidate metric

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // candidate generator
  logic   cand_gen__osop   ;
  logic   cand_gen__oval   ;
  logic   cand_gen__oeop   ;
  dat_t   cand_gen__odat   ;

  // hd decoder engine
  logic   engine__osop     ;
  logic   engine__oval     ;
  logic   engine__oeop     ;
  logic   engine__ofailed  ;
  dat_t   engine__odat     ;

  // metric calcularor
  llr_t   metric_calc__iLLR [24];

  //------------------------------------------------------------------------------------------------------
  // candidate generator
  //------------------------------------------------------------------------------------------------------

  golay24_dec_candidate_gen
  #(
    .pIDX_NUM ( pIDX_NUM )
  )
  cand_gen
  (
    .iclk    ( iclk           ) ,
    .ireset  ( ireset         ) ,
    .iclkena ( iclkena        ) ,
    //
    .ival    ( ival           ) ,
    .ich_hd  ( ich_hd         ) ,
    .iidx    ( iidx           ) ,
    //
    .osop    ( cand_gen__osop ) ,
    .oval    ( cand_gen__oval ) ,
    .oeop    ( cand_gen__oeop ) ,
    .odat    ( cand_gen__odat )
  );

  // capture "constant" for decoding frame data
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        otag       <= itag;
        och_hd     <= ich_hd;
        och_metric <= ich_metric;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // candidate decoder
  //------------------------------------------------------------------------------------------------------

  golay24_dec_engine
  engine
  (
    .iclk    ( iclk            ) ,
    .ireset  ( ireset          ) ,
    .iclkena ( iclkena         ) ,
    //
    .isop    ( cand_gen__osop  ) ,
    .ival    ( cand_gen__oval  ) ,
    .ieop    ( cand_gen__oeop  ) ,
    .idat    ( cand_gen__odat  ) ,
    //
    .osop    ( engine__osop    ) ,
    .oval    ( engine__oval    ) ,
    .oeop    ( engine__oeop    ) ,
    .ofailed ( engine__ofailed ) ,
    .odat    ( engine__odat    )
  );

  //------------------------------------------------------------------------------------------------------
  // metric calculator
  //------------------------------------------------------------------------------------------------------

  golay24_dec_metric_calc
  #(
    .pLLR_W ( pLLR_W )
  )
  metric_calc
  (
    .iclk     ( iclk              ) ,
    .ireset   ( ireset            ) ,
    .iclkena  ( iclkena           ) ,
    //
    .isop     ( engine__osop      ) ,
    .ival     ( engine__oval      ) ,
    .ieop     ( engine__oeop      ) ,
    .idat     ( engine__odat      ) ,
    .ifailed  ( engine__ofailed   ) ,
    //
    .iLLR     ( metric_calc__iLLR ) ,
    //
    .osop     ( osop              ) ,
    .oval     ( oval              ) ,
    .oeop     ( oeop              ) ,
    .odat     ( ocand_dat         ) ,
    .ometric  ( ocand_metric      )
  );

  // capture "constant" for decoding frame data
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        metric_calc__iLLR <= iLLR;
      end
    end
  end

endmodule
