/*



  parameter int pLLR_W  = 5 ;
  parameter int pEXTR_W = 6 ;



  logic           btc_dec_comp_code__iclk         ;
  logic           btc_dec_comp_code__ireset       ;
  logic           btc_dec_comp_code__iclkena      ;
  //
  logic           btc_dec_comp_code__istart       ;
  btc_code_mode_t btc_dec_comp_code__imode        ;
  //
  logic           btc_dec_comp_code__ival         ;
  strb_t          btc_dec_comp_code__istrb        ;
  logic           btc_dec_comp_code__ich_hd       ;
  extr_t          btc_dec_comp_code__iLapri       ;
  //
  logic           btc_dec_comp_code__oval         ;
  strb_t          btc_dec_comp_code__ostrb        ;
  extr_t          btc_dec_comp_code__oLextr       ;
  logic           btc_dec_comp_code__obitdat      ;
  logic           btc_dec_comp_code__obiterr      ;
  //
  logic           btc_dec_comp_code__odecfail     ;
  logic           btc_dec_comp_code__odecfail_val ;



  btc_dec_comp_code
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  btc_dec_comp_code
  (
    .iclk         ( btc_dec_comp_code__iclk         ) ,
    .ireset       ( btc_dec_comp_code__ireset       ) ,
    .iclkena      ( btc_dec_comp_code__iclkena      ) ,
    //
    .istart       ( btc_dec_comp_code__istart       ) ,
    .imode        ( btc_dec_comp_code__imode        ) ,
    //
    .ival         ( btc_dec_comp_code__ival         ) ,
    .istrb        ( btc_dec_comp_code__istrb        ) ,
    .ich_hd       ( btc_dec_comp_code__ich_hd       ) ,
    .iLapri       ( btc_dec_comp_code__iLapri       ) ,
    //
    .oval         ( btc_dec_comp_code__oval         ) ,
    .ostrb        ( btc_dec_comp_code__ostrb        ) ,
    .oLextr       ( btc_dec_comp_code__oLextr       ) ,
    .obitdat      ( btc_dec_comp_code__obitdat      ) ,
    .obiterr      ( btc_dec_comp_code__obiterr      ) ,
    //
    .odecfail     ( btc_dec_comp_code__odecfail     ) ,
    .odecfail_val ( btc_dec_comp_code__odecfail_val )
  );


  assign btc_dec_comp_code__iclk    = '0 ;
  assign btc_dec_comp_code__ireset  = '0 ;
  assign btc_dec_comp_code__iclkena = '0 ;
  assign btc_dec_comp_code__istart  = '0 ;
  assign btc_dec_comp_code__imode   = '0 ;
  assign btc_dec_comp_code__ival    = '0 ;
  assign btc_dec_comp_code__istrb   = '0 ;
  assign btc_dec_comp_code__ich_hd  = '0 ;
  assign btc_dec_comp_code__iLapri  = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code_engine.sv
// Description   : component code engine for soft decoding SPC & extended haming code
//

module btc_dec_comp_code_engine
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  istart       ,
  imode        ,
  //
  ival         ,
  istrb        ,
  ich_hd       ,
  iLapri       ,
  //
  oval         ,
  ostrb        ,
  oLextr       ,
  obitdat      ,
  obiterr      ,
  //
  odecfail     ,
  odecfail_val
);

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk         ;
  input  logic           ireset       ;
  input  logic           iclkena      ;
  // control interface
  input  logic           istart       ;
  input  btc_code_mode_t imode        ;
  // data interace
  input  logic           ival         ;
  input  strb_t          istrb        ;
  input  logic           ich_hd       ;
  input  extr_t          iLapri       ;
  // output lextr/bit decision interface
  output logic           oval         ;
  output strb_t          ostrb        ;
  output extr_t          oLextr       ;
  output logic           obitdat      ;
  output logic           obiterr      ;
  //
  output logic           odecfail     ;
  output logic           odecfail_val ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cHD_FIFO_DEPTH_W   = $bits(bit_idx_t) + 1; // twice
  localparam int cHD_FIFO_DAT_W     = 1 ;

  localparam int cLAPRI_MEM_ADDR_W  = $bits(bit_idx_t) + 1; // 2D
  localparam int cLAPRI_MEM_DAT_W   = pEXTR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // init sort
  logic                           init__oLapri_hd_val      ;
  logic                           init__oLapri_hd          ;
  //
  logic                           init__oLapri_write       ;
  logic                           init__oLapri_wptr        ;
  bit_idx_t                       init__oLapri_waddr       ;
  extr_t                          init__oLapri             ;
  //
  logic                           init__odone              ;
  strb_t                          init__ostrb              ;
  //
  logic                           init__oLapri_ptr         ;
  //
  bit_idx_t                       init__oLpp_idx       [4] ;
  extr_t                          init__oLpp_value     [4] ;
  //
  logic                           init__ospc_prod_sign     ;
  //
  state_t                         init__oham_syndrome      ;
  logic                           init__oham_even          ;
  bit_idx_t                       init__oham_err_idx       ;
  logic                           init__oham_decfail       ;

  //
  // hd fifo
  logic                           hd_fifo__iwrite  ;
  logic    [cHD_FIFO_DAT_W-1 : 0] hd_fifo__iwdat   ;
  //
  logic                           hd_fifo__iread   ;
  logic                           hd_fifo__orval   ;
  logic    [cHD_FIFO_DAT_W-1 : 0] hd_fifo__ordat   ;
  //
  logic                           hd_fifo__oempty  ;
  logic                           hd_fifo__ofull   ;

  //
  // Lapri hd fifo
  logic                           Lapri_fifo__iwrite  ;
  logic  [cLAPRI_MEM_DAT_W-1 : 0] Lapri_fifo__iwdat   ;
  //
  logic                           Lapri_fifo__iread   ;
  logic                           Lapri_fifo__orval   ;
  logic  [cLAPRI_MEM_DAT_W-1 : 0] Lapri_fifo__ordat   ;
  //
  logic                           Lapri_fifo__oempty  ;
  logic                           Lapri_fifo__ofull   ;

  //
  // Lapri mem
  logic                           Lapri_mem__iwrite   ;
  logic [cLAPRI_MEM_ADDR_W-1 : 0] Lapri_mem__iwaddr   ;
  logic  [cLAPRI_MEM_DAT_W-1 : 0] Lapri_mem__iwdat    ;
  //
  logic [cLAPRI_MEM_ADDR_W-1 : 0] Lapri_mem__iraddr   ;
  logic  [cLAPRI_MEM_DAT_W-1 : 0] Lapri_mem__ordat    ;

  //
  // spc decoder
  logic                           spc_dec__ival         ;
  strb_t                          spc_dec__istrb        ;
  logic                           spc_dec__iLapri_ptr   ;
  logic                           spc_dec__iprod_sign   ;
  extr_t                          spc_dec__imin0        ;
  bit_idx_t                       spc_dec__imin0_idx    ;
  extr_t                          spc_dec__imin1        ;
  //
  extr_t                          spc_dec__iLapri       ;
  logic                           spc_dec__oLapri_read  ;
  logic                           spc_dec__oLapri_rptr  ;
  bit_idx_t                       spc_dec__oLapri_raddr ;
  //
  logic                           spc_dec__opre_val     ;
  //
  logic                           spc_dec__oval         ;
  strb_t                          spc_dec__ostrb        ;
  extr_t                          spc_dec__oLextr       ;
  logic                           spc_dec__obitdat      ;
  //
  logic                           spc_dec__odecfail     ;
  logic                           spc_dec__odecfail_val ;

  //
  // haming fase chase
  logic                           eham_dec__ival               ;
  strb_t                          eham_dec__istrb              ;
  logic                           eham_dec__iLapri_ptr         ;
  bit_idx_t                       eham_dec__iLpp_idx       [4] ;
  extr_t                          eham_dec__iLpp_value     [4] ;
  state_t                         eham_dec__isyndrome          ;
  logic                           eham_dec__ieven              ;
  bit_idx_t                       eham_dec__ierr_idx           ;
  logic                           eham_dec__idecfail           ;
  //
  extr_t                          eham_dec__iLapri             ;
  logic                           eham_dec__oLapri_read        ;
  logic                           eham_dec__oLapri_rptr        ;
  bit_idx_t                       eham_dec__oLapri_raddr       ;
  //
  logic                           eham_dec__odone              ;
  strb_t                          eham_dec__ostrb              ;
  //
  metric_t                        eham_dec__omin0              ;
  logic                   [4 : 0] eham_dec__oerr0_bit_mask     ;
  bit_idx_t                       eham_dec__oerr0_bit_idx  [5] ;
  //
  metric_t                        eham_dec__omin1              ;
  logic                   [4 : 0] eham_dec__oerr1_bit_mask     ;
  bit_idx_t                       eham_dec__oerr1_bit_idx  [5] ;
  //
  metric_t                        eham_dec__omax               ;
  logic                   [4 : 0] eham_dec__oerrm_bit_mask     ;
  bit_idx_t                       eham_dec__oerrm_bit_idx  [5] ;
  //
  logic                           eham_dec__odecfail           ;

  //
  // haming decision
  btc_code_mode_t                 eham_decision__imode              ;
  logic                           eham_decision__ival               ;
  strb_t                          eham_decision__istrb              ;
  //
  metric_t                        eham_decision__imin0              ;
  logic                   [4 : 0] eham_decision__ierr0_bit_mask     ;
  bit_idx_t                       eham_decision__ierr0_bit_idx  [5] ;
  //
  metric_t                        eham_decision__imin1              ;
  logic                   [4 : 0] eham_decision__ierr1_bit_mask     ;
  bit_idx_t                       eham_decision__ierr1_bit_idx  [5] ;
  //
  metric_t                        eham_decision__imax               ;
  logic                   [4 : 0] eham_decision__ierrm_bit_mask     ;
  bit_idx_t                       eham_decision__ierrm_bit_idx  [5] ;
  //
  logic                           eham_decision__idecfail           ;
  //
  extr_t                          eham_decision__iLapri             ;
  logic                           eham_decision__oLapri_read        ;
  //
  logic                           eham_decision__opre_val           ;
  //
  logic                           eham_decision__oval               ;
  strb_t                          eham_decision__ostrb              ;
  extr_t                          eham_decision__oLextr             ;
  logic                           eham_decision__obitdat            ;
  //
  logic                           eham_decision__odecfail           ;
  logic                           eham_decision__odecfail_val       ;

  //------------------------------------------------------------------------------------------------------
  // input sort and pre decode unit
  //------------------------------------------------------------------------------------------------------

  btc_dec_spc_eham_init
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  init
  (
    .iclk           ( iclk                 ) ,
    .ireset         ( ireset               ) ,
    .iclkena        ( iclkena              ) ,
    //
    .imode          ( imode                ) ,
    //
    .ival           ( ival                 ) ,
    .istrb          ( istrb                ) ,
    .iLapri         ( iLapri               ) ,
    //
    .oLapri_hd_val  ( init__oLapri_hd_val  ) ,
    .oLapri_hd      ( init__oLapri_hd      ) ,
    //
    .oLapri_write   ( init__oLapri_write   ) ,
    .oLapri_wptr    ( init__oLapri_wptr    ) ,
    .oLapri_waddr   ( init__oLapri_waddr   ) ,
    .oLapri         ( init__oLapri         ) ,
    //
    .odone          ( init__odone          ) ,
    .ostrb          ( init__ostrb          ) ,
    //
    .oLapri_ptr     ( init__oLapri_ptr     ) ,
    //
    .oLpp_idx       ( init__oLpp_idx       ) ,
    .oLpp_value     ( init__oLpp_value     ) ,
    //
    .ospc_prod_sign ( init__ospc_prod_sign ) ,
    //
    .oham_syndrome  ( init__oham_syndrome  ) ,
    .oham_even      ( init__oham_even      ) ,
    .oham_err_idx   ( init__oham_err_idx   ) ,
    .oham_decfail   ( init__oham_decfail   )
  );

  //------------------------------------------------------------------------------------------------------
  // LLR hard decision FIFO
  //------------------------------------------------------------------------------------------------------

  codec_srl_fifo
  #(
    .pDEPTH_W ( cHD_FIFO_DEPTH_W ) ,
    .pDAT_W   ( cHD_FIFO_DAT_W   ) ,
    .pNO_REG  ( 0                )
  )
  hd_fifo
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iclear  ( istart           ) ,
    //
    .iwrite  ( hd_fifo__iwrite  ) ,
    .iwdat   ( hd_fifo__iwdat   ) ,
    //
    .iread   ( hd_fifo__iread   ) ,
    .orval   ( hd_fifo__orval   ) ,
    .ordat   ( hd_fifo__ordat   ) ,
    //
    .oempty  ( hd_fifo__oempty  ) ,
    .ofull   ( hd_fifo__ofull   )
  );

  assign hd_fifo__iwrite  = ival;
  assign hd_fifo__iwdat   = ich_hd;

  //------------------------------------------------------------------------------------------------------
  // Lapri hard decision FIFO
  //------------------------------------------------------------------------------------------------------

  codec_srl_fifo
  #(
    .pDEPTH_W ( cHD_FIFO_DEPTH_W ) ,
    .pDAT_W   ( cLAPRI_MEM_DAT_W ) ,
    .pNO_REG  ( 0                )
  )
  Lapri_fifo
  (
    .iclk    ( iclk                ) ,
    .ireset  ( ireset              ) ,
    .iclkena ( iclkena             ) ,
    //
    .iclear  ( istart              ) ,
    //
    .iwrite  ( Lapri_fifo__iwrite  ) ,
    .iwdat   ( Lapri_fifo__iwdat   ) ,
    //
    .iread   ( Lapri_fifo__iread   ) ,
    .orval   ( Lapri_fifo__orval   ) ,
    .ordat   ( Lapri_fifo__ordat   ) ,
    //
    .oempty  ( Lapri_fifo__oempty  ) ,
    .ofull   ( Lapri_fifo__ofull   )
  );

  assign Lapri_fifo__iwrite  = ival & (imode.code_type == cE_HAM_CODE);
  assign Lapri_fifo__iwdat   = iLapri ;

  //------------------------------------------------------------------------------------------------------
  // Lapri mem
  //------------------------------------------------------------------------------------------------------

  btc_dec_mem
  #(
    .pADDR_W ( cLAPRI_MEM_ADDR_W ) ,
    .pDAT_W  ( cLAPRI_MEM_DAT_W  ) ,
    .pNO_REG ( 0                 )
  )
  Lapri_mem
  (
    .iclk    ( iclk               ) ,
    .ireset  ( ireset             ) ,
    .iclkena ( iclkena            ) ,
    //
    .iwrite  ( Lapri_mem__iwrite  ) ,
    .iwaddr  ( Lapri_mem__iwaddr  ) ,
    .iwdat   ( Lapri_mem__iwdat   ) ,
    //
    .iraddr  ( Lapri_mem__iraddr  ) ,
    .ordat   ( Lapri_mem__ordat   )
  );

  assign Lapri_mem__iwrite =  init__oLapri_write;
  assign Lapri_mem__iwaddr = {init__oLapri_wptr, init__oLapri_waddr};
  assign Lapri_mem__iwdat  =  init__oLapri;

  assign Lapri_mem__iraddr = (imode.code_type == cSPC_CODE) ? {spc_dec__oLapri_rptr, spc_dec__oLapri_raddr} :
                                                              {eham_dec__oLapri_rptr, eham_dec__oLapri_raddr} ;

  //------------------------------------------------------------------------------------------------------
  // SPC decoder
  //------------------------------------------------------------------------------------------------------

  btc_dec_spc_decode
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  spc_dec
  (
    .iclk         ( iclk                  ) ,
    .ireset       ( ireset                ) ,
    .iclkena      ( iclkena               ) ,
    //
    .imode        ( imode                 ) ,
    //
    .ival         ( spc_dec__ival         ) ,
    .istrb        ( spc_dec__istrb        ) ,
    .iLapri_ptr   ( spc_dec__iLapri_ptr   ) ,
    .iprod_sign   ( spc_dec__iprod_sign   ) ,
    .imin0        ( spc_dec__imin0        ) ,
    .imin0_idx    ( spc_dec__imin0_idx    ) ,
    .imin1        ( spc_dec__imin1        ) ,
    //
    .iLapri       ( spc_dec__iLapri       ) ,
    .oLapri_read  ( spc_dec__oLapri_read  ) ,
    .oLapri_rptr  ( spc_dec__oLapri_rptr  ) ,
    .oLapri_raddr ( spc_dec__oLapri_raddr ) ,
    //
    .opre_val     ( spc_dec__opre_val     ) ,
    //
    .oval         ( spc_dec__oval         ) ,
    .ostrb        ( spc_dec__ostrb        ) ,
    .oLextr       ( spc_dec__oLextr       ) ,
    .obitdat      ( spc_dec__obitdat      ) ,
    //
    .odecfail     ( spc_dec__odecfail     ) ,
    .odecfail_val ( spc_dec__odecfail_val )
  );

  assign spc_dec__ival       = init__odone & (imode.code_type == cSPC_CODE);
  assign spc_dec__istrb      = init__ostrb ;

  assign spc_dec__iLapri_ptr = init__oLapri_ptr ;

  assign spc_dec__iprod_sign = init__ospc_prod_sign ;
  assign spc_dec__imin0      = init__oLpp_value [0] ;
  assign spc_dec__imin0_idx  = init__oLpp_idx   [0] ;
  assign spc_dec__imin1      = init__oLpp_value [1] ;

  assign spc_dec__iLapri     = Lapri_mem__ordat ;

  //------------------------------------------------------------------------------------------------------
  // FAST extended Hamming Chase decoder
  //------------------------------------------------------------------------------------------------------

  btc_dec_eham_fchase
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  eham_dec
  (
    .iclk           ( iclk                     ) ,
    .ireset         ( ireset                   ) ,
    .iclkena        ( iclkena                  ) ,
    //
    .imode          ( imode                    ) ,
    //
    .ival           ( eham_dec__ival           ) ,
    .istrb          ( eham_dec__istrb          ) ,
    .iLapri_ptr     ( eham_dec__iLapri_ptr     ) ,
    .iLpp_idx       ( eham_dec__iLpp_idx       ) ,
    .iLpp_value     ( eham_dec__iLpp_value     ) ,
    .isyndrome      ( eham_dec__isyndrome      ) ,
    .ieven          ( eham_dec__ieven          ) ,
    .ierr_idx       ( eham_dec__ierr_idx       ) ,
    .idecfail       ( eham_dec__idecfail       ) ,
    //
    .iLapri         ( eham_dec__iLapri         ) ,
    .oLapri_read    ( eham_dec__oLapri_read    ) ,
    .oLapri_rptr    ( eham_dec__oLapri_rptr    ) ,
    .oLapri_raddr   ( eham_dec__oLapri_raddr   ) ,
    //
    .odone          ( eham_dec__odone          ) ,
    .ostrb          ( eham_dec__ostrb          ) ,
    //
    .omin0          ( eham_dec__omin0          ) ,
    .oerr0_bit_mask ( eham_dec__oerr0_bit_mask ) ,
    .oerr0_bit_idx  ( eham_dec__oerr0_bit_idx  ) ,
    //
    .omin1          ( eham_dec__omin1          ) ,
    .oerr1_bit_mask ( eham_dec__oerr1_bit_mask ) ,
    .oerr1_bit_idx  ( eham_dec__oerr1_bit_idx  ) ,
    //
    .omax           ( eham_dec__omax           ) ,
    .oerrm_bit_mask ( eham_dec__oerrm_bit_mask ) ,
    .oerrm_bit_idx  ( eham_dec__oerrm_bit_idx  ) ,
    //
    .odecfail       ( eham_dec__odecfail       )
  );

  assign eham_dec__ival       = init__odone & (imode.code_type == cE_HAM_CODE);
  assign eham_dec__istrb      = init__ostrb ;

  assign eham_dec__iLapri_ptr = init__oLapri_ptr ;

  assign eham_dec__iLpp_idx   = init__oLpp_idx      ;
  assign eham_dec__iLpp_value = init__oLpp_value    ;
  assign eham_dec__isyndrome  = init__oham_syndrome ;
  assign eham_dec__ieven      = init__oham_even     ;
  assign eham_dec__ierr_idx   = init__oham_err_idx  ;
  assign eham_dec__idecfail   = init__oham_decfail  ;

  assign eham_dec__iLapri     = Lapri_mem__ordat ;

  //------------------------------------------------------------------------------------------------------
  // Hamming decision
  //------------------------------------------------------------------------------------------------------

  btc_dec_eham_decision
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  eham_decision
  (
    .iclk           ( iclk                          ) ,
    .ireset         ( ireset                        ) ,
    .iclkena        ( iclkena                       ) ,
    //
    .imode          ( imode                         ) ,
    //
    .ival           ( eham_decision__ival           ) ,
    .istrb          ( eham_decision__istrb          ) ,
    //
    .imin0          ( eham_decision__imin0          ) ,
    .ierr0_bit_mask ( eham_decision__ierr0_bit_mask ) ,
    .ierr0_bit_idx  ( eham_decision__ierr0_bit_idx  ) ,
    //
    .imin1          ( eham_decision__imin1          ) ,
    .ierr1_bit_mask ( eham_decision__ierr1_bit_mask ) ,
    .ierr1_bit_idx  ( eham_decision__ierr1_bit_idx  ) ,
    //
    .imax           ( eham_decision__imax           ) ,
    .ierrm_bit_mask ( eham_decision__ierrm_bit_mask ) ,
    .ierrm_bit_idx  ( eham_decision__ierrm_bit_idx  ) ,
    //
    .idecfail       ( eham_decision__idecfail       ) ,
    //
    .iLapri         ( eham_decision__iLapri         ) ,
    .oLapri_read    ( eham_decision__oLapri_read    ) ,
    //
    .opre_val       ( eham_decision__opre_val       ) ,
    //
    .oval           ( eham_decision__oval           ) ,
    .ostrb          ( eham_decision__ostrb          ) ,
    .oLextr         ( eham_decision__oLextr         ) ,
    .obitdat        ( eham_decision__obitdat        ) ,
    //
    .odecfail       ( eham_decision__odecfail       ) ,
    .odecfail_val   ( eham_decision__odecfail_val   )
  );

  assign eham_decision__ival           = eham_dec__odone          ;
  assign eham_decision__istrb          = eham_dec__ostrb          ;

  assign eham_decision__imin0          = eham_dec__omin0          ;
  assign eham_decision__ierr0_bit_mask = eham_dec__oerr0_bit_mask ;
  assign eham_decision__ierr0_bit_idx  = eham_dec__oerr0_bit_idx  ;

  assign eham_decision__imin1          = eham_dec__omin1          ;
  assign eham_decision__ierr1_bit_mask = eham_dec__oerr1_bit_mask ;
  assign eham_decision__ierr1_bit_idx  = eham_dec__oerr1_bit_idx  ;

  assign eham_decision__imax           = eham_dec__omax           ;
  assign eham_decision__ierrm_bit_mask = eham_dec__oerrm_bit_mask ;
  assign eham_decision__ierrm_bit_idx  = eham_dec__oerrm_bit_idx  ;

  assign eham_decision__idecfail       = eham_dec__odecfail       ;

  assign eham_decision__iLapri         = Lapri_fifo__ordat;

  assign Lapri_fifo__iread             = eham_decision__oLapri_read;

  //------------------------------------------------------------------------------------------------------
  // output mapping. hd FIFO read latency is 1 tick (!!!)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval          <= 1'b0;
      odecfail_val  <= 1'b0;
    end
    else if (iclkena) begin
      oval          <= (imode.code_type == cSPC_CODE) ? spc_dec__oval         : eham_decision__oval;
      odecfail_val  <= (imode.code_type == cSPC_CODE) ? spc_dec__odecfail_val : eham_decision__odecfail_val;
    end
  end

  assign hd_fifo__iread = (imode.code_type == cSPC_CODE) ? spc_dec__opre_val : eham_decision__opre_val;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (imode.code_type == cSPC_CODE) begin
        ostrb     <= spc_dec__ostrb  ;
        oLextr    <= spc_dec__oLextr ;
        obitdat   <= spc_dec__obitdat;
        obiterr   <= spc_dec__obitdat ^ hd_fifo__ordat;
        odecfail  <= spc_dec__odecfail;
      end
      else begin
        ostrb     <= eham_decision__ostrb  ;
        oLextr    <= eham_decision__oLextr ;
        obitdat   <= eham_decision__obitdat;
        obiterr   <= eham_decision__obitdat ^ hd_fifo__ordat;
        odecfail  <= eham_decision__odecfail;
      end
    end
  end

endmodule
