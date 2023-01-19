/*


  logic         rsc2_sctable__iclk     ;
  logic         rsc2_sctable__ireset   ;
  logic         rsc2_sctable__iclkena  ;
  logic [3 : 0] rsc2_sctable__iNmod15  ;
  logic [3 : 0] rsc2_sctable__istate   ;
  logic [3 : 0] rsc2_sctable__ostate   ;
  logic [3 : 0] rsc2_sctable__ostate_r ;



  rsc2_sctable
  rsc2_sctable
  (
    .iclk     ( rsc2_sctable__iclk     ) ,
    .ireset   ( rsc2_sctable__ireset   ) ,
    .iclkena  ( rsc2_sctable__iclkena  ) ,
    .iNmod15  ( rsc2_sctable__iNmod15  ) ,
    .istate   ( rsc2_sctable__istate   ) ,
    .ostate   ( rsc2_sctable__ostate   ) ,
    .ostate_r ( rsc2_sctable__ostate_r )
  );


  assign rsc2_sctable__iclk    = '0 ;
  assign rsc2_sctable__ireset  = '0 ;
  assign rsc2_sctable__iclkena = '0 ;
  assign rsc2_sctable__iNmod15 = '0 ;
  assign rsc2_sctable__istate  = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_sctable.sv
// Description   : Circullar state correspondence table. Its static table for different packet lengths
//                 Module can use asynchronus or register output for correspondence state
//

module rsc2_sctable
(
  iclk     ,
  ireset   ,
  iclkena  ,
  iNmod15  ,
  istate   ,
  ostate   ,
  ostate_r
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk     ;
  input  logic         ireset   ;
  input  logic         iclkena  ;
  input  logic [3 : 0] iNmod15  ;
  input  logic [3 : 0] istate   ;
  output logic [3 : 0] ostate   ;
  output logic [3 : 0] ostate_r ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef bit [3 : 0] lut_line_t  [0 : 15];
  typedef lut_line_t  lut_t       [0 : 15];

  localparam lut_t cLUT = '{
    '{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0} , // 0
    '{0, 14,  3, 13,  7,  9,  4, 10, 15,  1, 12,  2,  8,  6, 11,  5} , // 1
    '{0, 11, 13,  6, 10,  1,  7, 12,  5, 14,  8,  3, 15,  4,  2,  9} , // 2
    '{0,  8,  9,  1,  2, 10, 11,  3,  4, 12, 13,  5,  6, 14, 15,  7} , // 3
    '{0,  3,  4,  7,  8, 11, 12, 15,  1,  2,  5,  6,  9, 10, 13, 14} , // 4
    '{0, 12,  5,  9, 11,  7, 14,  2,  6, 10,  3, 15, 13,  1,  8,  4} , // 5
    '{0,  4, 12,  8,  9, 13,  5,  1,  2,  6, 14, 10, 11, 15,  7,  3} , // 6
    '{0,  6, 10, 12,  5,  3, 15,  9, 11, 13,  1,  7, 14,  8,  4,  2} , // 7
    '{0,  7,  8, 15,  1,  6,  9, 14,  3,  4, 11, 12,  2,  5, 10, 13} , // 8
    '{0,  5, 14, 11, 13,  8,  3,  6, 10, 15,  4,  1,  7,  2,  9, 12} , // 9
    '{0, 13,  7, 10, 15,  2,  8,  5, 14,  3,  9,  4,  1, 12,  6, 11} , // 10
    '{0,  2,  6,  4, 12, 14, 10,  8,  9, 11, 15, 13,  5,  7,  3,  1} , // 11
    '{0,  9, 11,  2,  6, 15, 13,  4, 12,  5,  7, 14, 10,  3,  1,  8} , // 12
    '{0, 10, 15,  5, 14,  4,  1, 11, 13,  7,  2,  8,  3,  9, 12,  6} , // 13
    '{0, 15,  1, 14,  3, 12,  2, 13,  7,  8,  6,  9,  4, 11,  5, 10} , // 14
    '{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0}   // 15
  };

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ostate = cLUT[iNmod15][istate];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostate_r <= ostate;
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

endmodule
