/*


  logic          rsc_sctable__iclk     ;
  logic          rsc_sctable__ireset   ;
  logic          rsc_sctable__iclkena  ;
  logic  [2 : 0] rsc_sctable__iNmod7   ;
  logic  [2 : 0] rsc_sctable__istate   ;
  logic  [2 : 0] rsc_sctable__ostate   ;
  logic  [2 : 0] rsc_sctable__ostate_r ;



  rsc_sctable
  rsc_sctable
  (
    .iclk     ( rsc_sctable__iclk     ) ,
    .ireset   ( rsc_sctable__ireset   ) ,
    .iclkena  ( rsc_sctable__iclkena  ) ,
    .iNmod7   ( rsc_sctable__iNmod7   ) ,
    .istate   ( rsc_sctable__istate   ) ,
    .ostate   ( rsc_sctable__ostate   ) ,
    .ostate_r ( rsc_sctable__ostate_r )
  );


  assign rsc_sctable__iclk    = '0 ;
  assign rsc_sctable__ireset  = '0 ;
  assign rsc_sctable__iclkena = '0 ;
  assign rsc_sctable__iNmod7  = '0 ;
  assign rsc_sctable__istate  = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_sctable.sv
// Description   : Circullar state correspondence table. Its static table for different packet lengths 8 <= N/4 <= 1024
//                 Module can use asynchronus or register output for correspondence state
//

module rsc_sctable
(
  iclk     ,
  ireset   ,
  iclkena  ,
  iNmod7   ,
  istate   ,
  ostate   ,
  ostate_r
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk     ;
  input  logic            ireset   ;
  input  logic            iclkena  ;
  input  logic    [2 : 0] iNmod7   ;
  input  logic    [2 : 0] istate   ;
  output logic    [2 : 0] ostate   ;
  output logic    [2 : 0] ostate_r ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef bit [2 : 0] lut_line_t  [0 : 7];
  typedef lut_line_t  lut_t       [0 : 7];

  localparam lut_t cLUT = '{
    '{0, 0, 0, 0, 0, 0, 0, 0} , // 0
    '{0, 6, 4, 2, 7, 1, 3, 5} , // 1
    '{0, 3, 7, 4, 5, 6, 2, 1} , // 2
    '{0, 5, 3, 6, 2, 7, 1, 4} , // 3
    '{0, 4, 1, 5, 6, 2, 7, 3} , // 4
    '{0, 2, 5, 7, 1, 3, 4, 6} , // 5
    '{0, 7, 6, 1, 3, 4, 5, 2} , // 6
    '{0, 0, 0, 0, 0, 0, 0, 0}   // 7
  };

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ostate = cLUT[iNmod7][istate];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostate_r <= ostate;
    end
  end

endmodule
