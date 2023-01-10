/*


  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;



  logic   bch_chieny_search__iclk                  ;
  logic   bch_chieny_search__ireset                ;
  logic   bch_chieny_search__iclkena               ;
  logic   bch_chieny_search__iloc_poly_val         ;
  data_t  bch_chieny_search__iloc_poly     [0 : t] ;
  ptr_t   bch_chieny_search__iloc_poly_ptr         ;
  logic   bch_chieny_search__iloc_decfail          ;
  logic   bch_chieny_search__iram_data             ;
  data_t  bch_chieny_search__oram_addr             ;
  logic   bch_chieny_search__oram_ptr              ;
  logic   bch_chieny_search__oram_read             ;
  logic   bch_chieny_search__owaddr                ;
  logic   bch_chieny_search__owptr                 ;
  logic   bch_chieny_search__odat_nfixed           ;
  logic   bch_chieny_search__osop                  ;
  logic   bch_chieny_search__oval                  ;
  logic   bch_chieny_search__oeop                  ;
  logic   bch_chieny_search__oeof                  ;
  logic   bch_chieny_search__odat                  ;
  logic   bch_chieny_search__odecfail              ;
  data_t  bch_chieny_search__obiterr               ;



  bch_chieny_search
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  bch_chieny_search
  (
    .iclk          ( bch_chieny_search__iclk          ) ,
    .ireset        ( bch_chieny_search__ireset        ) ,
    .iclkena       ( bch_chieny_search__iclkena       ) ,
    .iloc_poly_val ( bch_chieny_search__iloc_poly_val ) ,
    .iloc_poly     ( bch_chieny_search__iloc_poly     ) ,
    .iloc_ptr      ( bch_chieny_search__iloc_ptr      ) ,
    .iloc_decfail  ( bch_chieny_search__iloc_decfail  ) ,
    .iram_data     ( bch_chieny_search__iram_data     ) ,
    .oram_addr     ( bch_chieny_search__oram_addr     ) ,
    .oram_ptr      ( bch_chieny_search__oram_ptr      ) ,
    .oram_read     ( bch_chieny_search__oram_read     ) ,
    .owaddr        ( bch_chieny_search__owaddr        ) ,
    .owptr         ( bch_chieny_search__owptr         ) ,
    .odat_nfixed   ( bch_chieny_search__odat_nfixed   ) ,
    .osop          ( bch_chieny_search__osop          ) ,
    .oval          ( bch_chieny_search__oval          ) ,
    .oeop          ( bch_chieny_search__oeop          ) ,
    .oeof          ( bch_chieny_search__oeof          ) ,
    .odat          ( bch_chieny_search__odat          ) ,
    .odecfail      ( bch_chieny_search__odecfail      ) ,
    .obiterr       ( bch_chieny_search__obiterr       )
  );


  assign bch_chieny_search__iclk          = '0 ;
  assign bch_chieny_search__ireset        = '0 ;
  assign bch_chieny_search__iclkena       = '0 ;
  assign bch_chieny_search__iloc_poly_val = '0 ;
  assign bch_chieny_search__iloc_poly     = '0 ;
  assign bch_chieny_search__iloc_decfail  = '0 ;
  assign bch_chieny_search__iram_data     = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_chieny_search.sv
// Description   : bch chieny search algorithm module
//


module bch_chieny_search
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  iloc_poly_val ,
  iloc_poly     ,
  iloc_poly_ptr ,
  iloc_decfail  ,
  //
  iram_data     ,
  oram_addr     ,
  oram_ptr      ,
  oram_read     ,
  //
  owaddr        ,
  owptr         ,
  odat_nfixed   ,
  //
  osop          ,
  oval          ,
  oeop          ,
  oeof          ,
  odat          ,
  odecfail      ,
  obiterr
);

  `include "bch_parameters.svh"
  `include "bch_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk                  ;
  input  logic  ireset                ;
  input  logic  iclkena               ;
  //
  input  logic  iloc_poly_val         ;
  input  data_t iloc_poly     [0 : t] ;
  input  ptr_t  iloc_poly_ptr         ;
  input  logic  iloc_decfail          ;
  // ram interface
  input  logic  iram_data             ;
  output data_t oram_addr             ;
  output ptr_t  oram_ptr              ;
  output logic  oram_read             ;
  // output interface
  output data_t owaddr                ;
  output ptr_t  owptr                 ;
  output logic  odat_nfixed           ;
  //
  output logic  osop                  ;
  output logic  oval                  ;
  output logic  oeop                  ;
  output logic  oeof                  ;
  output logic  odat                  ;
  output logic  odecfail              ;
  output data_t obiterr               ;

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

  logic   start_search ;
  logic   enable_search;

  data_t  cnt;
  logic   cnt_is_0;
  logic   cnt_is_k;
  logic   cnt_is_n;
  //
  logic   [2 : 0] search_val;
  logic   [2 : 0] search_sop;
  logic   [2 : 0] search_eop;
  logic   [2 : 0] search_eof;
  //
  data_t  loc_mult  [0 : t];

  data_t  loc_value;
  data_t  loc_value_next;
  logic   loc_value_is_zero;

  data_t  bit_err_cnt;

  logic   dat_fixed;
  logic   dat_nfixed;
  logic   ram_rdata;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin : ini
    enable_search     = '0;
    cnt               = '0;
    cnt_is_0          = '0;
    cnt_is_n          = '0;
    cnt_is_k          = '0;
    //
    search_val        = '0;
    search_sop        = '0;
    search_eop        = '0;
    search_eof        = '0;
    //
    oval              = '0;
    osop              = '0;
    oeop              = '0;
    odat              = '0;
    //
    loc_mult          = '{default : 0};
    loc_value         = '0;
    loc_value_is_zero = '0;
    //
    owptr             = '0;
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  // chieny search FSM
  //------------------------------------------------------------------------------------------------------

  wire   ready2search = ~enable_search | (enable_search & cnt_is_n);
  assign start_search = ready2search & iloc_poly_val;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      enable_search <= 1'b0;
      //
      cnt           <= '0;
      cnt_is_0      <= 1'b0;
      cnt_is_n      <= 1'b0;
      cnt_is_k      <= 1'b0;
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
      else if (cnt_is_n) begin
        enable_search <= 1'b0;
      end
      //
      cnt_is_0  <= start_search;
      cnt_is_k  <= (cnt == k-2);
      cnt_is_n  <= (cnt == n-2);
      //
      if (start_search) begin
        cnt <= '0;
      end
      else if (enable_search) begin
        cnt <= cnt + 1'b1;
      end
      // control reg lines
      search_val  <= (search_val << 1) | enable_search;
      search_sop  <= (search_sop << 1) | (cnt_is_0 & enable_search);
      search_eop  <= (search_eop << 1) | (cnt_is_k & enable_search);
      search_eof  <= (search_eof << 1) | (cnt_is_n & enable_search);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram controls
  //------------------------------------------------------------------------------------------------------

  assign oram_addr = cnt;
  assign oram_read = 1'b1;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        oram_ptr <= iloc_poly_ptr;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // capture state of locator polynomes for statistic
  //------------------------------------------------------------------------------------------------------

  logic  [t : 1] loc_nzero;
  data_t         loc_poly_deg;

  logic loc_decfail_latched;
  logic loc_decfail;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin // tick
        loc_decfail_latched <= iloc_decfail;
        for (int i = 1; i <= t; i++) begin
          loc_nzero[i] <= (iloc_poly[i] != 0);
        end
      end
      if (enable_search & cnt_is_n) begin // tack
        loc_decfail   <= loc_decfail_latched;
        loc_poly_deg  <= loc_deg(loc_nzero);
      end
    end
  end

  function automatic data_t loc_deg (input logic [t : 1] vector);
    loc_deg = 0;
    for (int i = 1; i <= t; i++) begin
      if (vector[i]) begin
        loc_deg = i;
      end
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // errol locator gf_mult
  //------------------------------------------------------------------------------------------------------

  // function to count mult forward root for shorten codes
  function automatic data_t start_root_index(input int step);
    start_root_index = (step*(gf_n_max - n + 1)) % gf_n_max;
  endfunction

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      //
      if (start_search) begin
        loc_mult[0] <= iloc_poly[0];
        for (int i = 1; i <= t; i++) begin
          loc_mult[i] <= gf_mult_a_by_b_const(iloc_poly[i], ALPHA_TO[start_root_index(i)]);
        end
      end
      else if (enable_search) begin
        for (int i = 1; i <= t; i++) begin
          loc_mult[i] <= gf_mult_a_by_b_const(loc_mult[i], ALPHA_TO[i]);
        end
      end // enable_search
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // locator value logic
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int i = 0; i <= t; i++) begin
      loc_value_next = (i == 0) ? loc_mult[i] : (loc_value_next ^ loc_mult[i]);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (enable_search) begin
        loc_value <= loc_value_next;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // error correction & statistic counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      //
      if (search_val[0]) begin // ram have read latency == 1
        ram_rdata         <= iram_data;
        loc_value_is_zero <= (loc_value == 0);
      end
      //
      if (search_val[1]) begin
        dat_fixed   <= ram_rdata ^ loc_value_is_zero; // root is poly == 0 -> invert this error
        dat_nfixed  <= ram_rdata;
        bit_err_cnt <= search_sop[1] ? loc_value_is_zero : (bit_err_cnt + loc_value_is_zero);
      end
      //
      osop <= search_sop [2];
      oval <= search_val [2];
      oeop <= search_eop [2];
      oeof <= search_eof [2];

      if (search_val[2]) begin
        odat        <= dat_fixed;
        odat_nfixed <= dat_nfixed;
      end
      //
      if (search_eof[2]) begin
        odecfail <= (bit_err_cnt != loc_poly_deg) | loc_decfail_latched;
        obiterr  <= bit_err_cnt;
      end
      //
      if (search_sop[2]) begin
        owaddr <= '0;
        owptr  <= owptr + 1'b1;
      end
      else if (search_val[2]) begin
        owaddr <= owaddr + 1'b1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // logout function
  //------------------------------------------------------------------------------------------------------
`ifdef __BCH_CHIENY_DEBUG_LOG__
  // synthesis translate_off
  data_t cnt_delay [0 : 1];
  data_t pos[$];

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
      end
      //
      {cnt_delay[1], cnt_delay[0]} <= {cnt_delay[0] ,cnt};
      if (search_val[1]) begin
        if (search_sop[1]) begin
          pos.delete();
        end
        if (loc_value_is_zero) begin
          pos.push_back(cnt_delay[1]);
        end
        if (search_eof[1]) begin
          foreach (pos[i]) begin
            $display("%m chieny step %0d :: loc_value is zero", pos[i]);
          end
        end // search eof
      end // search val
    end // iclkena
  end
  // synthesis translate_on
`endif
endmodule
