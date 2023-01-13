/*


  parameter int pN_MAX    =     1024 ;
  parameter int pDATA_N   = pN_MAX/2 ;
  parameter int pTAG_W    =        4 ;
  parameter int pODAT_W   =        1 ;
  parameter bit pUSE_CRC  =        0 ;


  logic                 pc_3gpp_enc__iclk     ;
  logic                 pc_3gpp_enc__ireset   ;
  logic                 pc_3gpp_enc__iclkena  ;
  logic                 pc_3gpp_enc__isop     ;
  logic                 pc_3gpp_enc__ival     ;
  logic                 pc_3gpp_enc__ieop     ;
  logic                 pc_3gpp_enc__idat     ;
  logic  [pTAG_W-1 : 0] pc_3gpp_enc__itag     ;
  logic                 pc_3gpp_enc__ordy     ;
  logic                 pc_3gpp_enc__obusy    ;
  logic                 pc_3gpp_enc__ireq     ;
  logic                 pc_3gpp_enc__ofull    ;
  logic                 pc_3gpp_enc__obusy    ;
  logic                 pc_3gpp_enc__osop     ;
  logic                 pc_3gpp_enc__oval     ;
  logic                 pc_3gpp_enc__oeop     ;
  logic [pODAT_W-1 : 0] pc_3gpp_enc__odat     ;
  logic  [pTAG_W-1 : 0] pc_3gpp_enc__otag     ;



  pc_3gpp_enc
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pDATA_N  ( pDATA_N  ) ,
    .pTAG_W   ( pTAG_W   ) ,
    .pODAT_W  ( pODAT_W  ) ,
    .pUSE_CRC ( pUSE_CRC )
  )
  pc_3gpp_enc
  (
    .iclk    ( pc_3gpp_enc__iclk    ) ,
    .ireset  ( pc_3gpp_enc__ireset  ) ,
    .iclkena ( pc_3gpp_enc__iclkena ) ,
    .isop    ( pc_3gpp_enc__isop    ) ,
    .ival    ( pc_3gpp_enc__ival    ) ,
    .ieop    ( pc_3gpp_enc__ieop    ) ,
    .idat    ( pc_3gpp_enc__idat    ) ,
    .itag    ( pc_3gpp_enc__itag    ) ,
    .ordy    ( pc_3gpp_enc__ordy    ) ,
    .obusy   ( pc_3gpp_enc__obusy   ) ,
    .ireq    ( pc_3gpp_enc__ireq    ) ,
    .ofull   ( pc_3gpp_enc__ofull   ) ,
    .obusy   ( pc_3gpp_enc__obusy   ) ,
    .osop    ( pc_3gpp_enc__osop    ) ,
    .oval    ( pc_3gpp_enc__oval    ) ,
    .oeop    ( pc_3gpp_enc__oeop    ) ,
    .odat    ( pc_3gpp_enc__odat    ) ,
    .otag    ( pc_3gpp_enc__otag    )
  );


  assign pc_3gpp_enc__iclk    = '0 ;
  assign pc_3gpp_enc__ireset  = '0 ;
  assign pc_3gpp_enc__iclkena = '0 ;
  assign pc_3gpp_enc__isop    = '0 ;
  assign pc_3gpp_enc__ival    = '0 ;
  assign pc_3gpp_enc__ieop    = '0 ;
  assign pc_3gpp_enc__idat    = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_enc.sv
// Description   : PC 3GPP {1024, N} encoder without interleaving and with optional CRC5. Encoder based upon recursive realization
//                 The encoder has DWC support at ouptut and output word size can be multile of 8
//


module pc_3gpp_enc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
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
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  otag
);

  `include "pc_3gpp_enc_types.svh"

  parameter int pODAT_W   = 1 ; // 1/2/4/8
  parameter bit pUSE_CRC  = 0 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk    ;
  input  logic                 ireset  ;
  input  logic                 iclkena ;
  //
  input  logic                 isop    ;
  input  logic                 ival    ;
  input  logic                 ieop    ;
  input  logic                 idat    ;
  input  logic  [pTAG_W-1 : 0] itag    ;
  // input handshake
  output logic                 ordy    ;
  output logic                 obusy   ;
  // output "handshake"
  input  logic                 ireq    ;
  output logic                 ofull   ;
  //
  output logic                 osop    ;
  output logic                 oval    ;
  output logic                 oeop    ;
  output logic [pODAT_W-1 : 0] odat    ;
  output logic  [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cOBUF_RADDR_W  = cWORD_ADDR_W + $clog2(pWORD_W/pODAT_W);
  localparam int cOBUF_RDAT_W   = pODAT_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // source
  logic         source__owrite  ;
  logic         source__owfull  ;
  bit_addr_t    source__owaddr  ;
  logic         source__owdat   ;
  tag_t         source__owtag   ;

  //
  // ibuf
  logic         ibuf__oempty    ;
  logic         ibuf__oemptya   ;
  logic         ibuf__ofull     ;
  logic         ibuf__ofulla    ;

  //
  // engine
  logic         engine__isource_ram_full   ;
  beta_w_dat_t  engine__isource_ram_rdat   ;
  tag_t         engine__isource_ram_rtag   ;
  logic         engine__osource_ram_remtpy ;
  beta_w_addr_t engine__osource_ram_raddr  ;

  logic         engine__obusy              ;

  logic         engine__isink_ram_empty    ;
  logic         engine__osink_ram_write    ;
  logic         engine__osink_ram_wfull    ;
  beta_w_addr_t engine__osink_ram_waddr    ;
  beta_w_dat_t  engine__osink_ram_wdat     ;
  tag_t         engine__osink_ram_wtag     ;

  //
  // out buff
  logic         obuf__oempty  ;
  logic         obuf__oemptya ;
  logic         obuf__ofull   ;
  logic         obuf__ofulla  ;

  //
  // sink
  logic                       sink__ifull    ;
  logic  [cOBUF_RDAT_W-1 : 0] sink__irdat    ;
  tag_t                       sink__irtag    ;
  logic                       sink__orempty  ;
  logic [cOBUF_RADDR_W-1 : 0] sink__oraddr   ;

  //------------------------------------------------------------------------------------------------------
  // source unit
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_enc_source
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pTAG_W   ( pTAG_W   ) ,
    .pUSE_CRC ( pUSE_CRC )
  )
  source
  (
    .iclk    ( iclk           ) ,
    .ireset  ( ireset         ) ,
    .iclkena ( iclkena        ) ,
    //
    .isop    ( isop           ) ,
    .ival    ( ival           ) ,
    .ieop    ( ieop           ) ,
    .idat    ( idat           ) ,
    .itag    ( itag           ) ,
    //
    .ordy    ( ordy           ) ,
    .obusy   ( obusy          ) ,
    //
    .ifulla  ( ibuf__ofulla   ) ,
    .iemptya ( ibuf__oemptya  ) ,
    //
    .owrite  ( source__owrite ) ,
    .owfull  ( source__owfull ) ,
    .owaddr  ( source__owaddr ) ,
    .owdat   ( source__owdat  ) ,
    .owtag   ( source__owtag  )
  );

  //------------------------------------------------------------------------------------------------------
  // input buffer (1 -> engine pWORD_W)
  //------------------------------------------------------------------------------------------------------

  codec_buffer_dwc
  #(
    .pWADDR_W ( cBIT_ADDR_W  ) ,
    .pWDAT_W  ( 1            ) ,
    //
    .pRADDR_W ( cWORD_ADDR_W ) ,
    .pRDAT_W  ( pWORD_W      ) ,
    //
    .pTAG_W   ( pTAG_W       ) ,
    .pBNUM_W  ( 1            ) ,  // 2D
    //
    .pPIPE    ( 0            )    // read delay 1 tick
  )
  ibuf
  (
    .iclk    ( iclk                       ) ,
    .ireset  ( ireset                     ) ,
    .iclkena ( iclkena                    ) ,
    //
    .iwrite  ( source__owrite             ) ,
    .iwfull  ( source__owfull             ) ,
    .iwaddr  ( source__owaddr             ) ,
    .iwdat   ( source__owdat              ) ,
    .iwtag   ( source__owtag              ) ,
    //
    .irempty ( engine__osource_ram_remtpy ) ,
    .iraddr  ( engine__osource_ram_raddr  ) ,
    .ordat   ( engine__isource_ram_rdat   ) ,
    .ortag   ( engine__isource_ram_rtag   ) ,
    //
    .oempty  ( ibuf__oempty               ) ,
    .oemptya ( ibuf__oemptya              ) ,
    .ofull   ( ibuf__ofull                ) ,
    .ofulla  ( ibuf__ofulla               )
  );

  //------------------------------------------------------------------------------------------------------
  // engine
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_enc_engine
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  engine
  (
    .iclk               ( iclk                       ) ,
    .ireset             ( ireset                     ) ,
    .iclkena            ( iclkena                    ) ,
    //
    .isource_ram_full   ( engine__isource_ram_full   ) ,
    .isource_ram_rdat   ( engine__isource_ram_rdat   ) ,
    .isource_ram_rtag   ( engine__isource_ram_rtag   ) ,
    .osource_ram_remtpy ( engine__osource_ram_remtpy ) ,
    .osource_ram_raddr  ( engine__osource_ram_raddr  ) ,
    //
    .obusy              ( engine__obusy              ) ,
    //
    .isink_ram_empty    ( engine__isink_ram_empty    ) ,
    .osink_ram_write    ( engine__osink_ram_write    ) ,
    .osink_ram_wfull    ( engine__osink_ram_wfull    ) ,
    .osink_ram_waddr    ( engine__osink_ram_waddr    ) ,
    .osink_ram_wdat     ( engine__osink_ram_wdat     ) ,
    .osink_ram_wtag     ( engine__osink_ram_wtag     )
  );

  assign engine__isource_ram_full = ibuf__ofull;

  assign engine__isink_ram_empty  = obuf__oempty;

  //------------------------------------------------------------------------------------------------------
  // output buffer (engine pWORD_W -> pODAT_W)
  //------------------------------------------------------------------------------------------------------

  codec_buffer_dwc
  #(
    .pWADDR_W ( cWORD_ADDR_W  ) ,
    .pWDAT_W  ( pWORD_W       ) ,
    //
    .pRADDR_W ( cOBUF_RADDR_W ) ,
    .pRDAT_W  ( cOBUF_RDAT_W  ) ,
    //
    .pTAG_W   ( pTAG_W       ) ,
    .pBNUM_W  ( 1            ) ,  // 2D
    //
    .pPIPE    ( 0            )    // read delay 1 tick
  )
  obuf
  (
    .iclk    ( iclk                    ) ,
    .ireset  ( ireset                  ) ,
    .iclkena ( iclkena                 ) ,
    //
    .iwrite  ( engine__osink_ram_write ) ,
    .iwfull  ( engine__osink_ram_wfull ) ,
    .iwaddr  ( engine__osink_ram_waddr ) ,
    .iwdat   ( engine__osink_ram_wdat  ) ,
    .iwtag   ( engine__osink_ram_wtag  ) ,
    //
    .irempty ( sink__orempty           ) ,
    .iraddr  ( sink__oraddr            ) ,
    .ordat   ( sink__irdat             ) ,
    .ortag   ( sink__irtag             ) ,
    //
    .oempty  ( obuf__oempty            ) ,
    .oemptya ( obuf__oemptya           ) ,
    .ofull   ( obuf__ofull             ) ,
    .ofulla  ( obuf__ofulla            )
  );

  //------------------------------------------------------------------------------------------------------
  // sink unit
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_enc_sink
  #(
    .pN_MAX  ( pN_MAX        ) ,
    .pADDR_W ( cOBUF_RADDR_W ) ,
    .pDAT_W  ( cOBUF_RDAT_W  ) ,
    .pTAG_W  ( pTAG_W        )
  )
  sink
  (
    .iclk    ( iclk          ) ,
    .ireset  ( ireset        ) ,
    .iclkena ( iclkena       ) ,
    //
    .ifull   ( sink__ifull   ) ,
    .irdat   ( sink__irdat   ) ,
    .irtag   ( sink__irtag   ) ,
    .orempty ( sink__orempty ) ,
    .oraddr  ( sink__oraddr  ) ,
    //
    .ireq    ( ireq          ) ,
    .ofull   ( ofull         ) ,
    //
    .osop    ( osop          ) ,
    .oval    ( oval          ) ,
    .oeop    ( oeop          ) ,
    .odat    ( odat          ) ,
    .otag    ( otag          )
  );

  assign sink__ifull = obuf__ofull;

endmodule
