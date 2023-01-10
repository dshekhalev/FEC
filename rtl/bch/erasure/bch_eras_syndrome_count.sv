/*


  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;



  logic   bch_eras_syndrome_count__iclk                     ;
  logic   bch_eras_syndrome_count__ireset                   ;
  logic   bch_eras_syndrome_count__iclkena                  ;
  logic   bch_eras_syndrome_count__isop                     ;
  logic   bch_eras_syndrome_count__ival                     ;
  logic   bch_eras_syndrome_count__ieop                     ;
  logic   bch_eras_syndrome_count__ieras                    ;
  logic   bch_eras_syndrome_count__idat                     ;
  data_t  bch_eras_syndrome_count__oram_addr                ;
  ptr_t   bch_eras_syndrome_count__oram_ptr                 ;
  logic   bch_eras_syndrome_count__oram_data                ;
  logic   bch_eras_syndrome_count__oram_eras                ;
  logic   bch_eras_syndrome_count__oram_write               ;
  logic   bch_eras_syndrome_count__osyndrome_val            ;
  ptr_t   bch_eras_syndrome_count__osyndrome_ptr            ;
  data_t  bch_eras_syndrome_count__osyndrome    [2][1 : t2] ;



  bch_eras_syndrome_count
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  bch_eras_syndrome_count
  (
    .iclk          ( bch_eras_syndrome_count__iclk          ) ,
    .ireset        ( bch_eras_syndrome_count__ireset        ) ,
    .iclkena       ( bch_eras_syndrome_count__iclkena       ) ,
    .isop          ( bch_eras_syndrome_count__isop          ) ,
    .ival          ( bch_eras_syndrome_count__ival          ) ,
    .ieop          ( bch_eras_syndrome_count__ieop          ) ,
    .ieras         ( bch_eras_syndrome_count__ieras         ) ,
    .idat          ( bch_eras_syndrome_count__idat          ) ,
    .oram_addr     ( bch_eras_syndrome_count__oram_addr     ) ,
    .oram_ptr      ( bch_eras_syndrome_count__oram_ptr      ) ,
    .oram_data     ( bch_eras_syndrome_count__oram_data     ) ,
    .oram_eras     ( bch_eras_syndrome_count__oram_eras     ) ,
    .oram_write    ( bch_eras_syndrome_count__oram_write    ) ,
    .osyndrome_val ( bch_eras_syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( bch_eras_syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( bch_eras_syndrome_count__osyndrome     )
  );


  assign bch_eras_syndrome_count__iclk     = '0 ;
  assign bch_eras_syndrome_count__ireset   = '0 ;
  assign bch_eras_syndrome_count__iclkena  = '0 ;
  assign bch_eras_syndrome_count__isop     = '0 ;
  assign bch_eras_syndrome_count__ival     = '0 ;
  assign bch_eras_syndrome_count__ieop     = '0 ;
  assign bch_eras_syndrome_count__ieras    = '0 ;
  assign bch_eras_syndrome_count__idat     = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_eras_syndrome_count.sv
// Description   : bch erasure syndrome count module
//


module bch_eras_syndrome_count
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  isop          ,
  ival          ,
  ieop          ,
  ieras         ,
  idat          ,
  //
  oram_addr     ,
  oram_ptr      ,
  oram_data     ,
  oram_eras     ,
  oram_write    ,
  //
  osyndrome_val ,
  osyndrome_ptr ,
  osyndrome
);

  `include "bch_parameters.svh"
  `include "bch_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk                       ;
  input  logic   ireset                     ;
  input  logic   iclkena                    ;
  //
  input  logic   isop                       ;
  input  logic   ival                       ;
  input  logic   ieop                       ;
  input  logic   ieras                      ;
  input  logic   idat                       ;
  //
  output data_t  oram_addr                  ;
  output ptr_t   oram_ptr                   ;
  output logic   oram_data                  ;
  output logic   oram_eras                  ;
  output logic   oram_write                 ;
  //
  output logic   osyndrome_val              ;
  output ptr_t   osyndrome_ptr              ;
  output data_t  osyndrome      [2][1 : t2] ;  // eras 0/1 syndromes

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  rom_t ALPHA_TO;

  always_comb begin
    ALPHA_TO = generate_gf_alpha_to_power(irrpol);
  end

  eras_num_t  eras_cnt;
  logic       eras_enable;

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
        if (isop) begin
          eras_cnt      <= ieras;
          eras_enable   <= 1'b1;
          for (int i = 1; i <= t2; i++) begin
            for (int s = 0; s < 2; s++) begin
              osyndrome[s][i] <= {{{m-1}{1'b0}}, ieras ? s[0] : idat} ;
            end
          end
        end
        else begin
          eras_cnt <= eras_cnt + (ieras & eras_enable);
          if ((eras_cnt == t2-1) & ieras) begin
            eras_enable <= 1'b0;
          end
          for (int i = 1; i <= t2; i++) begin
            for (int s = 0; s < 2; s++) begin
              osyndrome[s][i] <= {{{m-1}{1'b0}}, (ieras & eras_enable) ? s[0] : idat} ^ gf_mult_a_by_b_const(osyndrome[s][i], ALPHA_TO[i]);
            end
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
    end
    else if (iclkena) begin
      oram_write  <= ival;
      if (ival) begin
        oram_ptr  <= oram_ptr + isop; // update pointer at start of frame, to easy align it with one tick delay
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        oram_data <= idat;
        oram_eras <= isop ? ieras : (ieras & eras_enable);
        oram_addr <= isop ? '0    : (oram_addr + 1'b1) ;
      end
    end
  end

  assign osyndrome_ptr = oram_ptr; // becouse osyndrome_val occured then the last word is writing to the ram

endmodule
