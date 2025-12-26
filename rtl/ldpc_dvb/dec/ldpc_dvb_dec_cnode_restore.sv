/*



  parameter int pLLR_W   = 4       ;
  parameter int pNODE_W  = 8       ;
  parameter int pCNODE_W = pNODE_W ;
  parameter int pCTX_W   = 8       ;



  logic                        ldpc_dvb_dec_cnode_restore__iclk        ;
  logic                        ldpc_dvb_dec_cnode_restore__ireset      ;
  logic                        ldpc_dvb_dec_cnode_restore__iclkena     ;
  //
  logic                        ldpc_dvb_dec_cnode_restore__istart      ;
  //
  logic                        ldpc_dvb_dec_cnode_restore__ival        ;
  min_col_idx_t                ldpc_dvb_dec_cnode_restore__ivnode_idx  ;
  logic                        ldpc_dvb_dec_cnode_restore__ivnode_sign ;
  logic                        ldpc_dvb_dec_cnode_restore__ivnode_mask ;
  vn_min_t                     ldpc_dvb_dec_cnode_restore__ivn_min     ;
  logic         [pCTX_W-1 : 0] ldpc_dvb_dec_cnode_restore__icnode_ctx  ;
  //
  logic                        ldpc_dvb_dec_cnode_restore__ocnode_val  ;
  logic         [pCTX_W-1 : 0] ldpc_dvb_dec_cnode_restore__ocnode_ctx  ;
  cnode_t                      ldpc_dvb_dec_cnode_restore__ocnode      ;



  ldpc_dvb_dec_cnode_restore
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pNODE_W  ( pNODE_W  ) ,
    .pCNODE_W ( pCNODE_W ) ,
    .pCTX_W   ( pCTX_W   )
  )
  ldpc_dvb_dec_cnode_restore
  (
    .iclk        ( ldpc_dvb_dec_cnode_restore__iclk        ) ,
    .ireset      ( ldpc_dvb_dec_cnode_restore__ireset      ) ,
    .iclkena     ( ldpc_dvb_dec_cnode_restore__iclkena     ) ,
    //
    .istart      ( ldpc_dvb_dec_cnode_restore__istart      ) ,
    //
    .ival        ( ldpc_dvb_dec_cnode_restore__ival        ) ,
    .ivnode_idx  ( ldpc_dvb_dec_cnode_restore__ivnode_idx  ) ,
    .ivnode_sign ( ldpc_dvb_dec_cnode_restore__ivnode_sign ) ,
    .ivnode_mask ( ldpc_dvb_dec_cnode_restore__ivnode_mask ) ,
    .ivn_min     ( ldpc_dvb_dec_cnode_restore__ivn_min     ) ,
    .icnode_ctx  ( ldpc_dvb_dec_cnode_restore__icnode_ctx  ) ,
    //
    .ocnode_val  ( ldpc_dvb_dec_cnode_restore__ocnode_val  ) ,
    .ocnode_ctx  ( ldpc_dvb_dec_cnode_restore__ocnode_ctx  ) ,
    .ocnode      ( ldpc_dvb_dec_cnode_restore__ocnode      )
  );


  assign ldpc_dvb_dec_cnode_restore__iclk        = '0 ;
  assign ldpc_dvb_dec_cnode_restore__ireset      = '0 ;
  assign ldpc_dvb_dec_cnode_restore__iclkena     = '0 ;
  assign ldpc_dvb_dec_cnode_restore__istart      = '0 ;
  assign ldpc_dvb_dec_cnode_restore__ival        = '0 ;
  assign ldpc_dvb_dec_cnode_restore__ivnode_idx  = '0 ;
  assign ldpc_dvb_dec_cnode_restore__ivnode_sign = '0 ;
  assign ldpc_dvb_dec_cnode_restore__ivnode_mask = '0 ;
  assign ldpc_dvb_dec_cnode_restore__ivn_min     = '0 ;
  assign ldpc_dvb_dec_cnode_restore__icnode_ctx  = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_cnode_restore.sv
// Description   : cnode restore for min-sum horizontal step
//

module ldpc_dvb_dec_cnode_restore
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  istart      ,
  //
  ival        ,
  ivnode_idx  ,
  ivnode_sign ,
  ivnode_mask ,
  ivn_min     ,
  icnode_ctx  ,
  //
  ocnode_val  ,
  ocnode_ctx  ,
  ocnode
);

  parameter int pCTX_W = 8;

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk        ;
  input  logic                       ireset      ;
  input  logic                       iclkena     ;
  //
  input  logic                       istart      ;
  //
  input  logic                       ival        ;
  input  vn_min_col_t                ivnode_idx  ;
  input  logic                       ivnode_sign ;
  input  logic                       ivnode_mask ;
  input  vn_min_t                    ivn_min     ;
  input  logic        [pCTX_W-1 : 0] icnode_ctx  ;
  //
  output logic                       ocnode_val  ;
  output logic        [pCTX_W-1 : 0] ocnode_ctx  ;
  output cnode_t                     ocnode      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ocnode_val <= 1'b0;
    end
    else if (iclkena) begin
      ocnode_val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ocnode_ctx <= icnode_ctx; // simple bypass data
      //
      if (ivnode_mask) begin  // do mask external
        ocnode <= '0;
      end
      else begin
        ocnode <= unpack_cnode(  ivn_min.min1, ivn_min.min2,
                                (ivn_min.min1_col == ivnode_idx),
                                 ivn_min.prod_sign ^ ivnode_sign);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  localparam int cCN_MAX = 2**(pCNODE_W-1);

  function automatic cnode_t unpack_cnode (input vnode_t min1, min2, input logic min2_sel, sign);
    vnode_t cn_abs;
  begin
    cn_abs       = min2_sel ? min2 : min1;
    // saturate to prevent + 2^(pCNODE_W-1) incorect inversion
    if (cn_abs >= cCN_MAX) begin
      cn_abs = cCN_MAX-1;
    end
    //
    unpack_cnode = (cn_abs ^ {pCNODE_W{sign}}) + sign;
  end
  endfunction

endmodule
