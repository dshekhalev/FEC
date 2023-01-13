/*



  parameter int pN_MAX    = 1024 ;
  parameter int pLLR_W    =    4 ;
  parameter int pTAG_W    =    4 ;
  parameter bit pUSE_CRC  =    1 ;



  logic                pc_3gpp_dec__iclk      ;
  logic                pc_3gpp_dec__ireset    ;
  logic                pc_3gpp_dec__iclkena   ;
  logic       [15 : 0] pc_3gpp_dec__idlen     ;
  logic                pc_3gpp_dec__isop      ;
  logic                pc_3gpp_dec__ival      ;
  logic                pc_3gpp_dec__ieop      ;
  logic [pTAG_W-1 : 0] pc_3gpp_dec__itag      ;
  logic [pLLR_W-1 : 0] pc_3gpp_dec__iLLR      ;
  logic                pc_3gpp_dec__ireq      ;
  logic                pc_3gpp_dec__ofull     ;
  logic                pc_3gpp_dec__ordy      ;
  logic                pc_3gpp_dec__obusy     ;
  logic                pc_3gpp_dec__osop      ;
  logic                pc_3gpp_dec__oval      ;
  logic                pc_3gpp_dec__oeop      ;
  logic                pc_3gpp_dec__odat      ;
  logic [pTAG_W-1 : 0] pc_3gpp_dec__otag      ;
  logic       [15 : 0] pc_3gpp_dec__oerr      ;
  logic                pc_3gpp_dec__ocrc_err  ;



  pc_3gpp_dec
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pLLR_W   ( pLLR_W   ) ,
    .pTAG_W   ( pTAG_W   ) ,
    .pUSE_CRC ( pUSE_CRC )
  )
  pc_3gpp_dec
  (
    .iclk     ( pc_3gpp_dec__iclk     ) ,
    .ireset   ( pc_3gpp_dec__ireset   ) ,
    .iclkena  ( pc_3gpp_dec__iclkena  ) ,
    .idlen    ( pc_3gpp_dec__idlen    ) ,
    .isop     ( pc_3gpp_dec__isop     ) ,
    .ival     ( pc_3gpp_dec__ival     ) ,
    .ieop     ( pc_3gpp_dec__ieop     ) ,
    .itag     ( pc_3gpp_dec__itag     ) ,
    .iLLR     ( pc_3gpp_dec__iLLR     ) ,
    .ordy     ( pc_3gpp_dec__ordy     ) ,
    .obusy    ( pc_3gpp_dec__obusy    ) ,
    .ireq     ( pc_3gpp_dec__ireq     ) ,
    .ofull    ( pc_3gpp_dec__ofull    ) ,
    .osop     ( pc_3gpp_dec__osop     ) ,
    .oval     ( pc_3gpp_dec__oval     ) ,
    .oeop     ( pc_3gpp_dec__oeop     ) ,
    .odat     ( pc_3gpp_dec__odat     ) ,
    .otag     ( pc_3gpp_dec__otag     ) ,
    .oerr     ( pc_3gpp_dec__oerr     ) ,
    .ocrc_err ( pc_3gpp_dec__ocrc_err )
  );


  assign pc_3gpp_dec__iclk    = '0 ;
  assign pc_3gpp_dec__ireset  = '0 ;
  assign pc_3gpp_dec__iclkena = '0 ;
  assign pc_3gpp_dec__idlen   = '0 ;
  assign pc_3gpp_dec__isop    = '0 ;
  assign pc_3gpp_dec__ival    = '0 ;
  assign pc_3gpp_dec__ieop    = '0 ;
  assign pc_3gpp_dec__idat    = '0 ;
  assign pc_3gpp_dec__itag    = '0 ;
  assign pc_3gpp_dec__iLLR    = '0 ;
  assing pc_3gpp_dec__ireq    = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec.sv
// Description   : PC 3GPP {1024, N} decoder without interleaving and with optional CRC5 check. Decoder based upon recursive realization
//

`include "define.vh"

module pc_3gpp_dec
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  idlen    ,
  //
  isop     ,
  ival     ,
  ieop     ,
  itag     ,
  iLLR     ,
  //
  ordy     ,
  obusy    ,
  //
  ireq     ,
  ofull    ,
  //
  osop     ,
  oval     ,
  oeop     ,
  odat     ,
  otag     ,
  //
  oerr     ,
  ocrc_err
);

  `include "pc_3gpp_dec_types.svh"

  parameter bit pUSE_CRC  = 0 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk      ;
  input  logic                ireset    ;
  input  logic                iclkena   ;
  //
  input  logic       [15 : 0] idlen     ;
  //
  input  logic                isop      ;
  input  logic                ival      ;
  input  logic                ieop      ;
  input  logic [pTAG_W-1 : 0] itag      ;
  input  logic [pLLR_W-1 : 0] iLLR      ;
  //
  output logic                ordy      ;
  output logic                obusy     ;
  //
  input  logic                ireq      ;
  output logic                ofull     ;
  //
  output logic                osop      ;
  output logic                oval      ;
  output logic                oeop      ;
  output logic                odat      ;
  output logic [pTAG_W-1 : 0] otag      ;
  //
  output logic       [15 : 0] oerr      ;
  output logic                ocrc_err  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cIBUF_TAG_W    = pTAG_W + cDLEN_W;
  localparam int cINT_BUF_TAG_W = pTAG_W + cDLEN_W + 16;

  typedef logic    [cIBUF_TAG_W-1 : 0] ibuf_tag_t;
  typedef logic [cINT_BUF_TAG_W-1 : 0] int_buf_tag_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source unit
  logic         source__owrite          ;
  logic         source__owfull          ;
  bit_addr_t    source__owLLR_addr      ;
  bit_addr_t    source__owLLR_frzb_addr ;
  bit_addr_t    source__owfrzb_addr     ;
  llr_t         source__owLLR           ;
  logic         source__owfrzb          ;
  tag_t         source__owtag           ;
  dlen_t        source__odlen           ;

  //
  // ibuf

  ibuf_tag_t    ibuf__iwtag       ;
  ibuf_tag_t    ibuf__ortag       ;

  logic         ibuf__oempty      ;
  logic         ibuf__oemptya     ;
  logic         ibuf__ofull       ;
  logic         ibuf__ofulla      ;

  //
  // engine
  dlen_t         engine__idlen                  ;

  logic          engine__isource_ram_full       ;
  llr_w_t        engine__isource_ram_rLLR       ;
  beta_w_dat_t   engine__isource_ram_rLLR_frzb  ;
  beta_w_dat_t   engine__isource_ram_rfrzb      ;
  tag_t          engine__isource_ram_rtag       ;
  logic          engine__osource_ram_remtpy     ;
  beta_w_addr_t  engine__osource_ram_rLLR_addr  ;
  beta_w_addr_t  engine__osource_ram_rfrzb_addr ;

  logic          engine__obusy                  ;

  logic          engine__isink_ram_empty        ;
  logic          engine__osink_ram_write        ;
  logic          engine__osink_ram_wfull        ;
  beta_w_addr_t  engine__osink_ram_waddr        ;
  beta_w_dat_t   engine__osink_ram_wdat         ;
  tag_t          engine__osink_ram_wtag         ;

  dlen_t         engine__odlen                  ;
  logic [15 : 0] engine__oerr                   ;

  //
  // int buf
  logic         int_buf__iwrite   ;
  logic         int_buf__iwfull   ;
  beta_w_addr_t int_buf__iwaddr   ;
  beta_w_dat_t  int_buf__iwdat    ;
  int_buf_tag_t int_buf__iwtag    ;

  logic         int_buf__oempty   ;
  logic         int_buf__oemptya  ;
  logic         int_buf__ofull    ;
  logic         int_buf__ofulla   ;

  //
  // reencode engine
  logic         enc__isource_ram_full   ;
  beta_w_dat_t  enc__isource_ram_rdat   ;
  int_buf_tag_t enc__isource_ram_rtag   ;
  logic         enc__osource_ram_remtpy ;
  beta_w_addr_t enc__osource_ram_raddr  ;

  logic         enc__obusy              ;

  logic         enc__isink_ram_empty    ;
  logic         enc__osink_ram_write    ;
  logic         enc__osink_ram_wfull    ;
  beta_w_addr_t enc__osink_ram_waddr    ;
  beta_w_dat_t  enc__osink_ram_wdat     ;
  int_buf_tag_t enc__osink_ram_wtag     ;

  //
  // obuf
  int_buf_tag_t obuf__ortag    ;

  logic         obuf__oempty   ;
  logic         obuf__oemptya  ;
  logic         obuf__ofull    ;
  logic         obuf__ofulla   ;

  //
  // sink
  dlen_t         sink__idlen    ;
  logic [15 : 0] sink__ierr     ;
  logic          sink__ifull    ;
  logic          sink__irdat    ;
  tag_t          sink__irtag    ;
  logic          sink__orempty  ;
  bit_addr_t     sink__oraddr   ;

  //------------------------------------------------------------------------------------------------------
  // source unit
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_source
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pLLR_W   ( pLLR_W   ) ,
    .pUSE_CRC ( pUSE_CRC ) ,
    .pTAG_W   ( pTAG_W   )
  )
  source
  (
    .iclk            ( iclk                    ) ,
    .ireset          ( ireset                  ) ,
    .iclkena         ( iclkena                 ) ,
    //
    .idlen           ( idlen                   ) ,
    //
    .isop            ( isop                    ) ,
    .ival            ( ival                    ) ,
    .ieop            ( ieop                    ) ,
    .iLLR            ( iLLR                    ) ,
    .itag            ( itag                    ) ,
    //
    .ordy            ( ordy                    ) ,
    .obusy           ( obusy                   ) ,
    //
    .ifulla          ( ibuf__ofulla            ) ,
    .iemptya         ( ibuf__oemptya           ) ,
    //
    .owrite          ( source__owrite          ) ,
    .owfull          ( source__owfull          ) ,
    .owLLR_addr      ( source__owLLR_addr      ) ,
    .owLLR_frzb_addr ( source__owLLR_frzb_addr ) ,
    .owfrzb_addr     ( source__owfrzb_addr     ) ,
    .owLLR           ( source__owLLR           ) ,
    .owfrzb          ( source__owfrzb          ) ,
    .owtag           ( source__owtag           ) ,
    //
    .odlen           ( source__odlen           )
  );

  //------------------------------------------------------------------------------------------------------
  // input buffer (1 [pLRR] -> pWORD_W[LLR]
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_ibuf
  #(
    .pWADDR_W ( cBIT_ADDR_W   ) ,
    .pRADDR_W ( cWORD_ADDR_W  ) ,
    //
    .pLLR_W   ( pLLR_W        ) ,
    .pWORD_W  ( pWORD_W       ) ,
    //
    .pTAG_W   ( cIBUF_TAG_W   ) ,
    //
    .pBNUM_W  ( 1             )
  )
  ibuf
  (
    .iclk            ( iclk                               ) ,
    .ireset          ( ireset                             ) ,
    .iclkena         ( iclkena                            ) ,
    //
    .iwrite          ( source__owrite                     ) ,
    .iwfull          ( source__owfull                     ) ,
    .iwLLR_addr      ( source__owLLR_addr                 ) ,
    .iwLLR_frzb_addr ( source__owLLR_frzb_addr            ) ,
    .iwfrzb_addr     ( source__owfrzb_addr                ) ,
    .iwLLR           ( source__owLLR                      ) ,
    .iwfrzb          ( source__owfrzb                     ) ,
    .iwtag           ( ibuf__iwtag                        ) ,
    //
    .irempty         ( engine__osource_ram_remtpy         ) ,
    .irLLR_addr      ( engine__osource_ram_rLLR_addr      ) ,
    .irfrzb_addr     ( engine__osource_ram_rfrzb_addr     ) ,
    .orLLR           ( engine__isource_ram_rLLR           ) ,
    .orLLR_frzb      ( engine__isource_ram_rLLR_frzb      ) ,
    .orfrzb          ( engine__isource_ram_rfrzb          ) ,
    .ortag           ( ibuf__ortag                        ) ,
    //
    .oempty          ( ibuf__oempty                       ) ,
    .oemptya         ( ibuf__oemptya                      ) ,
    .ofull           ( ibuf__ofull                        ) ,
    .ofulla          ( ibuf__ofulla                       )
  );

  assign ibuf__iwtag = {source__odlen, source__owtag};

  //------------------------------------------------------------------------------------------------------
  // decoder engine
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_sc_engine
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pLLR_W  ( pLLR_W  ) ,
    .pWORD_W ( pWORD_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  engine
  (
    .iclk                   ( iclk                           ) ,
    .ireset                 ( ireset                         ) ,
    .iclkena                ( iclkena                        ) ,
    //
    .idlen                  ( engine__idlen                  ) ,
    //
    .isource_ram_full       ( engine__isource_ram_full       ) ,
    .isource_ram_rLLR       ( engine__isource_ram_rLLR       ) ,
    .isource_ram_rLLR_frzb  ( engine__isource_ram_rLLR_frzb  ) ,
    .isource_ram_rfrzb      ( engine__isource_ram_rfrzb      ) ,
    .isource_ram_rtag       ( engine__isource_ram_rtag       ) ,
    .osource_ram_remtpy     ( engine__osource_ram_remtpy     ) ,
    .osource_ram_rLLR_addr  ( engine__osource_ram_rLLR_addr  ) ,
    .osource_ram_rfrzb_addr ( engine__osource_ram_rfrzb_addr ) ,
    //
    .obusy                  ( engine__obusy                  ) ,
    //
    .isink_ram_empty        ( engine__isink_ram_empty        ) ,
    .osink_ram_write        ( engine__osink_ram_write        ) ,
    .osink_ram_wfull        ( engine__osink_ram_wfull        ) ,
    .osink_ram_waddr        ( engine__osink_ram_waddr        ) ,
    .osink_ram_wdat         ( engine__osink_ram_wdat         ) ,
    .osink_ram_wtag         ( engine__osink_ram_wtag         ) ,
    //
    .odlen                  ( engine__odlen                  ) ,
    .oerr                   ( engine__oerr                   )
  );

  assign engine__isource_ram_full                  = ibuf__ofull;

  assign {engine__idlen, engine__isource_ram_rtag} = ibuf__ortag;

  assign engine__isink_ram_empty                   = int_buf__oempty;

  //------------------------------------------------------------------------------------------------------
  // intermediate buffer
  //------------------------------------------------------------------------------------------------------

  codec_buffer
  #(
    .pADDR_W ( cWORD_ADDR_W   ) ,
    .pDAT_W  ( pWORD_W        ) ,
    //
    .pTAG_W  ( cINT_BUF_TAG_W ) ,
    //
    .pBNUM_W ( 1              ) ,
    //
    .pPIPE   ( 0              )    // read delay 1 tick
  )
  int_buf
  (
    .iclk    ( iclk                    ) ,
    .ireset  ( ireset                  ) ,
    .iclkena ( iclkena                 ) ,
    //
    .iwrite  ( int_buf__iwrite         ) ,
    .iwfull  ( int_buf__iwfull         ) ,
    .iwaddr  ( int_buf__iwaddr         ) ,
    .iwdat   ( int_buf__iwdat          ) ,
    .iwtag   ( int_buf__iwtag          ) ,
    //
    .irempty ( enc__osource_ram_remtpy ) ,
    .iraddr  ( enc__osource_ram_raddr  ) ,
    .ordat   ( enc__isource_ram_rdat   ) ,
    .ortag   ( enc__isource_ram_rtag   ) ,
    //
    .oempty  ( int_buf__oempty         ) ,
    .oemptya ( int_buf__oemptya        ) ,
    .ofull   ( int_buf__ofull          ) ,
    .ofulla  ( int_buf__ofulla         )
  );

  assign int_buf__iwrite = engine__osink_ram_write;
  assign int_buf__iwfull = engine__osink_ram_wfull;
  assign int_buf__iwaddr = engine__osink_ram_waddr;
  assign int_buf__iwdat  = engine__osink_ram_wdat;
  assign int_buf__iwtag  = {engine__oerr, engine__odlen, engine__osink_ram_wtag};

  //------------------------------------------------------------------------------------------------------
  // reencode engine
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_enc_engine
  #(
    .pN_MAX  ( pN_MAX         ) ,
    .pWORD_W ( pWORD_W        ) ,
    .pTAG_W  ( cINT_BUF_TAG_W )
  )
  enc
  (
    .iclk               ( iclk                    ) ,
    .ireset             ( ireset                  ) ,
    .iclkena            ( iclkena                 ) ,
    //
    .isource_ram_full   ( enc__isource_ram_full   ) ,
    .isource_ram_rdat   ( enc__isource_ram_rdat   ) ,
    .isource_ram_rtag   ( enc__isource_ram_rtag   ) ,
    .osource_ram_remtpy ( enc__osource_ram_remtpy ) ,
    .osource_ram_raddr  ( enc__osource_ram_raddr  ) ,
    //
    .obusy              ( enc__obusy              ) ,
    //
    .isink_ram_empty    ( enc__isink_ram_empty    ) ,
    .osink_ram_write    ( enc__osink_ram_write    ) ,
    .osink_ram_wfull    ( enc__osink_ram_wfull    ) ,
    .osink_ram_waddr    ( enc__osink_ram_waddr    ) ,
    .osink_ram_wdat     ( enc__osink_ram_wdat     ) ,
    .osink_ram_wtag     ( enc__osink_ram_wtag     )
  );

  assign enc__isource_ram_full = int_buf__ofull;

  assign enc__isink_ram_empty  = obuf__oempty;

  //------------------------------------------------------------------------------------------------------
  // output buffer (engine pWORD_W -> 1)
  //------------------------------------------------------------------------------------------------------

  codec_buffer_dwc
  #(
    .pWADDR_W ( cWORD_ADDR_W   ) ,
    .pWDAT_W  ( pWORD_W        ) ,
    //
    .pRADDR_W ( cBIT_ADDR_W    ) ,
    .pRDAT_W  ( 1              ) ,
    //
    .pTAG_W   ( cINT_BUF_TAG_W ) ,
    .pBNUM_W  ( 1              ) ,  // 2D
    //
    .pPIPE    ( 0              )    // read delay 1 tick
  )
  obuf
  (
    .iclk    ( iclk                 ) ,
    .ireset  ( ireset               ) ,
    .iclkena ( iclkena              ) ,
    //
    .iwrite  ( enc__osink_ram_write ) ,
    .iwfull  ( enc__osink_ram_wfull ) ,
    .iwaddr  ( enc__osink_ram_waddr ) ,
    .iwdat   ( enc__osink_ram_wdat  ) ,
    .iwtag   ( enc__osink_ram_wtag  ) ,
    //
    .irempty ( sink__orempty        ) ,
    .iraddr  ( sink__oraddr         ) ,
    .ordat   ( sink__irdat          ) ,
    .ortag   ( obuf__ortag          ) ,
    //
    .oempty  ( obuf__oempty         ) ,
    .oemptya ( obuf__oemptya        ) ,
    .ofull   ( obuf__ofull          ) ,
    .ofulla  ( obuf__ofulla         )
  );

  //------------------------------------------------------------------------------------------------------
  // sink
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_sink
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pUSE_CRC ( pUSE_CRC ) ,
    .pTAG_W   ( pTAG_W   )
  )
  sink
  (
    .iclk     ( iclk          ) ,
    .ireset   ( ireset        ) ,
    .iclkena  ( iclkena       ) ,
    //
    .idlen    ( sink__idlen   ) ,
    .ierr     ( sink__ierr    ) ,
    //
    .ifull    ( sink__ifull   ) ,
    .irdat    ( sink__irdat   ) ,
    .irtag    ( sink__irtag   ) ,
    .orempty  ( sink__orempty ) ,
    .oraddr   ( sink__oraddr  ) ,
    //
    .ireq     ( ireq          ) ,
    .ofull    ( ofull         ) ,
    //
    .osop     ( osop          ) ,
    .oval     ( oval          ) ,
    .oeop     ( oeop          ) ,
    .odat     ( odat          ) ,
    .otag     ( otag          ) ,
    //
    .oerr     ( oerr          ) ,
    .ocrc_err ( ocrc_err      )
  );

  assign sink__ifull = obuf__ofull;

  assign {sink__ierr, sink__idlen, sink__irtag} = obuf__ortag;

endmodule
