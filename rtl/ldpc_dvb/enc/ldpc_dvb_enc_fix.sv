/*



  parameter int pDAT_W         = 8 ;
  parameter int pTAG_W         = 4 ;
  parameter bit pDO_TRANSPONSE = 0 ;

  parameter bit pCODEGR        = 0 ;
  parameter int pCODERATE      = 9 ;
  parameter bit pXMODE         = 0 ;


  logic                ldpc_dvb_enc__iclk      ;
  logic                ldpc_dvb_enc__ireset    ;
  //
  logic                ldpc_dvb_enc__iclkin    ;
  //
  logic                ldpc_dvb_enc__isop      ;
  logic                ldpc_dvb_enc__ival      ;
  logic                ldpc_dvb_enc__ieop      ;
  logic [pDAT_W-1 : 0] ldpc_dvb_enc__idat      ;
  logic [pTAG_W-1 : 0] ldpc_dvb_enc__itag      ;
  //
  logic                ldpc_dvb_enc__obusy     ;
  logic                ldpc_dvb_enc__ordy      ;
  //
  logic                ldpc_dvb_enc__iclkout   ;
  logic                ldpc_dvb_enc__ireq      ;
  logic                ldpc_dvb_enc__ofull     ;
  //
  logic                ldpc_dvb_enc__osop      ;
  logic                ldpc_dvb_enc__oval      ;
  logic                ldpc_dvb_enc__oeop      ;
  logic [pDAT_W-1 : 0] ldpc_dvb_enc__odat      ;
  logic [pTAG_W-1 : 0] ldpc_dvb_enc__otag      ;



  ldpc_dvb_enc_fix
  #(
    .pDAT_W         ( pDAT_W         ) ,
    .pTAG_W         ( pTAG_W         ) ,
    .pDO_TRANSPONSE ( pDO_TRANSPONSE ) ,
    .pCODEGR        ( pCODEGR        ) ,
    .pCODERATE      ( pCODERATE      ) ,
    .pXMODE         ( pXMODE         )
  )
  ldpc_dvb_enc_fix
  (
    .iclk      ( ldpc_dvb_enc__iclk      ) ,
    .ireset    ( ldpc_dvb_enc__ireset    ) ,
    //
    .iclkin    ( ldpc_dvb_enc__iclkin    ) ,
    //
    .isop      ( ldpc_dvb_enc__isop      ) ,
    .ival      ( ldpc_dvb_enc__ival      ) ,
    .ieop      ( ldpc_dvb_enc__ieop      ) ,
    .idat      ( ldpc_dvb_enc__idat      ) ,
    .itag      ( ldpc_dvb_enc__itag      ) ,
    //
    .obusy     ( ldpc_dvb_enc__obusy     ) ,
    .ordy      ( ldpc_dvb_enc__ordy      ) ,
    //
    .iclkout   ( ldpc_dvb_enc__iclkout   ) ,
    .ireq      ( ldpc_dvb_enc__ireq      ) ,
    .ofull     ( ldpc_dvb_enc__ofull     ) ,
    //
    .osop      ( ldpc_dvb_enc__osop      ) ,
    .oval      ( ldpc_dvb_enc__oval      ) ,
    .oeop      ( ldpc_dvb_enc__oeop      ) ,
    .odat      ( ldpc_dvb_enc__odat      ) ,
    .otag      ( ldpc_dvb_enc__otag      )
  );


  assign ldpc_dvb_enc__iclk      = '0 ;
  assign ldpc_dvb_enc__ireset    = '0 ;
  //
  assign ldpc_dvb_enc__iclkin    = '0 ;
  //
  assign ldpc_dvb_enc__isop      = '0 ;
  assign ldpc_dvb_enc__ival      = '0 ;
  assign ldpc_dvb_enc__ieop      = '0 ;
  assign ldpc_dvb_enc__idat      = '0 ;
  assign ldpc_dvb_enc__itag      = '0 ;
  //
  assign ldpc_dvb_enc__iclkout   = '0 ;
  assign ldpc_dvb_enc__ireq      = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_fix.sv
// Description   : fixed mode DVB RTL encoder with asynchronus input/output/core clocks
//


module ldpc_dvb_enc_fix
(
  iclk      ,
  ireset    ,
  //
  iclkin    ,
  //
  isop      ,
  ival      ,
  ieop      ,
  idat      ,
  itag      ,
  //
  obusy     ,
  ordy      ,
  //
  iclkout   ,
  ireq      ,
  ofull     ,
  //
  osop      ,
  oval      ,
  oeop      ,
  odat      ,
  otag
);

  parameter int pDAT_W         = 8 ;  // must be multiply of cZC_MAX (360)
  parameter int pTAG_W         = 4 ;
  parameter bit pDO_TRANSPONSE = 0 ;  // do output transponse to be like DVB-S standart or not

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_enc_types.svh"

  parameter bit pCODEGR        = cCODEGR_LARGE  ; // short(0)/large(1) graph
  parameter int pCODERATE      = cCODERATE_5by6 ; // coderate table see in ldpc_dvb_constants.svh
  parameter bit pXMODE         = 0              ; // DVB-S2X code tables using

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk      ; // core clock
  input  logic                ireset    ;
  //
  input  logic                iclkin    ; // input interface clock
  //
  input  logic                isop      ;
  input  logic                ival      ;
  input  logic                ieop      ;
  input  logic [pDAT_W-1 : 0] idat      ;
  input  logic [pTAG_W-1 : 0] itag      ;
  //
  output logic                obusy     ;
  output logic                ordy      ;
  //
  input  logic                iclkout   ; // output interface clock
  input  logic                ireq      ;
  output logic                ofull     ;
  //
  output logic                osop      ;
  output logic                oval      ;
  output logic                oeop      ;
  output logic [pDAT_W-1 : 0] odat      ;
  output logic [pTAG_W-1 : 0] otag      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // used DWC word
  localparam int cZC            = get_buffer_dat_w(pDAT_W);

  // input DWC buffer
  localparam int cIB_ADDR       = get_ibuff_addr(pCODEGR, pCODERATE, pXMODE);

  localparam int cIB_WADDR_W    = $clog2(cIB_ADDR);
  localparam int cIB_WDAT_W     = cZC;

  localparam int cIB_RADDR_W    = $clog2(cIB_ADDR);
  localparam int cIB_RDAT_W     = cZC_MAX;

  localparam int cIB_TAG_W      = pTAG_W;

  // output buffer
  localparam int cOB_ADDR       = get_obuff_max_addr(pCODEGR);

  localparam int cOB_ADDR_W     = $clog2(cOB_ADDR);
  localparam int cOB_DAT_W      = cZC_MAX;
  localparam int cOB_TAG_W      = pTAG_W + cOB_ADDR_W;

  localparam int cZC_FACTOR  = cIB_RDAT_W/cIB_WDAT_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                     source__isop      ;
  logic                     source__ieop      ;
  logic                     source__ival      ;
  logic      [pDAT_W-1 : 0] source__idat      ;

  logic  [cZC_FACTOR-1 : 0] source__owrite    ;
  logic                     source__owfull    ;
  logic [cIB_WADDR_W-1 : 0] source__owaddr    ;
  logic  [cIB_WDAT_W-1 : 0] source__owdat     ;

  //
  // input buffer
  logic  [cZC_FACTOR-1 : 0] ibuffer__iwrite   ;
  logic                     ibuffer__iwfull   ;
  logic [cIB_WADDR_W-1 : 0] ibuffer__iwaddr   ;
  logic  [cIB_WDAT_W-1 : 0] ibuffer__iwdat    ;
  logic   [cIB_TAG_W-1 : 0] ibuffer__iwtag    ;

  logic                     ibuffer__owempty  ;
  logic                     ibuffer__owemptya ;
  logic                     ibuffer__owfull   ;
  logic                     ibuffer__owfulla  ;

  logic                     ibuffer__irempty  ;
  logic [cIB_RADDR_W-1 : 0] ibuffer__iraddr   ;
  logic  [cIB_RDAT_W-1 : 0] ibuffer__ordat    ;
  logic   [cIB_TAG_W-1 : 0] ibuffer__ortag    ;

  logic                     ibuffer__orempty  ;
  logic                     ibuffer__oremptya ;
  logic                     ibuffer__orfull   ;
  logic                     ibuffer__orfulla  ;

  //
  // engine
  logic                     engine__irbuf_full  ;
  code_ctx_t                engine__icode_ctx   ;
  //
  logic     [cZC_MAX-1 : 0] engine__irdat       ;
  logic      [pTAG_W-1 : 0] engine__irtag       ;
  logic                     engine__orempty     ;
  logic [cIB_RADDR_W-1 : 0] engine__oraddr      ;
  //
  logic                     engine__iwbuf_empty ;
  //
  logic  [cOB_ADDR_W-1 : 0] engine__owcol       ;
  logic  [cOB_ADDR_W-1 : 0] engine__owdata_col  ;
  logic  [cOB_ADDR_W-1 : 0] engine__owrow       ;
  //
  logic                     engine__owrite      ;
  logic                     engine__owfull      ;
  logic  [cOB_ADDR_W-1 : 0] engine__owaddr      ;
  logic     [cZC_MAX-1 : 0] engine__owdat       ;
  logic      [pTAG_W-1 : 0] engine__owtag       ;

  //
  // output buffer
  logic                    obuffer__iwrite   ;
  logic                    obuffer__iwfull   ;
  logic [cOB_ADDR_W-1 : 0] obuffer__iwaddr   ;
  logic  [cOB_DAT_W-1 : 0] obuffer__iwdat    ;
  logic  [cOB_TAG_W-1 : 0] obuffer__iwtag    ;

  logic                    obuffer__owempty  ;
  logic                    obuffer__owemptya ;
  logic                    obuffer__owfull   ;
  logic                    obuffer__owfulla  ;

  logic                    obuffer__irempty  ;
  logic [cOB_ADDR_W-1 : 0] obuffer__iraddr   ;
  logic  [cOB_DAT_W-1 : 0] obuffer__ordat    ;
  logic  [cOB_TAG_W-1 : 0] obuffer__ortag    ;

  logic                    obuffer__orempty  ;
  logic                    obuffer__oremptya ;
  logic                    obuffer__orfull   ;
  logic                    obuffer__orfulla  ;

  //
  // sink
  logic [cOB_ADDR_W-1 : 0] sink__irsize   ;
  logic                    sink__irfull   ;
  logic  [cOB_DAT_W-1 : 0] sink__irdat    ;
  logic     [pTAG_W-1 : 0] sink__irtag    ;
  logic                    sink__orempty  ;
  logic [cOB_ADDR_W-1 : 0] sink__oraddr   ;

  //------------------------------------------------------------------------------------------------------
  // reset CDC for all clocks
  //------------------------------------------------------------------------------------------------------

  logic clk_reset;
  logic clkin_reset;
  logic clkout_reset;

  codec_reset_synchronizer
  clk_reset_sync
  (
    .clk ( iclk ),    .reset_carry_in ( 1'b0 ) ,      .reset_in ( ireset ) , .reset_out  ( clk_reset )
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
  // source
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_source
  #(
    .pDAT_W     ( pDAT_W      ) ,
    //
    .pWADDR_W   ( cIB_WADDR_W ) ,
    .pWDAT_W    ( cIB_WDAT_W  ) ,
    //
    .pZC_FACTOR ( cZC_FACTOR  )
  )
  source
  (
    .iclk    ( iclkin            ) ,
    .ireset  ( clkin_reset       ) ,
    .iclkena ( 1'b1              ) ,
    //
    .isop    ( source__isop      ) ,
    .ieop    ( source__ieop      ) ,
    .ival    ( source__ival      ) ,
    .idat    ( source__idat      ) ,
    //
    .ifulla  ( ibuffer__owfulla  ) ,
    .iemptya ( ibuffer__owemptya ) ,
    //
    .ordy    ( ordy              ) ,
    .obusy   ( obusy             ) ,
    //
    .owrite  ( source__owrite    ) ,
    .owfull  ( source__owfull    ) ,
    .owaddr  ( source__owaddr    ) ,
    .owdat   ( source__owdat     )
  );

  assign source__isop = isop;
  assign source__ieop = ieop;
  assign source__ival = ival & ordy;
  assign source__idat = idat;

  //------------------------------------------------------------------------------------------------------
  // input buffer :: 2 tick read delay
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_ibuffer
  #(
    .pWADDR_W ( cIB_WADDR_W ) ,
    .pWDAT_W  ( cIB_WDAT_W  ) ,
    //
    .pRADDR_W ( cIB_RADDR_W ) ,
    .pRDAT_W  ( cIB_RDAT_W  ) ,
    //
    .pTAG_W   ( cIB_TAG_W   ) ,
    .pBNUM_W  ( 1           ) , // 2D buffer
    .pPIPE    ( 1           )
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
  assign ibuffer__iwdat  = source__owdat ;

  always_ff @(posedge iclkin) begin
    if (ival & isop) begin
      ibuffer__iwtag <= itag;
    end
  end

  assign ibuffer__irempty = engine__orempty;
  assign ibuffer__iraddr  = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // engine
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_engine
  #(
    .pRADDR_W  ( cIB_RADDR_W ) ,
    .pWADDR_W  ( cOB_ADDR_W  ) ,
    //
    .pTAG_W    ( pTAG_W      ) ,
    //
    .pCODEGR   ( pCODEGR     ) ,
    .pXMODE    ( pXMODE      ) ,
    .pFIX_MODE ( 1           )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( clk_reset           ) ,
    .iclkena     ( 1'b1                ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .icode_ctx   ( engine__icode_ctx   ) ,
    //
    .irdat       ( engine__irdat       ) ,
    .irtag       ( engine__irtag       ) ,
    .orempty     ( engine__orempty     ) ,
    .oraddr      ( engine__oraddr      ) ,
    //
    .iwbuf_empty ( engine__iwbuf_empty ) ,
    //
    .owcol       ( engine__owcol       ) ,
    .owdata_col  ( engine__owdata_col  ) ,
    .owrow       ( engine__owrow       ) ,
    //
    .owrite      ( engine__owrite      ) ,
    .owfull      ( engine__owfull      ) ,
    .owaddr      ( engine__owaddr      ) ,
    .owdat       ( engine__owdat       ) ,
    .owtag       ( engine__owtag       )
  );

  assign engine__irbuf_full   = ibuffer__orfull;

  assign engine__icode_ctx    = '{xmode : pXMODE, gr : pCODEGR, coderate : pCODERATE};
  assign engine__irtag        = ibuffer__ortag;

  assign engine__irdat        = ibuffer__ordat;

  //------------------------------------------------------------------------------------------------------
  // transponse unit
  //------------------------------------------------------------------------------------------------------

  generate
    if (pDO_TRANSPONSE) begin : transponse_inst_gen
      assign engine__iwbuf_empty  = '0;
    end
    else begin
      assign engine__iwbuf_empty  = obuffer__owempty;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // output buffer :: 2 tick read delay
  //------------------------------------------------------------------------------------------------------

  codec_abuffer
  #(
    .pADDR_W ( cOB_ADDR_W ) ,
    .pDAT_W  ( cOB_DAT_W  ) ,
    .pTAG_W  ( cOB_TAG_W  ) ,
    .pBNUM_W ( 1          ) , // 2D buffer
    .pPIPE   ( 1          )
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

  generate
    if (pDO_TRANSPONSE) begin : transponse_path_gen

      assign obuffer__iwrite  = '0;
      assign obuffer__iwfull  = '0;
      assign obuffer__iwaddr  = '0;
      assign obuffer__iwdat   = '0;

      assign obuffer__iwtag   = '0;

    end
    else begin : no_transponse_path_gen

      assign obuffer__iwrite  = engine__owrite;
      assign obuffer__iwfull  = engine__owfull;
      assign obuffer__iwaddr  = engine__owaddr;
      assign obuffer__iwdat   = engine__owdat;

      assign obuffer__iwtag   = {engine__owcol, engine__owtag};

    end
  endgenerate

  assign obuffer__irempty = sink__orempty;
  assign obuffer__iraddr  = sink__oraddr;

  //------------------------------------------------------------------------------------------------------
  // output sink
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_sink
  #(
    .pRADDR_W ( cOB_ADDR_W ) ,
    .pRDAT_W  ( cOB_DAT_W  ) ,
    //
    .pDAT_W   ( pDAT_W     ) ,
    .pTAG_W   ( pTAG_W     )
  )
  sink
  (
    .iclk     ( iclkout       ) ,
    .ireset   ( clkout_reset  ) ,
    .iclkena  ( 1'b1          ) ,
    //
    .irsize   ( sink__irsize  ) ,
    .irfull   ( sink__irfull  ) ,
    .irdat    ( sink__irdat   ) ,
    .irtag    ( sink__irtag   ) ,
    .orempty  ( sink__orempty ) ,
    .oraddr   ( sink__oraddr  ) ,
    //
    .ireq     ( ireq          ) ,
    .ofull    ( ofull         ) ,
    //
    .osop     ( osop          ) ,
    .oeop     ( oeop          ) ,
    .oval     ( oval          ) ,
    .odat     ( odat          ) ,
    .otag     ( otag          )
  );

  assign sink__irfull   = obuffer__orfull;
  assign sink__irdat    = obuffer__ordat;

  assign {sink__irsize,
          sink__irtag}  = obuffer__ortag;

endmodule
