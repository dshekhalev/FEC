/*



  parameter int pLLR_W         = 5 ;
  parameter int pLLR_FP        = 3 ;
  parameter int pDTAG_W        = 8 ;
  parameter int pADDR_W        = 8 ;
  parameter int pMM_ADDR_W     = pADDR_W-1;
  parameter int pMMAX_TYPE     = 0 ;
  parameter bit pUSE_RP_P_COMP = 1 ;



  logic                       rsc2_dec_map_engine__iclk             ;
  logic                       rsc2_dec_map_engine__ireset           ;
  logic                       rsc2_dec_map_engine__iclkena          ;
  logic                       rsc2_dec_map_engine__ifirst           ;
  logic                       rsc2_dec_map_engine__ilast            ;
  logic                       rsc2_dec_map_engine__ieven            ;
  logic                       rsc2_dec_map_engine__ibitswap         ;
  logic                       rsc2_dec_map_engine__iwarm            ;
  logic                       rsc2_dec_map_engine__isop             ;
  logic                       rsc2_dec_map_engine__ival             ;
  logic                       rsc2_dec_map_engine__ieop             ;
  logic       [pADDR_W-1 : 0] rsc2_dec_map_engine__ifaddr           ;
  bit_llr_t                   rsc2_dec_map_engine__ifsLLR   [0 : 1] ;
  bit_llr_t                   rsc2_dec_map_engine__ifyLLR   [0 : 1] ;
  bit_llr_t                   rsc2_dec_map_engine__ifwLLR   [0 : 1] ;
  Lextr_t                     rsc2_dec_map_engine__ifLextr          ;
  logic       [pDTAG_W-1 : 0] rsc2_dec_map_engine__ifsLLRtag        ;
  logic       [pADDR_W-1 : 0] rsc2_dec_map_engine__ibaddr           ;
  bit_llr_t                   rsc2_dec_map_engine__ibsLLR   [0 : 1] ;
  bit_llr_t                   rsc2_dec_map_engine__ibyLLR   [0 : 1] ;
  bit_llr_t                   rsc2_dec_map_engine__ibwLLR   [0 : 1] ;
  Lextr_t                     rsc2_dec_map_engine__ibLextr          ;
  logic       [pDTAG_W-1 : 0] rsc2_dec_map_engine__ibsLLRtag        ;
  state_t                     rsc2_dec_map_engine__if_rp_state_even ;
  state_t                     rsc2_dec_map_engine__if_rp_state_odd  ;
  state_t                     rsc2_dec_map_engine__ib_rp_state_even ;
  state_t                     rsc2_dec_map_engine__ib_rp_state_odd  ;
  state_t                     rsc2_dec_map_engine__of_rp_state_even ;
  state_t                     rsc2_dec_map_engine__of_rp_state_odd  ;
  state_t                     rsc2_dec_map_engine__ob_rp_state_even ;
  state_t                     rsc2_dec_map_engine__ob_rp_state_odd  ;
  logic                       rsc2_dec_map_engine__osop             ;
  logic                       rsc2_dec_map_engine__oeop             ;
  logic                       rsc2_dec_map_engine__oval             ;
  logic                       rsc2_dec_map_engine__odatval          ;
  logic       [pADDR_W-1 : 0] rsc2_dec_map_engine__ofaddr           ;
  Lextr_t                     rsc2_dec_map_engine__ofLextr          ;
  logic               [1 : 0] rsc2_dec_map_engine__ofdat            ;
  logic               [1 : 0] rsc2_dec_map_engine__ofderr           ;
  logic       [pDTAG_W-1 : 0] rsc2_dec_map_engine__ofdtag           ;
  logic       [pADDR_W-1 : 0] rsc2_dec_map_engine__obaddr           ;
  Lextr_t                     rsc2_dec_map_engine__obLextr          ;
  logic               [1 : 0] rsc2_dec_map_engine__obdat            ;
  logic               [1 : 0] rsc2_dec_map_engine__obderr           ;
  logic       [pDTAG_W-1 : 0] rsc2_dec_map_engine__obdtag           ;
  logic                       rsc2_dec_map_engine__odone            ;
  logic              [15 : 0] rsc2_dec_map_engine__oerr             ;



  rsc2_dec_map_engine
  #(
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_FP        ( pLLR_FP        ) ,
    .pDTAG_W        ( pDTAG_W        ) ,
    .pADDR_W        ( pADDR_W        ) ,
    .pMM_ADDR_W     ( pMM_ADDR_W     ) ,
    .pMMAX_TYPE     ( pMMAX_TYPE     ) ,
    .pUSE_RP_P_COMP ( pUSE_RP_P_COMP )
  )
  rsc2_dec_map_engine
  (
    .iclk             ( rsc2_dec_map_engine__iclk             ) ,
    .ireset           ( rsc2_dec_map_engine__ireset           ) ,
    .iclkena          ( rsc2_dec_map_engine__iclkena          ) ,
    .ifirst           ( rsc2_dec_map_engine__ifirst           ) ,
    .ilast            ( rsc2_dec_map_engine__ilast            ) ,
    .ieven            ( rsc2_dec_map_engine__ieven            ) ,
    .ibitswap         ( rsc2_dec_map_engine__ibitswap         ) ,
    .iwarm            ( rsc2_dec_map_engine__iwarm            ) ,
    .isop             ( rsc2_dec_map_engine__isop             ) ,
    .ival             ( rsc2_dec_map_engine__ival             ) ,
    .ieop             ( rsc2_dec_map_engine__ieop             ) ,
    .ifaddr           ( rsc2_dec_map_engine__ifaddr           ) ,
    .ifsLLR           ( rsc2_dec_map_engine__ifsLLR           ) ,
    .ifyLLR           ( rsc2_dec_map_engine__ifyLLR           ) ,
    .ifwLLR           ( rsc2_dec_map_engine__ifwLLR           ) ,
    .ifLextr          ( rsc2_dec_map_engine__ifLextr          ) ,
    .ifsLLRtag        ( rsc2_dec_map_engine__ifsLLRtag        ) ,
    .ibaddr           ( rsc2_dec_map_engine__ibaddr           ) ,
    .ibsLLR           ( rsc2_dec_map_engine__ibsLLR           ) ,
    .ibyLLR           ( rsc2_dec_map_engine__ibyLLR           ) ,
    .ibwLLR           ( rsc2_dec_map_engine__ibwLLR           ) ,
    .ibLextr          ( rsc2_dec_map_engine__ibLextr          ) ,
    .ibsLLRtag        ( rsc2_dec_map_engine__ibsLLRtag        ) ,
    .if_rp_state_even ( rsc2_dec_map_engine__if_rp_state_even ) ,
    .if_rp_state_odd  ( rsc2_dec_map_engine__if_rp_state_odd  ) ,
    .ib_rp_state_even ( rsc2_dec_map_engine__ib_rp_state_even ) ,
    .ib_rp_state_odd  ( rsc2_dec_map_engine__ib_rp_state_odd  ) ,
    .of_rp_state_even ( rsc2_dec_map_engine__of_rp_state_even ) ,
    .of_rp_state_odd  ( rsc2_dec_map_engine__of_rp_state_odd  ) ,
    .ob_rp_state_even ( rsc2_dec_map_engine__ob_rp_state_even ) ,
    .ob_rp_state_odd  ( rsc2_dec_map_engine__ob_rp_state_odd  ) ,
    .osop             ( rsc2_dec_map_engine__osop             ) ,
    .oeop             ( rsc2_dec_map_engine__oeop             ) ,
    .oval             ( rsc2_dec_map_engine__oval             ) ,
    .odatval          ( rsc2_dec_map_engine__odatval          ) ,
    .ofaddr           ( rsc2_dec_map_engine__ofaddr           ) ,
    .ofLextr          ( rsc2_dec_map_engine__ofLextr          ) ,
    .ofdat            ( rsc2_dec_map_engine__ofdat            ) ,
    .ofderr           ( rsc_dec_map_engine__ofderr           ) ,
    .ofdtag           ( rsc_dec_map_engine__ofdtag           ) ,
    .obaddr           ( rsc2_dec_map_engine__obaddr           ) ,
    .obLextr          ( rsc2_dec_map_engine__obLextr          ) ,
    .obdat            ( rsc2_dec_map_engine__obdat            ) ,
    .obderr           ( rsc2_dec_map_engine__obderr           ) ,
    .obdtag           ( rsc2_dec_map_engine__obdtag           ) ,
    .odone            ( rsc2_dec_map_engine__odone            ) ,
    .oerr             ( rsc2_dec_map_engine__oerr             )
  );


  assign rsc2_dec_map_engine__iclk             = '0 ;
  assign rsc2_dec_map_engine__ireset           = '0 ;
  assign rsc2_dec_map_engine__iclkena          = '0 ;
  assign rsc2_dec_map_engine__ifirst           = '0 ;
  assign rsc2_dec_map_engine__ilast            = '0 ;
  assign rsc2_dec_map_engine__ieven            = '0 ;
  assign rsc2_dec_map_engine__ibitswap         = '0 ;
  assign rsc2_dec_map_engine__iwarm            = '0 ;
  assign rsc2_dec_map_engine__isop             = '0 ;
  assign rsc2_dec_map_engine__ival             = '0 ;
  assign rsc2_dec_map_engine__ieop             = '0 ;
  assign rsc2_dec_map_engine__ifaddr           = '0 ;
  assign rsc2_dec_map_engine__ifsLLR           = '0 ;
  assign rsc2_dec_map_engine__ifyLLR           = '0 ;
  assign rsc2_dec_map_engine__ifwLLR           = '0 ;
  assign rsc2_dec_map_engine__ifLextr          = '0 ;
  assign rsc2_dec_map_engine__ifsLLRtag        = '0 ;
  assign rsc2_dec_map_engine__ibaddr           = '0 ;
  assign rsc2_dec_map_engine__ibsLLR           = '0 ;
  assign rsc2_dec_map_engine__ibyLLR           = '0 ;
  assign rsc2_dec_map_engine__ibwLLR           = '0 ;
  assign rsc2_dec_map_engine__ibLextr          = '0 ;
  assign rsc2_dec_map_engine__ifsLLRtag        = '0 ;
  assign rsc2_dec_map_engine__if_rp_state_even = '0 ;
  assign rsc2_dec_map_engine__if_rp_state_odd  = '0 ;
  assign rsc2_dec_map_engine__ib_rp_state_even = '0 ;
  assign rsc2_dec_map_engine__ib_rp_state_odd  = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_dec_map_engine.sv
// Description   : top module of sub iteration decoder (i.e. decoder engine). Module use concurrent forward and backward
//                 ways computing. This feature require special rams with two write and read ports.
//

module rsc2_dec_map_engine
#(
  parameter int pLLR_W         =         5 ,
  parameter int pLLR_FP        =         3 ,
  parameter int pDTAG_W        =         8 ,  // duo-bit tag for multichannel modes
  parameter int pADDR_W        =         8 ,
  parameter int pMM_ADDR_W     = pADDR_W-1 ,  // metric memory address width. use to create x1/x2/x4 decoders
  parameter int pMMAX_TYPE     =         0 ,  // 0 - max Log Map
                                              // 1 - const 1 max Log Map
                                              // 2 - const 2 max Log Map
                                              // 3 - LUT max Log Map
  parameter bit pUSE_RP_P_COMP =         1    // use parallel comparator for recursion processor
)
(
  iclk              ,
  ireset            ,
  iclkena           ,
  //
  ifirst            ,
  ilast             ,
  ieven             ,
  ibitswap          ,
  iwarm             ,
  //
  isop              ,
  ival              ,
  ieop              ,
  //
  ifaddr            ,
  ifsLLR            ,
  ifyLLR            ,
  ifwLLR            ,
  ifLextr           ,
  ifsLLRtag         ,
  //
  ibaddr            ,
  ibsLLR            ,
  ibyLLR            ,
  ibwLLR            ,
  ibLextr           ,
  ibsLLRtag         ,
  //
  if_rp_state_even  ,
  if_rp_state_odd   ,
  ib_rp_state_even  ,
  ib_rp_state_odd   ,
  //
  of_rp_state_even  ,
  of_rp_state_odd   ,
  ob_rp_state_even  ,
  ob_rp_state_odd   ,
  //
  osop              ,
  oeop              ,
  oval              ,
  odatval           ,
  //
  ofaddr            ,
  ofLextr           ,
  ofdat             ,
  ofderr            ,
  ofdtag            ,
  //
  obaddr            ,
  obLextr           ,
  obdat             ,
  obderr            ,
  obdtag            ,
  //
  odone             ,
  oerr
);

  `include "rsc2_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk             ;
  input  logic                       ireset           ;
  input  logic                       iclkena          ;
  //
  input  logic                       ifirst           ; // first sub iteration
  input  logic                       ilast            ; // last sub iteration
  input  logic                       ieven            ; // 1/0 - no permutate(even)/permutate (odd) sub iteration
  input  logic                       ibitswap         ; // swap bit pair
  input  logic                       iwarm            ; // engine work mode warm/hot
  //
  input  logic                       isop             ;
  input  logic                       ival             ;
  input  logic                       ieop             ;
  //
  input  logic       [pADDR_W-1 : 0] ifaddr           ;
  input  bit_llr_t                   ifsLLR   [0 : 1] ;
  input  bit_llr_t                   ifyLLR   [0 : 1] ;
  input  bit_llr_t                   ifwLLR   [0 : 1] ;
  input  Lextr_t                     ifLextr          ;
  input  logic       [pDTAG_W-1 : 0] ifsLLRtag        ;
  //
  input  logic       [pADDR_W-1 : 0] ibaddr           ;
  input  bit_llr_t                   ibsLLR   [0 : 1] ;
  input  bit_llr_t                   ibyLLR   [0 : 1] ;
  input  bit_llr_t                   ibwLLR   [0 : 1] ;
  input  Lextr_t                     ibLextr          ;
  input  logic       [pDTAG_W-1 : 0] ibsLLRtag        ;
  //
  input  state_t                     if_rp_state_even ;
  input  state_t                     if_rp_state_odd  ;
  input  state_t                     ib_rp_state_even ;
  input  state_t                     ib_rp_state_odd  ;

  output state_t                     of_rp_state_even ;
  output state_t                     of_rp_state_odd  ;
  output state_t                     ob_rp_state_even ;
  output state_t                     ob_rp_state_odd  ;
  //
  output logic                       osop             ;
  output logic                       oeop             ;
  output logic                       oval             ;
  output logic                       odatval          ;
  //
  output logic       [pADDR_W-1 : 0] ofaddr           ;
  output Lextr_t                     ofLextr          ;
  output logic               [1 : 0] ofdat            ;
  output logic               [1 : 0] ofderr           ;
  output logic       [pDTAG_W-1 : 0] ofdtag           ;
  //
  output logic       [pADDR_W-1 : 0] obaddr           ;
  output Lextr_t                     obLextr          ;
  output logic               [1 : 0] obdat            ;
  output logic               [1 : 0] obderr           ;
  output logic       [pDTAG_W-1 : 0] obdtag           ;
  //
  output logic                       odone            ; // last iteration eop signal
  output logic              [15 : 0] oerr             ; // estimated bit errors

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

  logic [cDELAY-1 : 0] sop              /*synthesis keep */;
  logic [cDELAY-1 : 0] val              /*synthesis keep */;
  logic [cDELAY-1 : 0] eop              /*synthesis keep */;
  logic [cDELAY-1 : 0] warm             /*synthesis keep */;
  logic [cDELAY-1 : 0] bitswap          /*synthesis keep */;
  logic [cDELAY-1 : 0] last             /*synthesis keep */;

  logic [pADDR_W-1 : 0] faddr [cDELAY]  ;
  logic [pADDR_W-1 : 0] baddr [cDELAY]  ;

  logic [pDTAG_W-1 : 0] fdtag [cDELAY]  ;
  logic [pDTAG_W-1 : 0] bdtag [cDELAY]  ;

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
      sop     <= (sop     << 1) | isop;
      eop     <= (eop     << 1) | ieop;
      last    <= (last    << 1) | ilast;
      warm    <= (warm    << 1) | iwarm;
      bitswap <= (bitswap << 1) | ibitswap;
      for (int i = 0; i < cDELAY; i++) begin
        faddr[i] <= (i == 0) ? ifaddr     : faddr[i-1];
        baddr[i] <= (i == 0) ? ibaddr     : baddr[i-1];
        fdtag[i] <= (i == 0) ? ifsLLRtag  : fdtag[i-1];
        bdtag[i] <= (i == 0) ? ibsLLRtag  : bdtag[i-1];
      end
   end
  end

