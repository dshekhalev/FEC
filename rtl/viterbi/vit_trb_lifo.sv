/*


  parameter int pADDR_W = 8;
  parameter int pDAT_W  = 8;
  parameter int pBNUM_W = 1;



  logic                 vit_trb_lifo__iclk     ;
  logic                 vit_trb_lifo__ireset   ;
  logic                 vit_trb_lifo__iclkena  ;
  logic                 vit_trb_lifo__iwrite   ;
  logic                 vit_trb_lifo__iflush   ;
  logic [pADDR_W-1 : 0] vit_trb_lifo__iwaddr   ;
  logic  [pDAT_W-1 : 0] vit_trb_lifo__iwdat    ;
  logic                 vit_trb_lifo__oval     ;
  logic  [pDAT_W-1 : 0] vit_trb_lifo__odat     ;



  vit_trb_lifo
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pBNUM_W ( pBNUM_W )
  )
  vit_trb_lifo
  (
    .iclk    ( vit_trb_lifo__iclk    ) ,
    .ireset  ( vit_trb_lifo__ireset  ) ,
    .iclkena ( vit_trb_lifo__iclkena ) ,
    .iwrite  ( vit_trb_lifo__iwrite  ) ,
    .iflush  ( vit_trb_lifo__iflush  ) ,
    .iwaddr  ( vit_trb_lifo__iwaddr  ) ,
    .iwsop   ( vit_trb_lifo__iwsop   ) ,
    .iweop   ( vit_trb_lifo__iweop   ) ,
    .iwdat   ( vit_trb_lifo__iwdat   ) ,
    .osop    ( vit_trb_lifo__osop    ) ,
    .oval    ( vit_trb_lifo__oval    ) ,
    .oeop    ( vit_trb_lifo__oeop    ) ,
    .odat    ( vit_trb_lifo__odat    )
  );


  assign vit_trb_lifo__iclk    = '0 ;
  assign vit_trb_lifo__ireset  = '0 ;
  assign vit_trb_lifo__iclkena = '0 ;
  assign vit_trb_lifo__iwrite  = '0 ;
  assign vit_trb_lifo__iflush  = '0 ;
  assign vit_trb_lifo__iwaddr  = '0 ;
  assign vit_trb_lifo__iwsop   = '0 ;
  assign vit_trb_lifo__iweop   = '0 ;
  assign vit_trb_lifo__iwdat   = '0 ;



*/

//
// Project       : viterbi
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_trb_lifo.sv
// Description   : Viterbi decoder self synchronus xD LIFO. The xD buffer control is inside
//

module vit_trb_lifo
#(
  parameter int pADDR_W = 8 ,
  parameter int pDAT_W  = 8 ,
  parameter int pBNUM_W = 1   // 1/2 - 2D/4D
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iflush  ,
  iwaddr  ,
  iwdat   ,
  //
  oval    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  // write interface
  input  logic                 iwrite   ;
  input  logic                 iflush   ;
  input  logic [pADDR_W-1 : 0] iwaddr   ;
  input  logic  [pDAT_W-1 : 0] iwdat    ;
  // output interface
  output logic                 oval     ;
  output logic  [pDAT_W-1 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W = pADDR_W + pBNUM_W;

  localparam int cBNUM   = 2**pBNUM_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit [pDAT_W-1 : 0] ram [2**cADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;


  logic [pBNUM_W-1 : 0] b_wused;
  logic [pBNUM_W-1 : 0] b_rused;
  logic   [cBNUM-1 : 0] b_is_busy;

  logic [pADDR_W-1 : 0] ram_back_addr         [cBNUM];
  logic                 ram_back_addr_is_zero [cBNUM];

  logic [cADDR_W-1 : 0] ram_waddr;
  logic [cADDR_W-1 : 0] ram_raddr;

  logic         [2 : 0] rdata_val;
  logic  [pDAT_W-1 : 0] rdata    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin
    b_wused = '1;
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  wire flush_done = ram_back_addr_is_zero[b_rused] & (b_is_busy != 0);

  assign ram_waddr = {b_wused, iwaddr};

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // write direct order
      if (iwrite) begin
        ram[ram_waddr] <= iwdat;
        // buffer write side control
        if (iflush) begin
          b_wused <= b_wused + 1'b1;
          //
          ram_back_addr         [b_wused] <= iwaddr;
          ram_back_addr_is_zero [b_wused] <= (iwaddr == 0);
        end
      end

      if (b_is_busy != 0) begin
        ram_back_addr         [b_rused] <=  ram_back_addr[b_rused] - 1'b1;
        ram_back_addr_is_zero [b_rused] <= (ram_back_addr[b_rused] <= 1);
      end

      // buffer read side control :: self synchronous
      if (iwrite & iflush & (b_is_busy == 0)) begin
        b_rused <= b_wused;
      end
      else if (flush_done) begin
        b_rused <= b_rused + 1'b1;
      end

      // 3 tick read latency
      ram_raddr <= {b_rused, ram_back_addr[b_rused]};
      rdata     <= ram[ram_raddr];
      odat      <= rdata;
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      b_is_busy <= '0;
      rdata_val <= '0;
    end
    else if (iclkena) begin
      // buffer control
      for (int i = 0; i < cBNUM; i++) begin
        if (iwrite & iflush & (b_wused == i)) begin
          b_is_busy[i] <= 1'b1;
        end
        else if (flush_done & (b_rused == i)) begin
          b_is_busy[i] <= 1'b0;
        end
      end
      //
      rdata_val <= (rdata_val << 1) | (b_is_busy != 0);
    end
  end

  assign oval = rdata_val[2];

endmodule
