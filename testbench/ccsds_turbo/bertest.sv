
`timescale 1ns/1ns

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

  parameter int pNIDX   = 3;

  parameter int pIDX_TAB [4] = '{1, 2, 4, 5};

  parameter int pN      = 1784*pIDX_TAB[pNIDX] ; // 1784*[1/2/4/5]

  parameter int pCODE   =  3 ;   // 0/1/2/3 - 1/2, 1/3, 1/4, 1/6

  parameter int pN_ITER =  10 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  real cCODE_RATE [] = '{ 1.0/2, 1.0/3, 1.0/4, 1.0/6};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                 iclk      ;
  logic                 ireset    ;
  logic                 iclkena   ;
  //
  logic                 enc__isop  ;
  logic                 enc__ieop  ;
  logic                 enc__ival  ;
  logic                 enc__idat  ;
  //
  logic                 enc__obusy ;
  logic                 enc__ordy  ;
  //
  logic                 enc__osop  ;
  logic                 enc__oeop  ;
  logic                 enc__oval  ;
  logic                 enc__odat  ;

  bit                   dec__isop  ;
  bit                   dec__ieop  ;
  bit                   dec__ival  ;

  logic                 dec__obusy ;
  logic                 dec__ordy  ;

  logic                 dec__osop  ;
  logic                 dec__oeop  ;
  logic                 dec__oval  ;
  logic                 dec__odat  ;
  logic        [15 : 0] dec__oerr  ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_enc
  enc
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    //
    .icode   ( pCODE       ) ,
    .inidx   ( pNIDX       ) ,
    //
    .isop    ( enc__isop   ) ,
    .ieop    ( enc__ieop   ) ,
    .ival    ( enc__ival   ) ,
    .idat    ( enc__idat   ) ,
    .itag    ( 0           ) ,
    //
    .obusy   ( enc__obusy  ) ,
    .ordy    ( enc__ordy   ) ,
    //
    .osop    ( enc__osop   ) ,
    .oeop    ( enc__oeop   ) ,
    .oval    ( enc__oval   ) ,
    .odat    ( enc__odat   ) ,
    .otag    (             )
  );

  //------------------------------------------------------------------------------------------------------
  // BPSK mapper. Power is
  //     0 = -1-1i
  //     1 =  1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  cmplx_real_dat_t bpsk;

  assign bpsk.re = enc__odat ? 1 : -1;
  assign bpsk.im = enc__odat ? 1 : -1;

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  cmplx_real_dat_t  awgn_ch;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    dec__isop <= enc__osop;
    dec__ieop <= enc__oeop;
    dec__ival <= enc__oval;
    if (enc__oval) begin
      awgn_ch <= awgn.add(bpsk, awgn_bypass);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // scale data: set QPSK ref point to -+1024 point and saturate canstellation to -2047 : + 2047 point
  //------------------------------------------------------------------------------------------------------

  const int NGC_MAX = 2047;
  const int NGC_REF = 1024;

  bit signed [15 : 0] ngc_dat_re;
  bit signed [15 : 0] ngc_dat_im;

  bit signed [15 : 0] ngc_dat;

  always_comb begin
    ngc_dat_re = $floor(awgn_ch.re * NGC_REF + 0.5);
    ngc_dat_im = $floor(awgn_ch.im * NGC_REF + 0.5);
    //
    ngc_dat    = (ngc_dat_re + ngc_dat_im + 1)/2;
    // saturate
    if (ngc_dat > NGC_MAX)
      ngc_dat = NGC_MAX;
    else if (ngc_dat < -NGC_MAX)
      ngc_dat = -NGC_MAX;
  end

  //------------------------------------------------------------------------------------------------------
  // cut off bits for decoder
  //------------------------------------------------------------------------------------------------------

//localparam int cDAT_W = 4; // {4.2}
  localparam int cDAT_W = 5; // {5.3}
//localparam int cDAT_W = 8; // {8.6}

  bit   signed [cDAT_W-1 : 0] dat2llr;

  logic signed [cDAT_W-1 : 0] dec__iLLR;

  always_comb begin
    dat2llr = ngc_dat[11 : 12-cDAT_W];
  end

  assign dec__iLLR = dat2llr;

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec
  #(
    .pLLR_W     ( cDAT_W ) ,
    .pMMAX_TYPE ( 0      )
  )
  uut
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .icode   ( pCODE        ) ,
    .inidx   ( pNIDX        ) ,
    .iNiter  ( pN_ITER      ) ,
    //
    .isop    ( dec__isop    ) ,
    .ieop    ( dec__ieop    ) ,
    .ival    ( dec__ival    ) ,
    .itag    ( 0            ) ,
    .iLLR    ( dec__iLLR    ) ,
    //
    .ireq    ( 1'b1         ) ,
    .ofull   (              ) ,
    //
    .obusy   ( dec__obusy   ) ,
    .ordy    ( dec__ordy    ) ,
    //
    .osop    ( dec__osop    ) ,
    .oeop    ( dec__oeop    ) ,
    .oval    ( dec__oval    ) ,
    .otag    (              ) ,
    .odat    ( dec__odat    ) ,
    //
    .oerr    ( dec__oerr    )
  );

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

//const int Npkt = 1;
  const int Npkt = 16;
//const int Npkt = 128;
//const int Npkt = 1024;
//const int Npkt = 4096;

  const int B = 1e6;
//const int Npkt = B/(pN);

//real EbNo [] = '{-0.125, 0.0, 0.125, 0.25, 0.375};
  real EbNo [] = '{-0.125, 0.0, 0.125, 0.25};
//real EbNo [] = '{0.25, 0.375, 0.5, 0.75};
//real EbNo [] = '{0.25};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  pkt_class #(1) code_queue [$];

  initial begin
    pkt_class #(1) code;
    //
    code_queue.delete();
    //
    enc__isop <= '0;
    enc__ieop <= '0;
    enc__ival <= '0;
    enc__idat <= '0;
    //
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(1), .coderate(1.0), .Ps(cQPSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(1), .coderate(cCODE_RATE[pCODE]), .Ps(cQPSK_POW), .seed(2));
      repeat (10) @(posedge iclk);
      //
      @(posedge iclk iff enc__ordy);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data
        code = new(pN);
        void'(code.randomize());
        // drive data
        for (int i = 0; i < pN; i++) begin
          enc__ival <= 1'b1;
          enc__isop <= (i == 0);
          enc__ieop <= (i == (pN-1));
          enc__idat <= code.dat[i];
          @(posedge iclk);
        end
        enc__ival <= 1'b0;
        // save reference
        code_queue.push_back(code);
        // wait all modules free
        @(posedge iclk iff !enc__obusy);
        repeat (16) @(posedge iclk);    // true hack

        @(posedge iclk iff dec__ordy);
        //
        if ((n % 128) == 0)
          $display("sent %0d packets", n);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  int numerr      [];
  int est_numerr  [];

  initial begin
    pkt_class #(1) decode;
    pkt_class #(1) code;
    int addr;
    int err;
    int n;
    int bits;
    string s;
    //
    numerr      = new[EbNo.size()];
    est_numerr  = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr[k]     = 0;
      est_numerr[k] = 0;
    end
    decode = new(pN);
    //
    bits = pN*Npkt;
    //
    foreach (EbNo[k]) begin
      n = 0;
      //
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          if (dec__osop) begin
            addr = 0;
          end
          //
          decode.dat[addr] = dec__odat;
          //
          addr++;
          //
          if (dec__oeop) begin
            n++;
            code = code_queue.pop_front();
            err = code.do_compare(decode);
            numerr[k] += err;
            est_numerr[k] += dec__oerr;
            //
            if ((n % 32) == 0) begin
              $display("decode done %0d. err = %0d, est err %0d", n, err, dec__oerr);
            end
          end
        end
      end
      while (n < Npkt);
      $display("decode EbN0(SNR) = %0.2f(%0.2f) done. ber = %0e, fer = %0e", EbNo[k], awgn.get_snr(EbNo[k], 1, .coderate(cCODE_RATE[pCODE])), numerr[k]*1.0/bits, est_numerr[k]*1.0/bits);
      //
    end
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo(SNR) = %0.2f(%0.2f): ber = %0e. fer = %0e", bits, EbNo[k], awgn.get_snr(EbNo[k], 1, .coderate(cCODE_RATE[pCODE])), numerr[k]*1.0/bits, est_numerr[k]*1.0/bits);
    end

    awgn = null;
    $stop;
  end

endmodule


