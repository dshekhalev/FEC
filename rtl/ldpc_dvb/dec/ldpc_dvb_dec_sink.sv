/*



  parameter int pRADDR_W  =  8 ;
  parameter int pRDAT_W   =  2 ;
  //
  parameter int pDAT_W    =  8 ;
  parameter int pTAG_W    =  4 ;
  //
  parameter int pERR_W    = 16 ;



  logic                    ldpc_dvb_dec_sink__iclk      ;
  logic                    ldpc_dvb_dec_sink__ireset    ;
  logic                    ldpc_dvb_dec_sink__iclkena   ;
  //
  col_t                    ldpc_dvb_dec_sink__irsize    ;
  //
  logic                    ldpc_dvb_dec_sink__irfull    ;
  logic    [pRDAT_W-1 : 0] ldpc_dvb_dec_sink__irdat     ;
  logic     [pTAG_W-1 : 0] ldpc_dvb_dec_sink__irtag     ;
  //
  logic                    ldpc_dvb_dec_sink__irdecfail ;
  logic     [pERR_W-1 : 0] ldpc_dvb_dec_sink__irerr     ;
  logic            [7 : 0] ldpc_dvb_dec_sink__irNiter   ;
  //
  logic                    ldpc_dvb_dec_sink__orempty   ;
  logic   [pRADDR_W-1 : 0] ldpc_dvb_dec_sink__oraddr    ;
  //
  logic                    ldpc_dvb_dec_sink__ireq      ;
  logic                    ldpc_dvb_dec_sink__ofull     ;
  //
  logic                    ldpc_dvb_dec_sink__osop      ;
  logic                    ldpc_dvb_dec_sink__oeop      ;
  logic                    ldpc_dvb_dec_sink__oval      ;
  logic     [pDAT_W-1 : 0] ldpc_dvb_dec_sink__odat      ;
  logic     [pTAG_W-1 : 0] ldpc_dvb_dec_sink__otag      ;
  //
  logic                    ldpc_dvb_dec_sink__odecfail  ;
  logic     [pERR_W-1 : 0] ldpc_dvb_dec_sink__oerr      ;
  logic            [7 : 0] ldpc_dvb_dec_sink__oNiter    ;




  ldpc_dvb_dec_sink
  #(
    .pRADDR_W ( pRADDR_W ) ,
    .pRDAT    ( pRDAT    ) ,
    //
    .pDAT_W   ( pDAT_W   ) ,
    .pTAG_W   ( pTAG_W   ) ,
    //
    .pERR_W   ( pERR_W   )
  )
  ldpc_dvb_dec_sink
  (
    .iclk      ( ldpc_dvb_dec_sink__iclk      ) ,
    .ireset    ( ldpc_dvb_dec_sink__ireset    ) ,
    .iclkena   ( ldpc_dvb_dec_sink__iclkena   ) ,
    //
    .irsize    ( ldpc_dvb_dec_sink__irsize    ) ,
    //
    .irfull    ( ldpc_dvb_dec_sink__irfull    ) ,
    .irdat     ( ldpc_dvb_dec_sink__irdat     ) ,
    .irtag     ( ldpc_dvb_dec_sink__irtag     ) ,
    //
    .irdecfail ( ldpc_dvb_dec_sink__irdecfail ) ,
    .irerr     ( ldpc_dvb_dec_sink__irerr     ) ,
    .irNiter   ( ldpc_dvb_dec_sink__irNiter   ) ,
    //
    .orempty   ( ldpc_dvb_dec_sink__orempty   ) ,
    .oraddr    ( ldpc_dvb_dec_sink__oraddr    ) ,
    //
    .ireq      ( ldpc_dvb_dec_sink__ireq      ) ,
    .ofull     ( ldpc_dvb_dec_sink__ofull     ) ,
    //
    .osop      ( ldpc_dvb_dec_sink__osop      ) ,
    .oeop      ( ldpc_dvb_dec_sink__oeop      ) ,
    .oval      ( ldpc_dvb_dec_sink__oval      ) ,
    .odat      ( ldpc_dvb_dec_sink__odat      ) ,
    .otag      ( ldpc_dvb_dec_sink__otag      ) ,
    //
    .odecfail  ( ldpc_dvb_dec_sink__odecfail  ) ,
    .oerr      ( ldpc_dvb_dec_sink__oerr      ) ,
    .oNiter    ( ldpc_dvb_dec_sink__oNiter    )
  );


  assign ldpc_dvb_dec_sink__iclk      = '0 ;
  assign ldpc_dvb_dec_sink__ireset    = '0 ;
  assign ldpc_dvb_dec_sink__iclkena   = '0 ;
  assign ldpc_dvb_dec_sink__irsize    = '0 ;
  assign ldpc_dvb_dec_sink__irfull    = '0 ;
  assign ldpc_dvb_dec_sink__irdat     = '0 ;
  assign ldpc_dvb_dec_sink__irtag     = '0 ;
  assign ldpc_dvb_dec_sink__irdecfail = '0 ;
  assign ldpc_dvb_dec_sink__irerr     = '0 ;
  assing ldpc_dvb_dec_sink__irNiter   = '0 ;
  assign ldpc_dvb_dec_sink__ireq      = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_sink.sv
// Description   : Ouput decoder interface module for decoders which using output memory.
//

module ldpc_dvb_dec_sink
#(
  parameter int pRADDR_W = 8 ,
  parameter int pRDAT_W  = 8 ,
  //
  parameter int pDAT_W   = 8 ,
  parameter int pTAG_W   = 8 ,
  //
  parameter int pERR_W   = 8
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  irsize    ,
  irfull    ,
  irdat     ,
  irtag     ,
  //
  irerr     ,
  irdecfail ,
  irNiter   ,
  //
  orempty   ,
  oraddr    ,
  //
  ireq      ,
  ofull     ,
  //
  osop      ,
  oeop      ,
  oval      ,
  odat      ,
  otag      ,
  //
  odecfail  ,
  oerr      ,
  oNiter
);

  `include "../ldpc_dvb_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk                ;
  input  logic                  ireset              ;
  input  logic                  iclkena             ;
  //
  input  col_t                  irsize              ;
  //
  input  logic                  irfull              ;
  input  logic  [pRDAT_W-1 : 0] irdat               ;
  input  logic   [pTAG_W-1 : 0] irtag               ;
  //
  input  logic                  irdecfail           ;
  input  logic   [pERR_W-1 : 0] irerr               ;
  input  logic          [7 : 0] irNiter             ;
  //
  output logic                  orempty             ;
  output logic [pRADDR_W-1 : 0] oraddr              ;
  //
  input  logic                  ireq                ;
  output logic                  ofull               ;
  //
  output logic                  osop                ;
  output logic                  oeop                ;
  output logic                  oval                ;
  output logic   [pDAT_W-1 : 0] odat                ;
  output logic   [pTAG_W-1 : 0] otag                ;
  //
  output logic                  odecfail            ;
  output logic   [pERR_W-1 : 0] oerr                ;
  output logic          [7 : 0] oNiter              ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cTAG_W = pTAG_W + pERR_W + 1 + 8;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [cTAG_W-1 : 0] sink__irtag;
  logic [cTAG_W-1 : 0] sink__otag;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_sink
  #(
    .pRADDR_W ( pRADDR_W ) ,
    .pRDAT_W  ( pRDAT_W  ) ,
    //
    .pDAT_W   ( pDAT_W   ) ,
    .pTAG_W   ( cTAG_W   )
  )
  sink
  (
    .iclk      ( iclk        ) ,
    .ireset    ( ireset      ) ,
    .iclkena   ( iclkena     ) ,
    //
    .irsize    ( irsize      ) ,
    .irfull    ( irfull      ) ,
    .irdat     ( irdat       ) ,
    .irtag     ( sink__irtag ) ,
    .orempty   ( orempty     ) ,
    .oraddr    ( oraddr      ) ,
    //
    .ireq      ( ireq        ) ,
    .ofull     ( ofull       ) ,
    //
    .osop      ( osop        ) ,
    .oeop      ( oeop        ) ,
    .oval      ( oval        ) ,
    .odat      ( odat        ) ,
    .otag      ( sink__otag  )
  );

  assign sink__irtag                    = {irdecfail, irerr, irNiter, irtag};

  assign {odecfail, oerr, oNiter, otag} = sink__otag;

endmodule
