/*



  parameter int pLLR_W   =  8 ;
  parameter int pEXTR_W  =  8 ;
  parameter int pADDR_W  =  8 ;
  //
  parameter int pDEC_NUM =  8 ;
  //
  parameter int pTAG_W   =  8 ;
  parameter int pERR_W   = 16 ;



  logic                             btc_dec_engine__iclk                   ;
  logic                             btc_dec_engine__ireset                 ;
  logic                             btc_dec_engine__iclkena                ;
  //
  btc_code_mode_t                   btc_dec_engine__ixmode                 ;
  btc_code_mode_t                   btc_dec_engine__iymode                 ;
  btc_short_mode_t                  btc_dec_engine__ismode                 ;
  logic                     [3 : 0] btc_dec_engine__iNiter                 ;
  //
  logic                             btc_dec_engine__irbuf_full             ;
  logic              [pLLR_W-1 : 0] btc_dec_engine__irLLR       [pDEC_NUM] ;
  logic              [pTAG_W-1 : 0] btc_dec_engine__irtag                  ;
  logic                             btc_dec_engine__orempty                ;
  logic             [pADDR_W-1 : 0] btc_dec_engine__oraddr                 ;
  //
  logic                             btc_dec_engine__iwbuf_empty            ;
  //
  logic                             btc_dec_engine__owrite                 ;
  logic                             btc_dec_engine__owfull                 ;
  logic             [pADDR_W-1 : 0] btc_dec_engine__owaddr                 ;
  logic            [pDEC_NUM-1 : 0] btc_dec_engine__owdat                  ;
  logic              [pTAG_W-1 : 0] btc_dec_engine__owtag                  ;
  logic              [pERR_W-1 : 0] btc_dec_engine__owerr                  ;
  logic                             btc_dec_engine__owdecfail              ;
  //
  btc_code_mode_t                   btc_dec_engine__oxmode                 ;
  btc_code_mode_t                   btc_dec_engine__oymode                 ;
  btc_short_mode_t                  btc_dec_engine__osmode                 ;



  btc_dec_engine
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pEXTR_W  ( pEXTR_W  ) ,
    //
    .pADDR_W  ( pADDR_W  ) ,
    //
    .pDEC_NUM ( pDEC_NUM ) ,
    //
    .pERR_W   ( pERR_W   ) ,
    .pTAG_W   ( pTAG_W   )
  )
  btc_dec_engine
  (
    .iclk        ( btc_dec_engine__iclk        ) ,
    .ireset      ( btc_dec_engine__ireset      ) ,
    .iclkena     ( btc_dec_engine__iclkena     ) ,
    //
    .ixmode      ( btc_dec_engine__ixmode      ) ,
    .iymode      ( btc_dec_engine__iymode      ) ,
    .ismode      ( btc_dec_engine__ismode      ) ,
    .iNiter      ( btc_dec_engine__iNiter      ) ,
    //
    .irbuf_full  ( btc_dec_engine__irbuf_full  ) ,
    .irLLR       ( btc_dec_engine__irLLR       ) ,
    .irtag       ( btc_dec_engine__irtag       ) ,
    .oread       ( btc_dec_engine__oread       ) ,
    .orempty     ( btc_dec_engine__orempty     ) ,
    .oraddr      ( btc_dec_engine__oraddr      ) ,
    //
    .iwbuf_empty ( btc_dec_engine__iwbuf_empty ) ,
    //
    .owrite      ( btc_dec_engine__owrite      ) ,
    .owfull      ( btc_dec_engine__owfull      ) ,
    .owaddr      ( btc_dec_engine__owaddr      ) ,
    .owdat       ( btc_dec_engine__owdat       ) ,
    .owtag       ( btc_dec_engine__owtag       ) ,
    .owerr       ( btc_dec_engine__owerr       ) ,
    .owdecfail   ( btc_dec_engine__owdecfail   ) ,
    //
    .oxmode      ( btc_dec_engine__oxmode      ) ,
    .oymode      ( btc_dec_engine__oymode      ) ,
    .osmode      ( btc_dec_engine__osmode      )
  );


  assign btc_dec_engine__iclk        = '0 ;
  assign btc_dec_engine__ireset      = '0 ;
  assign btc_dec_engine__iclkena     = '0 ;
  assign btc_dec_engine__ixmode      = '0 ;
  assign btc_dec_engine__iymode      = '0 ;
  assign btc_dec_engine__ismode      = '0 ;
  assign btc_dec_engine__iNiter      = '0 ;
  assign btc_dec_engine__irbuf_full  = '0 ;
  assign btc_dec_engine__irLLR       = '0 ;
  assign btc_dec_engine__irtag       = '0 ;
  assign btc_dec_engine__iwbuf_empty = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_engine.sv
// Description   : wimax 802.16-2012 BTC decoder engine
//

module btc_dec_engine
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  ixmode      ,
  iymode      ,
  ismode      ,
  iNiter      ,
  //
  irbuf_full  ,
  irLLR       ,
  irtag       ,
  orempty     ,
  oraddr      ,
  //
  iwbuf_empty ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  owtag       ,
  owerr       ,
  owdecfail   ,
  //
  oxmode      ,
  oymode      ,
  osmode
);

  parameter int pADDR_W  =  8 ;
  //
  parameter int pDEC_NUM =  8 ;
  //
  parameter int pTAG_W   =  8 ;
  parameter int pERR_W   = 16 ;

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                             iclk                   ;
  input  logic                             ireset                 ;
  input  logic                             iclkena                ;
  //
  input  btc_code_mode_t                   ixmode                 ;
  input  btc_code_mode_t                   iymode                 ;
  input  btc_short_mode_t                  ismode                 ;
  input  logic                     [3 : 0] iNiter;
  //
  input  logic                             irbuf_full             ;
  input  logic              [pLLR_W-1 : 0] irLLR       [pDEC_NUM] ;
  input  logic              [pTAG_W-1 : 0] irtag                  ;
  output logic                             orempty                ;
  output logic             [pADDR_W-1 : 0] oraddr                 ;
  //
  input  logic                             iwbuf_empty            ;
  //
  output logic                             owrite                 ;
  output logic                             owfull                 ;
  output logic             [pADDR_W-1 : 0] owaddr                 ;
  output logic            [pDEC_NUM-1 : 0] owdat                  ;
  output logic              [pTAG_W-1 : 0] owtag                  ;
  output logic              [pERR_W-1 : 0] owerr                  ;
  output logic                             owdecfail              ;
  //
  output btc_code_mode_t                   oxmode                 ;
  output btc_code_mode_t                   oymode                 ;
  output btc_short_mode_t                  osmode                 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cMEM_DAT_W   = pDEC_NUM * pEXTR_W;
  localparam int cMEM_ADDR_W  = $clog2(cROW_MAX * cCOL_MAX/pDEC_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // ctrl
  logic                     ctrl__irbuf_full  ;
  logic                     ctrl__obuf_rempty ;
  //
  logic                     ctrl__iwbuf_empty ;
  //
  logic     [pADDR_W-1 : 0] ctrl__obuf_addr   ;
  //
  logic                     ctrl__orow_mode   ;
  //
  logic                     ctrl__idec_busy   ;
  logic    [pDEC_NUM-1 : 0] ctrl__odec_val    ;
  strb_t                    ctrl__odec_strb   ;
  alpha_t                   ctrl__odec_alpha  ;
  //
  logic                     ctrl__idecfail    ;
  logic                     ctrl__ostart_iter ;
  logic                     ctrl__olast_iter  ;

  //
  // component code
  btc_code_mode_t           code__ixmode               ;
  btc_code_mode_t           code__iymode               ;
  //
  logic                     code__istart               ;
  logic                     code__irow_mode            ;
  alpha_t                   code__ialpha               ;
  //
  logic    [pDEC_NUM-1 : 0] code__ival                 ;
  strb_t                    code__istrb                ;
  llr_t                     code__iLLR      [pDEC_NUM] ;
  extr_t                    code__iLextr    [pDEC_NUM] ;
  //
  logic                     code__oval                 ;
  strb_t                    code__ostrb                ;
  extr_t                    code__oLextr    [pDEC_NUM] ;
  //
  logic     [pADDR_W-1 : 0] code__owaddr               ;
  //
  logic    [pDEC_NUM-1 : 0] code__obitdat              ;
  logic      [pERR_W-1 : 0] code__obiterr              ;
  //
  logic                     code__odecfail             ;

  //
  // mem block
  logic                     mem__iwrite   ;
  logic [cMEM_ADDR_W-1 : 0] mem__iwaddr   ;
  logic  [cMEM_DAT_W-1 : 0] mem__iwdat    ;
  //
  logic [cMEM_ADDR_W-1 : 0] mem__iraddr   ;
  logic  [cMEM_DAT_W-1 : 0] mem__ordat    ;

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  btc_dec_ctrl
  #(
    .pADDR_W  ( pADDR_W  ) ,
    .pDEC_NUM ( pDEC_NUM )
  )
  ctrl
  (
    .iclk        ( iclk              ) ,
    .ireset      ( ireset            ) ,
    .iclkena     ( iclkena           ) ,
    //
    .ixmode      ( ixmode            ) ,
    .iymode      ( iymode            ) ,
    .ismode      ( ismode            ) ,
    .iNiter      ( iNiter            ) ,
    //
    .irbuf_full  ( ctrl__irbuf_full  ) ,
    .obuf_rempty ( ctrl__obuf_rempty ) ,
    //
    .iwbuf_empty ( ctrl__iwbuf_empty ) ,
    //
    .obuf_addr   ( ctrl__obuf_addr   ) ,
    //
    .orow_mode   ( ctrl__orow_mode   ) ,
    //
    .idec_busy   ( ctrl__idec_busy   ) ,
    .odec_val    ( ctrl__odec_val    ) ,
    .odec_strb   ( ctrl__odec_strb   ) ,
    .odec_alpha  ( ctrl__odec_alpha  ) ,
    //
    .idecfail    ( ctrl__idecfail    ) ,
    .ostart_iter ( ctrl__ostart_iter ) ,
    .olast_iter  ( ctrl__olast_iter  )
  );

  assign ctrl__irbuf_full   = irbuf_full;

  assign ctrl__iwbuf_empty  = iwbuf_empty;

  assign ctrl__idecfail     = 1'b0;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ctrl__idec_busy <= 1'b0;
    end
    else if (iclkena) begin
      if (ctrl__odec_val[0]) begin
        ctrl__idec_busy <= 1'b1;
      end
      else if (code__oval & code__ostrb.eof) begin
        ctrl__idec_busy <= 1'b0;
      end
    end
  end

  assign orempty = ctrl__obuf_rempty;
  assign oraddr  = ctrl__obuf_addr;

  //------------------------------------------------------------------------------------------------------
  // address/controls align line
  // ibuffer & internl ram read latency is 2 tick
  //------------------------------------------------------------------------------------------------------

  logic   [pDEC_NUM-1 : 0] dec_val_line   [2] ;
  strb_t                   dec_strb_line  [2] ;
  alpha_t                  dec_alpha_line [2] ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dec_val_line  [0] <= ctrl__odec_val;
      dec_strb_line [0] <= ctrl__odec_strb;
      dec_alpha_line[0] <= ctrl__odec_alpha;
      //
      dec_val_line  [1] <= dec_val_line   [0];
      dec_strb_line [1] <= dec_strb_line  [0];
      dec_alpha_line[1] <= dec_alpha_line [0];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // component decoder array
  //------------------------------------------------------------------------------------------------------

  btc_dec_comp_code
  #(
    .pLLR_W   ( pLLR_W      ) ,
    .pEXTR_W  ( pEXTR_W     ) ,
    //
    .pADDR_W  ( cMEM_ADDR_W ) ,
    .pERR_W   ( pERR_W      ) ,
    //
    .pDEC_NUM ( pDEC_NUM    )
  )
  code
  (
    .iclk      ( iclk            ) ,
    .ireset    ( ireset          ) ,
    .iclkena   ( iclkena         ) ,
    //
    .ixmode    ( code__ixmode    ) ,
    .iymode    ( code__iymode    ) ,
    //
    .istart    ( code__istart    ) ,
    .irow_mode ( code__irow_mode ) ,
    .ialpha    ( code__ialpha    ) ,
    //
    .ival      ( code__ival      ) ,
    .istrb     ( code__istrb     ) ,
    .iLLR      ( code__iLLR      ) ,
    .iLextr    ( code__iLextr    ) ,
    //
    .oval      ( code__oval      ) ,
    .ostrb     ( code__ostrb     ) ,
    .oLextr    ( code__oLextr    ) ,
    //
    .owaddr    ( code__owaddr    ) ,
    //
    .obitdat   ( code__obitdat   ) ,
    .obiterr   ( code__obiterr   ) ,
    //
    .odecfail  ( code__odecfail  )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      code__ixmode <= ixmode ;
      code__iymode <= iymode ;
    end
  end

  assign code__istart    = ctrl__ostart_iter ;
  assign code__irow_mode = ctrl__orow_mode ;

  assign code__ival      = dec_val_line   [1] ;
  assign code__istrb     = dec_strb_line  [1] ;
  assign code__ialpha    = dec_alpha_line [1] ;

  always_comb begin
    for (int i = 0; i < pDEC_NUM; i++) begin
      code__iLLR  [i] = irLLR [i];
      code__iLextr[i] = mem__ordat[i*pEXTR_W +: pEXTR_W] ;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // extrinsic ram buffer
  //------------------------------------------------------------------------------------------------------

  codec_mem_block
  #(
    .pADDR_W ( cMEM_ADDR_W ) ,
    .pDAT_W  ( cMEM_DAT_W  ) ,
    .pPIPE   ( 1           )
  )
  mem
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .iwrite  ( mem__iwrite  ) ,
    .iwaddr  ( mem__iwaddr  ) ,
    .iwdat   ( mem__iwdat   ) ,
    //
    .iraddr  ( mem__iraddr  ) ,
    .ordat   ( mem__ordat   )
  );

  assign mem__iwrite = code__oval;
  assign mem__iwaddr = code__owaddr;

  always_comb begin
    for (int i = 0; i < pDEC_NUM; i++) begin
      mem__iwdat[i*pEXTR_W +: pEXTR_W] = code__oLextr[i];
    end
  end

  assign mem__iraddr = ctrl__obuf_addr;

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite  <= 1'b0;
      owfull  <= 1'b0;
    end
    else if (iclkena) begin
      owrite  <= code__oval & ctrl__olast_iter;
      owfull  <= code__oval & code__ostrb.eof & ctrl__olast_iter;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owaddr    <= code__owaddr;
      owdat     <= code__obitdat;
      owerr     <= code__obiterr;
      owdecfail <= code__odecfail;
      //
      if (ctrl__ostart_iter) begin
        owtag   <= irtag;
        oxmode  <= ixmode;
        oymode  <= iymode;
        osmode  <= ismode;
      end
    end
  end

endmodule
