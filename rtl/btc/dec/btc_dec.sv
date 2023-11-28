/*



  parameter int pLLR_W  =  8 ;
  parameter int pEXTR_W =  8 ;
  parameter int pERR_W  = 16 ;
  parameter int pTAG_W  =  8 ;
  parameter int pDB_NUM =  1 ;



  logic                           btc_dec__iclk     ;
  logic                           btc_dec__ireset   ;
  //
  btc_code_mode_t                 btc_dec__ixmode   ;
  btc_code_mode_t                 btc_dec__iymode   ;
  btc_short_mode_t                btc_dec__ismode   ;
  logic                   [3 : 0] btc_dec__iNiter   ;
  logic                           btc_dec__ifmode   ;
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
    .pTAG_W  ( pTAG_W  ) ,
    .pDB_NUM ( pDB_NUM )
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
    .ifmode   ( btc_dec__ifmode   ) ,
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
  assign btc_dec__ifmode  = '0 ;
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
  ifmode   ,
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

  parameter int pERR_W  = 16 ;
  parameter int pTAG_W  =  8 ;
  parameter int pDB_NUM =  1 ;   // decoder block number

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
  input  logic                           ifmode   ;
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
  localparam int cIBUF_TAG_W    = $bits(ixmode) + $bits(iymode) + $bits(ismode) + pTAG_W + 4 + 1; // + Niter + fmode

  //
  localparam int cOBUF_WADDR_W  = $clog2(cBUF_MAX_BIT/cDEC_NUM);
  localparam int cOBUF_WDAT_W   = cDEC_NUM ;
  //
  localparam int cOBUF_RADDR_W  = $clog2(cBUF_MAX_BIT) ;
  localparam int cOBUF_RDAT_W   = 1 ;
  //
  localparam int cOBUF_TAG_W    = $bits(ixmode) + $bits(iymode) + $bits(ismode) + pTAG_W + 2*pERR_W + 1; // + decfail

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                       source__isop              ;
  logic                       source__ieop              ;
  logic                       source__ival              ;
  logic        [pLLR_W-1 : 0] source__iLLR              ;

  logic                       source__ifulla  [pDB_NUM] ;
  logic                       source__iemptya [pDB_NUM] ;
  //
  logic                       source__owrite  [pDB_NUM] ;
  logic                       source__owfull  [pDB_NUM] ;
  logic [cIBUF_WADDR_W-1 : 0] source__owaddr            ;
  logic  [cIBUF_WDAT_W-1 : 0] source__owLLR             ;

  //
  // ibuffer
  logic                       ibuffer__iwrite   [pDB_NUM] ;
  logic                       ibuffer__iwfull   [pDB_NUM] ;
  logic [cIBUF_WADDR_W-1 : 0] ibuffer__iwaddr   [pDB_NUM] ;
  logic  [cIBUF_WDAT_W-1 : 0] ibuffer__iwdat    [pDB_NUM] ;
  logic   [cIBUF_TAG_W-1 : 0] ibuffer__iwtag    [pDB_NUM] ;
  //
  logic                       ibuffer__owempty  [pDB_NUM] ;
  logic                       ibuffer__owemptya [pDB_NUM] ;
  logic                       ibuffer__owfull   [pDB_NUM] ;
  logic                       ibuffer__owfulla  [pDB_NUM] ;
  //
  logic                       ibuffer__irempty  [pDB_NUM] ;
  logic [cIBUF_RADDR_W-1 : 0] ibuffer__iraddr   [pDB_NUM] ;
  logic  [cIBUF_RDAT_W-1 : 0] ibuffer__ordat    [pDB_NUM] ;
  logic   [cIBUF_TAG_W-1 : 0] ibuffer__ortag    [pDB_NUM] ;
  //
  logic                       ibuffer__orempty  [pDB_NUM] ;
  logic                       ibuffer__oremptya [pDB_NUM] ;
  logic                       ibuffer__orfull   [pDB_NUM] ;
  logic                       ibuffer__orfulla  [pDB_NUM] ;

  //
  // engine
  btc_code_mode_t             engine__ixmode      [pDB_NUM]           ;
  btc_code_mode_t             engine__iymode      [pDB_NUM]           ;
  btc_short_mode_t            engine__ismode      [pDB_NUM]           ;
  logic               [3 : 0] engine__iNiter      [pDB_NUM]           ;
  logic                       engine__ifmode      [pDB_NUM]           ;
  //
  logic                       engine__irbuf_full  [pDB_NUM]           ;
  logic        [pLLR_W-1 : 0] engine__irLLR       [pDB_NUM][cDEC_NUM] ;
  logic        [pTAG_W-1 : 0] engine__irtag       [pDB_NUM]           ;
  logic                       engine__orempty     [pDB_NUM]           ;
  logic [cIBUF_RADDR_W-1 : 0] engine__oraddr      [pDB_NUM]           ;
  //
  logic                       engine__iwbuf_empty [pDB_NUM]           ;
  //
  logic                       engine__owrite      [pDB_NUM]           ;
  logic                       engine__owfull      [pDB_NUM]           ;
  logic [cOBUF_WADDR_W-1 : 0] engine__owaddr      [pDB_NUM]           ;
  logic      [cDEC_NUM-1 : 0] engine__owdat       [pDB_NUM]           ;
  logic        [pTAG_W-1 : 0] engine__owtag       [pDB_NUM]           ;
  logic        [pERR_W-1 : 0] engine__owerr       [pDB_NUM]           ;
  logic        [pERR_W-1 : 0] engine__owerr_num   [pDB_NUM]           ;
  logic                       engine__owdecfail   [pDB_NUM]           ;
  //
  btc_code_mode_t             engine__oxmode      [pDB_NUM]           ;
  btc_code_mode_t             engine__oymode      [pDB_NUM]           ;
  btc_short_mode_t            engine__osmode      [pDB_NUM]           ;

  //
  // obuffer
  logic                       obuffer__iwrite   [pDB_NUM] ;
  logic                       obuffer__iwfull   [pDB_NUM] ;
  logic [cOBUF_WADDR_W-1 : 0] obuffer__iwaddr   [pDB_NUM] ;
  logic  [cOBUF_WDAT_W-1 : 0] obuffer__iwdat    [pDB_NUM] ;
  logic   [cOBUF_TAG_W-1 : 0] obuffer__iwtag    [pDB_NUM] ;
  //
  logic                       obuffer__owempty  [pDB_NUM] ;
  logic                       obuffer__owemptya [pDB_NUM] ;
  logic                       obuffer__owfull   [pDB_NUM] ;
  logic                       obuffer__owfulla  [pDB_NUM] ;
  //
  logic                       obuffer__irempty  [pDB_NUM] ;
  logic [cOBUF_RADDR_W-1 : 0] obuffer__iraddr   [pDB_NUM] ;
  logic  [cOBUF_RDAT_W-1 : 0] obuffer__ordat    [pDB_NUM] ;
  logic   [cOBUF_TAG_W-1 : 0] obuffer__ortag    [pDB_NUM] ;
  //
  logic                       obuffer__orempty  [pDB_NUM] ;
  logic                       obuffer__oremptya [pDB_NUM] ;
  logic                       obuffer__orfull   [pDB_NUM] ;
  logic                       obuffer__orfulla  [pDB_NUM] ;

  //
  // sink
  btc_code_mode_t             sink__ixmode    [pDB_NUM] ;
  btc_code_mode_t             sink__iymode    [pDB_NUM] ;
  btc_short_mode_t            sink__ismode    [pDB_NUM] ;
  //
  logic                       sink__irfull    [pDB_NUM] ;
  logic  [cOBUF_RDAT_W-1 : 0] sink__irdat     [pDB_NUM] ;
  logic        [pTAG_W-1 : 0] sink__irtag     [pDB_NUM] ;
  //
  logic        [pERR_W-1 : 0] sink__irerr     [pDB_NUM] ;
  logic        [pERR_W-1 : 0] sink__irerr_num [pDB_NUM] ;
  logic                       sink__irdecfail [pDB_NUM] ;
  //
  logic                       sink__orempty   [pDB_NUM] ;
  logic [cOBUF_RADDR_W-1 : 0] sink__oraddr              ;

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
    .pWADDR_W ( cIBUF_WADDR_W ) ,
    .pDB_NUM  ( pDB_NUM       )
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
  //
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < pDB_NUM; g++) begin : dec_block_inst
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
        .iwclk    ( iclkin                ) ,
        .iwreset  ( clkin_reset           ) ,
        //
        .iwrite   ( ibuffer__iwrite   [g] ) ,
        .iwfull   ( ibuffer__iwfull   [g] ) ,
        .iwaddr   ( ibuffer__iwaddr   [g] ) ,
        .iwdat    ( ibuffer__iwdat    [g] ) ,
        .iwtag    ( ibuffer__iwtag    [g] ) ,
        //
        .owempty  ( ibuffer__owempty  [g] ) ,
        .owemptya ( ibuffer__owemptya [g] ) ,
        .owfull   ( ibuffer__owfull   [g] ) ,
        .owfulla  ( ibuffer__owfulla  [g] ) ,
        //
        .irclk    ( iclk                  ) ,
        .irreset  ( clk_reset             ) ,
        //
        .irempty  ( ibuffer__irempty  [g] ) ,
        .iraddr   ( ibuffer__iraddr   [g] ) ,
        .ordat    ( ibuffer__ordat    [g] ) ,
        .ortag    ( ibuffer__ortag    [g] ) ,
        //
        .orempty  ( ibuffer__orempty  [g] ) ,
        .oremptya ( ibuffer__oremptya [g] ) ,
        .orfull   ( ibuffer__orfull   [g] ) ,
        .orfulla  ( ibuffer__orfulla  [g] )
      );

      assign ibuffer__iwrite [g] = source__owrite [g];
      assign ibuffer__iwfull [g] = source__owfull [g];
      assign ibuffer__iwaddr [g] = source__owaddr;
      assign ibuffer__iwdat  [g] = source__owLLR;

      always_ff @(posedge iclkin) begin
        if (ival & isop) begin
          ibuffer__iwtag [g] <= {ixmode, iymode, ismode, iNiter, ifmode, itag};
        end
      end

      assign ibuffer__irempty [g] = engine__orempty [g];
      assign ibuffer__iraddr  [g] = engine__oraddr  [g];

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
        .iclk        ( iclk                    ) ,
        .ireset      ( ireset                  ) ,
        .iclkena     ( 1'b1                    ) ,
        //
        .ixmode      ( engine__ixmode      [g] ) ,
        .iymode      ( engine__iymode      [g] ) ,
        .ismode      ( engine__ismode      [g] ) ,
        .iNiter      ( engine__iNiter      [g] ) ,
        .ifmode      ( engine__ifmode      [g] ) ,
        //
        .irbuf_full  ( engine__irbuf_full  [g] ) ,
        .irLLR       ( engine__irLLR       [g] ) ,
        .irtag       ( engine__irtag       [g] ) ,
        .orempty     ( engine__orempty     [g] ) ,
        .oraddr      ( engine__oraddr      [g] ) ,
        //
        .iwbuf_empty ( engine__iwbuf_empty [g] ) ,
        //
        .owrite      ( engine__owrite      [g] ) ,
        .owfull      ( engine__owfull      [g] ) ,
        .owaddr      ( engine__owaddr      [g] ) ,
        .owdat       ( engine__owdat       [g] ) ,
        .owtag       ( engine__owtag       [g] ) ,
        .owerr       ( engine__owerr       [g] ) ,
        .owerr_num   ( engine__owerr_num   [g] ) ,
        .owdecfail   ( engine__owdecfail   [g] ) ,
        //
        .oxmode      ( engine__oxmode      [g] ) ,
        .oymode      ( engine__oymode      [g] ) ,
        .osmode      ( engine__osmode      [g] )
      );

      assign engine__irbuf_full [g] = ibuffer__orfull [g];

      assign {engine__ixmode [g],
              engine__iymode [g],
              engine__ismode [g],
              engine__iNiter [g],
              engine__ifmode [g],
              engine__irtag  [g]} = ibuffer__ortag [g];

      always_comb begin
        for (int i = 0; i < cDEC_NUM; i++) begin
          engine__irLLR [g][i] = ibuffer__ordat [g][i*pLLR_W +: pLLR_W];
        end
      end

      assign engine__iwbuf_empty [g] = obuffer__owempty [g];

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
        .iwclk    ( iclk                  ) ,
        .iwreset  ( clk_reset             ) ,
        //
        .iwrite   ( obuffer__iwrite   [g] ) ,
        .iwfull   ( obuffer__iwfull   [g] ) ,
        .iwaddr   ( obuffer__iwaddr   [g] ) ,
        .iwdat    ( obuffer__iwdat    [g] ) ,
        .iwtag    ( obuffer__iwtag    [g] ) ,
        //
        .owempty  ( obuffer__owempty  [g] ) ,
        .owemptya ( obuffer__owemptya [g] ) ,
        .owfull   ( obuffer__owfull   [g] ) ,
        .owfulla  ( obuffer__owfulla  [g] ) ,
        //
        .irclk    ( iclkout               ) ,
        .irreset  ( clkout_reset          ) ,
        //
        .irempty  ( obuffer__irempty  [g] ) ,
        .iraddr   ( obuffer__iraddr   [g] ) ,
        .ordat    ( obuffer__ordat    [g] ) ,
        .ortag    ( obuffer__ortag    [g] ) ,
        //
        .orempty  ( obuffer__orempty  [g] ) ,
        .oremptya ( obuffer__oremptya [g] ) ,
        .orfull   ( obuffer__orfull   [g] ) ,
        .orfulla  ( obuffer__orfulla  [g] )
      );

      assign obuffer__irempty [g] = sink__orempty [g];
      assign obuffer__iraddr  [g] = sink__oraddr  ;

      assign obuffer__iwrite  [g] = engine__owrite [g];
      assign obuffer__iwfull  [g] = engine__owfull [g];
      assign obuffer__iwaddr  [g] = engine__owaddr [g];
      assign obuffer__iwdat   [g] = engine__owdat  [g];

      assign obuffer__iwtag   [g] = { engine__oxmode    [g],
                                      engine__oymode    [g],
                                      engine__osmode    [g],
                                      engine__owdecfail [g],
                                      engine__owerr     [g],
                                      engine__owerr_num [g],
                                      engine__owtag     [g]};
    end
  endgenerate

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
    .pERR_W   ( pERR_W        ) ,
    //
    .pDB_NUM  ( pDB_NUM       )
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
    .irerr_num ( sink__irerr_num ) ,
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

  always_comb begin
    for (int i = 0; i < pDB_NUM; i++) begin
     {sink__ixmode    [i],
      sink__iymode    [i],
      sink__ismode    [i],
      sink__irdecfail [i],
      sink__irerr     [i],
      sink__irerr_num [i],
      sink__irtag     [i]} = obuffer__ortag [i];
    end
  end
endmodule
