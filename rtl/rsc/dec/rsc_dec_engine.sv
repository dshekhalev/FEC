/*



  parameter int pLLR_W         = 5 ;
  parameter int pLLR_FP        = 2 ;
  parameter int pDTAG_W        = 2 ;
  parameter int pADDR_W        = 8 ;
  parameter int pTAG_W         = 1 ;
  //
  parameter int pMMAX_TYPE     = 0 ;
  parameter bit pUSE_WIMAX     = 0 ;
  parameter int pUSE_IBUF_PIPE = 1 ;
  parameter int pUSE_RP_P_COMP = 1 ;
  //
  parameter int pFIX_MODE      = 0 ;



  logic                      rsc_dec_engine__iclk            ;
  logic                      rsc_dec_engine__ireset          ;
  logic                      rsc_dec_engine__iclkena         ;
  //
  logic                      rsc_dec_engine__irbuf_full      ;
  code_ctx_t                 rsc_dec_engine__icode_ctx       ;
  logic              [3 : 0] rsc_dec_engine__iNiter          ;
  logic       [pTAG_W-1 : 0] rsc_dec_engine__irtag           ;
  logic                      rsc_dec_engine__orempty         ;
  //
  bit_llr_t                  rsc_dec_engine__irfsLLR     [2] ;
  bit_llr_t                  rsc_dec_engine__irfyLLR     [2] ;
  bit_llr_t                  rsc_dec_engine__irfwLLR     [2] ;
  logic      [pDTAG_W-1 : 0] rsc_dec_engine__irfsLLRtag      ;
  logic      [pADDR_W-1 : 0] rsc_dec_engine__ofsaddr         ;
  logic      [pADDR_W-1 : 0] rsc_dec_engine__ofpaddr         ;
  //
  bit_llr_t                  rsc_dec_engine__irbsLLR     [2] ;
  bit_llr_t                  rsc_dec_engine__irbyLLR     [2] ;
  bit_llr_t                  rsc_dec_engine__irbwLLR     [2] ;
  logic      [pDTAG_W-1 : 0] rsc_dec_engine__irbsLLRtag      ;
  logic      [pADDR_W-1 : 0] rsc_dec_engine__obsaddr         ;
  logic      [pADDR_W-1 : 0] rsc_dec_engine__obpaddr         ;
  //
  logic                      rsc_dec_engine__iwbuf_empty     ;
  //
  logic                      rsc_dec_engine__owrite          ;
  logic                      rsc_dec_engine__owfull          ;
  dbits_num_t                rsc_dec_engine__ownum           ;
  logic       [pTAG_W-1 : 0] rsc_dec_engine__owtag           ;
  logic             [15 : 0] rsc_dec_engine__owerr           ;
  //
  logic      [pADDR_W-1 : 0] rsc_dec_engine__owfaddr         ;
  logic              [1 : 0] rsc_dec_engine__owfdat          ;
  logic              [1 : 0] rsc_dec_engine__owfderr         ;
  logic      [pDTAG_W-1 : 0] rsc_dec_engine__owfdtag         ;
  //
  logic      [pADDR_W-1 : 0] rsc_dec_engine__owbaddr         ;
  logic              [1 : 0] rsc_dec_engine__owbdat          ;
  logic              [1 : 0] rsc_dec_engine__owbderr         ;
  logic      [pDTAG_W-1 : 0] rsc_dec_engine__owbdtag         ;



  rsc_dec_engine
  #(
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_FP        ( pLLR_FP        ) ,
    .pDTAG_W        ( pDTAG_W        ) ,
    .pADDR_W        ( pADDR_W        ) ,
    .pTAG_W         ( pTAG_W         ) ,
    //
    .pMMAX_TYPE     ( pMMAX_TYPE     ) ,
    .pUSE_WIMAX     ( pUSE_WIMAX     ) ,
    .pUSE_IBUF_PIPE ( pUSE_IBUF_PIPE ) ,
    .pUSE_RP_P_COMP ( pUSE_RP_P_COMP ) ,
    //
    .pFIX_MODE      ( pFIX_MODE      ) ,
  )
  rsc_dec_engine
  (
    .iclk        ( rsc_dec_engine__iclk        ) ,
    .ireset      ( rsc_dec_engine__ireset      ) ,
    .iclkena     ( rsc_dec_engine__iclkena     ) ,
    //
    .irbuf_full  ( rsc_dec_engine__irbuf_full  ) ,
    .icode_ctx   ( rsc_dec_engine__icode_ctx   ) ,
    .iNiter      ( rsc_dec_engine__iNiter      ) ,
    .irtag       ( rsc_dec_engine__irtag       ) ,
    .orempty     ( rsc_dec_engine__orempty     ) ,
    //
    .irfsLLR     ( rsc_dec_engine__irfsLLR     ) ,
    .irfyLLR     ( rsc_dec_engine__irfyLLR     ) ,
    .irfwLLR     ( rsc_dec_engine__irfwLLR     ) ,
    .irfsLLRtag  ( rsc_dec_engine__irfsLLRtag  ) ,
    .ofsaddr     ( rsc_dec_engine__ofsaddr     ) ,
    .ofpaddr     ( rsc_dec_engine__ofpaddr     ) ,
    //
    .irbsLLR     ( rsc_dec_engine__irbsLLR     ) ,
    .irbyLLR     ( rsc_dec_engine__irbyLLR     ) ,
    .irbwLLR     ( rsc_dec_engine__irbwLLR     ) ,
    .irbsLLRtag  ( rsc_dec_engine__irbsLLRtag  ) ,
    .obsaddr     ( rsc_dec_engine__obsaddr     ) ,
    .obpaddr     ( rsc_dec_engine__obpaddr     ) ,
    //
    .iwbuf_empty ( rsc_dec_engine__iwbuf_empty ) ,
    //
    .owrite      ( rsc_dec_engine__owrite      ) ,
    .owfull      ( rsc_dec_engine__owfull      ) ,
    .ownum       ( rsc_dec_engine__ownum       ) ,
    .owtag       ( rsc_dec_engine__owtag       ) ,
    .owerr       ( rsc_dec_engine__owerr       ) ,
    //
    .owfaddr     ( rsc_dec_engine__owfaddr     ) ,
    .owfdat      ( rsc_dec_engine__owfdat      ) ,
    .owfderr     ( rsc_dec_engine__owfderr     ) ,
    .owfdtag     ( rsc_dec_engine__owfdtag     ) ,
    //
    .owbaddr     ( rsc_dec_engine__owbaddr     ) ,
    .owbdat      ( rsc_dec_engine__owbdat      ) ,
    .owbderr     ( rsc_dec_engine__owbderr     ) ,
    .owbdtag     ( rsc_dec_engine__owbdtag     )
  );


  assign rsc_dec_engine__iclk        = '0 ;
  assign rsc_dec_engine__ireset      = '0 ;
  assign rsc_dec_engine__iclkena     = '0 ;
  assign rsc_dec_engine__irbuf_full  = '0 ;
  assign rsc_dec_engine__icode_ctx   = '0 ;
  assign rsc_dec_engine__iNiter      = '0 ;
  assign rsc_dec_engine__irtag       = '0 ;
  assign rsc_dec_engine__irfsLLR     = '0 ;
  assign rsc_dec_engine__irfyLLR     = '0 ;
  assign rsc_dec_engine__irfwLLR     = '0 ;
  assign rsc_dec_engine__irfsLLRtag  = '0 ;
  assign rsc_dec_engine__irbsLLR     = '0 ;
  assign rsc_dec_engine__irbyLLR     = '0 ;
  assign rsc_dec_engine__irbwLLR     = '0 ;
  assign rsc_dec_engine__irbsLLRtag  = '0 ;
  assign rsc_dec_engine__iwbuf_empty = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_engine.sv
// Description   : RSC decoder engine top level
//

module rsc_dec_engine
#(
  parameter int pLLR_W         = 5 ,
  parameter int pLLR_FP        = 2 ,
  parameter int pDTAG_W        = 2 ,  // duo-bit tag for multichannel
  parameter int pADDR_W        = 8 ,
  parameter int pTAG_W         = 1 ,
  //
  parameter int pMMAX_TYPE     = 0 ,
  parameter bit pUSE_WIMAX     = 0 ,
  parameter bit pUSE_IBUF_PIPE = 1 ,
  parameter int pUSE_RP_P_COMP = 1 ,
  //
  parameter int pFIX_MODE      = 0
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  irbuf_full  ,
  icode_ctx   ,
  iNiter      ,
  irtag       ,
  orempty     ,
  //
  irfsLLR     ,
  irfyLLR     ,
  irfwLLR     ,
  irfsLLRtag  ,
  ofsaddr     ,
  ofpaddr     ,
  //
  irbsLLR     ,
  irbyLLR     ,
  irbwLLR     ,
  irbsLLRtag  ,
  obsaddr     ,
  obpaddr     ,
  //
  iwbuf_empty ,
  //
  owrite      ,
  owfull      ,
  ownum       ,
  owtag       ,
  owerr       ,
  //
  owfaddr     ,
  owfdat      ,
  owfderr     ,
  owfdtag     ,
  //
  owbaddr     ,
  owbdat      ,
  owbderr     ,
  owbdtag
);

  `include "../rsc_constants.svh"
  `include "rsc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                      iclk           ;
  input  logic                      ireset         ;
  input  logic                      iclkena        ;
  //
  input  logic                      irbuf_full     ;
  input  code_ctx_t                 icode_ctx      ;
  input  logic              [3 : 0] iNiter         ;
  input  logic       [pTAG_W-1 : 0] irtag          ;  // block tag
  output logic                      orempty        ;
  //
  input  bit_llr_t                  irfsLLR    [2] ;
  input  bit_llr_t                  irfyLLR    [2] ;
  input  bit_llr_t                  irfwLLR    [2] ;
  input  logic      [pDTAG_W-1 : 0] irfsLLRtag     ;  // forward duo-bit tag
  output logic      [pADDR_W-1 : 0] ofsaddr        ;
  output logic      [pADDR_W-1 : 0] ofpaddr        ;
  //
  input  bit_llr_t                  irbsLLR    [2] ;
  input  bit_llr_t                  irbyLLR    [2] ;
  input  bit_llr_t                  irbwLLR    [2] ;
  input  logic      [pDTAG_W-1 : 0] irbsLLRtag     ;  // backward duo-bit tag
  output logic      [pADDR_W-1 : 0] obsaddr        ;
  output logic      [pADDR_W-1 : 0] obpaddr        ;
  //
  input  logic                      iwbuf_empty    ;
  //
  output logic                      owrite         ;
  output logic                      owfull         ;
  output dbits_num_t                ownum          ;
  output logic       [pTAG_W-1 : 0] owtag          ;
  output logic             [15 : 0] owerr          ;
  //
  output logic      [pADDR_W-1 : 0] owfaddr        ;
  output logic              [1 : 0] owfdat         ;
  output logic              [1 : 0] owfderr        ;
  output logic      [pDTAG_W-1 : 0] owfdtag        ;
  //
  output logic      [pADDR_W-1 : 0] owbaddr        ;
  output logic              [1 : 0] owbdat         ;
  output logic              [1 : 0] owbderr        ;
  output logic      [pDTAG_W-1 : 0] owbdtag        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cEXTR_RAM_ADDR_W = pADDR_W;
  localparam int cEXTR_RAM_DATA_W = cL_EXT_W*3;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // parameter table
  logic                 [4 : 0] ptab__iptype   ;
  dbits_num_t                   ptab__iN       ;

  dbits_num_t                   used_N         ;
  dbits_num_t                   used_Nm1       ;
  dbits_num_t                   used_P     [4] ;
  dbits_num_t                   used_P0comp    ;
  dbits_num_t                   used_Pincr     ;
  logic                         used_Pdvbinv   ;

  //
  // ctrl
  logic                         ctrl__oaddr_pmode      ;
  logic                         ctrl__oaddr_clear      ;
  logic                         ctrl__oaddr_enable     ;

  logic                         ctrl__ofirst_sub_stage ;
  logic                         ctrl__olast_sub_stage  ;
  logic                         ctrl__oeven_sub_stage  ;
  logic                         ctrl__osub_stage_warm  ;

  logic                         ctrl__idec_eop         ;
  logic                         ctrl__odec_sop         ;
  logic                         ctrl__odec_val         ;
  logic                         ctrl__odec_eop         ;

  // address generator
  logic                          addr_gen__obitinv ;
  dbits_num_t                   faddr_gen__osaddr  ;
  dbits_num_t                   faddr_gen__opaddr  ;
  dbits_num_t                   baddr_gen__osaddr  ;
  dbits_num_t                   baddr_gen__opaddr  ;

  //
  // MAP engine
  logic                         map__ifirst           ;
  logic                         map__ilast            ;
  logic                         map__ieven            ;
  logic                         map__ibitswap         ;
  logic                         map__iwarm            ;

  logic                         map__isop             ;
  logic                         map__ival             ;
  logic                         map__ieop             ;

  logic         [pADDR_W-1 : 0] map__ifaddr           ;
  bit_llr_t                     map__ifsLLR       [2] ;
  bit_llr_t                     map__ifyLLR       [2] ;
  bit_llr_t                     map__ifwLLR       [2] ;
  Lextr_t                       map__ifLextr          ;
  logic         [pDTAG_W-1 : 0] map__ifsLLRtag        ;

  logic         [pADDR_W-1 : 0] map__ibaddr           ;
  bit_llr_t                     map__ibsLLR       [2] ;
  bit_llr_t                     map__ibyLLR       [2] ;
  bit_llr_t                     map__ibwLLR       [2] ;
  Lextr_t                       map__ibLextr          ;
  logic         [pDTAG_W-1 : 0] map__ibsLLRtag        ;

  state_t                       map__if_rp_state_even ;
  state_t                       map__if_rp_state_odd  ;
  state_t                       map__ib_rp_state_even ;
  state_t                       map__ib_rp_state_odd  ;

  state_t                       map__of_rp_state_even ;
  state_t                       map__of_rp_state_odd  ;
  state_t                       map__ob_rp_state_even ;
  state_t                       map__ob_rp_state_odd  ;

  logic                         map__osop             ;
  logic                         map__oeop             ;
  logic                         map__oval             ;
  logic                         map__odatval          ;

  logic         [pADDR_W-1 : 0] map__ofaddr           ;
  Lextr_t                       map__ofLextr          ;
  logic                 [1 : 0] map__ofdat            ;
  logic                 [1 : 0] map__ofderr           ;
  logic         [pDTAG_W-1 : 0] map__ofdtag           ;

  logic         [pADDR_W-1 : 0] map__obaddr           ;
  Lextr_t                       map__obLextr          ;
  logic                 [1 : 0] map__obdat            ;
  logic                 [1 : 0] map__obderr           ;
  logic         [pDTAG_W-1 : 0] map__obdtag           ;

  logic                         map__odone            ;
  logic                [15 : 0] map__oerr             ;

  //
  // extrinsic ram
  logic                          extr_ram__iwrite   ;
  logic [cEXTR_RAM_ADDR_W-1 : 0] extr_ram__iwaddr0  ;
  logic [cEXTR_RAM_DATA_W-1 : 0] extr_ram__iwdata0  ;
  logic [cEXTR_RAM_ADDR_W-1 : 0] extr_ram__iwaddr1  ;
  logic [cEXTR_RAM_DATA_W-1 : 0] extr_ram__iwdata1  ;

  logic                          extr_ram__iread    ;
  logic [cEXTR_RAM_ADDR_W-1 : 0] extr_ram__iraddr0  ;
  logic [cEXTR_RAM_DATA_W-1 : 0] extr_ram__ordata0  ;
  logic [cEXTR_RAM_ADDR_W-1 : 0] extr_ram__iraddr1  ;
  logic [cEXTR_RAM_DATA_W-1 : 0] extr_ram__ordata1  ;

  //------------------------------------------------------------------------------------------------------
  // decode permutation type decoder
  //------------------------------------------------------------------------------------------------------

  generate
    if (pFIX_MODE) begin
      rsc_ptable
      ptab
      (
        .iclk       ( iclk         ) ,
        .ireset     ( ireset       ) ,
        .iclkena    ( iclkena      ) ,
        //
        .iptype     ( ptab__iptype ) ,
        .iN         ( ptab__iN     ) ,
        //
        .oN         ( used_N       ) ,
        .oNm1       ( used_Nm1     ) ,
        .oNmod7     (              ) ,  // n.u.
        //
        .oP         ( used_P       ) ,
        .oP0comp    ( used_P0comp  ) ,
        .oPAx2_comp (              ) , // n.u.
        .oPincr     ( used_Pincr   ) ,
        .oPdvbinv   ( used_Pdvbinv )
      );
    end
    else begin
      rsc_ptable_gen
      ptab
      (
        .iclk       ( iclk         ) ,
        .ireset     ( ireset       ) ,
        .iclkena    ( iclkena      ) ,
        //
        .iptype     ( ptab__iptype ) ,
        .iN         ( ptab__iN     ) ,
        //
        .oN         ( used_N       ) ,
        .oNm1       ( used_Nm1     ) ,
        .oNmod7     (              ) ,  // n.u.
        //
        .oP         ( used_P       ) ,
        .oP0comp    ( used_P0comp  ) ,
        .oPAx2_comp (              ) , // n.u.
        .oPincr     ( used_Pincr   ) ,
        .oPdvbinv   ( used_Pdvbinv )
      );
    end
  endgenerate

  assign ptab__iptype = icode_ctx.ptype;
  assign ptab__iN     = pUSE_WIMAX ? icode_ctx.Ndbits : '0;

  //------------------------------------------------------------------------------------------------------
  // decoder FSM
  //------------------------------------------------------------------------------------------------------

  rsc_dec_ctrl
  ctrl
  (
    .iclk             ( iclk                   ) ,
    .ireset           ( ireset                 ) ,
    .iclkena          ( iclkena                ) ,
    //
    .iN               ( used_N                 ) ,
    .iNiter           ( iNiter                 ) ,
    //
    .ibuf_full        ( irbuf_full             ) ,  // if ibuffer full start
    .obuf_rempty      ( orempty                ) ,
    .iobuf_empty      ( iwbuf_empty            ) ,  // if obuffer is empty end
    //
    .oaddr_pmode      ( ctrl__oaddr_pmode      ) ,
    .oaddr_clear      ( ctrl__oaddr_clear      ) ,
    .oaddr_enable     ( ctrl__oaddr_enable     ) ,
    //
    .ofirst_sub_stage ( ctrl__ofirst_sub_stage ) ,
    .olast_sub_stage  ( ctrl__olast_sub_stage  ) ,
    .oeven_sub_stage  ( ctrl__oeven_sub_stage  ) ,
    .osub_stage_warm  ( ctrl__osub_stage_warm  ) ,
    //
    .idec_eop         ( ctrl__idec_eop         ) ,
    .odec_sop         ( ctrl__odec_sop         ) ,
    .odec_val         ( ctrl__odec_val         ) ,
    .odec_eop         ( ctrl__odec_eop         )
  );

  assign ctrl__idec_eop = map__oeop;

  //------------------------------------------------------------------------------------------------------
  // address generators
  //------------------------------------------------------------------------------------------------------

   rsc_dec_addr_gen
   #(
     .pB_nF ( 0 )
   )
   faddr_gen
   (
     .iclk     ( iclk               ) ,
     .ireset   ( ireset             ) ,
     .iclkena  ( iclkena            ) ,
     //
     .ipmode   ( ctrl__oaddr_pmode  ) ,
     .iclear   ( ctrl__oaddr_clear  ) ,
     .ienable  ( ctrl__oaddr_enable ) ,
     //
     .iN       ( used_N             ) ,
     .iNm1     ( used_Nm1           ) ,
     .iP       ( used_P             ) ,
     .iP0comp  ( used_P0comp        ) ,
     .iPincr   ( used_Pincr         ) ,
     .iPdvbinv ( used_Pdvbinv       ) ,
     //
     .osaddr   ( faddr_gen__osaddr  ) ,
     .opaddr   ( faddr_gen__opaddr  ) ,
     .obitinv  (  addr_gen__obitinv )
   );

   assign ofsaddr = faddr_gen__osaddr[pADDR_W-1 : 0];
   assign ofpaddr = faddr_gen__opaddr[pADDR_W-1 : 0];

   rsc_dec_addr_gen
   #(
     .pB_nF ( 1 )
   )
   baddr_gen
   (
     .iclk     ( iclk               ) ,
     .ireset   ( ireset             ) ,
     .iclkena  ( iclkena            ) ,
     //
     .ipmode   ( ctrl__oaddr_pmode  ) ,
     .iclear   ( ctrl__oaddr_clear  ) ,
     .ienable  ( ctrl__oaddr_enable ) ,
     //
     .iN       ( used_N             ) ,
     .iNm1     ( used_Nm1           ) ,
     .iP       ( used_P             ) ,
     .iP0comp  ( used_P0comp        ) ,
     .iPincr   ( used_Pincr         ) ,
     .iPdvbinv ( used_Pdvbinv       ) ,
     //
     .osaddr   ( baddr_gen__osaddr  ) ,
     .opaddr   ( baddr_gen__opaddr  ) ,
     .obitinv  (  ) // n.u.
   );

   assign obsaddr = baddr_gen__osaddr[pADDR_W-1 : 0];
   assign obpaddr = baddr_gen__opaddr[pADDR_W-1 : 0];

  //------------------------------------------------------------------------------------------------------
  // MAP engine
  //------------------------------------------------------------------------------------------------------

  logic                 map_bitswap ;
  logic                 map_warm    ;
  logic                 map_sop     ;
  logic                 map_val     ;
  logic                 map_eop     ;

  logic [pADDR_W-1 : 0] map_faddr   ;
  logic [pADDR_W-1 : 0] map_baddr   ;

  rsc_dec_map_engine
  #(
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_FP        ( pLLR_FP        ) ,
    .pDTAG_W        ( pDTAG_W        ) ,
    //
    .pADDR_W        ( pADDR_W        ) ,
    .pMM_ADDR_W     ( pADDR_W-1      ) , // 1/2 of pN
    //
    .pMMAX_TYPE     ( pMMAX_TYPE     ) ,
    //
    .pUSE_RP_P_COMP ( pUSE_RP_P_COMP )
  )
  map
  (
    .iclk             ( iclk                  ) ,
    .ireset           ( ireset                ) ,
    .iclkena          ( iclkena               ) ,
    //
    .ifirst           ( map__ifirst           ) ,
    .ilast            ( map__ilast            ) ,
    .ieven            ( map__ieven            ) ,
    .ibitswap         ( map__ibitswap         ) ,
    .iwarm            ( map__iwarm            ) ,
    //
    .isop             ( map__isop             ) ,
    .ival             ( map__ival             ) ,
    .ieop             ( map__ieop             ) ,
    //
    .ifaddr           ( map__ifaddr           ) ,
    .ifsLLR           ( map__ifsLLR           ) ,
    .ifyLLR           ( map__ifyLLR           ) ,
    .ifwLLR           ( map__ifwLLR           ) ,
    .ifLextr          ( map__ifLextr          ) ,
    .ifsLLRtag        ( map__ifsLLRtag        ) ,
    //
    .ibaddr           ( map__ibaddr           ) ,
    .ibsLLR           ( map__ibsLLR           ) ,
    .ibyLLR           ( map__ibyLLR           ) ,
    .ibwLLR           ( map__ibwLLR           ) ,
    .ibLextr          ( map__ibLextr          ) ,
    .ibsLLRtag        ( map__ibsLLRtag        ) ,
    //
    .if_rp_state_even ( map__if_rp_state_even ) ,
    .if_rp_state_odd  ( map__if_rp_state_odd  ) ,
    .ib_rp_state_even ( map__ib_rp_state_even ) ,
    .ib_rp_state_odd  ( map__ib_rp_state_odd  ) ,
    //
    .of_rp_state_even ( map__of_rp_state_even ) ,
    .of_rp_state_odd  ( map__of_rp_state_odd  ) ,
    .ob_rp_state_even ( map__ob_rp_state_even ) ,
    .ob_rp_state_odd  ( map__ob_rp_state_odd  ) ,
    //
    .osop             ( map__osop             ) ,
    .oeop             ( map__oeop             ) ,
    .oval             ( map__oval             ) ,
    .odatval          ( map__odatval          ) ,
    //
    .ofaddr           ( map__ofaddr           ) ,
    .ofLextr          ( map__ofLextr          ) ,
    .ofdat            ( map__ofdat            ) ,
    .ofderr           ( map__ofderr           ) ,
    .ofdtag           ( map__ofdtag           ) ,
    //
    .obaddr           ( map__obaddr           ) ,
    .obLextr          ( map__obLextr          ) ,
    .obdat            ( map__obdat            ) ,
    .obderr           ( map__obderr           ) ,
    .obdtag           ( map__obdtag           ) ,
    //
    .odone            ( map__odone            ) ,
    .oerr             ( map__oerr             )
  );

  assign map__ifirst            = ctrl__ofirst_sub_stage;
  assign map__ilast             = ctrl__olast_sub_stage;
  assign map__ieven             = ctrl__oeven_sub_stage;

  assign map__if_rp_state_even  = map__of_rp_state_even;
  assign map__if_rp_state_odd   = map__of_rp_state_odd ;

  assign map__ib_rp_state_even  = map__ob_rp_state_even;
  assign map__ib_rp_state_odd   = map__ob_rp_state_odd ;

  //
  // align input buffer read delay
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (pUSE_IBUF_PIPE) begin
        {map__ifaddr,   map_faddr  } <= {map_faddr,   faddr_gen__osaddr[pADDR_W-1 : 0]};
        {map__ibaddr,   map_baddr  } <= {map_baddr,   baddr_gen__osaddr[pADDR_W-1 : 0]};
        {map__ibitswap, map_bitswap} <= {map_bitswap,  addr_gen__obitinv};
        //
        {map__iwarm, map_warm} <= {map_warm, ctrl__osub_stage_warm};
        {map__isop,  map_sop } <= {map_sop,  ctrl__odec_sop};
        {map__ival,  map_val } <= {map_val,  ctrl__odec_val};
        {map__ieop,  map_eop } <= {map_eop,  ctrl__odec_eop};
      end
      else begin
        map__ifaddr   <= faddr_gen__osaddr[pADDR_W-1 : 0];
        map__ibaddr   <= baddr_gen__osaddr[pADDR_W-1 : 0];
        map__ibitswap <=  addr_gen__obitinv;
        //
        map__iwarm    <= ctrl__osub_stage_warm;
        map__isop     <= ctrl__odec_sop;
        map__ival     <= ctrl__odec_val;
        map__ieop     <= ctrl__odec_eop;
      end
    end
  end

  assign map__ifsLLR    = irfsLLR;
  assign map__ifyLLR    = irfyLLR;
  assign map__ifwLLR    = irfwLLR;
  assign map__ifsLLRtag = irfsLLRtag;

  assign {map__ifLextr[3], map__ifLextr[2], map__ifLextr[1]} = extr_ram__ordata0;

  assign map__ibsLLR    = irbsLLR;
  assign map__ibyLLR    = irbyLLR;
  assign map__ibwLLR    = irbwLLR;
  assign map__ibsLLRtag = irbsLLRtag;

  assign {map__ibLextr[3], map__ibLextr[2], map__ibLextr[1]} = extr_ram__ordata1;

  //------------------------------------------------------------------------------------------------------
  // extrinsic buffer
  //------------------------------------------------------------------------------------------------------

  codec_map_dec_extr_ram
  #(
    .pADDR_W ( cEXTR_RAM_ADDR_W ) ,
    .pDATA_W ( cEXTR_RAM_DATA_W ) ,
    //
    .pWPIPE  ( pUSE_IBUF_PIPE   ) ,
    .pRDPIPE ( pUSE_IBUF_PIPE   )
  )
  extr_ram
  (
    .iclk    ( iclk              ) ,
    .ireset  ( ireset            ) ,
    .iclkena ( iclkena           ) ,
    //
    .iwrite  ( extr_ram__iwrite  ) ,
    //
    .iwaddr0 ( extr_ram__iwaddr0 ) ,
    .iwdata0 ( extr_ram__iwdata0 ) ,
    //
    .iwaddr1 ( extr_ram__iwaddr1 ) ,
    .iwdata1 ( extr_ram__iwdata1 ) ,
    //
    .iread   ( 1'b1              ) ,
    //
    .iraddr0 ( extr_ram__iraddr0 ) ,
    .ordata0 ( extr_ram__ordata0 ) ,
    //
    .iraddr1 ( extr_ram__iraddr1 ) ,
    .ordata1 ( extr_ram__ordata1 )
  );

  // write side
  assign extr_ram__iwrite  =  map__oval ;

  assign extr_ram__iwaddr0 =  map__ofaddr;
  assign extr_ram__iwdata0 = {map__ofLextr[3], map__ofLextr[2], map__ofLextr[1]};
  //
  assign extr_ram__iwaddr1 =  map__obaddr ;
  assign extr_ram__iwdata1 = {map__obLextr[3], map__obLextr[2], map__obLextr[1]} ;

  // read side
  assign extr_ram__iread   = 1'b1 ;
  //
  assign extr_ram__iraddr0 = faddr_gen__osaddr[cEXTR_RAM_ADDR_W-1 : 0] ;
  assign extr_ram__iraddr1 = baddr_gen__osaddr[cEXTR_RAM_ADDR_W-1 : 0] ;

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  assign owrite   = map__odatval ; // write only at last half-iteration
  assign owfull   = map__odone   ;
  assign owerr    = map__oerr    ;
  //
  assign ownum    = used_N       ;
  assign owtag    = irtag        ;
  //
  assign owfaddr  = map__ofaddr ;
  assign owfdat   = map__ofdat  ;
  assign owfderr  = map__ofderr ;
  assign owfdtag  = map__ofdtag ;
  //
  assign owbaddr  = map__obaddr ;
  assign owbdat   = map__obdat  ;
  assign owbderr  = map__obderr ;
  assign owbdtag  = map__obdtag ;

endmodule
