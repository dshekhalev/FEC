/*



  parameter bit pDEINT_MODE = 0 ;
  parameter bit pPIPE       = 0 ;



  logic           super_i3_interleave__iclk    ;
  logic           super_i3_interleave__ireset  ;
  logic           super_i3_interleave__iclkena ;
  //
  logic           super_i3_interleave__ival    ;
  logic           super_i3_interleave__isop    ;
  logic [127 : 0] super_i3_interleave__idat    ;
  //
  logic           super_i3_interleave__oval    ;
  logic           super_i3_interleave__osop    ;
  logic [127 : 0] super_i3_interleave__odat    ;



  super_i3_interleave
  #(
    .pDEINT_MODE ( pDEINT_MODE ) ,
    .pPIPE       ( pPIPE       )
  )
  super_i3_interleave
  (
    .iclk    ( super_i3_interleave__iclk    ) ,
    .ireset  ( super_i3_interleave__ireset  ) ,
    .iclkena ( super_i3_interleave__iclkena ) ,
    //
    .ival    ( super_i3_interleave__ival    ) ,
    .isop    ( super_i3_interleave__isop    ) ,
    .idat    ( super_i3_interleave__idat    ) ,
    //
    .oval    ( super_i3_interleave__oval    ) ,
    .osop    ( super_i3_interleave__osop    ) ,
    .odat    ( super_i3_interleave__odat    )
  );


  assign super_i3_interleave__iclk    = '0 ;
  assign super_i3_interleave__ireset  = '0 ;
  assign super_i3_interleave__iclkena = '0 ;
  assign super_i3_interleave__ival    = '0 ;
  assign super_i3_interleave__isop    = '0 ;
  assign super_i3_interleave__idat    = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_interleave.sv
// Description   : I.3 interleaver/Deinterleaver base upon 8*255x128 bit ram
//

module super_i3_interleave
#(
  parameter bit pDEINT_MODE = 0 , // interleave/deinterleave
  parameter bit pPIPE       = 0   // ram pipeline mode
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  idat    ,
  //
  oval    ,
  osop    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk    ;
  input  logic           ireset  ;
  input  logic           iclkena ;
  //
  input  logic           ival    ;
  input  logic           isop    ;
  input  logic [127 : 0] idat    ;
  //
  output logic           oval    ;
  output logic           osop    ;
  output logic [127 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBLOCK_NUM_W   = 3;
  localparam int cBLOCK_ADDR_W  = 8;

  localparam int cRAM_ADDR_W    = cBLOCK_NUM_W + cBLOCK_ADDR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit               [127 : 0] ram     [2**cRAM_ADDR_W];

  logic                       write;
  logic                       wsop;
  logic  [cBLOCK_NUM_W-1 : 0] wblock = '0; // can be any
  logic [cBLOCK_ADDR_W-1 : 0] waddr;
  logic             [127 : 0] wdat;

  logic  [cBLOCK_NUM_W-1 : 0] rblock;
  logic [cBLOCK_ADDR_W-1 : 0] raddr;
  bit               [127 : 0] rdat [2];
  logic               [2 : 0] rval;
  logic               [2 : 0] rsop;

  //------------------------------------------------------------------------------------------------------
  // write side : write single block (frame) 32670
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      write <= ival;
      wsop  <= ival & isop;
      wdat  <= idat;
      if (ival) begin
        wblock <= wblock + isop;
        waddr  <= isop ? '0 : (waddr + 1'b1);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // read work at write rate
  // pDEINT_MODE ? get last : get first
  //------------------------------------------------------------------------------------------------------

  always @(posedge iclk) begin
    if (iclkena) begin
      if (wsop) begin
        rblock <= pDEINT_MODE ? (wblock + 1'b1) : wblock;
        raddr  <= '0;
      end
      else if (write) begin
        if (pDEINT_MODE) begin
          rblock <= rblock + 1'b1;  // look forward
        end
        else begin
          rblock <= rblock - 1'b1;  // look back
        end
        raddr   <= raddr + 1'b1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (write) begin
        ram[{wblock, waddr}] <= wdat;
      end
      rdat[0] <= ram[{rblock, raddr}];
      rdat[1] <= rdat[0];
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      rval <= '0;
      rsop <= '0;
    end
    else if (iclkena) begin
      rval <= (rval << 1) | write;
      rsop <= (rsop << 1) | wsop;
    end
  end

  assign odat = rdat[pPIPE] ;
  assign oval = rval[pPIPE + 1] ;
  assign osop = rsop[pPIPE + 1] ;

endmodule
