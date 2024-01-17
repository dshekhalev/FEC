/*



  parameter int m      = 1 ;
  parameter int irrpol = 1 ;
  parameter int n      = 1 ;



  logic [m-1 : 0] gf_alpha__odat [n] ;



  gf_alpha
  #(
    .m      ( m      ) ,
    .irrpol ( irrpol ) ,
    .n      ( n      )
  )
  gf_alpha
  (
    .odat ( gf_alpha__odat )
  );





*/

//
// Project       : galua fields
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_alpha.sv
// Description   : gf alpha table generation unit to use it independed from other project
//

module gf_alpha
(
  odat
);

  parameter int n = 2;

  `include "gf_parameters.svh"
  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  output logic [m-1 : 0] odat [n] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  rom_t ALPHA_TO;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    ALPHA_TO = generate_gf_alpha_to_power(irrpol);
    //
    for (int i = 0; i < n; i++) begin
      odat[i] = ALPHA_TO[i];
    end
  end

endmodule
