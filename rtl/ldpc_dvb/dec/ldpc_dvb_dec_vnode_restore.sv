/*



  parameter int pLLR_W       = 4 ;
  parameter int pNODE_W      = 8 ;
  parameter bit pUSE_SC_MODE = 6 ;



  logic        ldpc_dvb_dec_vnode_restore__iclk         ;
  logic        ldpc_dvb_dec_vnode_restore__ireset       ;
  logic        ldpc_dvb_dec_vnode_restore__iclkena      ;
  //
  logic        ldpc_dvb_dec_vnode_restore__istate_init  ;
  //
  logic        ldpc_dvb_dec_vnode_restore__ival         ;
  cycle_idx_t  ldpc_dvb_dec_vnode_restore__ivnode_addr  ;
  node_state_t ldpc_dvb_dec_vnode_restore__ivnode_state ;
  node_t       ldpc_dvb_dec_vnode_restore__icnode       ;
  node_sum_t   ldpc_dvb_dec_vnode_restore__ivnode_sum   ;
  logic        ldpc_dvb_dec_vnode_restore__ivnode_hd    ;
  //
  logic        ldpc_dvb_dec_vnode_restore__ovnode_val   ;
  cycle_idx_t  ldpc_dvb_dec_vnode_restore__ovnode_addr  ;
  node_t       ldpc_dvb_dec_vnode_restore__ovnode       ;
  logic        ldpc_dvb_dec_vnode_restore__ovnode_hd    ;
  node_state_t ldpc_dvb_dec_vnode_restore__ovnode_state ;



  ldpc_dvb_dec_vnode_restore
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pNODE_W      ( pNODE_W      ) ,
    .pUSE_SC_MODE ( pUSE_SC_MODE )
  )
  ldpc_dvb_dec_vnode_restore
  (
    .iclk         ( ldpc_dvb_dec_vnode_restore__iclk         ) ,
    .ireset       ( ldpc_dvb_dec_vnode_restore__ireset       ) ,
    .iclkena      ( ldpc_dvb_dec_vnode_restore__iclkena      ) ,
    //
    .istate_init  ( ldpc_dvb_dec_vnode_restore__istate_init  ) ,
    //
    .ival         ( ldpc_dvb_dec_vnode_restore__ival         ) ,
    .ivnode_addr  ( ldpc_dvb_dec_vnode_restore__ivnode_addr  ) ,
    .ivnode_state ( ldpc_dvb_dec_vnode_restore__ivnode_state ) ,
    .icnode       ( ldpc_dvb_dec_vnode_restore__icnode       ) ,
    .ivnode_sum   ( ldpc_dvb_dec_vnode_restore__ivnode_sum   ) ,
    .ivnode_hd    ( ldpc_dvb_dec_vnode_restore__ivnode_hd    ) ,
    //
    .ovnode_val   ( ldpc_dvb_dec_vnode_restore__ovnode_val   ) ,
    .ovnode_addr  ( ldpc_dvb_dec_vnode_restore__ovnode_addr  ) ,
    .ovnode       ( ldpc_dvb_dec_vnode_restore__ovnode       ) ,
    .ovnode_hd    ( ldpc_dvb_dec_vnode_restore__ovnode_hd    ) ,
    .ovnode_state ( ldpc_dvb_dec_vnode_restore__ovnode_state )
  );


  assign ldpc_dvb_dec_vnode_restore__iclk         = '0 ;
  assign ldpc_dvb_dec_vnode_restore__ireset       = '0 ;
  assign ldpc_dvb_dec_vnode_restore__iclkena      = '0 ;
  assign ldpc_dvb_dec_vnode_restore__istate_init  = '0 ;
  assign ldpc_dvb_dec_vnode_restore__ival         = '0 ;
  assign ldpc_dvb_dec_vnode_restore__ivnode_addr  = '0 ;
  assign ldpc_dvb_dec_vnode_restore__ivnode_sum   = '0 ;
  assign ldpc_dvb_dec_vnode_restore__ivnode_hd    = '0 ;
  assign ldpc_dvb_dec_vnode_restore__icnode       = '0 ;
  assign ldpc_dvb_dec_vnode_restore__ivnode_state = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_vnode_restore.sv
// Description   : vnode restore for vertical step with optional self-corrected algorithm
//

module ldpc_dvb_dec_vnode_restore
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  istate_init  ,
  //
  ival         ,
  ivnode_addr  ,
  ivnode_state ,
  icnode       ,
  ivnode_sum   ,
  ivnode_hd    ,
  //
  ovnode_val   ,
  ovnode_addr  ,
  ovnode       ,
  ovnode_hd    ,
  ovnode_state
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic        iclk         ;
  input  logic        ireset       ;
  input  logic        iclkena      ;
  //
  input  logic        istate_init  ;
  //
  input  logic        ival         ;
  input  cycle_idx_t  ivnode_addr  ;
  input  node_state_t ivnode_state ;
  input  node_t       icnode       ;
  input  node_sum_t   ivnode_sum   ;
  input  logic        ivnode_hd    ;
  //
  output logic        ovnode_val   ;
  output cycle_idx_t  ovnode_addr  ;
  output node_t       ovnode       ;
  output logic        ovnode_hd    ;
  output node_state_t ovnode_state ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] val;

  node_sum_t    vnode;
  logic         vnode_hd;
  cycle_idx_t   vnode_addr;
  node_state_t  vnode_state;

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

  assign ovnode_val = val[1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      vnode       <= ivnode_sum - icnode;
      vnode_hd    <= ivnode_hd;
      vnode_addr  <= ivnode_addr;
      //
      ovnode_hd   <= vnode_hd;
      ovnode_addr <= vnode_addr;
    end
  end

  wire vnode_sign = vnode[$high(vnode)];

  generate
    if (pUSE_SC_MODE) begin

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          vnode_state <= ivnode_state;
          //
          ovnode      <= saturate(vnode);
          //
          if (istate_init) begin
            ovnode_state.pre_sign <= 1'b0;
            ovnode_state.pre_zero <= 1'b1;
          end
          else begin
            ovnode_state.pre_sign <= vnode_sign;
            ovnode_state.pre_zero <= 1'b0;
            if (!vnode_state.pre_zero) begin // if was not zero
              if (vnode_state.pre_sign ^ vnode_sign) begin // sign change -> clear vnode
                ovnode_state.pre_sign <= 1'b0;
                ovnode_state.pre_zero <= 1'b1;
                ovnode                <= '0;
              end
            end
          end // istate init
        end // iclkena
      end // iclk

    end
    else begin

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          ovnode <= saturate(vnode);
        end
      end

      assign ovnode_state = '0;

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // usefull function
  //------------------------------------------------------------------------------------------------------

  function automatic node_t saturate (input node_sum_t dat);
    logic                             sign;
    logic [cNODE_SUM_W-1 : pNODE_W-1] sbits;
    logic                             overflow;
  begin
    sign      = dat[cNODE_SUM_W-1];
    //
    sbits     = sign ? ~dat[cNODE_SUM_W-1 : pNODE_W-1] : dat[cNODE_SUM_W-1 : pNODE_W-1];
    //
    overflow  = (sbits != 0);
    //
    saturate  = overflow ? {sign, {(pNODE_W-2){~sign}}, 1'b1} : dat[pNODE_W-1 : 0];
  end
  endfunction

endmodule
