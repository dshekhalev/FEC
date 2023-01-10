/*



  parameter int pDATA_W  = 32 ;
  parameter int pADDR_W  =  8 ;



  logic                 codec_map_dec_mm__iclk     ;
  logic                 codec_map_dec_mm__ireset   ;
  logic                 codec_map_dec_mm__iclkena  ;
  logic                 codec_map_dec_mm__iwrite   ;
  logic [pDATA_W-1 : 0] codec_map_dec_mm__iwdata   ;
  logic                 codec_map_dec_mm__iread    ;
  logic [pDATA_W-1 : 0] codec_map_dec_mm__ordata   ;



  codec_map_dec_mm
  #(
    .pDATA_W ( pDATA_W ) ,
    .pADDR_W ( pADDR_W )
  )
  codec_map_dec_mm
  (
    .iclk    ( codec_map_dec_mm__iclk    ) ,
    .ireset  ( codec_map_dec_mm__ireset  ) ,
    .iclkena ( codec_map_dec_mm__iclkena ) ,
    .iwrite  ( codec_map_dec_mm__iwrite  ) ,
    .iwdata  ( codec_map_dec_mm__iwdata  ) ,
    .iread   ( codec_map_dec_mm__iread   ) ,
    .ordata  ( codec_map_dec_mm__ordata  )
  );


  assign codec_map_dec_mm__iclk    = '0 ;
  assign codec_map_dec_mm__ireset  = '0 ;
  assign codec_map_dec_mm__iclkena = '0 ;
  assign codec_map_dec_mm__iwrite  = '0 ;
  assign codec_map_dec_mm__iwdata  = '0 ;
  assign codec_map_dec_mm__iread   = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_map_dec_mm.sv
// Description   : state metric memory for MAP decoder. It's FWPT LIFO. Module latency is 1 tick
//


module codec_map_dec_mm
#(
  parameter int pDATA_W  = 32 ,
  parameter int pADDR_W  =  8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwdata  ,
  //
  iread   ,
  ordata
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  logic                 iwrite   ;
  input  logic [pDATA_W-1 : 0] iwdata   ;
  //
  input  logic                 iread    ;
  output logic [pDATA_W-1 : 0] ordata   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pADDR_W-1 : 0] addr;
  logic [pADDR_W-1 : 0] ram_addr;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    ram_addr = addr;
    if (iwrite | iread)
      ram_addr = iwrite ? (addr + 1'b1) : (addr - 1'b1);
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset)
      addr <= '0;
    else if (iclkena)
      addr <= ram_addr;
  end

  logic [pDATA_W-1 : 0] ram [0 : 2**pADDR_W-1] ;

  logic [pADDR_W-1 : 0] raddr;


  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite)
        ram[ram_addr] <= iwdata;
      //
      raddr <= ram_addr;
    end
  end

  assign ordata = ram[raddr];

endmodule

// synthesis translate_off
module tb_mm ;

  parameter int pDATA_W  = 32 ;
  parameter int pADDR_W  =  8 ;



  logic                 iclk     ;
  logic                 ireset   ;
  logic                 iclkena  ;
  logic                 iwrite   ;
  logic [pDATA_W-1 : 0] iwdata   ;
  logic                 iread    ;
  logic [pDATA_W-1 : 0] ordata   ;



  codec_map_dec_mm
  #(
    .pDATA_W ( pDATA_W ) ,
    .pADDR_W ( pADDR_W )
  )
  codec_map_dec_mm
  (
    .*
  );

  initial begin
    iclk <= 1'b0;
    #5ns forever #5ns iclk = ~iclk;
  end

  initial begin
    ireset = 1'b1;
    repeat (2) @(negedge iclk);
    ireset = 1'b0;
  end

  assign iclkena  = 1'b1;

  initial begin
    iwrite <= 1'b0;
    iread  <= 1'b0;
    iwdata <= '0;
    @(posedge iclk iff ireset == 1'b0);

    for (int i = 0; i < 16; i++) begin
      if (i < 8) begin
        iwrite <= 1'b1;
        iwdata <= i + 10;
      end
//    if (i >= 7 && i <= 14) begin
//      iread <= 1'b1;
//    end
      if (i >= 8)
        iread <= 1'b1;
      @(posedge iclk);
      iwrite <= 1'b0;
      iread <= 1'b0;
    end
    repeat (3) @(posedge iclk);
  end

endmodule
// synthesis translate_on
