/*

  parameter bit [1 : 0] pCODEGR   = 0;
  parameter bit [4 : 0] pCODERATE = 0;
  parameter bit         pXMODE    = 0;
  parameter int         pTAG_W    = 1;





  logic                bch_dvb_dec_fix__iclk      ;
  logic                bch_dvb_dec_fix__ireset    ;
  logic                bch_dvb_dec_fix__iclkena   ;
  //
  logic                bch_dvb_dec_fix__isop      ;
  logic                bch_dvb_dec_fix__ival      ;
  logic                bch_dvb_dec_fix__ieop      ;
  logic [pTAG_W-1 : 0] bch_dvb_dec_fix__itag      ;
  logic                bch_dvb_dec_fix__idat      ;
  //
  logic                bch_dvb_dec_fix__osop      ;
  logic                bch_dvb_dec_fix__oval      ;
  logic                bch_dvb_dec_fix__oeop      ;
  logic                bch_dvb_dec_fix__oeof      ;
  logic [pTAG_W-1 : 0] bch_dvb_dec_fix__otag      ;
  logic                bch_dvb_dec_fix__odat      ;
  //
  logic                bch_dvb_dec_fix__odecfail  ;
  logic       [15 : 0] bch_dvb_dec_fix__obiterr   ;



  bch_dvb_dec_fix
  #(
    .pCODEGR   ( pCODEGR   ) ,
    .pCODERATE ( pCODERATE ) ,
    .pXMODE    ( pXMODE    ) ,
    .pTAG_W    ( pTAG_W    )
  )
  bch_dvb_dec_fix
  (
    .iclk     ( bch_dvb_dec_fix__iclk     ) ,
    .ireset   ( bch_dvb_dec_fix__ireset   ) ,
    .iclkena  ( bch_dvb_dec_fix__iclkena  ) ,
    //
    .isop     ( bch_dvb_dec_fix__isop     ) ,
    .ival     ( bch_dvb_dec_fix__ival     ) ,
    .ieop     ( bch_dvb_dec_fix__ieop     ) ,
    .itag     ( bch_dvb_dec_fix__itag     ) ,
    .idat     ( bch_dvb_dec_fix__idat     ) ,
    //
    .osop     ( bch_dvb_dec_fix__osop     ) ,
    .oval     ( bch_dvb_dec_fix__oval     ) ,
    .oeop     ( bch_dvb_dec_fix__oeop     ) ,
    .oeof     ( bch_dvb_dec_fix__oeof     ) ,
    .otag     ( bch_dvb_dec_fix__otag     ) ,
    .odat     ( bch_dvb_dec_fix__odat     ) ,
    //
    .odecfail ( bch_dvb_dec_fix__odecfail ) ,
    .obiterr  ( bch_dvb_dec_fix__obiterr  )
  );


  assign bch_dvb_dec_fix__iclk    = '0 ;
  assign bch_dvb_dec_fix__iclkena = '0 ;
  assign bch_dvb_dec_fix__ireset  = '0 ;
  assign bch_dvb_dec_fix__isop    = '0 ;
  assign bch_dvb_dec_fix__ival    = '0 ;
  assign bch_dvb_dec_fix__ieop    = '0 ;
  assign bch_dvb_dec_fix__itag    = '0 ;
  assign bch_dvb_dec_fix__idat    = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_dvb_dec_fix.sv
// Description   : bch DVB-S2/S2x decoder wrapper
//

module bch_dvb_dec_fix
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  isop     ,
  ival     ,
  ieop     ,
  itag     ,
  idat     ,
  //
  osop     ,
  oval     ,
  oeop     ,
  oeof     ,
  otag     ,
  odat     ,
  //
  odecfail ,
  obiterr
);

  parameter int pTAG_W = 1;

  `include "bch_dvb_fix_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk      ;
  input  logic                ireset    ;
  input  logic                iclkena   ;
  //
  input  logic                isop      ;
  input  logic                ival      ;
  input  logic                ieop      ;
  input  logic [pTAG_W-1 : 0] itag      ;
  input  logic                idat      ;
  //
  output logic                osop      ;
  output logic                oval      ;
  output logic                oeop      ;
  output logic                oeof      ;
  output logic [pTAG_W-1 : 0] otag      ;
  output logic                odat      ;
  //
  output logic                odecfail  ;
  output logic       [15 : 0] obiterr   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cM      = cGF_M[pCODEGR];
  localparam int cK_MAX  = get_data_max_bits_num(pCODEGR, pCODERATE, pXMODE);
  localparam int cD      = 1 + 2*get_t_num(pCODEGR, pCODERATE, pXMODE);
  localparam int cN      = get_code_bits_num(pCODEGR, pCODERATE, pXMODE);
  localparam int cIRRPOL = cGF_IRRPOL[pCODEGR];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bch_dec
  #(
    .m         ( cM            ) ,
    .k_max     ( cK_MAX        ) ,
    .d         ( cD            ) ,
    .n         ( cN            ) ,
    .irrpol    ( cIRRPOL       ) ,
    //
    .pBM_TYPE  ( "ribm_t_by_t" ) ,
    .pBM_ASYNC ( 1'b0          )
  )
  bch_dec
  (
    .iclk     ( iclk     ) ,
    .ireset   ( ireset   ) ,
    .iclkena  ( iclkena  ) ,
    //
    .isop     ( isop     ) ,
    .ival     ( ival     ) ,
    .ieop     ( ieop     ) ,
    .idat     ( idat     ) ,
    //
    .osop     ( osop     ) ,
    .oval     ( oval     ) ,
    .oeop     ( oeop     ) ,
    .oeof     ( oeof     ) ,
    .odat     ( odat     ) ,
    //
    .odecfail ( odecfail ) ,
    .obiterr  ( obiterr  )
  );

endmodule
