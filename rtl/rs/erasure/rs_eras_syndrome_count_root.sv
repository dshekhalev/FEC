/*



  parameter int n         = 240 ;
  parameter int check     =  30 ;
  parameter int m         =   8 ;
  parameter int irrpol    = 285 ;
  parameter int genstart  =   0 ;
  parameter int rootspace =   0 ;



  logic   rs_eras_syndrome_count_root__iclk                     ;
  logic   rs_eras_syndrome_count_root__iclkena                  ;
  logic   rs_eras_syndrome_count_root__ireset                   ;
  logic   rs_eras_syndrome_count_root__isop                     ;
  logic   rs_eras_syndrome_count_root__ival                     ;
  logic   rs_eras_syndrome_count_root__ieop                     ;
  data_t  rs_eras_syndrome_count_root__idat                     ;
  logic   rs_eras_syndrome_count_root__ieras                    ;
  data_t  rs_eras_syndrome_count_root__oram_addr                ;
  ptr_t   rs_eras_syndrome_count_root__oram_ptr                 ;
  data_t  rs_eras_syndrome_count_root__oram_data                ;
  logic   rs_eras_syndrome_count_root__oram_write               ;
  logic   rs_eras_syndrome_count_root__osyndrome_val            ;
  ptr_t   rs_eras_syndrome_count_root__osyndrome_ptr            ;
  data_t  rs_eras_syndrome_count_root__osyndrome    [1 : check] ;
  data_t  rs_eras_syndrome_count_root__oeras_root   [1 : check] ;
  data_t  rs_eras_syndrome_count_root__oeras_num                ;



  rs_eras_syndrome_count_root
  #(
    .n         ( n         ) ,
    .check     ( check     ) ,
    .m         ( m         ) ,
    .irrpol    ( irrpol    ) ,
    .genstart  ( genstart  ) ,
    .rootspace ( rootspace )
  )
  rs_eras_syndrome_count_root
  (
    .iclk          ( rs_eras_syndrome_count_root__iclk          ) ,
    .iclkena       ( rs_eras_syndrome_count_root__iclkena       ) ,
    .ireset        ( rs_eras_syndrome_count_root__ireset        ) ,
    .isop          ( rs_eras_syndrome_count_root__isop          ) ,
    .ival          ( rs_eras_syndrome_count_root__ival          ) ,
    .ieop          ( rs_eras_syndrome_count_root__ieop          ) ,
    .idat          ( rs_eras_syndrome_count_root__idat          ) ,
    .ieras         ( rs_eras_syndrome_count_root__ieras         ) ,
    .oram_addr     ( rs_eras_syndrome_count_root__oram_addr     ) ,
    .oram_ptr      ( rs_eras_syndrome_count_root__oram_ptr      ) ,
    .oram_data     ( rs_eras_syndrome_count_root__oram_data     ) ,
    .oram_write    ( rs_eras_syndrome_count_root__oram_write    ) ,
    .osyndrome_val ( rs_eras_syndrome_count_root__osyndrome_val ) ,
    .osyndrome_ptr ( rs_eras_syndrome_count_root__osyndrome_ptr ) ,
    .osyndrome     ( rs_eras_syndrome_count_root__osyndrome     ) ,
    .oeras_root    ( rs_eras_syndrome_count_root__oeras_root    ) ,
    .oeras_num     ( rs_eras_syndrome_count_root__oeras_num     )
  );


  assign rs_eras_syndrome_count_root__iclk    = '0 ;
  assign rs_eras_syndrome_count_root__iclkena = '0 ;
  assign rs_eras_syndrome_count_root__ireset  = '0 ;
  assign rs_eras_syndrome_count_root__isop    = '0 ;
  assign rs_eras_syndrome_count_root__ival    = '0 ;
  assign rs_eras_syndrome_count_root__ieop    = '0 ;
  assign rs_eras_syndrome_count_root__idat    = '0 ;
  assign rs_eras_syndrome_count_root__ieras   = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_eras_syndrome_count_root.sv
// Description   : rs syndrome with erasure roots count module
//



module rs_eras_syndrome_count_root
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
  oeras_root    ,
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
  output data_t  oeras_root   [1 : check] ;
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
  // erasure roots count logic
  //------------------------------------------------------------------------------------------------------

  data_t eras_state;
  data_t eras_state_next;

  assign eras_state_next = isop ? FIRST_ROOT_POS : gf_mult_a_by_b_const(eras_state, ROOTSPACE_INV);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        eras_state <= isop ? FIRST_ROOT_POS : eras_state_next;
        //
        for (int i = 1; i <= check; i++) begin
          if (isop) begin
            oeras_root[i] <= (i == 1) ? (ieras ?  eras_state_next : '0) : '0;
          end
          else if (ieras) begin
            oeras_root[i] <= (i == 1) ?           eras_state_next       : oeras_root[i-1];
          end
        end // for
        //
        if (isop) begin
          oeras_num <= {{m-1{1'b0}}, ieras};
        end
        else if (ieras) begin
          oeras_num <= oeras_num + 1'b1;
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
