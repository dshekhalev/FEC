//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for RTL RSC2 coder/decoder for QPSK
//

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

//parameter int pCODE       =  0 ;
  parameter int pCODE       =  1 ;
//parameter int pCODE       =  2 ;
//parameter int pCODE       =  3 ;
//parameter int pCODE       =  4 ;
//parameter int pCODE       =  5 ;
//parameter int pCODE       =  6 ;
//parameter int pCODE       =  7 ;

//parameter int pPTYPE      =  0 ;  // 14 bytes == 56 dbits
  parameter int pPTYPE      =  1 ;  // 38 bytes == 152 dbits

//parameter int pN          = 56 ;
  parameter int pN          = 152;

  parameter int pNiter      = 8;

  parameter int pODAT_W     = 2;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  real cCODE_RATE [] = '{ 1.0/3,
                          1.0/2, 2.0/3, 3.0/4, 4.0/5, 5.0/6, 6.0/7, 7.0/8};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic          iclk      ;
  logic          ireset    ;
  logic          iclkena   ;
  //
  logic          enc__isop  ;
  logic          enc__ieop  ;
  logic          enc__ival  ;
  logic  [1 : 0] enc__idat  ;
  //
  logic          enc__obusy ;
  logic          enc__ordy  ;
  //
  bit            enc__idbsclk ;

  logic          enc__osop  ;
  logic          enc__oeop  ;
  logic          enc__oeof  ;
  logic          enc__oval  ;
  logic  [1 : 0] enc__odat  ;

  logic  [3 : 0] iqam;

  bit            dec__isop  ;
  bit            dec__ieop  ;
  bit            dec__ieof  ;
  bit            dec__ival  ;

  logic          dec__obusy ;
  logic          dec__ordy  ;

  logic          dec__osop  ;
  logic          dec__oeop  ;
  logic          dec__oval  ;
  logic  [1 : 0] dec__odat  ;
  logic [15 : 0] dec__oerr  ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  rsc2_enc
  #(
    .pN_MAX ( pN )
  )
  enc
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .icode   ( pCODE        ) ,
    .iptype  ( pPTYPE       ) ,
    //
    .itag    ( '0           ) ,
    .isop    ( enc__isop    ) ,
    .ieop    ( enc__ieop    ) ,
    .ival    ( enc__ival    ) ,
    .idat    ( enc__idat    ) ,
    //
    .obusy   ( enc__obusy   ) ,
    .ordy    ( enc__ordy    ) ,
    //
    .idbsclk ( enc__idbsclk ) ,
    .ofull   (              ) ,
    //
    .otag    (              ) ,
    .osop    ( enc__osop    ) ,
    .oeop    ( enc__oeop    ) ,
    .oeof    ( enc__oeof    ) ,
    .oval    ( enc__oval    ) ,
    .odat    ( enc__odat    )
  );

  assign enc__idbsclk = 1'b1;

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper.
  //     00 = -1 - 1i
  //     01 = -1 + 1i
  //     10 =  1 - 1i
  //     11 =  1 + 1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW  = 2.0;

  bit              map_val;
  bit              map_sop;
  bit              map_eop;
  cmplx_real_dat_t map_dat;

  always_ff @(posedge iclk) begin
    map_sop     <= enc__osop;
    map_val     <= enc__oval;
    map_eop     <= enc__oeof;
    map_dat.re  <= enc__odat[0] ? 1 : -1;
    map_dat.im  <= enc__odat[1] ? 1 : -1;
  end

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  cmplx_real_dat_t  awgn_ch;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    dec__isop <= map_sop;
    dec__ieop <= map_eop;
    dec__ival <= map_val;
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

//localparam int cDAT_W = 4; // {4.2}
  localparam int cDAT_W = 5; // {5.3}
