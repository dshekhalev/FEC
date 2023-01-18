/*



  parameter int pWDAT_W = 2 ;
  parameter int pRDAT_W = 2 ;
  parameter int pADDR_W = 8 ;
  parameter bit pWPIPE  = 0 ;



  logic                 codec_map_dec_output_ram__ireset   ;
  logic                 codec_map_dec_output_ram__iwclk    ;
  logic                 codec_map_dec_output_ram__iwclkena ;
  logic                 codec_map_dec_output_ram__iwrite   ;
  logic [pADDR_W-1 : 0] codec_map_dec_output_ram__iwaddr0  ;
  logic [pWDAT_W-1 : 0] codec_map_dec_output_ram__iwdata0  ;
  logic [pADDR_W-1 : 0] codec_map_dec_output_ram__iwaddr1  ;
  logic [pWDAT_W-1 : 0] codec_map_dec_output_ram__iwdata1  ;
  logic                 codec_map_dec_output_ram__irclk    ;
  logic                 codec_map_dec_output_ram__irclkena ;
  logic                 codec_map_dec_output_ram__iread    ;
  logic [pADDR_W-1 : 0] codec_map_dec_output_ram__iraddr   ;
  logic [pRDAT_W-1 : 0] codec_map_dec_output_ram__ordata   ;



  codec_map_dec_output_ram
  #(
    .pWDAT_W ( pWDAT_W ) ,
    .pRDAT_W ( pRDAT_W ) ,
    .pADDR_W ( pADDR_W ) ,
    .pWPIPE  ( pWPIPE  )
  )
  codec_map_dec_output_ram
  (
    .ireset   ( codec_map_dec_output_ram__ireset   ) ,
    .iwclk    ( codec_map_dec_output_ram__iwclk    ) ,
    .iwclkena ( codec_map_dec_output_ram__iwclkena ) ,
    .iwrite   ( codec_map_dec_output_ram__iwrite   ) ,
    .iwaddr0  ( codec_map_dec_output_ram__iwaddr0  ) ,
    .iwdata0  ( codec_map_dec_output_ram__iwdata0  ) ,
    .iwaddr1  ( codec_map_dec_output_ram__iwaddr1  ) ,
    .iwdata1  ( codec_map_dec_output_ram__iwdata1  ) ,
    .irclk    ( codec_map_dec_output_ram__irclk    ) ,
    .irclkena ( codec_map_dec_output_ram__irclkena ) ,
    .iread    ( codec_map_dec_output_ram__iread    ) ,
    .iraddr   ( codec_map_dec_output_ram__iraddr   ) ,
    .ordata   ( codec_map_dec_output_ram__ordata   )
  );


  assign codec_map_dec_output_ram__ireset   = '0 ;
  assign codec_map_dec_output_ram__iwclk    = '0 ;
  assign codec_map_dec_output_ram__iwclkena = '0 ;
  assign codec_map_dec_output_ram__iwrite   = '0 ;
  assign codec_map_dec_output_ram__iwaddr0  = '0 ;
  assign codec_map_dec_output_ram__iwdata0  = '0 ;
  assign codec_map_dec_output_ram__iwaddr1  = '0 ;
  assign codec_map_dec_output_ram__iwdata1  = '0 ;
  assign codec_map_dec_output_ram__irclk    = '0 ;
  assign codec_map_dec_output_ram__irclkena = '0 ;
  assign codec_map_dec_output_ram__iread    = '0 ;
  assign codec_map_dec_output_ram__iraddr   = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_map_dec_output_ram.sv
// Description   : output ram for MAP decoder with two concurrent switched write ports for even/odd adress and
//                 one read port with simple DWC support
//                 ram write default latency is 1 tick,optionaly 2 tick.
//                 ram read latency is 1 tick
//

module codec_map_dec_output_ram
#(
  parameter int pWDAT_W =       1 ,
  parameter int pRDAT_W = pWDAT_W , // [1/2/4]*pWDAT_W  only
  parameter int pADDR_W =       8 ,
  parameter bit pWPIPE  =       0   // write path pipeline register
)
(
  ireset   ,
  //
  iwclk    ,
  iwclkena ,
  //
  iwrite   ,
  iwaddr0  ,
  iwdata0  ,
  iwaddr1  ,
  iwdata1  ,
  //
  irclk    ,
  irclkena ,
  //
  iread    ,
  iraddr   ,
  ordata
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
  input  logic [pADDR_W-1 : 0] iwaddr0  ;
  input  logic [pWDAT_W-1 : 0] iwdata0  ;
  input  logic [pADDR_W-1 : 0] iwaddr1  ;
  input  logic [pWDAT_W-1 : 0] iwdata1  ;
  //
  input  logic                 irclk    ;
  input  logic                 irclkena ;
  //
  input  logic                 iread    ;
  input  logic [pADDR_W-1 : 0] iraddr   ;
  output logic [pRDAT_W-1 : 0] ordata   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W  = pADDR_W - 1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                 write;
  logic                 wsel;

  logic [pWDAT_W-1 : 0] wdata0;
  logic [pWDAT_W-1 : 0] wdata1;

  logic [cADDR_W-1 : 0] waddr0;
  logic [cADDR_W-1 : 0] waddr1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign wsel = iwaddr0[0];

  generate
    if (pWPIPE) begin
      always_ff @(posedge iwclk) begin
        if (iwclkena) begin
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

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pRDAT_W/pWDAT_W == 4) begin

      bit   [pWDAT_W-1 : 0] ram00 [2**(cADDR_W-1)]  /*synthesis syn_ramstyle = "no_rw_check"*/;
      bit   [pWDAT_W-1 : 0] ram01 [2**(cADDR_W-1)]  /*synthesis syn_ramstyle = "no_rw_check"*/;

      bit   [pWDAT_W-1 : 0] ram10 [2**(cADDR_W-1)]  /*synthesis syn_ramstyle = "no_rw_check"*/;
      bit   [pWDAT_W-1 : 0] ram11 [2**(cADDR_W-1)]  /*synthesis syn_ramstyle = "no_rw_check"*/;

      logic [pWDAT_W-1 : 0] rdata00;
      logic [pWDAT_W-1 : 0] rdata01;

      logic [pWDAT_W-1 : 0] rdata10;
      logic [pWDAT_W-1 : 0] rdata11;

      always_ff @(posedge iwclk) begin
        if (write) begin
          if (waddr0[0]) begin
            ram01[waddr0[cADDR_W-1 : 1]] <= wdata0;
          end
          else begin
            ram00[waddr0[cADDR_W-1 : 1]] <= wdata0;
          end
          //
          if (waddr1[0]) begin
            ram11[waddr1[cADDR_W-1 : 1]] <= wdata1;
          end
          else begin
            ram10[waddr1[cADDR_W-1 : 1]] <= wdata1;
          end
        end
      end

      always_ff @(posedge irclk) begin
        if (irclkena) begin
          rdata00 <= ram00[iraddr[pADDR_W-3 : 0]];
          rdata01 <= ram01[iraddr[pADDR_W-3 : 0]];
          //
          rdata10 <= ram10[iraddr[pADDR_W-3 : 0]];
          rdata11 <= ram11[iraddr[pADDR_W-3 : 0]];
        end
      end

      assign ordata = {rdata01, rdata11,
                       rdata00, rdata10};

    end
    else if (pRDAT_W/pWDAT_W == 2) begin

      bit   [pWDAT_W-1 : 0] ram0 [2**cADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;
      bit   [pWDAT_W-1 : 0] ram1 [2**cADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;

      logic [pWDAT_W-1 : 0] rdata0;
      logic [pWDAT_W-1 : 0] rdata1;

      //------------------------------------------------------------------------------------------------------
      //
      //------------------------------------------------------------------------------------------------------

      always_ff @(posedge iwclk) begin
        if (iwclkena) begin
          if (write) begin
            ram0[waddr0] <= wdata0;
            ram1[waddr1] <= wdata1;
          end
        end
      end

      //------------------------------------------------------------------------------------------------------
      //
      //------------------------------------------------------------------------------------------------------

      always_ff @(posedge irclk) begin
        if (irclkena) begin
          rdata0 <= ram0[iraddr[pADDR_W-2 : 0]];
          rdata1 <= ram1[iraddr[pADDR_W-2 : 0]];
        end
      end

      assign ordata = {rdata0, rdata1};

    end
    else begin // pRDAT_W == pWDAT_W

      bit   [pWDAT_W-1 : 0] ram0 [2**cADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;
      bit   [pWDAT_W-1 : 0] ram1 [2**cADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;

      logic [pWDAT_W-1 : 0] rdata0;
      logic [pWDAT_W-1 : 0] rdata1;
      logic                 rsel_out;

      //------------------------------------------------------------------------------------------------------
      //
      //------------------------------------------------------------------------------------------------------

      always_ff @(posedge iwclk) begin
        if (iwclkena) begin
          if (write) begin
            ram0[waddr0] <= wdata0;
            ram1[waddr1] <= wdata1;
          end
        end
      end

      //------------------------------------------------------------------------------------------------------
      //
      //------------------------------------------------------------------------------------------------------

      always_ff @(posedge irclk) begin
        if (irclkena) begin
          rsel_out  <= iraddr[0];
          rdata0    <= ram0[iraddr[pADDR_W-1 : 1]];
          rdata1    <= ram1[iraddr[pADDR_W-1 : 1]];
        end
      end

      assign ordata = rsel_out ? rdata0 : rdata1;

    end
  endgenerate

endmodule
