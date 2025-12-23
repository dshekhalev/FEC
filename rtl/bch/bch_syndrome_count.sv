/*


  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;



  logic   bch_syndrome_count__iclk                  ;
  logic   bch_syndrome_count__ireset                ;
  logic   bch_syndrome_count__iclkena               ;
  logic   bch_syndrome_count__isop                  ;
  logic   bch_syndrome_count__ival                  ;
  logic   bch_syndrome_count__ieop                  ;
  logic   bch_syndrome_count__idat                  ;
  data_t  bch_syndrome_count__oram_addr             ;
  ptr_t   bch_syndrome_count__oram_ptr              ;
  logic   bch_syndrome_count__oram_data             ;
  logic   bch_syndrome_count__oram_write            ;
  logic   bch_syndrome_count__osyndrome_val         ;
  ptr_t   bch_syndrome_count__osyndrome_ptr         ;
  data_t  bch_syndrome_count__osyndrome    [1 : t2] ;



  bch_syndrome_count
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  bch_syndrome_count
  (
    .iclk          ( bch_syndrome_count__iclk          ) ,
    .ireset        ( bch_syndrome_count__ireset        ) ,
    .iclkena       ( bch_syndrome_count__iclkena       ) ,
    .isop          ( bch_syndrome_count__isop          ) ,
    .ival          ( bch_syndrome_count__ival          ) ,
    .ieop          ( bch_syndrome_count__ieop          ) ,
    .idat          ( bch_syndrome_count__idat          ) ,
    .oram_addr     ( bch_syndrome_count__oram_addr     ) ,
    .oram_ptr      ( bch_syndrome_count__oram_ptr      ) ,
    .oram_data     ( bch_syndrome_count__oram_data     ) ,
    .oram_write    ( bch_syndrome_count__oram_write    ) ,
    .osyndrome_val ( bch_syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( bch_syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( bch_syndrome_count__osyndrome     )
  );


  assign bch_syndrome_count__iclk     = '0 ;
  assign bch_syndrome_count__ireset   = '0 ;
  assign bch_syndrome_count__iclkena  = '0 ;
  assign bch_syndrome_count__isop     = '0 ;
  assign bch_syndrome_count__ival     = '0 ;
  assign bch_syndrome_count__ieop     = '0 ;
  assign bch_syndrome_count__idat     = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_syndrome_count.sv
// Description   : bch syndrome count module
//

module bch_syndrome_count
(
  iclk          ,
  ireset        ,
  iclkena       ,
  isop          ,
  ival          ,
  ieop          ,
  idat          ,
  oram_addr     ,
  oram_ptr      ,
  oram_data     ,
  oram_write    ,
  osyndrome_val ,
  osyndrome_ptr ,
  osyndrome
);

  `include "bch_parameters.svh"
  `include "bch_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk                  ;
  input  logic   ireset                ;
  input  logic   iclkena               ;
  input  logic   isop                  ;
  input  logic   ival                  ;
  input  logic   ieop                  ;
  input  logic   idat                  ;
  output data_t  oram_addr             ;
  output ptr_t   oram_ptr              ;
  output logic   oram_data             ;
  output logic   oram_write            ;
  output logic   osyndrome_val         ;
  output ptr_t   osyndrome_ptr         ;
  output data_t  osyndrome    [1 : t2] ;

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
        for (int i = 1; i <= t2; i++) begin
          if (isop) begin
            osyndrome[i] <= {{{m-1}{1'b0}}, idat};
          end
          else begin
            osyndrome[i] <= {{{m-1}{1'b0}}, idat} ^ gf_mult_a_by_b_const(osyndrome[i], ALPHA_TO[i]);
          end
        end // for
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
