/*



  parameter int pDATA_W = 32 ;
  parameter int pADDR_W =  8 ;
  parameter bit pWPIPE  =  0 ;
  parameter bit pRAPIPE =  0 ;
  parameter bit pRDPIPE =  0 ;



  logic                 codec_map_dec_extr_ram__iclk     ;
  logic                 codec_map_dec_extr_ram__ireset   ;
  logic                 codec_map_dec_extr_ram__iclkena  ;
  logic                 codec_map_dec_extr_ram__iwrite   ;
  logic [pADDR_W-1 : 0] codec_map_dec_extr_ram__iwaddr0  ;
  logic [pDATA_W-1 : 0] codec_map_dec_extr_ram__iwdata0  ;
  logic [pADDR_W-1 : 0] codec_map_dec_extr_ram__iwaddr1  ;
  logic [pDATA_W-1 : 0] codec_map_dec_extr_ram__iwdata1  ;
  logic                 codec_map_dec_extr_ram__iread    ;
  logic [pADDR_W-1 : 0] codec_map_dec_extr_ram__iraddr0  ;
  logic [pDATA_W-1 : 0] codec_map_dec_extr_ram__ordata0  ;
  logic [pADDR_W-1 : 0] codec_map_dec_extr_ram__iraddr1  ;
  logic [pDATA_W-1 : 0] codec_map_dec_extr_ram__ordata1  ;



  codec_map_dec_extr_ram
  #(
    .pDATA_W ( pDATA_W ) ,
    .pADDR_W ( pADDR_W ) ,
    .pWPIPE  ( pWPIPE  ) ,
    .pRAPIPE ( pRAPIPE ) ,
    .pRDPIPE ( pRDPIPE )
  )
  codec_map_dec_extr_ram
  (
    .iclk    ( codec_map_dec_extr_ram__iclk    ) ,
    .ireset  ( codec_map_dec_extr_ram__ireset  ) ,
    .iclkena ( codec_map_dec_extr_ram__iclkena ) ,
    .iwrite  ( codec_map_dec_extr_ram__iwrite  ) ,
    .iwaddr0 ( codec_map_dec_extr_ram__iwaddr0 ) ,
    .iwdata0 ( codec_map_dec_extr_ram__iwdata0 ) ,
    .iwaddr1 ( codec_map_dec_extr_ram__iwaddr1 ) ,
    .iwdata1 ( codec_map_dec_extr_ram__iwdata1 ) ,
    .iread   ( codec_map_dec_extr_ram__iread   ) ,
    .iraddr0 ( codec_map_dec_extr_ram__iraddr0 ) ,
    .ordata0 ( codec_map_dec_extr_ram__ordata0 ) ,
    .iraddr1 ( codec_map_dec_extr_ram__iraddr1 ) ,
    .ordata1 ( codec_map_dec_extr_ram__ordata1 )
  );


  assign codec_map_dec_extr_ram__iclk    = '0 ;
  assign codec_map_dec_extr_ram__ireset  = '0 ;
  assign codec_map_dec_extr_ram__iclkena = '0 ;
  assign codec_map_dec_extr_ram__iwrite  = '0 ;
  assign codec_map_dec_extr_ram__iwaddr0 = '0 ;
  assign codec_map_dec_extr_ram__iwdata0 = '0 ;
  assign codec_map_dec_extr_ram__iwaddr1 = '0 ;
  assign codec_map_dec_extr_ram__iwdata1 = '0 ;
  assign codec_map_dec_extr_ram__iread   = '0 ;
  assign codec_map_dec_extr_ram__iraddr0 = '0 ;
  assign codec_map_dec_extr_ram__iraddr1 = '0 ;



*/

//
// Project       : coding libray
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_map_dec_extr_ram.sv
// Description   : extrinsic ram for MAP decoder with two concurrent switched write and read ports for even/odd address
//                 ram write default latency is 1 tick, optionaly 2 tick.
//                 ram read default latency is 1 tick, optionaly 2/3 tick.
//

module codec_map_dec_extr_ram
#(
  parameter int pDATA_W = 32 ,
  parameter int pADDR_W =  8 ,
  parameter bit pWPIPE  =  0 ,  // write path   pipeline register
  parameter bit pRAPIPE =  0 ,  // read address pipeline register
  parameter bit pRDPIPE =  0    // read data    pipeline register
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwaddr0 ,
  iwdata0 ,
  iwaddr1 ,
  iwdata1 ,
  //
  iread   ,
  iraddr0 ,
  ordata0 ,
  iraddr1 ,
  ordata1
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  logic                 iwrite   ;
  input  logic [pADDR_W-1 : 0] iwaddr0  ;
  input  logic [pDATA_W-1 : 0] iwdata0  ;
  input  logic [pADDR_W-1 : 0] iwaddr1  ;
  input  logic [pDATA_W-1 : 0] iwdata1  ;
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

  logic [pDATA_W-1 : 0] ram0 [0 : 2**cADDR_W-1] /*synthesis syn_ramstyle = "no_rw_check"*/;
  logic [pDATA_W-1 : 0] ram1 [0 : 2**cADDR_W-1] /*synthesis syn_ramstyle = "no_rw_check"*/;

  logic                 write;
  logic                 wsel;

  logic [pDATA_W-1 : 0] wdata0;
  logic [pDATA_W-1 : 0] wdata1;

  logic [pDATA_W-1 : 0] rdata0;
  logic [pDATA_W-1 : 0] rdata1;

  logic                 rsel;

  logic [cADDR_W-1 : 0] waddr0;
  logic [cADDR_W-1 : 0] waddr1;

  logic [cADDR_W-1 : 0] raddr0;
  logic [cADDR_W-1 : 0] raddr1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign wsel = iwaddr0[0];

  generate
    if (pWPIPE) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          write  <= iwrite;

          waddr0 <= wsel ? iwaddr0[pADDR_W-1 : 1] : iwaddr1[pADDR_W-1 : 1];
          wdata0 <= wsel ? iwdata0                : iwdata1;

          waddr1 <= wsel ? iwaddr1[pADDR_W-1 : 1] : iwaddr0[pADDR_W-1 : 1];
          wdata1 <= wsel ? iwdata1                : iwdata0;
        end
      end
    end
    else begin
      assign write  = iwrite;

      assign waddr0 = wsel ? iwaddr0[pADDR_W-1 : 1] : iwaddr1[pADDR_W-1 : 1];
      assign wdata0 = wsel ? iwdata0                : iwdata1;

      assign waddr1 = wsel ? iwaddr1[pADDR_W-1 : 1] : iwaddr0[pADDR_W-1 : 1];
      assign wdata1 = wsel ? iwdata1                : iwdata0;
    end
  endgenerate

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (write) begin
        ram0[waddr0] <= wdata0;
        ram1[waddr1] <= wdata1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pRAPIPE) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
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

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      rsel_out  <= rsel;
      rdata0    <= ram0[raddr0];
      rdata1    <= ram1[raddr1];
    end
  end

  generate
    if (pRDPIPE) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
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
