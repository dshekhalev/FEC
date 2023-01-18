/*



  parameter int pDATA_W = 32 ;
  parameter int pADDR_W =  8 ;
  parameter bit pAPIPE  =  0 ;
  parameter bit pDPIPE  =  0 ;


  logic                 codec_map_dec_input_ram__ireset   ;
  logic                 codec_map_dec_input_ram__iwclk    ;
  logic                 codec_map_dec_input_ram__iwclkena ;
  logic                 codec_map_dec_input_ram__iwrite   ;
  logic [pADDR_W-1 : 0] codec_map_dec_input_ram__iwaddr   ;
  logic [pDATA_W-1 : 0] codec_map_dec_input_ram__iwdata   ;
  logic                 codec_map_dec_input_ram__irclk    ;
  logic                 codec_map_dec_input_ram__irclkena ;
  logic                 codec_map_dec_input_ram__iread    ;
  logic [pADDR_W-1 : 0] codec_map_dec_input_ram__iraddr0  ;
  logic [pDATA_W-1 : 0] codec_map_dec_input_ram__ordata0  ;
  logic [pADDR_W-1 : 0] codec_map_dec_input_ram__iraddr1  ;
  logic [pDATA_W-1 : 0] codec_map_dec_input_ram__ordata1  ;


  codec_map_dec_input_ram
  #(
    .pDATA_W ( pDATA_W ) ,
    .pADDR_W ( pADDR_W ) ,
    .pAPIPE  ( pAPIPE  ) ,
    .pDPIPE  ( pDPIPE  )
  )
  codec_map_dec_input_ram
  (
    .ireset   ( codec_map_dec_input_ram__ireset   ) ,
    .iwclk    ( codec_map_dec_input_ram__iwclk    ) ,
    .iwclkena ( codec_map_dec_input_ram__iwclkena ) ,
    .iwrite   ( codec_map_dec_input_ram__iwrite   ) ,
    .iwaddr   ( codec_map_dec_input_ram__iwaddr   ) ,
    .iwdata   ( codec_map_dec_input_ram__iwdata   ) ,
    .irclk    ( codec_map_dec_input_ram__irclk    ) ,
    .irclkena ( codec_map_dec_input_ram__irclkena ) ,
    .iread    ( codec_map_dec_input_ram__iread    ) ,
    .iraddr0  ( codec_map_dec_input_ram__iraddr0  ) ,
    .ordata0  ( codec_map_dec_input_ram__ordata0  ) ,
    .iraddr1  ( codec_map_dec_input_ram__iraddr1  ) ,
    .ordata1  ( codec_map_dec_input_ram__ordata1  )
  );


  assign codec_map_dec_input_ram__ireset   = '0 ;
  assign codec_map_dec_input_ram__iwclk    = '0 ;
  assign codec_map_dec_input_ram__iwclkena = '0 ;
  assign codec_map_dec_input_ram__iwrite   = '0 ;
  assign codec_map_dec_input_ram__iwaddr   = '0 ;
  assign codec_map_dec_input_ram__iwdata   = '0 ;
  assign codec_map_dec_input_ram__irclk    = '0 ;
  assign codec_map_dec_input_ram__irclkena = '0 ;
  assign codec_map_dec_input_ram__iread    = '0 ;
  assign codec_map_dec_input_ram__iraddr0  = '0 ;
  assign codec_map_dec_input_ram__iraddr1  = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_map_dec_input_ram.sv
// Description   : input ram for MAP decoder with one write port and two concurrent switched read ports with even/odd access
//                 ram write latency is 1 tick
//                 ram read default latency is 1 tick, optionaly 2/3 tick
//

module codec_map_dec_input_ram
#(
  parameter int pDATA_W = 32 ,
  parameter int pADDR_W =  8 ,
  parameter bit pAPIPE  =  0 ,  // read address pipeline register
  parameter bit pDPIPE  =  0    // read data    pipeline register
)
(
  ireset   ,
  //
  iwclk    ,
  iwclkena ,
  //
  iwrite   ,
  iwaddr   ,
  iwdata   ,
  //
  irclk    ,
  irclkena ,
  //
  iread    ,
  iraddr0  ,
  ordata0  ,
  iraddr1  ,
  ordata1
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 ireset   ;
  //
  input  logic                 iwclk    ;
  input  logic                 iwclkena ;
  //
  input  logic                 iwrite   ;
  input  logic [pADDR_W-1 : 0] iwaddr   ;
  input  logic [pDATA_W-1 : 0] iwdata   ;
  //
  input  logic                 irclk    ;
  input  logic                 irclkena ;
  //
  input  logic                 iread    ;
  input  logic [pADDR_W-1 : 0] iraddr0  ;
  output logic [pDATA_W-1 : 0] ordata0  ;
  input  logic [pADDR_W-1 : 0] iraddr1  ;
  output logic [pDATA_W-1 : 0] ordata1  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W  = pADDR_W - 1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit   [pDATA_W-1 : 0] ram0 [2**cADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;
  bit   [pDATA_W-1 : 0] ram1 [2**cADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;

  logic [cADDR_W-1 : 0] waddr;

  logic                 rsel;

  logic [cADDR_W-1 : 0] raddr0;
  logic [cADDR_W-1 : 0] raddr1;

  logic [pDATA_W-1 : 0] rdata0;
  logic [pDATA_W-1 : 0] rdata1;

  //------------------------------------------------------------------------------------------------------
  // write side
  //------------------------------------------------------------------------------------------------------

  wire wsel     = iwaddr[0];

  wire write0   = iwrite &  wsel;
  wire write1   = iwrite & !wsel;

  assign waddr  = iwaddr[pADDR_W-1 : 1];

  always_ff @(posedge iwclk) begin
    if (iwclkena) begin
      if (write0) begin
        ram0[waddr] <= iwdata;
      end
      if (write1) begin
        ram1[waddr] <= iwdata;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // read side
  //------------------------------------------------------------------------------------------------------

  generate
    if (pAPIPE) begin
      always_ff @(posedge irclk) begin
        if (irclkena) begin
          rsel   <= iraddr0[0];
          raddr0 <= iraddr0[0] ? iraddr0[pADDR_W-1 : 1] : iraddr1[pADDR_W-1 : 1];
          raddr1 <= iraddr0[0] ? iraddr1[pADDR_W-1 : 1] : iraddr0[pADDR_W-1 : 1];
        end
      end
    end
    else begin
      assign rsel   = iraddr0[0];
      assign raddr0 = iraddr0[0] ? iraddr0[pADDR_W-1 : 1] : iraddr1[pADDR_W-1 : 1];
      assign raddr1 = iraddr0[0] ? iraddr1[pADDR_W-1 : 1] : iraddr0[pADDR_W-1 : 1];
    end
  endgenerate

  logic rsel_out;

  always_ff @(posedge irclk) begin
    if (irclkena) begin
      rsel_out  <= rsel;
      rdata0    <= ram0[raddr0];
      rdata1    <= ram1[raddr1];
    end
  end

  generate
    if (pDPIPE) begin
      always_ff @(posedge irclk) begin
        if (irclkena) begin
          ordata0 <= rsel_out ? rdata0 : rdata1;
          ordata1 <= rsel_out ? rdata1 : rdata0;
        end
      end
    end
    else begin
      assign ordata0 = rsel_out ? rdata0 : rdata1;
      assign ordata1 = rsel_out ? rdata1 : rdata0;
    end
  endgenerate

endmodule
