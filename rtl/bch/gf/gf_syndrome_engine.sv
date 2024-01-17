/*



  parameter int m      = 1 ;
  parameter int irrpol = 1 ;
  //
  parameter int pDAT_W = 8 ;



  logic                gf_syndrome_engine__isop      ;
  logic [pDAT_W-1 : 0] gf_syndrome_engine__idat      ;
  logic [pDAT_W-1 : 0] gf_syndrome_engine__idat_mask ;
  logic      [m-1 : 0] gf_syndrome_engine__ialpha    ;
  logic      [m-1 : 0] gf_syndrome_engine__isyndrome ;
  logic      [m-1 : 0] gf_syndrome_engine__osyndrome ;



  gf_syndrome_engine
  #(
    .m      ( m      ) ,
    .irrpol ( irrpol ) ,
    //
    .pDAT_W ( pDAT_W )
  )
  gf_syndrome_engine
  (
    .isop      ( gf_syndrome_engine__isop      ) ,
    .idat      ( gf_syndrome_engine__idat      ) ,
    .idat_mask ( gf_syndrome_engine__idat_mask ) ,
    .ialpha    ( gf_syndrome_engine__ialpha    ) ,
    .isyndrome ( gf_syndrome_engine__isyndrome ) ,
    .osyndrome ( gf_syndrome_engine__osyndrome )
  );


  assign gf_syndrome_engine__isop      = '0 ;
  assign gf_syndrome_engine__idat      = '0 ;
  assign gf_syndrome_engine__idat_mask = '0 ;
  assign gf_syndrome_engine__ialpha    = '0 ;
  assign gf_syndrome_engine__isyndrome = '0 ;



*/

//
// Project       : galua fields
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_syndrome_engine.sv
// Description   : Galua field syndrome counter logic for multibit words (!!! LSB first !!!) to use it independed from other project
//

module gf_syndrome_engine
(
  isop      ,
  idat      ,
  idat_mask ,
  ialpha    ,
  isyndrome ,
  osyndrome
);

  parameter int pDAT_W = 8;

  `include "gf_parameters.svh"
  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                isop      ;
  input  logic [pDAT_W-1 : 0] idat      ;
  input  logic [pDAT_W-1 : 0] idat_mask ;
  input  logic      [m-1 : 0] ialpha    ;
  input  logic      [m-1 : 0] isyndrome ;
  output logic      [m-1 : 0] osyndrome ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    osyndrome = isyndrome;
    for (int b = 0; b < pDAT_W; b++) begin
      if ((b == 0) & isop) begin
        osyndrome = {{{m-1}{1'b0}}, idat[b]};
      end
      else begin
        if (idat_mask[b]) begin // for codes with fractional part
          osyndrome = {{{m-1}{1'b0}}, idat[b]} ^ gf_mult_a_by_b_const(osyndrome, ialpha);
        end
      end
    end
  end

endmodule
