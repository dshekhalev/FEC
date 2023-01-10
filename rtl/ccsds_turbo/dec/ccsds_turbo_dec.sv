/*



  parameter int pLLR_W          =  4 ;
  parameter int pLLR_FP         =  4 ;
  parameter int pODAT_W         =  2 ;
  parameter int pTAG_W          =  8 ;
  parameter int pN_MAX          = 64 ;
  parameter int pMMAX_TYPE      =  0 ;
  parameter bit pUSE_FIXED_CODE =  0 ;
  parameter bit pUSE_SC_MODE    =  0 ;
  parameter bit pUSE_RAM_PIPE   =  1 ;




  logic                       ccsds_turbo_dec__iclk    ;
  logic                       ccsds_turbo_dec__ireset  ;
  logic                       ccsds_turbo_dec__iclkena ;
  logic               [1 : 0] ccsds_turbo_dec__icode   ;
  logic               [1 : 0] ccsds_turbo_dec__inidx   ;
  logic               [7 : 0] ccsds_turbo_dec__iNiter  ;
  logic        [pTAG_W-1 : 0] ccsds_turbo_dec__itag    ;
  logic                       ccsds_turbo_dec__isop    ;
  logic                       ccsds_turbo_dec__ieop    ;
  logic                       ccsds_turbo_dec__ieof    ;
  logic                       ccsds_turbo_dec__ival    ;
  logic signed [pLLR_W-1 : 0] ccsds_turbo_dec__iLLR    ;
  logic                       ccsds_turbo_dec__obusy   ;
  logic                       ccsds_turbo_dec__ordy    ;
  logic                       ccsds_turbo_dec__ireq    ;
  logic                       ccsds_turbo_dec__ofull   ;
  logic        [pTAG_W-1 : 0] ccsds_turbo_dec__otag    ;
  logic                       ccsds_turbo_dec__osop    ;
  logic                       ccsds_turbo_dec__oeop    ;
  logic                       ccsds_turbo_dec__oval    ;
  logic                       ccsds_turbo_dec__odat    ;
  logic              [15 : 0] ccsds_turbo_dec__oerr    ;



  ccsds_turbo_dec
  #(
    .pLLR_W          ( pLLR_W          ) ,
    .pLLR_FP         ( pLLR_FP         ) ,
    .pODAT_W         ( pODAT_W         ) ,
    .pTAG_W          ( pTAG_W          ) ,
    .pN_MAX          ( pN_MAX          ) ,
    .pMMAX_TYPE      ( pMMAX_TYPE      ) ,
    .pUSE_FIXED_CODE ( pUSE_FIXED_CODE ) ,
    .pUSE_SC_MODE    ( pUSE_SC_MODE    ) ,
    .pUSE_RAM_PIPE   ( pUSE_RAM_PIPE   )
  )
  ccsds_turbo_dec
  (
    .iclk    ( ccsds_turbo_dec__iclk    ) ,
    .ireset  ( ccsds_turbo_dec__ireset  ) ,
    .iclkena ( ccsds_turbo_dec__iclkena ) ,
    .icode   ( ccsds_turbo_dec__icode   ) ,
    .inidx   ( ccsds_turbo_dec__inidx   ) ,
    .iNiter  ( ccsds_turbo_dec__iNiter  ) ,
    .itag    ( ccsds_turbo_dec__itag    ) ,
    .isop    ( ccsds_turbo_dec__isop    ) ,
    .ieop    ( ccsds_turbo_dec__ieop    ) ,
    .ieof    ( ccsds_turbo_dec__ieof    ) ,
    .ival    ( ccsds_turbo_dec__ival    ) ,
    .iLLR    ( ccsds_turbo_dec__iLLR    ) ,
    .obusy   ( ccsds_turbo_dec__obusy   ) ,
    .ordy    ( ccsds_turbo_dec__ordy    ) ,
    .ireq    ( ccsds_turbo_dec__ireq    ) ,
    .ofull   ( ccsds_turbo_dec__ofull   ) ,
    .otag    ( ccsds_turbo_dec__otag    ) ,
    .osop    ( ccsds_turbo_dec__osop    ) ,
    .oeop    ( ccsds_turbo_dec__oeop    ) ,
    .oval    ( ccsds_turbo_dec__oval    ) ,
    .odat    ( ccsds_turbo_dec__odat    ) ,
    .oerr    ( ccsds_turbo_dec__oerr    )
  );


  assign ccsds_turbo_dec__iclk    = '0 ;
  assign ccsds_turbo_dec__ireset  = '0 ;
  assign ccsds_turbo_dec__iclkena = '0 ;
  assign ccsds_turbo_dec__icode   = '0 ;
  assign ccsds_turbo_dec__inidx   = '0 ;
  assign ccsds_turbo_dec__iNiter  = '0 ;
  assign ccsds_turbo_dec__itag    = '0 ;
  assign ccsds_turbo_dec__isop    = '0 ;
  assign ccsds_turbo_dec__ieop    = '0 ;
  assign ccsds_turbo_dec__ieof    = '0 ;
  assign ccsds_turbo_dec__ival    = '0 ;
  assign ccsds_turbo_dec__iLLR    = '0 ;
  assign ccsds_turbo_dec__ireq    = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec.sv
// Description   : top level for ccsds_turbo decoder components with dynamic parameters change on fly
//                 Data process path is :
//                  source -> 2D input buffer -> decoder + extr_ram -> 2D buffer -> sink
//


module ccsds_turbo_dec
#(
  parameter int pLLR_W          =        5 ,  // LLR width
  parameter int pLLR_FP         = pLLR_W-2 ,  // LLR fixed point
  parameter int pODAT_W         =        1 ,  // Output data width 1/2/4
  parameter int pTAG_W          =        8 ,  // Tag port bitwidth
  //
  parameter int pN_MAX          =  223*8*5 ,  // maximum number of data bits
  //
  parameter int pMMAX_TYPE      =        0 ,  // 0 - max Log Map (only supported)
                                              // 1 - const 1 max Log Map
  parameter bit pUSE_FIXED_CODE =        0 ,  // 1 - icode/inidx is constant, 0 - icode/inidx is variable
  parameter bit pUSE_SC_MODE    =        1 ,  // use self-corrected logic for extrinsic
  //
  parameter bit pUSE_RAM_PIPE   =        1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  inidx   ,
  iNiter  ,
  //
  itag    ,
  isop    ,
  ieop    ,
  ival    ,
  iLLR    ,
  //
  obusy   ,
  ordy    ,
  //
  ireq    ,
  ofull   ,
  //
  otag    ,
  osop    ,
  oeop    ,
  oval    ,
  odat    ,
  //
  oerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk    ;
  input  logic                       ireset  ;
  input  logic                       iclkena ;
  //
  input  logic               [1 : 0] icode   ;
  input  logic               [1 : 0] inidx   ;
  input  logic               [7 : 0] iNiter  ;  // up to 255 iterations
  //
  input  logic        [pTAG_W-1 : 0] itag    ;
  input  logic                       isop    ;
  input  logic                       ieop    ;
  input  logic                       ival    ;
  input  logic signed [pLLR_W-1 : 0] iLLR    ;
  // input handshake interface
  output logic                       obusy   ;
  output logic                       ordy    ;
  // output data ready/request interface
  input  logic                       ireq    ;
  output logic                       ofull   ;
  //
  output logic        [pTAG_W-1 : 0] otag    ;
  output logic                       osop    ;
  output logic                       oeop    ;
  output logic                       oval    ;
  output logic       [pODAT_W-1 : 0] odat    ;
  //
  output logic              [15 : 0] oerr    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../ccsds_turbo_parameters.svh"
  `include "ccsds_turbo_dec_types.svh"

  localparam int cADDR_W = $clog2(pN_MAX);

  localparam int cIB_TAG_W = 2 +  2 +  8 + pTAG_W; //  {icode, nidx, Niter, tag}
  localparam int cOB_TAG_W =     cW + 16 + pTAG_W; // {used_N, decerr, tag}

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // parameter table
  logic           [1 : 0] ptab__inidx    ;

  logic           [1 : 0] used_code      ;

  logic           [7 : 0] used_Niter     ;

  ptab_dat_t              used_N         ;
  ptab_dat_t              used_Np3       ;
  ptab_dat_t              used_K2        ;
  ptab_dat_t              used_P     [4] ;
  ptab_dat_t              used_Pcomp [4] ;

  // source
  logic                   source__owrite      ;
  logic                   source__owfull      ;
  logic   [cADDR_W-1 : 0] source__owaddr      ;
  bit_llr_t               source__osLLR       ;
  bit_llr_t               source__oa0LLR  [3] ;
  bit_llr_t               source__oa1LLR  [3] ;

  // input buffer
  logic   [cADDR_W-1 : 0] ibuffer__ifsaddr     ;
  logic   [cADDR_W-1 : 0] ibuffer__ifpaddr     ;

  bit_llr_t               ibuffer__ofsLLR      ;
  bit_llr_t               ibuffer__ofa0LLR [3] ;
  bit_llr_t               ibuffer__ofa1LLR [3] ;

  logic   [cADDR_W-1 : 0] ibuffer__ibsaddr     ;
  logic   [cADDR_W-1 : 0] ibuffer__ibpaddr     ;

  bit_llr_t               ibuffer__obsLLR      ;
  bit_llr_t               ibuffer__oba0LLR [3] ;
  bit_llr_t               ibuffer__oba1LLR [3] ;

  logic [cIB_TAG_W-1 : 0] ibuffer__iwtag   ;
  logic [cIB_TAG_W-1 : 0] ibuffer__ortag   ;
  logic                   ibuffer__oempty  ;
  logic                   ibuffer__oemptya ;
  logic                   ibuffer__ofull   ;
  logic                   ibuffer__ofulla  ;

  // address generator
  ptab_dat_t              faddr_gen__osaddr ;
  ptab_dat_t              faddr_gen__opaddr ;
  ptab_dat_t              baddr_gen__osaddr ;
  ptab_dat_t              baddr_gen__opaddr ;

  // ctrl
  logic                   ctrl__obuf_rempty      ;

  logic                   ctrl__oaddr_pmode      ;
  logic                   ctrl__oaddr_ftmode     ;
  logic                   ctrl__oaddr_btmode     ;
  logic                   ctrl__oaddr_clear      ;
  logic                   ctrl__oaddr_enable     ;

  logic                   ctrl__ofirst_sub_stage ;
  logic                   ctrl__olast_sub_stage  ;
  logic                   ctrl__oeven_sub_stage  ;
  logic                   ctrl__osub_stage_warm  ;

  logic                   ctrl__odec_sop         ;
  logic                   ctrl__odec_val         ;
  logic                   ctrl__odec_eop         ;

  // decoder engine
  logic                   dec__ifirst           ;
  logic                   dec__ilast            ;
  logic                   dec__ieven            ;
  logic                   dec__iwarm            ;

  logic                   dec__isop             ;
  logic                   dec__ival             ;
  logic                   dec__ieop             ;

  logic                   dec__ifterm           ;
  logic   [cADDR_W-1 : 0] dec__ifaddr           ;
  bit_llr_t               dec__ifsLLR           ;
  bit_llr_t               dec__ifa0LLR      [3] ;
  bit_llr_t               dec__ifa1LLR      [3] ;
  Lextr_t                 dec__ifLextr          ;

  logic                   dec__ibterm           ;
  logic   [cADDR_W-1 : 0] dec__ibaddr           ;
  bit_llr_t               dec__ibsLLR           ;
  bit_llr_t               dec__iba0LLR      [3] ;
  bit_llr_t               dec__iba1LLR      [3] ;
  Lextr_t                 dec__ibLextr          ;

  logic                   dec__osop             ;
  logic                   dec__oeop             ;
  logic                   dec__oval             ;
  logic                   dec__odatval          ;

  logic   [cADDR_W-1 : 0] dec__ofaddr           ;
  Lextr_t                 dec__ofLextr          ;
  logic                   dec__ofdat            ;

  logic   [cADDR_W-1 : 0] dec__obaddr           ;
  Lextr_t                 dec__obLextr          ;
  logic                   dec__obdat            ;

  logic                   dec__odone            ;
  logic          [15 : 0] dec__oerr             ;

  // output buffer
  logic                   obuffer__oempty ;
  logic [cOB_TAG_W-1 : 0] obuffer__iwtag  ;
  logic [cOB_TAG_W-1 : 0] obuffer__ortag  ;

  // sink
  ptab_dat_t              sink__iN      ;
  logic                   sink__ifull   ;
  logic   [pODAT_W-1 : 0] sink__irdata  ;
  logic          [15 : 0] sink__ierr    ;
  logic    [pTAG_W-1 : 0] sink__itag    ;
  logic                   sink__orempty ;
  logic   [cADDR_W-1 : 0] sink__oraddr  ;

  // temp variable
  logic    [pTAG_W-1 : 0] data_tag ;

  //------------------------------------------------------------------------------------------------------
  // source module
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_source
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pLLR_FP ( pLLR_FP ) ,
    .pADDR_W ( cADDR_W )
  )
  source
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .icode   ( icode            ) , // drive by input parameters
    .inidx   ( inidx            ) ,
    // input interface
    .isop    ( isop             ) ,
    .ieop    ( ieop             ) ,
    .ival    ( ival             ) ,
    .iLLR    ( iLLR             ) ,
    //
    .ifulla  ( ibuffer__ofulla  ) ,
    .iemptya ( ibuffer__oemptya ) ,
    //
    .obusy   ( obusy            ) ,
    .ordy    ( ordy             ) ,
    // ibuffer interface
    .owrite  ( source__owrite   ) ,
    .owfull  ( source__owfull   ) ,
    .owaddr  ( source__owaddr   ) ,
    .osLLR   ( source__osLLR    ) ,
    .oa0LLR  ( source__oa0LLR   ) ,
    .oa1LLR  ( source__oa1LLR   )
  );

  //
  // align ccsds_turbo_dec_source delay
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (isop & ival) begin
        ibuffer__iwtag <= {icode, inidx, iNiter, itag};
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // input buffer
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_input_buffer
  #(
    .pLLR_W  ( pLLR_W        ) ,
    .pLLR_FP ( pLLR_FP       ) ,
    .pADDR_W ( cADDR_W       ) ,
    //
    .pTAG_W  ( cIB_TAG_W     ) ,
    //
    .pBNUM_W ( 1             ) ,  // 2D
    //
    .pDPIPE  ( pUSE_RAM_PIPE )
  )
  ibuffer
  (
    .iclk    ( iclk              ) ,
    .ireset  ( ireset            ) ,
    .iclkena ( iclkena           ) ,
    //
    .iwrite  ( source__owrite    ) ,
    .iwfull  ( source__owfull    ) ,
    .iwaddr  ( source__owaddr    ) ,
    .isLLR   ( source__osLLR     ) ,
    .ia0LLR  ( source__oa0LLR    ) ,
    .ia1LLR  ( source__oa1LLR    ) ,
    //
    .iwtag   ( ibuffer__iwtag    ) ,
    //
    .irempty ( ctrl__obuf_rempty ) ,
    //
    .ifsaddr ( ibuffer__ifsaddr  ) ,
    .ofsLLR  ( ibuffer__ofsLLR   ) ,
    .ifpaddr ( ibuffer__ifpaddr  ) ,
    .ofa0LLR ( ibuffer__ofa0LLR  ) ,
    .ofa1LLR ( ibuffer__ofa1LLR  ) ,
    //
    .ibsaddr ( ibuffer__ibsaddr  ) ,
    .obsLLR  ( ibuffer__obsLLR   ) ,
    .ibpaddr ( ibuffer__ibpaddr  ) ,
    .oba0LLR ( ibuffer__oba0LLR  ) ,
    .oba1LLR ( ibuffer__oba1LLR  ) ,
    //
    .ortag   ( ibuffer__ortag    ) ,
    //
    .oempty  ( ibuffer__oempty   ) ,
    .oemptya ( ibuffer__oemptya  ) ,
    .ofull   ( ibuffer__ofull    ) ,
    .ofulla  ( ibuffer__ofulla   )
  );

  assign ibuffer__ifsaddr = faddr_gen__osaddr[cADDR_W-1 : 0];
  assign ibuffer__ifpaddr = faddr_gen__opaddr[cADDR_W-1 : 0];

  assign ibuffer__ibsaddr = baddr_gen__osaddr[cADDR_W-1 : 0];
  assign ibuffer__ibpaddr = baddr_gen__opaddr[cADDR_W-1 : 0];

  //
  // remap signals
  always_comb begin
    dec__ifsLLR  = ibuffer__ofsLLR;
    dec__ifa0LLR = ibuffer__ofa0LLR;
    dec__ifa1LLR = ibuffer__ofa1LLR;

    dec__ibsLLR  = ibuffer__obsLLR;
    dec__iba0LLR = ibuffer__oba0LLR;
    dec__iba1LLR = ibuffer__oba1LLR;
  end

  generate
    if (pUSE_FIXED_CODE) begin
      assign {used_code, ptab__inidx, used_Niter} = {inidx, iNiter};
      assign data_tag                             = ibuffer__ortag[pTAG_W-1 : 0];
    end
    else begin
      assign {used_code, ptab__inidx, used_Niter, data_tag} = ibuffer__ortag;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // decode permutation type decoder
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_ptable
  ptab
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    //
    .icode   ( 2'b00       ) ,  // n.u
    .inidx   ( ptab__inidx ) ,
    //
    .oN      ( used_N      ) ,
    .oNp3    ( used_Np3    ) ,
    .oK2     ( used_K2     ) ,
    //
    .oP      ( used_P      ) ,
    .oPcomp  ( used_Pcomp  )
  );

  //------------------------------------------------------------------------------------------------------
  // decoder FSM
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_ctrl
  ctrl
  (
    .iclk             ( iclk    ) ,
    .ireset           ( ireset  ) ,
    .iclkena          ( iclkena ) ,
    //
    .iN               ( used_N     ) ,
    .iNiter           ( used_Niter ) ,
    //
    .ibuf_full        ( ibuffer__ofull         ) ,  // if ibuffer full start
    .obuf_rempty      ( ctrl__obuf_rempty      ) ,
    .iobuf_empty      ( obuffer__oempty        ) ,  // if obuffer is empty end
    //
    .oaddr_pmode      ( ctrl__oaddr_pmode      ) ,
    .oaddr_ftmode     ( ctrl__oaddr_ftmode     ) ,
    .oaddr_btmode     ( ctrl__oaddr_btmode     ) ,
    .oaddr_clear      ( ctrl__oaddr_clear      ) ,
    .oaddr_enable     ( ctrl__oaddr_enable     ) ,
    //
    .ofirst_sub_stage ( ctrl__ofirst_sub_stage ) ,
    .olast_sub_stage  ( ctrl__olast_sub_stage  ) ,
    .oeven_sub_stage  ( ctrl__oeven_sub_stage  ) ,
    .osub_stage_warm  ( ctrl__osub_stage_warm  ) ,
    //
    .idec_eop         ( dec__oeop              ) ,
    .odec_sop         ( ctrl__odec_sop         ) ,
    .odec_val         ( ctrl__odec_val         ) ,
    .odec_eop         ( ctrl__odec_eop         )
  );

  //------------------------------------------------------------------------------------------------------
  // address generators
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_addr_gen
  #(
    .pB_nF ( 0 )
  )
  faddr_gen
  (
    .iclk     ( iclk    ) ,
    .ireset   ( ireset  ) ,
    .iclkena  ( iclkena ) ,
    //
    .ipmode   ( ctrl__oaddr_pmode  ) ,
    .itmode   ( ctrl__oaddr_ftmode ) ,
    .iclear   ( ctrl__oaddr_clear  ) ,
    .ienable  ( ctrl__oaddr_enable ) ,
    //
    .iNp3     ( used_Np3           ) ,
    .iK2      ( used_K2            ) ,
    .iP       ( used_P             ) ,
    .iPcomp   ( used_Pcomp         ) ,
    //
    .osaddr   ( faddr_gen__osaddr  ) ,
    .opaddr   ( faddr_gen__opaddr  )
  );

  ccsds_turbo_dec_addr_gen
  #(
    .pB_nF ( 1 )
  )
  baddr_gen
  (
    .iclk     ( iclk    ) ,
    .ireset   ( ireset  ) ,
    .iclkena  ( iclkena ) ,
    //
    .ipmode   ( ctrl__oaddr_pmode  ) ,
    .itmode   ( ctrl__oaddr_btmode ) ,
    .iclear   ( ctrl__oaddr_clear  ) ,
    .ienable  ( ctrl__oaddr_enable ) ,
    //
    .iNp3     ( used_Np3           ) ,
    .iK2      ( used_K2            ) ,
    .iP       ( used_P             ) ,
    .iPcomp   ( used_Pcomp         ) ,
    //
    .osaddr   ( baddr_gen__osaddr  ) ,
    .opaddr   ( baddr_gen__opaddr  )
  );

  //------------------------------------------------------------------------------------------------------
  // decoder engine
  //------------------------------------------------------------------------------------------------------

  logic                 dec_bitswap ;
  logic                 dec_warm    ;
  logic                 dec_sop     ;
  logic                 dec_val     ;
  logic                 dec_eop     ;

  logic [cADDR_W-1 : 0] dec_faddr   ;
  logic [cADDR_W-1 : 0] dec_baddr   ;

  logic                 dec_fterm   ;
  logic                 dec_bterm   ;

  ccsds_turbo_dec_engine
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pLLR_FP      ( pLLR_FP      ) ,
    .pADDR_W      ( cADDR_W      ) ,
    .pMM_ADDR_W   ( cADDR_W-1    ) , // 1/2 of pN
    .pMMAX_TYPE   ( pMMAX_TYPE   ) ,
    .pUSE_SC_MODE ( pUSE_SC_MODE )
  )
  dec
  (
    .iclk     ( iclk         ) ,
    .ireset   ( ireset       ) ,
    .iclkena  ( iclkena      ) ,
    //
    .icode    ( used_code    ) ,
    //
    .ifirst   ( dec__ifirst  ) ,
    .ilast    ( dec__ilast   ) ,
    .ieven    ( dec__ieven   ) ,
    .iwarm    ( dec__iwarm   ) ,
    //
    .isop     ( dec__isop    ) ,
    .ival     ( dec__ival    ) ,
    .ieop     ( dec__ieop    ) ,
    //
    .ifterm   ( dec__ifterm  ) ,
    .ifaddr   ( dec__ifaddr  ) ,
    .ifsLLR   ( dec__ifsLLR  ) ,
    .ifa0LLR  ( dec__ifa0LLR ) ,
    .ifa1LLR  ( dec__ifa1LLR ) ,
    .ifLextr  ( dec__ifLextr ) ,
    //
    .ibterm   ( dec__ibterm  ) ,
    .ibaddr   ( dec__ibaddr  ) ,
    .ibsLLR   ( dec__ibsLLR  ) ,
    .iba0LLR  ( dec__iba0LLR ) ,
    .iba1LLR  ( dec__iba1LLR ) ,
    .ibLextr  ( dec__ibLextr ) ,
    //
    .osop     ( dec__osop    ) ,
    .oeop     ( dec__oeop    ) ,
    .oval     ( dec__oval    ) ,
    .odatval  ( dec__odatval ) ,
    //
    .ofaddr   ( dec__ofaddr  ) ,
    .ofLextr  ( dec__ofLextr ) ,
    .ofdat    ( dec__ofdat   ) ,
    //
    .obaddr   ( dec__obaddr  ) ,
    .obLextr  ( dec__obLextr ) ,
    .obdat    ( dec__obdat   ) ,
    //
    .odone    ( dec__odone   ) ,
    .oerr     ( dec__oerr    )
  );

  assign dec__ifirst = ctrl__ofirst_sub_stage;
  assign dec__ilast  = ctrl__olast_sub_stage;
  assign dec__ieven  = ctrl__oeven_sub_stage;

  //
  // align input buffer read delay
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (pUSE_RAM_PIPE) begin
        {dec__ifaddr,   dec_faddr}  <= {dec_faddr,   faddr_gen__osaddr[cADDR_W-1 : 0]};
        {dec__ibaddr,   dec_baddr}  <= {dec_baddr,   baddr_gen__osaddr[cADDR_W-1 : 0]};
        //
        {dec__iwarm, dec_warm}      <= {dec_warm, ctrl__osub_stage_warm};
        {dec__isop,  dec_sop }      <= {dec_sop,  ctrl__odec_sop};
        {dec__ival,  dec_val }      <= {dec_val,  ctrl__odec_val};
        {dec__ieop,  dec_eop }      <= {dec_eop,  ctrl__odec_eop};
        //
        {dec__ifterm, dec_fterm}    <= {dec_fterm, ctrl__oaddr_ftmode};
        {dec__ibterm, dec_bterm}    <= {dec_bterm, ctrl__oaddr_btmode};
      end
      else begin
        dec__ifaddr <= faddr_gen__osaddr[cADDR_W-1 : 0];
        dec__ibaddr <= baddr_gen__osaddr[cADDR_W-1 : 0];
        //
        dec__iwarm  <= ctrl__osub_stage_warm;
        dec__isop   <= ctrl__odec_sop;
        dec__ival   <= ctrl__odec_val;
        dec__ieop   <= ctrl__odec_eop;
        //
        dec__ifterm <= ctrl__oaddr_ftmode;
        dec__ibterm <= ctrl__oaddr_btmode;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // extrinsic buffer
  //------------------------------------------------------------------------------------------------------

  codec_map_dec_extr_ram
  #(
    .pDATA_W ( cL_EXT_W + 2  ) ,
    .pADDR_W ( cADDR_W       ) ,
    //
    .pWPIPE  ( pUSE_RAM_PIPE ) ,
    .pRDPIPE ( pUSE_RAM_PIPE )
  )
  extr_ram
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .iwrite  ( dec__oval    ) ,
    //
    .iwaddr0 ( dec__ofaddr  ) ,
    .iwdata0 ( dec__ofLextr ) ,
    //
    .iwaddr1 ( dec__obaddr  ) ,
    .iwdata1 ( dec__obLextr ) ,
    //
    .iread   ( 1'b1         ) ,
    //
    .iraddr0 ( faddr_gen__osaddr[cADDR_W-1 : 0] ) ,
    .ordata0 ( dec__ifLextr                     ) ,
    //
    .iraddr1 ( baddr_gen__osaddr[cADDR_W-1 : 0] ) ,
    .ordata1 ( dec__ibLextr                     )
  );

  //------------------------------------------------------------------------------------------------------
  // output buffer
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_output_buffer
  #(
    .pADDR_W ( cADDR_W       ) ,
    .pRDAT_W ( pODAT_W       ) ,
    .pTAG_W  ( cOB_TAG_W     ) ,
    .pBNUM_W ( 1             ) , // 2D
    .pWPIPE  ( pUSE_RAM_PIPE )
  )
  obuffer
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    // write side
    .iwrite  ( dec__odatval    ) ,  // write only at last half-iteration
    .iwfull  ( dec__odone      ) ,
    //
    .ifwaddr ( dec__ofaddr     ) ,
    .ifwdat  ( dec__ofdat      ) ,
    .ibwaddr ( dec__obaddr     ) ,
    .ibwdat  ( dec__obdat      ) ,
    //
    .iwtag   ( obuffer__iwtag  ) ,
    // read side
    .irempty ( sink__orempty   ) ,
    .iraddr  ( sink__oraddr    ) ,
    .ordata  ( sink__irdata    ) ,
    //
    .ortag   ( obuffer__ortag  ) ,
    //
    .oempty  ( obuffer__oempty ) ,
    .oemptya (                 ) ,  // n.u.
    .ofull   ( sink__ifull     ) ,
    .ofulla  (                 )    // n.u.
  );

  assign obuffer__iwtag = {dec__oerr, used_N, data_tag};

  assign {sink__ierr, sink__iN, sink__itag} = obuffer__ortag;

  //------------------------------------------------------------------------------------------------------
  // sink module
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec_sink
  #(
    .pADDR_W ( cADDR_W ) ,
    .pDAT_W  ( pODAT_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  sink
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .iN      ( sink__iN      ) ,
    //
    .ifull   ( sink__ifull   ) ,
    .irdata  ( sink__irdata  ) ,
    .ierr    ( sink__ierr    ) ,
    .itag    ( sink__itag    ) ,
    .orempty ( sink__orempty ) ,
    .oraddr  ( sink__oraddr  ) ,
    //
    .ireq    ( ireq   ) ,
    .ofull   ( ofull  ) ,
    //
    .otag    ( otag   ) ,
    .osop    ( osop   ) ,
    .oeop    ( oeop   ) ,
    .oval    ( oval   ) ,
    .odat    ( odat   ) ,
    .oerr    ( oerr   )
  );

endmodule

