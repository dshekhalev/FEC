//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.vh
// Description   : testbench for RTL viterbi coder/decoder
//

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

  // numeber of bits per frame. -1 - random bits frame [2*pCONSTR_LENGTH...1000*pCONSTR_LENGTH]
  parameter int pN          = 1000;

  parameter int pTRB_LENGTH = 64;

  parameter int pLLR_W      = 4;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  real cCODE_RATE = 3.0/4;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         iclk                      ;
  logic         ireset                    ;
  logic         iclkena                   ;
  //
  logic         enc__isop                 ;
  logic         enc__ieop                 ;
  logic         enc__ival                 ;
  logic [2 : 0] enc__idat                 ;
  //
  logic         enc__osop                 ;
  logic         enc__oeop                 ;
  logic         enc__oval                 ;
  logic [3 : 0] enc__odat                 ;

  bit                         dec__isop     ;
  bit                         dec__ieop     ;
  bit                         dec__ieof     ;
  bit                         dec__ival     ;
  logic signed [pLLR_W-1 : 0] dec__iLLR [4] ;

  logic          dec__osop                 ;
  logic          dec__oeop                 ;
  logic          dec__oval                 ;
  logic  [2 : 0] dec__odat                 ;
  logic  [1 : 0] dec__obiterr              ;
  logic [15 : 0] dec__oerrcnt              ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  vit_3by4_enc
  #(
    .pTAG_W ( 1 )
  )
  enc
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .isop    ( enc__isop  ) ,
    .ival    ( enc__ival  ) ,
    .ieop    ( enc__ieop  ) ,
    .itag    ( 1'b0       ) ,
    .idat    ( enc__idat  ) ,
    //
    .osop    ( enc__osop  ) ,
    .oval    ( enc__oval  ) ,
    .oeop    ( enc__oeop  ) ,
    .otag    (            ) ,
    .odat    ( enc__odat  )
  );

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper. Power is
  //     00 = -1-1i
  //     01 = -1+1i
  //     10 =  1-1i
  //     11 =  1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  cmplx_real_dat_t qpsk [2];

  assign qpsk[1].re = enc__odat[3] ? 1 : -1;
  assign qpsk[1].im = enc__odat[2] ? 1 : -1;

  assign qpsk[0].re = enc__odat[1] ? 1 : -1;
  assign qpsk[0].im = enc__odat[0] ? 1 : -1;

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  cmplx_real_dat_t  awgn_ch [2];

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    cmplx_real_dat_t tmp0;
    cmplx_real_dat_t tmp1;
    //
    dec__isop <= enc__osop;
    dec__ieop <= enc__oeop;
    dec__ival <= enc__oval;
    if (enc__oval) begin
      tmp0 = awgn.add(qpsk[0], awgn_bypass);
      tmp1 = awgn.add(qpsk[1], awgn_bypass);
      //
      awgn_ch[0] <= tmp0;
      awgn_ch[1] <= tmp1;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // scale data: set QPSK ref point to -+1024 point and saturate canstellation to -2047 : + 2047 point
  //------------------------------------------------------------------------------------------------------

  const int NGC_MAX = 2047;
  const int NGC_REF = 1024;

  bit signed [15 : 0] ngc_dat_re [2];
  bit signed [15 : 0] ngc_dat_im [2];

  always_comb begin
    for (int i = 0; i < 2; i++) begin
      ngc_dat_re[i] = $floor(awgn_ch[i].re * NGC_REF + 0.5);
      ngc_dat_im[i] = $floor(awgn_ch[i].im * NGC_REF + 0.5);
      // saturate
      if (ngc_dat_re[i] > NGC_MAX)
        ngc_dat_re[i] = NGC_MAX;
      else if (ngc_dat_re[i] < -NGC_MAX)
        ngc_dat_re[i] = -NGC_MAX;
      //
      if (ngc_dat_im[i] > NGC_MAX)
        ngc_dat_im[i] = NGC_MAX;
      else if (ngc_dat_im[i] < -NGC_MAX)
        ngc_dat_im[i] = -NGC_MAX;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // cut off bits for decoder
  //  take 5bits {5.3} from ref point
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = pLLR_W;

  bit signed [cDAT_W-1 : 0] dat2llr_re [2];
  bit signed [cDAT_W-1 : 0] dat2llr_im [2];

  always_comb begin
    for (int i = 0; i < 2; i++) begin
      dat2llr_re[i] = ngc_dat_re[i][11 : 12-cDAT_W] + ngc_dat_re[i][15];
      dat2llr_im[i] = ngc_dat_im[i][11 : 12-cDAT_W] + ngc_dat_im[i][15];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  bit signed [cDAT_W-1 : 0] fdat2llr_re;
  bit signed [cDAT_W-1 : 0] fdat2llr_im;

  vit_3by4_dec
  #(
    .pTRB_LENGTH             ( pTRB_LENGTH    ) ,
    //
    .pLLR_W                  ( pLLR_W         ) ,
    //
    .pTAG_W                  ( 1              ) ,
    //
    .pSOP_STATE_SYNC_DISABLE ( 0              )
  )
  dec
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .isop    ( dec__isop    ) ,
    .ival    ( dec__ival    ) ,
    .ieop    ( dec__ieop    ) ,
    .itag    ( 1'b0         ) ,
    .iLLR    ( dec__iLLR    ) ,
    //
    .osop    ( dec__osop    ) ,
    .oval    ( dec__oval    ) ,
    .oeop    ( dec__oeop    ) ,
    .otag    (              ) ,
    .odat    ( dec__odat    ) ,
    .obiterr ( dec__obiterr ) ,
    .oerrcnt ( dec__oerrcnt )
  );

  assign dec__iLLR[3] = dat2llr_re[1];
  assign dec__iLLR[2] = dat2llr_im[1];
  assign dec__iLLR[1] = dat2llr_re[0];
  assign dec__iLLR[0] = dat2llr_im[0];

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
  const int Npkt = 128;
