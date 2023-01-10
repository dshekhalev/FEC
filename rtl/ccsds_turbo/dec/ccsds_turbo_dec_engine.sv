/*



  parameter int pLLR_W       = 5 ;
  parameter int pLLR_FP      = 3 ;
  parameter int pADDR_W      = 8 ;
  parameter int pMM_ADDR_W   = pADDR_W-1;
  parameter int pMMAX_TYPE   = 0 ;
  parameter bit pUSE_SC_MODE = 1 ;



  logic                       ccsds_turbo_dec_engine__iclk         ;
  logic                       ccsds_turbo_dec_engine__ireset       ;
  logic                       ccsds_turbo_dec_engine__iclkena      ;
  logic               [1 : 0] ccsds_turbo_dec_engine__icode        ;
  logic                       ccsds_turbo_dec_engine__ifirst       ;
  logic                       ccsds_turbo_dec_engine__ilast        ;
  logic                       ccsds_turbo_dec_engine__ieven        ;
  logic                       ccsds_turbo_dec_engine__iwarm        ;
  logic                       ccsds_turbo_dec_engine__isop         ;
  logic                       ccsds_turbo_dec_engine__ival         ;
  logic                       ccsds_turbo_dec_engine__ieop         ;
  logic                       ccsds_turbo_dec_engine__ifterm       ;
  logic       [pADDR_W-1 : 0] ccsds_turbo_dec_engine__ifaddr       ;
  bit_llr_t                   ccsds_turbo_dec_engine__ifsLLR       ;
  bit_llr_t                   ccsds_turbo_dec_engine__ifa0LLR  [3] ;
  bit_llr_t                   ccsds_turbo_dec_engine__ifa1LLR  [3] ;
  Lextr_t                     ccsds_turbo_dec_engine__ifLextr      ;
  logic                       ccsds_turbo_dec_engine__ibterm       ;
  logic       [pADDR_W-1 : 0] ccsds_turbo_dec_engine__ibaddr       ;
  bit_llr_t                   ccsds_turbo_dec_engine__ibsLLR       ;
  bit_llr_t                   ccsds_turbo_dec_engine__iba0LLR  [3] ;
  bit_llr_t                   ccsds_turbo_dec_engine__iba1LLR  [3] ;
  Lextr_t                     ccsds_turbo_dec_engine__ibLextr      ;
  logic                       ccsds_turbo_dec_engine__osop         ;
  logic                       ccsds_turbo_dec_engine__oeop         ;
  logic                       ccsds_turbo_dec_engine__oval         ;
  logic                       ccsds_turbo_dec_engine__odatval      ;
  logic       [pADDR_W-1 : 0] ccsds_turbo_dec_engine__ofaddr       ;
  Lextr_t                     ccsds_turbo_dec_engine__ofLextr      ;
  logic                       ccsds_turbo_dec_engine__ofdat        ;
  logic       [pADDR_W-1 : 0] ccsds_turbo_dec_engine__obaddr       ;
  Lextr_t                     ccsds_turbo_dec_engine__obLextr      ;
  logic                       ccsds_turbo_dec_engine__obdat        ;
  logic                       ccsds_turbo_dec_engine__odone        ;
  logic              [15 : 0] ccsds_turbo_dec_engine__oerr         ;



  ccsds_turbo_dec_engine
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pLLR_FP      ( pLLR_FP      ) ,
    .pADDR_W      ( pADDR_W      ) ,
    .pMM_ADDR_W   ( pMM_ADDR_W   ) ,
    .pMMAX_TYPE   ( pMMAX_TYPE   ) ,
    .pUSE_SC_MODE ( pUSE_SC_MODE )
  )
  ccsds_turbo_dec_engine
  (
    .iclk             ( ccsds_turbo_dec_engine__iclk             ) ,
    .ireset           ( ccsds_turbo_dec_engine__ireset           ) ,
    .iclkena          ( ccsds_turbo_dec_engine__iclkena          ) ,
    .icode            ( ccsds_turbo_dec_engine__icode            ) ,
    .ifirst           ( ccsds_turbo_dec_engine__ifirst           ) ,
    .ilast            ( ccsds_turbo_dec_engine__ilast            ) ,
    .ieven            ( ccsds_turbo_dec_engine__ieven            ) ,
    .iwarm            ( ccsds_turbo_dec_engine__iwarm            ) ,
    .isop             ( ccsds_turbo_dec_engine__isop             ) ,
    .ival             ( ccsds_turbo_dec_engine__ival             ) ,
    .ieop             ( ccsds_turbo_dec_engine__ieop             ) ,
    .ifterm           ( ccsds_turbo_dec_engine__ifterm           ) ,
    .ifaddr           ( ccsds_turbo_dec_engine__ifaddr           ) ,
    .ifsLLR           ( ccsds_turbo_dec_engine__ifsLLR           ) ,
    .ifa0LLR          ( ccsds_turbo_dec_engine__ifa0LLR          ) ,
    .ifa1LLR          ( ccsds_turbo_dec_engine__ifa1LLR          ) ,
    .ifLextr          ( ccsds_turbo_dec_engine__ifLextr          ) ,
    .ibterm           ( ccsds_turbo_dec_engine__ibterm           ) ,
    .ibaddr           ( ccsds_turbo_dec_engine__ibaddr           ) ,
    .ibsLLR           ( ccsds_turbo_dec_engine__ibsLLR           ) ,
    .iba0LLR          ( ccsds_turbo_dec_engine__iba0LLR          ) ,
    .iba1LLR          ( ccsds_turbo_dec_engine__iba1LLR          ) ,
    .ibLextr          ( ccsds_turbo_dec_engine__ibLextr          ) ,
    .osop             ( ccsds_turbo_dec_engine__osop             ) ,
    .oeop             ( ccsds_turbo_dec_engine__oeop             ) ,
    .oval             ( ccsds_turbo_dec_engine__oval             ) ,
    .odatval          ( ccsds_turbo_dec_engine__odatval          ) ,
    .ofaddr           ( ccsds_turbo_dec_engine__ofaddr           ) ,
    .ofLextr          ( ccsds_turbo_dec_engine__ofLextr          ) ,
    .ofdat            ( ccsds_turbo_dec_engine__ofdat            ) ,
    .obaddr           ( ccsds_turbo_dec_engine__obaddr           ) ,
    .obLextr          ( ccsds_turbo_dec_engine__obLextr          ) ,
    .obdat            ( ccsds_turbo_dec_engine__obdat            ) ,
    .odone            ( ccsds_turbo_dec_engine__odone            ) ,
    .oerr             ( ccsds_turbo_dec_engine__oerr             )
  );


  assign ccsds_turbo_dec_engine__iclk             = '0 ;
  assign ccsds_turbo_dec_engine__ireset           = '0 ;
  assign ccsds_turbo_dec_engine__iclkena          = '0 ;
  assign ccsds_turbo_dec_engine__icode            = '0 ;
  assign ccsds_turbo_dec_engine__ifirst           = '0 ;
  assign ccsds_turbo_dec_engine__ilast            = '0 ;
  assign ccsds_turbo_dec_engine__ieven            = '0 ;
  assign ccsds_turbo_dec_engine__iwarm            = '0 ;
  assign ccsds_turbo_dec_engine__isop             = '0 ;
  assign ccsds_turbo_dec_engine__ival             = '0 ;
  assign ccsds_turbo_dec_engine__ieop             = '0 ;
  assign ccsds_turbo_dec_engine__ifterm           = '0 ;
  assign ccsds_turbo_dec_engine__ifaddr           = '0 ;
  assign ccsds_turbo_dec_engine__ifsLLR           = '0 ;
  assign ccsds_turbo_dec_engine__ifa0LLR          = '0 ;
  assign ccsds_turbo_dec_engine__ifa1LLR          = '0 ;
  assign ccsds_turbo_dec_engine__ifLextr          = '0 ;
  assign ccsds_turbo_dec_engine__ibterm           = '0 ;
  assign ccsds_turbo_dec_engine__ibaddr           = '0 ;
  assign ccsds_turbo_dec_engine__ibsLLR           = '0 ;
  assign ccsds_turbo_dec_engine__iba0LLR          = '0 ;
  assign ccsds_turbo_dec_engine__iba1LLR          = '0 ;
  assign ccsds_turbo_dec_engine__ibLextr          = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_engine.sv
// Description   : top module of sub iteration decoder (i.e. decoder engine). Module use concurrent forward and backward
//                 ways computing. This feature require special rams with two write and read ports.
//

module ccsds_turbo_dec_engine
#(
  parameter int pLLR_W       =         5 ,
  parameter int pLLR_FP      =         3 ,
  parameter int pADDR_W      =         8 ,
  parameter int pMM_ADDR_W   = pADDR_W-1 ,  // metric memory address width. use to create x1/x2/x4 decoders
  parameter int pMMAX_TYPE   =         0 ,  // 0 - max Log Map
                                            // 1 - const 1 max Log Map
                                            // 2 - const 2 max Log Map
                                            // 3 - LUT max Log Map
  parameter bit pUSE_SC_MODE =         1    // use self-corrected logic for extrinsic
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  //
  ifirst  ,
  ilast   ,
  ieven   ,
  iwarm   ,
  //
  isop    ,
  ival    ,
  ieop    ,
  //
  ifterm  ,
  ifaddr  ,
  ifsLLR  ,
  ifa0LLR ,
  ifa1LLR ,
  ifLextr ,
  //
  ibterm  ,
  ibaddr  ,
  ibsLLR  ,
  iba0LLR ,
  iba1LLR ,
  ibLextr ,
  //
  osop    ,
  oeop    ,
  oval    ,
  odatval ,
  //
  ofaddr  ,
  ofLextr ,
  ofdat   ,
  //
  obaddr  ,
  obLextr ,
  obdat   ,
  //
  odone   ,
  oerr
);

  `include "ccsds_turbo_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk         ;
  input  logic                       ireset       ;
  input  logic                       iclkena      ;
  //
  input  logic               [1 : 0] icode        ;
  //
  input  logic                       ifirst       ; // first sub iteration
  input  logic                       ilast        ; // last sub iteration
  input  logic                       ieven        ; // 1/0 - no permutate(even)/permutate (odd) sub iteration
  input  logic                       iwarm        ; // engine work mode warm/hot
  //
  input  logic                       isop         ;
  input  logic                       ival         ;
  input  logic                       ieop         ;
  //
  input  logic                       ifterm       ;
  input  logic       [pADDR_W-1 : 0] ifaddr       ;
  input  bit_llr_t                   ifsLLR       ;
  input  bit_llr_t                   ifa0LLR  [3] ;
  input  bit_llr_t                   ifa1LLR  [3] ;
  input  Lextr_t                     ifLextr      ;
  //
  input  logic                       ibterm       ;
  input  logic       [pADDR_W-1 : 0] ibaddr       ;
  input  bit_llr_t                   ibsLLR       ;
  input  bit_llr_t                   iba0LLR  [3] ;
  input  bit_llr_t                   iba1LLR  [3] ;
  input  Lextr_t                     ibLextr      ;
  //
  output logic                       osop         ;
  output logic                       oeop         ;
  output logic                       oval         ;
  output logic                       odatval      ;
  //
  output logic       [pADDR_W-1 : 0] ofaddr       ;
  output Lextr_t                     ofLextr      ;
  output logic                       ofdat        ;
  //
  output logic       [pADDR_W-1 : 0] obaddr       ;
  output Lextr_t                     obLextr      ;
  output logic                       obdat        ;
  //
  output logic                       odone        ; // last iteration eop signal
  output logic              [15 : 0] oerr         ; // estimated bit errors

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBMC_DELAY   = 2;
  localparam int cRP_DELAY    = 1;
  localparam int cLAPO_DELAY  = 6;
  localparam int cLEXTR_DELAY = 2;

  localparam int cDELAY = cBMC_DELAY + cRP_DELAY + cLAPO_DELAY + cLEXTR_DELAY;

  //------------------------------------------------------------------------------------------------------
  // common contol line
  //------------------------------------------------------------------------------------------------------

  logic  [cDELAY-1 : 0] sop             ;
  logic  [cDELAY-1 : 0] val             /*synthesis keep */;
  logic  [cDELAY-1 : 0] eop             ;
  logic  [cDELAY-1 : 0] warm            /*synthesis keep */;
  logic  [cDELAY-1 : 0] last            ;
  logic  [cDELAY-1 : 0] fterm           ;
  logic  [cDELAY-1 : 0] bterm           ;

  logic [pADDR_W-1 : 0] faddr [cDELAY]  ;
  logic [pADDR_W-1 : 0] baddr [cDELAY]  ;

  logic  [cDELAY-1 : 0] first           ;
  logic  [cDELAY-1 : 0] even            ;

  Lextr_t               fLextr[cDELAY]  ;
  Lextr_t               bLextr[cDELAY]  ;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop   <= (sop   << 1) | isop;
      eop   <= (eop   << 1) | ieop;
      last  <= (last  << 1) | ilast;
      warm  <= (warm  << 1) | iwarm;
      fterm <= (fterm << 1) | ifterm;
      bterm <= (bterm << 1) | ibterm;
      //
      if (pUSE_SC_MODE) begin
        even  <= (even  << 1) | ieven;
        first <= (first << 1) | ifirst;
      end
      //
      for (int i = 0; i < cDELAY; i++) begin
        faddr[i] <= (i == 0) ? ifaddr : faddr[i-1];
        baddr[i] <= (i == 0) ? ibaddr : baddr[i-1];
        //
        if (pUSE_SC_MODE) begin
          fLextr[i] <= (i == 0) ? ifLextr : fLextr[i-1];
          bLextr[i] <= (i == 0) ? ibLextr : bLextr[i-1];
        end
      end
   end
  end

