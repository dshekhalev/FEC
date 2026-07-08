/*



  parameter int pRADDR_W = 8 ;
  parameter int pWADDR_W = 8 ;
  parameter int pTAG_W   = 8 ;



  logic                       b_nb_ldpc_hd_dec_engine_fix__iclk        ;
  logic                       b_nb_ldpc_hd_dec_engine_fix__ireset      ;
  logic                       b_nb_ldpc_hd_dec_engine_fix__iclkena     ;
  //
  logic                       b_nb_ldpc_hd_dec_engine_fix__irbuf_full  ;
  logic               [3 : 0] b_nb_ldpc_hd_dec_engine_fix__iNiter      ;
  logic                       b_nb_ldpc_hd_dec_engine_fix__ifmode      ;
  //
  gf_data_t                   b_nb_ldpc_hd_dec_engine_fix__irdat       ;
  logic        [pTAG_W-1 : 0] b_nb_ldpc_hd_dec_engine_fix__irtag       ;
  logic                       b_nb_ldpc_hd_dec_engine_fix__orempty     ;
  logic      [pRADDR_W-1 : 0] b_nb_ldpc_hd_dec_engine_fix__oraddr      ;
  //
  logic                       b_nb_ldpc_hd_dec_engine_fix__iwbuf_empty ;
  //
  logic                       b_nb_ldpc_hd_dec_engine_fix__owrite      ;
  logic                       b_nb_ldpc_hd_dec_engine_fix__owfull      ;
  logic      [pWADDR_W-1 : 0] b_nb_ldpc_hd_dec_engine_fix__owaddr      ;
  gf_data_t                   b_nb_ldpc_hd_dec_engine_fix__owdat       ;
  logic        [pTAG_W-1 : 0] b_nb_ldpc_hd_dec_engine_fix__owtag       ;
  //
  logic                       b_nb_ldpc_hd_dec_engine_fix__owdecfail   ;
  bit_err_t                   b_nb_ldpc_hd_dec_engine_fix__owbit_err   ;
  bit_err_t                   b_nb_ldpc_hd_dec_engine_fix__owsymb_err  ;
  logic               [3 : 0] b_nb_ldpc_hd_dec_engine_fix__owNiter     ;
  //
  logic                       b_nb_ldpc_hd_dec_engine_fix__obusy       ;



  b_nb_ldpc_hd_dec_engine_fix
  #(
    .pRADDR_W ( pRADDR_W      ) ,
    .pWADDR_W ( pWADDR_W      ) ,
    .pTAG_W   ( pTAG_W        )
  )
  b_nb_ldpc_hd_dec_engine_fix
  (
    .iclk        ( b_nb_ldpc_hd_dec_engine_fix__iclk        ) ,
    .ireset      ( b_nb_ldpc_hd_dec_engine_fix__ireset      ) ,
    .iclkena     ( b_nb_ldpc_hd_dec_engine_fix__iclkena     ) ,
    //
    .irbuf_full  ( b_nb_ldpc_hd_dec_engine_fix__irbuf_full  ) ,
    .iNiter      ( b_nb_ldpc_hd_dec_engine_fix__iNiter      ) ,
    .ifmode      ( b_nb_ldpc_hd_dec_engine_fix__ifmode      ) ,
    //
    .irdat       ( b_nb_ldpc_hd_dec_engine_fix__irdat       ) ,
    .irtag       ( b_nb_ldpc_hd_dec_engine_fix__irtag       ) ,
    .orempty     ( b_nb_ldpc_hd_dec_engine_fix__orempty     ) ,
    .oraddr      ( b_nb_ldpc_hd_dec_engine_fix__oraddr      ) ,
    //
    .iwbuf_empty ( b_nb_ldpc_hd_dec_engine_fix__iwbuf_empty ) ,
    //
    .owrite      ( b_nb_ldpc_hd_dec_engine_fix__owrite      ) ,
    .owfull      ( b_nb_ldpc_hd_dec_engine_fix__owfull      ) ,
    .owaddr      ( b_nb_ldpc_hd_dec_engine_fix__owaddr      ) ,
    .owdat       ( b_nb_ldpc_hd_dec_engine_fix__owdat       ) ,
    .owtag       ( b_nb_ldpc_hd_dec_engine_fix__owtag       ) ,
    //
    .owdecfail   ( b_nb_ldpc_hd_dec_engine_fix__owdecfail   ) ,
    .owbit_err   ( b_nb_ldpc_hd_dec_engine_fix__owbit_err   ) ,
    .owsymb_err  ( b_nb_ldpc_hd_dec_engine_fix__owsymb_err  ) ,
    .owNiter     ( b_nb_ldpc_hd_dec_engine_fix__owNiter     ) ,
    //
    .obusy       ( b_nb_ldpc_hd_dec_engine_fix__obusy       )
  );


  assign b_nb_ldpc_hd_dec_engine_fix__iclk        = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__ireset      = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__iclkena     = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__irbuf_full  = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__iNiter      = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__ifmode      = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__irdat       = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__irtag       = '0 ;
  assign b_nb_ldpc_hd_dec_engine_fix__iwbuf_empty = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_hd_dec_engine_fix.svh
// Description   : decoder {88,44} engine with hard input bit (!!!) decision
//

module b_nb_ldpc_hd_dec_engine_fix
#(
  parameter int pRADDR_W      = 8 ,
  parameter int pWADDR_W      = 8 ,
  parameter int pTAG_W        = 8 ,
  //
  parameter int pBCNV_MAX_IDX = 0
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  irbuf_full  ,
  iNiter      ,
  ifmode      ,
  //
  irdat       ,
  irtag       ,
  orempty     ,
  oraddr      ,
  //
  iwbuf_empty ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  owtag       ,
  //
  owdecfail   ,
  owbit_err   ,
  owsymb_err  ,
  owNiter     ,
  //
  obusy
);

  `include "b_nb_ldpc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk        ;
  input  logic                       ireset      ;
  input  logic                       iclkena     ;
  //
  input  logic                       irbuf_full  ;
  input  logic               [3 : 0] iNiter      ;
  input  logic                       ifmode      ;
  //
  input  gf_data_t                   irdat       ;
  input  logic        [pTAG_W-1 : 0] irtag       ;
  output logic                       orempty     ;
  output logic      [pRADDR_W-1 : 0] oraddr      ;
  //
  input  logic                       iwbuf_empty ;
  //
  output logic                       owrite      ;
  output logic                       owfull      ;
  output logic      [pWADDR_W-1 : 0] owaddr      ;
  output gf_data_t                   owdat       ;
  output logic        [pTAG_W-1 : 0] owtag       ;
  //
  output logic                       owdecfail   ;
  output bit_err_t                   owbit_err   ;
  output bit_err_t                   owsymb_err  ;
  output logic               [3 : 0] owNiter     ;
  //
  output logic                       obusy       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------


  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------



endmodule
