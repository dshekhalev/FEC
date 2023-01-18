/*



  parameter int pLLR_W                =  4 ;
  parameter int pLLR_FP               =  4 ;
  parameter int pODAT_W               =  2 ;
  parameter int pTAG_W                =  8 ;
  //
  parameter int pN_MAX                = 64 ;
  //
  parameter int pMMAX_TYPE            =  0 ;
  parameter bit pUSE_W_BIT            =  0 ;
  parameter bit pUSE_WIMAX            =  1 ;
  parameter bit pUSE_FIXED_CODE       =  0 ;
  //
  parameter bit pUSE_RP_P_COMP        =  1 ;
  parameter bit pUSE_RAM_PIPE         =  1 ;
  //
  parameter bit pUSE_SRC_EOP_VAL_MASK =  1 ;



  logic                       rsc_dec__iclk            ;
  logic                       rsc_dec__ireset          ;
  logic                       rsc_dec__iclkena         ;
  logic               [3 : 0] rsc_dec__icode           ;
  logic               [4 : 0] rsc_dec__iptype          ;
  logic              [12 : 0] rsc_dec__iN              ;
  logic               [3 : 0] rsc_dec__iNiter          ;
  logic        [pTAG_W-1 : 0] rsc_dec__itag            ;
  logic                       rsc_dec__isop            ;
  logic                       rsc_dec__ieop            ;
  logic                       rsc_dec__ival            ;
  logic signed [pLLR_W-1 : 0] rsc_dec__iLLR    [0 : 1] ;
  logic                       rsc_dec__obusy           ;
  logic                       rsc_dec__ordy            ;
  logic                       rsc_dec__ireq            ;
  logic                       rsc_dec__ofull           ;
  logic                       rsc_dec__osop            ;
  logic                       rsc_dec__oeop            ;
  logic                       rsc_dec__oval            ;
  logic       [pODAT_W-1 : 0] rsc_dec__odat            ;
  logic        [pTAG_W-1 : 0] rsc_dec__otag            ;
  logic              [15 : 0] rsc_dec__oerr            ;



  rsc_dec
  #(
    .pLLR_W                ( pLLR_W                ) ,
    .pLLR_FP               ( pLLR_FP               ) ,
    .pODAT_W               ( pODAT_W               ) ,
    .pTAG_W                ( pTAG_W                ) ,
    //
    .pMMAX_TYPE            ( pMMAX_TYPE            ) ,
    //
    .pN_MAX                ( pN_MAX                ) ,
    .pUSE_W_BIT            ( pUSE_W_BIT            ) ,
    .pUSE_WIMAX            ( pUSE_WIMAX            ) ,
    .pUSE_FIXED_CODE       ( pUSE_FIXED_CODE       ) ,
    //
    .pUSE_RP_P_COMP        ( pUSE_RP_P_COMP        ) ,
    .pUSE_RAM_PIPE         ( pUSE_RAM_PIPE         ) ,
    //
    .pUSE_SRC_EOP_VAL_MASK ( pUSE_SRC_EOP_VAL_MASK )
  )
  rsc_dec
  (
    .iclk    ( rsc_dec__iclk    ) ,
    .ireset  ( rsc_dec__ireset  ) ,
    .iclkena ( rsc_dec__iclkena ) ,
    .icode   ( rsc_dec__icode   ) ,
    .iptype  ( rsc_dec__iptype  ) ,
    .iN      ( rsc_dec__iN      ) ,
    .iNiter  ( rsc_dec__iNiter  ) ,
    .itag    ( rsc_dec__itag    ) ,
    .isop    ( rsc_dec__isop    ) ,
    .ieop    ( rsc_dec__ieop    ) ,
    .ival    ( rsc_dec__ival    ) ,
    .iLLR    ( rsc_dec__iLLR    ) ,
    .obusy   ( rsc_dec__obusy   ) ,
    .ordy    ( rsc_dec__ordy    ) ,
    .ireq    ( rsc_dec__ireq    ) ,
    .ofull   ( rsc_dec__ofull   ) ,
    .osop    ( rsc_dec__osop    ) ,
    .oeop    ( rsc_dec__oeop    ) ,
    .oval    ( rsc_dec__oval    ) ,
    .odat    ( rsc_dec__odat    ) ,
    .otag    ( rsc_dec__otag    ) ,
    .oerr    ( rsc_dec__oerr    )
  );


  assign rsc_dec__iclk    = '0 ;
  assign rsc_dec__ireset  = '0 ;
  assign rsc_dec__iclkena = '0 ;
  assign rsc_dec__icode   = '0 ;
  assign rsc_dec__iptype  = '0 ;
  assign rsc_dec__iN      = '0 ;
  assign rsc_dec__iNiter  = '0 ;
  assign rsc_dec__itag    = '0 ;
  assign rsc_dec__isop    = '0 ;
  assign rsc_dec__ieop    = '0 ;
  assign rsc_dec__ival    = '0 ;
  assign rsc_dec__iLLR    = '0 ;
  assign rsc_dec__ireq    = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec.sv
// Description   : top level for rsc decoder components with dynamic parameters change on fly
//                 Data process path is :
//                  source -> 2D input buffer -> decoder + extr_ram -> 2D buffer -> sink
//

`include "define.vh"

module rsc_dec
#(
  parameter int pLLR_W                =        5 ,  // LLR width
  parameter int pLLR_FP               = pLLR_W-2 ,  // LLR fixed point
  parameter int pODAT_W               =        2 ,  // Output data width 2/4/8
  parameter int pTAG_W                =        8 ,  // Tag port bitwidth
  //
  parameter int pN_MAX                =     4096 ,  // maximum number of data duobit's <= 4096
  //
  parameter int pMMAX_TYPE            =        0 ,  // 0 - max Log Map (only supported)
                                                    // 1 - const 1 max Log Map
  parameter bit pUSE_W_BIT            =        1 ,  // 0/1 - not use/use coderate with W bits (icode == 0 or icode == 10/11)
  parameter bit pUSE_WIMAX            =        1 ,  // 1 - use dvb/wimax/wimaxa, 0 - use dvb/wimaxa only
  parameter bit pUSE_FIXED_CODE       =        0 ,  // 1 - icode/iptype/iN is constant, 0 - icode/iptype/iN is variable
  //
  parameter bit pUSE_RP_P_COMP        =        1 ,  // use parallel comparator for recursion processor
  parameter bit pUSE_RAM_PIPE         =        1 ,  // pipeline rams inside dec_engine
  //
  parameter bit pUSE_SRC_EOP_VAL_MASK =        1    // use ieop with ival ANDED, else use single ieop
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  iptype  ,
  iN      ,
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
  osop    ,
  oeop    ,
  oval    ,
  odat    ,
  otag    ,
  //
  oerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk           ;
  input  logic                       ireset         ;
  input  logic                       iclkena        ;
  //
  input  logic               [3 : 0] icode          ; // code rate  0       - 1/3,
                                                      //            [1 : 9] - [1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8; 8/9; 9/10]
                                                      //            [10:11] - [2:3]/5
                                                      //            12      - 3/7
  input  logic               [4 : 0] iptype         ; // permutation type [0:11] - DVB/[12:15] - Wimax/[16:27] - WimaxA
  input  logic              [12 : 0] iN             ; // number of data duobit's
  input  logic               [3 : 0] iNiter         ; // number of iteration >= 2
  //
  input  logic        [pTAG_W-1 : 0] itag           ;
  input  logic                       isop           ;
  input  logic                       ieop           ;
  input  logic                       ival           ;
  input  logic signed [pLLR_W-1 : 0] iLLR   [0 : 1] ;
  // input handshake interface
  output logic                       obusy          ;
  output logic                       ordy           ;
  // output data ready/request interface
  input  logic                       ireq           ;
  output logic                       ofull          ;
  //
  output logic                       osop           ;
  output logic                       oeop           ;
  output logic                       oval           ;
  output logic       [pODAT_W-1 : 0] odat           ;
  output logic        [pTAG_W-1 : 0] otag           ;
  //
  output logic              [15 : 0] oerr           ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../rsc_constants.svh"
  `include "rsc_dec_types.svh"

  localparam int cADDR_W = clogb2(pN_MAX);

  localparam int cIB_TAG_W  = (pUSE_FIXED_CODE ? 0 : $bits(code_ctx_t)) + $bits(iNiter) + pTAG_W; // {used_code_ctx, Niter, tag}
  localparam int cOB_TAG_W  = 16 + $bits(dbits_num_t) + pTAG_W; // {decerr, iN, itag}

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  code_ctx_t                used_code_ctx    ;
  //
  // source
  logic                     source__ifulla          ;
  logic                     source__iemptya         ;

  logic                     source__owrite          ;
  logic                     source__owfull          ;
  logic             [1 : 0] source__owsel           ;
  logic     [cADDR_W-1 : 0] source__owaddr          ;
  bit_llr_t                 source__osLLR   [0 : 1] ;
  bit_llr_t                 source__oyLLR   [0 : 1] ;
  bit_llr_t                 source__owLLR   [0 : 1] ;

  //
  // input buffer
  logic [cIB_TAG_W-1 : 0] ibuffer__iwtag   ;

  logic                     ibuffer__irempty         ;
  logic     [cADDR_W-1 : 0] ibuffer__ifsaddr         ;
  bit_llr_t                 ibuffer__ofsLLR  [0 : 1] ;
  logic     [cADDR_W-1 : 0] ibuffer__ifpaddr         ;
  bit_llr_t                 ibuffer__ofyLLR  [0 : 1] ;
  bit_llr_t                 ibuffer__ofwLLR  [0 : 1] ;

  logic     [cADDR_W-1 : 0] ibuffer__ibsaddr         ;
  bit_llr_t                 ibuffer__obsLLR  [0 : 1] ;
  logic     [cADDR_W-1 : 0] ibuffer__ibpaddr         ;
  bit_llr_t                 ibuffer__obyLLR  [0 : 1] ;
  bit_llr_t                 ibuffer__obwLLR  [0 : 1] ;

  logic   [cIB_TAG_W-1 : 0] ibuffer__ortag           ;

  logic                     ibuffer__oempty          ;
  logic                     ibuffer__oemptya         ;
  logic                     ibuffer__ofull           ;
  logic                     ibuffer__ofulla          ;
  //
  // decoder engine
  logic                     engine__irbuf_full      ;
  code_ctx_t                engine__icode_ctx       ;
  logic             [3 : 0] engine__iNiter          ;
  logic      [pTAG_W-1 : 0] engine__irtag           ;
  logic                     engine__orempty         ;
  //
  bit_llr_t                 engine__irfsLLR     [2] ;
  bit_llr_t                 engine__irfyLLR     [2] ;
  bit_llr_t                 engine__irfwLLR     [2] ;
  logic     [cADDR_W-1 : 0] engine__ofsaddr         ;
  logic     [cADDR_W-1 : 0] engine__ofpaddr         ;
  //
  bit_llr_t                 engine__irbsLLR     [2] ;
  bit_llr_t                 engine__irbyLLR     [2] ;
  bit_llr_t                 engine__irbwLLR     [2] ;
  logic     [cADDR_W-1 : 0] engine__obsaddr         ;
  logic     [cADDR_W-1 : 0] engine__obpaddr         ;
  //
  logic                     engine__iwbuf_empty     ;
  //
  logic                     engine__owrite          ;
  logic                     engine__owfull          ;
  dbits_num_t               engine__ownum           ;
  logic      [pTAG_W-1 : 0] engine__owtag           ;
  logic            [15 : 0] engine__owerr           ;
  //
  logic     [cADDR_W-1 : 0] engine__owfaddr         ;
  logic             [1 : 0] engine__owfdat          ;
  //
  logic     [cADDR_W-1 : 0] engine__owbaddr         ;
  logic             [1 : 0] engine__owbdat          ;
  //
  // output buffer
  logic                     obuffer__iwrite   ;
  logic                     obuffer__iwfull   ;

  logic     [cADDR_W-1 : 0] obuffer__ifwaddr  ;
  logic             [1 : 0] obuffer__ifwdat   ;
  logic     [cADDR_W-1 : 0] obuffer__ibwaddr  ;
  logic             [1 : 0] obuffer__ibwdat   ;
  logic   [cOB_TAG_W-1 : 0] obuffer__iwtag    ;

  logic                     obuffer__irempty  ;
  logic     [cADDR_W-1 : 0] obuffer__iraddr   ;
  logic     [pODAT_W-1 : 0] obuffer__ordata   ;
  logic   [cOB_TAG_W-1 : 0] obuffer__ortag    ;

  logic                     obuffer__oempty   ;
  logic                     obuffer__oemptya  ;
  logic                     obuffer__ofull    ;
  logic                     obuffer__ofulla   ;

  // sink
  dbits_num_t               sink__iN      ;
  logic                     sink__ifull   ;
  logic     [pODAT_W-1 : 0] sink__irdata  ;
  logic            [15 : 0] sink__ierr    ;
  logic      [pTAG_W-1 : 0] sink__itag    ;
  logic                     sink__orempty ;
  logic     [cADDR_W-1 : 0] sink__oraddr  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin : info
    @(posedge iclk iff iclkena & ival & isop);
    $display("bw paramters used for decoding:");
    $display("block length %0d. code rate %0d", iN, icode);
    case (pMMAX_TYPE)
      1       : $display("C=1.5 MaxLog Map");
      2       : $display("C=2.0 MaxLog Map");
      3       : $display("LUT   MaxLog Map");
      default : $display("MaxLog Map");
    endcase
    $display("iteration number : %0d", iNiter);
    $display("fixed point_w : %0d", pLLR_FP);
    $display("input bit LLR : %0d", $size(bit_llr_t));
    $display("duo bit LLR : %0d", $size(dbit_llr_t));
    $display("extrinsic (Lext) LLR : %0d", $size(extr_llr_t), 2**(cL_EXT_W-1)-1);
    $display("trellis state (alpha/beta) LLR : %0d, max state : %0d", $size(trel_state_t), 2**(cSTATE_W-2));
    $display("trellis Lapo LLR : %0d", $size(trel_branch_t));
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign used_code_ctx.code   = icode  ;
  assign used_code_ctx.ptype  = iptype ;
  assign used_code_ctx.Ndbits = iN     ;

  //------------------------------------------------------------------------------------------------------
  // source module
  //------------------------------------------------------------------------------------------------------

  rsc_dec_source
  #(
    .pLLR_W            ( pLLR_W                ) ,
    .pLLR_FP           ( pLLR_FP               ) ,
    .pADDR_W           ( cADDR_W               ) ,
    .pUSE_W_BIT        ( pUSE_W_BIT            ) ,
    .pUSE_EOP_VAL_MASK ( pUSE_SRC_EOP_VAL_MASK )
  )
  source
  (
    .iclk     ( iclk            ) ,
    .ireset   ( ireset          ) ,
    .iclkena  ( iclkena         ) ,
    //
    .icode    ( icode           ) , // drive by input parameters
    .iN       ( iN              ) ,
    // input interface
    .isop     ( isop            ) ,
    .ieop     ( ieop            ) ,
    .ival     ( ival            ) ,
    .iLLR     ( iLLR            ) ,
    .iLLRtag  ( '0              ) , // n.u.
    //
    .ifulla   ( source__ifulla  ) ,
    .iemptya  ( source__iemptya ) ,
    //
    .obusy    ( obusy           ) ,
    .ordy     ( ordy            ) ,
    // ibuffer interface
    .owrite   ( source__owrite  ) ,
    .owfull   ( source__owfull  ) ,
    .owsel    ( source__owsel   ) ,
    .owaddr   ( source__owaddr  ) ,
    .osLLR    ( source__osLLR   ) ,
    .oyLLR    ( source__oyLLR   ) ,
    .owLLR    ( source__owLLR   ) ,
    .osLLRtag (                 )   // n.u.
  );

  assign source__ifulla  = ibuffer__ofulla;
  assign source__iemptya = ibuffer__oemptya;

  //------------------------------------------------------------------------------------------------------
  // input buffer
  //------------------------------------------------------------------------------------------------------

  rsc_dec_input_buffer
  #(
    .pLLR_W  ( pLLR_W        ) ,
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
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( source__owrite   ) ,
    .iwfull  ( source__owfull   ) ,
    .iwsel   ( source__owsel    ) ,
    .iwaddr  ( source__owaddr   ) ,
    .isLLR   ( source__osLLR    ) ,
    .iyLLR   ( source__oyLLR    ) ,
    .iwLLR   ( source__owLLR    ) ,
    //
    .iwtag   ( ibuffer__iwtag   ) ,
    //
    .irempty ( ibuffer__irempty ) ,
    //
    .ifsaddr ( ibuffer__ifsaddr ) ,
    .ofsLLR  ( ibuffer__ofsLLR  ) ,
    //
    .ifpaddr ( ibuffer__ifpaddr ) ,
    .ofyLLR  ( ibuffer__ofyLLR  ) ,
    .ofwLLR  ( ibuffer__ofwLLR  ) ,
    //
    .ibsaddr ( ibuffer__ibsaddr ) ,
    .obsLLR  ( ibuffer__obsLLR  ) ,
    //
    .ibpaddr ( ibuffer__ibpaddr ) ,
    .obyLLR  ( ibuffer__obyLLR  ) ,
    .obwLLR  ( ibuffer__obwLLR  ) ,
    //
    .ortag   ( ibuffer__ortag   ) ,
    //
    .oempty  ( ibuffer__oempty  ) ,
    .oemptya ( ibuffer__oemptya ) ,
    .ofull   ( ibuffer__ofull   ) ,
    .ofulla  ( ibuffer__ofulla  )
  );

  //
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (isop & ival) begin
        ibuffer__iwtag <= pUSE_FIXED_CODE ? {iNiter, itag} : {used_code_ctx, iNiter, itag}; // {used_code_ctx, Niter, tag}
      end
    end
  end

  assign ibuffer__irempty = engine__orempty;

  assign ibuffer__ifsaddr = engine__ofsaddr;
  assign ibuffer__ifpaddr = engine__ofpaddr;

  assign ibuffer__ibsaddr = engine__obsaddr;
  assign ibuffer__ibpaddr = engine__obpaddr;

  //------------------------------------------------------------------------------------------------------
  // decoder engine
  //------------------------------------------------------------------------------------------------------

  rsc_dec_engine
  #(
    .pLLR_W         ( pLLR_W          ) ,
    .pLLR_FP        ( pLLR_FP         ) ,
    .pADDR_W        ( cADDR_W         ) ,
    .pTAG_W         ( pTAG_W          ) ,
    //
    .pMMAX_TYPE     ( pMMAX_TYPE      ) ,
    .pUSE_WIMAX     ( pUSE_WIMAX      ) ,
    .pUSE_IBUF_PIPE ( pUSE_RAM_PIPE   ) ,
    .pUSE_RP_P_COMP ( pUSE_RP_P_COMP  ) ,
    //
    .pFIX_MODE      ( pUSE_FIXED_CODE )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .icode_ctx   ( engine__icode_ctx   ) ,
    .iNiter      ( engine__iNiter      ) ,
    .irtag       ( engine__irtag       ) ,
    .orempty     ( engine__orempty     ) ,
    //
    .irfsLLR     ( engine__irfsLLR     ) ,
    .irfyLLR     ( engine__irfyLLR     ) ,
    .irfwLLR     ( engine__irfwLLR     ) ,
    .irfsLLRtag  ( '0                  ) ,  // n.u.
    .ofsaddr     ( engine__ofsaddr     ) ,
    .ofpaddr     ( engine__ofpaddr     ) ,
    //
    .irbsLLR     ( engine__irbsLLR     ) ,
    .irbyLLR     ( engine__irbyLLR     ) ,
    .irbwLLR     ( engine__irbwLLR     ) ,
    .irbsLLRtag  ( '0                  ) ,  // n.u
    .obsaddr     ( engine__obsaddr     ) ,
    .obpaddr     ( engine__obpaddr     ) ,
    //
    .iwbuf_empty ( engine__iwbuf_empty ) ,
    //
    .owrite      ( engine__owrite      ) ,
    .owfull      ( engine__owfull      ) ,
    .ownum       ( engine__ownum       ) ,
    .owtag       ( engine__owtag       ) ,
    .owerr       ( engine__owerr       ) ,
    //
    .owfaddr     ( engine__owfaddr     ) ,
    .owfdat      ( engine__owfdat      ) ,
    .owfderr     (                     ) ,
    .owfdtag     (                     ) ,  // n.u.
    //
    .owbaddr     ( engine__owbaddr     ) ,
    .owbdat      ( engine__owbdat      ) ,
    .owbderr     (                     ) ,
    .owbdtag     (                     )    // n.u
  );

  assign engine__irbuf_full  = ibuffer__ofull;

  always_comb begin
    if (pUSE_FIXED_CODE) begin
       engine__icode_ctx  = used_code_ctx;
       //
      {engine__iNiter,
       engine__irtag}     = ibuffer__ortag;
    end
    else begin
      {engine__icode_ctx,
       engine__iNiter,
       engine__irtag}     = ibuffer__ortag;  // {used_code_ctx, Niter, tag}
    end
  end

  assign engine__irfsLLR     = ibuffer__ofsLLR ;
  assign engine__irfyLLR     = ibuffer__ofyLLR ;
  assign engine__irfwLLR     = pUSE_W_BIT ? ibuffer__ofwLLR : '{default : '0};

  assign engine__irbsLLR     = ibuffer__obsLLR ;
  assign engine__irbyLLR     = ibuffer__obyLLR ;
  assign engine__irbwLLR     = pUSE_W_BIT ? ibuffer__obwLLR : '{default : '0};

  assign engine__iwbuf_empty = obuffer__oempty ;

  //------------------------------------------------------------------------------------------------------
  // output buffer
  //------------------------------------------------------------------------------------------------------

  rsc_dec_output_buffer
  #(
    .pADDR_W ( cADDR_W       ) ,
    .pWDAT_W ( 2             ) ,
    .pRDAT_W ( pODAT_W       ) ,
    //
    .pTAG_W  ( cOB_TAG_W     ) ,
    //
    .pBNUM_W ( 1             ) , // 2D
    .pWPIPE  ( pUSE_RAM_PIPE )
  )
  obuffer
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( obuffer__iwrite  ) ,
    .iwfull  ( obuffer__iwfull  ) ,
    //
    .ifwaddr ( obuffer__ifwaddr ) ,
    .ifwdat  ( obuffer__ifwdat  ) ,
    .ibwaddr ( obuffer__ibwaddr ) ,
    .ibwdat  ( obuffer__ibwdat  ) ,
    //
    .iwtag   ( obuffer__iwtag   ) ,
    //
    .irempty ( obuffer__irempty ) ,
    .iraddr  ( obuffer__iraddr  ) ,
    .ordata  ( obuffer__ordata  ) ,
    //
    .ortag   ( obuffer__ortag   ) ,
    //
    .oempty  ( obuffer__oempty  ) ,
    .oemptya ( obuffer__oemptya ) ,
    .ofull   ( obuffer__ofull   ) ,
    .ofulla  ( obuffer__ofulla  )
  );

  assign obuffer__iwrite  = engine__owrite ;
  assign obuffer__iwfull  = engine__owfull ;

  assign obuffer__ifwaddr = engine__owfaddr ;
  assign obuffer__ifwdat  = engine__owfdat  ;
  assign obuffer__ibwaddr = engine__owbaddr ;
  assign obuffer__ibwdat  = engine__owbdat  ;

  assign obuffer__iwtag   = {engine__owerr, engine__ownum, engine__owtag};

  assign obuffer__irempty = sink__orempty;
  assign obuffer__iraddr  = sink__oraddr ;

  //------------------------------------------------------------------------------------------------------
  // sink module
  //------------------------------------------------------------------------------------------------------

  rsc_dec_sink
  #(
    .pADDR_W ( cADDR_W ) ,
    .pDAT_W  ( pODAT_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  sink
  (
    .iclk    ( iclk          ) ,
    .ireset  ( ireset        ) ,
    .iclkena ( iclkena       ) ,
    //
    .iN      ( sink__iN      ) ,
    //
    .ifull   ( sink__ifull   ) ,
    .irdata  ( sink__irdata  ) ,
    .irderr  ( '0            ) , // n.u.
    .irdtag  ( '0            ) , // n.u.
    .ierr    ( sink__ierr    ) ,
    .itag    ( sink__itag    ) ,
    .orempty ( sink__orempty ) ,
    .oraddr  ( sink__oraddr  ) ,
    //
    .ireq    ( ireq          ) ,
    .ofull   ( ofull         ) ,
    //
    .osop    ( osop          ) ,
    .oeop    ( oeop          ) ,
    .oval    ( oval          ) ,
    .odat    ( odat          ) ,
    .oderr   (               ) , // n.u.
    .odtag   (               ) , // n.u.
    .otag    ( otag          ) ,
    .oerr    ( oerr          )
  );

  assign sink__ifull  = obuffer__ofull;
  assign sink__irdata = obuffer__ordata;

  assign {sink__ierr, sink__iN, sink__itag} = obuffer__ortag;

endmodule

