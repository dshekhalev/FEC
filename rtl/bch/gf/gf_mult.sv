/*



  parameter int m      = 1 ;
  parameter int irrpol = 1 ;



  logic [m-1 : 0] gf_mult__idat_a ;
  logic [m-1 : 0] gf_mult__idat_b ;
  //
  logic [m-1 : 0] gf_mult__odat   ;



  gf_mult
  #(
    .m      ( m      ) ,
    .irrpol ( irrpol )
  )
  gf_mult
  (
    .idat_a ( gf_mult__idat_a ) ,
    .idat_b ( gf_mult__idat_b ) ,
    //
    .odat   ( gf_mult__odat   )
  );


  assign gf_mult__idat_a = '0 ;
  assign gf_mult__idat_b = '0 ;



*/

//
// Project       : galua fields
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_mult.sv
// Description   : gf multiplier to use it independed from other project
//

module gf_mult
(
  idat_a ,
  idat_b ,
  //
  odat
);

  `include "gf_parameters.svh"
  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic [m-1 : 0] idat_a ;
  input  logic [m-1 : 0] idat_b ;
  //
  output logic [m-1 : 0] odat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign odat = gf_mult_a_by_b(idat_a, idat_b, irrpol);

endmodule