//------------------------------------------------------------------------------------------------------
//
// forward path BEGIN
//
//------------------------------------------------------------------------------------------------------

  logic                     f_bmc__oval       ;
  gamma_t                   f_bmc__ogamma     ;
  Lapri_t                   f_bmc__oLapri     ;
  logic                     f_bmc__ohd        ;


  logic                     f_rp__istate_clr  ;

  logic                     f_rp__oval        ;
  gamma_t                   f_rp__ogamma      ;
  state_t                   f_rp__ostate2mm   ;


  logic                     f_mm__iwrite      ;
  logic [cSTATE_W*16-1 : 0] f_mm__iwdata      ;
  logic                     f_mm__iread       ;
  logic [cSTATE_W*16-1 : 0] f_mm__ordata      ;
  logic [cSTATE_W*16-1 : 0] b_mm__ordata      ;


  logic                     f_Lapo__ival      ;
  gamma_t                   f_Lapo__igamma    ;
  state_t                   f_Lapo__istate    ;
  logic                     f_Lapo__oval      ;
  Lapo_t                    f_Lapo__oLapo     ;


  logic                     f_Lextr__ival     ;
  logic                     f_Lextr__idat     ;
  Lapri_t                   f_Lextr__iLapri   ;
  Lapo_t                    f_Lextr__iLapo    ;

  logic                     f_Lextr__isc_init ;
  logic                     f_Lextr__isc_ena  ;
  Lextr_t                   f_Lextr__iLextr   ;

  logic                     f_Lextr__oval     ;
  Lextr_t                   f_Lextr__oLextr   ;
  logic                     f_Lextr__odat     ;
  logic                     f_Lextr__oerr     ;

  //------------------------------------------------------------------------------------------------------
  // BMC
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_bmc
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pLLR_FP ( pLLR_FP )
  )
  f_bmc
  (
    .iclk       ( iclk           ) ,
    .ireset     ( ireset         ) ,
    .iclkena    ( iclkena        ) ,
    //
    .ival       ( ival           ) ,
    .ieven      ( ieven          ) ,
    .iLextr_clr ( ifirst         ) ,
    //
    .iterm      ( ifterm         ) ,
    //
    .isLLR      ( ifsLLR         ) ,
    .ia0LLR     ( ifa0LLR        ) ,
    .ia1LLR     ( ifa1LLR        ) ,
    //
    .iLextr     ( ifLextr.value  ) ,
    //
    .oval       ( f_bmc__oval    ) ,
    .ogamma     ( f_bmc__ogamma  ) ,
    .oLapri     ( f_bmc__oLapri  ) ,
    .ohd        ( f_bmc__ohd     )
  );

  //------------------------------------------------------------------------------------------------------
  // RP
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_rp
  #(
    .pB_nF      ( 0          ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  f_rp
  (
    .iclk       ( iclk             ) ,
    .ireset     ( ireset           ) ,
    .iclkena    ( iclkena          ) ,
    //
    .icode      ( icode            ) ,
    .istate_clr ( f_rp__istate_clr ) ,
    //
    .ival       ( f_bmc__oval      ) ,
    .igamma     ( f_bmc__ogamma    ) ,
    //
    .oval       ( f_rp__oval       ) ,
    .ostate     (                  ) ,  // n.u.
    .ogamma     ( f_rp__ogamma     ) ,
    .ostate2mm  ( f_rp__ostate2mm  )
  );

  assign f_rp__istate_clr = sop[0];

  //------------------------------------------------------------------------------------------------------
  // mm
  //------------------------------------------------------------------------------------------------------

  codec_map_dec_mm
  #(
    .pDATA_W ( cSTATE_W * cSTATE_NUM ) ,
    .pADDR_W ( pMM_ADDR_W            )   // 1/N of pN
  )
  f_mm
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .iwrite  ( f_mm__iwrite ) ,
    .iwdata  ( f_mm__iwdata ) ,
    .iread   ( f_mm__iread  ) ,
    .ordata  ( f_mm__ordata )
  );

  assign f_mm__iwrite = f_rp__oval &  warm[cBMC_DELAY + cRP_DELAY-1];
  assign f_mm__iread  = f_rp__oval & !warm[cBMC_DELAY + cRP_DELAY-1];

  assign f_mm__iwdata = {f_rp__ostate2mm[ 0], f_rp__ostate2mm[ 1], f_rp__ostate2mm[ 2], f_rp__ostate2mm[ 3],
                         f_rp__ostate2mm[ 4], f_rp__ostate2mm[ 5], f_rp__ostate2mm[ 6], f_rp__ostate2mm[ 7],
                         f_rp__ostate2mm[ 8], f_rp__ostate2mm[ 9], f_rp__ostate2mm[10], f_rp__ostate2mm[11],
                         f_rp__ostate2mm[12], f_rp__ostate2mm[13], f_rp__ostate2mm[14], f_rp__ostate2mm[15]};

  //------------------------------------------------------------------------------------------------------
  // Lapo
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_Lapo
  #(
    .pB_nF      ( 0          ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  f_Lapo
  (
    .iclk    ( iclk           ) ,
    .ireset  ( ireset         ) ,
    .iclkena ( iclkena        ) ,
    //
    .ival    ( f_Lapo__ival   ) ,
    .igamma  ( f_Lapo__igamma ) ,
    .istate  ( f_Lapo__istate ) ,
    //
    .oval    ( f_Lapo__oval   ) ,
    .oLapo   ( f_Lapo__oLapo  )
  );

  assign f_Lapo__ival   = f_rp__oval & !warm[cBMC_DELAY + cRP_DELAY-1];
  assign f_Lapo__igamma = f_rp__ogamma;

  assign {f_Lapo__istate[ 0], f_Lapo__istate[ 1], f_Lapo__istate[ 2], f_Lapo__istate[ 3],
          f_Lapo__istate[ 4], f_Lapo__istate[ 5], f_Lapo__istate[ 6], f_Lapo__istate[ 7],
          f_Lapo__istate[ 8], f_Lapo__istate[ 9], f_Lapo__istate[10], f_Lapo__istate[11],
          f_Lapo__istate[12], f_Lapo__istate[13], f_Lapo__istate[14], f_Lapo__istate[15]} = b_mm__ordata;


  //------------------------------------------------------------------------------------------------------
  // delay line for Lapri & hd
  //------------------------------------------------------------------------------------------------------

  Lapri_t f_Lapri [cRP_DELAY + cLAPO_DELAY]  /*synthesis keep */;
  logic   f_hd    [cRP_DELAY + cLAPO_DELAY]  /*synthesis keep */;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < cRP_DELAY + cLAPO_DELAY; i++) begin
        if (i == 0) begin
          f_Lapri[i] <= f_bmc__oLapri;
          f_hd   [i] <= f_bmc__ohd   ;
        end
        else begin
          f_Lapri[i] <= f_Lapri[i-1];
          f_hd   [i] <= f_hd   [i-1];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Lextr
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_Lextr
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pLLR_FP      ( pLLR_FP      ) ,
    .pMMAX_TYPE   ( pMMAX_TYPE   ) ,
    .pUSE_SC_MODE ( pUSE_SC_MODE )
  )
  f_Lextr
  (
    .iclk     ( iclk              ) ,
    .ireset   ( ireset            ) ,
    .iclkena  ( iclkena           ) ,
    //
    .ival     ( f_Lextr__ival     ) ,
    .idat     ( f_Lextr__idat     ) ,
    .iLapri   ( f_Lextr__iLapri   ) ,
    .iLapo    ( f_Lextr__iLapo    ) ,
    //
    .isc_init ( f_Lextr__isc_init ) ,
    .isc_ena  ( f_Lextr__isc_ena  ) ,
    .iLextr   ( f_Lextr__iLextr   ) ,
    //
    .oval     ( f_Lextr__oval     ) ,
    .oLextr   ( f_Lextr__oLextr   ) ,
    .odat     ( f_Lextr__odat     ) ,
    .oerr     ( f_Lextr__oerr     )
  );

  assign f_Lextr__ival      = f_Lapo__oval;
  assign f_Lextr__iLapo     = f_Lapo__oLapo;

  assign f_Lextr__idat      = f_hd    [cRP_DELAY + cLAPO_DELAY-1];
  assign f_Lextr__iLapri    = f_Lapri [cRP_DELAY + cLAPO_DELAY-1];

  assign f_Lextr__isc_init  =  first  [cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1];
  assign f_Lextr__isc_ena   = !even   [cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1];
  assign f_Lextr__iLextr    =  fLextr [cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1];

