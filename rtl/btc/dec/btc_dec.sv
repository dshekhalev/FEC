/*



  parameter int pLLR_W  =  8 ;
  parameter int pEXTR_W =  8 ;
  parameter int pERR_W  = 16 ;
  parameter int pTAG_W  =  8 ;



  logic                           btc_dec__iclk     ;
  logic                           btc_dec__ireset   ;
  //
  btc_code_mode_t                 btc_dec__ixmode   ;
  btc_code_mode_t                 btc_dec__iymode   ;
  btc_short_mode_t                btc_dec__ismode   ;
  logic                   [3 : 0] btc_dec__iNiter   ;
  //
  logic                           btc_dec__iclkin   ;
  logic                           btc_dec__ival     ;
  logic                           btc_dec__isop     ;
  logic                           btc_dec__ieop     ;
  logic signed     [pLLR_W-1 : 0] btc_dec__iLLR     ;
  logic            [pTAG_W-1 : 0] btc_dec__itag     ;
  //
  logic                           btc_dec__ordy     ;
  logic                           btc_dec__obusy    ;
  //
  logic                           btc_dec__iclkout  ;
  logic                           btc_dec__ireq     ;
  logic                           btc_dec__ofull    ;
  //
  logic                           btc_dec__oval     ;
  logic                           btc_dec__osop     ;
  logic                           btc_dec__oeop     ;
  logic                           btc_dec__odat     ;
  logic            [pTAG_W-1 : 0] btc_dec__otag     ;
  //
  logic                           btc_dec__odecfail ;
  logic            [pERR_W-1 : 0] btc_dec__oerr     ;
  logic            [pERR_W-1 : 0] btc_dec__onum     ;



  btc_dec
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W ) ,
    .pERR_W  ( pERR_W  ) ,
    .pTAG_W  ( pTAG_W  )
  )
  btc_dec
  (
    .iclk     ( btc_dec__iclk     ) ,
    .ireset   ( btc_dec__ireset   ) ,
    //
    .ixmode   ( btc_dec__ixmode   ) ,
    .iymode   ( btc_dec__iymode   ) ,
    .ismode   ( btc_dec__ismode   ) ,
    .iNiter   ( btc_dec__iNiter   ) ,
    //
    .iclkin   ( btc_dec__iclkin   ) ,
    .ival     ( btc_dec__ival     ) ,
    .isop     ( btc_dec__isop     ) ,
    .ieop     ( btc_dec__ieop     ) ,
    .iLLR     ( btc_dec__iLLR     ) ,
    .itag     ( btc_dec__itag     ) ,
    //
    .ordy     ( btc_dec__ordy     ) ,
    .obusy    ( btc_dec__obusy    ) ,
    //
    .iclkout  ( btc_dec__iclkout  ) ,
    .ireq     ( btc_dec__ireq     ) ,
    .ofull    ( btc_dec__ofull    ) ,
    //
    .oval     ( btc_dec__oval     ) ,
    .osop     ( btc_dec__osop     ) ,
    .oeop     ( btc_dec__oeop     ) ,
    .odat     ( btc_dec__odat     ) ,
    .otag     ( btc_dec__otag     ) ,
    //
    .odecfail ( btc_dec__odecfail ) ,
    .oerr     ( btc_dec__oerr     ) ,
    .onum     ( btc_dec__onum     )
  );


  assign btc_dec__iclk    = '0 ;
  assign btc_dec__ireset  = '0 ;
  assign btc_dec__ixmode  = '0 ;
  assign btc_dec__iymode  = '0 ;
  assign btc_dec__ismode  = '0 ;
  assign btc_dec__iNiter  = '0 ;
  assign btc_dec__iclkin  = '0 ;
  assign btc_dec__ival    = '0 ;
  assign btc_dec__isop    = '0 ;
  assign btc_dec__ieop    = '0 ;
  assign btc_dec__iLLR    = '0 ;
  assign btc_dec__itag    = '0 ;
  assign btc_dec__iclkout = '0 ;
  assign btc_dec__ireq    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec.sv
// Description   : wimax 802.16-2012 BTC decoder top module
//

module btc_dec
(
  iclk     ,
  ireset   ,
  //
  ixmode   ,
  iymode   ,
  ismode   ,
  iNiter   ,
  //
  iclkin   ,
  ival     ,
  isop     ,
  ieop     ,
  iLLR     ,
  itag     ,
  //
  ordy     ,
  obusy    ,
  //
  iclkout  ,
  ireq     ,
  ofull    ,
  //
  oval     ,
  osop     ,
  oeop     ,
  odat     ,
  otag     ,
  //
  odecfail ,
  oerr     ,
  onum
);

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  parameter int pERR_W = 16 ;
  parameter int pTAG_W =  8 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                           iclk     ; // core clock
  input  logic                           ireset   ;
  //
  input  btc_code_mode_t                 ixmode   ;
  input  btc_code_mode_t                 iymode   ;
  input  btc_short_mode_t                ismode   ;
  input  logic                   [3 : 0] iNiter   ;
  //
  input  logic                           iclkin   ; // input interface clock
  //
  input  logic                           ival     ;
  input  logic                           isop     ;
  input  logic                           ieop     ;
  input  logic signed     [pLLR_W-1 : 0] iLLR     ;
  input  logic            [pTAG_W-1 : 0] itag     ;
  //
  output logic                           ordy     ;
  output logic                           obusy    ;
  //
  input  logic                           iclkout  ; // output interface clock
  input  logic                           ireq     ;
  output logic                           ofull    ;
  //
  output logic                           oval     ;
  output logic                           osop     ;
  output logic                           oeop     ;
  output logic                           odat     ;
  output logic            [pTAG_W-1 : 0] otag     ;
  //
  output logic                           odecfail ;
  output logic            [pERR_W-1 : 0] oerr     ;
  output logic            [pERR_W-1 : 0] onum     ; // number of bit due to oerr

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBUF_MAX_BIT   = cROW_MAX * cCOL_MAX;

  localparam int cDEC_NUM       = 8; // number of used component decoder engines

  //
  localparam int cIBUF_WADDR_W  = $clog2(cBUF_MAX_BIT);
  localparam int cIBUF_WDAT_W   = pLLR_W ;
  //
  localparam int cIBUF_RADDR_W  = $clog2(cBUF_MAX_BIT/cDEC_NUM) ;
  localparam int cIBUF_RDAT_W   = cDEC_NUM*pLLR_W ;
  //
  localparam int cIBUF_TAG_W    = $bits(ixmode) + $bits(iymode) + $bits(ismode) + pTAG_W + 4; // + Niter

  //
  localparam int cOBUF_WADDR_W  = $clog2(cBUF_MAX_BIT/cDEC_NUM);
  localparam int cOBUF_WDAT_W   = cDEC_NUM ;
  //
  localparam int cOBUF_RADDR_W  = $clog2(cBUF_MAX_BIT) ;
  localparam int cOBUF_RDAT_W   = 1 ;
  //
  localparam int cOBUF_TAG_W    = $bits(ixmode) + $bits(iymode) + $bits(ismode) + pTAG_W + pERR_W + 1; // + decfail

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                       source__isop    ;
  logic                       source__ieop    ;
  logic                       source__ival    ;
  logic        [pLLR_W-1 : 0] source__iLLR    ;

  logic                       source__ifulla  ;
  logic                       source__iemptya ;
  //
  logic                       source__owrite  ;
  logic                       source__owfull  ;
  logic [cIBUF_WADDR_W-1 : 0] source__owaddr  ;
  logic  [cIBUF_WDAT_W-1 : 0] source__owLLR   ;

  //
  // ibuffer
  logic                       ibuffer__iwrite  ;
  logic                       ibuffer__iwfull  ;
  logic [cIBUF_WADDR_W-1 : 0] ibuffer__iwaddr  ;
  logic  [cIBUF_WDAT_W-1 : 0] ibuffer__iwdat   ;
  logic   [cIBUF_TAG_W-1 : 0] ibuffer__iwtag   ;
  //
  logic                       ibuffer__owempty  ;
  logic                       ibuffer__owemptya ;
  logic                       ibuffer__owfull   ;
  logic                       ibuffer__owfulla  ;
  //
  logic                       ibuffer__irempty ;
  logic [cIBUF_RADDR_W-1 : 0] ibuffer__iraddr  ;
  logic  [cIBUF_RDAT_W-1 : 0] ibuffer__ordat   ;
  logic   [cIBUF_TAG_W-1 : 0] ibuffer__ortag   ;
  //
  logic                       ibuffer__orempty  ;
  logic                       ibuffer__oremptya ;
  logic                       ibuffer__orfull   ;
  logic                       ibuffer__orfulla  ;

  //
  // engine
  btc_code_mode_t             engine__ixmode                 ;
  btc_code_mode_t             engine__iymode                 ;
  btc_short_mode_t            engine__ismode                 ;
  logic               [3 : 0] engine__iNiter                 ;
  //
  logic                       engine__irbuf_full             ;
  logic        [pLLR_W-1 : 0] engine__irLLR       [cDEC_NUM] ;
  logic        [pTAG_W-1 : 0] engine__irtag                  ;
  logic                       engine__orempty                ;
  logic [cIBUF_RADDR_W-1 : 0] engine__oraddr                 ;
  //
  logic                       engine__iwbuf_empty            ;
  //
  logic                       engine__owrite                 ;
  logic                       engine__owfull                 ;
  logic [cOBUF_WADDR_W-1 : 0] engine__owaddr                 ;
  logic      [cDEC_NUM-1 : 0] engine__owdat                  ;
  logic        [pTAG_W-1 : 0] engine__owtag                  ;
  logic        [pERR_W-1 : 0] engine__owerr                  ;
  logic                       engine__owdecfail              ;
  //
  btc_code_mode_t             engine__oxmode                 ;
  btc_code_mode_t             engine__oymode                 ;
  btc_short_mode_t            engine__osmode                 ;

  //
  // obuffer
  logic                       obuffer__iwrite   ;
  logic                       obuffer__iwfull   ;
  logic [cOBUF_WADDR_W-1 : 0] obuffer__iwaddr   ;
  logic  [cOBUF_WDAT_W-1 : 0] obuffer__iwdat    ;
  logic   [cOBUF_TAG_W-1 : 0] obuffer__iwtag    ;
  //
  logic                       obuffer__owempty  ;
  logic                       obuffer__owemptya ;
  logic                       obuffer__owfull   ;
  logic                       obuffer__owfulla  ;
  //
  logic                       obuffer__irempty  ;
  logic [cOBUF_RADDR_W-1 : 0] obuffer__iraddr   ;
  logic  [cOBUF_RDAT_W-1 : 0] obuffer__ordat    ;
  logic   [cOBUF_TAG_W-1 : 0] obuffer__ortag    ;
  //
  logic                       obuffer__orempty  ;
  logic                       obuffer__oremptya ;
  logic                       obuffer__orfull   ;
  logic                       obuffer__orfulla  ;

  //
  // sink
  btc_code_mode_t             sink__ixmode    ;
  btc_code_mode_t             sink__iymode    ;
  btc_short_mode_t            sink__ismode    ;
  //
  logic                       sink__irfull    ;
  logic  [cOBUF_RDAT_W-1 : 0] sink__irdat     ;
  logic        [pTAG_W-1 : 0] sink__irtag     ;
  //
  logic        [pERR_W-1 : 0] sink__irerr     ;
  logic                       sink__irdecfail ;
  //
  logic                       sink__orempty   ;
  logic [cOBUF_RADDR_W-1 : 0] sink__oraddr    ;

  //------------------------------------------------------------------------------------------------------
  // reset CDC for all clocks
  //------------------------------------------------------------------------------------------------------

  logic clk_reset;
  logic clkin_reset;
  logic clkout_reset;

  codec_reset_synchronizer
  clk_reset_sync
  (
    .clk ( iclk ),    .reset_carry_in ( 1'b0      ) , .reset_in ( ireset ) , .reset_out  ( clk_reset )
  );

  codec_reset_synchronizer
  clkin_reset_sync
  (
    .clk ( iclkin ),  .reset_carry_in ( clk_reset ) , .reset_in ( ireset ) , .reset_out  ( clkin_reset )
  );

  codec_reset_synchronizer
  clkout_reset_sync
  (
    .clk ( iclkout ), .reset_carry_in ( clk_reset ) , .reset_in ( ireset ) , .reset_out  ( clkout_reset )
  );

  //------------------------------------------------------------------------------------------------------
  // input source
  //------------------------------------------------------------------------------------------------------

  btc_dec_source
  #(
    .pLLR_W   ( pLLR_W        ) ,
    .pWADDR_W ( cIBUF_WADDR_W )
  )
  source
  (
    .iclk    ( iclkin          ) ,
    .ireset  ( clkin_reset     ) ,
    .iclkena ( 1'b1            ) ,
    //
    .ixmode  ( ixmode          ) ,
    .iymode  ( iymode          ) ,
    .ismode  ( ismode          ) ,
    //
    .ival    ( source__ival    ) ,
    .isop    ( source__isop    ) ,
    .ieop    ( source__ieop    ) ,
    .iLLR    ( source__iLLR    ) ,
    //
    .ordy    ( ordy            ) ,
    .obusy   ( obusy           ) ,
    //
    .ifulla  ( source__ifulla  ) ,
    .iemptya ( source__iemptya ) ,
    //
    .owrite  ( source__owrite  ) ,
    .owfull  ( source__owfull  ) ,
    .owaddr  ( source__owaddr  ) ,
    .owLLR   ( source__owLLR   )
  );

  assign source__isop     = isop;
  assign source__ieop     = ieop;
  assign source__ival     = ival & ordy;
  assign source__iLLR     = iLLR;

  assign source__ifulla   = ibuffer__owfulla  ;
  assign source__iemptya  = ibuffer__owemptya ;

  //------------------------------------------------------------------------------------------------------
  // input buffer LLR -> 8 * LLR
  //------------------------------------------------------------------------------------------------------

  codec_abuffer_dwc
  #(
    .pWADDR_W ( cIBUF_WADDR_W ) ,
    .pWDAT_W  ( cIBUF_WDAT_W  ) ,
    //
    .pRADDR_W ( cIBUF_RADDR_W ) ,
    .pRDAT_W  ( cIBUF_RDAT_W  ) ,
    //
    .pTAG_W   ( cIBUF_TAG_W   ) ,
    .pBNUM_W  ( 1             ) ,
    //
    .pPIPE    ( 1             )
  )
  ibuffer
  (
    .iwclk    ( iclkin            ) ,
    .iwreset  ( clkin_reset       ) ,
    //
    .iwrite   ( ibuffer__iwrite   ) ,
    .iwfull   ( ibuffer__iwfull   ) ,
    .iwaddr   ( ibuffer__iwaddr   ) ,
    .iwdat    ( ibuffer__iwdat    ) ,
    .iwtag    ( ibuffer__iwtag    ) ,
    //
    .owempty  ( ibuffer__owempty  ) ,
    .owemptya ( ibuffer__owemptya ) ,
    .owfull   ( ibuffer__owfull   ) ,
    .owfulla  ( ibuffer__owfulla  ) ,
    //
    .irclk    ( iclk              ) ,
    .irreset  ( clk_reset         ) ,
    //
    .irempty  ( ibuffer__irempty  ) ,
    .iraddr   ( ibuffer__iraddr   ) ,
    .ordat    ( ibuffer__ordat    ) ,
    .ortag    ( ibuffer__ortag    ) ,
    //
    .orempty  ( ibuffer__orempty  ) ,
    .oremptya ( ibuffer__oremptya ) ,
    .orfull   ( ibuffer__orfull   ) ,
    .orfulla  ( ibuffer__orfulla  )
  );

  assign ibuffer__iwrite = source__owrite;
  assign ibuffer__iwfull = source__owfull;
  assign ibuffer__iwaddr = source__owaddr;
  assign ibuffer__iwdat  = source__owLLR;

  always_ff @(posedge iclkin) begin
    if (ival & isop) begin
      ibuffer__iwtag <= {ixmode, iymode, ismode, iNiter, itag};
    end
  end

  assign ibuffer__irempty = engine__orempty;
  assign ibuffer__iraddr  = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // engine
  //------------------------------------------------------------------------------------------------------

  btc_dec_engine
  #(
    .pLLR_W   ( pLLR_W        ) ,
    .pEXTR_W  ( pEXTR_W       ) ,
    //
    .pADDR_W  ( cIBUF_RADDR_W ) ,
    //
    .pDEC_NUM ( cDEC_NUM      ) ,
    //
    .pERR_W   ( pERR_W        ) ,
    .pTAG_W   ( pTAG_W        )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( 1'b1                ) ,
    //
    .ixmode      ( engine__ixmode      ) ,
    .iymode      ( engine__iymode      ) ,
    .ismode      ( engine__ismode      ) ,
    .iNiter      ( engine__iNiter      ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .irLLR       ( engine__irLLR       ) ,
    .irtag       ( engine__irtag       ) ,
    .orempty     ( engine__orempty     ) ,
    .oraddr      ( engine__oraddr      ) ,
    //
    .iwbuf_empty ( engine__iwbuf_empty ) ,
    //
    .owrite      ( engine__owrite      ) ,
    .owfull      ( engine__owfull      ) ,
    .owaddr      ( engine__owaddr      ) ,
    .owdat       ( engine__owdat       ) ,
    .owtag       ( engine__owtag       ) ,
    .owerr       ( engine__owerr       ) ,
    .owdecfail   ( engine__owdecfail   ) ,
    //
    .oxmode      ( engine__oxmode      ) ,
    .oymode      ( engine__oymode      ) ,
    .osmode      ( engine__osmode      )
  );

  assign engine__irbuf_full  = ibuffer__orfull;

  assign {engine__ixmode,
          engine__iymode,
          engine__ismode,
          engine__iNiter,
          engine__irtag} = ibuffer__ortag;

  always_comb begin
    for (int i = 0; i < cDEC_NUM; i++) begin
      engine__irLLR[i] = ibuffer__ordat[i*pLLR_W +: pLLR_W];
    end
  end

  assign engine__iwbuf_empty = obuffer__owempty;

  //------------------------------------------------------------------------------------------------------
  // output buffer 8 -> 1
  //------------------------------------------------------------------------------------------------------

  codec_abuffer_dwc
  #(
    .pWADDR_W ( cOBUF_WADDR_W ) ,
    .pWDAT_W  ( cOBUF_WDAT_W  ) ,
    //
    .pRADDR_W ( cOBUF_RADDR_W ) ,
    .pRDAT_W  ( cOBUF_RDAT_W  ) ,
    //
    .pTAG_W   ( cOBUF_TAG_W   ) ,
    .pBNUM_W  ( 1             ) ,
    //
    .pPIPE    ( 1             )
  )
  obuffer
  (
    .iwclk    ( iclk              ) ,
    .iwreset  ( clk_reset         ) ,
    //
    .iwrite   ( obuffer__iwrite   ) ,
    .iwfull   ( obuffer__iwfull   ) ,
    .iwaddr   ( obuffer__iwaddr   ) ,
    .iwdat    ( obuffer__iwdat    ) ,
    .iwtag    ( obuffer__iwtag    ) ,
    //
    .owempty  ( obuffer__owempty  ) ,
    .owemptya ( obuffer__owemptya ) ,
    .owfull   ( obuffer__owfull   ) ,
    .owfulla  ( obuffer__owfulla  ) ,
    //
    .irclk    ( iclkout           ) ,
    .irreset  ( clkout_reset      ) ,
    //
    .irempty  ( obuffer__irempty  ) ,
    .iraddr   ( obuffer__iraddr   ) ,
    .ordat    ( obuffer__ordat    ) ,
    .ortag    ( obuffer__ortag    ) ,
    //
    .orempty  ( obuffer__orempty  ) ,
    .oremptya ( obuffer__oremptya ) ,
    .orfull   ( obuffer__orfull   ) ,
    .orfulla  ( obuffer__orfulla  )
  );

  assign obuffer__irempty = sink__orempty;
  assign obuffer__iraddr  = sink__oraddr;

  assign obuffer__iwrite  = engine__owrite;
  assign obuffer__iwfull  = engine__owfull;
  assign obuffer__iwaddr  = engine__owaddr;
  assign obuffer__iwdat   = engine__owdat;

  assign obuffer__iwtag   = { engine__oxmode    ,
                              engine__oymode    ,
                              engine__osmode    ,
                              engine__owdecfail ,
                              engine__owerr     ,
                              engine__owtag};

  //------------------------------------------------------------------------------------------------------
  // sink
  //------------------------------------------------------------------------------------------------------

  btc_dec_sink
  #(
    .pRDAT_W  ( cOBUF_RDAT_W  ) ,
    .pRADDR_W ( cOBUF_RADDR_W ) ,
    //
    .pTAG_W   ( pTAG_W        ) ,
    //
    .pERR_W   ( pERR_W        )
  )
  sink
  (
    .iclk      ( iclkout         ) ,
    .ireset    ( clkout_reset    ) ,
    .iclkena   ( 1'b1            ) ,
    //
    .ixmode    ( sink__ixmode    ) ,
    .iymode    ( sink__iymode    ) ,
    .ismode    ( sink__ismode    ) ,
    //
    .irfull    ( sink__irfull    ) ,
    .irdat     ( sink__irdat     ) ,
    .irtag     ( sink__irtag     ) ,
    //
    .irerr     ( sink__irerr     ) ,
    .irdecfail ( sink__irdecfail ) ,
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
    .onum      ( onum            )
  );

  assign sink__irfull = obuffer__orfull;
  assign sink__irdat  = obuffer__ordat;

  assign {sink__ixmode    ,
          sink__iymode    ,
          sink__ismode    ,
          sink__irdecfail ,
          sink__irerr     ,
          sink__irtag     } = obuffer__ortag;

endmodule
