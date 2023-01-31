/*



  parameter int pDEPTH_W = 8 ;
  parameter int pDAT_W   = 8 ;



  logic                ldpc_dvb_dec_fifo__iclk    ;
  logic                ldpc_dvb_dec_fifo__ireset  ;
  logic                ldpc_dvb_dec_fifo__iclkena ;
  //
  logic                ldpc_dvb_dec_fifo__iclear  ;
  //
  logic                ldpc_dvb_dec_fifo__iwrite  ;
  logic [pDAT_W-1 : 0] ldpc_dvb_dec_fifo__iwdat   ;
  //
  logic                ldpc_dvb_dec_fifo__iread   ;
  logic [pDAT_W-1 : 0] ldpc_dvb_dec_fifo__ordat   ;
  //
  logic                ldpc_dvb_dec_fifo__oempty  ;
  logic                ldpc_dvb_dec_fifo__ofull   ;



  ldpc_dvb_dec_fifo
  #(
    .pDEPTH_W ( pDEPTH_W ) ,
    .pDAT_W   ( pDAT_W   )
  )
  ldpc_dvb_dec_fifo
  (
    .iclk    ( ldpc_dvb_dec_fifo__iclk    ) ,
    .ireset  ( ldpc_dvb_dec_fifo__ireset  ) ,
    .iclkena ( ldpc_dvb_dec_fifo__iclkena ) ,
    //
    .iclear  ( ldpc_dvb_dec_fifo__iclear  ) ,
    //
    .iwrite  ( ldpc_dvb_dec_fifo__iwrite  ) ,
    .iwdat   ( ldpc_dvb_dec_fifo__iwdat   ) ,
    //
    .iread   ( ldpc_dvb_dec_fifo__iread   ) ,
    .ordat   ( ldpc_dvb_dec_fifo__ordat   ) ,
    //
    .oempty  ( ldpc_dvb_dec_fifo__oempty  ) ,
    .ofull   ( ldpc_dvb_dec_fifo__ofull   )
  );


  assign ldpc_dvb_dec_fifo__iclk    = '0 ;
  assign ldpc_dvb_dec_fifo__ireset  = '0 ;
  assign ldpc_dvb_dec_fifo__iclkena = '0 ;
  assing ldpc_dvb_dec_fifo__iclear  = '0 ;
  assign ldpc_dvb_dec_fifo__iwrite  = '0 ;
  assign ldpc_dvb_dec_fifo__iwdat   = '0 ;
  assign ldpc_dvb_dec_fifo__iread   = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_fifo.sv
// Description   : Small RAM based fifo with output delay 1 tick
//

module ldpc_dvb_dec_fifo
#(
  parameter int pDEPTH_W = 8 ,
  parameter int pDAT_W   = 8
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
  ordat   ,
  //
  oempty  ,
  ofull
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
  output logic [pDAT_W-1 : 0] ordat   ;
  //
  output logic                oempty  ;
  output logic                ofull   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit     [pDAT_W-1 : 0] ram [2**pDEPTH_W];

  logic [pDEPTH_W-1 : 0] waddr;
  logic [pDEPTH_W-1 : 0] raddr;
  logic [pDEPTH_W   : 0] cnt; // + 1 bit for overflow check

  //------------------------------------------------------------------------------------------------------
  //
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

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (write) begin
        ram[waddr] <= iwdat;
      end
      //
      ordat <= ram[raddr];
    end
  end

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

