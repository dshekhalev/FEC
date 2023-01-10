/*


  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;



  logic   bch_decision__iclk                  ;
  logic   bch_decision__ireset                ;
  logic   bch_decision__iclkena               ;
  logic   bch_decision__idata_val             ;
  ptr_t   bch_decision__idata_ptr             ;
  logic   bch_decision__idata_decfail         ;
  data_t  bch_decision__idata_biterr          ;
  logic   bch_decision__iram_data             ;
  logic   bch_decision__iram_data_nfixed      ;
  data_t  bch_decision__oram_addr             ;
  logic   bch_decision__oram_ptr              ;
  logic   bch_decision__oram_read             ;
  logic   bch_decision__owaddr                ;
  logic   bch_decision__owptr                 ;
  logic   bch_decision__odat_nfixed           ;
  logic   bch_decision__osop                  ;
  logic   bch_decision__oval                  ;
  logic   bch_decision__oeop                  ;
  logic   bch_decision__oeof                  ;
  logic   bch_decision__odat                  ;
  logic   bch_decision__odecfail              ;
  data_t  bch_decision__obiterr               ;



  bch_decision
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  bch_decision
  (
    .iclk             ( bch_decision__iclk             ) ,
    .ireset           ( bch_decision__ireset           ) ,
    .iclkena          ( bch_decision__iclkena          ) ,
    .idata_val        ( bch_decision__idata_val        ) ,
    .idata_ptr        ( bch_decision__idata_ptr        ) ,
    .idata_decfail    ( bch_decision__idata_decfail    ) ,
    .idata_biterr     ( bch_decision__idata_biterr     ) ,
    .iram_data        ( bch_decision__iram_data        ) ,
    .iram_data_nfixed ( bch_decision__iram_data_nfixed ) ,
    .oram_addr        ( bch_decision__oram_addr        ) ,
    .oram_ptr         ( bch_decision__oram_ptr         ) ,
    .oram_read        ( bch_decision__oram_read        ) ,
    .owaddr           ( bch_decision__owaddr           ) ,
    .owptr            ( bch_decision__owptr            ) ,
    .odat_nfixed      ( bch_decision__odat_nfixed      ) ,
    .osop             ( bch_decision__osop             ) ,
    .oval             ( bch_decision__oval             ) ,
    .oeop             ( bch_decision__oeop             ) ,
    .oeof             ( bch_decision__oeof             ) ,
    .odat             ( bch_decision__odat             ) ,
    .odecfail         ( bch_decision__odecfail         ) ,
    .obiterr          ( bch_decision__obiterr          )
  );


  assign bch_decision__iclk             = '0 ;
  assign bch_decision__ireset           = '0 ;
  assign bch_decision__iclkena          = '0 ;
  assign bch_decision__idata_val        = '0 ;
  assign bch_decision__idata_ptr        = '0 ;
  assign bch_decision__idata_decfail    = '0 ;
  assign bch_decision__idata_biterr     = '0 ;
  assign bch_decision__iram_data        = '0 ;
  assign bch_decision__iram_data_nfixed = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_decision.sv
// Description   : bch chieny search algorithm module
//


module bch_decision
(
  iclk             ,
  ireset           ,
  iclkena          ,
  //
  idata_val        ,
  idata_ptr        ,
  idata_decfail    ,
  idata_biterr     ,
  //
  iram_data        ,
  iram_data_nfixed ,
  oram_addr        ,
  oram_ptr         ,
  oram_read        ,
  //
  osop             ,
  oval             ,
  oeop             ,
  oeof             ,
  odat             ,
  odecfail         ,
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
  input  logic  idata_val             ;
  input  ptr_t  idata_ptr             ;
  input  logic  idata_decfail         ;
  input  data_t idata_biterr          ;
  // ram interface
  input  logic  iram_data             ;
  input  logic  iram_data_nfixed      ;
  output data_t oram_addr             ;
  output ptr_t  oram_ptr              ;
  output logic  oram_read             ;
  // output interface
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

  logic   start_search ;
  logic   enable_search;

  data_t  cnt;
  logic   cnt_is_0;
  logic   cnt_is_k;
  logic   cnt_is_n;
  //
  logic   search_val;
  logic   search_sop;
  logic   search_eop;
  logic   search_eof;

  logic   decfail;
  data_t  biterr;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin : ini
    enable_search = '0;
    cnt           = '0;
    cnt_is_0      = '0;
    cnt_is_n      = '0;
    cnt_is_k      = '0;
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
    oeof          = '0;
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  // deicsion as chieny search FSM
  //------------------------------------------------------------------------------------------------------

  assign start_search = idata_val;

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
      search_val  <= enable_search;
      search_sop  <= cnt_is_0 & enable_search;
      search_eop  <= cnt_is_k & enable_search;
      search_eof  <= cnt_is_n & enable_search;
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
        oram_ptr <= idata_ptr;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        decfail <= idata_decfail;
        biterr  <= idata_biterr;
      end
      //
      osop <= search_sop;
      oval <= search_val;
      oeop <= search_eop;
      oeof <= search_eof;
      //
      if (search_val) begin
        odat <= decfail ? iram_data_nfixed : iram_data;
      end
      //
      if (search_sop) begin
        odecfail <= decfail;
        obiterr  <= biterr;
      end
    end
  end

endmodule
