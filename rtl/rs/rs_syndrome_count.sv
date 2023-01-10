/*



  parameter int n         = 240 ;
  parameter int check     =  30 ;
  parameter int m         =   8 ;
  parameter int irrpol    = 285 ;
  parameter int genstart  =   0 ;
  parameter int rootspace =   0 ;



  logic   rs_syndrome_count__iclk                     ;
  logic   rs_syndrome_count__iclkena                  ;
  logic   rs_syndrome_count__ireset                   ;
  logic   rs_syndrome_count__isop                     ;
  logic   rs_syndrome_count__ival                     ;
  logic   rs_syndrome_count__ieop                     ;
  data_t  rs_syndrome_count__idat                     ;
  data_t  rs_syndrome_count__oram_addr                ;
  ptr_t   rs_syndrome_count__oram_ptr                 ;
  data_t  rs_syndrome_count__oram_data                ;
  logic   rs_syndrome_count__oram_write               ;
  logic   rs_syndrome_count__osyndrome_val            ;
  ptr_t   rs_syndrome_count__osyndrome_ptr            ;
  data_t  rs_syndrome_count__osyndrome    [1 : check] ;



  rs_syndrome_count
  #(
    .n         ( n         ) ,
    .check     ( check     ) ,
    .m         ( m         ) ,
    .irrpol    ( irrpol    ) ,
    .genstart  ( genstart  ) ,
    .rootspace ( rootspace )
  )
  rs_syndrome_count
  (
    .iclk          ( rs_syndrome_count__iclk          ) ,
    .iclkena       ( rs_syndrome_count__iclkena       ) ,
    .ireset        ( rs_syndrome_count__ireset        ) ,
    .isop          ( rs_syndrome_count__isop          ) ,
    .ival          ( rs_syndrome_count__ival          ) ,
    .ieop          ( rs_syndrome_count__ieop          ) ,
    .idat          ( rs_syndrome_count__idat          ) ,
    .oram_addr     ( rs_syndrome_count__oram_addr     ) ,
    .oram_ptr      ( rs_syndrome_count__oram_ptr      ) ,
    .oram_data     ( rs_syndrome_count__oram_data     ) ,
    .oram_write    ( rs_syndrome_count__oram_write    ) ,
    .osyndrome_val ( rs_syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( rs_syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( rs_syndrome_count__osyndrome     )
  );


  assign rs_syndrome_count__iclk    = '0 ;
  assign rs_syndrome_count__iclkena = '0 ;
  assign rs_syndrome_count__ireset  = '0 ;
  assign rs_syndrome_count__isop    = '0 ;
  assign rs_syndrome_count__ival    = '0 ;
  assign rs_syndrome_count__ieop    = '0 ;
  assign rs_syndrome_count__idat    = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_syndrome_count.sv
// Description   : rs syndrome count module
//



module rs_syndrome_count
(
  iclk          ,
  iclkena       ,
  ireset        ,
  //
  isop          ,
  ival          ,
  ieop          ,
  idat          ,
  //
  oram_addr     ,
  oram_ptr      ,
  oram_data     ,
  oram_write    ,
  //
  osyndrome_val ,
  osyndrome_ptr ,
  osyndrome
);

  `include "rs_parameters.svh"
  `include "rs_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk                     ;
  input  logic   iclkena                  ;
  input  logic   ireset                   ;
  //
  input  logic   isop                     ;
  input  logic   ival                     ;
  input  logic   ieop                     ;
  input  data_t  idat                     ;
  //
  output data_t  oram_addr                ;
  output ptr_t   oram_ptr                 ;
  output data_t  oram_data                ;
  output logic   oram_write               ;
  //
  output logic   osyndrome_val            ;
  output ptr_t   osyndrome_ptr            ;
  output data_t  osyndrome    [1 : check] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  rom_t ALPHA_TO;

  always_comb begin
    ALPHA_TO = generate_gf_alpha_to_power(irrpol);
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osyndrome_val <= 1'b0;
    end
    else if (iclkena) begin
      osyndrome_val <= ival & ieop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        for (int i = 1; i <= check; i++) begin
          osyndrome[i] <= isop ? idat : (idat ^ gf_mult_a_by_b_const(osyndrome[i], ALPHA_TO[((genstart + i-1) * rootspace) % gf_n_max]));
        end
      end // ival
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // ram buffer write logic
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oram_write  <= '0;
      oram_ptr    <= '0;
      oram_data   <= '0;
      oram_addr   <= '0;
    end
    else if (iclkena) begin
      oram_write  <= ival;
      if (ival) begin
        oram_data <= idat;
        oram_addr <= isop ? '0 : (oram_addr + 1'b1) ;
        oram_ptr  <= oram_ptr + isop; // update pointer at start of frame, to easy align it with one tick delay
      end
    end
  end

  assign osyndrome_ptr = oram_ptr; // becouse osyndrome_val occured then the last word is writing to the ram

endmodule
