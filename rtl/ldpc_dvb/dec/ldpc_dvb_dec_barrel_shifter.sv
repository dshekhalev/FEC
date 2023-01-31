/*



  parameter bit pR_SHIFT   = 0 ;
  parameter int pPIPE_LINE = 8 ;



  logic   ldpc_dvb_dec_barrel_shifter__iclk    ;
  logic   ldpc_dvb_dec_barrel_shifter__ireset  ;
  logic   ldpc_dvb_dec_barrel_shifter__iclkena ;
  //
  logic   ldpc_dvb_dec_barrel_shifter__ival    ;
  znode_t ldpc_dvb_dec_barrel_shifter__idat    ;
  shift_t ldpc_dvb_dec_barrel_shifter__ishift  ;
  //
  logic   ldpc_dvb_dec_barrel_shifter__oval    ;
  znode_t ldpc_dvb_dec_barrel_shifter__odat    ;



  ldpc_dvb_dec_barrel_shifter
  #(
    .pLLR_W     ( pLLR_W     ) ,
    .pNODE_W    ( pNODE_W    ) ,
    .pR_SHIFT   ( pR_SHIFT   ) ,
    .pPIPE_LINE ( pPIPE_LINE )
  )
  ldpc_dvb_dec_barrel_shifter
  (
    .iclk    ( ldpc_dvb_dec_barrel_shifter__iclk    ) ,
    .ireset  ( ldpc_dvb_dec_barrel_shifter__ireset  ) ,
    .iclkena ( ldpc_dvb_dec_barrel_shifter__iclkena ) ,
    //
    .ival    ( ldpc_dvb_dec_barrel_shifter__ival    ) ,
    .idat    ( ldpc_dvb_dec_barrel_shifter__idat    ) ,
    .ishift  ( ldpc_dvb_dec_barrel_shifter__ishift  ) ,
    //
    .oval    ( ldpc_dvb_dec_barrel_shifter__oval    ) ,
    .odat    ( ldpc_dvb_dec_barrel_shifter__odat    )
  );


  assign ldpc_dvb_dec_barrel_shifter__iclk    = '0 ;
  assign ldpc_dvb_dec_barrel_shifter__ireset  = '0 ;
  assign ldpc_dvb_dec_barrel_shifter__iclkena = '0 ;
  assign ldpc_dvb_dec_barrel_shifter__ival    = '0 ;
  assign ldpc_dvb_dec_barrel_shifter__idat    = '0 ;
  assign ldpc_dvb_dec_barrel_shifter__ishift  = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_barrel_shifter.sv
// Description   : wide word barrel shifter
//

module ldpc_dvb_dec_barrel_shifter
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

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  parameter bit pR_SHIFT                        =  0 ; // shift direction
  //
  parameter bit [cLOG2_ZC_MAX-1 : 0] pPIPE_LINE =  1 ; // shift edge pipeline

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk    ;
  input  logic   ireset  ;
  input  logic   iclkena ;
  //
  input  logic   ival    ;
  input  znode_t idat    ;
  input  shift_t ishift  ;
  //
  output logic   oval    ;
  output znode_t odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                 shifter__ival             ;
  logic [cZC_MAX-1 : 0] shifter__idat  [pNODE_W]  ;
  shift_t               shifter__ishift           ;
  //
  logic                 shifter__oval  [pNODE_W]  ;
  logic [cZC_MAX-1 : 0] shifter__odat  [pNODE_W]  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < pNODE_W; g++) begin : bit_shift_gen
      ldpc_dvb_barrel_shifter
      #(
        .pW         ( cZC_MAX      ) ,
        .pSHIFT_W   ( cLOG2_ZC_MAX ) ,
        .pR_SHIFT   ( pR_SHIFT     ) ,
        .pPIPE_LINE ( pPIPE_LINE   )
      )
      shifter
      (
        .iclk    ( iclk                ) ,
        .ireset  ( ireset              ) ,
        .iclkena ( iclkena             ) ,
        //
        .ival    ( shifter__ival       ) ,
        .idat    ( shifter__idat   [g] ) ,
        .ishift  ( shifter__ishift     ) ,
        //
        .oval    ( shifter__oval   [g] ) ,
        .odat    ( shifter__odat   [g] )
      );
    end
  endgenerate

  assign shifter__ival   = ival;
  assign shifter__ishift = ishift;

  assign oval            = shifter__oval[0];

  always_comb begin
    for (int b = 0; b < pNODE_W; b++) begin
      for (int z = 0; z < cZC_MAX; z++) begin
        shifter__idat[b][z] = idat[z][b];
        //
        odat[z][b]          = shifter__odat[b][z];
      end
    end
  end

endmodule
