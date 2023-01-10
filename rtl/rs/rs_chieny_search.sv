/*

  parameter int n          = 240 ;
  parameter int check      =  30 ;
  parameter int m          =   8 ;
  parameter int irrpol     = 285 ;
  parameter int genstart   =   0 ;
  parameter int rootspace  =   1 ;
  parameter int sym_err_w  =   m ;
  parameter int bit_err_w  =   m ;
  parameter bit pRIBM_MODE =   0 ;




  logic     rs_chieny_search__iclk                     ;
  logic     rs_chieny_search__iclkena                  ;
  logic     rs_chieny_search__ireset                   ;
  logic     rs_chieny_search__iloc_poly_val            ;
  data_t    rs_chieny_search__iloc_poly     [0 : errs] ;
  data_t    rs_chieny_search__iomega_poly   [1 : errs] ;
  logic     rs_chieny_search__iloc_decfail             ;
  ptr_t     rs_chieny_search__iloc_poly_ptr            ;
  data_t    rs_chieny_search__iram_data                ;
  data_t    rs_chieny_search__oram_addr                ;
  ptr_t     rs_chieny_search__oram_ptr                 ;
  logic     rs_chieny_search__oram_read                ;
  logic     rs_chieny_search__osop                     ;
  logic     rs_chieny_search__oval                     ;
  logic     rs_chieny_search__oeop                     ;
  logic     rs_chieny_search__oeof                     ;
  data_t    rs_chieny_search__odat                     ;
  logic     rs_chieny_search__odecfail                 ;
  sym_err_t rs_chieny_search__onum_err_sym             ;
  bit_err_t rs_chieny_search__onum_err_bit             ;



  rs_chieny_search
  #(
    .n          ( n          ) ,
    .check      ( check      ) ,
    .m          ( m          ) ,
    .irrpol     ( irrpol     ) ,
    .genstart   ( genstart   ) ,
    .rootspace  ( rootspace  ) ,
    .sym_err_w  ( sym_err_w  ) ,
    .bit_err_w  ( bit_err_w  ) ,
    .pRIBM_MODE ( pRIBM_MODE )
  )
  rs_chieny_search
  (
    .iclk          ( rs_chieny_search__iclk          ) ,
    .iclkena       ( rs_chieny_search__iclkena       ) ,
    .ireset        ( rs_chieny_search__ireset        ) ,
    .iloc_poly_val ( rs_chieny_search__iloc_poly_val ) ,
    .iloc_poly     ( rs_chieny_search__iloc_poly     ) ,
    .iomega_poly   ( rs_chieny_search__iomega_poly   ) ,
    .iloc_decfail  ( rs_chieny_search__iloc_decfail  ) ,
    .iloc_poly_ptr ( rs_chieny_search__iloc_poly_ptr ) ,
    .iram_data     ( rs_chieny_search__iram_data     ) ,
    .oram_addr     ( rs_chieny_search__oram_addr     ) ,
    .oram_ptr      ( rs_chieny_search__oram_ptr      ) ,
    .oram_read     ( rs_chieny_search__oram_read     ) ,
    .osop          ( rs_chieny_search__osop          ) ,
    .oval          ( rs_chieny_search__oval          ) ,
    .oeop          ( rs_chieny_search__oeop          ) ,
    .oeof          ( rs_chieny_search__oeof          ) ,
    .odat          ( rs_chieny_search__odat          ) ,
    .odecfail      ( rs_chieny_search__odecfail      ) ,
    .onum_err_sym  ( rs_chieny_search__onum_err_sym  ) ,
    .onum_err_bit  ( rs_chieny_search__onum_err_bit  )
  );


  assign rs_chieny_search__iclk          = '0 ;
  assign rs_chieny_search__iclkena       = '0 ;
  assign rs_chieny_search__ireset        = '0 ;
  assign rs_chieny_search__iloc_poly_val = '0 ;
  assign rs_chieny_search__iloc_poly     = '0 ;
  assign rs_chieny_search__iomega_poly   = '0 ;
  assign rs_chieny_search__iloc_decfail  = '0 ;
  assign rs_chieny_search__iloc_poly_ptr = '0 ;
  assign rs_chieny_search__iram_data     = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_chieny_search.sv
// Description   : rs chieny search algorithm module
//

`include "define.vh"

module rs_chieny_search
(
  iclk          ,
  iclkena       ,
  ireset        ,
  iloc_poly_val ,
  iloc_poly     ,
  iomega_poly   ,
  iloc_decfail  ,
  iloc_poly_ptr ,
  iram_data     ,
  oram_addr     ,
  oram_ptr      ,
  oram_read     ,
  osop          ,
  oval          ,
  oeop          ,
  oeof          ,
  odat          ,
  odecfail      ,
  onum_err_sym  ,
  onum_err_bit
);

  `include "rs_parameters.svh"
  `include "rs_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic     iclk                     ;
  input  logic     iclkena                  ;
  input  logic     ireset                   ;
  //
  input  logic     iloc_poly_val            ;
  input  data_t    iloc_poly     [0 : errs] ; // error locator  polynome
  input  data_t    iomega_poly   [1 : errs] ; // error value    polynome
  input  logic     iloc_decfail             ;
  input  ptr_t     iloc_poly_ptr            ;
  //
  input  data_t    iram_data                ;
  output data_t    oram_addr                ;
  output ptr_t     oram_ptr                 ;
  output logic     oram_read                ;
  //
  output logic     osop                     ;
  output logic     oval                     ;
  output logic     oeop                     ;
  output logic     oeof                     ;
  output data_t    odat                     ;
  //
  output logic     odecfail                 ;
  output sym_err_t onum_err_sym             ;
  output bit_err_t onum_err_bit             ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  rom_t ALPHA_TO;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    ALPHA_TO = generate_gf_alpha_to_power(irrpol);
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic   start_search  ;
  logic   enable_search ;

  data_t  cnt;
  logic   cnt_is_one;
  logic   cnt_is_max;

  logic [4 : 0] search_val;
  logic [4 : 0] search_sop;
  logic [4 : 0] search_eop;
  logic [4 : 0] search_eof;
  //
  //
  data_t  loc_mult    [0 : errs];
  data_t  omega_mult  [0 : errs-1]; // do for more

  data_t  drv_loc_value;
  data_t  drv_loc_value_next;

  data_t  loc_value;
  data_t  loc_value_next;
  logic   loc_value_is_zero;
  logic   loc_value_is_zero_r0;
  logic   loc_value_is_zero_r1;

  data_t  omega_value;
  data_t  omega_value_next;

  data_t  err_mult;
  data_t  err_mult_value;

  logic   div__iena  ;
  data_t  div__idat_a;
  data_t  div__idat_d;
  data_t  div__odat  ;

  //
  //
  data_t data_fixed;
  data_t ram_rdata;
  data_t ram_rdata_r0;

  data_t    sym_err;
  sym_err_t sym_err_cnt;

  logic     sym_err_occured;

  data_t    bit_err;
  bit_err_t bit_err_cnt;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin : ini
    enable_search = '0;
    cnt           = '0;
    cnt_is_one    = '0;
    cnt_is_max    = '0;
    //
    search_val    = '0;
    search_sop    = '0;
    search_eop    = '0;
    search_eof    = '0;
    //
    oval          = '0;
    osop          = '0;
    oeop          = '0;
    odat          = '0;
    //
    loc_mult            = '{default : 0};
    drv_loc_value       = '0;

    loc_value             = '0;
    loc_value_is_zero_r0  = '0;
    loc_value_is_zero_r1  = '0;

    omega_mult          = '{default : 0};
    omega_value         = '0;
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  // ctrl FSM
  //------------------------------------------------------------------------------------------------------

  wire   ready2search = ~enable_search | (enable_search & cnt_is_one);
  assign start_search = ready2search & iloc_poly_val;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      enable_search <= 1'b0;
      //
      cnt           <= '0;
      cnt_is_max    <= 1'b0;
      cnt_is_one    <= 1'b0;
      //
      search_val    <= '0;
      search_sop    <= '0;
      search_eop    <= '0;
      search_eof    <= '0;
    end
    else if (iclkena) begin
      // Chieny use one simple state
      if (start_search) begin
        enable_search <= 1'b1;
      end
      else if (cnt_is_one) begin
        enable_search <= 1'b0;
      end
      //
      cnt_is_max  <= start_search;
      cnt_is_one  <= (cnt == 2);
      //
      if (start_search) begin
        cnt <= n;       // easy way for shorten codes
      end
      else if (enable_search) begin
        cnt <= cnt - 1'b1;
      end
      // control reg lines
      search_val <= (search_val << 1) |  enable_search ;
      search_sop <= (search_sop << 1) | (enable_search &  cnt_is_max   );
      search_eop <= (search_eop << 1) | (enable_search & (cnt == check + 1));
      search_eof <= (search_eof << 1) | (enable_search &  cnt_is_one   );
    end
  end

  //------------------------------------------------------------------------------------------------------
  // capture state of locator polynomes for statistic
  //------------------------------------------------------------------------------------------------------

  logic [errs : 1] loc_nzero;
  sym_err_t        loc_poly_deg;

  logic loc_decfail_latched;
  logic loc_decfail;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin // tick
        loc_decfail_latched <= iloc_decfail;
        for (int i = 1; i <= errs; i++) begin
          loc_nzero[i] <= (iloc_poly[i] != 0);
        end
      end
      if (enable_search & cnt_is_one) begin // tack
        loc_decfail   <= loc_decfail_latched;
        loc_poly_deg  <= loc_deg(loc_nzero);
      end
    end
  end

  function automatic sym_err_t loc_deg (input logic [errs : 1] vector);
    loc_deg = 0;
    for (int i = 1; i <= errs; i++) begin
      if (vector[i]) begin
        loc_deg = i;
      end
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // addres generator
  //------------------------------------------------------------------------------------------------------

  assign oram_read = 1'b1;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        oram_ptr <= iloc_poly_ptr;
      end
      //
      if (start_search) begin
        oram_addr <= '0;
      end
      else if (enable_search) begin
        oram_addr <= oram_addr + 1'b1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // errol locator gf_mult
  //------------------------------------------------------------------------------------------------------

  // function to count mult forward root for shorten codes
  function automatic data_t start_root_index(input int step);
    start_root_index = (step*rootspace*(gf_n_max - n + 1)) % gf_n_max;
  endfunction

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      //
      if (start_search) begin
        loc_mult[0] <= iloc_poly[0];
        for (int i = 1; i <= errs; i++) begin
          loc_mult[i] <= gf_mult_a_by_b_const(iloc_poly[i], ALPHA_TO[start_root_index(i)]);
        end
      end
      else if (enable_search) begin
        for (int i = 1; i <= errs; i++) begin
          loc_mult[i] <= gf_mult_a_by_b_const(loc_mult[i], ALPHA_TO[(i*rootspace) % gf_n_max]);
        end
      end // enable_search
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // error value gf_mult
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        omega_mult[0] <= iomega_poly[1];
        for (int i = 1; i < errs; i++) begin
          omega_mult[i] <= gf_mult_a_by_b_const(iomega_poly[i+1], ALPHA_TO[start_root_index(i)]);
        end
      end
      else if (enable_search) begin
        for (int i = 1; i < errs; i++) begin
          omega_mult[i] <= gf_mult_a_by_b_const(omega_mult[i], ALPHA_TO[(i*rootspace) % gf_n_max]);
        end
      end // enable_search
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // error mult
  //------------------------------------------------------------------------------------------------------

  parameter bit pRIBM_MODE = 1'b0;

  localparam data_t ERR_MULT_LOAD_BY  = (((genstart + pRIBM_MODE*check)*rootspace)*(gf_n_max - n + 1)) % gf_n_max;
  localparam data_t ERR_MULT_BY       =  ((genstart + pRIBM_MODE*check)*rootspace) % gf_n_max;

  generate
    if (ERR_MULT_BY != 0) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (start_search) begin
            err_mult <= gf_mult_a_by_b_const(ALPHA_TO[0], ALPHA_TO[ERR_MULT_LOAD_BY]);
          end
          else if (enable_search) begin
            err_mult <= gf_mult_a_by_b_const(err_mult,  ALPHA_TO[ERR_MULT_BY]);
          end
          //
          if (enable_search) begin
            err_mult_value <= err_mult;
          end
        end // iclkena
      end // always_ff
    end //
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // error locator & value logic
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int i = 0; i <= errs; i++) begin
      loc_value_next = (i == 0) ? loc_mult[i] : (loc_value_next ^ loc_mult[i]);
    end
    for (int i = 1; i <= ((errs >> 1) + errs[0]); i++) begin
      drv_loc_value_next = (i == 1) ? loc_mult[i] : (drv_loc_value_next ^ loc_mult[2*i-1]);
    end
    for (int i = 0; i < errs; i++) begin
      omega_value_next = (i == 0) ? omega_mult[i] : (omega_value_next ^ omega_mult[i]);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (enable_search) begin
        loc_value       <= loc_value_next;
        drv_loc_value   <= drv_loc_value_next;
        omega_value     <= omega_value_next;
      end
      // +3 tick for gf_div delay align
      if (search_val[0]) begin
        loc_value_is_zero_r1  <= (loc_value == 0);
      end
      if (search_val[1]) begin
        loc_value_is_zero_r0  <= loc_value_is_zero_r1;
      end
      if (search_val[2]) begin
        loc_value_is_zero     <= loc_value_is_zero_r0;
      end
    end
  end

  rs_gf_div
  #(
    .m      ( m      ) ,  // 3 tick delay
    .irrpol ( irrpol )
  )
  div
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    .iena    ( div__iena   ) ,
    .idat_a  ( div__idat_a ) ,
    .idat_d  ( div__idat_d ) ,
    .odat    ( div__odat   )
  );

  assign div__iena        = 1'b1;
  generate
    if (ERR_MULT_BY != 0)
      assign div__idat_a  = gf_mult_a_by_b(omega_value, err_mult_value);  // rs_gf_div have register at this path
    else
      assign div__idat_a  = omega_value;
  endgenerate
  assign div__idat_d      = drv_loc_value ;

  assign sym_err          = loc_value_is_zero ? div__odat : '0;
  assign sym_err_occured  = loc_value_is_zero;
  assign bit_err          = count_bit_num(sym_err);

  //------------------------------------------------------------------------------------------------------
  // error correction & statistic counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (search_val[1]) begin  // ram have read latency == 2
        ram_rdata_r0 <= iram_data;
      end
      if (search_val[2]) begin
        ram_rdata     <= ram_rdata_r0; // align rs_gf_div delay
      end
      //
      if (search_val[3]) begin
        data_fixed  <= ram_rdata ^ sym_err;
        sym_err_cnt <= search_sop[3] ? sym_err_occured : (sym_err_cnt + sym_err_occured);
        bit_err_cnt <= search_sop[3] ? bit_err         : (bit_err_cnt + bit_err);
      end
      //
      osop <= search_sop  [4];
      oval <= search_val  [4];
      oeop <= search_eop  [4];
      oeof <= search_eof  [4];
      if (search_val[4]) begin
        odat <= data_fixed;
      end
      if (search_eof[4]) begin
        odecfail      <= (sym_err_cnt != loc_poly_deg) | loc_decfail;
        onum_err_sym  <=  sym_err_cnt;
        onum_err_bit  <=  bit_err_cnt;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // useful function
  //------------------------------------------------------------------------------------------------------

  function automatic data_t count_bit_num (input data_t error);
    count_bit_num = 0;
    for (int i = 0; i < m; i++) begin
      count_bit_num += error[i];
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // logout function
  //------------------------------------------------------------------------------------------------------
`ifdef __RS_CHIENY_DEBUG_LOG__
  // synthesis translate_off
  data_t cnt_delay [0 : 3];
  data_t pos[$];
  data_t err[$];

  always_ff @(posedge iclk) begin
    string str,s;
    //
    if (iclkena) begin
      if (start_search) begin
        $sformat(str, "%m chieny get error locator poly : ");
        foreach (iloc_poly[i]) begin
          $sformat(s, " %d", iloc_poly[i]);
          str = {str, s};
        end
        $display(str);
        //
        $sformat(str, "%m chieny get error value poly : ");
        foreach (iomega_poly[i]) begin
          $sformat(s, " %d", iomega_poly[i]);
          str = {str, s};
        end
        $display(str);
      end
      //
      {cnt_delay[3], cnt_delay[2], cnt_delay[1], cnt_delay[0]} <= {cnt_delay[2], cnt_delay[1], cnt_delay[0] ,cnt};
      if (search_val[3]) begin
        if (search_sop[3]) begin
          pos.delete();
          err.delete();
        end
        if (loc_value_is_zero) begin
          pos.push_back(cnt_delay[3]);
          err.push_back(sym_err);
        end
        if (search_eof[3]) begin
          foreach (pos[i]) begin
            $display("%m chieny step %0d :: loc_value is zero, error %h", n - pos[i], err[i]);
          end
        end // search eof
      end // search val
    end // iclkena
  end
  // synthesis translate_on
`endif

endmodule
