/*


  parameter int pSYMB_M_W = 8;


  logic        tcm_dec_tmu_tree4__iclk         ;
  logic        tcm_dec_tmu_tree4__ireset       ;
  logic        tcm_dec_tmu_tree4__iclkena      ;
  logic        tcm_dec_tmu_tree4__ival         ;
  symb_m_t     tcm_dec_tmu_tree4__isymb_m  [4] ;
  logic        tcm_dec_tmu_tree4__oval         ;
  trel_bm_t    tcm_dec_tmu_tree4__obm          ;
  symb_m_idx_t tcm_dec_tmu_tree4__osymb_m_idx  ;



  tcm_dec_tmu_tree4
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_dec_tmu_tree4
  (
    .iclk        ( tcm_dec_tmu_tree4__iclk        ) ,
    .ireset      ( tcm_dec_tmu_tree4__ireset      ) ,
    .iclkena     ( tcm_dec_tmu_tree4__iclkena     ) ,
    .ival        ( tcm_dec_tmu_tree4__ival        ) ,
    .isymb_m     ( tcm_dec_tmu_tree4__isymb_m     ) ,
    .oval        ( tcm_dec_tmu_tree4__oval        ) ,
    .obm         ( tcm_dec_tmu_tree4__obm         ) ,
    .osymb_m_idx ( tcm_dec_tmu_tree4__osymb_m_idx )
  );


  assign tcm_dec_tmu_tree4__iclk    = '0 ;
  assign tcm_dec_tmu_tree4__ireset  = '0 ;
  assign tcm_dec_tmu_tree4__iclkena = '0 ;
  assign tcm_dec_tmu_tree4__ival    = '0 ;
  assign tcm_dec_tmu_tree4__isymb_m = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_tmu_tree4.sv
// Description   : trellis metric unit add-compare-select tree for 2.25 coderate (4 metric per group)
//

`include "define.vh"

module tcm_dec_tmu_tree4
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

  input  logic        iclk        ;
  input  logic        ireset      ;
  input  logic        iclkena     ;
  //
  input  logic        ival        ;
  input  symb_m_t     isymb_m [4] ;
  //
  output logic        oval        ;
  output trel_bm_t    obm         ;
  output symb_m_idx_t osymb_m_idx ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [2 : 0]  val;

  trel_bm_t      pre_sum       [4];

  symb_m_value_t symb_m3_line  [2];

  trel_bm_t      sum           [4];

  //------------------------------------------------------------------------------------------------------
  //
  //  1. add pre group
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
        for (int i = 0; i < 4; i++) begin
          pre_sum[i] <= isymb_m[i][0] + isymb_m[i][1] + isymb_m[i][2];
        end
        symb_m3_line[0] <= isymb_m[0][3];
        symb_m3_line[1] <= isymb_m[2][3];
      end
      //
      // add final group
      if (val[0]) begin
        for (int i = 0; i < 4; i++) begin
          sum[i] <= pre_sum[i] + symb_m3_line[i/2];
        end
      end
      //
      // compare pre group
      if (val[1]) begin
        decision4 = max4(sum[0], sum[1], sum[2], sum[3]);
        //
        obm         <= sum[decision4];
        osymb_m_idx <= decision4;
      end
    end
  end

  assign oval = val[2];

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
