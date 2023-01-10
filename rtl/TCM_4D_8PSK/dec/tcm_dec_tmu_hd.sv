/*


  parameter int pSYMB_M_W = 8;


  logic        tcm_dec_tmu_hd__iclk         ;
  logic        tcm_dec_tmu_hd__ireset       ;
  logic        tcm_dec_tmu_hd__iclkena      ;
  logic        tcm_dec_tmu_hd__ival         ;
  symb_m_t     tcm_dec_tmu_hd__isymb_m  [4] ;
  logic        tcm_dec_tmu_hd__oval         ;
  symb_hd_t    tcm_dec_tmu_hd__ohd          ;




  tcm_dec_tmu_hd
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_dec_tmu_hd
  (
    .iclk    ( tcm_dec_tmu_hd__iclk    ) ,
    .ireset  ( tcm_dec_tmu_hd__ireset  ) ,
    .iclkena ( tcm_dec_tmu_hd__iclkena ) ,
    .ival    ( tcm_dec_tmu_hd__ival    ) ,
    .isymb_m ( tcm_dec_tmu_hd__isymb_m ) ,
    .oval    ( tcm_dec_tmu_hd__oval    ) ,
    .ohd     ( tcm_dec_tmu_hd__ohd     )
  );


  assign tcm_dec_tmu_hd__iclk    = '0 ;
  assign tcm_dec_tmu_hd__ireset  = '0 ;
  assign tcm_dec_tmu_hd__iclkena = '0 ;
  assign tcm_dec_tmu_hd__ival    = '0 ;
  assign tcm_dec_tmu_hd__isymb_m = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_tmu_hd.sv
// Description   : get hard decision for 4D symbol : compare and seelct maximum metric for each symbol inside 4D
//

`include "define.vh"

module tcm_dec_tmu_hd
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isymb_m ,
  //
  oval    ,
  ohd
);

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic     iclk        ;
  input  logic     ireset      ;
  input  logic     iclkena     ;
  //
  input  logic     ival        ;
  input  symb_m_t  isymb_m [4] ;
  //
  output logic     oval        ;
  output symb_hd_t ohd         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0]  val;

  symb_m_value_t symb_m   [4][2];
  logic [1 : 0]  symb_idx [4][2];

  //------------------------------------------------------------------------------------------------------
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
    bit decision2;
    //
    if (iclkena) begin
      if (ival) begin
        for (int i = 0; i < 4; i++) begin
          for (int j = 0; j < 2; j++) begin
            decision2 = max2(isymb_m[i][2*j+0], isymb_m[i][2*j+1]);
            //
            symb_m  [i][j] <= isymb_m[i][2*j + decision2];
            symb_idx[i][j] <=            2*j + decision2;
          end
        end
      end
      //
      if (val[0]) begin
        for (int i = 0; i < 4; i++) begin
          decision2 = max2(symb_m[i][0], symb_m[i][1]);
          //
          ohd[i] <= symb_idx[i][decision2];
        end
      end
    end
  end

  assign oval = val[1];

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  function automatic bit max2 (input symb_m_value_t a0, a1);
    max2 = (a1 > a0);
  endfunction

endmodule
