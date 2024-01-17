/*



  parameter int m      = 1 ;
  parameter int irrpol = 1 ;



  logic [m-1 : 0] gf_mult_const__idat_a ;
  logic [m-1 : 0] gf_mult_const__iconst ;
  //
  logic [m-1 : 0] gf_mult_const__odat   ;



  gf_mult_const
  #(
    .m      ( m      ) ,
    .irrpol ( irrpol )
  )
  gf_mult_const
  (
    .idat_a ( gf_mult_const__idat_a ) ,
    .iconst ( gf_mult_const__iconst ) ,
    //
    .odat   ( gf_mult_const__odat   )
  );


  assign gf_mult_const__idat_a = '0 ;
  assign gf_mult_const__iconst = '0 ;



*/

//
// Project       : galua fields
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_mult_const.sv
// Description   : gf constant multiplier to use it independed from other project
//

module gf_mult_const
(
  idat_a ,
  iconst ,
  //
  odat
);

  `include "gf_parameters.svh"
  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic [m-1 : 0] idat_a ;
  input  logic [m-1 : 0] iconst ;
  //
  output logic [m-1 : 0] odat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign odat = gf_mult_a_by_b_const(idat_a, iconst, irrpol);

endmodule
