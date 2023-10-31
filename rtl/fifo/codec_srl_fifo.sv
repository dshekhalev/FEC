/*



  parameter int pDEPTH_W = 8 ;
  parameter int pDAT_W   = 8 ;
  parameter bit pNO_REG  = 0 ;



  logic                codec_srl_fifo__iclk    ;
  logic                codec_srl_fifo__ireset  ;
  logic                codec_srl_fifo__iclkena ;
  //
  logic                codec_srl_fifo__iclear  ;
  //
  logic                codec_srl_fifo__iwrite  ;
  logic [pDAT_W-1 : 0] codec_srl_fifo__iwdat   ;
  //
  logic                codec_srl_fifo__iread   ;
  logic                codec_srl_fifo__orval   ;
  logic [pDAT_W-1 : 0] codec_srl_fifo__ordat   ;
  //
  logic                codec_srl_fifo__oempty  ;
  logic                codec_srl_fifo__ofull   ;



  codec_srl_fifo
  #(
    .pDEPTH_W ( pDEPTH_W ) ,
    .pDAT_W   ( pDAT_W   ) ,
    .pNO_REG  ( pNO_REG  )
  )
  codec_srl_fifo
  (
    .iclk    ( codec_srl_fifo__iclk    ) ,
    .ireset  ( codec_srl_fifo__ireset  ) ,
    .iclkena ( codec_srl_fifo__iclkena ) ,
    //
    .iclear  ( codec_srl_fifo__iclear  ) ,
    //
    .iwrite  ( codec_srl_fifo__iwrite  ) ,
    .iwdat   ( codec_srl_fifo__iwdat   ) ,
    //
    .iread   ( codec_srl_fifo__iread   ) ,
    .orval   ( codec_srl_fifo__orval   ) ,
    .ordat   ( codec_srl_fifo__ordat   ) ,
    //
    .oempty  ( codec_srl_fifo__oempty  ) ,
    .ofull   ( codec_srl_fifo__ofull   )
  );


  assign codec_srl_fifo__iclk    = '0 ;
  assign codec_srl_fifo__ireset  = '0 ;
  assign codec_srl_fifo__iclkena = '0 ;
  assing codec_srl_fifo__iclear  = '0 ;
  assign codec_srl_fifo__iwrite  = '0 ;
  assign codec_srl_fifo__iwdat   = '0 ;
  assign codec_srl_fifo__iread   = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_srl_fifo.sv
// Description   : Small SRL based fifo with output delay 0/1 tick
//

module codec_srl_fifo
#(
  parameter int pDEPTH_W = 8 ,
  parameter int pDAT_W   = 8 ,
  parameter bit pNO_REG  = 0
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
  output logic                orval   ;
  output logic [pDAT_W-1 : 0] ordat   ;
  //
  output logic                oempty  ;
  output logic                ofull   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit     [pDAT_W-1 : 0] ram [2**pDEPTH_W];

  logic [pDEPTH_W   : 0] cnt; // + 1 bit for correct work

  //------------------------------------------------------------------------------------------------------
  // pointers
  //------------------------------------------------------------------------------------------------------

  wire write = iwrite & !ofull;
  wire read  = iread  & !oempty;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      cnt <= '0;
    end
    else if (iclkena) begin
      if (iclear) begin
        cnt <= '0;
      end
      else if (write ^ read) begin
        cnt <= write ? (cnt + 1'b1) : (cnt - 1'b1);
      end
    end
  end

  assign oempty = (cnt == 0);
  assign ofull  = cnt[pDEPTH_W];

  //------------------------------------------------------------------------------------------------------
  // ram write
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (write) begin
        ram[0] <= iwdat;
        for (int i = 1; i < 2**pDEPTH_W; i++) begin
          ram[i] <= ram[i-1];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram read
  //------------------------------------------------------------------------------------------------------

  generate
    if (pNO_REG) begin
      assign orval = read;
      assign ordat = ram[cnt - 1'b1];
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
          ordat <= ram[cnt - 1'b1];
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