//------------------------------------------------------------------------------------------------------
//
// forward path END
//
//------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------
//
// backward path BEGIN
//
//------------------------------------------------------------------------------------------------------

  logic                     b_bmc__oval       ;
  gamma_t                   b_bmc__ogamma     ;
  Lapri_t                   b_bmc__oLapri     ;
  logic                     b_bmc__ohd        ;


  logic                     b_rp__istate_clr  ;

  logic                     b_rp__oval        ;
  gamma_t                   b_rp__ogamma      ;
  state_t                   b_rp__ostate2mm   ;

  logic                     b_mm__iwrite      ;
  logic [cSTATE_W*16-1 : 0] b_mm__iwdata      ;
  logic                     b_mm__iread       ;


  logic                     b_Lapo__ival      ;
  gamma_t                   b_Lapo__igamma    ;
  state_t                   b_Lapo__istate    ;
  logic                     b_Lapo__oval      ;
  Lapo_t                    b_Lapo__oLapo     ;


  logic                     b_Lextr__ival     ;
  logic                     b_Lextr__idat     ;
  Lapri_t                   b_Lextr__iLapri   ;
  Lapo_t                    b_Lextr__iLapo    ;

  logic                     b_Lextr__isc_init ;
  logic                     b_Lextr__isc_ena  ;
  Lextr_t                   b_Lextr__iLextr   ;

  logic                     b_Lextr__oval     ;
  Lextr_t                   b_Lextr__oLextr   ;
  logic                     b_Lextr__odat     ;
  logic                     b_Lextr__oerr     ;

  //------------------------------------------------------------------------------------------------------
  // BMC
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_bmc
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pLLR_FP ( pLLR_FP )
  )
  b_bmc
  (
    .iclk       ( iclk           ) ,
    .ireset     ( ireset         ) ,
    .iclkena    ( iclkena        ) ,
    //
    .ival       ( ival           ) ,
    .ieven      ( ieven          ) ,
    .iLextr_clr ( ifirst         ) ,
    //
    .iterm      ( ibterm         ) ,
    //
    .isLLR      ( ibsLLR         ) ,
    .ia0LLR     ( iba0LLR        ) ,
    .ia1LLR     ( iba1LLR        ) ,
    //
    .iLextr     ( ibLextr.value  ) ,
    //
    .oval       ( b_bmc__oval    ) ,
    .ogamma     ( b_bmc__ogamma  ) ,
    .oLapri     ( b_bmc__oLapri  ) ,
    .ohd        ( b_bmc__ohd     )
  );

  //------------------------------------------------------------------------------------------------------
  // RP
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_rp
  #(
    .pB_nF      ( 1          ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  b_rp
  (
    .iclk       ( iclk             ) ,
    .ireset     ( ireset           ) ,
    .iclkena    ( iclkena          ) ,
    //
    .icode      ( icode            ) ,
    .istate_clr ( b_rp__istate_clr ) ,
    //
    .ival       ( b_bmc__oval      ) ,
    .igamma     ( b_bmc__ogamma    ) ,
    //
    .oval       ( b_rp__oval       ) ,
    .ostate     (                  ) ,  // n.u.
    .ogamma     ( b_rp__ogamma     ) ,
    .ostate2mm  ( b_rp__ostate2mm  )
  );

  assign b_rp__istate_clr = sop[0];

  //------------------------------------------------------------------------------------------------------
  // mm
  //------------------------------------------------------------------------------------------------------

  codec_map_dec_mm
  #(
    .pDATA_W ( cSTATE_W * cSTATE_NUM ) ,
    .pADDR_W ( pMM_ADDR_W            )   // 1/N of pN
  )
  b_mm
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .iwrite  ( b_mm__iwrite ) ,
    .iwdata  ( b_mm__iwdata ) ,
    .iread   ( b_mm__iread  ) ,
    .ordata  ( b_mm__ordata )
  );

  assign b_mm__iwrite = b_rp__oval &  warm[cBMC_DELAY + cRP_DELAY-1];
  assign b_mm__iread  = b_rp__oval & !warm[cBMC_DELAY + cRP_DELAY-1];

  assign b_mm__iwdata = {b_rp__ostate2mm[ 0], b_rp__ostate2mm[ 1], b_rp__ostate2mm[ 2], b_rp__ostate2mm[ 3],
                         b_rp__ostate2mm[ 4], b_rp__ostate2mm[ 5], b_rp__ostate2mm[ 6], b_rp__ostate2mm[ 7],
                         b_rp__ostate2mm[ 8], b_rp__ostate2mm[ 9], b_rp__ostate2mm[10], b_rp__ostate2mm[11],
                         b_rp__ostate2mm[12], b_rp__ostate2mm[13], b_rp__ostate2mm[14], b_rp__ostate2mm[15]};

  //------------------------------------------------------------------------------------------------------
  // Lapo
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_Lapo
  #(
    .pB_nF      ( 1          ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  b_Lapo
  (
    .iclk    ( iclk           ) ,
    .ireset  ( ireset         ) ,
    .iclkena ( iclkena        ) ,
    //
    .ival    ( b_Lapo__ival   ) ,
    .igamma  ( b_Lapo__igamma ) ,
    .istate  ( b_Lapo__istate ) ,
    //
    .oval    ( b_Lapo__oval   ) ,
    .oLapo   ( b_Lapo__oLapo  )
  );

  assign b_Lapo__ival   = b_rp__oval & !warm[cBMC_DELAY + cRP_DELAY-1];
  assign b_Lapo__igamma = b_rp__ogamma;

  assign {b_Lapo__istate[ 0], b_Lapo__istate[ 1], b_Lapo__istate[ 2], b_Lapo__istate[ 3],
          b_Lapo__istate[ 4], b_Lapo__istate[ 5], b_Lapo__istate[ 6], b_Lapo__istate[ 7],
          b_Lapo__istate[ 8], b_Lapo__istate[ 9], b_Lapo__istate[10], b_Lapo__istate[11],
          b_Lapo__istate[12], b_Lapo__istate[13], b_Lapo__istate[14], b_Lapo__istate[15] } = f_mm__ordata;

  //------------------------------------------------------------------------------------------------------
  // delay line for Lapri & hd
  //------------------------------------------------------------------------------------------------------

  Lapri_t b_Lapri [cRP_DELAY + cLAPO_DELAY] /*synthesis keep */;
  logic   b_hd    [cRP_DELAY + cLAPO_DELAY] /*synthesis keep */;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < cRP_DELAY + cLAPO_DELAY; i++) begin
        if (i == 0) begin
          b_Lapri[i] <= b_bmc__oLapri;
          b_hd   [i] <= b_bmc__ohd   ;
        end
        else begin
          b_Lapri[i] <= b_Lapri[i-1];
          b_hd   [i] <= b_hd   [i-1];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Lextr
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_Lextr
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pLLR_FP      ( pLLR_FP      ) ,
    .pMMAX_TYPE   ( pMMAX_TYPE   ) ,
    .pUSE_SC_MODE ( pUSE_SC_MODE )
  )
  b_Lextr
  (
    .iclk     ( iclk              ) ,
    .ireset   ( ireset            ) ,
    .iclkena  ( iclkena           ) ,
    //
    .ival     ( b_Lextr__ival     ) ,
    .idat     ( b_Lextr__idat     ) ,
    .iLapri   ( b_Lextr__iLapri   ) ,
    .iLapo    ( b_Lextr__iLapo    ) ,
    //
    .isc_init ( b_Lextr__isc_init ) ,
    .isc_ena  ( b_Lextr__isc_ena  ) ,
    .iLextr   ( b_Lextr__iLextr   ) ,
    //
    .oval     ( b_Lextr__oval     ) ,
    .oLextr   ( b_Lextr__oLextr   ) ,
    .odat     ( b_Lextr__odat     ) ,
    .oerr     ( b_Lextr__oerr     )
  );

  assign b_Lextr__ival      = b_Lapo__oval;
  assign b_Lextr__iLapo     = b_Lapo__oLapo;

  assign b_Lextr__idat      = b_hd    [cRP_DELAY + cLAPO_DELAY-1];
  assign b_Lextr__iLapri    = b_Lapri [cRP_DELAY + cLAPO_DELAY-1];

  assign b_Lextr__isc_init  =  first  [cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1];
  assign b_Lextr__isc_ena   = !even   [cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1];
  assign b_Lextr__iLextr    =  bLextr [cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1];

//------------------------------------------------------------------------------------------------------
//
// backward path END
//
//------------------------------------------------------------------------------------------------------






  //------------------------------------------------------------------------------------------------------
  // output interface
  //------------------------------------------------------------------------------------------------------

  assign osop     = sop[cDELAY-1];
  assign oeop     = eop[cDELAY-1];

  assign ofaddr   = faddr[cDELAY-1];
  assign obaddr   = baddr[cDELAY-1];

  assign oval     = f_Lextr__oval;

  assign odatval  = f_Lextr__oval;

  assign ofLextr  = f_Lextr__oLextr;
  assign ofdat    = f_Lextr__odat;

  assign obLextr  = b_Lextr__oLextr;
  assign obdat    = b_Lextr__odat;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      odone <= 1'b0;
    end
    else if (iclkena) begin
      odone <= oval & oeop & last[cDELAY-1];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (osop) begin
        oerr <= '0;
      end
      else if (oval) begin
        oerr <= oerr + (f_Lextr__oerr & !fterm[cDELAY-1]) + (b_Lextr__oerr & !bterm[cDELAY-1]);
      end
    end
  end

endmodule
