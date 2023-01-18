//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_enc_wrp.sv
// Description   : RSC encoder wrapper for synthesis
//

module rsc_enc_wrp
#(
  parameter int pTAG_W       =    8 ,
  //
  parameter int pCODE        =    3 , // coderate
  parameter int pPTYPE       =   31 , // permutation type
  parameter int pN           = 1920 , // number of data duobit's <= 4096
  //
  parameter bit pUSE_OBUFFER =    1   // use output buffer at encoder output
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ieop    ,
  ival    ,
  idat    ,
  itag    ,
  //
  obusy   ,
  ordy    ,
  //
  idbsclk ,
  ofull   ,
  //
  osop    ,
  oeop    ,
  oeof    ,
  oval    ,
  odat    ,
  otag
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                isop    ;
  input  logic                ieop    ;
  input  logic                ival    ;
  input  logic        [1 : 0] idat    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  //
  output logic                obusy   ;
  output logic                ordy    ;
  //
  input  logic                idbsclk ; // output debit symbol clock
  output logic                ofull   ;
  //
  output logic                osop    ;
  output logic                oeop    ;
  output logic                oeof    ;
  output logic                oval    ;
  output logic        [1 : 0] odat    ;
  output logic [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  rsc_enc
  #(
    .pTAG_W          ( pTAG_W       ) ,
    .pN_MAX          ( pN           ) ,
    .pUSE_FIXED_CODE ( 1            ) ,
    .pUSE_OBUFFER    ( pUSE_OBUFFER )
  )
  rsc_enc
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    //
    .icode   ( pCODE       ) ,
    .iptype  ( pPTYPE      ) ,
    .iN      ( pN          ) ,
    //
    .isop    ( isop        ) ,
    .ieop    ( ieop        ) ,
    .ival    ( ival        ) ,
    .idat    ( idat        ) ,
    .itag    ( itag        ) ,
    //
    .obusy   ( obusy       ) ,
    .ordy    ( ordy        ) ,
    //
    .idbsclk ( idbsclk     ) ,
    .ofull   ( ofull       ) ,
    //
    .osop    ( osop        ) ,
    .oeop    ( oeop        ) ,
    .oeof    ( oeof        ) ,
    .oval    ( oval        ) ,
    .odat    ( odat        ) ,
    .otag    ( otag        )
  );

endmodule
