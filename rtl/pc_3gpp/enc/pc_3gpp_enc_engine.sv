/*



  parameter int pN_MAX   = 4 ;
  parameter int pADDR_W  = 8 ;
  parameter int pDAT_W   = 8 ;
  parameter int pTAG_W   = 4 ;



  logic         pc_3gpp_enc_engine__iclk               ;
  logic         pc_3gpp_enc_engine__ireset             ;
  logic         pc_3gpp_enc_engine__iclkena            ;
  logic         pc_3gpp_enc_engine__isource_ram_full   ;
  beta_w_dat_t  pc_3gpp_enc_engine__isource_ram_rdat   ;
  tag_t         pc_3gpp_enc_engine__isource_ram_rtag   ;
  logic         pc_3gpp_enc_engine__osource_ram_remtpy ;
  beta_w_addr_t pc_3gpp_enc_engine__osource_ram_raddr  ;
  logic         pc_3gpp_enc_engine__obusy              ;
  logic         pc_3gpp_enc_engine__isink_ram_empty    ;
  logic         pc_3gpp_enc_engine__osink_ram_write    ;
  logic         pc_3gpp_enc_engine__osink_ram_wfull    ;
  beta_w_addr_t pc_3gpp_enc_engine__osink_ram_waddr    ;
  beta_w_dat_t  pc_3gpp_enc_engine__osink_ram_wdat     ;
  tag_ts        pc_3gpp_enc_engine__osink_ram_wtag     ;



  pc_3gpp_enc_engine
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  pc_3gpp_enc_engine
  (
    .iclk               ( pc_3gpp_enc_engine__iclk               ) ,
    .ireset             ( pc_3gpp_enc_engine__ireset             ) ,
    .iclkena            ( pc_3gpp_enc_engine__iclkena            ) ,
    .isource_ram_full   ( pc_3gpp_enc_engine__isource_ram_full   ) ,
    .isource_ram_rdat   ( pc_3gpp_enc_engine__isource_ram_rdat   ) ,
    .isource_ram_rtag   ( pc_3gpp_enc_engine__isource_ram_rtag   ) ,
    .osource_ram_remtpy ( pc_3gpp_enc_engine__osource_ram_remtpy ) ,
    .osource_ram_raddr  ( pc_3gpp_enc_engine__osource_ram_raddr  ) ,
    .obusy              ( pc_3gpp_enc_engine__obusy              ) ,
    .isink_ram_empty    ( pc_3gpp_enc_engine__isink_ram_empty    ) ,
    .osink_ram_write    ( pc_3gpp_enc_engine__osink_ram_write    ) ,
    .osink_ram_wfull    ( pc_3gpp_enc_engine__osink_ram_wfull    ) ,
    .osink_ram_waddr    ( pc_3gpp_enc_engine__osink_ram_waddr    ) ,
    .osink_ram_wdat     ( pc_3gpp_enc_engine__osink_ram_wdat     ) ,
    .osink_ram_wtag     ( pc_3gpp_enc_engine__osink_ram_wtag     )
  );


  assign pc_3gpp_enc_engine__iclk             = '0 ;
  assign pc_3gpp_enc_engine__ireset           = '0 ;
  assign pc_3gpp_enc_engine__iclkena          = '0 ;
  assign pc_3gpp_enc_engine__isource_ram_full = '0 ;
  assign pc_3gpp_enc_engine__isource_ram_rdat = '0 ;
  assign pc_3gpp_enc_engine__isource_ram_rtag = '0 ;
  assign pc_3gpp_enc_engine__isink_ram_empty  = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_enc_engine.sv
// Description   : Recursive polar encoder itself. Take binary data from input nD buffer, encode and write encoded data to ouput nD buffer
//


module pc_3gpp_enc_engine
(
  iclk               ,
  ireset             ,
  iclkena            ,
  //
  isource_ram_full   ,
  isource_ram_rdat   ,
  isource_ram_rtag   ,
  osource_ram_remtpy ,
  osource_ram_raddr  ,
  //
  obusy              ,
  //
  isink_ram_empty    ,
  osink_ram_write    ,
  osink_ram_wfull    ,
  osink_ram_waddr    ,
  osink_ram_wdat     ,
  osink_ram_wtag
);

  `include "pc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk               ;
  input  logic          ireset             ;
  input  logic          iclkena            ;
  //
  input  logic          isource_ram_full   ;
  input  beta_w_dat_t   isource_ram_rdat   ;
  input  tag_t          isource_ram_rtag   ;
  output logic          osource_ram_remtpy ;
  output beta_w_addr_t  osource_ram_raddr  ;
  //
  output logic          obusy              ;
  //
  input  logic          isink_ram_empty    ;
  output logic          osink_ram_write    ;
  output logic          osink_ram_wfull    ;
  output beta_w_addr_t  osink_ram_waddr    ;
  output beta_w_dat_t   osink_ram_wdat     ;
  output tag_t          osink_ram_wtag     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // beta ram
  logic         beta_ram__iwrite     ;
  beta_w_addr_t beta_ram__iwaddr     ;
  logic         beta_ram__iwsel      ;
  beta_w_dat_t  beta_ram__iwdat      ;

  beta_w_addr_t beta_ram__iraddr     ;
  beta_w_dat_t  beta_ram__ordat  [2] ;

  //
  // ctrl
  logic         ctrl__isource_ram_full   ;
  logic         ctrl__osource_ram_rempty ;
  beta_w_addr_t ctrl__osource_ram_raddr  ;

  logic         ctrl__isink_ram_empty    ;
  logic         ctrl__osink_ram_wfull    ;

  beta_w_addr_t ctrl__obeta_raddr        ;
  logic         ctrl__obeta_rsel         ;
  beta_w_addr_t ctrl__obeta_waddr        ;
  logic         ctrl__obeta_wsel         ;
  alu_opcode_t  ctrl__oalu_opcode        ;

  logic         ctrl__obusy              ;

  //
  // alu
  alu_opcode_t  alu__iopcode         ;
  beta_w_dat_t  alu__idat            ;
  beta_w_addr_t alu__ibeta_raddr     ;
  logic         alu__ibeta_rsel      ;
  beta_w_dat_t  alu__ibeta_rdat  [2] ;

  beta_w_addr_t alu__iaddr2write     ;
  logic         alu__isel2write      ;
  logic         alu__ifull2write     ;

  logic         alu__obeta_write     ;
  beta_w_addr_t alu__obeta_waddr     ;
  logic         alu__obeta_wsel      ;
  beta_w_dat_t  alu__obeta_wdat      ;

  logic         alu__owfull          ;
  logic         alu__owrite          ;
  beta_w_addr_t alu__owaddr          ;
  beta_w_dat_t  alu__owdat           ;

  //------------------------------------------------------------------------------------------------------
  // main FSM
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_enc_ctrl
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W )
  )
  ctrl
  (
    .iclk               ( iclk                     ) ,
    .ireset             ( ireset                   ) ,
    .iclkena            ( iclkena                  ) ,
    //
    .isource_ram_full   ( ctrl__isource_ram_full   ) ,
    .osource_ram_rempty ( ctrl__osource_ram_rempty ) ,
    .osource_ram_raddr  ( ctrl__osource_ram_raddr  ) ,
    //
    .isink_ram_empty    ( ctrl__isink_ram_empty    ) ,
    .osink_ram_wfull    ( ctrl__osink_ram_wfull    ) ,
    //
    .obeta_raddr        ( ctrl__obeta_raddr        ) ,
    .obeta_rsel         ( ctrl__obeta_rsel         ) ,
    .obeta_waddr        ( ctrl__obeta_waddr        ) ,
    .obeta_wsel         ( ctrl__obeta_wsel         ) ,
    .oalu_opcode        ( ctrl__oalu_opcode        ) ,
    //
    .obusy              ( obusy                    )
  );

  assign ctrl__isource_ram_full = isource_ram_full;

  assign osource_ram_remtpy     = ctrl__osource_ram_rempty;
  assign osource_ram_raddr      = ctrl__osource_ram_raddr;

  assign ctrl__isink_ram_empty  = isink_ram_empty;

  //------------------------------------------------------------------------------------------------------
  // beta internal ram
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
  // ALU
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_enc_alu
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W )
  )
  alu
  (
    .iclk        ( iclk             ) ,
    .ireset      ( ireset           ) ,
    .iclkena     ( iclkena          ) ,
    //
    .iopcode     ( alu__iopcode     ) ,
    .idat        ( alu__idat        ) ,
    .ibeta_raddr ( alu__ibeta_raddr ) ,
    .ibeta_rsel  ( alu__ibeta_rsel  ) ,
    .ibeta_rdat  ( alu__ibeta_rdat  ) ,
    //
    .iaddr2write ( alu__iaddr2write ) ,
    .isel2write  ( alu__isel2write  ) ,
    .ifull2write ( alu__ifull2write ) ,
    //
    .obeta_write ( alu__obeta_write ) ,
    .obeta_waddr ( alu__obeta_waddr ) ,
    .obeta_wsel  ( alu__obeta_wsel  ) ,
    .obeta_wdat  ( alu__obeta_wdat  ) ,
    //
    .owfull      ( alu__owfull      ) ,
    .owrite      ( alu__owrite      ) ,
    .owaddr      ( alu__owaddr      ) ,
    .owdat       ( alu__owdat       )
  );

  assign alu__idat       = isource_ram_rdat;

  assign alu__ibeta_rdat = beta_ram__ordat;

  // align ram delay
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      alu__iopcode     <= ctrl__oalu_opcode;
      alu__ibeta_raddr <= ctrl__obeta_raddr;
      alu__ibeta_rsel  <= ctrl__obeta_rsel ;
      //
      alu__iaddr2write <= ctrl__obeta_waddr;
      alu__isel2write  <= ctrl__obeta_wsel;
      alu__ifull2write <= ctrl__osink_ram_wfull;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output buffer signals
  //------------------------------------------------------------------------------------------------------

  assign osink_ram_wfull = alu__owfull;
  assign osink_ram_write = alu__owrite;
  assign osink_ram_waddr = alu__owaddr;
  assign osink_ram_wdat  = alu__owdat;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ctrl__osink_ram_wfull) begin
        osink_ram_wtag <= isource_ram_rtag;
      end
    end
  end

endmodule
