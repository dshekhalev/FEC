/*



  parameter int pLLR_W  = 4 ;
  parameter int pTAG_W  = 4 ;



  logic                golay24_dec__iclk     ;
  logic                golay24_dec__ireset   ;
  logic                golay24_dec__iclkena  ;
  logic                golay24_dec__isop     ;
  logic                golay24_dec__ival     ;
  logic                golay24_dec__ieop     ;
  logic [pTAG_W-1 : 0] golay24_dec__itag     ;
  logic [pLLR_W-1 : 0] golay24_dec__iLLR     ;
  logic                golay24_dec__oval     ;
  logic [pTAG_W-1 : 0] golay24_dec__otag     ;
  logic       [11 : 0] golay24_dec__odat     ;
  logic        [3 : 0] golay24_dec__oerr     ;



  golay24_dec
  #(
    .pLLR_W ( pLLR_W ) ,
    .pTAG_W ( pTAG_W )
  )
  golay24_dec
  (
    .iclk    ( golay24_dec__iclk    ) ,
    .ireset  ( golay24_dec__ireset  ) ,
    .iclkena ( golay24_dec__iclkena ) ,
    .isop    ( golay24_dec__isop    ) ,
    .ival    ( golay24_dec__ival    ) ,
    .ieop    ( golay24_dec__ieop    ) ,
    .itag    ( golay24_dec__itag    ) ,
    .iLLR    ( golay24_dec__iLLR    ) ,
    .oval    ( golay24_dec__oval    ) ,
    .otag    ( golay24_dec__otag    ) ,
    .odat    ( golay24_dec__odat    ) ,
    .oerr    ( golay24_dec__oerr    )
  );


  assign golay24_dec__iclk    = '0 ;
  assign golay24_dec__ireset  = '0 ;
  assign golay24_dec__iclkena = '0 ;
  assign golay24_dec__isop    = '0 ;
  assign golay24_dec__ival    = '0 ;
  assign golay24_dec__ieop    = '0 ;
  assign golay24_dec__itag    = '0 ;
  assign golay24_dec__iLLR    = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision$
// Date          : $Date$
// Workfile      : golay24_dec.sv
// Description   : golay extened code {24, 12, 8} soft decoder. g(x) = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1 (12'hC75)
//                  decoder use Chase II algorithm with 16 candidates
//


module golay24_dec
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
  oval    ,
  otag    ,
  odat    ,
  oerr
);

  `include "golay24_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk     ;
  input  logic          ireset   ;
  input  logic          iclkena  ;
  //
  input  logic          isop     ;
  input  logic          ival     ;
  input  logic          ieop     ;
  input  tag_t          itag     ;
  input  llr_t          iLLR     ;
  //
  output logic          oval     ;
  output tag_t          otag     ;
  output logic [11 : 0] odat     ;
  output logic  [3 : 0] oerr     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic     source__oval            ;
  tag_t     source__otag            ;
  dat_t     source__och_hd          ;
  metric_t  source__och_metric      ;
  llr_t     source__oLLR       [24] ;
  idx_t     source__oidx        [4] ;

  logic     processing__osop         ;
  logic     processing__oval         ;
  logic     processing__oeop         ;
  tag_t     processing__otag         ;
  dat_t     processing__och_hd       ;
  metric_t  processing__och_metric   ;
  dat_t     processing__ocand_dat    ;
  metric_t  processing__ocand_metric ;

  //------------------------------------------------------------------------------------------------------
  // source unit
  //------------------------------------------------------------------------------------------------------

  golay24_dec_source
  #(
    .pLLR_W   ( pLLR_W  ) ,
    .pTAG_W   ( pTAG_W  ) ,
    .pIDX_NUM ( 4       )
  )
  source
  (
    .iclk       ( iclk               ) ,
    .ireset     ( ireset             ) ,
    .iclkena    ( iclkena            ) ,
    //
    .isop       ( isop               ) ,
    .ival       ( ival               ) ,
    .ieop       ( ieop               ) ,
    .itag       ( itag               ) ,
    .iLLR       ( iLLR               ) ,
    //
    .oval       ( source__oval       ) ,
    .otag       ( source__otag       ) ,
    .och_hd     ( source__och_hd     ) ,
    .och_metric ( source__och_metric ) ,
    .oLLR       ( source__oLLR       ) ,
    .oidx       ( source__oidx       )
  );

  //------------------------------------------------------------------------------------------------------
  // processing block
  //------------------------------------------------------------------------------------------------------

  golay24_dec_processing
  #(
    .pLLR_W   ( pLLR_W  ) ,
    .pTAG_W   ( pTAG_W  ) ,
    .pIDX_NUM ( 4       )
  )
  processing
  (
    .iclk         ( iclk                      ) ,
    .ireset       ( ireset                    ) ,
    .iclkena      ( iclkena                   ) ,
    //
    .ival         ( source__oval              ) ,
    .itag         ( source__otag              ) ,
    .ich_hd       ( source__och_hd            ) ,
    .ich_metric   ( source__och_metric        ) ,
    .iLLR         ( source__oLLR              ) ,
    .iidx         ( source__oidx              ) ,
    //
    .osop         ( processing__osop         ) ,
    .oval         ( processing__oval         ) ,
    .oeop         ( processing__oeop         ) ,
    .otag         ( processing__otag         ) ,
    //
    .och_hd       ( processing__och_hd       ) ,
    .och_metric   ( processing__och_metric   ) ,
    //
    .ocand_dat    ( processing__ocand_dat    ) ,
    .ocand_metric ( processing__ocand_metric )
  );

  //------------------------------------------------------------------------------------------------------
  // ML decision block
  //------------------------------------------------------------------------------------------------------

  dat_t decision__odat;

  golay24_dec_decision
  #(
    .pLLR_W ( pLLR_W ) ,
    .pTAG_W ( pTAG_W )
  )
  decision
  (
    .iclk         ( iclk                     ) ,
    .ireset       ( ireset                   ) ,
    .iclkena      ( iclkena                  ) ,
    //
    .isop         ( processing__osop         ) ,
    .ival         ( processing__oval         ) ,
    .ieop         ( processing__oeop         ) ,
    .itag         ( processing__otag         ) ,
    //
    .ich_hd       ( processing__och_hd       ) ,
    .ich_metric   ( processing__och_metric   ) ,
    //
    .icand_dat    ( processing__ocand_dat    ) ,
    .icand_metric ( processing__ocand_metric ) ,
    //
    .oval         ( oval                     ) ,
    .otag         ( otag                     ) ,
    .odat         ( decision__odat           ) ,
    .oerr         ( oerr                     )
  );

  assign odat = decision__odat[11 : 0];

endmodule
