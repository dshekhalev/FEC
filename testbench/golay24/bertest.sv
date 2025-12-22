//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for RTL soft decision golay {24, 12, 8} coder/decoder for QPSK
//

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

  parameter int pN  = 12 ;

  real cCODE_RATE   = 1.0/2;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic          iclk      ;
  logic          ireset    ;
  logic          iclkena   ;
  //
  logic          enc__ival  ;
  logic [11 : 0] enc__idat  ;
  //
  logic          enc__oval  ;
  logic [23 : 0] enc__odat  ;

  logic  [3 : 0] iqam;

  bit            dec__isop    ;
  bit            dec__ieop    ;
  bit            dec__ival    ;

  logic          dec__osop    ;
  logic          dec__oeop    ;
  logic          dec__oval    ;
  logic [11 : 0] dec__odat    ;
  logic  [3 : 0] dec__oerr    ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  golay24_enc
  enc
  (
    .iclk    ( iclk      ) ,
    .ireset  ( ireset    ) ,
    .iclkena ( iclkena   ) ,
    //
    .itag    ( '0        ) ,
    .ival    ( enc__ival ) ,
    .idat    ( enc__idat ) ,
    //
    .otag    (           ) ,
    .oval    ( enc__oval ) ,
    .odat    ( enc__odat )
  );

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper.
  //     00 = -1 - 1i
  //     01 = -1 + 1i
  //     10 =  1 - 1i
  //     11 =  1 + 1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW  = 2.0;

  bit [23 : 0]     framer_val;
  bit [23 : 0]     framer_sop;
  bit [23 : 0]     framer_eop;
  bit [23 : 0]     framer_dat;

  bit              map_val;
  bit              map_sop;
  bit              map_eop;
  cmplx_real_dat_t map_dat;

  always_ff @(posedge iclk) begin
    framer_val <= enc__oval ? 24'h555_555 : (framer_val >> 1);
    framer_sop <= enc__oval ? 24'h000_001 : (framer_sop >> 1);
    framer_eop <= enc__oval ? 24'h400_000 : (framer_eop >> 1);

    if (enc__oval)
      framer_dat <= enc__odat;
    else if (framer_val[0])
      framer_dat <= (framer_dat >> 2);
    //
    map_val    <= framer_val[0];
    map_sop    <= framer_sop[0];
    map_eop    <= framer_eop[0];
    map_dat.re <= framer_dat[0] ? 1 : -1;
    map_dat.im <= framer_dat[1] ? 1 : -1;
  end

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

  localparam int cDAT_W = 4; // {4.2}
//localparam int cDAT_W = 5; // {5.3}
//localparam int cDAT_W = 6; // {5.3}

  bit signed [cDAT_W-1 : 0] dat2llr_re;
  bit signed [cDAT_W-1 : 0] dat2llr_im;

  always_comb begin
    dat2llr_re = ngc_dat_re[11 : 12-cDAT_W];
    dat2llr_im = ngc_dat_im[11 : 12-cDAT_W];
  end


  bit        [1 : 0] dec_sop;
  bit        [1 : 0] dec_eop;
  bit        [1 : 0] dec_val;

  bit [cDAT_W-1 : 0] dec_dat [2];

  bit [cDAT_W-1 : 0] dec__iLLR;

  always_ff @(posedge iclk) begin
    dec_sop <= awgn_sop ? 2'b01 : (dec_sop >> 1);
    dec_eop <= awgn_eop ? 2'b10 : (dec_eop >> 1);
    dec_val <= awgn_val ? 2'b11 : (dec_val >> 1);
    //
    if (awgn_val)
      {dec_dat[1], dec_dat[0]} <= {dat2llr_im, dat2llr_re};
    else
      dec_dat[0] <= dec_dat[1];
  end

  assign dec__isop = dec_sop[0];
  assign dec__ieop = dec_eop[0];
  assign dec__ival = dec_val[0];
  assign dec__iLLR = dec_dat[0];

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  golay24_dec
  #(
    .pLLR_W ( cDAT_W )
  )
  uut_rtl
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,

    .isop    ( dec__isop  ) ,
    .ival    ( dec__ival  ) ,
    .ieop    ( dec__ieop  ) ,
    .itag    ( '0         ) ,
    .iLLR    ( dec__iLLR  ) ,
    //
    .oval    ( dec__oval  ) ,
    .otag    (            ) ,
    .odat    ( dec__odat  ) ,
    .oerr    ( dec__oerr  )
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

  assign iqam     = 2;

  //------------------------------------------------------------------------------------------------------
  // tb settings
  //------------------------------------------------------------------------------------------------------

//const int Npkt = 10;
//const int Npkt = 128;
//const int Npkt = 1024;
//const int Npkt = 2048;
//const int Npkt = 4096;

  const int B = 1e5;
  const int Npkt = B/pN;

//real EbNo [] = '{4.0};
  real EbNo [] = '{3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5};


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
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(2), .coderate(1.0), .Ps(cQPSK_POW), .seed(0));
    //
    $display("Test modulation %0d bps", iqam);
    //
    @(posedge iclk iff !ireset);

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(2), .coderate(cCODE_RATE), .Ps(cQPSK_POW), .seed(2));
      awgn.log();
      void'(awgn.add('{0, 0}, 0));
      repeat (10) @(posedge iclk);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data
        code = new(pN);
        void'(code.randomize());
        // drive data
        for (int i = 0; i < pN; i++) begin
          enc__idat[i] <= code.dat[i];
        end
        enc__ival <= 1'b1;
        @(posedge iclk);
        enc__ival <= 1'b0;

        // save reference
        code_queue.push_back(code);

        // wait all modules free
        repeat(24) @(posedge iclk);   // true hack
        //
        if ((n % 512) == 0)
          $display("sent %0d packets", n);
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
    int tmp;
    string s;
    //
    numerr      = new[EbNo.size()];
    est_numerr  = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr    [k] = 0;
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

          //
          if ((n % 512) == 0) begin
            $display("decode done %0d. err = %0d, est err %0d", n, numerr[k], est_numerr[k]);
          end
//        $display("decode done %0d. err = %0d, est err %0d", n, err, dec__oerr);
        end
      end
      while (n < Npkt);
      $display("decode EbN0 = %0.2f done. ber = %0.2e, fer = %0.2e", EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*cCODE_RATE*1.0/bits);  // estimated error by full word
      //
    end
    //
    $display("");
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo = %.2f: ber = %0.2e. fer = %0.2e", bits, EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*cCODE_RATE*1.0/bits);
    end
    $stop;
  end

endmodule


