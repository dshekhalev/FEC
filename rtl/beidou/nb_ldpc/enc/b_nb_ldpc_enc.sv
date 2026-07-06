/*



  parameter int pDAT_W        = 6 ;
  parameter int pTAG_W        = 8 ;
  //
  parameter int pBCNV_MAX_IDX = 3 ;



  logic                     b_nb_ldpc_enc__iclk        ;
  logic                     b_nb_ldpc_enc__ireset      ;
  //
  code_idx_t                b_nb_ldpc_enc__icode_idx   ;
  //
  logic                     b_nb_ldpc_enc__iclkin      ;
  //
  logic                     b_nb_ldpc_enc__isop        ;
  logic                     b_nb_ldpc_enc__ival        ;
  logic                     b_nb_ldpc_enc__ieop        ;
  logic      [pDAT_W-1 : 0] b_nb_ldpc_enc__idat        ;
  logic      [pTAG_W-1 : 0] b_nb_ldpc_enc__itag        ;
  //
  logic                     b_nb_ldpc_enc__ordy        ;
  logic                     b_nb_ldpc_enc__obusy       ;
  logic                     b_nb_ldpc_enc__osource_err ;
  //
  logic                     b_nb_ldpc_enc__iclkout     ;
  logic                     b_nb_ldpc_enc__ireq        ;
  logic                     b_nb_ldpc_enc__ofull       ;
  //
  logic                     b_nb_ldpc_enc__osop        ;
  logic                     b_nb_ldpc_enc__oval        ;
  logic                     b_nb_ldpc_enc__oeop        ;
  logic      [pDAT_W-1 : 0] b_nb_ldpc_enc__odat        ;
  logic      [pTAG_W-1 : 0] b_nb_ldpc_enc__otag        ;



  b_nb_ldpc_enc
  #(
    .pDAT_W        ( pDAT_W        ) ,
    .pTAG_W        ( pTAG_W        ) ,
    //
    .pBCNV_MAX_IDX ( pBCNV_MAX_IDX )
  )
  b_nb_ldpc_enc
  (
    .iclk        ( b_nb_ldpc_enc__iclk        ) ,
    .ireset      ( b_nb_ldpc_enc__ireset      ) ,
    //
    .icode_idx   ( b_nb_ldpc_enc__icode_idx   ) ,
    //
    .iclkin      ( b_nb_ldpc_enc__iclkin      ) ,
    //
    .isop        ( b_nb_ldpc_enc__isop        ) ,
    .ival        ( b_nb_ldpc_enc__ival        ) ,
    .ieop        ( b_nb_ldpc_enc__ieop        ) ,
    .idat        ( b_nb_ldpc_enc__idat        ) ,
    .itag        ( b_nb_ldpc_enc__itag        ) ,
    //
    .ordy        ( b_nb_ldpc_enc__ordy        ) ,
    .obusy       ( b_nb_ldpc_enc__obusy       ) ,
    .osource_err ( b_nb_ldpc_enc__osource_err ) ,
    //
    .iclkout     ( b_nb_ldpc_enc__iclkout     ) ,
    .ireq        ( b_nb_ldpc_enc__ireq        ) ,
    .ofull       ( b_nb_ldpc_enc__ofull       ) ,
    //
    .osop        ( b_nb_ldpc_enc__osop        ) ,
    .oval        ( b_nb_ldpc_enc__oval        ) ,
    .oeop        ( b_nb_ldpc_enc__oeop        ) ,
    .odat        ( b_nb_ldpc_enc__odat        ) ,
    .otag        ( b_nb_ldpc_enc__otag        )
  );


  assign b_nb_ldpc_enc__iclk      = '0 ;
  assign b_nb_ldpc_enc__ireset    = '0 ;
  assign b_nb_ldpc_enc__icode_idx = '0 ;
  assign b_nb_ldpc_enc__iclkin    = '0 ;
  assign b_nb_ldpc_enc__isop      = '0 ;
  assign b_nb_ldpc_enc__ival      = '0 ;
  assign b_nb_ldpc_enc__ieop      = '0 ;
  assign b_nb_ldpc_enc__idat      = '0 ;
  assign b_nb_ldpc_enc__itag      = '0 ;
  assign b_nb_ldpc_enc__iclkout   = '0 ;
  assign b_nb_ldpc_enc__ireq      = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_enc.svh
// Description   : encoder top level
//

module b_nb_ldpc_enc
#(
  parameter int pDAT_W        = 6 ,
  parameter int pTAG_W        = 8 ,
  //
  parameter int pBCNV_MAX_IDX = 3   // 0     - cBCNV1_SF3 only
                                    // 1     - cBCNV1_SF3/cBCNV1_SF2 only
                                    // other - cBCNV1_SF3/cBCNV1_SF2/cBCNV2/cBCNV3
)
(
  iclk        ,
  ireset      ,
  //
  icode_idx   ,
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
  otag
);

  `include "b_nb_ldpc_enc_types.svh"

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

  input  logic                    iclk        ;
  input  logic                    ireset      ;
  //
  input  code_idx_t               icode_idx   ;
  //
  input  logic                    iclkin      ;
  //
  input  logic                    isop        ;
  input  logic                    ival        ;
  input  logic                    ieop        ;
  input  logic     [pDAT_W-1 : 0] idat        ;
  input  logic     [pTAG_W-1 : 0] itag        ;
  //
  output logic                    ordy        ;
  output logic                    obusy       ;
  output logic                    osource_err ;
  //
  input  logic                    iclkout     ;
  input  logic                    ireq        ;
  output logic                    ofull       ;
  //
  output logic                    osop        ;
  output logic                    oval        ;
  output logic                    oeop        ;
  output logic     [pDAT_W-1 : 0] odat        ;
  output logic     [pTAG_W-1 : 0] otag        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cIBUF_ADDR_W = cLOG2_K_MAX;
  localparam int cIBUF_DAT_W  = $bits(gf_data_t);
  localparam int cIBUF_TAG_W  = $bits(code_idx_t) + pTAG_W;

  localparam int cOBUF_ADDR_W = cLOG2_N_MAX     ;
  localparam int cOBUF_DAT_W  = $bits(gf_data_t);
  localparam int cOBUF_TAG_W  = $bits(code_idx_t) + pTAG_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // source
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
  logic        [pTAG_W-1 : 0] source__owtag       ;

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

  // generation matrix table
  code_idx_t                  g_tab__icode_idx      ;
  //
  col_t                       g_tab__oused_col      ;
  col_t                       g_tab__oused_data_col ;
  row_t                       g_tab__oused_row      ;
  cycle_idx_t                 g_tab__ocycle_max_num ;
  //
  logic                       g_tab__idat_n_parity  ;
  //
  logic                       g_tab__icycle_read    ;
  cycle_idx_t                 g_tab__icycle_idx     ;
  //
  logic                       g_tab__oread          ;
  strb_t                      g_tab__orstrb         ;
  logic  [cIBUF_ADDR_W-1 : 0] g_tab__oraddr         ;
  gf_data_t                   g_tab__ogdat          ;

  // ctrl
  logic                       ctrl__ibuf_full      ;
  logic                       ctrl__obuf_rempty    ;
  logic                       ctrl__iobuf_empty    ;
  //
  code_idx_t                  ctrl__icode_idx      ;
  //
  row_t                       ctrl__iused_row      ;
  cycle_idx_t                 ctrl__icycle_max_num ;
  //
  logic                       ctrl__imac_busy      ;
  logic                       ctrl__imac_done      ;
  //
  code_idx_t                  ctrl__ocode_idx      ;
  logic                       ctrl__odat_n_parity  ;
  //
  logic                       ctrl__ocycle_read    ;
  cycle_idx_t                 ctrl__ocycle_idx     ;

  // mac unit
  logic                       mac__idat_n_parity ;
  //
  logic                       mac__ival          ;
  gf_data_t                   mac__idat          ;
  gf_data_t                   mac__igdat         ;
  strb_t                      mac__istrb         ;
  //
  logic                       mac__owrite        ;
  logic                       mac__owfull        ;
  gf_data_t                   mac__owdat         ;
  logic  [cOBUF_ADDR_W-1 : 0] mac__owaddr        ;

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
  // obusy CDC
  //------------------------------------------------------------------------------------------------------

  assign ordy         = source__ordy;
  assign obusy        = source__obusy;
  assign osource_err  = source__osource_err;

  //------------------------------------------------------------------------------------------------------
  // source
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_enc_source
  #(
    .pDAT_W  ( pDAT_W       ) ,
    .pADDR_W ( cIBUF_ADDR_W ) ,
    .pTAG_W  ( pTAG_W       )
  )
  source
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( 1'b1                ) ,
    //
    .icode_idx   ( icode_idx           ) ,
    //
    .isop        ( isop                ) ,
    .ival        ( ival & ordy         ) ,
    .ieop        ( ieop                ) ,
    .idat        ( idat                ) ,
    .itag        ( itag                ) ,
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

  assign source__ifulla  = ibuf__owfulla  ;
  assign source__iemptya = ibuf__owemptya ;

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
  assign ibuf__iwtag    = {source__ocode_idx, source__owtag};

  //
  assign ibuf__irempty  = ctrl__obuf_rempty ;

  assign ibuf__iraddr   = g_tab__oraddr ;

  //------------------------------------------------------------------------------------------------------
  // context unit
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_g_tab
  #(
    .pADDR_W       ( cIBUF_ADDR_W  ) ,
    .pBCNV_MAX_IDX ( pBCNV_MAX_IDX )
  )
  g_tab
  (
    .iclk           ( iclk                  ) ,
    .ireset         ( ireset                ) ,
    .iclkena        ( 1'b1                  ) ,
    //
    .icode_idx      ( g_tab__icode_idx      ) ,
    //
    .oused_col      ( g_tab__oused_col      ) ,
    .oused_data_col ( g_tab__oused_data_col ) ,
    .oused_row      ( g_tab__oused_row      ) ,
    .ocycle_max_num ( g_tab__ocycle_max_num ) ,
    //
    .idat_n_parity  ( g_tab__idat_n_parity  ) ,
    //
    .icycle_read    ( g_tab__icycle_read    ) ,
    .icycle_idx     ( g_tab__icycle_idx     ) ,
    //
    .oread          ( g_tab__oread          ) ,
    .orstrb         ( g_tab__orstrb         ) ,
    .oraddr         ( g_tab__oraddr         ) ,
    .ogdat          ( g_tab__ogdat          )
  );

  assign g_tab__icode_idx     = ctrl__ocode_idx;

  assign g_tab__idat_n_parity = ctrl__odat_n_parity;

  assign g_tab__icycle_read   = ctrl__ocycle_read ;
  assign g_tab__icycle_idx    = ctrl__ocycle_idx  ;

  //------------------------------------------------------------------------------------------------------
  // allign ibuf read delay (2 ticks)
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] g_tab_read;
  gf_data_t     g_tab_gdat [2];
  strb_t        g_tab_strb [2];

  logic         used_g_tab_read;
  gf_data_t     used_g_tab_gdat;
  strb_t        used_g_tab_strb;

  always_ff @(posedge iclk) begin
    g_tab_read <= (g_tab_read << 1) | g_tab__oread;
    //
    for (int i = 0; i < $size(g_tab_gdat); i++) begin
      g_tab_gdat[i] <= (i == 0) ? g_tab__ogdat  : g_tab_gdat[i-1];
      g_tab_strb[i] <= (i == 0) ? g_tab__orstrb : g_tab_strb[i-1];
    end
  end

  assign used_g_tab_read = g_tab_read[1];
  assign used_g_tab_gdat = g_tab_gdat[1];
  assign used_g_tab_strb = g_tab_strb[1];

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_enc_ctrl
  ctrl
  (
    .iclk           ( iclk                 ) ,
    .ireset         ( ireset               ) ,
    .iclkena        ( 1'b1                 ) ,
    //
    .ibuf_full      ( ctrl__ibuf_full      ) ,
    .obuf_rempty    ( ctrl__obuf_rempty    ) ,
    .iobuf_empty    ( ctrl__iobuf_empty    ) ,
    //
    .icode_idx      ( ctrl__icode_idx      ) ,
    //
    .iused_row      ( ctrl__iused_row      ) ,
    .icycle_max_num ( ctrl__icycle_max_num ) ,
    //
    .imac_busy      ( ctrl__imac_busy      ) ,
    .imac_done      ( ctrl__imac_done      ) ,
    //
    .ocode_idx      ( ctrl__ocode_idx      ) ,
    .odat_n_parity  ( ctrl__odat_n_parity  ) ,
    //
    .ocycle_read    ( ctrl__ocycle_read    ) ,
    .ocycle_idx     ( ctrl__ocycle_idx     )
  );

  assign ctrl__ibuf_full      = ibuf__orfull  ;
  assign ctrl__iobuf_empty    = obuf__owempty ;

  assign ctrl__icode_idx      = ibuf__ortag[cIBUF_TAG_W-1 : pTAG_W];

  assign ctrl__iused_row      = g_tab__oused_row ;
  assign ctrl__icycle_max_num = g_tab__ocycle_max_num ;

  assign ctrl__imac_busy      = mac__owrite ;
  assign ctrl__imac_done      = mac__owfull ;

  //------------------------------------------------------------------------------------------------------
  // mac unit
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_mac_unit
  #(
    .pADDR_W ( cOBUF_ADDR_W )
  )
  mac
  (
    .iclk          ( iclk               ) ,
    .ireset        ( ireset             ) ,
    .iclkena       ( 1'b1               ) ,
    //
    .idat_n_parity ( mac__idat_n_parity ) ,
    //
    .ival          ( mac__ival          ) ,
    .idat          ( mac__idat          ) ,
    .igdat         ( mac__igdat         ) ,
    .istrb         ( mac__istrb         ) ,
    //
    .owrite        ( mac__owrite        ) ,
    .owfull        ( mac__owfull        ) ,
    .owdat         ( mac__owdat         ) ,
    .owaddr        ( mac__owaddr        )
  );

  assign mac__idat_n_parity = ctrl__odat_n_parity ;

  assign mac__ival          = used_g_tab_read ;

  assign mac__idat          = ibuf__ordat ;

  assign mac__igdat         = used_g_tab_gdat ;
  assign mac__istrb         = used_g_tab_strb ;

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

  assign obuf__iwrite   = mac__owrite ;
  assign obuf__iwfull   = mac__owfull ;
  assign obuf__iwaddr   = mac__owaddr ;
  assign obuf__iwdat    = mac__owdat  ;

  always_ff @(posedge iclk) begin
    obuf__iwtag <= ibuf__ortag; // code index inside (!!!) can make simple here
  end

  assign obuf__irempty  = sink__orempty ;
  assign obuf__iraddr   = sink__oraddr ;

  //------------------------------------------------------------------------------------------------------
  // sink
  //------------------------------------------------------------------------------------------------------

  b_nb_ldpc_enc_sink
  #(
    .pADDR_W ( cOBUF_ADDR_W ) ,
    .pDAT_W  ( pDAT_W       ) ,
    .pTAG_W  ( pTAG_W       )
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

  assign sink__irfull       = obuf__orfull ;
  assign sink__irdat        = obuf__ordat ;

  assign {sink__icode_idx,
          sink__irtag}      = obuf__ortag ;

endmodule
