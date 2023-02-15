/*



  parameter int pCODEGR           =  1 ;
  parameter int pCODERATE         =  3 ;
  parameter bit pXMODE            =  0 ;
  //
  parameter int pLLR_W            =  4 ;
  parameter int pLLR_NUM          =  1 ;
  //
  parameter int pDAT_W            =  8 ;
  parameter int pTAG_W            =  4 ;
  //
  parameter int pERR_W            = 16 ;
  //
  parameter int pNODE_W           =  6 ;
  //
  parameter int pNORM_FACTOR      =  7 ;
  parameter bit pNORM_OFFSET      =  0 ;
  parameter bit pDO_TRANSPONSE    =  0 ;
  parameter bit pDO_LLR_INVERSION =  1 ;
  parameter bit pUSE_SRL_FIFO     =  1 ;
  parameter bit pFULL_BITS_OUTPUT =  0 ;
  parameter bit pUSE_SC_MODE      =  0 ;



  logic                ldpc_dvb_dec_fix__iclk                ;
  logic                ldpc_dvb_dec_fix__ireset              ;
  //
  logic        [7 : 0] ldpc_dvb_dec_fix__iNiter              ;
  logic                ldpc_dvb_dec_fix__ifmode              ;
  //
  logic                ldpc_dvb_dec_fix__iclkin              ;
  //
  logic                ldpc_dvb_dec_fix__ival                ;
  logic                ldpc_dvb_dec_fix__isop                ;
  logic                ldpc_dvb_dec_fix__ieop                ;
  logic [pTAG_W-1 : 0] ldpc_dvb_dec_fix__itag                ;
  llr_t                ldpc_dvb_dec_fix__iLLR     [pLLR_NUM] ;
  //
  logic                ldpc_dvb_dec_fix__obusy               ;
  logic                ldpc_dvb_dec_fix__ordy                ;
  //
  logic                ldpc_dvb_dec_fix__iclkout             ;
  logic                ldpc_dvb_dec_fix__ireq                ;
  logic                ldpc_dvb_dec_fix__ofull               ;
  //
  logic                ldpc_dvb_dec_fix__oval                ;
  logic                ldpc_dvb_dec_fix__osop                ;
  logic                ldpc_dvb_dec_fix__oeop                ;
  logic [pTAG_W-1 : 0] ldpc_dvb_dec_fix__otag                ;
  logic [pDAT_W-1 : 0] ldpc_dvb_dec_fix__odat                ;
  //
  logic                ldpc_dvb_dec_fix__odecfail            ;
  logic [pERR_W-1 : 0] ldpc_dvb_dec_fix__oerr                ;



  ldpc_dvb_dec_fix
  #(
    .pCODEGR           ( pCODEGR           ) ,
    .pCODERATE         ( pCODERATE         ) ,
    .pXMODE            ( pXMODE            ) ,
    //
    .pLLR_W            ( pLLR_W            ) ,
    .pLLR_NUM          ( pLLR_NUM          ) ,
    //
    .pDAT_W            ( pDAT_W            ) ,
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pERR_W            ( pERR_W            ) ,
    //
    .pNODE_W           ( pNODE_W           ) ,
    //
    .pNORM_FACTOR      ( pNORM_FACTOR      ) ,
    .pNORM_OFFSET      ( pNORM_OFFSET      ) ,
    .pDO_TRANSPONSE    ( pDO_TRANSPONSE    ) ,
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION ) ,
    .pUSE_SRL_FIFO     ( pUSE_SRL_FIFO     ) ,
    .pFULL_BITS_OUTPUT ( pFULL_BITS_OUTPUT ) ,
    .pUSE_SC_MODE      ( pUSE_SC_MODE      )
  )
  ldpc_dvb_dec_fix
  (
    .iclk      ( ldpc_dvb_dec_fix__iclk      ) ,
    .ireset    ( ldpc_dvb_dec_fix__ireset    ) ,
    //
    .iNiter    ( ldpc_dvb_dec_fix__iNiter    ) ,
    .ifmode    ( ldpc_dvb_dec_fix__ifmode    ) ,
    //
    .iclkin    ( ldpc_dvb_dec_fix__iclkin    ) ,
    //
    .ival      ( ldpc_dvb_dec_fix__ival      ) ,
    .isop      ( ldpc_dvb_dec_fix__isop      ) ,
    .ieop      ( ldpc_dvb_dec_fix__ieop      ) ,
    .itag      ( ldpc_dvb_dec_fix__itag      ) ,
    .iLLR      ( ldpc_dvb_dec_fix__iLLR      ) ,
    //
    .obusy     ( ldpc_dvb_dec_fix__obusy     ) ,
    .ordy      ( ldpc_dvb_dec_fix__ordy      ) ,
    //
    .iclkout   ( ldpc_dvb_dec_fix__iclkout   ) ,
    .ireq      ( ldpc_dvb_dec_fix__ireq      ) ,
    .ofull     ( ldpc_dvb_dec_fix__ofull     ) ,
    //
    .oval      ( ldpc_dvb_dec_fix__oval      ) ,
    .osop      ( ldpc_dvb_dec_fix__osop      ) ,
    .oeop      ( ldpc_dvb_dec_fix__oeop      ) ,
    .otag      ( ldpc_dvb_dec_fix__otag      ) ,
    .odat      ( ldpc_dvb_dec_fix__odat      ) ,
    //
    .odecfail  ( ldpc_dvb_dec_fix__odecfail  ) ,
    .oerr      ( ldpc_dvb_dec_fix__oerr      )
  );


  assign ldpc_dvb_dec_fix__iclk      = '0 ;
  assign ldpc_dvb_dec_fix__ireset    = '0 ;
  assign ldpc_dvb_dec_fix__iNiter    = '0 ;
  assign ldpc_dvb_dec_fix__ifmode    = '0 ;
  assign ldpc_dvb_dec_fix__iclkin    = '0 ;
  assign ldpc_dvb_dec_fix__ival      = '0 ;
  assign ldpc_dvb_dec_fix__isop      = '0 ;
  assign ldpc_dvb_dec_fix__ieop      = '0 ;
  assign ldpc_dvb_dec_fix__itag      = '0 ;
  assign ldpc_dvb_dec_fix__iLLR      = '0 ;
  assign ldpc_dvb_dec_fix__iclkout   = '0 ;
  assign ldpc_dvb_dec_fix__ireq      = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_fix.sv
// Description   : Fixed mode DVB LDPC RTL decoder with asynchronus input/output/core clocks
//

`include "define.vh"

module ldpc_dvb_dec_fix
(
  iclk      ,
  ireset    ,
  //
  iNiter    ,
  ifmode    ,
  //
  iclkin    ,
  //
  ival      ,
  isop      ,
  ieop      ,
  itag      ,
  iLLR      ,
  //
  obusy     ,
  ordy      ,
  //
  iclkout   ,
  ireq      ,
  ofull     ,
  //
  oval      ,
  osop      ,
  oeop      ,
  odat      ,
  otag      ,
  //
  odecfail  ,
  oerr
);

  parameter int pLLR_NUM          =  8 ;  // must be multiply of cZC_MAX (360)
  parameter int pDAT_W            =  8 ;  // must be multiply of cZC_MAX (360)
  parameter int pTAG_W            =  4 ;
  //
  parameter bit pDO_TRANSPONSE    =  0 ;  // do input transponse to be like DVB-S standart or not
  parameter bit pDO_LLR_INVERSION =  1 ;  // do metric inversion or not
  parameter bit pUSE_SRL_FIFO     =  1 ;  // use SRL based internal FIFO
  parameter bit pFULL_BITS_OUTPUT =  0 ;  // send all(1)/data(0) bits to output
  //
  parameter int pERR_W            = 16 ;
  //

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  parameter bit pCODEGR           = cCODEGR_LARGE  ;  // maximum used graph short(0)/large(1)
  parameter int pCODERATE         = cCODERATE_1by2 ;  // coderate table see in ldpc_dvb_constants.svh
  parameter bit pXMODE            = 0              ;  // DVB-S2X code tables using

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                ;  // core clock
  input  logic                       ireset              ;
  //
  input  logic               [7 : 0] iNiter              ;
  input  logic                       ifmode              ;  // fast work mode with early stop
  //
  input  logic                       iclkin              ;  // input interface clock
  //
  input  logic                       ival                ;
  input  logic                       isop                ;
  input  logic                       ieop                ;
  input  logic        [pTAG_W-1 : 0] itag                ;
  input  logic signed [pLLR_W-1 : 0] iLLR     [pLLR_NUM] ;
  //
  output logic                       obusy               ;
  output logic                       ordy                ;
  //
  input  logic                       iclkout             ;  // output interface clock
  input  logic                       ireq                ;
  output logic                       ofull               ;
  //
  output logic                       oval                ;
  output logic                       osop                ;
  output logic                       oeop                ;
  output logic        [pDAT_W-1 : 0] odat                ;
  output logic        [pTAG_W-1 : 0] otag                ;
  //
  output logic                       odecfail            ;
  output logic        [pERR_W-1 : 0] oerr                ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // used DWC word
  localparam int cZC            = get_buffer_llr_num(pLLR_W, pLLR_NUM);

  // input DWC buffer
  localparam int cIB_ADDR       = get_buff_max_addr(pCODEGR);

  localparam int cIB_WADDR_W    = $clog2(cIB_ADDR);
  localparam int cIB_WDAT_W     = cZC * pLLR_W;

  localparam int cIB_RADDR_W    = $clog2(cIB_ADDR);
  localparam int cIB_RDAT_W     = cZC_MAX * pLLR_W;

  localparam int cIB_TAG_W      = pTAG_W + $bits(iNiter) + 1;

  // output buffer
  localparam int cOB_ADDR       = cIB_ADDR; // same as input

  localparam int cOB_ADDR_W     = $clog2(cOB_ADDR);
  localparam int cOB_DAT_W      = cZC_MAX;
  localparam int cOB_TAG_W      = pTAG_W + cOB_ADDR_W + pERR_W + 1;

  localparam int cZC_FACTOR     = cIB_RDAT_W/cIB_WDAT_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                       source__isop                  ;
  logic                       source__ieop                  ;
  logic                       source__ival                  ;
  llr_t                       source__iLLR       [pLLR_NUM] ;

  logic    [cZC_FACTOR-1 : 0] source__owrite                ;
  logic   [cIB_WADDR_W-1 : 0] source__owaddr                ;
  logic                       source__owfull                ;
  llr_t                       source__owLLR      [cZC]      ;

  //
  // input buffer
  logic    [cZC_FACTOR-1 : 0] ibuffer__iwrite               ;
  logic                       ibuffer__iwfull               ;
  logic   [cIB_WADDR_W-1 : 0] ibuffer__iwaddr               ;
  logic    [cIB_WDAT_W-1 : 0] ibuffer__iwdat                ;
  logic     [cIB_TAG_W-1 : 0] ibuffer__iwtag                ;

  logic                       ibuffer__owempty              ;
  logic                       ibuffer__owemptya             ;
  logic                       ibuffer__owfull               ;
  logic                       ibuffer__owfulla              ;

  logic                       ibuffer__irempty              ;
  logic   [cIB_RADDR_W-1 : 0] ibuffer__iraddr               ;
  logic    [cIB_RDAT_W-1 : 0] ibuffer__ordat                ;
  logic     [cIB_TAG_W-1 : 0] ibuffer__ortag                ;

  logic                       ibuffer__orempty              ;
  logic                       ibuffer__oremptya             ;
  logic                       ibuffer__orfull               ;
  logic                       ibuffer__orfulla              ;

  //
  // engine
  logic                       engine__irbuf_full            ;
  code_ctx_t                  engine__icode_ctx             ;
  logic               [7 : 0] engine__iNiter                ;
  logic                       engine__ifmode                ;
  //
  zllr_t                      engine__irLLR                 ;
  logic        [pTAG_W-1 : 0] engine__irtag                 ;
  logic                       engine__orempty               ;
  logic   [cIB_RADDR_W-1 : 0] engine__oraddr                ;
  //
  logic                       engine__iwbuf_empty           ;
  //
  logic    [cOB_ADDR_W-1 : 0] engine__owcol                 ;
  logic    [cOB_ADDR_W-1 : 0] engine__owdata_col            ;
  logic    [cOB_ADDR_W-1 : 0] engine__owrow                 ;
  //
  logic                       engine__owrite                ;
  logic                       engine__owfull                ;
  logic    [cOB_ADDR_W-1 : 0] engine__owaddr                ;
  zdat_t                      engine__owdat                 ;
  logic        [pTAG_W-1 : 0] engine__owtag                 ;

  logic                       engine__owdecfail             ;
  logic        [pERR_W-1 : 0] engine__owerr                 ;

  //
  // obuf
  logic                       obuffer__iwrite               ;
  logic                       obuffer__iwfull               ;
  logic    [cOB_ADDR_W-1 : 0] obuffer__iwaddr               ;
  logic     [cOB_DAT_W-1 : 0] obuffer__iwdat                ;
  logic     [cOB_TAG_W-1 : 0] obuffer__iwtag                ;

  logic                       obuffer__owempty              ;
  logic                       obuffer__owemptya             ;
  logic                       obuffer__owfull               ;
  logic                       obuffer__owfulla              ;

  logic                       obuffer__irempty              ;
  logic    [cOB_ADDR_W-1 : 0] obuffer__iraddr               ;
  logic     [cOB_DAT_W-1 : 0] obuffer__ordat                ;
  logic     [cOB_TAG_W-1 : 0] obuffer__ortag                ;

  logic                       obuffer__orempty              ;
  logic                       obuffer__oremptya             ;
  logic                       obuffer__orfull               ;
  logic                       obuffer__orfulla              ;

  //
  // sink
  logic    [cOB_ADDR_W-1 : 0] sink__irsize                  ;
  //
  logic                       sink__irfull                  ;
  logic     [cOB_DAT_W-1 : 0] sink__irdat                   ;
  logic        [pTAG_W-1 : 0] sink__irtag                   ;
  //
  logic                       sink__irdecfail               ;
  logic        [pERR_W-1 : 0] sink__irerr                   ;
  //
  logic                       sink__orempty                 ;
  logic    [cOB_ADDR_W-1 : 0] sink__oraddr                  ;

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

  ldpc_dvb_dec_source
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pLLR_NUM          ( pLLR_NUM          ) ,
    //
    .pWADDR_W          ( cIB_WADDR_W       ) ,
    .pWNUM             ( cZC               ) ,
    //
    .pZC_FACTOR        ( cZC_FACTOR        ) ,
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  source
  (
    .iclk       ( iclkin            ) ,
    .ireset     ( clkin_reset       ) ,
    .iclkena    ( 1'b1              ) ,
    //
    .isop       ( source__isop      ) ,
    .ieop       ( source__ieop      ) ,
    .ival       ( source__ival      ) ,
    .iLLR       ( source__iLLR      ) ,
    //
    .obusy      ( obusy             ) ,
    .ordy       ( ordy              ) ,
    //
    .iemptya    ( ibuffer__owemptya ) ,
    .ifulla     ( ibuffer__owfulla  ) ,
    //
    .owrite     ( source__owrite    ) ,
    .owfull     ( source__owfull    ) ,
    .owaddr     ( source__owaddr    ) ,
    .owLLR      ( source__owLLR     )
  );

  assign source__isop = isop;
  assign source__ieop = ieop;
  assign source__ival = ival & ordy;
  assign source__iLLR = iLLR;

  //------------------------------------------------------------------------------------------------------
  // input buffer :: 2 tick read delay
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_ibuffer
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

  always_comb begin
    for (int z = 0; z < cZC; z++) begin
      ibuffer__iwdat[z*pLLR_W +: pLLR_W] = source__owLLR[z];
    end
  end

  always_ff @(posedge iclkin) begin
    if (ival & isop) begin
      ibuffer__iwtag <= {ifmode, iNiter, itag};
    end
  end

  assign ibuffer__irempty = engine__orempty;
  assign ibuffer__iraddr  = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // engine
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_2d_engine
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pNODE_W           ( pNODE_W           ) ,
    //
    .pRADDR_W          ( cIB_RADDR_W       ) ,
    .pWADDR_W          ( cOB_ADDR_W        ) ,
    //
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pERR_W            ( pERR_W            ) ,
    //
    .pCODEGR           ( pCODEGR           ) ,
    .pXMODE            ( pXMODE            ) ,
    .pNORM_FACTOR      ( pNORM_FACTOR      ) ,
    .pNORM_OFFSET      ( pNORM_OFFSET      ) ,
    //
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION ) ,
    .pUSE_SRL_FIFO     ( pUSE_SRL_FIFO     ) ,
    .pUSE_SC_MODE      ( pUSE_SC_MODE      ) ,
    //
    .pFIX_MODE         ( 1                 )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( clk_reset           ) ,
    .iclkena     ( 1'b1                ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .icode_ctx   ( engine__icode_ctx   ) ,
    .iNiter      ( engine__iNiter      ) ,
    .ifmode      ( engine__ifmode      ) ,
    //
    .irLLR       ( engine__irLLR       ) ,
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
    .owtag       ( engine__owtag       ) ,
    //
    .owdecfail   ( engine__owdecfail   ) ,
    .owerr       ( engine__owerr       )
  );

  assign engine__irbuf_full   = ibuffer__orfull;

  assign engine__icode_ctx    = '{gr : pCODEGR, coderate : pCODERATE};

  assign {engine__ifmode,
          engine__iNiter,
          engine__irtag     } = ibuffer__ortag;

  always_comb begin
    for (int z = 0; z < cZC_MAX; z++) begin
      engine__irLLR[z] = ibuffer__ordat[z*pLLR_W +: pLLR_W];
    end
  end

  assign engine__iwbuf_empty  = obuffer__owempty;

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

  assign obuffer__iwrite  = engine__owrite;
  assign obuffer__iwfull  = engine__owfull;
  assign obuffer__iwaddr  = engine__owaddr;
  assign obuffer__iwdat   = engine__owdat;

  assign obuffer__iwtag   = { pFULL_BITS_OUTPUT ? engine__owcol : engine__owdata_col,
                              engine__owdecfail,
                              engine__owerr,
                              engine__owtag};

  assign obuffer__irempty = sink__orempty;
  assign obuffer__iraddr  = sink__oraddr;

  //------------------------------------------------------------------------------------------------------
  // sink
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_sink
  #(
    .pRADDR_W ( cOB_ADDR_W ) ,
    .pRDAT_W  ( cOB_DAT_W  ) ,
    //
    .pDAT_W   ( pDAT_W     ) ,
    .pTAG_W   ( pTAG_W     ) ,
    //
    .pERR_W   ( pERR_W     )
  )
  sink
  (
    .iclk      ( iclkout         ) ,
    .ireset    ( clkout_reset    ) ,
    .iclkena   ( 1'b1            ) ,
    //
    .irsize    ( sink__irsize    ) ,
    .irfull    ( sink__irfull    ) ,
    .irdat     ( sink__irdat     ) ,
    .irtag     ( sink__irtag     ) ,
    //
    .irdecfail ( sink__irdecfail ) ,
    .irerr     ( sink__irerr     ) ,
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
    .oerr      ( oerr            )
  );

  assign sink__irfull = obuffer__orfull;
  assign sink__irdat  = obuffer__ordat;

  assign {sink__irsize    ,
          sink__irdecfail ,
          sink__irerr     ,
          sink__irtag     } = obuffer__ortag;

endmodule
