/*



  parameter int pLLR_W  = 4 ;
  parameter int pNODE_W = 8 ;



  logic         ldpc_dvb_dec_cnode_restore__iclk        ;
  logic         ldpc_dvb_dec_cnode_restore__ireset      ;
  logic         ldpc_dvb_dec_cnode_restore__iclkena     ;
  //
  logic         ldpc_dvb_dec_cnode_restore__istart      ;
  //
  logic         ldpc_dvb_dec_cnode_restore__ival        ;
  min_col_idx_t ldpc_dvb_dec_cnode_restore__ivnode_idx  ;
  logic         ldpc_dvb_dec_cnode_restore__ivnode_sign ;
  logic         ldpc_dvb_dec_cnode_restore__ivnode_mask ;
  vn_min_t      ldpc_dvb_dec_cnode_restore__ivn_min     ;
  cnode_ctx_t   ldpc_dvb_dec_cnode_restore__icnode_ctx  ;
  //
  logic         ldpc_dvb_dec_cnode_restore__ocnode_val  ;
  cnode_ctx_t   ldpc_dvb_dec_cnode_restore__ocnode_ctx  ;
  node_t        ldpc_dvb_dec_cnode_restore__ocnode      ;



  ldpc_dvb_dec_cnode_restore
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pNODE_W ( pNODE_W )
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

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk        ;
  input  logic         ireset      ;
  input  logic         iclkena     ;
  //
  input  logic         istart      ;
  //
  input  logic         ival        ;
  input  vn_min_col_t  ivnode_idx  ;
  input  logic         ivnode_sign ;
  input  logic         ivnode_mask ;
  input  vn_min_t      ivn_min     ;
  input  cnode_ctx_t   icnode_ctx  ;
  //
  output logic         ocnode_val  ;
  output cnode_ctx_t   ocnode_ctx  ;
  output node_t        ocnode      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------


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
      //
      ocnode_ctx <= icnode_ctx;
      //
      if (ivnode_mask & icnode_ctx.mask_0_bit) begin
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

  function automatic node_t unpack_cnode (input vnode_t min1, min2, input logic min2_sel, sign);
    vnode_t cn_abs;
  begin
    cn_abs       = min2_sel ? min2 : min1;
    unpack_cnode = (cn_abs ^ {pNODE_W{sign}}) + sign;
  end
  endfunction

endmodule
