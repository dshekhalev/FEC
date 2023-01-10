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
  logic   rs_syndrome_count__ieras                    ;
  data_t  rs_syndrome_count__oram_addr                ;
  ptr_t   rs_syndrome_count__oram_ptr                 ;
  data_t  rs_syndrome_count__oram_data                ;
  logic   rs_syndrome_count__oram_write               ;
  logic   rs_syndrome_count__osyndrome_val            ;
  ptr_t   rs_syndrome_count__osyndrome_ptr            ;
  data_t  rs_syndrome_count__osyndrome    [1 : check] ;
  data_t  rs_syndrome_count__oeras_poly   [1 : check] ;
  data_t  rs_syndrome_count__oeras_num                ;



  rs_eras_syndrome_count_poly
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
    .ieras         ( rs_syndrome_count__ieras         ) ,
    .oram_addr     ( rs_syndrome_count__oram_addr     ) ,
    .oram_ptr      ( rs_syndrome_count__oram_ptr      ) ,
    .oram_data     ( rs_syndrome_count__oram_data     ) ,
    .oram_write    ( rs_syndrome_count__oram_write    ) ,
    .osyndrome_val ( rs_syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( rs_syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( rs_syndrome_count__osyndrome     ) ,
    .oeras_poly    ( rs_syndrome_count__oeras_poly    ) ,
    .oeras_num     ( rs_syndrome_count__oeras_num     )
  );


  assign rs_syndrome_count__iclk    = '0 ;
  assign rs_syndrome_count__iclkena = '0 ;
  assign rs_syndrome_count__ireset  = '0 ;
  assign rs_syndrome_count__isop    = '0 ;
  assign rs_syndrome_count__ival    = '0 ;
  assign rs_syndrome_count__ieop    = '0 ;
  assign rs_syndrome_count__idat    = '0 ;
  assign rs_syndrome_count__ieras   = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_syndrome_count.sv
// Description   : rs syndrome with erasures poly count module
//



module rs_eras_syndrome_count_poly
(
  iclk          ,
  iclkena       ,
  ireset        ,
  //
  isop          ,
  ival          ,
  ieop          ,
  idat          ,
  ieras         ,
  //
  oram_addr     ,
  oram_ptr      ,
  oram_data     ,
  oram_write    ,
  //
  osyndrome_val ,
  osyndrome_ptr ,
  osyndrome     ,
  oeras_poly    ,
  oeras_num
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
  input  logic   ieras                    ;
  //
  output data_t  oram_addr                ;
  output ptr_t   oram_ptr                 ;
  output data_t  oram_data                ;
  output logic   oram_write               ;
  //
  output logic   osyndrome_val            ;
  output ptr_t   osyndrome_ptr            ;
  output data_t  osyndrome    [1 : check] ;
  output data_t  oeras_poly   [1 : check] ;
  output data_t  oeras_num                ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  rom_t   ALPHA_TO;
  rom_t   INDEX_OF;

  data_t  FIRST_ROOT_POS;
  data_t  ROOTSPACE_INV;

  always_comb begin
    ALPHA_TO        = generate_gf_alpha_to_power(irrpol);
    INDEX_OF        = generate_gf_index_of_alpha(ALPHA_TO);

    FIRST_ROOT_POS  = ALPHA_TO[(rootspace*(n-1)) % gf_n_max];
    ROOTSPACE_INV   = gf_div(1, ALPHA_TO[rootspace], INDEX_OF, ALPHA_TO);
  end

  //------------------------------------------------------------------------------------------------------
  // syndrome count logic
  //------------------------------------------------------------------------------------------------------
/*
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osyndrome_val <= 1'b0;
    end
    else if (iclkena) begin
      osyndrome_val <= ival & ieop;
    end
  end
*/
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
  // erasure roots count logic
  //------------------------------------------------------------------------------------------------------

  logic val ;
  logic sop ;
  logic eop ;
  logic eras;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      {val, sop, eop, eras} <= '0;
      osyndrome_val         <= 1'b0;
    end
    else if (iclkena) begin
      {val, sop, eop, eras} <= {ival, isop, ieop, ieras};
      osyndrome_val         <= val & eop;
    end
  end

  data_t eras_state;
  data_t eras_state_next;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (isop) begin
          eras_state <= FIRST_ROOT_POS;
        end
        else begin
          eras_state <= gf_mult_a_by_b_const(eras_state, ROOTSPACE_INV);
        end
        //
        if (isop) begin
          oeras_num <= {{m-1{1'b0}}, ieras};
        end
        else if (ieras) begin
          oeras_num <= oeras_num + 1'b1;
        end
      end // ival
      //
      if (val) begin
        for (int i = 1; i <= check; i++) begin
          if (i == 1) begin
            if (sop) begin
              oeras_poly[i] <= {m{eras}} & eras_state;
            end
            else begin
              oeras_poly[i] <= oeras_poly[i] ^ ({m{eras}} & eras_state);
            end
          end
          else begin
            if (sop) begin
              oeras_poly[i] <= '0;
            end
            else begin
              oeras_poly[i] <= oeras_poly[i] ^ gf_mult_a_by_b(oeras_poly[i-1], {m{eras}} & eras_state);
            end
          end
        end
      end
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
