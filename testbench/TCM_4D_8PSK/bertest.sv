//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.vh
// Description   : testbench for RTL 4D 8PSK TCM coder/decoder
//

`include "awgn_class.svh"
`include "tcm_pkt_class.svh"

module bertest ;

  parameter int pN        = 1000;
  parameter int pDAT_W    = 12; // <= 16
  parameter int pSYMB_M_W = 4;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCODE    = 0;  // 0/1/2/3 - 2/2.25/2.5/2.75

  real cCODE_RATE [4] = '{2.0/3, 2.25/3, 2.5/3, 2.75/3};

  int  cBIT_NUM   [4] = '{8, 9, 10, 11};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                iclk         ;
  logic                ireset       ;
  logic                iclkena      ;
  //
  logic        [1 : 0] icode        ;
  //
  logic                enc__i1sps   ;
  logic                enc__isop    ;
  logic                enc__ieop    ;
  logic                enc__ival    ;
  logic       [10 : 0] enc__idat    ;
  //
  logic                enc__o1sps   ;
  logic                enc__osop    ;
  logic                enc__oeop    ;
  logic                enc__oval    ;
  logic        [2 : 0] enc__odat    ;

  logic                dec__i1sps   ;
  logic                dec__isop    ;
  logic                dec__ival    ;
  logic                dec__ieop    ;
  logic [pDAT_W-1 : 0] dec__idat_re ;
  logic [pDAT_W-1 : 0] dec__idat_im ;

  logic                dec__osop    ;
  logic                dec__oval    ;
  logic                dec__oeop    ;
  logic       [10 : 0] dec__odat    ;
  logic        [3 : 0] dec__obiterr ;
  logic       [15 : 0] dec__oerrcnt ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  tcm_enc
  enc
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .icode   ( icode      ) ,
    .i1sps   ( enc__i1sps ) ,
    //
    .isop    ( enc__isop  ) ,
    .ieop    ( enc__ieop  ) ,
    .ival    ( enc__ival  ) ,
    .idat    ( enc__idat  ) ,
    //
    .o1sps   ( enc__o1sps ) ,
    .osop    ( enc__osop  ) ,
    .oeop    ( enc__oeop  ) ,
    .oval    ( enc__oval  ) ,
    .odat    ( enc__odat  )
  );

  //------------------------------------------------------------------------------------------------------
  // 8PSK mapper
  //------------------------------------------------------------------------------------------------------

  const real c8PSK_POW = 1.0;

  localparam real c8PSK_MAP_TAB [8][2] = '{
    '{ 1.0,    0.0},
    '{ 0.707,  0.707},
    '{ 0.0,    1.0},
    '{-0.707,  0.707},
    '{-1.0,    0.0},
    '{-0.707, -0.707},
    '{ 0.0,   -1.0},
    '{ 0.707, -0.707}
    };

  cmplx_real_dat_t s8psk;

  always_comb begin
    s8psk.re = c8PSK_MAP_TAB[enc__odat][0];
    s8psk.im = c8PSK_MAP_TAB[enc__odat][1];
  end

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  cmplx_real_dat_t  awgn_ch;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    dec__i1sps  <= enc__o1sps;
    dec__isop   <= enc__osop;
    dec__ieop   <= enc__oeop;
    dec__ival   <= enc__oval;
    if (enc__o1sps) begin
      awgn_ch <= awgn.add(s8psk, awgn_bypass);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // scale data: set QPSK ref point to -+1024 point and saturate canstellation to -2047 : + 2047 point
  //------------------------------------------------------------------------------------------------------

  const int NGC_MAX = 2**(pDAT_W-1)-1;
  const int NGC_REF = 2**(pDAT_W-2);

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
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    dec__idat_re = ngc_dat_re[pDAT_W-1 : 0];// + ngc_dat_re[15];
    dec__idat_im = ngc_dat_im[pDAT_W-1 : 0];// + ngc_dat_im[15];
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  tcm_dec
  #(
    .pDAT_W                  ( pDAT_W    ) ,
    .pSYMB_M_W               ( pSYMB_M_W ) ,
    .pSOP_STATE_SYNC_DISABLE ( 0         ) ,
    .pUSE_TRB_FAST_DECISION  ( 1         )
  )
  dec
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .icode   ( icode        ) ,
    //
    .i1sps   ( dec__i1sps   ) ,
    //
    .isop    ( dec__isop    ) ,
    .ival    ( dec__ival    ) ,
    .ieop    ( dec__ieop    ) ,
    .idat_re ( dec__idat_re ) ,
    .idat_im ( dec__idat_im ) ,
    //
    .osop    ( dec__osop    ) ,
    .oval    ( dec__oval    ) ,
    .oeop    ( dec__oeop    ) ,
    .odat    ( dec__odat    ) ,
    //
    .obiterr ( dec__obiterr ) ,
    .oerrcnt ( dec__oerrcnt )
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

  localparam int cB = 1e7;
//const int Npkt = cB/(cBIT_NUM[cCODE]*pN);

//const int Npkt = 1;
  const int Npkt = 128;
//const int Npkt = 1024;
//const int Npkt = 4096;

//real EbNo [] = '{8};
  real EbNo [] = '{5, 6,  7,  8,  9}; // 2/3    = 2.0
//real EbNo [] = '{6, 7,  8,  9, 10}; // 3/4    = 2.25
//real EbNo [] = '{7, 8,  9, 10, 11}; // 5/6    = 2.5
//real EbNo [] = '{8, 9, 10, 11, 12}; // 11/12  = 2.75

  assign icode = cCODE;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  tcm_pkt_class code_queue [$];

  initial begin
    tcm_pkt_class code;
    //
    code_queue.delete();
    //
    enc__i1sps <= '0;
    enc__isop  <= '0;
    enc__ieop  <= '0;
    enc__ival  <= '0;
    enc__idat  <= '0;
    //
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(3), .coderate(1.0), .Ps(c8PSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(3), .coderate(cCODE_RATE[cCODE]), .Ps(c8PSK_POW), .seed(2));
      awgn.log();
      repeat (10) @(posedge iclk);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data
        code = new(pN, cCODE);
        void'(code.randomize());
        //
        // drive data
        for (int i = 0; i < pN; i++) begin
          enc__i1sps <= 1'b1;
          enc__ival  <= 1'b1;
          enc__isop  <= (i == 0);
          enc__ieop  <= (i == (pN-1));
          enc__idat  <= code.dat[i];
          @(posedge iclk);
          enc__ival <= 1'b0;
          repeat (3) @(posedge iclk);
          enc__i1sps <= 1'b0;
        end
        // save reference
        code_queue.push_back(code);
        //
        if ((n % 16) == 0)
          $display("sent %0d packets", n);
      end
    end
  end

  int numerr      [];
  int est_numerr  [];

  initial begin
    tcm_pkt_class decode;
    tcm_pkt_class code;
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
    decode = new(pN, cCODE);
    // bit number used for BER counter
    bits  = cBIT_NUM[cCODE] * pN * Npkt;
    // bit number used for FER counter
    fbits = bits/cCODE_RATE[cCODE];
    //c
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


