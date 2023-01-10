/*


  parameter int pSYMB_M_W = 8;


  logic        tcm_dec_tmu_tree2__iclk          ;
  logic        tcm_dec_tmu_tree2__ireset        ;
  logic        tcm_dec_tmu_tree2__iclkena       ;
  logic        tcm_dec_tmu_tree2__ival          ;
  symb_m_t     tcm_dec_tmu_tree2__isymb_m   [2] ;
  logic        tcm_dec_tmu_tree2__oval          ;
  trel_  bm_t  tcm_dec_tmu_tree2__obm           ;
  symb_m_idx_t tcm_dec_tmu_tree2__osymb_m_idx   ;



  tcm_dec_tmu_tree2
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_dec_tmu_tree2
  (
    .iclk        ( tcm_dec_tmu_tree2__iclk        ) ,
    .ireset      ( tcm_dec_tmu_tree2__ireset      ) ,
    .iclkena     ( tcm_dec_tmu_tree2__iclkena     ) ,
    .ival        ( tcm_dec_tmu_tree2__ival        ) ,
    .isymb_m     ( tcm_dec_tmu_tree2__isymb_m     ) ,
    .oval        ( tcm_dec_tmu_tree2__oval        ) ,
    .obm         ( tcm_dec_tmu_tree2__obm         ) ,
    .osymb_m_idx ( tcm_dec_tmu_tree2__osymb_m_idx )
  );


  assign tcm_dec_tmu_tree2__iclk    = '0 ;
  assign tcm_dec_tmu_tree2__ireset  = '0 ;
  assign tcm_dec_tmu_tree2__iclkena = '0 ;
  assign tcm_dec_tmu_tree2__ival    = '0 ;
  assign tcm_dec_tmu_tree2__isymb_m = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_tmu_tree2.sv
// Description   : trellis metric unit add-compare-select tree for 2.0 coderate (2 metric per group)
//

`include "define.vh"

module tcm_dec_tmu_tree2
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  ival         ,
  isymb_m      ,
  //
  oval         ,
  obm          ,
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
  input  symb_m_t     isymb_m [2] ;
  //
  output logic        oval        ;
  output trel_bm_t    obm         ;
  output symb_m_idx_t osymb_m_idx ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [2 : 0]  val;

  trel_bm_t      pre_sum       [2];

  symb_m_value_t symb_m3_line  [2];

  trel_bm_t      sum           [2];

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
    bit         decision2;
    //
    if (iclkena) begin
      //
      // add pre group
      if (ival) begin
        for (int i = 0; i < 2; i++) begin
          pre_sum     [i] <= isymb_m[i][0] + isymb_m[i][1] + isymb_m[i][2];
          symb_m3_line[i] <= isymb_m[i][3];
        end
      end
      //
      // add final group
      if (val[0]) begin
        for (int i = 0; i < 2; i++) begin
          sum[i] <= pre_sum[i] + symb_m3_line[i];
        end
      end
      //
      // compare group
      if (val[1]) begin
        decision2 = max2(sum[0], sum[1]);
        //
        obm         <= sum[decision2];
        osymb_m_idx <= decision2;
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
