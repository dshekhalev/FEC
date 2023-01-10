/*



  parameter int n         = 255 ;
  parameter int check     =  30 ;
  parameter int m         =   8 ;
  parameter int irrpol    = 285 ;
  parameter int genstart  =   0 ;
  parameter int rootspace =   1 ;



  logic           rs_enc__iclk     ;
  logic           rs_enc__iclkena  ;
  logic           rs_enc__ireset   ;
  logic           rs_enc__isop     ;
  logic           rs_enc__ival     ;
  logic           rs_enc__ieop     ;
  logic           rs_enc__ieof     ;
  logic [m-1 : 0] rs_enc__idat     ;
  logic           rs_enc__osop     ;
  logic           rs_enc__oval     ;
  logic           rs_enc__oeop     ;
  logic [m-1 : 0] rs_enc__odat     ;



  rs_enc
  #(
    .n          ( n         ) ,
    .check      ( check     ) ,
    .m          ( m         ) ,
    .irrpol     ( irrpol    ) ,
    .genstart   ( genstart  ) ,
    .rootspace  ( rootspace )
  )
  rs_enc
  (
    .iclk    ( rs_enc__iclk    ) ,
    .iclkena ( rs_enc__iclkena ) ,
    .ireset  ( rs_enc__ireset  ) ,
    .isop    ( rs_enc__isop    ) ,
    .ival    ( rs_enc__ival    ) ,
    .ieop    ( rs_enc__ieop    ) ,
    .ieof    ( rs_enc__ieof    ) ,
    .idat    ( rs_enc__idat    ) ,
    .osop    ( rs_enc__osop    ) ,
    .oval    ( rs_enc__oval    ) ,
    .oeop    ( rs_enc__oeop    ) ,
    .odat    ( rs_enc__odat    )
  );


  assign rs_enc__iclk    = '0 ;
  assign rs_enc__iclkena = '0 ;
  assign rs_enc__ireset  = '0 ;
  assign rs_enc__isop    = '0 ;
  assign rs_enc__ival    = '0 ;
  assign rs_enc__ieop    = '0 ;
  assign rs_enc__ieof    = '0 ;
  assign rs_enc__idat    = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_enc.sv
// Description   : rs encoder top module
//



module rs_enc
(
  iclk    ,
  iclkena ,
  ireset  ,
  isop    ,
  ival    ,
  ieop    ,
  ieof    ,
  idat    ,
  osop    ,
  oval    ,
  oeop    ,
  odat
);

  `include "rs_parameters.svh"
  `include "rs_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk     ;
  input  logic           iclkena  ;
  input  logic           ireset   ;
  //
  input  logic           isop     ;
  input  logic           ival     ;
  input  logic           ieop     ;
  input  logic           ieof     ;
  input  logic [m-1 : 0] idat     ;
  //
  output logic           osop     ;
  output logic           oval     ;
  output logic           oeop     ;
  output logic [m-1 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  gpoly_t GPOLY;

  data_t  dat2mult;

  gpoly_t state;
  gpoly_t state_next;

  logic   data_n_code;

  //------------------------------------------------------------------------------------------------------
  // generator poly
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    rom_t ALPHA_TO  ;
    rom_t INDEX_OF  ;

    ALPHA_TO  = generate_gf_alpha_to_power(irrpol);
    INDEX_OF  = generate_gf_index_of_alpha(ALPHA_TO);

    GPOLY     = generate_pol_coeficients (genstart, rootspace, check, INDEX_OF, ALPHA_TO);
  end


  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osop  <= '0;
      oval  <= '0;
      oeop  <= '0;
      odat  <= '0;
      state <= clear_gpoly(0);
    end
    else if (iclkena) begin
      oval <= ival;
      osop <= isop;
      oeop <= ieof;
      if (ival) begin
        // simple FSM
        if (isop)
          data_n_code <= 1'b1;
        else if (ieop)
          data_n_code <= 1'b0;
        //
        odat  <= (isop | data_n_code) ? idat : state[1];  // remember about GPOLY inversion
        state <= state_next;
      end
    end
  end

  assign dat2mult = (isop | data_n_code) ? (idat ^ state[1]) : '0;

  //------------------------------------------------------------------------------------------------------
  // gf multiply
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int i = 1; i <= check; i++) begin
      if (i == check) begin
        state_next[i] = gf_mult_a_by_b_const(dat2mult, GPOLY[i]);
      end
      else begin
        state_next[i] = gf_mult_a_by_b_const(dat2mult, GPOLY[i]) ^ state[i+1]; // shift right (!!!) remember about GPOLY inversion
      end
    end
  end

endmodule