//localparam int cDAT_W = 6; // {5.3}

  bit signed [cDAT_W-1 : 0] dat2llr_re;
  bit signed [cDAT_W-1 : 0] dat2llr_im;

  always_comb begin
    dat2llr_re = ngc_dat_re[11 : 12-cDAT_W];
    dat2llr_im = ngc_dat_im[11 : 12-cDAT_W];
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  logic dec__ireq;
  logic dec__ofull;

  rsc2_dec
  #(
    .pLLR_W                ( cDAT_W  ) ,
    .pODAT_W               ( pODAT_W ) ,
    .pN_MAX                ( pN      ) ,
    .pUSE_W_BIT            ( 1       ) ,
    .pUSE_SRC_EOP_VAL_MASK ( 0       )
  )
  uut
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .icode   ( pCODE      ) ,
    .iptype  ( pPTYPE     ) ,
    .iNiter  ( pNiter     ) ,
    //
    .itag    ( '0         ) ,
    .isop    ( dec__isop  ) ,
    .ieop    ( dec__ieop  ) ,
    .ival    ( dec__ival  ) ,
    //
    .iLLR    ( '{dat2llr_re, dat2llr_im} ) ,
    //
    .obusy   ( dec__obusy ) ,
    .ordy    ( dec__ordy  ) ,
    //
    .ireq    ( dec__ireq  ) ,
    .ofull   ( dec__ofull ) ,
    //
    .osop    ( dec__osop  ) ,
    .oeop    ( dec__oeop  ) ,
    .oval    ( dec__oval  ) ,
    .odat    ( dec__odat  ) ,
    .otag    (            ) , // n.u.
    //
    .oerr    ( dec__oerr  )
  );

  assign dec__ireq = 1'b1;

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

//const int Npkt = 4;
//const int Npkt = 128;
//const int Npkt = 1024;

  const int B = 1e5;
  const int Npkt = B/(pN*2);

//real EbNo [] = '{5.0};
  real EbNo [] = '{1.0, 1.5, 2.0, 2.5, 3.0};
//real EbNo [] = '{0.5, 1.0, 1.5, 2.0, 2.5, 3.0};
//real EbNo [] = '{1.0, 2.0, 3.0, 4.0, 5.0, 6.0};
//real EbNo [] = '{0.5, 0.75, 1.0, 1.25, 1.5, 1.75};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  pkt_class #(2) code_queue [$];

  initial begin
    pkt_class #(2) code;
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
    $display("Test modulation %0d bps", iqam);
    //
    @(posedge iclk iff !ireset);

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(2), .coderate(cCODE_RATE[pCODE]), .Ps(cQPSK_POW), .seed(2));
      awgn.log();
      void'(awgn.add('{0, 0}, 0));
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
        if ((n % 16) == 0) begin
          $display("sent %0d packets", n);
        end
      end
    end
  end

  int numerr      [];
  int est_numerr  [];

  initial begin
    pkt_class #(2) decode;
    pkt_class #(2) code;
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
    bits = 2*pN*Npkt;
    //
    foreach (EbNo[k]) begin
      n = 0;
      //
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          if (dec__osop) addr = 0;
          //
          for (int i = 0; i < pODAT_W; i += 2) begin
            decode.dat[addr] = dec__odat[i +: 2];
            addr++;
          end
          //
          if (dec__oeop) begin
            n++;
            code = code_queue.pop_front();
            err = code.do_compare(decode);
            numerr[k] += err;
            est_numerr[k] += dec__oerr;
            //
            if ((n % 32) == 0) begin
              $display("decode done %0d. err = %0d, est err %0d", n, numerr[k], est_numerr[k]);
            end
          end
        end
      end
      while (n < Npkt);
      $display("decode EbN0 = %0.2f done. ber = %0.2e, fer = %0.2e", EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/bits);
      //
    end
    //
    $display("");
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo = %0.2f: ber = %0.2e. fer = %0.2e", bits, EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/bits);
    end
    $stop;
  end

endmodule


