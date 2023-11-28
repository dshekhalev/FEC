//
// Project       : btc
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for RTL BTC coder/decoder integrated top module
//
`timescale 1ns/1ns

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

  `include "../rtl/btc/btc_parameters.svh"

  parameter int pLLR_W   = 5;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                iclk           ;
  logic                ireset         ;
  logic                iclkena        ;
  //
  btc_code_mode_t      ixmode         ;
  btc_code_mode_t      iymode         ;
  btc_short_mode_t     ismode         ;
  //
  logic                enc__isop      ;
  logic                enc__ieop      ;
  logic                enc__ival      ;
  logic                enc__idat      ;
  //
  logic                enc__obusy     ;
  logic                enc__ordy      ;
  logic                enc__ireq      ;
  logic                enc__ofull     ;
  //
  logic                enc__osop      ;
  logic                enc__oeop      ;
  logic                enc__oeof      ;
  logic                enc__oval      ;
  logic                enc__odat      ;

  bit          [3 : 0] iNiter         ;
  bit                  ifmode         ;

  bit                  dec__ival      ;
  bit                  dec__isop      ;
  bit                  dec__ieop      ;
  bit   [pLLR_W-1 : 0] dec__iLLR      ;
  logic                dec__obusy     ;
  logic                dec__ordy      ;

  bit                  dec__ireq      ;
  logic                dec__ofull     ;

  logic                dec__osop      ;
  logic                dec__oeop      ;
  logic                dec__oval      ;
  logic                dec__odat      ;

  logic                dec__odecfail  ;
  logic       [15 : 0] dec__oerr      ;
  logic       [15 : 0] dec__onum      ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  btc_enc
  enc
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .ixmode  ( ixmode     ) ,
    .iymode  ( iymode     ) ,
    .ismode  ( ismode     ) ,
    //
    .ival    ( enc__ival  ) ,
    .isop    ( enc__isop  ) ,
    .ieop    ( enc__ieop  ) ,
    .idat    ( enc__idat  ) ,
    .itag    ( '0         ) ,
    //
    .ordy    ( enc__ordy  ) ,
    .obusy   ( enc__obusy ) ,
    //
    .ofull   (            ) ,
    .ireq    ( enc__ireq  ) ,
    //
    .oval    ( enc__oval  ) ,
    .osop    ( enc__osop  ) ,
    .oeop    ( enc__oeop  ) ,
    .odat    ( enc__odat  ) ,
    .otag    (            )
  );

  assign enc__ireq = !dec__obusy;

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper. Power is
  //     00 = -1-1i
  //     01 = -1+1i
  //     10 =  1-1i
  //     11 =  1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  logic             enc_sop;
  logic             enc_val;
  logic             enc_eop;
  logic     [1 : 0] enc_dat;

  logic             qpsk_sop;
  logic             qpsk_val;
  logic             qpsk_eop;
  cmplx_real_dat_t  qpsk;

  bit eff;

  always_ff @(posedge iclk) begin
    if (enc__oval) begin
      eff <= enc__osop ? 1'b1 : !eff;
    end
    //
    enc_val <= enc__oval & eff & !enc__osop;
    //
    if (enc__oval) begin // LSB first
      enc_dat[1] <= enc__odat;
      enc_dat[0] <= enc_dat[1];
    end
    //
    if (enc__oval & enc__osop) begin
      enc_sop <= 1'b1;
    end
    else if (enc_val) begin
      enc_sop <= 1'b0;
    end
    //
    enc_eop <= enc__oval & enc__oeop;
  end

  assign qpsk_sop = enc_sop;
  assign qpsk_val = enc_val;
  assign qpsk_eop = enc_eop;

  assign qpsk.re  = enc_dat[1] ? 1 : -1;
  assign qpsk.im  = enc_dat[0] ? 1 : -1;

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  logic             awgn_sop;
  logic             awgn_val;
  logic             awgn_eop;
  cmplx_real_dat_t  awgn_ch;
  cmplx_real_dat_t  qpsk2noise;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    awgn_sop <= qpsk_sop;
    awgn_eop <= qpsk_eop;
    awgn_val <= qpsk_val;
    if (qpsk_val) begin
      awgn_ch     <= awgn.add(qpsk, awgn_bypass);
      qpsk2noise  <= qpsk;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // scale data: set QPSK ref point to -+1024 point and saturate canstellation to -2047 : + 2047 point
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = pLLR_W;

  const int NGC_MAX = 2**(cDAT_W-1)-1;
  const int NGC_REF = 2**(cDAT_W-2);

  real ngc_dat_re;
  real ngc_dat_im;

  bit signed [cDAT_W-1 : 0] dat2llr_re;
  bit signed [cDAT_W-1 : 0] dat2llr_im;

  always_comb begin
    ngc_dat_re = $floor(awgn_ch.re * NGC_REF + 0.5);
    ngc_dat_im = $floor(awgn_ch.im * NGC_REF + 0.5);
    // saturate
    if (ngc_dat_re > NGC_MAX) begin
      ngc_dat_re = NGC_MAX;
    end
    else if (ngc_dat_re < -NGC_MAX) begin
      ngc_dat_re = -NGC_MAX;
    end
    //
    if (ngc_dat_im > NGC_MAX) begin
      ngc_dat_im = NGC_MAX;
    end
    else if (ngc_dat_im < -NGC_MAX) begin
      ngc_dat_im = -NGC_MAX;
    end
    // assign to decoder
    dat2llr_re = ngc_dat_re;
    dat2llr_im = ngc_dat_im;
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  btc_dec
  #(
    .pLLR_W  ( pLLR_W ) ,
    .pDB_NUM ( 2      )
  )
  dec
  (
    .iclk     ( iclk          ) ,
    .ireset   ( ireset        ) ,
    //
    .ixmode   ( ixmode        ) ,
    .iymode   ( iymode        ) ,
    .ismode   ( ismode        ) ,
    .iNiter   ( iNiter        ) ,
    .ifmode   ( ifmode        ) ,
    //
    .iclkin   ( iclk          ) ,
    .ival     ( dec__ival     ) ,
    .isop     ( dec__isop     ) ,
    .ieop     ( dec__ieop     ) ,
    .iLLR     ( dec__iLLR     ) ,
    .itag     ( '0            ) ,
    //
    .ordy     ( dec__ordy     ) ,
    .obusy    ( dec__obusy    ) ,
    //
    .iclkout  ( iclk          ) ,
    .ireq     ( dec__ireq     ) ,
    .ofull    ( dec__ofull    ) ,
    //
    .oval     ( dec__oval     ) ,
    .osop     ( dec__osop     ) ,
    .oeop     ( dec__oeop     ) ,
    .odat     ( dec__odat     ) ,
    .otag     (               ) ,
    //
    .odecfail ( dec__odecfail ) ,
    .oerr     ( dec__oerr     ) ,
    .onum     ( dec__onum     )
  );

  assign dec__ireq = 1'b1;

  bit [1 : 0] val;
  bit [1 : 0] sop;
  bit [1 : 0] eop;

  bit signed [cDAT_W-1 : 0] llr [2];

  always_ff @(posedge iclk) begin
    val <=  awgn_val              ? 2'b11 : (val << 1);
    sop <= (awgn_val & awgn_sop)  ? 2'b10 : (sop << 1);
    eop <= (awgn_val & awgn_eop)  ? 2'b01 : (eop << 1);
    if (awgn_val) begin
      llr[0] <= dat2llr_re;
      llr[1] <= dat2llr_im;
    end
    else begin
      llr[1] <= llr[0];
      llr[0] <= '0;
    end
  end

  assign dec__ival = val[1];
  assign dec__isop = sop[1];
  assign dec__ieop = eop[1];
  assign dec__iLLR = llr[1];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

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

  //------------------------------------------------------------------------------------------------------
  // tb settings
  //------------------------------------------------------------------------------------------------------

  const int Npkt = 100;

  real EbNo [] = '{2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5};
//real EbNo [] = '{6};
//real EbNo [] = '{5, 5.5, 6, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  pkt_class #(1) code_queue [$];

  int  data_num;
  int  err_data_num;
  int  code_num;
  real coderate;

  initial begin
    pkt_class #(1) code;
    //
    code_queue.delete();
    //
    enc__isop <= '0;
    enc__ieop <= '0;
    enc__ival <= '0;
    enc__idat <= '0;

    ismode    <= '0;
    iNiter    <= 5;
    ifmode    <= 1;
    //
    //
    ixmode.code_type <= cSPC_CODE;
    ixmode.code_type <= cE_HAM_CODE;
    ixmode.size      <= cBSIZE_8;
//  ixmode.size      <= cBSIZE_16;
    ixmode.size      <= cBSIZE_32;
//  ixmode.size      <= cBSIZE_64;

    iymode.code_type <= cSPC_CODE;
    iymode.code_type <= cE_HAM_CODE;
    iymode.size      <= cBSIZE_8;
//  iymode.size      <= cBSIZE_16;
//  iymode.size      <= cBSIZE_32;
    iymode.size      <= cBSIZE_64;
    //
    //
    //
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(2), .coderate(1.0), .Ps(cQPSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);

    data_num      = get_data_bits(ixmode) * get_data_bits(iymode);
    code_num      = get_code_bits(ixmode) * get_code_bits(iymode);

    err_data_num  = get_code_bits(ixmode) * get_data_bits(iymode);

    coderate = 1.0 * data_num/code_num;

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(2), .coderate(coderate), .Ps(cQPSK_POW), .seed(2));
      repeat (10) @(posedge iclk);
      //
      @(posedge iclk iff enc__ordy);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data
        code = new(data_num); // generate in bits
        void'(code.randomize());
        // drive data
        for (int i = 0; i < data_num; i++) begin
          enc__ival <= 1'b1;
          enc__isop <= (i == 0);
          enc__ieop <= (i == (data_num-1));
          enc__idat <= code.dat[i];
          @(posedge iclk);
        end
        enc__ival <= 1'b0;
        // save reference
        code_queue.push_back(code);
        // wait all modules free
        @(posedge iclk iff !enc__obusy);
        repeat (16) @(posedge iclk);    // true hack
        @(posedge iclk iff !dec__obusy);
        //
        if ((n % 256) == 0) begin
          $display("sent %0d packets", n);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // count true channel error
  //------------------------------------------------------------------------------------------------------

  int ch_err;

  initial begin
    bit hd_re, hd_im;
    bit ch_re, ch_im;
    forever begin
      @(posedge iclk iff awgn_val);
      hd_re = (qpsk2noise.re >= 0);
      hd_im = (qpsk2noise.im >= 0);
      ch_re = (awgn_ch.re >= 0);
      ch_im = (awgn_ch.im >= 0);
      ch_err += (hd_re ^ ch_re) + (hd_im ^ ch_im);
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  int numerr      [];
  int hd_numerr   [];
  int est_numerr  [];

  initial begin
    pkt_class #(1) decode;
    pkt_class #(1) code;
    int addr;
    int err, hd_err;
    int n;
    int bits, ch_bits, ebits;
    string s;
    //
    numerr      = new[EbNo.size()];
    hd_numerr   = new[EbNo.size()];
    est_numerr  = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr[k]     = 0;
      hd_numerr[k]  = 0;
      est_numerr[k] = 0;
    end
    //
    foreach (EbNo[k]) begin
      n = 0;
      ch_err = 0;
      //
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          if (decode == null) begin
            decode    = new(data_num);
            bits      = data_num*Npkt;
            ebits     = err_data_num*Npkt;
            ch_bits   = code_num*Npkt;
          end
          //
          if (dec__osop) addr = 0;
          //
          decode.dat    [addr] = dec__odat;
          addr++;
          //
          if (dec__oeop) begin
            n++;
            code = code_queue.pop_front();
            err = code.do_compare(decode);
            numerr[k] += err;
            est_numerr[k] += dec__oerr;
            //
//          if ((n % 1024) == 0) begin
//          if (err != 0) begin
//              $display("decode done %0d. err = %0d, est err %0d, ch err %0d", n, err, dec__oerr, ch_err);
//              $stop;
//          end
          end
        end
      end
      while (n < Npkt);
      hd_numerr[k] = ch_err;
      $display("decode EbN0 = %0.2f done. ber = %0.2e, fer = %0.2e, ch_err = %0.2e", EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/ebits, ch_err*1.0/ch_bits);
      //
    end
    $display("code %0d/%0d = %0.2f results", data_num, code_num, coderate);
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0.2e EbNo(SNR) = %0.2f(%0.2f): ber = %0.2e. fer = %0.2e, ch_err = %0.2e", bits, EbNo[k], awgn.get_snr(EbNo[k], 2, coderate), numerr[k]*1.0/bits, est_numerr[k]*1.0/ebits, hd_numerr[k]*1.0/ch_bits);
    end
    $stop;
  end

endmodule


