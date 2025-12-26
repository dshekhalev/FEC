/*



  parameter int pLLR_W            = 4 ;
  parameter int pNODE_W           = 8 ;
  parameter bit pDO_LLR_INVERSION = 0 ;



  logic      ldpc_dvb_dec_vnode_sum__iclk              ;
  logic      ldpc_dvb_dec_vnode_sum__ireset            ;
  logic      ldpc_dvb_dec_vnode_sum__iclkena           ;
  //
  logic      ldpc_dvb_dec_vnode_sum__iload_iter        ;
  //
  logic      ldpc_dvb_dec_vnode_sum__ival              ;
  strb_t     ldpc_dvb_dec_vnode_sum__istrb             ;
  llr_t      ldpc_dvb_dec_vnode_sum__iLLR              ;
  node_t     ldpc_dvb_dec_vnode_sum__icnode            ;
  //
  logic      ldpc_dvb_dec_vnode_sum__ovnode_val        ;
  node_sum_t ldpc_dvb_dec_vnode_sum__ovnode_sum        ;
  node_num_t ldpc_dvb_dec_vnode_sum__ovnode_num_m1     ;
  logic      ldpc_dvb_dec_vnode_sum__ovnode_hd         ;
  //
  logic      ldpc_dvb_dec_vnode_sum__ovnode_pre_val    ;
  node_num_t ldpc_dvb_dec_vnode_sum__ovnode_pre_num_m1 ;
  //
  logic      ldpc_dvb_dec_vnode_sum__obitval           ;
  logic      ldpc_dvb_dec_vnode_sum__obitsop           ;
  logic      ldpc_dvb_dec_vnode_sum__obiteop           ;
  logic      ldpc_dvb_dec_vnode_sum__obitdat           ;
  logic      ldpc_dvb_dec_vnode_sum__obiterr           ;
  col_t      ldpc_dvb_dec_vnode_sum__obitaddr          ;



  ldpc_dvb_dec_vnode_sum
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pNODE_W           ( pNODE_W           ) ,
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  ldpc_dvb_dec_vnode_sum
  (
    .iclk              ( ldpc_dvb_dec_vnode_sum__iclk              ) ,
    .ireset            ( ldpc_dvb_dec_vnode_sum__ireset            ) ,
    .iclkena           ( ldpc_dvb_dec_vnode_sum__iclkena           ) ,
    //
    .iload_iter        ( ldpc_dvb_dec_vnode_sum__iload_iter        ) ,
    //
    .ival              ( ldpc_dvb_dec_vnode_sum__ival              ) ,
    .istrb             ( ldpc_dvb_dec_vnode_sum__istrb             ) ,
    .iLLR              ( ldpc_dvb_dec_vnode_sum__iLLR              ) ,
    .icnode            ( ldpc_dvb_dec_vnode_sum__icnode            ) ,
    //
    .ovnode_val        ( ldpc_dvb_dec_vnode_sum__ovnode_val        ) ,
    .ovnode_sum        ( ldpc_dvb_dec_vnode_sum__ovnode_sum        ) ,
    .ovnode_num_m1     ( ldpc_dvb_dec_vnode_sum__ovnode_num_m1     ) ,
    .ovnode_hd         ( ldpc_dvb_dec_vnode_sum__ovnode_hd         ) ,
    //
    .ovnode_pre_val    ( ldpc_dvb_dec_vnode_sum__ovnode_pre_val    ) ,
    .ovnode_pre_num_m1 ( ldpc_dvb_dec_vnode_sum__ovnode_pre_num_m1 ) ,
    //
    .obitval           ( ldpc_dvb_dec_vnode_sum__obitval           ) ,
    .obitsop           ( ldpc_dvb_dec_vnode_sum__obitsop           ) ,
    .obiteop           ( ldpc_dvb_dec_vnode_sum__obiteop           ) ,
    .obitdat           ( ldpc_dvb_dec_vnode_sum__obitdat           ) ,
    .obiterr           ( ldpc_dvb_dec_vnode_sum__obiterr           ) ,
    .obitaddr          ( ldpc_dvb_dec_vnode_sum__obitaddr          )
  );


  assign ldpc_dvb_dec_vnode_sum__iclk       = '0 ;
  assign ldpc_dvb_dec_vnode_sum__ireset     = '0 ;
  assign ldpc_dvb_dec_vnode_sum__iclkena    = '0 ;
  assign ldpc_dvb_dec_vnode_sum__iload_iter = '0 ;
  assign ldpc_dvb_dec_vnode_sum__ival       = '0 ;
  assign ldpc_dvb_dec_vnode_sum__istrb      = '0 ;
  assign ldpc_dvb_dec_vnode_sum__iLLR       = '0 ;
  assign ldpc_dvb_dec_vnode_sum__icnode     = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_vnode_sum.sv
// Description   : cnode accumulator for vertical step
//

module ldpc_dvb_dec_vnode_sum
(
  iclk              ,
  ireset            ,
  iclkena           ,
  //
  iload_iter        ,
  //
  ival              ,
  istrb             ,
  iLLR              ,
  icnode            ,
  icol_idx          ,
  //
  ovnode_val        ,
  ovnode_sum        ,
  ovnode_num_m1     ,
  ovnode_hd         ,
  //
  ovnode_pre_val    ,
  ovnode_pre_num_m1 ,
  //
  obitval           ,
  obitsop           ,
  obiteop           ,
  obitdat           ,
  obiterr           ,
  obitaddr
);

  parameter bit pDO_LLR_INVERSION = 0;

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk              ;
  input  logic      ireset            ;
  input  logic      iclkena           ;
  //
  input  logic      iload_iter        ; // use for decoder bypass
  //
  input  logic      ival              ;
  input  strb_t     istrb             ;
  input  llr_t      iLLR              ;
  input  node_t     icnode            ;
  input  col_t      icol_idx          ;
  //
  output logic      ovnode_val        ;
  output node_sum_t ovnode_sum        ;
  output node_num_t ovnode_num_m1     ;
  output logic      ovnode_hd         ; // special for syndrome
  //
  output logic      ovnode_pre_val    ; // look ahead decision (-1 tick)
  output node_num_t ovnode_pre_num_m1 ;
  //
  output logic      obitval           ;
  output logic      obitsop           ;
  output logic      obiteop           ;
  output logic      obitdat           ;
  output logic      obiterr           ;
  output col_t      obitaddr          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  strb_t strb;
  logic  hdbit;

  //------------------------------------------------------------------------------------------------------
  // vnode accumulator
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ovnode_val <= 1'b0;
    end
    else if (iclkena) begin
      ovnode_val <= ival & istrb.eop;
    end
  end

  assign ovnode_pre_val = ival & istrb.eop;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      strb  <= istrb;
      //
      hdbit <= pDO_LLR_INVERSION ? (iLLR <= 0) : (iLLR < 0);
      //
      if (ival) begin
        ovnode_sum        <= (istrb.sop ? iLLR : ovnode_sum) + icnode;
        ovnode_num_m1     <=  istrb.sop ? 0    : (ovnode_num_m1 + 1'b1);
        ovnode_pre_num_m1 <=  istrb.sop ? 1'b1 : (ovnode_pre_num_m1 + 1'b1); // look ahead
      end
      //
      if (ival & istrb.sof & istrb.sop) begin
        obitsop <= 1'b1;
      end
      else if (obitval) begin
        obitsop <= 1'b0;
      end
      // icol_idx hold for all cnodes
      obitaddr <= icol_idx;
    end
  end

  // register is outside
  assign ovnode_hd = pDO_LLR_INVERSION ? (ovnode_sum <= 0) : (ovnode_sum < 0);

  //------------------------------------------------------------------------------------------------------
  // hard decision and bit interface
  // there is register outside of module (!!!)
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    obitval = ovnode_val;
    obiteop = strb.eof;
    //
    if (iload_iter) begin
      obitdat = hdbit;
      obiterr = '0;
    end
    else begin
      obitdat = pDO_LLR_INVERSION ? (ovnode_sum <= 0) : (ovnode_sum < 0);
      obiterr = obitdat ^ hdbit; // can do so, because LLR and it's HD hold at least 2 cycles while vnode counting
    end
  end

endmodule
