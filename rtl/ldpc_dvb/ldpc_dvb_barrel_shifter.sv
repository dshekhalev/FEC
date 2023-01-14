/*



  parameter int pW         = 8 ;
  parameter int pSHIFT_W   = 8 ;
  parameter bit pR_SHIFT   = 0 ;
  parameter int pPIPE_LINE = 8 ;



  logic                  ldpc_dvb_barrel_shifter__iclk    ;
  logic                  ldpc_dvb_barrel_shifter__ireset  ;
  logic                  ldpc_dvb_barrel_shifter__iclkena ;
  //
  logic                  ldpc_dvb_barrel_shifter__ival    ;
  logic       [pW-1 : 0] ldpc_dvb_barrel_shifter__idat    ;
  logic [pSHIFT_W-1 : 0] ldpc_dvb_barrel_shifter__ishift  ;
  //
  logic                  ldpc_dvb_barrel_shifter__oval    ;
  logic       [pW-1 : 0] ldpc_dvb_barrel_shifter__odat    ;



  ldpc_dvb_barrel_shifter
  #(
    .pW         ( pW         ) ,
    .pSHIFT_W   ( pSHIFT_W   ) ,
    .pR_SHIFT   ( pR_SHIFT   ) ,
    .pPIPE_LINE ( pPIPE_LINE )
  )
  ldpc_dvb_barrel_shifter
  (
    .iclk    ( ldpc_dvb_barrel_shifter__iclk    ) ,
    .ireset  ( ldpc_dvb_barrel_shifter__ireset  ) ,
    .iclkena ( ldpc_dvb_barrel_shifter__iclkena ) ,
    //
    .ival    ( ldpc_dvb_barrel_shifter__ival    ) ,
    .idat    ( ldpc_dvb_barrel_shifter__idat    ) ,
    .ishift  ( ldpc_dvb_barrel_shifter__ishift  ) ,
    //
    .oval    ( ldpc_dvb_barrel_shifter__oval    ) ,
    .odat    ( ldpc_dvb_barrel_shifter__odat    )
  );


  assign ldpc_dvb_barrel_shifter__iclk    = '0 ;
  assign ldpc_dvb_barrel_shifter__ireset  = '0 ;
  assign ldpc_dvb_barrel_shifter__iclkena = '0 ;
  assign ldpc_dvb_barrel_shifter__ival    = '0 ;
  assign ldpc_dvb_barrel_shifter__idat    = '0 ;
  assign ldpc_dvb_barrel_shifter__ishift  = '0 ;



*/

//
// Project       : ldpc DVB-S
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_barrel_shifter.sv
// Description   : wide bit barrel shifter
//

module ldpc_dvb_barrel_shifter
#(
  parameter int pW                          =            360 ,  // don't change
  parameter int pSHIFT_W                    = $clog2(pW + 1) ,
  //
  parameter bit pR_SHIFT                    =              0 ,  // shift direction
  //
  parameter bit [pSHIFT_W-1 : 0] pPIPE_LINE =              1    // shift edge pipeline
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  idat    ,
  ishift  ,
  //
  oval    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk    ;
  input  logic                  ireset  ;
  input  logic                  iclkena ;
  //
  input  logic                  ival    ;
  input  logic       [pW-1 : 0] idat    ;
  input  logic [pSHIFT_W-1 : 0] ishift  ;
  //
  output logic                  oval    ;
  output logic       [pW-1 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                  shifter__ival    ;
  logic     [2*pW-1 : 0] shifter__idat    ;
  logic [pSHIFT_W-1 : 0] shifter__ishift  ;
  //
  logic                  shifter__oval    ;
  logic     [2*pW-1 : 0] shifter__odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_wide_shifter
  #(
    .pW         ( 2*pW       ) ,
    .pSHIFT_W   ( pSHIFT_W   ) ,
    .pR_SHIFT   ( pR_SHIFT   ) ,
    .pPIPE_LINE ( pPIPE_LINE )
  )
  shifter
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .ival    ( shifter__ival    ) ,
    .idat    ( shifter__idat    ) ,
    .ishift  ( shifter__ishift  ) ,
    //
    .oval    ( shifter__oval    ) ,
    .odat    ( shifter__odat    )
  );

  assign shifter__ival   = ival;
  assign shifter__idat   = {idat, idat};
  assign shifter__ishift = ishift;

  assign oval = shifter__oval;
  assign odat = pR_SHIFT ? shifter__odat[0 +: pW] : shifter__odat[pW +: pW];

endmodule