//------------------------------------------------------------------------------------------------------
//
// forward path BEGIN
//
//------------------------------------------------------------------------------------------------------

  // branch metric calculator
  logic                     f_bmc__oval       ;
  gamma_t                   f_bmc__ogamma     ;
  Lapri_t                   f_bmc__oLapri     ;
  logic             [1 : 0] f_bmc__ohd        ;
  //
  // recursion processor
  logic                     f_rp__istate_clr  ;
  logic                     f_rp__istate_ld   ;
  state_t                   f_rp__istate      ;

  logic                     f_rp__oval        ;
  gamma_t                   f_rp__ogamma      ;
  state_t                   f_rp__ostate2mm   ;
  state_t                   f_rp__ostate_last ;
  //
  // metric memory LIFO
  logic                     f_mm__iwrite      ;
  logic [cSTATE_W*16-1 : 0] f_mm__iwdata      ;
  logic                     f_mm__iread       ;
  logic [cSTATE_W*16-1 : 0] f_mm__ordata      ;
  logic [cSTATE_W*16-1 : 0] b_mm__ordata      ;
  //
  // aposteriory L
  logic                     f_Lapo__ival      ;
  gamma_t                   f_Lapo__igamma    ;
  state_t                   f_Lapo__istate    ;
  logic                     f_Lapo__oval      ;
  Lapo_t                    f_Lapo__oLapo     ;
  //
  // extrinsic L
  logic                     f_Lextr__ival     ;
  logic                     f_Lextr__ibitswap ;
  logic             [1 : 0] f_Lextr__idat     ;
  Lapri_t                   f_Lextr__iLapri   ;
  Lapo_t                    f_Lextr__iLapo    ;

  logic                     f_Lextr__oval     ;
  Lextr_t                   f_Lextr__oLextr   ;
  logic             [1 : 0] f_Lextr__odat     ;
  logic             [1 : 0] f_Lextr__oerr     ;

  //------------------------------------------------------------------------------------------------------
  // BMC
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_bmc
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
    .ibitswap   ( ibitswap       ) ,
    .iLextr_clr ( ifirst         ) ,
    //
    .isLLR      ( ifsLLR         ) ,
    .iyLLR      ( ifyLLR         ) ,
    .iwLLR      ( ifwLLR         ) ,
    //
    .iLextr     ( ifLextr        ) ,
    //
    .oval       ( f_bmc__oval    ) ,
    .ogamma     ( f_bmc__ogamma  ) ,
    .oLapri     ( f_bmc__oLapri  ) ,
    .ohd        ( f_bmc__ohd     )
  );

  //------------------------------------------------------------------------------------------------------
  // recursion processor
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_rp_mod
  #(
    .pB_nF        ( 0              ) ,
    .pLLR_W       ( pLLR_W         ) ,
    .pLLR_FP      ( pLLR_FP        ) ,
    .pMMAX_TYPE   ( pMMAX_TYPE     ) ,
    .pUSE_P_COMP  ( pUSE_RP_P_COMP )
  )
  f_rp
  (
    .iclk        ( iclk              ) ,
    .ireset      ( ireset            ) ,
    .iclkena     ( iclkena           ) ,
    //
    .istate_clr  ( f_rp__istate_clr  ) ,
    .istate_ld   ( f_rp__istate_ld   ) ,
    .istate      ( f_rp__istate      ) ,
    //
    .ival        ( f_bmc__oval       ) ,
    .igamma      ( f_bmc__ogamma     ) ,
    //
    .oval        ( f_rp__oval        ) ,
    .ostate      (                   ) ,  // n.u.
    .ogamma      ( f_rp__ogamma      ) ,
    .ostate2mm   ( f_rp__ostate2mm   ) ,
    .ostate_last ( f_rp__ostate_last )
  );

  assign f_rp__istate_clr = 1'b0;

  //------------------------------------------------------------------------------------------------------
  // circular trellis logic
  //------------------------------------------------------------------------------------------------------

  assign f_rp__istate_ld = sop[0];  // 1 tick delay for b_rp__istate mux

  wire f_rp_eop = eop[cBMC_DELAY + cRP_DELAY]; // 1 tick delay after true op to f_rp__ostate_last become valid

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (isop & ifirst) begin
        f_rp__istate     <= '{default : '0};
        of_rp_state_even <= '{default : '0};
        of_rp_state_odd  <= '{default : '0};
      end
      else begin
        f_rp__istate <= ieven ? if_rp_state_even : if_rp_state_odd;
        //
        if (f_rp_eop) begin
          if (ieven) begin
            of_rp_state_even <= f_rp__ostate_last;
          end
          else begin
            of_rp_state_odd  <= f_rp__ostate_last;
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // mm
  //------------------------------------------------------------------------------------------------------

  codec_map_dec_mm
  #(
    .pDATA_W ( cSTATE_W * 16 ) ,
    .pADDR_W ( pMM_ADDR_W    )   // 1/N of pN
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

  assign f_mm__iwdata = {f_rp__ostate2mm[0],  f_rp__ostate2mm[1],  f_rp__ostate2mm[2],  f_rp__ostate2mm[3],
                         f_rp__ostate2mm[4],  f_rp__ostate2mm[5],  f_rp__ostate2mm[6],  f_rp__ostate2mm[7],
                         f_rp__ostate2mm[8],  f_rp__ostate2mm[9],  f_rp__ostate2mm[10], f_rp__ostate2mm[11],
                         f_rp__ostate2mm[12], f_rp__ostate2mm[13], f_rp__ostate2mm[14], f_rp__ostate2mm[15]};

  //------------------------------------------------------------------------------------------------------
  // Lapo
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_Lapo
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

  assign {f_Lapo__istate[0],  f_Lapo__istate[1],  f_Lapo__istate[2],  f_Lapo__istate[3],
          f_Lapo__istate[4],  f_Lapo__istate[5],  f_Lapo__istate[6],  f_Lapo__istate[7],
          f_Lapo__istate[8],  f_Lapo__istate[9],  f_Lapo__istate[10], f_Lapo__istate[11],
          f_Lapo__istate[12], f_Lapo__istate[13], f_Lapo__istate[14], f_Lapo__istate[15]} = b_mm__ordata;

  //------------------------------------------------------------------------------------------------------
  // delay line for Lapri & hd
  //------------------------------------------------------------------------------------------------------

  Lapri_t         f_Lapri [cRP_DELAY + cLAPO_DELAY]  /*synthesis keep */;
  logic   [1 : 0] f_hd    [cRP_DELAY + cLAPO_DELAY]  /*synthesis keep */;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < cRP_DELAY + cLAPO_DELAY; i++) begin
        f_Lapri[i] <= (i == 0) ? f_bmc__oLapri : f_Lapri[i-1];
        f_hd   [i] <= (i == 0) ? f_bmc__ohd    : f_hd   [i-1];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Lextr
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_Lextr
  #(
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  f_Lextr
  (
    .iclk     ( iclk              ) ,
    .ireset   ( ireset            ) ,
    .iclkena  ( iclkena           ) ,
    //
    .ival     ( f_Lextr__ival     ) ,
    .ibitswap ( f_Lextr__ibitswap ) ,
    .idat     ( f_Lextr__idat     ) ,
    .iLapri   ( f_Lextr__iLapri   ) ,
    .iLapo    ( f_Lextr__iLapo    ) ,
    //
    .oval     ( f_Lextr__oval     ) ,
    .oLextr   ( f_Lextr__oLextr   ) ,
    .odat     ( f_Lextr__odat     ) ,
    .oerr     ( f_Lextr__oerr     )
  );

  assign f_Lextr__ibitswap  = !ieven & bitswap[cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1];

  assign f_Lextr__ival      = f_Lapo__oval;
  assign f_Lextr__iLapo     = f_Lapo__oLapo;

  assign f_Lextr__idat      = f_hd    [cRP_DELAY + cLAPO_DELAY-1];
  assign f_Lextr__iLapri    = f_Lapri [cRP_DELAY + cLAPO_DELAY-1];

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

  // branch metric calculator
  logic                     b_bmc__oval       ;
  gamma_t                   b_bmc__ogamma     ;
  Lapri_t                   b_bmc__oLapri     ;
  logic             [1 : 0] b_bmc__ohd        ;
  //
  // recursion processor
  logic                     b_rp__istate_clr  ;
  logic                     b_rp__istate_ld   ;
  state_t                   b_rp__istate      ;

  logic                     b_rp__oval        ;
  gamma_t                   b_rp__ogamma      ;
  state_t                   b_rp__ostate2mm   ;
  state_t                   b_rp__ostate_last ;
  //
  // metric memory LIFO
  logic                     b_mm__iwrite      ;
  logic [cSTATE_W*16-1 : 0] b_mm__iwdata      ;
  logic                     b_mm__iread       ;
  //
  // aposteriory L
  logic                     b_Lapo__ival      ;
  gamma_t                   b_Lapo__igamma    ;
  state_t                   b_Lapo__istate    ;
  logic                     b_Lapo__oval      ;
  Lapo_t                    b_Lapo__oLapo     ;
  //
  // extrinsic L
  logic                     b_Lextr__ival     ;
  logic                     b_Lextr__ibitswap ;
  logic             [1 : 0] b_Lextr__idat     ;
  Lapri_t                   b_Lextr__iLapri   ;
  Lapo_t                    b_Lextr__iLapo    ;

  logic                     b_Lextr__oval     ;
  Lextr_t                   b_Lextr__oLextr   ;
  logic             [1 : 0] b_Lextr__odat     ;
  logic             [1 : 0] b_Lextr__oerr     ;

  //------------------------------------------------------------------------------------------------------
  // BMC
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_bmc
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
    .ival       (  ival          ) ,
    .ieven      (  ieven         ) ,
    .ibitswap   ( !ibitswap      ) , // inverse to forward !!!!
    .iLextr_clr (  ifirst        ) ,
    //
    .isLLR      ( ibsLLR         ) ,
    .iyLLR      ( ibyLLR         ) ,
    .iwLLR      ( ibwLLR         ) ,
    //
    .iLextr     ( ibLextr        ) ,
    //
    .oval       ( b_bmc__oval    ) ,
    .ogamma     ( b_bmc__ogamma  ) ,
    .oLapri     ( b_bmc__oLapri  ) ,
    .ohd        ( b_bmc__ohd     )
  );

  //------------------------------------------------------------------------------------------------------
  // RP
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_rp_mod
  #(
    .pB_nF        ( 1              ) ,
    .pLLR_W       ( pLLR_W         ) ,
    .pLLR_FP      ( pLLR_FP        ) ,
    .pMMAX_TYPE   ( pMMAX_TYPE     ) ,
    .pUSE_P_COMP  ( pUSE_RP_P_COMP )
  )
  b_rp
  (
    .iclk        ( iclk              ) ,
    .ireset      ( ireset            ) ,
    .iclkena     ( iclkena           ) ,
    //
    .istate_clr  ( b_rp__istate_clr  ) ,
    .istate_ld   ( b_rp__istate_ld   ) ,
    .istate      ( b_rp__istate      ) ,
    //
    .ival        ( b_bmc__oval       ) ,
    .igamma      ( b_bmc__ogamma     ) ,
    //
    .oval        ( b_rp__oval        ) ,
    .ostate      (                   ) ,  // n.u.
    .ogamma      ( b_rp__ogamma      ) ,
    .ostate2mm   ( b_rp__ostate2mm   ) ,
    .ostate_last ( b_rp__ostate_last )
  );

  assign b_rp__istate_clr = 1'b0;

  //------------------------------------------------------------------------------------------------------
  // circular trellis logic
  //------------------------------------------------------------------------------------------------------

  assign b_rp__istate_ld = sop[0]; // 1 tick delay for b_rp__istate mux

  wire b_rp_eop = eop[cBMC_DELAY + cRP_DELAY];  // 1 tick delay after true op to f_rp__ostate_last become valid

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (isop & ifirst) begin
        b_rp__istate     <= '{default : '0};
        ob_rp_state_even <= '{default : '0};
        ob_rp_state_odd  <= '{default : '0};
      end
      else begin
        b_rp__istate <= ieven ? ib_rp_state_even : ib_rp_state_odd;
        //
        if (b_rp_eop) begin
          if (ieven) begin
            ob_rp_state_even <= b_rp__ostate_last;
          end
          else begin
            ob_rp_state_odd  <= b_rp__ostate_last;
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // mm
  //------------------------------------------------------------------------------------------------------

  codec_map_dec_mm
  #(
    .pDATA_W ( cSTATE_W * 16 ) ,
    .pADDR_W ( pMM_ADDR_W    )   // 1/N of pN
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

  assign b_mm__iwdata = {b_rp__ostate2mm[0],  b_rp__ostate2mm[1],  b_rp__ostate2mm[2],  b_rp__ostate2mm[3],
                         b_rp__ostate2mm[4],  b_rp__ostate2mm[5],  b_rp__ostate2mm[6],  b_rp__ostate2mm[7],
                         b_rp__ostate2mm[8],  b_rp__ostate2mm[9],  b_rp__ostate2mm[10], b_rp__ostate2mm[11],
                         b_rp__ostate2mm[12], b_rp__ostate2mm[13], b_rp__ostate2mm[14], b_rp__ostate2mm[15]};

  //------------------------------------------------------------------------------------------------------
  // Lapo
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_Lapo
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

  assign {b_Lapo__istate[0],  b_Lapo__istate[1],  b_Lapo__istate[2],  b_Lapo__istate[3],
          b_Lapo__istate[4],  b_Lapo__istate[5],  b_Lapo__istate[6],  b_Lapo__istate[7],
          b_Lapo__istate[8],  b_Lapo__istate[9],  b_Lapo__istate[10], b_Lapo__istate[11],
          b_Lapo__istate[12], b_Lapo__istate[13], b_Lapo__istate[14], b_Lapo__istate[15]} = f_mm__ordata;

  //------------------------------------------------------------------------------------------------------
  // delay line for Lapri & hd
  //------------------------------------------------------------------------------------------------------

  Lapri_t         b_Lapri [cRP_DELAY + cLAPO_DELAY] /*synthesis keep */;
  logic   [1 : 0] b_hd    [cRP_DELAY + cLAPO_DELAY] /*synthesis keep */;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < cRP_DELAY + cLAPO_DELAY; i++) begin
        b_Lapri[i] <= (i == 0) ? b_bmc__oLapri : b_Lapri[i-1];
        b_hd   [i] <= (i == 0) ? b_bmc__ohd    : b_hd   [i-1];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Lextr
  //------------------------------------------------------------------------------------------------------

  rsc2_dec_Lextr
  #(
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  b_Lextr
  (
    .iclk     ( iclk              ) ,
    .ireset   ( ireset            ) ,
    .iclkena  ( iclkena           ) ,
    //
    .ival     ( b_Lextr__ival     ) ,
    .ibitswap ( b_Lextr__ibitswap ) ,
    .idat     ( b_Lextr__idat     ) ,
    .iLapri   ( b_Lextr__iLapri   ) ,
    .iLapo    ( b_Lextr__iLapo    ) ,
    //
    .oval     ( b_Lextr__oval     ) ,
    .oLextr   ( b_Lextr__oLextr   ) ,
    .odat     ( b_Lextr__odat     ) ,
    .oerr     ( b_Lextr__oerr     )
  );

  assign b_Lextr__ibitswap  = !ieven & !bitswap[cBMC_DELAY + cRP_DELAY + cLAPO_DELAY-1]; // inverse to forward !!!!

  assign b_Lextr__ival      = b_Lapo__oval;
  assign b_Lextr__iLapo     = b_Lapo__oLapo;

  assign b_Lextr__idat      = b_hd    [cRP_DELAY + cLAPO_DELAY-1];
  assign b_Lextr__iLapri    = b_Lapri [cRP_DELAY + cLAPO_DELAY-1];

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

  assign odatval  = f_Lextr__oval;// & last[cDELAY-1]; incorrect for some Wimax combination of (ptype 7/11/13/17 and frame length)

  assign ofLextr  = f_Lextr__oLextr;
  assign ofdat    = f_Lextr__odat;
  assign ofderr   = f_Lextr__oerr;

  assign ofdtag   = fdtag[cDELAY-1];

  assign obLextr  = b_Lextr__oLextr;
  assign obdat    = b_Lextr__odat;
  assign obderr   = b_Lextr__oerr;

  assign obdtag   = bdtag[cDELAY-1];

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
        oerr <= oerr + get_dbit_err(f_Lextr__oerr, b_Lextr__oerr);
      end
    end
  end

  function automatic logic [2 : 0] get_dbit_err (input logic [1 : 0] f, b);
    get_dbit_err = f[0] + f[1] + b[0] + b[1];
  endfunction

endmodule
