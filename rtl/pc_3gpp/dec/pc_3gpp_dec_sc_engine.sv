/*



  parameter int pN_MAX   = 4 ;
  parameter int pLLR_W   = 4 ;
  parameter int pWORD_W  = 8 ;
  parameter int pTAG_W   = 4 ;



  logic         pc_3gpp_dec_sc_engine__iclk                   ;
  logic         pc_3gpp_dec_sc_engine__ireset                 ;
  logic         pc_3gpp_dec_sc_engine__iclkena                ;
  dlen_t        pc_3gpp_dec_sc_engine__idlen                  ;
  logic         pc_3gpp_dec_sc_engine__isource_ram_full       ;
  llr_w_t       pc_3gpp_dec_sc_engine__isource_ram_rLLR       ;
  beta_w_dat_t  pc_3gpp_dec_sc_engine__isource_ram_rLLR_frzb  ;
  beta_w_dat_t  pc_3gpp_dec_sc_engine__isource_ram_rfrzb      ;
  tag_t         pc_3gpp_dec_sc_engine__isource_ram_rtag       ;
  logic         pc_3gpp_dec_sc_engine__osource_ram_remtpy     ;
  beta_w_addr_t pc_3gpp_dec_sc_engine__osource_ram_rLLR_addr  ;
  beta_w_addr_t pc_3gpp_dec_sc_engine__osource_ram_rfrzb_addr ;
  logic         pc_3gpp_dec_sc_engine__obusy                  ;
  logic         pc_3gpp_dec_sc_engine__isink_ram_empty        ;
  logic         pc_3gpp_dec_sc_engine__osink_ram_write        ;
  logic         pc_3gpp_dec_sc_engine__osink_ram_wfull        ;
  beta_w_addr_t pc_3gpp_dec_sc_engine__osink_ram_waddr        ;
  beta_w_dat_t  pc_3gpp_dec_sc_engine__osink_ram_wdat         ;
  tag_t         pc_3gpp_dec_sc_engine__osink_ram_wtag         ;
  dlen_t        pc_3gpp_dec_sc_engine__odlen                  ;
  err_t         pc_3gpp_dec_sc_engine__oerr                   ;



  pc_3gpp_dec_sc_engine
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pLLR_W  ( pLLR_W  ) ,
    .pWORD_W ( pWORD_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  pc_3gpp_dec_sc_engine
  (
    .iclk                   ( pc_3gpp_dec_sc_engine__iclk                  ) ,
    .ireset                 ( pc_3gpp_dec_sc_engine__ireset                ) ,
    .iclkena                ( pc_3gpp_dec_sc_engine__iclkena               ) ,
    .idlen                  ( pc_3gpp_dec_sc_engine__idlen                 ) ,
    .isource_ram_full       ( pc_3gpp_dec_sc_engine__isourceram_full       ) ,
    .isource_ram_rLLR       ( pc_3gpp_dec_sc_engine__isourceram_rLLR       ) ,
    .isource_ram_rLLR_frzb  ( pc_3gpp_dec_sc_engine__isourceram_rLLR_frzb  ) ,
    .isource_ram_rfrzb      ( pc_3gpp_dec_sc_engine__isourceram_rfrzb      ) ,
    .isource_ram_rtag       ( pc_3gpp_dec_sc_engine__isourceram_rtag       ) ,
    .osource_ram_remtpy     ( pc_3gpp_dec_sc_engine__osourceram_remtpy     ) ,
    .osource_ram_rLLR_addr  ( pc_3gpp_dec_sc_engine__osourceram_rLLR_addr  ) ,
    .osource_ram_rfrzb_addr ( pc_3gpp_dec_sc_engine__osourceram_rfrzb_addr ) ,
    .obusy                  ( pc_3gpp_dec_sc_engine__obusy                 ) ,
    .isink_ram_empty        ( pc_3gpp_dec_sc_engine__isink_ram_empty       ) ,
    .osink_ram_write        ( pc_3gpp_dec_sc_engine__osink_ram_write       ) ,
    .osink_ram_wfull        ( pc_3gpp_dec_sc_engine__osink_ram_wfull       ) ,
    .osink_ram_waddr        ( pc_3gpp_dec_sc_engine__osink_ram_waddr       ) ,
    .osink_ram_wdat         ( pc_3gpp_dec_sc_engine__osink_ram_wdat        ) ,
    .osink_ram_wtag         ( pc_3gpp_dec_sc_engine__osink_ram_wtag        ) ,
    .odlen                  ( pc_3gpp_dec_sc_engine__odlen                 ) ,
    .oerr                   ( pc_3gpp_dec_sc_engine__oerr                  )
  );


  assign pc_3gpp_dec_sc_engine__iclk                  = '0 ;
  assign pc_3gpp_dec_sc_engine__ireset                = '0 ;
  assign pc_3gpp_dec_sc_engine__iclkena               = '0 ;
  assign pc_3gpp_dec_sc_engine__idlen                 = '0 ;
  assign pc_3gpp_dec_sc_engine__isource_ram_full      = '0 ;
  assign pc_3gpp_dec_sc_engine__isource_ram_rLLR      = '0 ;
  assign pc_3gpp_dec_sc_engine__isource_ram_rLLR_frzb = '0 ;
  assign pc_3gpp_dec_sc_engine__isource_ram_rfrzb     = '0 ;
  assign pc_3gpp_dec_sc_engine__isource_ram_rtag      = '0 ;
  assign pc_3gpp_dec_sc_engine__isource_ram_empty     = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_sc_engine.sv
// Description   : Polar deocder 2^10 successive canstellation decoder based upon recursive decoding
//

`include "define.vh"

module pc_3gpp_dec_sc_engine
(
  iclk                   ,
  ireset                 ,
  iclkena                ,
  //
  idlen                  ,
  //
  isource_ram_full       ,
  isource_ram_rLLR       ,
  isource_ram_rLLR_frzb  ,
  isource_ram_rfrzb      ,
  isource_ram_rtag       ,
  osource_ram_remtpy     ,
  osource_ram_rLLR_addr  ,
  osource_ram_rfrzb_addr ,
  //
  obusy                  ,
  //
  isink_ram_empty        ,
  osink_ram_write        ,
  osink_ram_wfull        ,
  osink_ram_waddr        ,
  osink_ram_wdat         ,
  osink_ram_wtag         ,
  //
  odlen                  ,
  oerr
);

  `include "pc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk                   ;
  input  logic          ireset                 ;
  input  logic          iclkena                ;
  //
  input  dlen_t         idlen                  ;
  //
  input  logic          isource_ram_full       ;
  input  llr_w_t        isource_ram_rLLR       ;
  input  beta_w_dat_t   isource_ram_rLLR_frzb  ;
  input  beta_w_dat_t   isource_ram_rfrzb      ;
  input  tag_t          isource_ram_rtag       ;
  output logic          osource_ram_remtpy     ;
  output beta_w_addr_t  osource_ram_rLLR_addr  ;
  output beta_w_addr_t  osource_ram_rfrzb_addr ;
  //
  output logic          obusy                  ;
  //
  input  logic          isink_ram_empty        ;
  output logic          osink_ram_write        ;
  output logic          osink_ram_wfull        ;
  output beta_w_addr_t  osink_ram_waddr        ;
  output beta_w_dat_t   osink_ram_wdat         ;
  output tag_t          osink_ram_wtag         ;
  //
  output dlen_t         odlen                  ;
  output err_t          oerr                   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // alpha ram
  logic           alpha_ram__iwrite ;
  alpha_w_addr_t  alpha_ram__iwaddr ;
  logic           alpha_ram__iwsel  ;
  alpha_hw_t      alpha_ram__iwdat  ;
  alpha_w_addr_t  alpha_ram__iraddr ;
  alpha_w_t       alpha_ram__ordat  ;

  //
  // beta ram
  logic           beta_ram__iwrite     ;
  beta_w_addr_t   beta_ram__iwaddr     ;
  logic           beta_ram__iwsel      ;
  beta_w_dat_t    beta_ram__iwdat      ;

  beta_w_addr_t   beta_ram__iraddr     ;
  beta_w_dat_t    beta_ram__ordat  [2] ;

  //
  // ctrl
  logic           ctrl__osink_ram_wfull ;

  beta_w_addr_t   ctrl__obeta_raddr     ;
  logic           ctrl__obeta_rsel      ;
  beta_w_addr_t   ctrl__obeta_waddr     ;
  logic           ctrl__obeta_wsel      ;

  alpha_w_addr_t  ctrl__oalpha_raddr    ;
  logic           ctrl__oalpha_rsel     ;
  alpha_w_addr_t  ctrl__oalpha_waddr    ;
  logic           ctrl__oalpha_wsel     ;

  beta_w_addr_t   ctrl__oaddr2write     ;

  alu_opcode_t    ctrl__oalu_opcode     ;

  logic           ctrl__obusy           ;

  //
  // alu
  alu_opcode_t    alu__iopcode          ;
  frozenb_type_t  alu__ofrzb_type       ;
  logic           alu__ofrzb_dec_done   ;

  llr_w_t         alu__iLLR             ;
  beta_w_dat_t    alu__ifrzb            ;

  beta_w_addr_t   alu__ibeta_raddr      ;
  logic           alu__ibeta_rsel       ;
  beta_w_dat_t    alu__ibeta_rdat   [2] ;
  beta_w_addr_t   alu__ibeta_waddr      ;
  logic           alu__ibeta_wsel       ;

  alpha_w_addr_t  alu__ialpha_raddr     ;
  logic           alu__ialpha_rsel      ;
  alpha_w_t       alu__ialpha_rdat      ;
  alpha_w_addr_t  alu__ialpha_waddr     ;
  logic           alu__ialpha_wsel      ;

  beta_w_addr_t   alu__iaddr2write      ;
  beta_w_dat_t    alu__ifrzb2write      ;
  logic           alu__ifull2write      ;

  logic           alu__obeta_write      ;
  beta_w_addr_t   alu__obeta_waddr      ;
  logic           alu__obeta_wsel       ;
  beta_w_dat_t    alu__obeta_wdat       ;

  logic           alu__oalpha_write     ;
  alpha_w_addr_t  alu__oalpha_waddr     ;
  logic           alu__oalpha_wsel      ;
  alpha_hw_t      alu__oalpha_wdat      ;

  logic           alu__owfull           ;
  logic           alu__owrite           ;
  beta_w_addr_t   alu__owaddr           ;
  beta_w_dat_t    alu__owdat            ;

  err_t           alu__oerr             ;

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_sc_ctrl
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W )
  )
  ctrl
  (
    .iclk                   ( iclk                   ) ,
    .ireset                 ( ireset                 ) ,
    .iclkena                ( iclkena                ) ,
    //
    .isource_ram_full       ( isource_ram_full       ) ,
    .osource_ram_rempty     ( osource_ram_remtpy     ) ,
    .osource_ram_rLLR_addr  ( osource_ram_rLLR_addr  ) ,
    .osource_ram_rfrzb_addr ( osource_ram_rfrzb_addr ) ,
    //
    .isink_ram_empty        ( isink_ram_empty        ) ,
    .osink_ram_wfull        ( ctrl__osink_ram_wfull  ) ,
    //
    .obeta_raddr            ( ctrl__obeta_raddr      ) ,
    .obeta_rsel             ( ctrl__obeta_rsel       ) ,
    .obeta_waddr            ( ctrl__obeta_waddr      ) ,
    .obeta_wsel             ( ctrl__obeta_wsel       ) ,
    //
    .oalpha_raddr           ( ctrl__oalpha_raddr     ) ,
    .oalpha_rsel            ( ctrl__oalpha_rsel      ) ,
    .oalpha_waddr           ( ctrl__oalpha_waddr     ) ,
    .oalpha_wsel            ( ctrl__oalpha_wsel      ) ,
    //
    .oaddr2write            ( ctrl__oaddr2write      ) ,
    //
    .ialu_frzb_type         ( alu__ofrzb_type        ) ,
    .ialu_frzb_dec_done     ( alu__ofrzb_dec_done    ) ,
    .oalu_opcode            ( ctrl__oalu_opcode      ) ,
    //
    .obusy                  ( obusy                  )
  );

  //------------------------------------------------------------------------------------------------------
  // alpha ram
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_alpha_ram
  #(
    .pADDR_W ( cWORD_ADDR_W ) ,
    .pDAT_W  ( cALPHA_W     ) ,
    //
    .pNUM    ( pWORD_W      ) ,
    //
    .pPIPE   ( 0            )
  )
  alpha_ram
  (
    .iclk    ( iclk               ) ,
    .ireset  ( ireset             ) ,
    .iclkena ( iclkena            ) ,
    //
    .iwrite  ( alpha_ram__iwrite  ) ,
    .iwaddr  ( alpha_ram__iwaddr  ) ,
    .iwsel   ( alpha_ram__iwsel   ) ,
    .iwdat   ( alpha_ram__iwdat   ) ,
    //
    .iraddr  ( alpha_ram__iraddr  ) ,
    .ordat   ( alpha_ram__ordat   )
  );

  assign alpha_ram__iwrite = alu__oalpha_write ;
  assign alpha_ram__iwaddr = alu__oalpha_waddr ;
  assign alpha_ram__iwsel  = alu__oalpha_wsel  ;
  assign alpha_ram__iwdat  = alu__oalpha_wdat  ;

  assign alpha_ram__iraddr = ctrl__oalpha_raddr;

  //------------------------------------------------------------------------------------------------------
  // beta ram
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_beta_ram
  #(
    .pADDR_W ( cWORD_ADDR_W ) ,
    .pDAT_W  ( pWORD_W      ) ,
    .pPIPE   ( 0            )
  )
  beta_ram
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( beta_ram__iwrite ) ,
    .iwaddr  ( beta_ram__iwaddr ) ,
    .iwsel   ( beta_ram__iwsel  ) ,
    .iwdat   ( beta_ram__iwdat  ) ,
    //
    .iraddr  ( beta_ram__iraddr ) ,
    .ordat   ( beta_ram__ordat  )
  );

  assign beta_ram__iwrite = alu__obeta_write ;
  assign beta_ram__iwaddr = alu__obeta_waddr ;
  assign beta_ram__iwsel  = alu__obeta_wsel  ;
  assign beta_ram__iwdat  = alu__obeta_wdat  ;

  assign beta_ram__iraddr = ctrl__obeta_raddr;

  //------------------------------------------------------------------------------------------------------
  // alu
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_alu
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pLLR_W  ( pLLR_W  ) ,
    .pWORD_W ( pWORD_W )
  )
  alu
  (
    .iclk           ( iclk                ) ,
    .ireset         ( ireset              ) ,
    .iclkena        ( iclkena             ) ,
    //
    .iopcode        ( alu__iopcode        ) ,
    .ofrzb_type     ( alu__ofrzb_type     ) ,
    .ofrzb_dec_done ( alu__ofrzb_dec_done ) ,
    //
    .iLLR           ( alu__iLLR           ) ,
    .ifrzb          ( alu__ifrzb          ) ,
    //
    .ibeta_raddr    ( alu__ibeta_raddr    ) ,
    .ibeta_rsel     ( alu__ibeta_rsel     ) ,
    .ibeta_rdat     ( alu__ibeta_rdat     ) ,
    .ibeta_waddr    ( alu__ibeta_waddr    ) ,
    .ibeta_wsel     ( alu__ibeta_wsel     ) ,
    //
    .ialpha_raddr   ( alu__ialpha_raddr   ) ,
    .ialpha_rsel    ( alu__ialpha_rsel    ) ,
    .ialpha_rdat    ( alu__ialpha_rdat    ) ,
    .ialpha_waddr   ( alu__ialpha_waddr   ) ,
    .ialpha_wsel    ( alu__ialpha_wsel    ) ,
    //
    .iaddr2write    ( alu__iaddr2write    ) ,
    .ifrzb2write    ( alu__ifrzb2write    ) ,
    .ifull2write    ( alu__ifull2write    ) ,
    //
    .obeta_write    ( alu__obeta_write    ) ,
    .obeta_waddr    ( alu__obeta_waddr    ) ,
    .obeta_wsel     ( alu__obeta_wsel     ) ,
    .obeta_wdat     ( alu__obeta_wdat     ) ,
    //
    .oalpha_write   ( alu__oalpha_write   ) ,
    .oalpha_waddr   ( alu__oalpha_waddr   ) ,
    .oalpha_wsel    ( alu__oalpha_wsel    ) ,
    .oalpha_wdat    ( alu__oalpha_wdat    ) ,
    //
    .owfull         ( alu__owfull         ) ,
    .owrite         ( alu__owrite         ) ,
    .owaddr         ( alu__owaddr         ) ,
    .owdat          ( alu__owdat          ) ,
    //
    .oerr           ( alu__oerr           )
  );

  assign alu__iLLR        = isource_ram_rLLR;

  assign alu__ifrzb       = isource_ram_rfrzb;

  assign alu__ibeta_rdat  = beta_ram__ordat;

  assign alu__ialpha_rdat = alpha_ram__ordat;

  assign alu__ifrzb2write = isource_ram_rLLR_frzb;

  // align ram delay
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      alu__iopcode      <= ctrl__oalu_opcode;
      //
      alu__ibeta_raddr  <= ctrl__obeta_raddr;
      alu__ibeta_rsel   <= ctrl__obeta_rsel ;
      alu__ibeta_waddr  <= ctrl__obeta_waddr;
      alu__ibeta_wsel   <= ctrl__obeta_wsel ;
      //
      alu__ialpha_raddr <= ctrl__oalpha_raddr;
      alu__ialpha_rsel  <= ctrl__oalpha_rsel ;
      alu__ialpha_waddr <= ctrl__oalpha_waddr;
      alu__ialpha_wsel  <= ctrl__oalpha_wsel ;
      //
      alu__iaddr2write  <= ctrl__oaddr2write;
      //
      alu__ifull2write  <= ctrl__osink_ram_wfull;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output buffer signals
  //------------------------------------------------------------------------------------------------------

  assign osink_ram_wfull = alu__owfull;
  assign osink_ram_write = alu__owrite;
  assign osink_ram_waddr = alu__owaddr;
  assign osink_ram_wdat  = alu__owdat;
  //
  assign oerr            = alu__oerr;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (osource_ram_remtpy) begin
        osink_ram_wtag  <= isource_ram_rtag;
        odlen           <= idlen;
      end
    end
  end

endmodule
