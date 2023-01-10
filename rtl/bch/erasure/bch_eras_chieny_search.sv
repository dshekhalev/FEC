/*


  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;



  logic          bch_eras_chieny_search__iclk                     ;
  logic          bch_eras_chieny_search__ireset                   ;
  logic          bch_eras_chieny_search__iclkena                  ;
  logic          bch_eras_chieny_search__iloc_poly_val            ;
  ptr_t          bch_eras_chieny_search__iloc_poly_ptr            ;
  data_t         bch_eras_chieny_search__iloc_poly     [2][0 : t] ;
  logic          bch_eras_chieny_search__iram_data                ;
  logic          bch_eras_chieny_search__iram_eras                ;
  data_t         bch_eras_chieny_search__oram_addr                ;
  logic          bch_eras_chieny_search__oram_ptr                 ;
  logic          bch_eras_chieny_search__oram_read                ;
  logic          bch_eras_chieny_search__owaddr                   ;
  logic          bch_eras_chieny_search__owptr                    ;
  logic          bch_eras_chieny_search__odat_nfixed              ;
  logic          bch_eras_chieny_search__osop                     ;
  logic          bch_eras_chieny_search__oval                     ;
  logic          bch_eras_chieny_search__oeop                     ;
  logic          bch_eras_chieny_search__oeof                     ;
  logic  [1 : 0] bch_eras_chieny_search__odat                     ;
  logic  [1 : 0] bch_eras_chieny_search__odecfail                 ;
  data_t         bch_eras_chieny_search__obiterr       [2]        ;
  data_t         bch_eras_chieny_search__odecerr       [2]        ;



  bch_eras_chieny_search
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  bch_eras_chieny_search
  (
    .iclk          ( bch_eras_chieny_search__iclk          ) ,
    .ireset        ( bch_eras_chieny_search__ireset        ) ,
    .iclkena       ( bch_eras_chieny_search__iclkena       ) ,
    .iloc_poly_val ( bch_eras_chieny_search__iloc_poly_val ) ,
    .iloc_ptr      ( bch_eras_chieny_search__iloc_ptr      ) ,
    .iloc_poly     ( bch_eras_chieny_search__iloc_poly     ) ,
    .iram_data     ( bch_eras_chieny_search__iram_data     ) ,
    .iram_eras     ( bch_eras_chieny_search__iram_eras     ) ,
    .oram_addr     ( bch_eras_chieny_search__oram_addr     ) ,
    .oram_ptr      ( bch_eras_chieny_search__oram_ptr      ) ,
    .oram_read     ( bch_eras_chieny_search__oram_read     ) ,
    .owaddr        ( bch_eras_chieny_search__owaddr        ) ,
    .owptr         ( bch_eras_chieny_search__owptr         ) ,
    .odat_nfixed   ( bch_eras_chieny_search__odat_nfixed   ) ,
    .osop          ( bch_eras_chieny_search__osop          ) ,
    .oval          ( bch_eras_chieny_search__oval          ) ,
    .oeop          ( bch_eras_chieny_search__oeop          ) ,
    .oeof          ( bch_eras_chieny_search__oeof          ) ,
    .odat          ( bch_eras_chieny_search__odat          ) ,
    .odecfail      ( bch_eras_chieny_search__odecfail      ) ,
    .obiterr       ( bch_eras_chieny_search__obiterr       ) ,
    .odecerr       ( bch_eras_chieny_search__odecerr       )
  );


  assign bch_eras_chieny_search__iclk          = '0 ;
  assign bch_eras_chieny_search__ireset        = '0 ;
  assign bch_eras_chieny_search__iclkena       = '0 ;
  assign bch_eras_chieny_search__iloc_poly_val = '0 ;
  assign bch_eras_chieny_search__iloc_poly_ptr = '0 ;
  assign bch_eras_chieny_search__iloc_poly     = '0 ;
  assign bch_eras_chieny_search__iram_data     = '0 ;
  assign bch_eras_chieny_search__iram_eras     = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_eras_chieny_search.sv
// Description   : bch erasure chieny search algorithm module
//


module bch_eras_chieny_search
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  iloc_poly_val ,
  iloc_poly_ptr ,
  iloc_poly     ,
  //
  iram_data     ,
  iram_eras     ,
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
  obiterr       ,
  odecerr
);

  `include "bch_parameters.svh"
  `include "bch_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk                     ;
  input  logic          ireset                   ;
  input  logic          iclkena                  ;
  //
  input  logic          iloc_poly_val            ;
  input  ptr_t          iloc_poly_ptr            ;
  input  data_t         iloc_poly     [2][0 : t] ;
  // ram interface
  input  logic          iram_data                ;
  input  logic          iram_eras                ;
  output data_t         oram_addr                ;
  output ptr_t          oram_ptr                 ;
  output logic          oram_read                ;
  // output interface
  output data_t         owaddr                   ;
  output ptr_t          owptr                    ;
  output logic          odat_nfixed              ;
  //
  output logic          osop                     ;
  output logic          oval                     ;
  output logic          oeop                     ;
  output logic          oeof                     ;
  output logic  [1 : 0] odat                     ;
  output logic  [1 : 0] odecfail                 ;
  output data_t         obiterr       [2]        ;
  output data_t         odecerr       [2]        ;

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

  logic           start_search ;
  logic           enable_search;

  data_t          cnt;
  logic           cnt_is_0;
  logic           cnt_is_k;
  logic           cnt_is_n;
  //
  logic   [2 : 0] search_val;
  logic   [2 : 0] search_sop;
  logic   [2 : 0] search_eop;
  logic   [2 : 0] search_eof;
  //
  data_t          loc_mult          [2][0 : t];

  data_t          loc_value         [2];
  data_t          loc_value_next    [2];
  logic           loc_value_is_zero [2];

  data_t          bit_err_cnt       [2];
  data_t          dec_err_cnt       [2];
  data_t          true_bit_err_cnt  [2];

  logic   [1 : 0] dat_with_mask;
  logic   [1 : 0] dat_fixed;
  logic           dat_nfixed;
  logic           ram_rdata;
  logic           ram_eras;

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
    odat              = '{default : 0};
    //
    loc_mult          = '{default : 0};
    loc_value         = '{default : 0};
    loc_value_is_zero = '{default : 0};
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

  logic  [t : 1] loc_nzero    [2];
  data_t         loc_poly_deg [2];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int s = 0; s < 2; s++) begin
        if (start_search) begin // tick
          for (int i = 1; i <= t; i++) begin
            loc_nzero[s][i] <= (iloc_poly[s][i] != 0);
          end
        end
        if (enable_search & cnt_is_n) begin // tack
          loc_poly_deg[s] <= loc_deg(loc_nzero[s]);
        end
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
      for (int s = 0; s < 2; s++) begin
        if (start_search) begin
          loc_mult[s][0] <= iloc_poly[s][0];
          for (int i = 1; i <= t; i++) begin
            loc_mult[s][i] <= gf_mult_a_by_b_const(iloc_poly[s][i], ALPHA_TO[start_root_index(i)]);
          end
        end
        else if (enable_search) begin
          for (int i = 1; i <= t; i++) begin
            loc_mult[s][i] <= gf_mult_a_by_b_const(loc_mult[s][i], ALPHA_TO[i]);
          end
        end // enable_search
      end
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // locator value logic
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int s = 0; s < 2; s++) begin
      for (int i = 0; i <= t; i++) begin
        loc_value_next[s] = (i == 0) ? loc_mult[s][i] : (loc_value_next[s] ^ loc_mult[s][i]);
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (enable_search) begin
        for (int s = 0; s < 2; s++) begin
          loc_value[s] <= loc_value_next[s];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // error correction & statistic counters
  //------------------------------------------------------------------------------------------------------

  assign dat_with_mask[0] = ram_eras ? 1'b0 : ram_rdata;
  assign dat_with_mask[1] = ram_eras ? 1'b1 : ram_rdata;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      //
      if (search_val[0]) begin // ram have read latency == 1
        ram_rdata <= iram_data;
        ram_eras  <= iram_eras;
        for (int s = 0; s < 2; s++) begin
          loc_value_is_zero[s] <= (loc_value[s] == 0);
        end
      end
      //
      if (search_val[1]) begin
        dat_nfixed  <= ram_rdata;
        for (int s = 0; s < 2; s++) begin
          dat_fixed [s] <= dat_with_mask[s] ^ loc_value_is_zero[s]; // root is poly == 0 -> invert this error
          if (search_sop[1]) begin
            bit_err_cnt     [s] <= loc_value_is_zero[s];
            dec_err_cnt     [s] <= !ram_eras & (ram_rdata != (dat_with_mask[s] ^ loc_value_is_zero[s])); // cut off erasures
            true_bit_err_cnt[s] <=             (ram_rdata != (dat_with_mask[s] ^ loc_value_is_zero[s]));
          end
          else begin
            bit_err_cnt     [s] <= bit_err_cnt[s]       + loc_value_is_zero[s];
            dec_err_cnt     [s] <= dec_err_cnt[s]       + (!ram_eras & (ram_rdata != (dat_with_mask[s] ^ loc_value_is_zero[s]))); // cut off erasures
            true_bit_err_cnt[s] <= true_bit_err_cnt[s]  +              (ram_rdata != (dat_with_mask[s] ^ loc_value_is_zero[s]));
          end
        end
      end
      //
      osop <= search_sop [2];
      oval <= search_val [2];
      oeop <= search_eop [2];
      oeof <= search_eof [2];

      if (search_val[2]) begin
        odat_nfixed <= dat_nfixed;
        odat        <= dat_fixed;
      end
      //
      if (search_eof[2]) begin
        for (int s = 0; s < 2; s++) begin
          odecfail[s] <= (bit_err_cnt[s] != loc_poly_deg[s]);
          obiterr [s] <=  true_bit_err_cnt[s];
          odecerr [s] <=  dec_err_cnt[s];
        end
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

endmodule
