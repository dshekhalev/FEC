//
// Project       : polar code 3GPP
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for behaviour polar code
//

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

  parameter int pN_MAX    = 1024;
  parameter int pDATA_N   = pN_MAX/2;   // 1/2
//parameter int pDATA_N   = pN_MAX*7/8; // 7/8
  parameter bit pUSE_CRC  = 0;

  parameter int pLLR_W    = 4;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  real cCODE_RATE = (1.0*pDATA_N)/pN_MAX;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                       iclk      ;
  logic                       ireset    ;
  logic                       iclkena   ;
  //
  logic                       enc__isop ;
  logic                       enc__ieop ;
  logic                       enc__ival ;
  logic                       enc__idat ;
  logic                       enc__ordy ;
  //
  logic                       enc__osop ;
  logic                       enc__oeop ;
  logic                       enc__oval ;
  logic                       enc__odat ;

  logic                       dec__isop ;
  logic                       dec__ieop ;
  logic                       dec__ival ;
  logic signed [pLLR_W-1 : 0] dec__iLLR ;
  logic                       dec__ordy ;

  logic                       dec__osop ;
  logic                       dec__oeop ;
  logic                       dec__oval ;
  logic                       dec__odat ;
  int                         dec__oerr ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

//pc_3gpp_enc_beh
  pc_3gpp_enc_opt_beh2rtl
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pDATA_N  ( pDATA_N  ) ,
    .pUSE_CRC ( pUSE_CRC )
  )
  enc
  (
    .iclk    ( iclk      ) ,
    .ireset  ( ireset    ) ,
    .iclkena ( iclkena   ) ,
    //
    .isop    ( enc__isop ) ,
    .ival    ( enc__ival ) ,
    .ieop    ( enc__ieop ) ,
    .idat    ( enc__idat ) ,
    .ordy    ( enc__ordy ) ,
    //
    .osop    ( enc__osop ) ,
    .oval    ( enc__oval ) ,
    .oeop    ( enc__oeop ) ,
    .odat    ( enc__odat )
  );

  //------------------------------------------------------------------------------------------------------
  // BPSK mapper. Power is
  //     0 = -1-1i
  //     1 = 1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  cmplx_real_dat_t qpsk;

  assign qpsk.re = enc__odat ? 1 : -1;
  assign qpsk.im = enc__odat ? 1 : -1;

  const real cBPSK_POW = 1.0;

  cmplx_real_dat_t bpsk;

  assign bpsk.re = enc__odat ? 1 : -1;
  assign bpsk.im = 0;

//`define __USE_TRUE_BPSK__

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
`ifdef __USE_TRUE_BPSK__
      awgn_ch <= awgn.add(bpsk, awgn_bypass);
`else
      awgn_ch <= awgn.add(qpsk, awgn_bypass);
`endif
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
  end

  //------------------------------------------------------------------------------------------------------
  // cut off bits for decoder
  //  take 5bits {5.3} from ref point
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = pLLR_W;

  bit signed [15 : 0] dat_sum;

  bit signed [cDAT_W-1 : 0] dat2llr;

  always_comb begin
`ifdef __USE_TRUE_BPSK__
    dat2llr = ngc_dat_re[11 -: cDAT_W] + ngc_dat_re[15];
`else
    dat_sum = (ngc_dat_re + ngc_dat_im);
    if (dat_sum > NGC_MAX) begin
      dat2llr = {1'b0, {{cDAT_W-1}{1'b1}}};
    end
    else if (dat_sum < -NGC_MAX) begin
      dat2llr = {1'b1, {{cDAT_W-1}{1'b0}}};
    end
    else begin
      dat2llr = dat_sum[11 -: cDAT_W];
    end
`endif
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

//pc_3gpp_dec_sc_mo_beh
  pc_3gpp_dec_fssc4_mo_beh2rtl
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pN_MAX   ( pN_MAX   ) ,
    .pDATA_N  ( pDATA_N  ) ,
    .pUSE_CRC ( pUSE_CRC )
  )
  dec
  (
    .iclk     ( iclk       ) ,
    .ireset   ( ireset     ) ,
    .iclkena  ( iclkena    ) ,
    //
    .isop     ( dec__isop  ) ,
    .ival     ( dec__ival  ) ,
    .ieop     ( dec__ieop  ) ,
    .iLLR     ( dec__iLLR  ) ,
    .ordy     ( dec__ordy  ) ,
    //
    .osop     ( dec__osop  ) ,
    .oval     ( dec__oval  ) ,
    .oeop     ( dec__oeop  ) ,
    .odat     ( dec__odat  ) ,
    .oerr     ( dec__oerr  ) ,
    //
    .ocrc_err (            )
  );

  assign dec__iLLR = dat2llr;

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

//const int Npkt = 8;
  const int Npkt = 128;

//real EbNo [] = '{8};
  real EbNo [] = '{2, 3, 4, 5, 6};

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
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(2), .coderate(1.0), .Ps(cQPSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
`ifdef __USE_TRUE_BPSK__
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(1), .coderate(cCODE_RATE), .Ps(cBPSK_POW), .seed(2));
`else
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(1), .coderate(cCODE_RATE), .Ps(cQPSK_POW), .seed(2));
`endif
      awgn.log();
      repeat (10) @(posedge iclk);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data for terminated trellis
        code = new(pDATA_N);
        void'(code.randomize());
        // drive data
        for (int i = 0; i < pDATA_N; i++) begin
          enc__ival <= 1'b1;
          enc__isop <= (i == 0);
          enc__ieop <= (i == (pDATA_N-1));
          enc__idat <= code.dat[i];
          @(posedge iclk iff enc__ordy);
          enc__ival <= 1'b0;
        end
        // save reference
        code_queue.push_back(code);
        //
        if ((n % 128) == 0) begin
          $display("sent %0d packets", n);
        end
        //
        @(posedge iclk iff enc__ordy);
        repeat (16) @(posedge iclk iff dec__ordy);
      end
    end
  end

  int numerr      [];
  int est_numerr  [];

  initial begin
    pkt_class #(1) decode;
    pkt_class #(1) code;
    int addr;
    int err;
    int n;
    int bits, fbits;
    string s;
    //
    int dec_err;
    //
    numerr      = new[EbNo.size()];
    est_numerr  = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr[k]     = 0;
      est_numerr[k] = 0;
    end
    decode = new(pDATA_N);
    // bit number used for BER counter
    bits  = pDATA_N*Npkt;
    // bit number used for FER counter
    fbits = pN_MAX*Npkt;
    //
    foreach (EbNo[k]) begin
      n = 0;
      //
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          if (dec__osop) begin
            addr    = 0;
            dec_err = dec__oerr;
          end
          //
          decode.dat[addr] = dec__odat;
          addr++;
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
            est_numerr[k] += dec_err;
            //
            if ((n % 64) == 0) begin
              $display("decode done %0d. err = %0d, est err %0d", n, err, dec_err);
            end
          end
        end
      end
      while (n < Npkt);
      $display("decode EbN0 = %0.2f done. ber = %0.2e, fer = %0.2e", EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/fbits);
      //
    end
    //
    $display("");
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo = %0.2f: ber = %0.2e. fer = %0.2e", bits, EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/fbits);
    end
    $stop;
  end

endmodule


