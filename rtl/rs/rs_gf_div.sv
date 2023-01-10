/*



  parameter int m       =   8 ;
  parameter int irrpol  = 285 ;



  logic           rs_gf_div__iclk     ;
  logic           rs_gf_div__ireset   ;
  logic           rs_gf_div__iclkena  ;
  logic           rs_gf_div__iena     ;
  logic [m-1 : 0] rs_gf_div__idat_a   ;
  logic [m-1 : 0] rs_gf_div__idat_d   ;
  logic [m-1 : 0] rs_gf_div__odat     ;



  rs_gf_div
  #(
    .m      ( m      ) ,
    .irrpol ( irrpol )
  )
  rs_gf_div
  (
    .iclk    ( rs_gf_div__iclk    ) ,
    .ireset  ( rs_gf_div__ireset  ) ,
    .iclkena ( rs_gf_div__iclkena ) ,
    .iena    ( rs_gf_div__iena    ) ,
    .idat_a  ( rs_gf_div__idat_a  ) ,
    .idat_d  ( rs_gf_div__idat_d  ) ,
    .odat    ( rs_gf_div__odat    )
  );


  assign rs_gf_div__iclk    = '0 ;
  assign rs_gf_div__ireset  = '0 ;
  assign rs_gf_div__iclkena = '0 ;
  assign rs_gf_div__iena    = '0 ;
  assign rs_gf_div__idat_a  = '0 ;
  assign rs_gf_div__idat_d  = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_gf_div.sv
// Description   : galua filed GF(2^m) rom based divider, module delay is 3 tick
//



module rs_gf_div
(
  iclk    ,
  ireset  ,
  iclkena ,
  iena    ,
  idat_a  ,
  idat_d  ,
  odat
);

  `include "rs_parameters.svh"
  `include "rs_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk     ;
  input  logic           ireset   ;
  input  logic           iclkena  ;
  input  logic           iena     ;
  input  logic [m-1 : 0] idat_a   ;
  input  logic [m-1 : 0] idat_d   ;
  output logic [m-1 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  data_t dat2mult_a_r0;
  data_t dat2mult_b_r0;

  data_t dat2mult_a;
  data_t dat2mult_b;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin
    dat2mult_a_r0 = '0;
    dat2mult_b_r0 = '0;

    dat2mult_a    = '0;
    dat2mult_b    = '0;
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

`ifdef MODEL_TECH
  rom_t ALPHA_TO_INV_ALPHA;

  always_comb begin
    rom_t ALPHA_TO  ;
    rom_t INDEX_OF  ;

    ALPHA_TO            = generate_gf_alpha_to_power(irrpol);
    INDEX_OF            = generate_gf_index_of_alpha(ALPHA_TO);
    ALPHA_TO_INV_ALPHA  = generate_gf_alpha_to_inv_alpha  (INDEX_OF, ALPHA_TO);
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dat2mult_a_r0 <= idat_a;
      dat2mult_b_r0 <= ALPHA_TO_INV_ALPHA[idat_d];
      //
      dat2mult_a    <= dat2mult_a_r0 ;
      dat2mult_b    <= dat2mult_b_r0 ;
    end
  end
`else
  always_ff @(posedge iclk) begin
    rom_t ALPHA_TO  ;
    rom_t INDEX_OF  ;
    rom_t ALPHA_TO_INV_ALPHA;

    ALPHA_TO            = generate_gf_alpha_to_power(irrpol);
    INDEX_OF            = generate_gf_index_of_alpha(ALPHA_TO);
    ALPHA_TO_INV_ALPHA  = generate_gf_alpha_to_inv_alpha  (INDEX_OF, ALPHA_TO);

    if (iclkena) begin
      dat2mult_a_r0 <= idat_a;
      dat2mult_b_r0 <= ALPHA_TO_INV_ALPHA[idat_d];
      //
      dat2mult_a    <= dat2mult_a_r0 ;
      dat2mult_b    <= dat2mult_b_r0 ;
    end
  end
`endif

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      odat <= gf_mult_a_by_b(dat2mult_a, dat2mult_b);
    end
  end

endmodule
