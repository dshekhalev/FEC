/*






  logic          tcm_enc__iclk     ;
  logic          tcm_enc__ireset   ;
  logic          tcm_enc__iclkena  ;
  logic  [1 : 0] tcm_enc__icode    ;
  logic          tcm_enc__i1sps    ;
  logic          tcm_enc__isop     ;
  logic          tcm_enc__ieop     ;
  logic          tcm_enc__ival     ;
  logic [10 : 0] tcm_enc__idat     ;
  logic          tcm_enc__o1sps    ;
  logic          tcm_enc__osop     ;
  logic          tcm_enc__oeop     ;
  logic          tcm_enc__oval     ;
  logic  [2 : 0] tcm_enc__odat     ;



  tcm_enc
  tcm_enc
  (
    .iclk    ( tcm_enc__iclk    ) ,
    .ireset  ( tcm_enc__ireset  ) ,
    .iclkena ( tcm_enc__iclkena ) ,
    .icode   ( tcm_enc__icode   ) ,
    .i1sps   ( tcm_enc__i1sps   ) ,
    .isop    ( tcm_enc__isop    ) ,
    .ieop    ( tcm_enc__ieop    ) ,
    .ival    ( tcm_enc__ival    ) ,
    .idat    ( tcm_enc__idat    ) ,
    .o1sps   ( tcm_enc__o1sps   ) ,
    .osop    ( tcm_enc__osop    ) ,
    .oeop    ( tcm_enc__oeop    ) ,
    .oval    ( tcm_enc__oval    ) ,
    .odat    ( tcm_enc__odat    )
  );


  assign tcm_enc__iclk    = '0 ;
  assign tcm_enc__ireset  = '0 ;
  assign tcm_enc__iclkena = '0 ;
  assign tcm_enc__icode   = '0 ;
  assign tcm_enc__i1sps   = '0 ;
  assign tcm_enc__isop    = '0 ;
  assign tcm_enc__ieop    = '0 ;
  assign tcm_enc__ival    = '0 ;
  assign tcm_enc__idat    = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_enc.sv
// Description   : 4D-8PSK TCM encoder top
//

module tcm_enc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  i1sps   ,
  //
  isop    ,
  ieop    ,
  ival    ,
  idat    ,
  //
  o1sps   ,
  osop    ,
  oeop    ,
  oval    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk    ;
  input  logic          ireset  ;
  input  logic          iclkena ;
  //
  input  logic  [1 : 0] icode   ; // 0/1/2/3 - 2/2.25/2.5/2.75
  //
  input  logic          i1sps   ; // symbol frequency
  // 4D symbol interface
  input  logic          isop    ;
  input  logic          ieop    ;
  input  logic          ival    ; // one 4D symbol for 4 8PSK symbols (!!!)
  input  logic [10 : 0] idat    ; // 11/10/9/8 - 2/2.25/2.5/2.75
  // 8PSK symbol interface
  output logic          o1sps   ;
  output logic          osop    ;
  output logic          oeop    ;
  output logic          oval    ; // one 4D symbol for 4 8PSK symbols (!!!)
  output logic  [2 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic          dfc__o1sps  ;
  logic          dfc__osop   ;
  logic          dfc__oeop   ;
  logic          dfc__oval   ;
  logic [11 : 1] dfc__odat   ;

  logic          conv__o1sps ;
  logic          conv__osop  ;
  logic          conv__oeop  ;
  logic          conv__oval  ;
  logic [11 : 0] conv__odat   ;

  //------------------------------------------------------------------------------------------------------
  // diff coder
  //------------------------------------------------------------------------------------------------------

  tcm_enc_dfc
  dfc
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .icode   ( icode      ) ,
    //
    .i1sps   ( i1sps      ) ,
    .isop    ( isop       ) ,
    .ieop    ( ieop       ) ,
    .ival    ( ival       ) ,
    .idat    ( idat       ) ,
    //
    .o1sps   ( dfc__o1sps ) ,
    .osop    ( dfc__osop  ) ,
    .oeop    ( dfc__oeop  ) ,
    .oval    ( dfc__oval  ) ,
    .odat    ( dfc__odat  )
  );

  //------------------------------------------------------------------------------------------------------
  // convolution coder
  //------------------------------------------------------------------------------------------------------

  tcm_enc_conv
  conv
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .i1sps   ( dfc__o1sps   ) ,
    .isop    ( dfc__osop    ) ,
    .ieop    ( dfc__oeop    ) ,
    .ival    ( dfc__oval    ) ,
    .idat    ( dfc__odat    ) ,
    //
    .o1sps   ( conv__o1sps  ) ,
    .osop    ( conv__osop   ) ,
    .oeop    ( conv__oeop   ) ,
    .oval    ( conv__oval   ) ,
    .odat    ( conv__odat   )
  );

  //------------------------------------------------------------------------------------------------------
  // mapper
  //------------------------------------------------------------------------------------------------------

  tcm_enc_mapper
  mapper
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    //
    .icode   ( icode       ) ,
    //
    .i1sps   ( conv__o1sps ) ,
    //
    .isop    ( conv__osop  ) ,
    .ieop    ( conv__oeop  ) ,
    .ival    ( conv__oval  ) ,
    .idat    ( conv__odat  ) ,
    //
    .o1sps   ( o1sps       ) ,
    .osop    ( osop        ) ,
    .oeop    ( oeop        ) ,
    .oval    ( oval        ) ,
    .odat    ( odat        )
  );

endmodule
