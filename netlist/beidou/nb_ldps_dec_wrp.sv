/*



  logic          nb_ldpc_dec_wrp__iclk            ;
  logic          nb_ldpc_dec_wrp__ireset          ;
  logic          nb_ldpc_dec_wrp__iclk_core       ;
  //
  logic  [7 : 0] nb_ldpc_dec_wrp__iNiter          ;
  logic          nb_ldpc_dec_wrp__ifmode          ;
  //
  logic          nb_ldpc_dec_wrp__isop            ;
  logic          nb_ldpc_dec_wrp__ival            ;
  logic          nb_ldpc_dec_wrp__ieop            ;
  logic          nb_ldpc_dec_wrp__idat            ;
  logic  [7 : 0] nb_ldpc_dec_wrp__itag            ;
  //
  logic          nb_ldpc_dec_wrp__ordy            ;
  logic          nb_ldpc_dec_wrp__obusy           ;
  logic          nb_ldpc_dec_wrp__oframe_in_error ;
  //
  logic          nb_ldpc_dec_wrp__osop            ;
  logic          nb_ldpc_dec_wrp__oval            ;
  logic          nb_ldpc_dec_wrp__oeop            ;
  logic          nb_ldpc_dec_wrp__odat            ;
  logic  [7 : 0] nb_ldpc_dec_wrp__otag            ;
  //
  logic  [7 : 0] nb_ldpc_dec_wrp__ouNiter         ;
  logic          nb_ldpc_dec_wrp__odecfail        ;
  logic [10 : 0] nb_ldpc_dec_wrp__obit_err        ;
  logic  [7 : 0] nb_ldpc_dec_wrp__osymb_err       ;



  nb_ldpc_dec_wrp
  nb_ldpc_dec_wrp
  (
    .iclk            ( nb_ldpc_dec_wrp__iclk            ) ,
    .ireset          ( nb_ldpc_dec_wrp__ireset          ) ,
    .iclk_core       ( nb_ldpc_dec_wrp__iclk_core       ) ,
    //
    .iNiter          ( nb_ldpc_dec_wrp__iNiter          ) ,
    .ifmode          ( nb_ldpc_dec_wrp__ifmode          ) ,
    //
    .isop            ( nb_ldpc_dec_wrp__isop            ) ,
    .ival            ( nb_ldpc_dec_wrp__ival            ) ,
    .ieop            ( nb_ldpc_dec_wrp__ieop            ) ,
    .idat            ( nb_ldpc_dec_wrp__idat            ) ,
    .itag            ( nb_ldpc_dec_wrp__itag            ) ,
    //
    .ordy            ( nb_ldpc_dec_wrp__ordy            ) ,
    .obusy           ( nb_ldpc_dec_wrp__obusy           ) ,
    .oframe_in_error ( nb_ldpc_dec_wrp__oframe_in_error ) ,
    //
    .osop            ( nb_ldpc_dec_wrp__osop            ) ,
    .oval            ( nb_ldpc_dec_wrp__oval            ) ,
    .oeop            ( nb_ldpc_dec_wrp__oeop            ) ,
    .odat            ( nb_ldpc_dec_wrp__odat            ) ,
    .otag            ( nb_ldpc_dec_wrp__otag            ) ,
    //
    .ouNiter         ( nb_ldpc_dec_wrp__ouNiter         ) ,
    .odecfail        ( nb_ldpc_dec_wrp__odecfail        ) ,
    .obit_err        ( nb_ldpc_dec_wrp__obit_err        ) ,
    .osymb_err       ( nb_ldpc_dec_wrp__osymb_err       )
  );


  assign nb_ldpc_dec_wrp__iclk      = '0 ;
  assign nb_ldpc_dec_wrp__ireset    = '0 ;
  assign nb_ldpc_dec_wrp__iclk_core = '0 ;
  assign nb_ldpc_dec_wrp__iNiter    = '0 ;
  assign nb_ldpc_dec_wrp__ifmode    = '0 ;
  assign nb_ldpc_dec_wrp__isop      = '0 ;
  assign nb_ldpc_dec_wrp__ival      = '0 ;
  assign nb_ldpc_dec_wrp__ieop      = '0 ;
  assign nb_ldpc_dec_wrp__idat      = '0 ;
  assign nb_ldpc_dec_wrp__itag      = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : nb_ldpc_dec_wrp.sv
// Description   : BCNV1_SF3 decoder only
//                 maximum number of iterations is 8 (!!!)
//

module nb_ldpc_dec_wrp
(
  iclk            ,
  ireset          ,
  iclk_core       ,
  //
  iNiter          ,
  ifmode          ,
  //
  isop            ,
  ival            ,
  ieop            ,
  idat            ,
  itag            ,
  //
  ordy            ,
  obusy           ,
  oframe_in_error ,
  //
  osop            ,
  oval            ,
  oeop            ,
  odat            ,
  otag            ,
  //
  ouNiter         ,
  odecfail        ,
  obit_err        ,
  osymb_err
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk            ;
  input  logic          ireset          ;
  input  logic          iclk_core       ; // LDPC core clock
  //
  input  logic  [7 : 0] iNiter          ;
  input  logic          ifmode          ;
  //
  input  logic          isop            ;
  input  logic          ival            ;
  input  logic          ieop            ;
  input  logic          idat            ;
  input  logic  [7 : 0] itag            ;
  //
  output logic          ordy            ;
  output logic          obusy           ;
  output logic          oframe_in_error ;
  //
  output logic          osop            ;
  output logic          oval            ;
  output logic          oeop            ;
  output logic          odat            ;
  output logic  [7 : 0] otag            ;
  //
  output logic  [7 : 0] ouNiter         ;
  output logic          odecfail        ;
  output logic [10 : 0] obit_err        ;
  output logic  [7 : 0] osymb_err       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  nb_ldpc_dec_stub
  dec
  (
    .iclk            ( iclk            ) ,
    .ireset          ( ireset          ) ,
    .iclk_core       ( iclk_core       ) ,
    //
    .iNiter          ( iNiter          ) ,
    .ifmode          ( ifmode          ) ,
    //
    .isop            ( isop            ) ,
    .ival            ( ival            ) ,
    .ieop            ( ieop            ) ,
    .idat            ( idat            ) ,
    .itag            ( itag            ) ,
    //
    .ordy            ( ordy            ) ,
    .obusy           ( obusy           ) ,
    .oframe_in_error ( oframe_in_error ) ,
    //
    .osop            ( osop            ) ,
    .oval            ( oval            ) ,
    .oeop            ( oeop            ) ,
    .odat            ( odat            ) ,
    .otag            ( otag            ) ,
    //
    .ouNiter         ( ouNiter         ) ,
    .odecfail        ( odecfail        ) ,
    .obit_err        ( obit_err        ) ,
    .osymb_err       ( osymb_err       )
  );

endmodule