//const int Npkt = 1024;
//const int Npkt = 4096;

//real EbNo [] = '{8};
  real EbNo [] = '{5, 6, 7, 8, 9, 10};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  pkt_class #(3) code_queue [$];

  initial begin
    pkt_class #(3) code;
    //
    code_queue.delete();
    //
    enc__isop <= '0;
    enc__ieop <= '0;
    enc__ival <= '0;
    enc__idat <= '0;
    //
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(2), .coderate(1.0), .Ps(cQPSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(2), .coderate(cCODE_RATE), .Ps(cQPSK_POW), .seed(2));
      awgn.log();
      repeat (10) @(posedge iclk);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data for terminated trellis
        code = new(pN);
        void'(code.randomize());
        // drive data
        for (int i = 0; i < pN; i++) begin
          enc__ival <= 1'b1;
          enc__isop <= (i == 0);
          enc__ieop <= (i == (pN-1));
          enc__idat <= code.dat[i];
          @(posedge iclk);
          enc__ival <= 1'b0;
        end
        // save reference
        code_queue.push_back(code);
        //
        if ((n % 128) == 0)
          $display("sent %0d packets", n);
      end
    end
  end

  int numerr      [];
  int est_numerr  [];

  initial begin
    pkt_class #(3) decode;
    pkt_class #(3) code;
    int addr;
    int err;
    int n;
    int bits, fbits;
    string s;
    //
    int acc_err;
    //
    numerr      = new[EbNo.size()];
    est_numerr  = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr[k]     = 0;
      est_numerr[k] = 0;
    end
    decode = new(pN);
    // bit number used for BER counter
    bits  = 3*pN*Npkt;
    // bit number used for FER counter
    fbits = 4*pN*Npkt;
    //
    foreach (EbNo[k]) begin
      n = 0;
      //
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          if (dec__osop) begin
            addr    = 0;
            acc_err = 0;
          end
          //
          decode.dat[addr] = dec__odat;
          addr++;
          acc_err += dec__obiterr;
          //
          if (dec__oeop) begin
            n++;
            assert (code_queue.size() != 0) else begin
              $error("queue order error");
              $stop;
            end
            code = code_queue.pop_front();
            err = code.do_compare(decode);
            numerr[k] += err;
            est_numerr[k] += acc_err;
//          $display("decode done %0d. err = %0d, est err %0d", n, err, acc_err);
          end
        end
      end
      while (n < Npkt);
      $display("decode EbN0 = %0f done. ber = %0e, fer = %0e", EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/fbits);
      //
    end
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo = %f: ber = %0e. fer = %0e", bits, EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/fbits);
    end
    $stop;
  end

endmodule


