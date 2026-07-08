/*



  parameter int pDAT_W = 6 ;
  parameter int pTAG_W = 8 ;



  logic                     b_nb_ldpc_hd_dec_fix__iclk        ;
  logic                     b_nb_ldpc_hd_dec_fix__ireset      ;
  //
  logic             [3 : 0] b_nb_ldpc_hd_dec_fix__iNiter      ;
  logic                     b_nb_ldpc_hd_dec_fix__ifmode      ;
  //
  logic                     b_nb_ldpc_hd_dec_fix__iclkin      ;
  //
  logic                     b_nb_ldpc_hd_dec_fix__isop        ;
  logic                     b_nb_ldpc_hd_dec_fix__ival        ;
  logic                     b_nb_ldpc_hd_dec_fix__ieop        ;
  logic      [pDAT_W-1 : 0] b_nb_ldpc_hd_dec_fix__idat        ;
  logic      [pTAG_W-1 : 0] b_nb_ldpc_hd_dec_fix__itag        ;
  //
  logic                     b_nb_ldpc_hd_dec_fix__ordy        ;
  logic                     b_nb_ldpc_hd_dec_fix__obusy       ;
  logic                     b_nb_ldpc_hd_dec_fix__osource_err ;
  //
  logic                     b_nb_ldpc_hd_dec_fix__iclkout     ;
  logic                     b_nb_ldpc_hd_dec_fix__ireq        ;
  logic                     b_nb_ldpc_hd_dec_fix__ofull       ;
  //
  logic                     b_nb_ldpc_hd_dec_fix__osop        ;
  logic                     b_nb_ldpc_hd_dec_fix__oval        ;
  logic                     b_nb_ldpc_hd_dec_fix__oeop        ;
  logic      [pDAT_W-1 : 0] b_nb_ldpc_hd_dec_fix__odat        ;
  logic      [pTAG_W-1 : 0] b_nb_ldpc_hd_dec_fix__otag        ;
  //
  logic             [3 : 0] b_nb_ldpc_hd_dec_fix__ouNiter     ;
  logic                     b_nb_ldpc_hd_dec_fix__odecfail    ;
  bit_err_t                 b_nb_ldpc_hd_dec_fix__obit_err    ;
  symb_err_t                b_nb_ldpc_hd_dec_fix__osymb_err   ;


  b_nb_ldpc_hd_dec_fix
  #(
    .pDAT_W ( pDAT_W ) ,
    .pTAG_W ( pTAG_W )
  )
  b_nb_ldpc_hd_dec_fix
  (
    .iclk        ( b_nb_ldpc_hd_dec_fix__iclk        ) ,
    .ireset      ( b_nb_ldpc_hd_dec_fix__ireset      ) ,
    //
    .iNiter      ( b_nb_ldpc_hd_dec_fix__iNiter      ) ,
    .ifmode      ( b_nb_ldpc_hd_dec_fix__ifmode      ) ,
    //
    .iclkin      ( b_nb_ldpc_hd_dec_fix__iclkin      ) ,
    //
    .isop        ( b_nb_ldpc_hd_dec_fix__isop        ) ,
    .ival        ( b_nb_ldpc_hd_dec_fix__ival        ) ,
    .ieop        ( b_nb_ldpc_hd_dec_fix__ieop        ) ,
    .idat        ( b_nb_ldpc_hd_dec_fix__idat        ) ,
    .itag        ( b_nb_ldpc_hd_dec_fix__itag        ) ,
    //
    .ordy        ( b_nb_ldpc_hd_dec_fix__ordy        ) ,
    .obusy       ( b_nb_ldpc_hd_dec_fix__obusy       ) ,
    .osource_err ( b_nb_ldpc_hd_dec_fix__osource_err ) ,
    //
    .iclkout     ( b_nb_ldpc_hd_dec_fix__iclkout     ) ,
    .ireq        ( b_nb_ldpc_hd_dec_fix__ireq        ) ,
    .ofull       ( b_nb_ldpc_hd_dec_fix__ofull       ) ,
    //
    .osop        ( b_nb_ldpc_hd_dec_fix__osop        ) ,
    .oval        ( b_nb_ldpc_hd_dec_fix__oval        ) ,
    .oeop        ( b_nb_ldpc_hd_dec_fix__oeop        ) ,
    .odat        ( b_nb_ldpc_hd_dec_fix__odat        ) ,
    .otag        ( b_nb_ldpc_hd_dec_fix__otag        ) ,
    //
    .ouNiter     ( b_nb_ldpc_hd_dec_fix__ouNiter     ) ,
    .odecfail    ( b_nb_ldpc_hd_dec_fix__odecfail    ) ,
    .obit_err    ( b_nb_ldpc_hd_dec_fix__obit_err    ) ,
    .osymb_err   ( b_nb_ldpc_hd_dec_fix__osymb_err   )
  );


  assign b_nb_ldpc_hd_dec_fix__iclk      = '0 ;
  assign b_nb_ldpc_hd_dec_fix__ireset    = '0 ;
  assign b_nb_ldpc_hd_dec_fix__icode_idx = '0 ;
  assign b_nb_ldpc_hd_dec_fix__iclkin    = '0 ;
  assign b_nb_ldpc_hd_dec_fix__isop      = '0 ;
  assign b_nb_ldpc_hd_dec_fix__ival      = '0 ;
  assign b_nb_ldpc_hd_dec_fix__ieop      = '0 ;
  assign b_nb_ldpc_hd_dec_fix__idat      = '0 ;
  assign b_nb_ldpc_hd_dec_fix__itag      = '0 ;
  assign b_nb_ldpc_hd_dec_fix__iclkout   = '0 ;
  assign b_nb_ldpc_hd_dec_fix__ireq      = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_hd_dec_fix.svh
// Description   : decoder (88, 44) with hard input bit (!!!) decision top level
//

module b_nb_ldpc_hd_dec_fix
#(
  parameter int pDAT_W             = 6 ,
  parameter int pTAG_W             = 8 ,
  //
  parameter bit pUSE_LLR_INVERSION = 0    // invert input metric
)
(
  iclk        ,
  ireset      ,
  //
  iNiter      ,
  ifmode      ,
  //
  iclkin      ,
  //
  isop        ,
  ival        ,
  ieop        ,
  idat        ,
  itag        ,
  //
  ordy        ,
  obusy       ,
  osource_err ,
  //
  iclkout     ,
  ireq        ,
  ofull       ,
  //
  osop        ,
  oval        ,
  oeop        ,
  odat        ,
  otag        ,
  //
  ouNiter     ,
  odecfail    ,
  obit_err    ,
  osymb_err
);

  `include "b_nb_ldpc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // synthesis translate_off
  initial begin
    assert (pDAT_W inside {1, 6}) else begin
      $fatal("unsupported data width = %0d", pDAT_W);
    end
  end
  // synthesis translate_on

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                      iclk        ;
  input  logic                      ireset      ;
  //
  input  logic              [3 : 0] iNiter      ;
  input  logic                      ifmode      ;
  //
  input  logic                      iclkin      ;
  //
  input  logic                      isop        ;
  input  logic                      ival        ;
  input  logic                      ieop        ;
  input  logic       [pDAT_W-1 : 0] idat        ;
  input  logic       [pTAG_W-1 : 0] itag        ;
  //
  output logic                      ordy        ;
  output logic                      obusy       ;
  output logic                      osource_err ;
  //
  input  logic                      iclkout     ;
  input  logic                      ireq        ;
  output logic                      ofull       ;
  //
  output logic                      osop        ;
  output logic                      oval        ;
  output logic                      oeop        ;
  output logic       [pDAT_W-1 : 0] odat        ;
  output logic       [pTAG_W-1 : 0] otag        ;
  //
  output logic              [3 : 0] ouNiter     ;
  output logic                      odecfail    ;
  output bit_err_t                  obit_err    ;
  output symb_err_t                 osymb_err   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cIBUF_ADDR_W = cLOG2_N_MAX;
  localparam int cIBUF_DAT_W  = $bits(gf_data_t);
  localparam int cIBUF_TAG_W  = pTAG_W;

  localparam int cOBUF_ADDR_W = cLOG2_K_MAX;
  localparam int cOBUF_DAT_W  = $bits(gf_data_t);
  localparam int cOBUF_TAG_W  = 4 + 1 + cBIT_ERR_W + cSYMB_ERR_W + pTAG_W; // + used Niter + decfail + errors

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // source
  code_idx_t                  source__icode_idx   ;
  //
  logic                       source__isop        ;
  logic                       source__ival        ;
  logic                       source__ieop        ;
  logic        [pDAT_W-1 : 0] source__idat        ;
  logic   [cIBUF_TAG_W-1 : 0] source__itag        ;
  //
  logic                       source__ifulla      ;
  logic                       source__iemptya     ;
  //
  logic                       source__ordy        ;
  logic                       source__obusy       ;
  logic                       source__osource_err ;
  //
  code_idx_t                  source__ocode_idx   ;
  //
  logic                       source__owrite      ;
  logic                       source__owfull      ;
  logic  [cIBUF_ADDR_W-1 : 0] source__owaddr      ;
  gf_data_t                   source__owdat       ;
  logic   [cIBUF_TAG_W-1 : 0] source__owtag       ;

  // ibuffer
  logic                       ibuf__iwrite   ;
  logic                       ibuf__iwfull   ;
  logic  [cIBUF_ADDR_W-1 : 0] ibuf__iwaddr   ;
  logic   [cIBUF_DAT_W-1 : 0] ibuf__iwdat    ;
  logic   [cIBUF_TAG_W-1 : 0] ibuf__iwtag    ;
  //
  logic                       ibuf__owempty  ;
  logic                       ibuf__owemptya ;
  logic                       ibuf__owfull   ;
  logic                       ibuf__owfulla  ;
  //
  logic                       ibuf__irempty  ;
  logic  [cIBUF_ADDR_W-1 : 0] ibuf__iraddr   ;
  logic   [cIBUF_DAT_W-1 : 0] ibuf__ordat    ;
  logic   [cIBUF_TAG_W-1 : 0] ibuf__ortag    ;
  //
  logic                       ibuf__orempty  ;
  logic                       ibuf__oremptya ;
  logic                       ibuf__orfull   ;
  logic                       ibuf__orfulla  ;

  // engine
  logic                       engine__irbuf_full  ;
  logic               [3 : 0] engine__iNiter      ;
  logic                       engine__ifmode      ;
  //
  gf_data_t                   engine__irdat       ;
  logic        [pTAG_W-1 : 0] engine__irtag       ;
  logic                       engine__orempty     ;
  logic  [cIBUF_ADDR_W-1 : 0] engine__oraddr      ;
  //
  logic                       engine__iwbuf_empty ;
  //
  logic                       engine__owrite      ;
  logic                       engine__owfull      ;
  logic  [cOBUF_ADDR_W-1 : 0] engine__owaddr      ;
  gf_data_t                   engine__owdat       ;
  logic        [pTAG_W-1 : 0] engine__owtag       ;
  //
  logic                       engine__owdecfail   ;
  bit_err_t                   engine__owbit_err   ;
  bit_err_t                   engine__owsymb_err  ;
  logic               [3 : 0] engine__owNiter     ;
  //
  logic                       engine__obusy       ;

  // obuffer
  logic                       obuf__iwrite   ;
  logic                       obuf__iwfull   ;
  logic  [cOBUF_ADDR_W-1 : 0] obuf__iwaddr   ;
  logic   [cOBUF_DAT_W-1 : 0] obuf__iwdat    ;
  logic   [cOBUF_TAG_W-1 : 0] obuf__iwtag    ;
  //
  logic                       obuf__owempty  ;
  logic                       obuf__owemptya ;
  logic                       obuf__owfull   ;
  logic                       obuf__owfulla  ;
  //
  logic                       obuf__irempty  ;
  logic  [cOBUF_ADDR_W-1 : 0] obuf__iraddr   ;
  logic   [cOBUF_DAT_W-1 : 0] obuf__ordat    ;
  logic   [cOBUF_TAG_W-1 : 0] obuf__ortag    ;
  //
  logic                       obuf__orempty  ;
  logic                       obuf__oremptya ;
  logic                       obuf__orfull   ;
  logic                       obuf__orfulla  ;

  // sink
  code_idx_t                  sink__icode_idx ;
  //
  logic                       sink__irfull    ;
  gf_data_t                   sink__irdat     ;
  logic        [pTAG_W-1 : 0] sink__irtag     ;
  logic                       sink__orempty   ;
  logic  [cOBUF_ADDR_W-1 : 0] sink__oraddr    ;

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
  //
  //------------------------------------------------------------------------------------------------------

  assign ordy         = source__ordy;
  assign osource_err  = source__osource_err;

  //------------------------------------------------------------------------------------------------------
  // obusy CDC :: busy is not handske singnal
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] engine_busy;
  logic [1 : 0] obuf_busy;

  always_ff @(posedge iclkin) begin
    engine_busy <= (engine_busy << 1) | engine__obusy;
    obuf_busy   <= (obuf_busy   << 1) | obuf__owfull;
    //
    obusy       <= source__obusy | engine_busy[1] | obuf_busy[1];
  end

  //------------------------------------------------------------------------------------------------------
  // source
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_source
  #(
    .pDAT_W    ( pDAT_W       ) ,
    .pADDR_W   ( cIBUF_ADDR_W ) ,
    .pTAG_W    ( cIBUF_TAG_W  ) ,
    //
    .pDEC_MODE ( 1            )
  )
  source
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( 1'b1                ) ,
    //
    .icode_idx   ( source__icode_idx   ) ,
    //
    .isop        ( source__isop        ) ,
    .ival        ( source__ival        ) ,
    .ieop        ( source__ieop        ) ,
    .idat        ( source__idat        ) ,
    .itag        ( source__itag        ) ,
    //
    .ifulla      ( source__ifulla      ) ,
    .iemptya     ( source__iemptya     ) ,
    //
    .ordy        ( source__ordy        ) ,
    .obusy       ( source__obusy       ) ,
    .osource_err ( source__osource_err ) ,
    //
    .ocode_idx   ( source__ocode_idx   ) ,
    //
    .owrite      ( source__owrite      ) ,
    .owfull      ( source__owfull      ) ,
    .owaddr      ( source__owaddr      ) ,
    .owdat       ( source__owdat       ) ,
    .owtag       ( source__owtag       )
  );

  assign source__icode_idx = '0;

  assign source__isop      = isop;
  assign source__ival      = ival & ordy;
  assign source__ieop      = ieop;
  assign source__idat      = pUSE_LLR_INVERSION ? ~idat : idat;
  assign source__itag      = itag;

  assign source__ifulla    = ibuf__owfulla  ;
  assign source__iemptya   = ibuf__owemptya ;

  //------------------------------------------------------------------------------------------------------
  // input bufer
  //------------------------------------------------------------------------------------------------------

  codec_abuffer
  #(
    .pADDR_W   ( cIBUF_ADDR_W ) ,
    .pDAT_W    ( cIBUF_DAT_W  ) ,
    .pTAG_W    ( cIBUF_TAG_W  ) ,
    //
    .pBNUM_W   ( 1            ) , // 2D buffer
    .pPIPE     ( 1            )   // 2 tick reading
  )
  ibuf
  (
    .iwclk    ( iclkin         ) ,
    .iwreset  ( clkin_reset    ) ,
    //
    .iwrite   ( ibuf__iwrite   ) ,
    .iwfull   ( ibuf__iwfull   ) ,
    .iwaddr   ( ibuf__iwaddr   ) ,
    .iwdat    ( ibuf__iwdat    ) ,
    .iwtag    ( ibuf__iwtag    ) ,
    //
    .owempty  ( ibuf__owempty  ) ,
    .owemptya ( ibuf__owemptya ) ,
    .owfull   ( ibuf__owfull   ) ,
    .owfulla  ( ibuf__owfulla  ) ,
    //
    .irclk    ( iclk           ) ,
    .irreset  ( clk_reset      ) ,
    //
    .irempty  ( ibuf__irempty  ) ,
    .iraddr   ( ibuf__iraddr   ) ,
    .ordat    ( ibuf__ordat    ) ,
    .ortag    ( ibuf__ortag    ) ,
    //
    .orempty  ( ibuf__orempty  ) ,
    .oremptya ( ibuf__oremptya ) ,
    .orfull   ( ibuf__orfull   ) ,
    .orfulla  ( ibuf__orfulla  )
  );

  assign ibuf__iwrite   = source__owrite;
  assign ibuf__iwfull   = source__owfull;
  assign ibuf__iwaddr   = source__owaddr;
  assign ibuf__iwdat    = source__owdat ;
  assign ibuf__iwtag    = source__owtag ;

  //
  assign ibuf__irempty  = engine__orempty ;
  assign ibuf__iraddr   = engine__oraddr ;

  //------------------------------------------------------------------------------------------------------
  // engine
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_hd_dec_engine_fix
  #(
    .pRADDR_W ( cIBUF_ADDR_W  ) ,
    .pWADDR_W ( cOBUF_ADDR_W  ) ,
    .pTAG_W   ( pTAG_W        )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( 1'b1                ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .iNiter      ( engine__iNiter      ) ,
    .ifmode      ( engine__ifmode      ) ,
    //
    .irdat       ( engine__irdat       ) ,
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
    //
    .owdecfail   ( engine__owdecfail   ) ,
    .owbit_err   ( engine__owbit_err   ) ,
    .owsymb_err  ( engine__owsymb_err  ) ,
    .owNiter     ( engine__owNiter     ) ,
    //
    .obusy       ( engine__obusy       )
  );

  assign engine__irbuf_full   = ibuf__orfull ;
  assign engine__iNiter       = iNiter ;
  assign engine__ifmode       = ifmode ;
  assign engine__irtag        = ibuf__ortag;
  assign engine__irdat        = ibuf__ordat ;

  assign engine__iwbuf_empty  = obuf__owempty ;

  //------------------------------------------------------------------------------------------------------
  // output bufer
  //------------------------------------------------------------------------------------------------------

  codec_abuffer
  #(
    .pADDR_W   ( cOBUF_ADDR_W ) ,
    .pDAT_W    ( cOBUF_DAT_W  ) ,
    .pTAG_W    ( cOBUF_TAG_W  ) ,
    //
    .pBNUM_W   ( 1            ) , // 2D buffer
    .pPIPE     ( 1            )   // 2 tick reading
  )
  obuf
  (
    .iwclk    ( iclk           ) ,
    .iwreset  ( clk_reset      ) ,
    //
    .iwrite   ( obuf__iwrite   ) ,
    .iwfull   ( obuf__iwfull   ) ,
    .iwaddr   ( obuf__iwaddr   ) ,
    .iwdat    ( obuf__iwdat    ) ,
    .iwtag    ( obuf__iwtag    ) ,
    //
    .owempty  ( obuf__owempty  ) ,
    .owemptya ( obuf__owemptya ) ,
    .owfull   ( obuf__owfull   ) ,
    .owfulla  ( obuf__owfulla  ) ,
    //
    .irclk    ( iclkout        ) ,
    .irreset  ( clkout_reset   ) ,
    //
    .irempty  ( obuf__irempty  ) ,
    .iraddr   ( obuf__iraddr   ) ,
    .ordat    ( obuf__ordat    ) ,
    .ortag    ( obuf__ortag    ) ,
    //
    .orempty  ( obuf__orempty  ) ,
    .oremptya ( obuf__oremptya ) ,
    .orfull   ( obuf__orfull   ) ,
    .orfulla  ( obuf__orfulla  )
  );

  assign obuf__iwrite   = engine__owrite ;
  assign obuf__iwfull   = engine__owfull ;
  assign obuf__iwaddr   = engine__owaddr ;
  assign obuf__iwdat    = engine__owdat  ;
  assign obuf__iwtag    = {engine__owNiter, engine__owdecfail, engine__owsymb_err, engine__owbit_err, engine__owtag};

  assign obuf__irempty  = sink__orempty ;
  assign obuf__iraddr   = sink__oraddr ;

  //------------------------------------------------------------------------------------------------------
  // sink
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_sink
  #(
    .pADDR_W ( cOBUF_ADDR_W ) ,
    .pDAT_W  ( pDAT_W       ) ,
    .pTAG_W  ( pTAG_W       ) ,
    //
    .pDEC_MODE ( 1          )
  )
  sink
  (
    .iclk      ( iclkout         ) ,
    .ireset    ( clkout_reset    ) ,
    .iclkena   ( 1'b1            ) ,
    //
    .icode_idx ( sink__icode_idx ) ,
    //
    .irfull    ( sink__irfull    ) ,
    .irdat     ( sink__irdat     ) ,
    .irtag     ( sink__irtag     ) ,
    .orempty   ( sink__orempty   ) ,
    .oraddr    ( sink__oraddr    ) ,
    //
    .ireq      ( ireq            ) ,
    .ofull     ( ofull           ) ,
    //
    .osop      ( osop            ) ,
    .oeop      ( oeop            ) ,
    .oval      ( oval            ) ,
    .odat      ( odat            ) ,
    .otag      ( otag            )
  );

  assign sink__icode_idx  = '0;

  assign sink__irfull     = obuf__orfull ;
  assign sink__irdat      = obuf__ordat ;
  assign sink__irtag      = obuf__ortag ;

endmodule
