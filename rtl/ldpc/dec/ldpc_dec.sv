/*



  parameter int pCODE         =             1 ;
  parameter int pN            =            48 ;
  parameter int pLLR_W        =             5 ;
  parameter int pLLR_BY_CYCLE =             2 ;
  parameter int pNODE_W       =             1 ;
  parameter bit pUSE_SC_MODE  =             0 ;
  parameter int pODAT_W       = pLLR_BY_CYCLE ;
  parameter int pERR_W        =            16 ;
  parameter int pTAG_W        =             4 ;



  logic                       ldpc_dec__iclk                    ;
  logic                       ldpc_dec__ireset                  ;
  logic                       ldpc_dec__iclkena                 ;
  logic               [7 : 0] ldpc_dec__iNiter                  ;
  logic                       ldpc_dec__ifmode                  ;
  logic                       ldpc_dec__isop                    ;
  logic                       ldpc_dec__ieop                    ;
  logic                       ldpc_dec__ival                    ;
  logic        [pTAG_W-1 : 0] ldpc_dec__itag                    ;
  logic signed [pLLR_W-1 : 0] ldpc_dec__iLLR    [pLLR_BY_CYCLE] ;
  logic                       ldpc_dec__obusy                   ;
  logic                       ldpc_dec__ordy                    ;
  logic                       ldpc_dec__osop                    ;
  logic                       ldpc_dec__oeop                    ;
  logic                       ldpc_dec__oval                    ;
  logic        [pTAG_W-1 : 0] ldpc_dec__otag                    ;
  logic [pLLR_BY_CYCLE-1 : 0] ldpc_dec__odat                    ;
  logic                       ldpc_dec__odecfail                ;
  logic        [pERR_W-1 : 0] ldpc_dec__oerr                    ;



  ldpc_dec
  #(
    .pCODE         ( pCODE         ) ,
    .pN            ( pN            ) ,
    .pLLR_W        ( pLLR_W        ) ,
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pNODE_W       ( pNODE_W       ) ,
    .pNORM_VNODE   ( pNORM_VNODE   ) ,
    .pNORM_CNODE   ( pNORM_CNODE   ) ,
    .pUSE_SC_MODE  ( pUSE_SC_MODE  ) ,
    .pODAT_W       ( pODAT_W       ) ,
    .pERR_W        ( pERR_W        ) ,
    .pTAG_W        ( pTAG_W        )
  )
  ldpc_dec
  (
    .iclk     ( ldpc_dec__iclk     ) ,
    .ireset   ( ldpc_dec__ireset   ) ,
    .iclkena  ( ldpc_dec__iclkena  ) ,
    .iNiter   ( ldpc_dec__iNiter   ) ,
    .ifmode   ( ldpc_dec__ifmode   ) ,
    .isop     ( ldpc_dec__isop     ) ,
    .ieop     ( ldpc_dec__ieop     ) ,
    .ival     ( ldpc_dec__ival     ) ,
    .itag     ( ldpc_dec__itag     ) ,
    .iLLR     ( ldpc_dec__iLLR     ) ,
    .obusy    ( ldpc_dec__obusy    ) ,
    .ordy     ( ldpc_dec__ordy     ) ,
    .osop     ( ldpc_dec__osop     ) ,
    .oeop     ( ldpc_dec__oeop     ) ,
    .oval     ( ldpc_dec__oval     ) ,
    .otag     ( ldpc_dec__otag     ) ,
    .odat     ( ldpc_dec__odat     ) ,
    .odecfail ( ldpc_dec__odecfail ) ,
    .oerr     ( ldpc_dec__oerr     )
  );


  assign ldpc_dec__iclk    = '0 ;
  assign ldpc_dec__ireset  = '0 ;
  assign ldpc_dec__iclkena = '0 ;
  assign ldpc_dec__iNiter  = '0 ;
  assign ldpc_dec__ifmode  = '0 ;
  assign ldpc_dec__isop    = '0 ;
  assign ldpc_dec__ieop    = '0 ;
  assign ldpc_dec__ival    = '0 ;
  assign ldpc_dec__itag    = '0 ;
  assign ldpc_dec__iLLR    = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec.sv
// Description   : LDPC decoder with static code parameters. Normalized 2D min-sum algorithm is used. Input metrics is straight(!!!). The metric saturation is inside.
//                 The iNiter port and any input tag info latched inside at isop & ival signal. Decoder use 2D input buffer and no any output buffers or output handshake
//                 The decoded systematic bits output during decoding on fly with error counting. Only systematic bit error is take into acount(!!!). The actual oerr value is valid at oeop tag.
//

`include "define.vh"

module ldpc_dec
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
  osop     ,
  oeop     ,
  oval     ,
  otag     ,
  odat     ,
  //
  odecfail ,
  oerr
);

  parameter bit pNORM_VNODE =  1 ; // 1/0 vnode noramlization coefficient is 0.875/1
  parameter bit pNORM_CNODE =  1 ; // 1/0 cnode noramlization coefficient is 0.875/1
  parameter int pERR_W      = 16 ;
  parameter int pTAG_W      =  4 ;

  `include "../ldpc_parameters.svh"
  `include "ldpc_dec_parameters.svh"

  parameter int pODAT_W     = pLLR_BY_CYCLE ; // output data bitwidth. pODAT_W = N*pLLR_BY_CYCLE and must be multuply of pZF * pT

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                     ;
  input  logic                       ireset                   ;
  input  logic                       iclkena                  ;
  //
  input  logic               [7 : 0] iNiter                   ;
  input  logic                       ifmode                   ;
  //
  input  logic                       isop                     ;
  input  logic                       ieop                     ;
  input  logic                       ival                     ;
  input  logic        [pTAG_W-1 : 0] itag                     ;
  input  logic signed [pLLR_W-1 : 0] iLLR    [pLLR_BY_CYCLE]  ;
  //
  output logic                       obusy                    ;
  output logic                       ordy                     ;
  //
  output logic                       osop                     ;
  output logic                       oeop                     ;
  output logic                       oval                     ;
  output logic        [pTAG_W-1 : 0] otag                     ;
  output logic       [pODAT_W-1 : 0] odat                     ;
  //
  output logic                       odecfail                 ;
  output logic        [pERR_W-1 : 0] oerr                     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pLLR_BY_CYCLE-1 : 0] engine__odat [1] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  ldpc_dec_engine
  #(
    .pCODE          ( pCODE         ) ,
    .pN             ( pN            ) ,
    //
    .pLLR_W         ( pLLR_W        ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE ) ,
    .pNODE_W        ( pNODE_W       ) ,
    .pNODE_BY_CYCLE ( 1             ) ,
    .pUSE_MN_MODE   ( 0             ) ,
    //
    .pNORM_VNODE    ( pNORM_VNODE   ) ,
    .pNORM_CNODE    ( pNORM_CNODE   ) ,
    .pUSE_SC_MODE   ( pUSE_SC_MODE  ) ,
    //
    .pODAT_W        ( pODAT_W       ) ,
    .pERR_W         ( pERR_W        ) ,
    .pTAG_W         ( pTAG_W        )
  )
  engine
  (
    .iclk     ( iclk         ) ,
    .ireset   ( ireset       ) ,
    .iclkena  ( iclkena      ) ,
    //
    .iNiter   ( iNiter       ) ,
    .ifmode   ( ifmode       ) ,
    //
    .isop     ( isop         ) ,
    .ieop     ( ieop         ) ,
    .ival     ( ival         ) ,
    .itag     ( itag         ) ,
    .iLLR     ( iLLR         ) ,
    //
    .obusy    ( obusy        ) ,
    .ordy     ( ordy         ) ,
    //
    .irdy     ( 1'b1         ) , // no output buffer
    //
    .osop     ( osop         ) ,
    .oeop     ( oeop         ) ,
    .oval     ( oval         ) ,
    .oaddr    (              ) ,
    .otag     ( otag         ) ,
    .odat     ( engine__odat ) ,
    //
    .odecfail ( odecfail     ) ,
    .oerr     ( oerr         )
  );

  assign odat = engine__odat[0];

endmodule
