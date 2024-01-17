/*






  logic                  super_i3_bch_outer_chieny_search__iclk                             ;
  logic                  super_i3_bch_outer_chieny_search__ireset                           ;
  logic                  super_i3_bch_outer_chieny_search__iclkena                          ;
  //
  logic                  super_i3_bch_outer_chieny_search__iloc_poly_val                    ;
  logic                  super_i3_bch_outer_chieny_search__iloc_poly_ptr                    ;
  gf_dat_t               super_i3_bch_outer_chieny_search__iloc_poly     [cDEC_NUM][0 : cT] ;
  //
  dat_t                  super_i3_bch_outer_chieny_search__iram_rdat     [cDEC_NUM]         ;
  ram_addr_t             super_i3_bch_outer_chieny_search__oram_raddr                       ;
  logic                  super_i3_bch_outer_chieny_search__oram_rptr                        ;
  logic                  super_i3_bch_outer_chieny_search__oram_read                        ;
  //
  logic                  super_i3_bch_outer_chieny_search__owrite                           ;
  ram_addr_t             super_i3_bch_outer_chieny_search__owaddr                           ;
  logic                  super_i3_bch_outer_chieny_search__owptr                            ;
  dat_t                  super_i3_bch_outer_chieny_search__owdat         [cDEC_NUM]         ;
  dat_t                  super_i3_bch_outer_chieny_search__owdat_nfixed  [cDEC_NUM]         ;
  //
  logic                  super_i3_bch_outer_chieny_search__odone                            ;
  logic                  super_i3_bch_outer_chieny_search__odone_ptr                        ;
  gf_dat_t               super_i3_bch_outer_chieny_search__obiterr       [cDEC_NUM]         ;
  logic [cDEC_NUM-1 : 0] super_i3_bch_outer_chieny_search__odecfail                         ;


  super_i3_bch_outer_chieny_search
  super_i3_bch_outer_chieny_search
  (
    .iclk          ( super_i3_bch_outer_chieny_search__iclk          ) ,
    .ireset        ( super_i3_bch_outer_chieny_search__ireset        ) ,
    .iclkena       ( super_i3_bch_outer_chieny_search__iclkena       ) ,
    //
    .iloc_poly_val ( super_i3_bch_outer_chieny_search__iloc_poly_val ) ,
    .iloc_poly_ptr ( super_i3_bch_outer_chieny_search__iloc_poly_ptr ) ,
    .iloc_poly     ( super_i3_bch_outer_chieny_search__iloc_poly     ) ,
    //
    .iram_rdat     ( super_i3_bch_outer_chieny_search__iram_rdat     ) ,
    .oram_raddr    ( super_i3_bch_outer_chieny_search__oram_raddr    ) ,
    .oram_rptr     ( super_i3_bch_outer_chieny_search__oram_rptr     ) ,
    .oram_read     ( super_i3_bch_outer_chieny_search__oram_read     ) ,
    //
    .owrite        ( super_i3_bch_outer_chieny_search__owrite        ) ,
    .owaddr        ( super_i3_bch_outer_chieny_search__owaddr        ) ,
    .owptr         ( super_i3_bch_outer_chieny_search__owptr         ) ,
    .owdat         ( super_i3_bch_outer_chieny_search__owdat         ) ,
    .owdat_nfixed  ( super_i3_bch_outer_chieny_search__owdat_nfixed  ) ,
    //
    .odone         ( super_i3_bch_outer_chieny_search__odone         ) ,
    .odone_ptr     ( super_i3_bch_outer_chieny_search__odone_ptr     ) ,
    .obiterr       ( super_i3_bch_outer_chieny_search__obiterr       ) ,
    .odecfail      ( super_i3_bch_outer_chieny_search__odecfail      )
  );


  assign super_i3_bch_outer_chieny_search__iclk          = '0 ;
  assign super_i3_bch_outer_chieny_search__ireset        = '0 ;
  assign super_i3_bch_outer_chieny_search__iclkena       = '0 ;
  assign super_i3_bch_outer_chieny_search__iloc_poly_val = '0 ;
  assign super_i3_bch_outer_chieny_search__iloc_poly_ptr = '0 ;
  assign super_i3_bch_outer_chieny_search__iloc_poly     = '0 ;
  assign super_i3_bch_outer_chieny_search__iram_rdat     = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_bch_outer_chieny_search.sv
// Description   : I.3 outer BCH (3860,3824) decoder array chieny search
//

module super_i3_bch_outer_chieny_search
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  iloc_poly_val ,
  iloc_poly_ptr ,
  iloc_poly     ,
  //
  iram_rdat     ,
  oram_raddr    ,
  oram_rptr     ,
  oram_read     ,
  //
  owrite        ,
  owaddr        ,
  owptr         ,
  owdat         ,
  owdat_nfixed  ,
  //
  odone         ,
  odone_ptr     ,
  obiterr       ,
  odecfail
);

  `include "super_i3_bch_outer_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk                             ;
  input  logic                  ireset                           ;
  input  logic                  iclkena                          ;
  //
  input  logic                  iloc_poly_val                    ;
  input  logic                  iloc_poly_ptr                    ;
  input  gf_dat_t               iloc_poly     [cDEC_NUM][0 : cT] ;
  //
  input  dat_t                  iram_rdat     [cDEC_NUM]         ;
  output ram_addr_t             oram_raddr                       ;
  output logic                  oram_rptr                        ;
  output logic                  oram_read                        ;
  //
  output logic                  owrite                           ;
  output ram_addr_t             owaddr                           ;
  output logic                  owptr                            ;
  output dat_t                  owdat         [cDEC_NUM]         ;
  output dat_t                  owdat_nfixed  [cDEC_NUM]         ;
  //
  output logic                  odone                            ;
  output logic                  odone_ptr                        ;
  output gf_dat_t               obiterr       [cDEC_NUM]         ;
  output logic [cDEC_NUM-1 : 0] odecfail                         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic start_search ;
  logic enable_search;

  struct packed
  {
    logic      zero;
    logic      is_n;
    logic      done;
    ram_addr_t value;
  } cnt;

  logic [2 : 0] search_val;
  logic [2 : 0] search_sop;
  logic [2 : 0] search_eof;
  logic [2 : 0] search_done;

  // alpha types
  gf_dat_t alpha__odat                    [0 : cT];
  gf_dat_t alpha_start__odat              [1 : cT];

  // chieny engine
  logic    engine__isop         [cDEC_NUM]                 ;
  gf_dat_t engine__iloc_poly    [cDEC_NUM][0 : cT]         ;
  gf_dat_t engine__ialpha_start [cDEC_NUM][1 : cT]         ;
  //
  gf_dat_t engine__iloc_mult    [cDEC_NUM][0 : cT][cDAT_W] ;
  gf_dat_t engine__ialpha       [cDEC_NUM][1 : cT]         ;
  //
  gf_dat_t engine__oloc_mult    [cDEC_NUM][0 : cT][cDAT_W] ;

  // chieny logic
  gf_dat_t loc_mult              [cDEC_NUM][0 : cT][cDAT_W] ;
  gf_dat_t loc_value             [cDEC_NUM]        [cDAT_W] ;
  gf_dat_t loc_value_next        [cDEC_NUM]        [cDAT_W] ;
  dat_t    loc_value_is_zero     [cDEC_NUM]                 ;

  gf_dat_t bit_err_cnt           [cDEC_NUM];

  dat_t    dat_fixed             [cDEC_NUM];
  dat_t    dat_nfixed            [cDEC_NUM];

  //------------------------------------------------------------------------------------------------------
  // chieny search FSM
  //------------------------------------------------------------------------------------------------------

  assign start_search = iloc_poly_val;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      enable_search <= 1'b0;
    end
    else if (iclkena) begin
      // simple FSM
      if (start_search) begin
        enable_search <= 1'b1;
      end
      else if (cnt.done) begin
        enable_search <= 1'b0;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        cnt       <= '0;
        cnt.zero  <= 1'b1;
      end
      else if (enable_search) begin
        cnt.value <= cnt.value + 1'b1;
        cnt.zero  <= 1'b0;
        cnt.is_n  <= (cnt.value == cEOF_EDGE-2);
        cnt.done  <= (cnt.value == cFRAME_SIZE-2);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // read data
  //------------------------------------------------------------------------------------------------------

  assign oram_raddr = cnt.value;
  assign oram_read  = 1'b1;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        oram_rptr <= iloc_poly_ptr;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // strobes generation
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      search_done <= '0;
    end
    else if (iclkena) begin
      search_done <= (search_done << 1) | (cnt.done & enable_search);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      search_val  <= (search_val << 1) | enable_search;
      search_sop  <= (search_sop << 1) | (cnt.zero & enable_search);
      search_eof  <= (search_eof << 1) | (cnt.is_n & enable_search);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // capture state of locator polynomes for statistic
  //------------------------------------------------------------------------------------------------------

  logic [cT : 1] loc_nzero    [cDEC_NUM];
  gf_dat_t       loc_poly_deg [cDEC_NUM];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin // tick
        for (int d = 0; d < cDEC_NUM; d++) begin
          for (int i = 1; i <= cT; i++) begin
            loc_nzero[d][i] <= (iloc_poly[d][i] != 0);
          end
        end
      end
      if (enable_search & cnt.is_n) begin // tack
        for (int d = 0; d < cDEC_NUM; d++) begin
          loc_poly_deg[d] <= loc_deg(loc_nzero[d]);
        end
      end
    end
  end

  function automatic gf_dat_t loc_deg (input logic [cT : 1] vector);
    loc_deg = 0;
    for (int i = 1; i <= cT; i++) begin
      if (vector[i]) begin
        loc_deg = i;
      end
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // chieny logic
  //------------------------------------------------------------------------------------------------------

  gf_alpha
  #(
    .m      ( cM      ) ,
    .irrpol ( cIRRPOL ) ,
    .n      ( cT + 1  )
  )
  gf_alpha
  (
    .odat ( alpha__odat )
  );

  gf_chieny_alpha_start
  #(
    .m      ( cM      ) ,
    .irrpol ( cIRRPOL ) ,
    .t      ( cT      ) ,
    .n      ( cN      )
  )
  gf_alpha_start
  (
    .odat ( alpha_start__odat )
  );

  generate
    genvar g;
    for (g = 0; g < cDEC_NUM; g++) begin : chieny_engine_inst_gen
      gf_chieny_engine
      #(
        .m      ( cM      ) ,
        .irrpol ( cIRRPOL ) ,
        .t      ( cT      ) ,
        //
        .pDAT_W ( cDAT_W  )
      )
      engine
      (
        .isop         ( engine__isop         [g] ) ,
        .iloc_poly    ( engine__iloc_poly    [g] ) ,
        .ialpha_start ( engine__ialpha_start [g] ) ,
        //
        .iloc_mult    ( engine__iloc_mult    [g] ) ,
        .ialpha       ( engine__ialpha       [g] ) ,
        //
        .oloc_mult    ( engine__oloc_mult    [g] )
      );

      assign engine__isop         [g] = start_search;
      assign engine__iloc_poly    [g] = iloc_poly[g];
      assign engine__ialpha_start [g] = alpha_start__odat;

      assign engine__iloc_mult    [g] = loc_mult[g];
      assign engine__ialpha       [g] = alpha__odat[1 : cT];

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (start_search | enable_search)  begin
            loc_mult[g]  <= engine__oloc_mult[g];
          end
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // locator value logic
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int d = 0; d < cDEC_NUM; d++) begin
      for (int b = 0; b < cDAT_W; b++) begin
        for (int i = 0; i <= cT; i++) begin
          loc_value_next[d][b] = (i == 0) ? loc_mult [d][i][b] : (loc_value_next[d][b] ^ loc_mult[d][i][b]);
        end
      end
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

  logic bypass;     // bypass inner pbits
  logic wptr = '0;  // can be any

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (search_val[0]) begin
        for (int d = 0; d < cDEC_NUM; d++) begin
          for (int b = 0; b < cDAT_W; b++) begin
            loc_value_is_zero[d][b] <= (loc_value[d][b] == 0);
          end
        end
      end
      //
      if (search_sop[1]) begin
        bypass <= 1'b0;
      end
      else if (search_eof[1]) begin
        bypass <= 1'b1;
      end
      //
      if (search_val[1]) begin
        for (int d = 0; d < cDEC_NUM; d++) begin
          dat_nfixed [d] <= iram_rdat[d];
          dat_fixed  [d] <= iram_rdat[d] ^ loc_value_is_zero[d]; // root is poly == 0 -> invert this error
          bit_err_cnt[d] <= search_sop[1] ? get_bit_err(loc_value_is_zero[d]) : (bit_err_cnt[d] + get_bit_err(loc_value_is_zero[d]));
          // last word differ
          if (search_eof[1]) begin
            dat_fixed  [d] <= iram_rdat[d] ^ {6'h0, loc_value_is_zero[d][3 : 2], 6'h0, loc_value_is_zero[d][1 : 0]};
            bit_err_cnt[d] <= bit_err_cnt[d] + get_bit_err({12'h0, loc_value_is_zero[d][3 : 0]});
          end
          // others must bypassed and not counted
          else if (bypass & !search_sop[1]) begin
            dat_fixed  [d] <= iram_rdat   [d];
            bit_err_cnt[d] <= bit_err_cnt [d];
          end
        end
      end
      //
      if (search_sop[1]) begin
        owaddr  <= '0;
        wptr    <= wptr + 1'b1;
      end
      else if (search_val[1]) begin
        owaddr  <= owaddr + 1'b1;
      end
    end
  end

  assign owptr        = wptr;
  assign owrite       = search_val[2];
  assign owdat        = dat_fixed;
  assign owdat_nfixed = dat_nfixed;

  assign odone        = search_done[2];
  assign odone_ptr    = wptr;

  // there is register for decfail/biterr outside
  always_comb begin
    for (int d = 0; d < cDEC_NUM; d++) begin
      obiterr [d] =  bit_err_cnt[d];
      odecfail[d] = (bit_err_cnt[d] != loc_poly_deg[d]);
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function dat_t get_bit_err (input dat_t data);
    get_bit_err = '0;
    for (int b = 0; b < $bits(dat_t); b++) begin
      get_bit_err += data[b];
    end
  endfunction

endmodule
