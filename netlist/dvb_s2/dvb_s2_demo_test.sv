//
// Project       : DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_s2_demo_test.sv
// Description   : simple testbench for demo DVB-S2 codec
//

`timescale 1ns/1ns

module dvb_s2_demo_test;

  `include "dvb_s2_tb_frame_size.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic           iclk     ;
  logic           ireset   ;
  logic   [8 : 0] acm_code ;

  // encoder
  logic           enc__s_axis_aclk       ;
  logic           enc__s_axis_aresetn    ;
  logic           enc__s_axis_tvalid     ;
  logic   [7 : 0] enc__s_axis_tdata      ;
  logic           enc__s_axis_tlast      ;
  //
  logic   [7 : 0] enc__s_axis_tid        ;
  logic   [3 : 0] enc__s_axis_tdest      ;
  logic   [8 : 0] enc__s_axis_tuser      ;
  logic           enc__s_axis_tready     ;
  //
  logic           enc__m_axis_aclk       ;
  logic           enc__m_axis_aresetn    ;
  logic           enc__m_axis_tready     ;
  logic           enc__m_axis_tvalid     ;
  logic   [7 : 0] enc__m_axis_tdata      ;
  logic           enc__m_axis_tlast      ;
  //
  logic   [7 : 0] enc__m_axis_tid        ;
  logic   [3 : 0] enc__m_axis_tdest      ;
  logic   [8 : 0] enc__m_axis_tuser      ;
  //
  logic           enc__obusy             ;
  //
  logic           enc__oframe_in_done    ;
  logic  [15 : 0] enc__oframe_in_bitnum  ;
  logic           enc__oframe_in_error   ;
  //
  logic           enc__oframe_out_done   ;
  logic  [15 : 0] enc__oframe_out_bitnum ;

  // decoder
  logic           dec__s_axis_aclk        ;
  logic           dec__s_axis_aresetn     ;
  logic           dec__s_axis_tvalid      ;
  logic  [31 : 0] dec__s_axis_tdata       ;
  logic           dec__s_axis_tlast       ;
  //
  logic   [7 : 0] dec__s_axis_tid         ;
  logic   [3 : 0] dec__s_axis_tdest       ;
  logic  [17 : 0] dec__s_axis_tuser       ;
  logic           dec__s_axis_tready      ;
  //
  logic           dec__m_axis_aclk        ;
  logic           dec__m_axis_aresetn     ;
  logic           dec__m_axis_tready      ;
  logic           dec__m_axis_tvalid      ;
  logic   [7 : 0] dec__m_axis_tdata       ;
  logic           dec__m_axis_tlast       ;
  //
  logic   [7 : 0] dec__m_axis_tid         ;
  logic   [3 : 0] dec__m_axis_tdest       ;
  logic   [8 : 0] dec__m_axis_tuser       ;
  //
  logic           dec__obusy              ;
  //
  logic           dec__oframe_in_done     ;
  logic  [15 : 0] dec__oframe_in_bitnum   ;
  logic           dec__oframe_in_error    ;
  logic           dec__oframe_in_overflow ;
  //
  logic           dec__oframe_out_done    ;
  logic  [15 : 0] dec__oframe_out_bitnum  ;
  //
  logic  [15 : 0] dec__oldpc_biterr       ;
  logic           dec__oldpc_decfail      ;
  logic   [7 : 0] dec__oldpc_used_niter   ;
  //
  logic   [3 : 0] dec__obch_biterr        ;
  logic           dec__obch_decfail       ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  dvb_s2_enc_wrp
  enc
  (
    .iclk              ( iclk                   ) ,
    .ireset            ( ireset                 ) ,
    //
    .s_axis_aclk       ( enc__s_axis_aclk       ) ,
    .s_axis_aresetn    ( enc__s_axis_aresetn    ) ,
    .s_axis_tvalid     ( enc__s_axis_tvalid     ) ,
    .s_axis_tdata      ( enc__s_axis_tdata      ) ,
    .s_axis_tlast      ( enc__s_axis_tlast      ) ,
    //
    .s_axis_tid        ( enc__s_axis_tid        ) ,
    .s_axis_tdest      ( enc__s_axis_tdest      ) ,
    .s_axis_tuser      ( enc__s_axis_tuser      ) ,
    .s_axis_tready     ( enc__s_axis_tready     ) ,
    //
    .m_axis_aclk       ( enc__m_axis_aclk       ) ,
    .m_axis_aresetn    ( enc__m_axis_aresetn    ) ,
    .m_axis_tready     ( enc__m_axis_tready     ) ,
    .m_axis_tvalid     ( enc__m_axis_tvalid     ) ,
    .m_axis_tdata      ( enc__m_axis_tdata      ) ,
    .m_axis_tlast      ( enc__m_axis_tlast      ) ,
    //
    .m_axis_tid        ( enc__m_axis_tid        ) ,
    .m_axis_tdest      ( enc__m_axis_tdest      ) ,
    .m_axis_tuser      ( enc__m_axis_tuser      ) ,
    //
    .obusy             ( enc__obusy             ) ,
    //
    .oframe_in_done    ( enc__oframe_in_done    ) ,
    .oframe_in_bitnum  ( enc__oframe_in_bitnum  ) ,
    .oframe_in_error   ( enc__oframe_in_error   ) ,
    //
    .oframe_out_done   ( enc__oframe_out_done   ) ,
    .oframe_out_bitnum ( enc__oframe_out_bitnum )
  );

  assign enc__s_axis_tid    = '0;
  assign enc__s_axis_tdest  = '0;

  assign enc__s_axis_tuser  = acm_code;

  //------------------------------------------------------------------------------------------------------
  // QPSK modulator for [-4 : 4) range
  //------------------------------------------------------------------------------------------------------

  logic [7 : 0] symbol_val;
  logic [7 : 0] symbol_dat;
  logic [7 : 0] symbol_last;

  always_ff @(posedge enc__m_axis_aclk) begin
    if (enc__m_axis_tvalid & enc__m_axis_tready) begin
      symbol_val  <= 8'h0F;
      symbol_dat  <=  enc__m_axis_tdata;
      symbol_last <= {enc__m_axis_tlast, 3'b0};
    end
    else begin
      symbol_val  <= (symbol_val  >> 1);
      symbol_dat  <= (symbol_dat  >> 2);
      symbol_last <= (symbol_last >> 1);
    end
  end

  assign enc__m_axis_tready = (symbol_val <= 1);

  //
  always_comb begin
    dec__s_axis_tvalid  = symbol_val  [0];
    dec__s_axis_tlast   = symbol_last [0];
    // In DVB-S2 the MSB is always transmitted first.
    case ({symbol_dat[0], symbol_dat[1]})
      2'b00 : begin
        dec__s_axis_tdata[0  +: 16] = 0.707 * 2**(13);
        dec__s_axis_tdata[16 +: 16] = 0.707 * 2**(13);
      end
      2'b01 : begin
        dec__s_axis_tdata[0  +: 16] =  0.707 * 2**(13);
        dec__s_axis_tdata[16 +: 16] = -0.707 * 2**(13);
      end
      2'b10 : begin
        dec__s_axis_tdata[0  +: 16] = -0.707 * 2**(13);
        dec__s_axis_tdata[16 +: 16] =  0.707 * 2**(13);
      end
      2'b11 : begin
        dec__s_axis_tdata[0  +: 16] = -0.707 * 2**(13);
        dec__s_axis_tdata[16 +: 16] = -0.707 * 2**(13);
      end
    endcase
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  dvb_s2_dec_wrp
  dec
  (
    .iclk               ( iclk                    ) ,
    .ireset             ( ireset                  ) ,
    //
    .s_axis_aclk        ( dec__s_axis_aclk        ) ,
    .s_axis_aresetn     ( dec__s_axis_aresetn     ) ,
    .s_axis_tvalid      ( dec__s_axis_tvalid      ) ,
    .s_axis_tdata       ( dec__s_axis_tdata       ) ,
    .s_axis_tlast       ( dec__s_axis_tlast       ) ,
    //
    .s_axis_tid         ( dec__s_axis_tid         ) ,
    .s_axis_tdest       ( dec__s_axis_tdest       ) ,
    .s_axis_tuser       ( dec__s_axis_tuser       ) ,
    .s_axis_tready      ( dec__s_axis_tready      ) ,
    //
    .m_axis_aclk        ( dec__m_axis_aclk        ) ,
    .m_axis_aresetn     ( dec__m_axis_aresetn     ) ,
    .m_axis_tready      ( dec__m_axis_tready      ) ,
    .m_axis_tvalid      ( dec__m_axis_tvalid      ) ,
    .m_axis_tdata       ( dec__m_axis_tdata       ) ,
    .m_axis_tlast       ( dec__m_axis_tlast       ) ,
    //
    .m_axis_tid         ( dec__m_axis_tid         ) ,
    .m_axis_tdest       ( dec__m_axis_tdest       ) ,
    .m_axis_tuser       ( dec__m_axis_tuser       ) ,
    //
    .obusy              ( dec__obusy              ) ,
    //
    .oframe_in_done     ( dec__oframe_in_done     ) ,
    .oframe_in_bitnum   ( dec__oframe_in_bitnum   ) ,
    .oframe_in_error    ( dec__oframe_in_error    ) ,
    .oframe_in_overflow ( dec__oframe_in_overflow ) ,
    //
    .oframe_out_done    ( dec__oframe_out_done    ) ,
    .oframe_out_bitnum  ( dec__oframe_out_bitnum  ) ,
    //
    .oldpc_biterr       ( dec__oldpc_biterr       ) ,
    .oldpc_decfail      ( dec__oldpc_decfail      ) ,
    .oldpc_used_niter   ( dec__oldpc_used_niter   ) ,
    //
    .obch_biterr        ( dec__obch_biterr        ) ,
    .obch_decfail       ( dec__obch_decfail       )
  );

  assign dec__s_axis_tid    = '0;
  assign dec__s_axis_tdest  = '0;

  // fast mode, up to 10 iterations
  assign dec__s_axis_tuser  = {1'b1, 8'd10, acm_code};

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

  bit [7 : 0] tx_data [64800/8];
  bit [7 : 0] rx_data [64800/8];

  initial begin : main
    acm_code  <= 20;
//    acm_code  <= 22;
    //
    enc__s_axis_tvalid <= '0;
    enc__s_axis_tdata  <= '0;
    enc__s_axis_tlast  <= '0;
    //
    @(posedge enc__s_axis_aclk iff !ireset);
    //
    send_data (get_fec_data_words_num(acm_code));
    //
    get_data  ();
    //
    if (check_data(get_fec_data_words_num(acm_code))) begin
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
    frame_length = frame_bit_length/8 + ((frame_bit_length % 8) != 0);
    //
    $display("send %0d bits %0.1f bytes", frame_bit_length, frame_bit_length*1.0/8);
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
        $display("ldpc statistic: biterr %0d, decfail %0d, used_iter %0d", dec__oldpc_decfail, dec__oldpc_decfail, dec__oldpc_used_niter);
        $display("bch  statistic: biterr %0d, decfail %0d", dec__obch_biterr, dec__obch_decfail);
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
    frame_length = frame_bit_length/8 + ((frame_bit_length % 8) != 0);
    //
    check_data = 0;
    for (int i = 0; i < frame_length/8; i++) begin
      for (int j = 0; j < 8; j++) begin
        if ((8*i + j) < frame_bit_length) begin
          check_data |= (tx_data[i][8-1-j] != rx_data[i][8-1-j]); // MSB first
        end
      end
    end
  end
  endfunction

endmodule


