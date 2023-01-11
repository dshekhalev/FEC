/*



  parameter int pCODE                 =              1 ;
  parameter int pN                    =             48 ;
  parameter int pLLR_W                =              5 ;
  parameter int pLLR_NUM              =              5 ;
  parameter int pLLR_BY_CYCLE         =              2 ;
  parameter int pNODE_W               =              2 ;
  parameter int pNODE_BY_CYCLE        =              2 ;
  parameter bit pUSE_MN_MODE          =              0 ;
  parameter bit pNORM_VNODE           =              0 ;
  parameter bit pNORM_CNODE           =              0 ;
  parameter bit pUSE_SC_MODE          =              0 ;
  parameter int pBIT_ERR_SPLIT_FACTOR = pNODE_BY_CYCLE ;
  parameter int pODAT_W               =  pLLR_BY_CYCLE ;
  parameter int pERR_W                =             16 ;
  parameter int pTAG_W                =              4 ;



  logic                       ldpc_dec_engine__iclk                    ;
  logic                       ldpc_dec_engine__ireset                  ;
  logic                       ldpc_dec_engine__iclkena                 ;
  logic               [7 : 0] ldpc_dec_engine__iNiter                  ;
  logic                       ldpc_dec_engine__ifmode                  ;
  logic                       ldpc_dec_engine__isop                    ;
  logic                       ldpc_dec_engine__ieop                    ;
  logic                       ldpc_dec_engine__ival                    ;
  logic        [pTAG_W-1 : 0] ldpc_dec_engine__itag                    ;
  logic signed [pLLR_W-1 : 0] ldpc_dec_engine__iLLR         [pLLR_NUM] ;
  logic                       ldpc_dec_engine__obusy                   ;
  logic                       ldpc_dec_engine__ordy                    ;
  logic                       ldpc_dec_engine__irdy                    ;
  logic                       ldpc_dec_engine__osop                    ;
  logic                       ldpc_dec_engine__oeop                    ;
  logic                       ldpc_dec_engine__oval                    ;
  logic       [cADDR_W-1 : 0] ldpc_dec_engine__oaddr                   ;
  logic        [pTAG_W-1 : 0] ldpc_dec_engine__otag                    ;
  logic       [pODAT_W-1 : 0] ldpc_dec_engine__odat   [pNODE_BY_CYCLE] ;
  logic                       ldpc_dec_engine__odecfail                ;
  logic        [pERR_W-1 : 0] ldpc_dec_engine__oerr                    ;



  ldpc_dec_engine
  #(
    .pCODE                 ( pCODE                 ) ,
    .pN                    ( pN                    ) ,
    .pLLR_W                ( pLLR_W                ) ,
    .pLLR_NUM              ( pLLR_NUM              ) ,
    .pLLR_BY_CYCLE         ( pLLR_BY_CYCLE         ) ,
    .pNODE_W               ( pNODE_W               ) ,
    .pNODE_BY_CYCLE        ( pNODE_BY_CYCLE        ) ,
    .pUSE_MN_MODE          ( pUSE_MN_MODE          ) ,
    .pNORM_VNODE           ( pNORM_VNODE           ) ,
    .pNORM_CNODE           ( pNORM_CNODE           ) ,
    .pUSE_SC_MODE          ( pUSE_SC_MODE          ) ,
    .pBIT_ERR_SPLIT_FACTOR ( pBIT_ERR_SPLIT_FACTOR ) ,
    .pODAT_W               ( pODAT_W               ) ,
    .pERR_W                ( pERR_W                ) ,
    .pTAG_W                ( pTAG_W                )
  )
  ldpc_dec_engine
  (
    .iclk     ( ldpc_dec_engine__iclk     ) ,
    .ireset   ( ldpc_dec_engine__ireset   ) ,
    .iclkena  ( ldpc_dec_engine__iclkena  ) ,
    .iNiter   ( ldpc_dec_engine__iNiter   ) ,
    .ifmode   ( ldpc_dec_engine__ifmode   ) ,
    .isop     ( ldpc_dec_engine__isop     ) ,
    .ieop     ( ldpc_dec_engine__ieop     ) ,
    .ival     ( ldpc_dec_engine__ival     ) ,
    .itag     ( ldpc_dec_engine__itag     ) ,
    .iLLR     ( ldpc_dec_engine__iLLR     ) ,
    .obusy    ( ldpc_dec_engine__obusy    ) ,
    .ordy     ( ldpc_dec_engine__ordy     ) ,
    .irdy     ( ldpc_dec_engine__irdy     ) ,
    .osop     ( ldpc_dec_engine__osop     ) ,
    .oeop     ( ldpc_dec_engine__oeop     ) ,
    .oval     ( ldpc_dec_engine__oval     ) ,
    .oaddr    ( ldpc_dec_engine__oaddr    ) ,
    .otag     ( ldpc_dec_engine__otag     ) ,
    .odat     ( ldpc_dec_engine__odat     ) ,
    .odecfail ( ldpc_dec_engine__odecfail ) ,
    .oerr     ( ldpc_dec_engine__oerr     )
  );


  assign ldpc_dec_engine__iclk    = '0 ;
  assign ldpc_dec_engine__ireset  = '0 ;
  assign ldpc_dec_engine__iclkena = '0 ;
  assign ldpc_dec_engine__iNiter  = '0 ;
  assign ldpc_dec_engine__ifmode  = '0 ;
  assign ldpc_dec_engine__isop    = '0 ;
  assign ldpc_dec_engine__ieop    = '0 ;
  assign ldpc_dec_engine__ival    = '0 ;
  assign ldpc_dec_engine__itag    = '0 ;
  assign ldpc_dec_engine__iLLR    = '0 ;
  assign ldpc_dec_engine__irdy    = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_engine.sv
// Description   : LDPC decoder engine with static code parameters. Normalized 2D min-sum algorithm is used. Input metrics is straight(!!!). The metric saturation is inside.
//                 The iNiter port and any input tag info latched inside at isop & ival signal. Decoder engine use 2D input buffer and no any output buffers or output handshake
//                 The decoded systematic or parity bits output during decoding on fly with error counting. The actual oerr value is valid at oeop tag.
//

`include "define.vh"

module ldpc_dec_engine
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  iNiter   ,
  ifmode   ,
  //
  isop     ,
  ieop     ,
  ival     ,
  itag     ,
  iLLR     ,
  //
  obusy    ,
  ordy     ,
  //
  irdy     ,
  //
  osop     ,
  oeop     ,
  oval     ,
  oaddr    ,
  otag     ,
  odat     ,
  //
  odecfail ,
  oerr
);

  parameter bit pUSE_MN_MODE          = 0 ; // use multi node working mode (decoders wirh output ram)

  parameter bit pNORM_VNODE           = 1 ; // 1/0 vnode noramlization coefficient is 0.875/1
  parameter bit pNORM_CNODE           = 1 ; // 1/0 cnode noramlization coefficient is 0.875/1

  parameter int pTAG_W                = 4 ;

  `include "../ldpc_parameters.svh"
  `include "ldpc_dec_parameters.svh"
  `include "ldpc_dec_functions.svh"

  parameter int pLLR_NUM              = pLLR_BY_CYCLE;  // bitwidth of decoder input interface. (pLLR_NUM != pLLR_BY_CYCLE) ? dwc decoder : usual decoder
                                                        // (pLLR_BY_CYCLE <= pLLR_NUM) && (pLLR_NUM <= pLLR_BY_CYCLE * pNODE_BY_CYCLE)

  parameter int pBIT_ERR_SPLIT_FACTOR = pNODE_BY_CYCLE; // parameter used to split pLLR_BY_CYCLE * pNODE_BY_CYCLE bit errors on 2 stage adder to increase speed of counter

  parameter int pODAT_W               = pLLR_BY_CYCLE ; // output data bitwidth. pODAT_W = N*pLLR_BY_CYCLE and must be multuply of pZF * pT/pNODE_BY_CYCLE
  parameter int pERR_W                = 16;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                     ;
  input  logic                       ireset                   ;
  input  logic                       iclkena                  ;
  // input interface
  input  logic               [7 : 0] iNiter                   ;
  input  logic                       ifmode                   ;
  //
  input  logic                       isop                     ;
  input  logic                       ieop                     ;
  input  logic                       ival                     ;
  input  logic        [pTAG_W-1 : 0] itag                     ;
  input  logic signed [pLLR_W-1 : 0] iLLR          [pLLR_NUM] ;
  // input handshake
  output logic                       obusy                    ;
  output logic                       ordy                     ;
  // output handshake
  input  logic                       irdy                     ;
  // output interface
  output logic                       osop                     ;
  output logic                       oeop                     ;
  output logic                       oval                     ;
  output logic       [cADDR_W-1 : 0] oaddr                    ;
  output logic        [pTAG_W-1 : 0] otag                     ;
  output logic       [pODAT_W-1 : 0] odat    [pNODE_BY_CYCLE] ;
  //
  output logic                       odecfail                 ;
  output logic        [pERR_W-1 : 0] oerr                     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cIBUF_TAG_W  = 8 + pTAG_W; // Niter + tag
  localparam int cMEM_TAG_W   = cZCNT_W + 3 + 3; // zcnt + cnode_{sop, val, eop} + vnode_{sop, val, eop};

  localparam int cCNODE_EBUSY_L =  1; // the addr gen latency (3) + ram write latency (1) - cnode output latency (2) - 1
  localparam int cCNODE_EBUSY_H =  9; // the addr_gen latency (3) + ram read latency (4) + vnode latency (6) - cnode output latency (2) - 1 - ram write latency (1)

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source's
  logic  [pNODE_BY_CYCLE-1 : 0] source__owrite                  ;
  logic                         source__owfull                  ;
  logic         [cADDR_W-1 : 0] source__owaddr                  ;
  logic signed   [pLLR_W-1 : 0] source__owLLR   [pLLR_BY_CYCLE] ;

  logic  [pNODE_BY_CYCLE-1 : 0] source_dwc__owrite                                  ;
  logic                         source_dwc__owfull                                  ;
  logic     [cIBUF_TAG_W-1 : 0] source_dwc__owtag                                   ;
  logic         [cADDR_W-1 : 0] source_dwc__owaddr  [pNODE_BY_CYCLE]                ;
  logic signed   [pLLR_W-1 : 0] source_dwc__owLLR   [pNODE_BY_CYCLE][pLLR_BY_CYCLE] ;

  //
  // input buffer
  logic     [cIBUF_TAG_W-1 : 0] ibuf__iwtag                                     ;

  logic                         ibuf__irempty                                   ;
  logic         [cADDR_W-1 : 0] ibuf__iraddr                                    ;
  logic signed   [pLLR_W-1 : 0] ibuf__oLLR      [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic     [cIBUF_TAG_W-1 : 0] ibuf__ortag                                     ;

  logic                         ibuf__oempty                                    ;
  logic                         ibuf__oemptya                                   ;
  logic                         ibuf__ofull                                     ;
  logic                         ibuf__ofulla                                    ;

  logic signed   [pLLR_W-1 : 0] buf_oLLR        [pLLR_BY_CYCLE][pNODE_BY_CYCLE] /* synthesis keep */;

  //
  // ctrl
  logic                         ctrl__obuf_rempty    ;
  logic                         ctrl__oload_mode     ;
  logic                         ctrl__oc_nv_mode     ;

  logic                         ctrl__oaddr_clear    ;
  logic                         ctrl__oaddr_enable   ;

  logic                         ctrl__ivnode_busy    ;
  logic                         ctrl__ovnode_sop     ;
  logic                         ctrl__ovnode_val     ;
  logic                         ctrl__ovnode_eop     ;

  logic                         ctrl__icnode_busy    ;
  logic                         ctrl__icnode_decfail ;
  logic                         ctrl__ocnode_sop     ;
  logic                         ctrl__ocnode_val     ;
  logic                         ctrl__ocnode_eop     ;

  logic                         ctrl__olast_iter     ;

  //
  // address generator
  mem_addr_t                    addr_gen__obuf_addr                                  ;
  mem_addr_t                    addr_gen__oaddr  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                    addr_gen__osela  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                         addr_gen__omask  [pC]               [pNODE_BY_CYCLE] ;
  tcnt_t                        addr_gen__otcnt                                      ;
  zcnt_t                        addr_gen__ozcnt                                      ;

  //
  // shift mem
  logic      [cMEM_TAG_W-1 : 0] mem__irtag                                           ;
  mem_addr_t                    mem__iraddr      [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                    mem__irsela      [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                         mem__irmask      [pC]               [pNODE_BY_CYCLE] ;
  logic      [cMEM_TAG_W-1 : 0] mem__ortag                                           ;
  logic                         mem__ormask      [pC]               [pNODE_BY_CYCLE] ;
  node_t                        mem__ordat       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t                  mem__orstate     [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  logic                         mem__iwrite                                          ;
  mem_addr_t                    mem__iwaddr      [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                    mem__iwsela      [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                         mem__iwmask      [pC]               [pNODE_BY_CYCLE] ;
  node_t                        mem__iwdat       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                         mem__iwrite_state                                    ;
  node_state_t                  mem__iwstate     [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  //
  // vertical step
  logic                         vnode__isop                                        ;
  logic                         vnode__ival                                        ;
  logic                         vnode__ieop                                        ;
  llr_t                         vnode__iLLR        [pLLR_BY_CYCLE][pNODE_BY_CYCLE] /* synthesis keep */;
  node_t                        vnode__icnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t                  vnode__icstate [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  logic                         vnode__iusop                                       ;
  logic                         vnode__iuval                                       ;
  llr_t                         vnode__iuLLR       [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  logic                         vnode__oval                                        ;
  mem_addr_t                    vnode__oaddr   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                         vnode__oamux   [pC]                                ;
  mem_sela_t                    vnode__osela   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                         vnode__omask   [pC]               [pNODE_BY_CYCLE] ;
  node_t                        vnode__ovnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t                  vnode__ovstate [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  logic                         vnode__obitsop                                     ;
  logic                         vnode__obitval                                     ;
  logic                         vnode__obiteop                                     ;
  logic   [pLLR_BY_CYCLE-1 : 0] vnode__obitdat                    [pNODE_BY_CYCLE] ;
  logic      [cBIT_ERR_W-1 : 0] vnode__obiterr                                     ;

  logic                         vnode__obusy                                       ;

  //
  // horizontal step
  logic                         cnode__isop                                        ;
  logic                         cnode__ival                                        ;
  logic                         cnode__ieop                                        ;
  zcnt_t                        cnode__izcnt                                       ;
  logic                         cnode__ivmask  [pC]               [pNODE_BY_CYCLE] ;
  node_t                        cnode__ivnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  logic                         cnode__oval                                        ;
  mem_addr_t                    cnode__oaddr   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                    cnode__osela   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                         cnode__omask   [pC]               [pNODE_BY_CYCLE] ;
  node_t                        cnode__ocnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  logic                         cnode__odecfail                                    ;
  logic                         cnode__obusy                                       ;

  //
  // sink
  logic                         sink__ibitsop                   ;
  logic                         sink__ibitval                   ;
  logic                         sink__ibiteop                   ;
  logic   [pLLR_BY_CYCLE-1 : 0] sink__ibitdat  [pNODE_BY_CYCLE] ;
  logic      [cBIT_ERR_W-1 : 0] sink__ibiterr                   ;

  logic                         sink__idecfail                  ;
  logic          [pTAG_W-1 : 0] sink__itag                      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pLLR_NUM == pLLR_BY_CYCLE) begin : usual_source_gen
      ldpc_dec_source
      #(
        .pADDR_W        ( cADDR_W        ) ,
        .pLDPC_NUM      ( cLDPC_NUM      ) ,
        .pLLR_W         ( pLLR_W         ) ,
        .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
        .pNODE_BY_CYCLE ( pNODE_BY_CYCLE )
      )
      source
      (
        .iclk    ( iclk    ) ,
        .ireset  ( ireset  ) ,
        .iclkena ( iclkena ) ,
        //
        .isop    ( isop    ) ,
        .ieop    ( ieop    ) ,
        .ival    ( ival    ) ,
        .iLLR    ( iLLR    ) ,
        //
        .obusy   ( obusy   ) ,
        .ordy    ( ordy    ) ,
        //
        .iempty  ( ibuf__oempty   ) ,
        .iemptya ( ibuf__oemptya  ) ,
        .ifull   ( ibuf__ofull    ) ,
        .ifulla  ( ibuf__ofulla   ) ,
        //
        .owrite  ( source__owrite ) ,
        .owfull  ( source__owfull ) ,
        .owaddr  ( source__owaddr ) ,
        .owLLR   ( source__owLLR  )
      );

      //------------------------------------------------------------------------------------------------------
      // input buffer : 2 cycle read delay
      //------------------------------------------------------------------------------------------------------

      ldpc_dec_ibuffer
      #(
        .pADDR_W        ( cADDR_W        ) ,
        .pLLR_W         ( pLLR_W         ) ,
        .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
        .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
        .pTAG_W         ( cIBUF_TAG_W    )
      )
      ibuf
      (
        .iclk    ( iclk           ) ,
        .ireset  ( ireset         ) ,
        .iclkena ( iclkena        ) ,
        //
        .iwrite  ( source__owrite ) ,
        .iwfull  ( source__owfull ) ,
        .iwaddr  ( source__owaddr ) ,
        .iLLR    ( source__owLLR  ) ,
        //
        .iwtag   ( ibuf__iwtag    ) ,
        //
        .irempty ( ibuf__irempty  ) ,
        .iraddr  ( ibuf__iraddr   ) ,
        .oLLR    ( ibuf__oLLR     ) ,
        .ortag   ( ibuf__ortag    ) ,
        //
        .oempty  ( ibuf__oempty   ) ,
        .oemptya ( ibuf__oemptya  ) ,
        .ofull   ( ibuf__ofull    ) ,
        .ofulla  ( ibuf__ofulla   )
      );

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (ival & isop)
            ibuf__iwtag <= {iNiter, itag};
        end
      end
    end
    else begin : dwc_source_gen
      ldpc_dec_source_dwc
      #(
        .pADDR_W        ( cADDR_W        ) ,
        .pLDPC_NUM      ( cLDPC_NUM      ) ,
        .pLLR_W         ( pLLR_W         ) ,
        .pLLR_NUM       ( pLLR_NUM       ) ,
        .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
        .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
        .pTAG_W         ( cIBUF_TAG_W    )
      )
      source_dwc
      (
        .iclk    ( iclk               ) ,
        .ireset  ( ireset             ) ,
        .iclkena ( iclkena            ) ,
        //
        .isop    ( isop               ) ,
        .ieop    ( ieop               ) ,
        .ival    ( ival               ) ,
        .itag    ( {iNiter, itag}     ) ,
        .iLLR    ( iLLR               ) ,
        //
        .obusy   ( obusy              ) ,
        .ordy    ( ordy               ) ,
        //
        .iempty  ( ibuf__oempty       ) ,
        .iemptya ( ibuf__oemptya      ) ,
        .ifull   ( ibuf__ofull        ) ,
        .ifulla  ( ibuf__ofulla       ) ,
        //
        .owrite  ( source_dwc__owrite ) ,
        .owfull  ( source_dwc__owfull ) ,
        .owtag   ( source_dwc__owtag  ) ,
        .owaddr  ( source_dwc__owaddr ) ,
        .owLLR   ( source_dwc__owLLR  )
      );

      //------------------------------------------------------------------------------------------------------
      // input buffer : 2 cycle read delay
      //------------------------------------------------------------------------------------------------------

      ldpc_dec_ibuffer_dwc
      #(
        .pADDR_W        ( cADDR_W        ) ,
        .pLLR_W         ( pLLR_W         ) ,
        .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
        .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
        .pTAG_W         ( cIBUF_TAG_W    )
      )
      ibuf
      (
        .iclk    ( iclk               ) ,
        .ireset  ( ireset             ) ,
        .iclkena ( iclkena            ) ,
        //
        .iwrite  ( source_dwc__owrite ) ,
        .iwfull  ( source_dwc__owfull ) ,
        .iwaddr  ( source_dwc__owaddr ) ,
        .iLLR    ( source_dwc__owLLR  ) ,
        //
        .iwtag   ( source_dwc__owtag  ) ,
        //
        .irempty ( ibuf__irempty      ) ,
        .iraddr  ( ibuf__iraddr       ) ,
        .oLLR    ( ibuf__oLLR         ) ,
        .ortag   ( ibuf__ortag        ) ,
        //
        .oempty  ( ibuf__oempty       ) ,
        .oemptya ( ibuf__oemptya      ) ,
        .ofull   ( ibuf__ofull        ) ,
        .ofulla  ( ibuf__ofulla       )
      );
    end
  endgenerate

  assign ibuf__iraddr   = addr_gen__obuf_addr;
  assign ibuf__irempty  = ctrl__obuf_rempty;

  //------------------------------------------------------------------------------------------------------
  // controller
  //------------------------------------------------------------------------------------------------------

  logic cnode_start_busy;
  logic vnode_start_busy;

  ldpc_dec_ctrl
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pUSE_MN_MODE   ( pUSE_MN_MODE   )
  )
  ctrl
  (
    .iclk           ( iclk                     ) ,
    .ireset         ( ireset                   ) ,
    .iclkena        ( iclkena                  ) ,
    //
    .iNiter         ( ibuf__ortag[pTAG_W +: 8] ) ,
    //
    .ifmode         ( ifmode                   ) ,
    //
    .ibuf_full      ( ibuf__ofull              ) ,
    .obuf_rempty    ( ctrl__obuf_rempty        ) ,
    //
    .iobuf_empty    ( irdy                     ) ,
    //
    .oload_mode     ( ctrl__oload_mode         ) ,
    .oc_nv_mode     ( ctrl__oc_nv_mode         ) ,
    //
    .oaddr_clear    ( ctrl__oaddr_clear        ) ,
    .oaddr_enable   ( ctrl__oaddr_enable       ) ,
    //
    .ivnode_busy    ( ctrl__ivnode_busy        ) ,
    .ovnode_sop     ( ctrl__ovnode_sop         ) ,
    .ovnode_val     ( ctrl__ovnode_val         ) ,
    .ovnode_eop     ( ctrl__ovnode_eop         ) ,
    //
    .icnode_busy    ( ctrl__icnode_busy        ) ,
    .icnode_decfail ( ctrl__icnode_decfail     ) ,
    .ocnode_sop     ( ctrl__ocnode_sop         ) ,
    .ocnode_val     ( ctrl__ocnode_val         ) ,
    .ocnode_eop     ( ctrl__ocnode_eop         ) ,
    //
    .olast_iter     ( ctrl__olast_iter         )
  );

  assign ctrl__icnode_busy    = cnode_start_busy | cnode__obusy;
  assign ctrl__icnode_decfail = cnode__odecfail;

  assign ctrl__ivnode_busy    = vnode_start_busy | vnode__obusy;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      vnode_start_busy <= 1'b0;
      cnode_start_busy <= 1'b0;
    end
    else if (iclkena) begin
      if (ctrl__ovnode_val & ctrl__ovnode_sop) begin
        vnode_start_busy <= 1'b1;
      end
      else if (vnode__oval) begin
        vnode_start_busy <= 1'b0;
      end
      //
      if (ctrl__ocnode_val & ctrl__ocnode_sop) begin
        cnode_start_busy <= 1'b1;
      end
      else if (cnode__oval) begin
        cnode_start_busy <= 1'b0;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // address generator : 2 cycle delay
  //------------------------------------------------------------------------------------------------------

  ldpc_dec_addr_gen
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE )
  )
  addr_gen
  (
    .iclk       ( iclk                ) ,
    .ireset     ( ireset              ) ,
    .iclkena    ( iclkena             ) ,
    //
    .iclear     ( ctrl__oaddr_clear   ) ,
    .ienable    ( ctrl__oaddr_enable  ) ,
    //
    .iload_mode ( ctrl__oload_mode    ) ,
    .ic_nv_mode ( ctrl__oc_nv_mode    ) ,
    //
    .obuf_addr  ( addr_gen__obuf_addr ) ,
    .oaddr      ( addr_gen__oaddr     ) ,
    .osela      ( addr_gen__osela     ) ,
    .omask      ( addr_gen__omask     ) ,
    .otcnt      ( addr_gen__otcnt     ) ,
    .ozcnt      ( addr_gen__ozcnt     )
  );

  //------------------------------------------------------------------------------------------------------
  // shift ram array :
  //    2 cycle write delay
  //    4 cycle read delay
  //------------------------------------------------------------------------------------------------------

  ldpc_dec_mem
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pTAG_W         ( cMEM_TAG_W     ) ,
    .pUSE_SC_MODE   ( pUSE_SC_MODE   )
  )
  mem
  (
    .iclk         ( iclk              ) ,
    .ireset       ( ireset            ) ,
    .iclkena      ( iclkena           ) ,
    //
    .irtag        ( mem__irtag        ) ,
    .iraddr       ( mem__iraddr       ) ,
    .irsela       ( mem__irsela       ) ,
    .irmask       ( mem__irmask       ) ,
    .ortag        ( mem__ortag        ) ,
    .ormask       ( mem__ormask       ) ,
    .ordat        ( mem__ordat        ) ,
    .orstate      ( mem__orstate      ) ,
    //
    .iwrite       ( mem__iwrite       ) ,
    .iwaddr       ( mem__iwaddr       ) ,
    .iwsela       ( mem__iwsela       ) ,
    .iwmask       ( mem__iwmask       ) ,
    .iwdat        ( mem__iwdat        ) ,
    //
    .iwrite_state ( mem__iwrite_state ) ,
    .iwstate      ( mem__iwstate      )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      mem__irtag[2 : 0] <= {ctrl__ovnode_eop, ctrl__ovnode_val, ctrl__ovnode_sop} & {3{!ctrl__oload_mode}};
      mem__irtag[5 : 3] <= {ctrl__ocnode_eop, ctrl__ocnode_val, ctrl__ocnode_sop} & {3{!ctrl__oload_mode}};
    end
  end

  always_comb mem__irtag[cMEM_TAG_W-1 : 6] = addr_gen__ozcnt;

  assign mem__iraddr  = addr_gen__oaddr ;
  assign mem__irsela  = addr_gen__osela ;
  assign mem__irmask  = addr_gen__omask ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      mem__iwrite       <= vnode__oval | cnode__oval ;
      for (int c = 0; c < pC; c++) begin
        mem__iwaddr[c]  <= vnode__oamux[c] ? vnode__oaddr [c] : cnode__oaddr [c] ;
        mem__iwsela[c]  <= vnode__oamux[c] ? vnode__osela [c] : cnode__osela [c] ;
        mem__iwdat [c]  <= vnode__oamux[c] ? vnode__ovnode[c] : cnode__ocnode[c] ;
        mem__iwmask[c]  <= vnode__oamux[c] ? vnode__omask [c] : cnode__omask [c] ;
      end
      //
      mem__iwrite_state <= vnode__oval;
      mem__iwstate      <= vnode__ovstate;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Vertical step : read cnode/iLLR -> write vnode
  //------------------------------------------------------------------------------------------------------

  node_t        wvnode__ovnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t  wvnode__ovstate [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  ldpc_dec_vnode
  #(
    .pCODE                 ( pCODE                 ) ,
    .pN                    ( pN                    ) ,
    .pLLR_W                ( pLLR_W                ) ,
    .pLLR_BY_CYCLE         ( pLLR_BY_CYCLE         ) ,
    .pNODE_W               ( pNODE_W               ) ,
    .pNODE_BY_CYCLE        ( pNODE_BY_CYCLE        ) ,
    .pBIT_ERR_SPLIT_FACTOR ( pBIT_ERR_SPLIT_FACTOR ) ,
    .pUSE_NORM             ( pNORM_VNODE           ) ,
    .pUSE_SC_MODE          ( pUSE_SC_MODE          )
  )
  vnode
  (
    .iclk    ( iclk            ) ,
    .ireset  ( ireset          ) ,
    .iclkena ( iclkena         ) ,
    //
    .isop    ( vnode__isop     ) ,
    .ival    ( vnode__ival     ) ,
    .ieop    ( vnode__ieop     ) ,
    .iLLR    ( vnode__iLLR     ) ,
    .icnode  ( vnode__icnode   ) ,
    .icstate ( vnode__icstate  ) ,
    //
    .iusop   ( vnode__iusop    ) ,
    .iuval   ( vnode__iuval    ) ,
    .iuLLR   ( vnode__iuLLR    ) ,
    //
    .oval    ( vnode__oval     ) ,
    .oaddr   ( vnode__oaddr    ) ,
    .oamux   ( vnode__oamux    ) ,
    .osela   ( vnode__osela    ) ,
    .omask   ( vnode__omask    ) ,
    .ovnode  ( wvnode__ovnode  ) ,
    .ovstate ( wvnode__ovstate ) ,
    //
    .obitsop ( vnode__obitsop  ) ,
    .obitval ( vnode__obitval  ) ,
    .obiteop ( vnode__obiteop  ) ,
    .obitdat ( vnode__obitdat  ) ,
    .obiterr ( vnode__obiterr  ) ,
    //
    .obusy   ( vnode__obusy    )
  );

  assign vnode__isop    = mem__ortag[0];
  assign vnode__ival    = mem__ortag[1];
  assign vnode__ieop    = mem__ortag[2];

  logic [2 : 0] vnode_usop /* synthesis keep */ ; // ibuffer (2) + addr_gen (1) delay
  logic [2 : 0] vnode_uval /* synthesis keep */ ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // align input buffer(2) vs mem delay(4) read delay difference
      buf_oLLR    <= ibuf__oLLR;
      vnode__iLLR <= buf_oLLR;
      // set mode
      {vnode__iusop, vnode_usop} <= {vnode_usop, ctrl__ovnode_sop & ctrl__oload_mode};
      {vnode__iuval, vnode_uval} <= {vnode_uval, ctrl__ovnode_val & ctrl__oload_mode};
    end
  end

  assign vnode__iuLLR = buf_oLLR;

  bitmask_tab_t bitmask;

  always_comb begin
    bitmask = get_bitmask_tab(pCODE);
  end

  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
          vnode__icnode [c][llra][n] = '0;
          vnode__icstate[c][llra][n] = '0;
          //
          vnode__ovnode [c][llra][n] = '0;
          vnode__ovstate[c][llra][n] = '0;
          if (!bitmask[c][n]) begin
            // forward
            vnode__icnode [c][llra][n] = mem__ordat     [c][llra][n];
            vnode__icstate[c][llra][n] = mem__orstate   [c][llra][n];
            // backward
            vnode__ovnode [c][llra][n] = wvnode__ovnode [c][llra][n];
            vnode__ovstate[c][llra][n] = wvnode__ovstate[c][llra][n];
          end // bitmask
        end // llra
      end // t
    end // c
  end

  //------------------------------------------------------------------------------------------------------
  // horizontal step : read vnode -> write cnode
  //------------------------------------------------------------------------------------------------------

  node_t wcnode__ocnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  ldpc_dec_cnode
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pUSE_NORM      ( pNORM_CNODE    ) ,
    .pEBUSY_L       ( cCNODE_EBUSY_L ) ,
    .pEBUSY_H       ( cCNODE_EBUSY_H )
  )
  cnode
  (
    .iclk     ( iclk            ) ,
    .ireset   ( ireset          ) ,
    .iclkena  ( iclkena         ) ,
    //
    .isop     ( cnode__isop     ) ,
    .ival     ( cnode__ival     ) ,
    .ieop     ( cnode__ieop     ) ,
    .izcnt    ( cnode__izcnt    ) ,
    .ivmask   ( cnode__ivmask   ) ,
    .ivnode   ( cnode__ivnode   ) ,
    //
    .oval     ( cnode__oval     ) ,
    .oaddr    ( cnode__oaddr    ) ,
    .osela    ( cnode__osela    ) ,
    .omask    ( cnode__omask    ) ,
    .ocnode   ( wcnode__ocnode  ) ,
    //
    .odecfail ( cnode__odecfail ) ,
    .obusy    ( cnode__obusy    )
  );

  assign cnode__isop    = mem__ortag[3];
  assign cnode__ival    = mem__ortag[4];
  assign cnode__ieop    = mem__ortag[5];
  assign cnode__izcnt   = mem__ortag[6 +: cZCNT_W];

  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        if (pNODE_BY_CYCLE == pT) begin
          cnode__ivmask[c][n] = bitmask[c][n];
        end
        else begin
          cnode__ivmask[c][n] = bitmask[c][n] ? 1'b1 : mem__ormask[c][n];
        end
        //
        for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
          cnode__ivnode[c][llra][n] = '0;
          cnode__ocnode[c][llra][n] = '0;
          if (!bitmask[c][n]) begin
            cnode__ivnode[c][llra][n] = mem__ordat    [c][llra][n];
            cnode__ocnode[c][llra][n] = wcnode__ocnode[c][llra][n];
          end // bitmask
        end // llra
      end // t
    end // c
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic last_iter;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      last_iter <= 1'b0;
    end
    else if (iclkena) begin
      if (ctrl__ovnode_val & ctrl__ovnode_sop & ctrl__olast_iter) begin
        last_iter <= 1'b1;
      end
      else if (vnode__obitval & vnode__obiteop) begin
        last_iter <= 1'b0;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping with optional DWC support
  //------------------------------------------------------------------------------------------------------

  ldpc_dec_engine_sink
  #(
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pIERR_W        ( cBIT_ERR_W     ) ,
    //
    .pODAT_W        ( pODAT_W        ) ,
    .pOERR_W        ( pERR_W         ) ,
    //
    .pADDR_W        ( cADDR_W        ) ,
    //
    .pTAG_W         ( pTAG_W         )
  )
  sink
  (
    .iclk     ( iclk           ) ,
    .ireset   ( ireset         ) ,
    .iclkena  ( iclkena        ) ,
    //
    .ibitsop  ( sink__ibitsop  ) ,
    .ibitval  ( sink__ibitval  ) ,
    .ibiteop  ( sink__ibiteop  ) ,
    .ibitdat  ( sink__ibitdat  ) ,
    .ibiterr  ( sink__ibiterr  ) ,
    //
    .idecfail ( sink__idecfail ) ,
    .itag     ( sink__itag     ) ,
    //
    .osop     ( osop           ) ,
    .oval     ( oval           ) ,
    .oeop     ( oeop           ) ,
    .oaddr    ( oaddr          ) ,
    .otag     ( otag           ) ,
    .odat     ( odat           ) ,
    //
    .odecfail ( odecfail       ) ,
    .oerr     ( oerr           )
  );

  assign sink__ibitsop  = vnode__obitsop & vnode__obitval & last_iter;
  assign sink__ibitval  =                  vnode__obitval & last_iter;
  assign sink__ibiteop  = vnode__obiteop & vnode__obitval & last_iter;
  assign sink__ibitdat  = vnode__obitdat;
  assign sink__ibiterr  = vnode__obiterr;

  assign sink__idecfail = cnode__odecfail;
  assign sink__itag     = ibuf__ortag[pTAG_W-1 : 0];

endmodule
