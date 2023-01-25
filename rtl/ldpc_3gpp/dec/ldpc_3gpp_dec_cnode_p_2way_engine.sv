/*



  parameter int pCODE          = 1 ;
  parameter int pN             = 1 ;
  parameter int pLLR_W         = 4 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_W        = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;


  logic    ldpc_3gpp_dec_cnode_p_2way_engine__iclk      ;
  logic    ldpc_3gpp_dec_cnode_p_2way_engine__ireset    ;
  logic    ldpc_3gpp_dec_cnode_p_2way_engine__iclkena   ;
  logic    ldpc_3gpp_dec_cnode_p_2way_engine__ival      ;
  vn_min_t ldpc_3gpp_dec_cnode_p_2way_engine__ivn   [2] ;
  logic    ldpc_3gpp_dec_cnode_p_2way_engine__oval      ;
  vn_min_t ldpc_3gpp_dec_cnode_p_2way_engine__ovn       ;



  ldpc_3gpp_dec_cnode_p_2way_engine
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pNODE_W ( pNODE_W )
  )
  ldpc_3gpp_dec_cnode_p_2way_engine
  (
    .iclk    ( ldpc_3gpp_dec_cnode_p_2way_engine__iclk    ) ,
    .ireset  ( ldpc_3gpp_dec_cnode_p_2way_engine__ireset  ) ,
    .iclkena ( ldpc_3gpp_dec_cnode_p_2way_engine__iclkena ) ,
    .ival    ( ldpc_3gpp_dec_cnode_p_2way_engine__ival    ) ,
    .ivn     ( ldpc_3gpp_dec_cnode_p_2way_engine__ivn     )
    .oval    ( ldpc_3gpp_dec_cnode_p_2way_engine__oval    ) ,
    .ovn     ( ldpc_3gpp_dec_cnode_p_2way_engine__ovn     )
  );


  assign ldpc_3gpp_dec_cnode_p_2way_engine__iclk    = '0 ;
  assign ldpc_3gpp_dec_cnode_p_2way_engine__ireset  = '0 ;
  assign ldpc_3gpp_dec_cnode_p_2way_engine__iclkena = '0 ;
  assign ldpc_3gpp_dec_cnode_p_2way_engine__ival    = '0 ;
  assign ldpc_3gpp_dec_cnode_p_2way_engine__ivn     = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_cnode_p_2way_engine.sv
// Description   : LDPC decoder check node arithmetic engine for parallel partial search : read 2 vnodes and do simple search
//

`include "define.vh"

module ldpc_3gpp_dec_cnode_p_2way_engine
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  ivn     ,
  //
  oval    ,
  ovn
);

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk      ;
  input  logic    ireset    ;
  input  logic    iclkena   ;
  //
  input  logic    ival      ;
  input  vn_min_t ivn   [2] ;
  //
  output logic    oval      ;
  output vn_min_t ovn       ;

  //------------------------------------------------------------------------------------------------------
  // prepare data
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

                                              // {a,b} vs {c, d}
  wire check1 = (ivn[1].min1 < ivn[0].min1);  //          (c < a) ? c : a
  wire check2 = (ivn[1].min2 < ivn[0].min1);  // c < a  ? (d < a) ? d : a
  wire check3 = (ivn[1].min1 < ivn[0].min2);  // c >= a ? (c < b) ? c : b

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (check1) begin
          ovn.min1      <= ivn[1].min1;
          ovn.min2      <= check2 ? ivn[1].min2 : ivn[0].min1;
          ovn.min1_col  <= ivn[1].min1_col;
        end
        else begin
          ovn.min1      <= ivn[0].min1;
          ovn.min2      <= check3 ? ivn[1].min1 : ivn[0].min2;
          ovn.min1_col  <= ivn[0].min1_col;
        end
      end
    end
  end

endmodule
