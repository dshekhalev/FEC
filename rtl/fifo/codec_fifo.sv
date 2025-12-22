/*



  parameter int pDEPTH_W = 8 ;
  parameter int pDAT_W   = 8 ;
  parameter bit pNO_REG  = 0 ;



  logic                codec_fifo__iclk    ;
  logic                codec_fifo__ireset  ;
  logic                codec_fifo__iclkena ;
  //
  logic                codec_fifo__iclear  ;
  //
  logic                codec_fifo__iwrite  ;
  logic [pDAT_W-1 : 0] codec_fifo__iwdat   ;
  //
  logic                codec_fifo__iread   ;
  logic                codec_fifo__orval   ;
  logic [pDAT_W-1 : 0] codec_fifo__ordat   ;
  //
  logic                codec_fifo__oempty  ;
  logic                codec_fifo__ofull   ;
  logic                codec_fifo__ohfull  ;
  logic [pDEPTH_W : 0] codec_fifo__ousedw  ;



  codec_fifo
  #(
    .pDEPTH_W ( pDEPTH_W ) ,
    .pDAT_W   ( pDAT_W   ) ,
    .pNO_REG  ( pNO_REG  )
  )
  codec_fifo
  (
    .iclk    ( codec_fifo__iclk    ) ,
    .ireset  ( codec_fifo__ireset  ) ,
    .iclkena ( codec_fifo__iclkena ) ,
    //
    .iclear  ( codec_fifo__iclear  ) ,
    //
    .iwrite  ( codec_fifo__iwrite  ) ,
    .iwdat   ( codec_fifo__iwdat   ) ,
    //
    .iread   ( codec_fifo__iread   ) ,
    .orval   ( codec_fifo__orval   ) ,
    .ordat   ( codec_fifo__ordat   ) ,
    //
    .oempty  ( codec_fifo__oempty  ) ,
    .ofull   ( codec_fifo__ofull   ) ,
    .ohfull  ( codec_fifo__ohfull  ) ,
    .ousedw  ( codec_fifo__ousedw  )
  );


  assign codec_fifo__iclk    = '0 ;
  assign codec_fifo__ireset  = '0 ;
  assign codec_fifo__iclkena = '0 ;
  assign codec_fifo__iclear  = '0 ;
  assign codec_fifo__iwrite  = '0 ;
  assign codec_fifo__iwdat   = '0 ;
  assign codec_fifo__iread   = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_fifo.sv
// Description   : Small synchronus distributed RAM based fifo with output delay 0/1 tick
//

module codec_fifo
#(
  parameter int pDEPTH_W = 5 ,
  parameter int pDAT_W   = 8 ,
  parameter bit pNO_REG  = 0    // read delay 0(no register)/1(register) tick
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iclear  ,
  //
  iwrite  ,
  iwdat   ,
  //
  iread   ,
  orval   ,
  ordat   ,
  //
  oempty  ,
  ofull   ,
  ohfull  ,
  ousedw
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                iclear  ;
  //
  input  logic                iwrite  ;
  input  logic [pDAT_W-1 : 0] iwdat   ;
  //
  input  logic                iread   ;
  output logic                orval   ;
  output logic [pDAT_W-1 : 0] ordat   ;
  //
  output logic                oempty  ;
  output logic                ofull   ;
  output logic                ohfull  ;
  output logic [pDEPTH_W : 0] ousedw  ; // + 1 bit for full width

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  (* ram_style = "distributed" *) bit [pDAT_W-1 : 0] ram [2**pDEPTH_W];

  logic [pDEPTH_W-1 : 0] waddr;
  logic [pDEPTH_W-1 : 0] raddr;
  logic [pDEPTH_W   : 0] cnt; // + 1 bit for overflow check

  //------------------------------------------------------------------------------------------------------
  // pointers
  //------------------------------------------------------------------------------------------------------

  wire write = iwrite & !ofull;
  wire read  = iread  & !oempty;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      waddr <= '0;
      raddr <= '0;
      //
      cnt   <= '0;
    end
    else if (iclkena) begin
      if (iclear) begin
        waddr <= '0;
        raddr <= '0;
        //
        cnt   <= '0;
      end
      else begin
        if (write) begin
          waddr <= waddr + 1'b1;
        end
        if (read) begin
          raddr <= raddr + 1'b1;
        end
        //
        if (write ^ read) begin
          cnt <= write ? (cnt + 1'b1) : (cnt - 1'b1);
        end
      end
    end
  end

  assign oempty = (cnt == 0);
  assign ofull  = cnt[pDEPTH_W];
  assign ohfull = cnt[pDEPTH_W] | cnt[pDEPTH_W-1];
  assign ousedw = cnt;

  //------------------------------------------------------------------------------------------------------
  // ram write
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (write) begin
        ram[waddr] <= iwdat;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram read
  //------------------------------------------------------------------------------------------------------

  generate
    if (pNO_REG) begin
      assign orval = read;
      assign ordat = ram[raddr];
    end
    else begin
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          orval <= 1'b0;
        end
        else if (iclkena) begin
          orval <= read;
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          ordat <= ram[raddr];
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // synthesis translate_off
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite & !iclear) begin
        assert (!ofull) else begin
          $error("fifo %m overflow");
          $stop;
        end
      end
      if (iread & !iclear) begin
        assert(!oempty) else begin
          $error("fifo %m underflow");
          $stop;
        end
      end
    end
  end
  // synthesis translate_on
endmodule

