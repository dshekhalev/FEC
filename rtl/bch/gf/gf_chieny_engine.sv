/*



  parameter int m      = 1 ;
  parameter int irrpol = 1 ;
  parameter int n      = 1 ;
  parameter int t      = 1 ;
  //
  parameter int pDAT_W = 1 ;



  logic           gf_chieny_engine__isop             ;
  logic [m-1 : 0] gf_chieny_engine__iloc_poly    [t] ;
  logic [m-1 : 0] gf_chieny_engine__ialpha_start [t] ;
  //
  logic [m-1 : 0] gf_chieny_engine__iloc_mult    [t] ;
  logic [m-1 : 0] gf_chieny_engine__ialpha       [t] ;
  //
  logic [m-1 : 0] gf_chieny_engine__oloc_mult    [t] ;



  gf_chieny_engine
  #(
    .m      ( m      ) ,
    .irrpol ( irrpol ) ,
    .n      ( n      ) ,
    .t      ( t      ) ,
    //
    .pDAT_W ( pDAT_W )
  )
  gf_chieny_engine
  (
    .isop         ( gf_chieny_engine__isop         ) ,
    .iloc_poly    ( gf_chieny_engine__iloc_poly    ) ,
    .ialpha_start ( gf_chieny_engine__ialpha_start ) ,
    //
    .iloc_mult    ( gf_chieny_engine__iloc_mult    ) ,
    .ialpha       ( gf_chieny_engine__ialpha       ) ,
    //
    .oloc_mult    ( gf_chieny_engine__oloc_mult    )
  );


  assign gf_chieny_engine__isop         = '0 ;
  assign gf_chieny_engine__iloc_poly    = '0 ;
  assign gf_chieny_engine__ialpha_start = '0 ;
  assign gf_chieny_engine__iloc_mult    = '0 ;
  assign gf_chieny_engine__ialpha       = '0 ;



*/

//
// Project       : galua fields
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_chieny_engine.sv
// Description   : Galua field cnieny locator counters logic for multibit words (!!! LSB first !!!) to use it independed from other project
//

module gf_chieny_engine
(
  isop         ,
  iloc_poly    ,
  ialpha_start ,
  //
  iloc_mult    ,
  ialpha       ,
  //
  oloc_mult
);

  parameter int pDAT_W = 8;
  parameter int t      = 2;

  `include "gf_parameters.svh"
  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           isop                         ;
  input  logic [m-1 : 0] iloc_poly    [0 : t]         ;
  input  logic [m-1 : 0] ialpha_start [1 : t]         ;
  //
  input  logic [m-1 : 0] iloc_mult    [0 : t][pDAT_W] ;
  input  logic [m-1 : 0] ialpha       [1 : t]         ;
  //
  output logic [m-1 : 0] oloc_mult    [0 : t][pDAT_W] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [m-1 : 0] tmp_loc_mult [pDAT_W];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    if (isop) begin
      oloc_mult [0] = '{default : iloc_poly[0]};
    end
    else begin
      oloc_mult [0] = iloc_mult[0]; // comb loop
    end
    //
    for (int i = 1; i <= t; i++) begin
      if (isop) begin
        tmp_loc_mult[0] = gf_mult_a_by_b(iloc_poly[i],    ialpha_start[i]);
      end
      else begin
        tmp_loc_mult[0] = gf_mult_a_by_b_const(iloc_mult[i][pDAT_W-1], ialpha[i]);
      end
      //
      for (int b = 1; b < pDAT_W; b++) begin
        tmp_loc_mult[b] = gf_mult_a_by_b_const(tmp_loc_mult[b-1], ialpha[i]);
      end
      //
      oloc_mult[i] = tmp_loc_mult;
    end
  end

endmodule
