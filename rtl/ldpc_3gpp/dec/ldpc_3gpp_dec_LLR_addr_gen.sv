/*



  parameter int pADDR_W       = 8 ;
  parameter int pROW_BY_CYCLE = 8 ;



  logic                   ldpc_3gpp_dec_LLR_addr_gen__iclk                       ;
  logic                   ldpc_3gpp_dec_LLR_addr_gen__ireset                     ;
  logic                   ldpc_3gpp_dec_LLR_addr_gen__iclkena                    ;
  //
  hb_zc_t                 ldpc_3gpp_dec_LLR_addr_gen__iused_zc                   ;
  logic                   ldpc_3gpp_dec_LLR_addr_gen__ic_nv_mode                 ;
  //
  logic                   ldpc_3gpp_dec_LLR_addr_gen__iread                      ;
  logic                   ldpc_3gpp_dec_LLR_addr_gen__irstart                    ;
  logic                   ldpc_3gpp_dec_LLR_addr_gen__irmask     [pROW_BY_CYCLE] ;
  logic                   ldpc_3gpp_dec_LLR_addr_gen__irval                      ;
  strb_t                  ldpc_3gpp_dec_LLR_addr_gen__irstrb                     ;
  //
  logic   [pADDR_W-1 : 0] ldpc_3gpp_dec_LLR_addr_gen__oLLR_raddr                 ;
  //
  logic                   ldpc_3gpp_dec_LLR_addr_gen__orval                      ;
  strb_t                  ldpc_3gpp_dec_LLR_addr_gen__orstrb                     ;
  logic                   ldpc_3gpp_dec_LLR_addr_gen__ormask     [pROW_BY_CYCLE] ;



  ldpc_3gpp_dec_LLR_addr_gen
  #(
    .pADDR_W       ( pADDR_W       ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE )
  )
  ldpc_3gpp_dec_LLR_addr_gen
  (
    .iclk       ( ldpc_3gpp_dec_LLR_addr_gen__iclk       ) ,
    .ireset     ( ldpc_3gpp_dec_LLR_addr_gen__ireset     ) ,
    .iclkena    ( ldpc_3gpp_dec_LLR_addr_gen__iclkena    ) ,
    //
    .iused_zc   ( ldpc_3gpp_dec_LLR_addr_gen__iused_zc   ) ,
    .ic_nv_mode ( ldpc_3gpp_dec_LLR_addr_gen__ic_nv_mode ) ,
    //
    .iread      ( ldpc_3gpp_dec_LLR_addr_gen__iread      ) ,
    .irstart    ( ldpc_3gpp_dec_LLR_addr_gen__irstart    ) ,
    .irmask     ( ldpc_3gpp_dec_LLR_addr_gen__irmask     ) ,
    .irval      ( ldpc_3gpp_dec_LLR_addr_gen__irval      ) ,
    .irstrb     ( ldpc_3gpp_dec_LLR_addr_gen__irstrb     ) ,
    //
    .oLLR_raddr ( ldpc_3gpp_dec_LLR_addr_gen__oLLR_raddr ) ,
    //
    .orval      ( ldpc_3gpp_dec_LLR_addr_gen__orval      ) ,
    .orstrb     ( ldpc_3gpp_dec_LLR_addr_gen__orstrb     ) ,
    .ormask     ( ldpc_3gpp_dec_LLR_addr_gen__ormask     )
  );


  assign ldpc_3gpp_dec_LLR_addr_gen__iclk       = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__ireset     = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__iclkena    = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__iused_zc   = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__ic_nv_mode = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__iread      = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__irstart    = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__irmask     = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__irval      = '0 ;
  assign ldpc_3gpp_dec_LLR_addr_gen__irstrb     = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_LLR_addr_gen.sv
// Description   : read addres generation module for data LLR at vnode processing
//                 and parity LLR at cnode processing
//                 parity LLR mask read delay 4 tick (2 address generator + 2 ram)
//

module ldpc_3gpp_dec_LLR_addr_gen
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  iused_zc   ,
  ic_nv_mode ,
  //
  iread      ,
  irstart    ,
  irmask     ,
  irval      ,
  irstrb     ,
  //
  oLLR_raddr ,
  //
  orval      ,
  orstrb     ,
  ormask
);

  parameter int pADDR_W = 8;

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk                       ;
  input  logic                 ireset                     ;
  input  logic                 iclkena                    ;
  //
  input  hb_zc_t               iused_zc                   ;
  input  logic                 ic_nv_mode                 ;
  //
  input  logic                 iread                      ;
  input  logic                 irstart                    ;
  input  logic                 irmask     [pROW_BY_CYCLE] ;
  input  logic                 irval                      ;
  input  strb_t                irstrb                     ;
  //
  output logic [pADDR_W-1 : 0] oLLR_raddr                 ;
  //
  output logic                 orval                      ;
  output strb_t                orstrb                     ;
  output logic                 ormask     [pROW_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pADDR_W-1 : 0]  row_raddr;

  struct packed {
    logic   done;
    hb_zc_t value;
  } zc_rcnt;

  logic [3 : 0] rval;
  strb_t        rstrb [4]; // ram (2) + address (2)
  logic         rmask [4][pROW_BY_CYCLE];

  //------------------------------------------------------------------------------------------------------
  //  cnode : zc  -> row (get full horizontal line in one row)
  //  vnode : row ->  zc (get full vertical   line in some rows)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      rval  <= '0;
    end
    else if (iclkena) begin
      rval <= (rval << 1) | iread;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < $size(rstrb); i++) begin
        rstrb[i] <= (i == 0) ? irstrb : rstrb[i-1];
        rmask[i] <= (i == 0) ? irmask : rmask[i-1];
      end

      if (iread) begin
        if (ic_nv_mode) begin // cnode mode
          if (irstrb.sof & irstrb.sop) begin
            zc_rcnt   <= '0;
            row_raddr <= '0;
          end
          else if (irstrb.sop) begin
            zc_rcnt   <= '0;
            row_raddr <= row_raddr + iused_zc;
          end
          else begin
            zc_rcnt.value <= zc_rcnt.done   ? '0    : (zc_rcnt.value + 1'b1);
            zc_rcnt.done  <= (iused_zc < 2) ? 1'b1  : (zc_rcnt.value == iused_zc-2);
          end
        end
        else begin  // vnode mode
          if (irstrb.sof & irstrb.sop) begin
            row_raddr     <= '0;
            zc_rcnt       <= '0;
          end
          else if (irstrb.sop) begin
            row_raddr     <= '0;
            zc_rcnt.value <= zc_rcnt.value + 1'b1;
          end
          else begin
            row_raddr     <= row_raddr + iused_zc;
          end
        end // ic_nv_mode
      end // iread
      //
      oLLR_raddr <= row_raddr + zc_rcnt.value;
    end // iclkena
  end // iclk

  assign orval  = rval [3]; // 2 + 2 tick
  assign orstrb = rstrb[3];
  assign ormask = rmask[3];

endmodule
