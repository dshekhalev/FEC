//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for RTL coder/decoder for BPSK
//

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

  parameter bit pUSE_L_POLY = 1 ;
  parameter int pLLR_W      = 4 ;

  parameter int pDAT_N      = pUSE_L_POLY ? 8  : 6  ;
  parameter int pN          = pUSE_L_POLY ? 51 : 21 ;

  real cCODE_RATE           = 1.0*pDAT_N/pN;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                iclk      ;
  logic                ireset    ;
  logic                iclkena   ;
  //
  logic                enc__ival ;
  logic [pDAT_N-1 : 0] enc__idat ;
  logic        [7 : 0] enc__itag ;
  logic                enc__ordy ;
  //
  logic                enc__irdy ;
  logic                enc__osop ;
  logic                enc__oval ;
  logic                enc__oeop ;
  logic                enc__odat ;
  logic        [7 : 0] enc__otag ;

  logic                dec__isop       ;
  logic                dec__ival       ;
  logic                dec__ieop       ;
  logic [pLLR_W-1 : 0] dec__iLLR       ;
  logic        [7 : 0] dec__itag       ;
  logic                dec__ordy       ;
  //
  logic                dec__oframe_err ;
  //
  logic                dec__irdy       ;
  logic                dec__oval       ;
  logic [pDAT_N-1 : 0] dec__odat       ;
  logic [pDAT_N-1 : 0] dec__oerr       ;
  logic        [7 : 0] dec__otag       ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  b_bch_enc
  #(
    .pUSE_L_POLY ( pUSE_L_POLY )
  )
  enc
  (
    .iclk    ( iclk      ) ,
    .ireset  ( ireset    ) ,
    .iclkena ( iclkena   ) ,
    //
    .ival    ( enc__ival ) ,
    .idat    ( enc__idat ) ,
    .itag    ( enc__itag ) ,
    .ordy    ( enc__ordy ) ,
    //
    .irdy    ( enc__irdy ) ,
    .osop    ( enc__osop ) ,
    .oval    ( enc__oval ) ,
    .oeop    ( enc__oeop ) ,
    .odat    ( enc__odat ) ,
    .otag    ( enc__otag )
  );

  assign enc__irdy = dec__ordy;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (enc__ival & enc__ordy) begin
        enc__itag <= enc__itag + 1'b1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // BPSK mapper.
  //     0 = -1 - 1i
  //     1 =  1 + 1i
  //------------------------------------------------------------------------------------------------------

  const real cBPSK_POW  = 2.0;

  bit              map_val;
  bit              map_sop;
  bit              map_eop;
  cmplx_real_dat_t map_dat;

  assign map_val    = enc__oval;
  assign map_sop    = enc__osop;
  assign map_eop    = enc__oeop;
  assign map_dat.re = enc__odat ? 1 : -1;
  assign map_dat.im = enc__odat ? 1 : -1;

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  bit               awgn_val;
  bit               awgn_sop;
  bit               awgn_eop;
  cmplx_real_dat_t  awgn_ch;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    awgn_sop <= map_sop;
    awgn_eop <= map_eop;
    awgn_val <= map_val;
    if (map_val) begin
      awgn_ch <= awgn.add(map_dat, awgn_bypass);
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
    ngc_dat    = ngc_dat_re + ngc_dat_im;
    // saturate
    if (ngc_dat > NGC_MAX) begin
      ngc_dat = NGC_MAX;
    end
    else if (ngc_dat < -NGC_MAX)begin
      ngc_dat = -NGC_MAX;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  b_bch_dec
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pLLR_W      ( pLLR_W      )
  )
  dec
  (
    .iclk       ( iclk            ) ,
    .ireset     ( ireset          ) ,
    .iclkena    ( iclkena         ) ,
    //
    .isop       ( dec__isop       ) ,
    .ival       ( dec__ival       ) ,
    .ieop       ( dec__ieop       ) ,
    .iLLR       ( dec__iLLR       ) ,
    .itag       ( dec__itag       ) ,
    .ordy       ( dec__ordy       ) ,
    //
    .oframe_err ( dec__oframe_err ) ,
    //
    .irdy       ( dec__irdy       ) ,
    .oval       ( dec__oval       ) ,
    .odat       ( dec__odat       ) ,
    .oerr       ( dec__oerr       ) ,
    .otag       ( dec__otag       )
  );

  assign dec__isop = awgn_sop;
  assign dec__ieop = awgn_eop;
  assign dec__ival = awgn_val;
  assign dec__iLLR = ngc_dat[11 : 12-pLLR_W];
  assign dec__itag = enc__otag;

  assign dec__irdy = 1'b1;

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

  const int Npkt = 128;

  real SNR [] = '{0.0, 1.0, 2.0, 3.0, 4.0};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  pkt_class #(1) code_queue [$];

  initial begin
    pkt_class #(1) code;
    //
    code_queue.delete();
    //
    enc__ival <= '0;
    enc__idat <= '0;
    //
    awgn.init_SNR(.SNR(SNR[0]), .Ps(cBPSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);

    foreach (SNR[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_SNR(.SNR(SNR[k]), .Ps(cBPSK_POW), .seed(2));

      void'(awgn.add('{0, 0}, 0));
      repeat (10) @(posedge iclk);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data
        code = new(pDAT_N);
        void'(code.randomize());
        // drive data
        for (int i = 0; i < pDAT_N; i++) begin
          enc__idat[i] <= code.dat[i];
        end
        enc__ival <= 1'b1;
        @(posedge iclk iff enc__ordy);
        enc__ival <= 1'b0;

        // save reference
        code_queue.push_back(code);

        // wait decoder free. true hack (!!!!!!!!!)
        @(posedge iclk iff enc__ordy);
        repeat(5) @(posedge iclk);
        @(posedge iclk iff dec__ordy);
        //
        if (((n+1) % 32) == 0)
          $display("send %0d packets", n + 1);
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
    int bits;
    int dat_bits;
    //
    numerr      = new[SNR.size()];
    est_numerr  = new[SNR.size()];
    foreach (numerr[k]) begin
      numerr    [k] = 0;
      est_numerr[k] = 0;
    end
    decode = new(pDAT_N);
    // errors count at full frame
    bits      = pN*Npkt;
    dat_bits  = pDAT_N*Npkt;
    //
    foreach (SNR[k]) begin
      n = 0;
      //
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          //
          for (int i = 0; i < 12; i++) begin
            decode.dat [i] = dec__odat [i];
          end
          //
          n++;
          code = code_queue.pop_front();
          err = code.do_compare(decode);
          numerr    [k] += err;
          est_numerr[k] += dec__oerr;
        end
      end
      while (n < Npkt);
      $display("decode SNR = %0.2f done. ber = %0.3e, est ch ber = %0.3e", SNR[k], numerr[k]*1.0/dat_bits, est_numerr[k]*1.0/bits);  // estimated error by full word
      //
    end
    $display("");
    for (int k = 0; k < SNR.size(); k++) begin
      $display("bits %0d SNR = %.2f: ber = %0.3e. est ch ber = %0.3e", bits, SNR[k], numerr[k]*1.0/dat_bits, est_numerr[k]*1.0/bits);
    end
    $stop;
  end

endmodule


