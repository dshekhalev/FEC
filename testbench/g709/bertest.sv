//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for (G.709) 16-byte interleaved RS(255,239) codec for QPSK AWGN
//

`timescale 1ns/1ns

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic iclk    ;
  logic ireset  ;
  logic iclkena ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic           enc__ival    ;
  logic           enc__isop    ;
  logic [127 : 0] enc__idat    ;
  //
  logic           enc__oval    ;
  logic           enc__osop    ;
  logic [127 : 0] enc__odat    ;

  logic           dec__ival    ;
  logic           dec__isop    ;
  logic [127 : 0] dec__idat    ;
  //
  logic           dec__oval    ;
  logic           dec__osop    ;
  logic [127 : 0] dec__odat    ;
  //
  logic           dec__odecval ;
  logic   [4 : 0] dec__odecerr ;
  logic   [7 : 0] dec__osymerr ;
  logic  [10 : 0] dec__obiterr ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  g709_enc
  enc
  (
    .iclk    ( iclk      ) ,
    .ireset  ( ireset    ) ,
    .iclkena ( iclkena   ) ,
    //
    .ival    ( enc__ival ) ,
    .isop    ( enc__isop ) ,
    .idat    ( enc__idat ) ,
    //
    .oval    ( enc__oval ) ,
    .osop    ( enc__osop ) ,
    .odat    ( enc__odat )
  );

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper. Power is 2
  //     00 = -1-1i
  //     01 = -1+1i
  //     10 =  1-1i
  //     11 =  1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  bit               qpsk_sop  ;
  bit               qpsk_val  ;
  cmplx_real_dat_t  qpsk [64] ;

  always_ff @(posedge iclk) begin
    qpsk_sop <= enc__osop;
    qpsk_val <= enc__oval;
    //
    for (int i = 0; i < 64; i++) begin
      qpsk[i].re <= enc__odat[2*i + 1] ? 1 : -1;
      qpsk[i].im <= enc__odat[2*i + 0] ? 1 : -1;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  cmplx_real_dat_t  awgn_ch  [64];
  bit               awgn_sop;
  bit               awgn_val;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    awgn_sop <= qpsk_sop;
    awgn_val <= qpsk_val;
    if (qpsk_val) begin
      for (int i = 0; i < 64; i++) begin
        awgn_ch[i] <= awgn.add(qpsk[i], awgn_bypass);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  g709_dec
  dec
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .ival    ( dec__ival    ) ,
    .isop    ( dec__isop    ) ,
    .idat    ( dec__idat    ) ,
    //
    .oval    ( dec__oval    ) ,
    .osop    ( dec__osop    ) ,
    .odat    ( dec__odat    ) ,
    //
    .odecval ( dec__odecval ) ,
    .odecerr ( dec__odecerr ) ,
    .osymerr ( dec__osymerr ) ,
    .obiterr ( dec__obiterr )
  );

  always_comb begin
    dec__isop = awgn_sop;
    dec__ival = awgn_val;
    for (int i = 0; i < 64; i++) begin
      dec__idat[2*i + 1] = (awgn_ch[i].re >= 0);
      dec__idat[2*i + 0] = (awgn_ch[i].im >= 0);
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    iclk <= 1'b0;
    #5ns forever #5ns iclk = !iclk;
  end

  initial begin
    ireset = 1'b1;
    repeat (2) @(negedge iclk);
    ireset = 1'b0;
  end

  assign iclkena  = 1'b1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  const int  dataN    = 16*8*239;
  const int  codeN    = 16*8*255;
  const real coderate = 239.0/255.0;

  const int Npkt = 40;

//real EbNo [] = '{8.0};
  real EbNo [] = '{6.5, 6.75, 7.0};

  //------------------------------------------------------------------------------------------------------
  // data generator
  //------------------------------------------------------------------------------------------------------

  event test_done;

  pkt_class #(1) code_queue [$];

  initial begin
    pkt_class #(1) code;
    //
    code_queue.delete();
    //
    enc__ival <= '0;
    enc__isop <= '0;
    enc__idat <= '0;
    //
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(2), .coderate(1.0), .Ps(cQPSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);
    //
    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(2), .coderate(coderate), .Ps(cQPSK_POW), .seed(2));
      awgn.log();
      void'(awgn.add('{0, 0}, 0));
      repeat (10) @(posedge iclk);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data
        code = new(dataN);
        void'(code.randomize());

        // drive data
        for (int i = 0; i < codeN/128; i++) begin
          enc__ival <= 1'b1;
          enc__isop <= (i == 0);
          enc__idat <= '0;
          if (i < dataN/128) begin
            for (int j = 0; j < 128; j++) begin
              enc__idat[j] <= code.dat[128*i + j];
            end
          end
          @(posedge iclk);
          enc__ival <= 1'b0;
          enc__isop <= 1'b0;
        end
        // save reference
        code_queue.push_back(code);
        //
        $display("sent %0d packets", n);
      end
      //
      @(test_done);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // data reciver & checker
  //------------------------------------------------------------------------------------------------------

  int numerr      [];
  int est_numerr  [];

  initial begin
    pkt_class #(1) decode;
    pkt_class #(1) code;
    //
    int addr;
    int err;
    int n;
    string s;
    //
    numerr = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr[k] = 0;
    end
    //
    //
    @(posedge iclk iff !ireset);
    repeat (2) @(posedge iclk);
    //
    foreach (EbNo[k]) begin
      n = 0;
      // get data
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          if (dec__osop) begin
            addr            = 0;
            //
            decode          = new(dataN);
          end
          //
          for (int i = 0; i < 128; i++) begin
            if (addr < dataN) begin
              decode.dat[addr] = dec__odat[i];
            end
            addr++;
          end
          //
          if (addr == codeN) begin
            n++;
            code    = code_queue.pop_front();

            err     = code.do_compare(decode);
            //
            numerr[k]     += err;
            //
            $display("%0t decode done %0d. err = %0d", $time, n, numerr[k]);
          end
        end
      end
      while (n < Npkt);
      -> test_done;

      // intermediate results
      $display("decode EbN0(SNR) = %0.2f(%0.2f) done. ber = %0.2e", EbNo[k], awgn.SNR, numerr[k]*1.0/(Npkt*dataN));
    end
    // final results
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0.2e EbNo(SNR) = %0.2f(%0.2f) : ber = %0.2e", Npkt*dataN, EbNo[k], awgn.get_snr(EbNo[k], .bps(2), .coderate(coderate)),
               numerr[k]*1.0/(Npkt*dataN));
    end
    //
    #1us;
    $display("test done %0t", $time);
    $stop;
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (dec__odecval) begin
          $display("%0t decode val. decerr = %0d, symerr = %0d, biterr = %0d", $time,
                   dec__odecerr, dec__osymerr, dec__obiterr);
      end
    end
  end

endmodule


