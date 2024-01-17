/*



  parameter int pERR_W = 8 ;



  logic                  super_i3_bch_outer_decision__iclk                        ;
  logic                  super_i3_bch_outer_decision__ireset                      ;
  logic                  super_i3_bch_outer_decision__iclkena                     ;
  //
  logic                  super_i3_bch_outer_decision__idat_val                    ;
  logic                  super_i3_bch_outer_decision__idat_ptr                    ;
  logic [cDEC_NUM-1 : 0] super_i3_bch_outer_decision__idat_decfail                ;
  //
  dat_t                  super_i3_bch_outer_decision__iram_rdat        [cDEC_NUM] ;
  dat_t                  super_i3_bch_outer_decision__iram_rdat_nfixed [cDEC_NUM] ;
  ram_addr_t             super_i3_bch_outer_decision__oram_raddr                  ;
  logic                  super_i3_bch_outer_decision__oram_rptr                   ;
  logic                  super_i3_bch_outer_decision__oram_read                   ;
  //
  logic                  super_i3_bch_outer_decision__oval                        ;
  logic                  super_i3_bch_outer_decision__osop                        ;
  logic                  super_i3_bch_outer_decision__oeop                        ;
  ram_dat_t              super_i3_bch_outer_decision__odat                        ;
  //
  logic   [pERR_W-1 : 0] super_i3_bch_outer_decision__odecerr                     ;



  super_i3_bch_outer_decision
  #(
    .pERR_W ( pERR_W )
  )
  super_i3_bch_outer_decision
  (
    .iclk             ( super_i3_bch_outer_decision__iclk             ) ,
    .ireset           ( super_i3_bch_outer_decision__ireset           ) ,
    .iclkena          ( super_i3_bch_outer_decision__iclkena          ) ,
    //
    .idat_val         ( super_i3_bch_outer_decision__idat_val         ) ,
    .idat_ptr         ( super_i3_bch_outer_decision__idat_ptr         ) ,
    .idat_decfail     ( super_i3_bch_outer_decision__idat_decfail     ) ,
    //
    .iram_rdat        ( super_i3_bch_outer_decision__iram_rdat        ) ,
    .iram_rdat_nfixed ( super_i3_bch_outer_decision__iram_rdat_nfixed ) ,
    .oram_raddr       ( super_i3_bch_outer_decision__oram_raddr       ) ,
    .oram_rptr        ( super_i3_bch_outer_decision__oram_rptr        ) ,
    .oram_read        ( super_i3_bch_outer_decision__oram_read        ) ,
    //
    .oval             ( super_i3_bch_outer_decision__oval             ) ,
    .osop             ( super_i3_bch_outer_decision__osop             ) ,
    .oeop             ( super_i3_bch_outer_decision__oeop             ) ,
    .odat             ( super_i3_bch_outer_decision__odat             ) ,
    //
    .odecerr          ( super_i3_bch_outer_decision__odecerr          )
  );


  assign super_i3_bch_outer_decision__iclk             = '0 ;
  assign super_i3_bch_outer_decision__ireset           = '0 ;
  assign super_i3_bch_outer_decision__iclkena          = '0 ;
  assign super_i3_bch_outer_decision__idat_val         = '0 ;
  assign super_i3_bch_outer_decision__idat_ptr         = '0 ;
  assign super_i3_bch_outer_decision__idat_decfail     = '0 ;
  assign super_i3_bch_outer_decision__iram_rdat        = '0 ;
  assign super_i3_bch_outer_decision__iram_rdat_nfixed = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_bch_outer_decision.sv
// Description   : bch decoder decision unit for outer decoder (decfail ? unfixed data : fixed data)
//                 & "BCH(3860,3824) frame format" framer for strem data restore
//

module super_i3_bch_outer_decision
(
  iclk             ,
  ireset           ,
  iclkena          ,
  //
  idat_val         ,
  idat_ptr         ,
  idat_decfail     ,
  //
  iram_rdat        ,
  iram_rdat_nfixed ,
  oram_raddr       ,
  oram_rptr        ,
  oram_read        ,
  //
  oval             ,
  osop             ,
  oeop             ,
  odat             ,
  //
  odecerr
);

  parameter int pERR_W = 8;

  `include "super_i3_bch_outer_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk                        ;
  input  logic                  ireset                      ;
  input  logic                  iclkena                     ;
  //
  input  logic                  idat_val                    ;
  input  logic                  idat_ptr                    ;
  input  logic [cDEC_NUM-1 : 0] idat_decfail                ;
  //
  input  dat_t                  iram_rdat        [cDEC_NUM] ;
  input  dat_t                  iram_rdat_nfixed [cDEC_NUM] ;
  output ram_addr_t             oram_raddr                  ;
  output logic                  oram_rptr                   ;
  output logic                  oram_read                   ;
  //
  output logic                  oval                        ;
  output logic                  osop                        ;
  output logic                  oeop                        ;
  output ram_dat_t              odat                        ;
  //
  output logic   [pERR_W-1 : 0] odecerr                     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic start_search ;
  logic enable_search;

  struct packed {
    logic      zero;
    logic      is_k;
    logic      is_n;
    logic      done;
    ram_addr_t value;
  } cnt;

  logic         [1 : 0] val;
  logic         [1 : 0] sop;
  logic         [1 : 0] eop;
  logic         [1 : 0] eof;
  logic [cDEC_NUM-1 :0] decfail [2];

  dat_t                 dat [cDEC_NUM] ;
  logic [cDEC_NUM-1 :0] dat_decfail;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  assign start_search = idat_val;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      enable_search  <= 1'b0;
    end
    else if (iclkena) begin
      if (start_search) begin
        enable_search <= 1'b1;
      end
      else if (cnt.done) begin
        enable_search <= 1'b0;
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        cnt       <= '0;
        cnt.zero  <= 1'b1;
      end
      else if (enable_search) begin
        cnt.value <= cnt.value + 1'b1;
        cnt.zero  <= 1'b0;
        cnt.is_k  <= (cnt.value == cEOP_EDGE-2);
        cnt.is_n  <= (cnt.value == cEOF_EDGE-2);
        cnt.done  <= (cnt.value == cFRAME_SIZE-2);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram reading (read latency 2 tick)
  //------------------------------------------------------------------------------------------------------

  assign oram_raddr = cnt.value;
  assign oram_read  = 1'b1;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start_search) begin
        oram_rptr <= idat_ptr;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // strobes generation
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | enable_search;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | (cnt.zero & enable_search);
      eop <= (eop << 1) | (cnt.is_k & enable_search);
      eof <= (eof << 1) | (cnt.is_n & enable_search);
      //
      if (start_search) begin
        dat_decfail <= idat_decfail;
      end
      //
      decfail[0] <= dat_decfail;
      decfail[1] <= decfail[0];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram read latency 2 tick
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= val[1];
    end
  end

  // select in codeword native format
  always_comb begin
    for (int d = 0; d < cDEC_NUM; d++) begin
      dat[d] = decfail[1][d] ? iram_rdat_nfixed[d] : iram_rdat[d];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= sop[1];
      oeop <= eop[1];
      //
      // convert to stream format
      if (val[1]) begin
        for (int d = 0; d < cDEC_NUM; d++) begin
          for (int i = 0; i < cDAT_W; i++) begin
            odat[i*cDEC_NUM + d] = dat[d][i];
          end
        end
        // last word (128 bit) differ LSB first
        if (eof[1]) begin
          for (int d = 0; d < cDEC_NUM; d++) begin
            odat[d*cDAT_W +: cDAT_W] = dat[d];
          end
        end
      end
      //
      if (sop[1]) begin
        odecerr <= count_decnum(dat_decfail);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function logic [pERR_W-1 : 0] count_decnum (input logic [cDEC_NUM-1 : 0] decfail);
    count_decnum = '0;
    for (int i = 0; i < cDEC_NUM; i++) begin
      count_decnum = count_decnum + decfail[i];
    end
  endfunction

endmodule
