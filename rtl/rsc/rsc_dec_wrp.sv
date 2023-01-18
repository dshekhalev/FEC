//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_wrp.sv
// Description   : simple decoder wrapper for synthsis
//

module rsc_dec_wrp
#(
  parameter int pLLR_W                =    5 ,  // LLR width
  parameter int pODAT_W               =    2 ,  // Output data width 2/4/8
  //
  parameter int pTAG_W                =    8 ,  // Tag port bitwidth
  //
  parameter int pCODE                 =    3 ,  // coderate
  parameter int pPTYPE                =   31 ,  // permutation type
  parameter int pN                    = 1920 ,  // number of data duobit's <= 4096
  //
  parameter bit pUSE_SRC_EOP_VAL_MASK =    1    // use ieop with ival ANDED, else use single ieop
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
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

  localparam int cUSE_W_BIT = (pCODE == 0) | (pCODE == 11) | (pCODE == 12) ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  rsc_dec
  #(
    .pLLR_W                ( pLLR_W                ) ,
    .pODAT_W               ( pODAT_W               ) ,
    .pTAG_W                ( pTAG_W                ) ,
    //
    .pN_MAX                ( pN                    ) ,
    .pUSE_W_BIT            ( cUSE_W_BIT            ) ,
    .pUSE_FIXED_CODE       ( 1                     ) ,
    //
    .pUSE_RAM_PIPE         ( 1                     ) ,
    //
    .pUSE_SRC_EOP_VAL_MASK ( pUSE_SRC_EOP_VAL_MASK )
  )
  rsc_dec
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .icode   ( pCODE   ) ,
    .iptype  ( pPTYPE  ) ,
    .iN      ( pN      ) ,
    //
    .iNiter  ( iNiter  ) ,
    //
    .itag    ( itag    ) ,
    .isop    ( isop    ) ,
    .ieop    ( ieop    ) ,
    .ival    ( ival    ) ,
    .iLLR    ( iLLR    ) ,
    //
    .obusy   ( obusy   ) ,
    .ordy    ( ordy    ) ,
    //
    .ireq    ( ireq    ) ,
    .ofull   ( ofull   ) ,
    //
    .osop    ( osop    ) ,
    .oeop    ( oeop    ) ,
    .oval    ( oval    ) ,
    .odat    ( odat    ) ,
    .otag    ( otag    ) ,
    .oerr    ( oerr    )
  );

endmodule

