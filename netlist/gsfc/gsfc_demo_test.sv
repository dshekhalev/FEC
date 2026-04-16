//
// Project       : GSFC ldpc (7136, 8160)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_demo_test.sv
// Description   : simple testbench for demo GSFC codec
//

`timescale 1ns/1ns

module gsfc_demo_test;

  localparam int cDATA_BITS = 7136;
  localparam int cCODE_BITS = 8160;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic           iclk     ;
  logic           ireset   ;

  // encoder
  logic           enc__s_axis_aclk     ;
  logic           enc__s_axis_aresetn  ;
  logic           enc__s_axis_tvalid   ;
  logic  [15 : 0] enc__s_axis_tdata    ;
  logic           enc__s_axis_tlast    ;
  //
  logic   [7 : 0] enc__s_axis_tid      ;
  logic   [3 : 0] enc__s_axis_tdest    ;
  logic   [3 : 0] enc__s_axis_tuser    ;
  logic           enc__s_axis_tready   ;
  //
  logic           enc__m_axis_aclk     ;
  logic           enc__m_axis_aresetn  ;
  logic           enc__m_axis_tready   ;
  logic           enc__m_axis_tvalid   ;
  logic  [15 : 0] enc__m_axis_tdata    ;
  logic           enc__m_axis_tlast    ;
  //
  logic   [7 : 0] enc__m_axis_tid      ;
  logic   [3 : 0] enc__m_axis_tdest    ;
  logic   [3 : 0] enc__m_axis_tuser    ;
  //
  logic           enc__obusy           ;
  //
  logic           enc__oframe_in_error ;

  // decoder
  logic   [3 : 0] dec__iNiter          ;
  logic           dec__ifmode          ;
  //
  logic           dec__s_axis_aclk     ;
  logic           dec__s_axis_aresetn  ;
  logic           dec__s_axis_tvalid   ;
  logic [127 : 0] dec__s_axis_tdata    ;
  logic           dec__s_axis_tlast    ;
  //
  logic   [7 : 0] dec__s_axis_tid      ;
  logic   [3 : 0] dec__s_axis_tdest    ;
  logic   [3 : 0] dec__s_axis_tuser    ;
  logic           dec__s_axis_tready   ;
  //
  logic           dec__m_axis_aclk     ;
  logic           dec__m_axis_aresetn  ;
  logic           dec__m_axis_tready   ;
  logic           dec__m_axis_tvalid   ;
  logic  [15 : 0] dec__m_axis_tdata    ;
  logic           dec__m_axis_tlast    ;
  //
  logic   [7 : 0] dec__m_axis_tid      ;
  logic   [3 : 0] dec__m_axis_tdest    ;
  logic   [3 : 0] dec__m_axis_tuser    ;
  //
  logic           dec__obusy           ;
  //
  logic           dec__oframe_in_error ;
  logic           dec__oframe_out_done ;
  //
  logic  [15 : 0] dec__obiterr         ;
  logic           dec__odecfail        ;
  logic   [3 : 0] dec__oused_niter     ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  gsfc_enc_wrp
  enc
  (
    .iclk            ( iclk                 ) ,
    .ireset          ( ireset               ) ,
    //
    .s_axis_aclk     ( enc__s_axis_aclk     ) ,
    .s_axis_aresetn  ( enc__s_axis_aresetn  ) ,
    .s_axis_tvalid   ( enc__s_axis_tvalid   ) ,
    .s_axis_tdata    ( enc__s_axis_tdata    ) ,
    .s_axis_tlast    ( enc__s_axis_tlast    ) ,
    //
    .s_axis_tid      ( enc__s_axis_tid      ) ,
    .s_axis_tdest    ( enc__s_axis_tdest    ) ,
    .s_axis_tuser    ( enc__s_axis_tuser    ) ,
    .s_axis_tready   ( enc__s_axis_tready   ) ,
    //
    .m_axis_aclk     ( enc__m_axis_aclk     ) ,
    .m_axis_aresetn  ( enc__m_axis_aresetn  ) ,
    .m_axis_tready   ( enc__m_axis_tready   ) ,
    .m_axis_tvalid   ( enc__m_axis_tvalid   ) ,
    .m_axis_tdata    ( enc__m_axis_tdata    ) ,
    .m_axis_tlast    ( enc__m_axis_tlast    ) ,
    //
    .m_axis_tid      ( enc__m_axis_tid      ) ,
    .m_axis_tdest    ( enc__m_axis_tdest    ) ,
    .m_axis_tuser    ( enc__m_axis_tuser    ) ,
    //
    .obusy           ( enc__obusy           ) ,
    //
    .oframe_in_error ( enc__oframe_in_error )
  );

  assign enc__s_axis_tid    = '0;
  assign enc__s_axis_tdest  = '0;
  assign enc__s_axis_tuser  = '0;;

  //------------------------------------------------------------------------------------------------------
  // wide QPSK modulator for exact points
  //------------------------------------------------------------------------------------------------------

  localparam int cLLR_W = 4;              // [-8 : 7];
  localparam int cONE   = 2**(cLLR_W-2);  // +-4

  assign enc__m_axis_tready = dec__s_axis_tready;

  assign dec__s_axis_tvalid = enc__m_axis_tvalid;
  assign dec__s_axis_tlast  = enc__m_axis_tlast;

  always_comb begin
    for (int i = 0; i < 16; i++) begin
      dec__s_axis_tdata[i*8 +: 8] = enc__m_axis_tdata[i] ? cONE : -cONE;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  gsfc_dec_wrp
  dec
  (
    .iclk            ( iclk                 ) ,
    .ireset          ( ireset               ) ,
    //
    .iNiter          ( dec__iNiter          ) ,
    .ifmode          ( dec__ifmode          ) ,
    //
    .s_axis_aclk     ( dec__s_axis_aclk     ) ,
    .s_axis_aresetn  ( dec__s_axis_aresetn  ) ,
    .s_axis_tvalid   ( dec__s_axis_tvalid   ) ,
    .s_axis_tdata    ( dec__s_axis_tdata    ) ,
    .s_axis_tlast    ( dec__s_axis_tlast    ) ,
    //
    .s_axis_tid      ( dec__s_axis_tid      ) ,
    .s_axis_tdest    ( dec__s_axis_tdest    ) ,
    .s_axis_tuser    ( dec__s_axis_tuser    ) ,
    .s_axis_tready   ( dec__s_axis_tready   ) ,
    //
    .m_axis_aclk     ( dec__m_axis_aclk     ) ,
    .m_axis_aresetn  ( dec__m_axis_aresetn  ) ,
    .m_axis_tready   ( dec__m_axis_tready   ) ,
    .m_axis_tvalid   ( dec__m_axis_tvalid   ) ,
    .m_axis_tdata    ( dec__m_axis_tdata    ) ,
    .m_axis_tlast    ( dec__m_axis_tlast    ) ,
    //
    .m_axis_tid      ( dec__m_axis_tid      ) ,
    .m_axis_tdest    ( dec__m_axis_tdest    ) ,
    .m_axis_tuser    ( dec__m_axis_tuser    ) ,
    //
    .obusy           ( dec__obusy           ) ,
    //
    .oframe_in_error ( dec__oframe_in_error ) ,
    .oframe_out_done ( dec__oframe_out_done ) ,
    //
    .obiterr         ( dec__obiterr         ) ,
    .odecfail        ( dec__odecfail        ) ,
    .oused_niter     ( dec__oused_niter     )
  );

  assign dec__iNiter        = 8; // max
  assign dec__ifmode        = 1;

  assign dec__s_axis_tid    = '0;
  assign dec__s_axis_tdest  = '0;
  assign dec__s_axis_tuser  = '0;

  // always enable
  assign dec__m_axis_tready = 1'b1;

  //------------------------------------------------------------------------------------------------------
  // clock
  //------------------------------------------------------------------------------------------------------

  bit clk_core;
  bit clk_sys;
  bit clk_modem;

  initial begin
    fork
      #5ns forever #5ns clk_core  = !clk_core;
      #8ns forever #8ns clk_sys   = !clk_sys;
      #4ns forever #4ns clk_modem = !clk_modem;
    join
  end

  initial begin
    ireset = 1'b1;
    repeat (2) @(negedge iclk);
    ireset = 1'b0;
  end

  assign iclk = clk_core;

  assign enc__s_axis_aclk     =  clk_sys;
  assign enc__s_axis_aresetn  = !ireset;

  assign enc__m_axis_aclk     =  clk_modem;
  assign enc__m_axis_aresetn  = !ireset;

  assign dec__s_axis_aclk     =  clk_modem;
  assign dec__s_axis_aresetn  = !ireset;

  assign dec__m_axis_aclk     =  clk_sys;
  assign dec__m_axis_aresetn  = !ireset;

  //------------------------------------------------------------------------------------------------------
  // main framer
  //------------------------------------------------------------------------------------------------------

  bit [15 : 0] tx_data [cDATA_BITS/16];
  bit [15 : 0] rx_data [cDATA_BITS/16];

  initial begin : main
    //
    enc__s_axis_tvalid <= '0;
    enc__s_axis_tdata  <= '0;
    enc__s_axis_tlast  <= '0;
    //
    @(posedge enc__s_axis_aclk iff !ireset);
    //
    send_data (cDATA_BITS);
    //
    get_data  ();
    //
    if (check_data(cDATA_BITS)) begin
      $display("check failed");
    end
    else begin
      $display("check ok");
    end
    repeat (10) @(posedge enc__s_axis_aclk);
    //
    $stop;
  end

  task send_data (input int frame_bit_length);
    int frame_length;
  begin
    //
    frame_length = cDATA_BITS/16;
    //
    $display("send %0d bits %0d words", frame_bit_length, frame_length);
    //
    for (int i = 0; i < frame_length; i++) begin
      tx_data[i] = $urandom;
      //
      enc__s_axis_tvalid  <= 1'b1;
      enc__s_axis_tdata   <= tx_data[i];
      enc__s_axis_tlast   <= (i == (frame_length-1));
      //
      @(posedge enc__s_axis_aclk iff enc__s_axis_tready);
      enc__s_axis_tvalid  <= 1'b0;
    end
  end
  endtask

  task get_data ();
    int addr;
  begin
    addr = 0;
    forever begin
      @(posedge dec__m_axis_aclk iff (dec__m_axis_tvalid & dec__m_axis_tready));
      rx_data[addr] = dec__m_axis_tdata;
      //
      if (addr == 0) begin
        $display("statistic: biterr %0d, decfail %0d, used_iter %0d", dec__obiterr, dec__odecfail, dec__oused_niter);
      end
      //
      addr++;
      if (dec__m_axis_tlast) break;
    end
  end
  endtask

  function bit check_data (input int frame_bit_length);
    int frame_length;
  begin
    frame_length = frame_bit_length/16;
    //
    check_data = 0;
    for (int i = 0; i < frame_length; i++) begin
      for (int j = 0; j < 16; j++) begin
        if ((16*i + j) < frame_bit_length) begin
          check_data |= (tx_data[i][j] != rx_data[i][j]); // MSB first
        end
      end
    end
  end
  endfunction

endmodule


