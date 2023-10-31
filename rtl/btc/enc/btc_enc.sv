/*



  parameter int pTAG_W = 8 ;



  logic                           btc_enc__iclk    ;
  logic                           btc_enc__ireset  ;
  logic                           btc_enc__iclkena ;
  //
  btc_code_mode_t                 btc_enc__ixmode  ;
  btc_code_mode_t                 btc_enc__iymode  ;
  btc_short_mode_t                btc_enc__ismode  ;
  //
  logic                           btc_enc__ival    ;
  logic                           btc_enc__isop    ;
  logic                           btc_enc__ieop    ;
  logic                           btc_enc__idat    ;
  logic            [pTAG_W-1 : 0] btc_enc__itag    ;
  //
  logic                           btc_enc__ordy    ;
  logic                           btc_enc__obusy   ;
  //
  logic                           btc_enc__ireq    ;
  logic                           btc_enc__ofull   ;
  //
  logic                           btc_enc__oval    ;
  logic                           btc_enc__osop    ;
  logic                           btc_enc__oeop    ;
  logic                           btc_enc__odat    ;
  logic            [pTAG_W-1 : 0] btc_enc__otag    ;



  btc_enc
  #(
    .pTAG_W ( pTAG_W )
  )
  btc_enc
  (
    .iclk    ( btc_enc__iclk    ) ,
    .ireset  ( btc_enc__ireset  ) ,
    .iclkena ( btc_enc__iclkena ) ,
    //
    .ixmode  ( btc_enc__ixmode  ) ,
    .iymode  ( btc_enc__iymode  ) ,
    .ismode  ( btc_enc__ismode  ) ,
    //
    .ival    ( btc_enc__ival    ) ,
    .isop    ( btc_enc__isop    ) ,
    .ieop    ( btc_enc__ieop    ) ,
    .idat    ( btc_enc__idat    ) ,
    .itag    ( btc_enc__itag    ) ,
    //
    .ordy    ( btc_enc__ordy    ) ,
    .obusy   ( btc_enc__obusy   ) ,
    //
    .ireq    ( btc_enc__ireq    ) ,
    .ofull   ( btc_enc__ofull   ) ,
    //
    .oval    ( btc_enc__oval    ) ,
    .osop    ( btc_enc__osop    ) ,
    .oeop    ( btc_enc__oeop    ) ,
    .odat    ( btc_enc__odat    ) ,
    .otag    ( btc_enc__otag    )
  );


  assign btc_enc__iclk    = '0 ;
  assign btc_enc__ireset  = '0 ;
  assign btc_enc__iclkena = '0 ;
  assign btc_enc__ixmode  = '0 ;
  assign btc_enc__iymode  = '0 ;
  assign btc_enc__ismode  = '0 ;
  assign btc_enc__ival    = '0 ;
  assign btc_enc__isop    = '0 ;
  assign btc_enc__ieop    = '0 ;
  assign btc_enc__idat    = '0 ;
  assign btc_enc__itag    = '0 ;
  assign btc_enc__ireq    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_enc.sv
// Description   : wimax 802.16-2012 BTC encoder top module
//

module btc_enc
#(
  parameter int pTAG_W = 8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ixmode  ,
  iymode  ,
  ismode  ,
  //
  ival    ,
  isop    ,
  ieop    ,
  idat    ,
  itag    ,
  //
  ordy    ,
  obusy   ,
  //
  ireq    ,
  ofull   ,
  //
  oval    ,
  osop    ,
  oeop    ,
  odat    ,
  otag
);

  `include "../btc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                           iclk    ;
  input  logic                           ireset  ;
  input  logic                           iclkena ;
  //
  input  btc_code_mode_t                 ixmode  ;
  input  btc_code_mode_t                 iymode  ;
  input  btc_short_mode_t                ismode  ;
  //
  input  logic                           ival    ;
  input  logic                           isop    ;
  input  logic                           ieop    ;
  input  logic                           idat    ;
  input  logic            [pTAG_W-1 : 0] itag    ;
  //
  output logic                           ordy    ;
  output logic                           obusy   ;
  //
  input  logic                           ireq    ;
  output logic                           ofull   ;
  //
  output logic                           oval    ;
  output logic                           osop    ;
  output logic                           oeop    ;
  output logic                           odat    ;
  output logic            [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBUF_MAX_BIT   = cROW_MAX * cCOL_MAX;

  //
  localparam int cIBUF_WADDR_W  = $clog2(cBUF_MAX_BIT);
  localparam int cIBUF_WDAT_W   = 1 ;
  //
  localparam int cIBUF_RADDR_W  = $clog2(cBUF_MAX_BIT/8) ;
  localparam int cIBUF_RDAT_W   = 8 ;
  //
  localparam int cIBUF_TAG_W    = $bits(ixmode) + $bits(iymode) + $bits(ismode) + pTAG_W;

  //
  localparam int cOBUF_WADDR_W  = $clog2(cBUF_MAX_BIT/8);
  localparam int cOBUF_WDAT_W   = 8 ;
  //
  localparam int cOBUF_RADDR_W  = $clog2(cBUF_MAX_BIT) ;
  localparam int cOBUF_RDAT_W   = 1 ;
  //
  localparam int cOBUF_TAG_W    = $bits(ixmode) + $bits(iymode) + $bits(ismode) + pTAG_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                       source__isop    ;
  logic                       source__ieop    ;
  logic                       source__ival    ;
  logic                       source__idat    ;

  logic                       source__ifulla  ;
  logic                       source__iemptya ;
  //
  logic                       source__owrite  ;
  logic                       source__owfull  ;
  logic [cIBUF_WADDR_W-1 : 0] source__owaddr  ;
  logic  [cIBUF_WDAT_W-1 : 0] source__owdat   ;

  //
  // ibuffer
  logic                       ibuffer__iwrite  ;
  logic                       ibuffer__iwfull  ;
  logic [cIBUF_WADDR_W-1 : 0] ibuffer__iwaddr  ;
  logic  [cIBUF_WDAT_W-1 : 0] ibuffer__iwdat   ;
  logic   [cIBUF_TAG_W-1 : 0] ibuffer__iwtag   ;
  //
  logic                       ibuffer__irempty ;
  logic [cIBUF_RADDR_W-1 : 0] ibuffer__iraddr  ;
  logic  [cIBUF_RDAT_W-1 : 0] ibuffer__ordat   ;
  logic   [cIBUF_TAG_W-1 : 0] ibuffer__ortag   ;
  //
  logic                       ibuffer__oempty  ;
  logic                       ibuffer__oemptya ;
  logic                       ibuffer__ofull   ;
  logic                       ibuffer__ofulla  ;

  //
  // engine
  btc_code_mode_t             engine__ixmode      ;
  btc_code_mode_t             engine__iymode      ;
  btc_short_mode_t            engine__ismode      ;
  //
  logic                       engine__irbuf_full  ;
  logic  [cIBUF_RDAT_W-1 : 0] engine__irdat       ;
  logic        [pTAG_W-1 : 0] engine__irtag       ;
  logic                       engine__oread       ;
  logic                       engine__orempty     ;
  logic [cIBUF_RADDR_W-1 : 0] engine__oraddr      ;
  //
  logic                       engine__iwbuf_empty ;
  //
  logic                       engine__owrite      ;
  logic                       engine__owfull      ;
  logic [cIBUF_RADDR_W-1 : 0] engine__owaddr      ;
  logic  [cIBUF_RDAT_W-1 : 0] engine__owdat       ;
  logic        [pTAG_W-1 : 0] engine__owtag       ;
  //
  btc_code_mode_t             engine__oxmode      ;
  btc_code_mode_t             engine__oymode      ;
  btc_short_mode_t            engine__osmode      ;

  //
  // obuffer
  logic                       obuffer__iwrite  ;
  logic                       obuffer__iwfull  ;
  logic [cOBUF_WADDR_W-1 : 0] obuffer__iwaddr  ;
  logic  [cOBUF_WDAT_W-1 : 0] obuffer__iwdat   ;
  logic   [cOBUF_TAG_W-1 : 0] obuffer__iwtag   ;
  //
  logic                       obuffer__irempty ;
  logic [cOBUF_RADDR_W-1 : 0] obuffer__iraddr  ;
  logic  [cOBUF_RDAT_W-1 : 0] obuffer__ordat   ;
  logic   [cOBUF_TAG_W-1 : 0] obuffer__ortag   ;
  //
  logic                       obuffer__oempty  ;
  logic                       obuffer__oemptya ;
  logic                       obuffer__ofull   ;
  logic                       obuffer__ofulla  ;

  //
  // sink
  btc_code_mode_t             sink__ixmode  ;
  btc_code_mode_t             sink__iymode  ;
  btc_short_mode_t            sink__ismode  ;
  //
  logic                       sink__irfull  ;
  logic  [cOBUF_RDAT_W-1 : 0] sink__irdat   ;
  logic        [pTAG_W-1 : 0] sink__irtag   ;
  logic                       sink__oread   ;
  logic                       sink__orempty ;
  logic [cOBUF_RADDR_W-1 : 0] sink__oraddr  ;

  //------------------------------------------------------------------------------------------------------
  // source unint
  //------------------------------------------------------------------------------------------------------

  btc_enc_source
  #(
    .pWDAT_W  ( cIBUF_WDAT_W  ) ,
    .pWADDR_W ( cIBUF_WADDR_W )
  )
  source
  (
    .iclk    ( iclk            ) ,
    .ireset  ( ireset          ) ,
    .iclkena ( iclkena         ) ,
    //
    .ixmode  ( ixmode          ) ,
    .iymode  ( iymode          ) ,
    .ismode  ( ismode          ) ,
    //
    .ival    ( source__ival    ) ,
    .isop    ( source__isop    ) ,
    .ieop    ( source__ieop    ) ,
    .idat    ( source__idat    ) ,
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
    .owdat   ( source__owdat   )
  );

  assign source__isop     = isop;
  assign source__ieop     = ieop;
  assign source__ival     = ival & ordy;
  assign source__idat     = idat;

  assign source__ifulla   = ibuffer__ofulla  ;
  assign source__iemptya  = ibuffer__oemptya ;

  //------------------------------------------------------------------------------------------------------
  // input buffer 1 -> 8
  //------------------------------------------------------------------------------------------------------

  codec_buffer_dwc
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
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( ibuffer__iwrite  ) ,
    .iwfull  ( ibuffer__iwfull  ) ,
    .iwaddr  ( ibuffer__iwaddr  ) ,
    .iwdat   ( ibuffer__iwdat   ) ,
    .iwtag   ( ibuffer__iwtag   ) ,
    //
    .irempty ( ibuffer__irempty ) ,
    .iraddr  ( ibuffer__iraddr  ) ,
    .ordat   ( ibuffer__ordat   ) ,
    .ortag   ( ibuffer__ortag   ) ,
    //
    .oempty  ( ibuffer__oempty  ) ,
    .oemptya ( ibuffer__oemptya ) ,
    .ofull   ( ibuffer__ofull   ) ,
    .ofulla  ( ibuffer__ofulla  )
  );

  assign ibuffer__iwrite = source__owrite;
  assign ibuffer__iwfull = source__owfull;
  assign ibuffer__iwaddr = source__owaddr;
  assign ibuffer__iwdat  = source__owdat ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & isop) begin
        ibuffer__iwtag <= {ixmode, iymode, ismode, itag};
      end
    end
  end

  assign ibuffer__irempty = engine__orempty;
  assign ibuffer__iraddr  = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // encoder engine
  //------------------------------------------------------------------------------------------------------

  btc_enc_engine
  #(
    .pDAT_W  ( cIBUF_RDAT_W  ) ,
    .pADDR_W ( cIBUF_RADDR_W ) ,
    .pTAG_W  ( pTAG_W        )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .ixmode      ( engine__ixmode      ) ,
    .iymode      ( engine__iymode      ) ,
    .ismode      ( engine__ismode      ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .irdat       ( engine__irdat       ) ,
    .irtag       ( engine__irtag       ) ,
    //
    .oread       ( engine__oread       ) ,
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
    //
    .oxmode      ( engine__oxmode      ) ,
    .oymode      ( engine__oymode      ) ,
    .osmode      ( engine__osmode      )
  );

  assign {engine__ixmode,
          engine__iymode,
          engine__ismode,
          engine__irtag} = ibuffer__ortag ;

  assign engine__irbuf_full   = ibuffer__ofull;
  assign engine__irdat        = ibuffer__ordat;

  assign engine__iwbuf_empty  = obuffer__oempty;

  //------------------------------------------------------------------------------------------------------
  // output buffer 8 -> 1
  //------------------------------------------------------------------------------------------------------

  codec_buffer_dwc
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
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( obuffer__iwrite  ) ,
    .iwfull  ( obuffer__iwfull  ) ,
    .iwaddr  ( obuffer__iwaddr  ) ,
    .iwdat   ( obuffer__iwdat   ) ,
    .iwtag   ( obuffer__iwtag   ) ,
    //
    .irempty ( obuffer__irempty ) ,
    .iraddr  ( obuffer__iraddr  ) ,
    .ordat   ( obuffer__ordat   ) ,
    .ortag   ( obuffer__ortag   ) ,
    //
    .oempty  ( obuffer__oempty  ) ,
    .oemptya ( obuffer__oemptya ) ,
    .ofull   ( obuffer__ofull   ) ,
    .ofulla  ( obuffer__ofulla  )
  );

  assign obuffer__irempty = sink__orempty;
  assign obuffer__iraddr  = sink__oraddr;

  assign obuffer__iwrite  = engine__owrite;
  assign obuffer__iwfull  = engine__owfull;
  assign obuffer__iwaddr  = engine__owaddr;
  assign obuffer__iwdat   = engine__owdat;

  assign obuffer__iwtag   = { engine__oxmode ,
                              engine__oymode ,
                              engine__osmode ,
                              engine__owtag};

  //------------------------------------------------------------------------------------------------------
  // sink unit
  //------------------------------------------------------------------------------------------------------

  btc_enc_sink
  #(
    .pTAG_W   ( pTAG_W        ) ,
    .pRDAT_W  ( cOBUF_RDAT_W  ) ,
    .pRADDR_W ( cOBUF_RADDR_W )
  )
  sink
  (
    .iclk    ( iclk          ) ,
    .ireset  ( ireset        ) ,
    .iclkena ( iclkena       ) ,
    //
    .ixmode  ( sink__ixmode  ) ,
    .iymode  ( sink__iymode  ) ,
    .ismode  ( sink__ismode  ) ,
    //
    .irfull  ( sink__irfull  ) ,
    .irdat   ( sink__irdat   ) ,
    .irtag   ( sink__irtag   ) ,
    .oread   ( sink__oread   ) ,
    .orempty ( sink__orempty ) ,
    .oraddr  ( sink__oraddr  ) ,
    //
    .ireq    ( ireq          ) ,
    .ofull   ( ofull         ) ,
    //
    .oval    ( oval          ) ,
    .osop    ( osop          ) ,
    .oeop    ( oeop          ) ,
    .odat    ( odat          ) ,
    .otag    ( otag          )
  );

  assign {sink__ixmode,
          sink__iymode,
          sink__ismode,
          sink__irtag} = obuffer__ortag ;

  assign sink__irfull = obuffer__ofull  ;
  assign sink__irdat  = obuffer__ordat  ;

endmodule
