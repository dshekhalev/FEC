/*


  parameter int pSYMB_M_W = 8;


  logic        tcm_dec_tmu_tree16__iclk           ;
  logic        tcm_dec_tmu_tree16__ireset         ;
  logic        tcm_dec_tmu_tree16__iclkena        ;
  logic        tcm_dec_tmu_tree16__ival           ;
  symb_m_t     tcm_dec_tmu_tree16__isymb_m   [16] ;
  logic        tcm_dec_tmu_tree16__oval           ;
  trel_bm_t    tcm_dec_tmu_tree16__obm            ;
  symb_m_idx_t tcm_dec_tmu_tree4__osymb_m_idx     ;



  tcm_dec_tmu_tree16
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_dec_tmu_tree16
  (
    .iclk        ( tcm_dec_tmu_tree16__iclk        ) ,
    .ireset      ( tcm_dec_tmu_tree16__ireset      ) ,
    .iclkena     ( tcm_dec_tmu_tree16__iclkena     ) ,
    .ival        ( tcm_dec_tmu_tree16__ival        ) ,
    .isymb_m     ( tcm_dec_tmu_tree16__isymb_m     ) ,
    .oval        ( tcm_dec_tmu_tree16__oval        ) ,
    .obm         ( tcm_dec_tmu_tree16__obm         ) ,
    .osymb_m_idx ( tcm_dec_tmu_tree16__osymb_m_idx )
  );


  assign tcm_dec_tmu_tree16__iclk    = '0 ;
  assign tcm_dec_tmu_tree16__ireset  = '0 ;
  assign tcm_dec_tmu_tree16__iclkena = '0 ;
  assign tcm_dec_tmu_tree16__ival    = '0 ;
  assign tcm_dec_tmu_tree16__isymb_m = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_tmu_tree16.sv
// Description   : trellis metric unit add-compare-select tree for 2.75 coderate (16 metric per group)
//

`include "define.vh"

module tcm_dec_tmu_tree16
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  ival        ,
  isymb_m     ,
  //
  oval        ,
  obm         ,
  osymb_m_idx
);

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic        iclk         ;
  input  logic        ireset       ;
  input  logic        iclkena      ;
  //
  input  logic        ival         ;
  input  symb_m_t     isymb_m [16] ;
  //
  output logic        oval         ;
  output trel_bm_t    obm          ;
  output symb_m_idx_t osymb_m_idx  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic   [3 : 0] val;

  trel_bm_t       pre_sum           [16];

  symb_m_value_t  symb_m3_line      [2][4];

  trel_bm_t       comp_pre_sum      [4];
  symb_m_idx_t    comp_pre_sum_idx  [4];

  trel_bm_t       sum               [4];
  symb_m_idx_t    sum_idx           [4];

  //------------------------------------------------------------------------------------------------------
  //
  //  1. add pre group of 8
  //  2. compare pre group
  //  3. add final
  //  4  compare group final
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  always_ff @(posedge iclk) begin
    bit [1 : 0] decision4;
    //
    if (iclkena) begin
      //
      // add pre group
      if (ival) begin
        for (int i = 0; i < 16; i++) begin
          pre_sum[i] <= isymb_m[i][0] + isymb_m[i][1] + isymb_m[i][2];
        end
        for (int i = 0; i < 4; i++) begin
          symb_m3_line[0][i] <= isymb_m[4*i][3];
        end
      end
      //
      // compare pre group
      if (val[0]) begin
        for (int i = 0; i < 4; i++) begin
          decision4 = max4(pre_sum[4*i], pre_sum[4*i+1], pre_sum[4*i+2], pre_sum[4*i+3]);
          //
          comp_pre_sum      [i] <= pre_sum[4*i + decision4];
          comp_pre_sum_idx  [i] <=         4*i + decision4;
        end
        symb_m3_line[1] <= symb_m3_line[0];
      end
      //
      // add final
      if (val[1]) begin
        for (int i = 0; i < 4; i++) begin
          sum[i]  <= comp_pre_sum[i] + symb_m3_line[1][i];
        end
        sum_idx   <= comp_pre_sum_idx;
      end
      //
      // compare group final
      if (val[2]) begin
        decision4 = max4(sum[0], sum[1], sum[2], sum[3]);
        //
        obm         <= sum    [decision4];
        osymb_m_idx <= sum_idx[decision4];
      end
    end
  end

  assign oval = val[3];

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  function automatic bit max2 (input trel_bm_t a0, a1);
    max2 = (a1 > a0);
  endfunction

  function automatic bit [1 : 0] max4 (input trel_bm_t a0, a1, a2, a3);
    logic a1_more_a0;
    logic a3_more_a2;
    logic a23_more_a10;
  begin
    a1_more_a0    = (a1 > a0);
    a3_more_a2    = (a3 > a2);

    a23_more_a10  = ((a3_more_a2 ? a3 : a2) > (a1_more_a0 ? a1 : a0));

    if (a23_more_a10) begin
      max4 = a3_more_a2 ? 2'h3 : 2'h2;
    end
    else begin
      max4 = a1_more_a0 ? 2'h1 : 2'h0;
    end
  end
  endfunction

endmodule
