/*



  parameter int m      = 1 ;
  parameter int irrpol = 1 ;
  parameter int t      = 2 ;
  parameter int n      = 1 ;



  logic [m-1 : 0] gf_chieny_alpha_start__odat [1 : t] ;



  gf_chieny_alpha_start
  #(
    .m      ( m      ) ,
    .irrpol ( irrpol ) ,
    .t      ( t      ) ,
    .start  ( start  ) ,
    .n      ( n      )
  )
  gf_chieny_alpha_start
  (
    .odat ( gf_alpha__odat )
  );





*/

//
// Project       : galua fields
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_chieny_alpha_start.sv
// Description   : gf alpha start values for shortend codes
//

module gf_chieny_alpha_start
(
  odat
);

  parameter int t    = 2; // number of corrected errors
  parameter int step = 1; // step between roots
  parameter int n    = 2; // shortened block size

  `include "gf_parameters.svh"
  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  output logic [m-1 : 0] odat [1 : t] ;

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
    for (int i = 1; i <= t; i++) begin
      odat[i] = ALPHA_TO[start_root_index(i, n, 2**m-1)];
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function automatic int start_root_index(input int step, n, gf_n_max);
    start_root_index = (step*(gf_n_max - n + 1)) % gf_n_max;
  endfunction

endmodule
