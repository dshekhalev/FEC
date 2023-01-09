//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for RTL viterbi 1/2 coder/decoder
//

`include "awgn_class.svh"
`include "vit_pkt_class.svh"

module bertest ;

//parameter int pCONSTR_LENGTH            = 3;
//parameter int pCODE_GEN_NUM             = 2;  // fixed for this tb
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};

//parameter int pCONSTR_LENGTH            = 5;
//parameter int pCODE_GEN_NUM             = 2;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o35, 'o31};

  parameter int pCONSTR_LENGTH            = 7;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o171, 'o133};

//parameter int pCONSTR_LENGTH            = 9;
//parameter int pCODE_GEN_NUM             = 2;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o657, 'o435};

  // numeber of bits per frame. -1 - random bits frame [2*pCONSTR_LENGTH...1000*pCONSTR_LENGTH]
  parameter int pN            = 1010;

  parameter int pTRB_LENGTH = 65; //5*pCONSTR_LENGTH;

  parameter int pLLR_W      = 4;    // 1/>1 - hard/soft decision

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  real cCODE_RATE = 1.0*pN/(pCODE_GEN_NUM*(pN + pCONSTR_LENGTH-1));

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                       iclk                      ;
  logic                       ireset                    ;
  logic                       iclkena                   ;
  //
  logic                       enc__isop                 ;
  logic                       enc__ieop                 ;
  logic                       enc__ival                 ;
  logic                       enc__idat                 ;
  logic                       enc__ordy                 ;
  //
  logic                       enc__osop                 ;
  logic                       enc__oeop                 ;
  logic                       enc__oval                 ;
  logic [pCODE_GEN_NUM-1 : 0] enc__odat                 ;

  bit                         dec__isop                 ;
  bit                         dec__ieop                 ;
  bit                         dec__ieof                 ;
  bit                         dec__ival                 ;
  logic [pCODE_GEN_NUM-1 : 0] dec__idat                 ;
  logic signed [pLLR_W-1 : 0] dec__iLLR [pCODE_GEN_NUM] ;

  logic                       dec__osop                 ;
  logic                       dec__oeop                 ;
  logic                       dec__oval                 ;
  logic                       dec__odat                 ;
  logic [pCODE_GEN_NUM-1 : 0] dec__obiterr              ;
  logic              [15 : 0] dec__oerrcnt              ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  vit_enc
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    //
    .pTAG_W         ( 1              )
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
    .ordy    ( enc__ordy  ) ,
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

  cmplx_real_dat_t qpsk;

  assign qpsk.re = enc__odat[1] ? 1 : -1;
  assign qpsk.im = enc__odat[0] ? 1 : -1;

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
      awgn_ch <= awgn.add(qpsk, awgn_bypass);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // scale data: set QPSK ref point to -+1024 point and saturate canstellation to -2047 : + 2047 point
  //------------------------------------------------------------------------------------------------------

  const int NGC_MAX = 2047;
  const int NGC_REF = 1024;

  bit signed [15 : 0] ngc_dat_re;
  bit signed [15 : 0] ngc_dat_im;

  always_comb begin
    ngc_dat_re = $floor(awgn_ch.re * NGC_REF + 0.5);
    ngc_dat_im = $floor(awgn_ch.im * NGC_REF + 0.5);
    // saturate
    if (ngc_dat_re > NGC_MAX)
      ngc_dat_re = NGC_MAX;
    else if (ngc_dat_re < -NGC_MAX)
      ngc_dat_re = -NGC_MAX;
    //
    if (ngc_dat_im > NGC_MAX)
      ngc_dat_im = NGC_MAX;
    else if (ngc_dat_im < -NGC_MAX)
      ngc_dat_im = -NGC_MAX;
  end

  //------------------------------------------------------------------------------------------------------
  // cut off bits for decoder
  //  take 5bits {5.3} from ref point
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = (pLLR_W == 1) ? 4 : pLLR_W;

  bit signed [cDAT_W-1 : 0] dat2llr_re;
  bit signed [cDAT_W-1 : 0] dat2llr_im;

  always_comb begin
    dat2llr_re = ngc_dat_re[11 : 12-cDAT_W] + ngc_dat_re[15];
    dat2llr_im = ngc_dat_im[11 : 12-cDAT_W] + ngc_dat_im[15];
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  bit signed [cDAT_W-1 : 0] fdat2llr_re;
  bit signed [cDAT_W-1 : 0] fdat2llr_im;

  vit_dec
  #(
    .pCONSTR_LENGTH          ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM           ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN               ( pCODE_GEN      ) ,
    //
    .pTRB_LENGTH             ( pTRB_LENGTH    ) ,
    //
    .pLLR_W                  ( pLLR_W         ) ,
    //
    .pTAG_W                  ( 1              ) ,
    //
    .pSOP_STATE_SYNC_DISABLE ( 0              ) ,
    .pUSE_ACSU_LA            ( 0              )
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
    .idat    ( dec__idat    ) ,
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

  assign dec__idat[1] = !ngc_dat_re[15];
  assign dec__idat[0] = !ngc_dat_im[15];

  assign dec__iLLR[1] = dat2llr_re;
  assign dec__iLLR[0] = dat2llr_im;

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
//real EbNo [] = '{5, 6, 7, 8, 9, 10};  // use for hard decision
  real EbNo [] = '{3, 4, 5, 6, 7};      // use for soft decision

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  vit_pkt_class code_queue [$];

  initial begin
    vit_pkt_class code;
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
          @(posedge iclk iff enc__ordy);
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
    vit_pkt_class decode;
    vit_pkt_class code;
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
    bits  = pN*Npkt;
    // bit number used for FER counter
    fbits = pCODE_GEN_NUM*pN*Npkt;
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


