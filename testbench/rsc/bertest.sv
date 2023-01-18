//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for RTL RSC coder/decoder QPSK
//

`include "define.vh"
`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

//parameter int pCODE       =  0 ;
//parameter int pCODE       =  1 ;
//parameter int pCODE       =  2 ;
  parameter int pCODE       =  3 ;
//parameter int pCODE       =  5 ;
//parameter int pCODE       =  7 ; // 7/8
//parameter int pCODE       =  10; //2/5
//parameter int pCODE       =  11; //3/5
//parameter int pCODE       =  12; //3/7

//parameter int pPTYPE      =  0 ;  // 12 bytes == 48 dbits
//parameter int pPTYPE      =  16 ; // 6 bytes == 24 dbits
//parameter int pPTYPE      =  16 + 2 ; // wimaxA
//parameter int pPTYPE      =  12 ; // wimax 7
//parameter int pPTYPE      =  13 ; // wimax 11
//parameter int pPTYPE      =  14 ; // wimax 13
//parameter int pPTYPE      =  15 ; // wimax 17
//parameter int pPTYPE      =  1 ;  // dvb 16 bytes == 64 dbits
//parameter int pPTYPE      =  2 ;  // dvb 53 bytes == 212 dbits
//parameter int pPTYPE      =  5 ;
//parameter int pPTYPE      =  22 ; // wimax 30 bytes == 120 dbits
  parameter int pPTYPE      =  31 ; // wimax 480 bytes == 1920 dbits
//parameter int pPTYPE      =  28 ; // wimax 60 bytes == 240 dbits

//parameter int pN          = 24 ;
//parameter int pN          = 48 ;
//parameter int pN          = 480 ;
//parameter int pN          = 68*4 ;
//parameter int pN          = 120 ;
//parameter int pN          = 32*4 ;
//parameter int pN          = 212;
//parameter int pN          = 424 ;
//parameter int pN          = 848
  parameter int pN          = 1920 ;

  parameter int pNiter      = 10;

  parameter int pODAT_W     = 2;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  real cCODE_RATE [] = '{ 1.0/3,
                          1.0/2, 2.0/3, 3.0/4, 4.0/5, 5.0/6, 6.0/7, 7.0/8, 8.0/9, 9.0/10,
                          2.0/5, 3.0/5, 3.0/7};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                 iclk      ;
  logic                 ireset    ;
  logic                 iclkena   ;
  //
  logic         [3 : 0] enc__icode   ;
  logic         [4 : 0] enc__iptype  ;
  logic        [12 : 0] enc__iN      ;
  logic                 enc__itag    ;
  //
  logic                 enc__isop    ;
  logic                 enc__ieop    ;
  logic                 enc__ival    ;
  logic         [1 : 0] enc__idat    ;
  //
  logic                 enc__obusy   ;
  logic                 enc__ordy    ;
  logic                 enc__idbsclk ;
  //
  logic                 enc__osop    ;
  logic                 enc__oeop    ;
  logic                 enc__oeof    ;
  logic                 enc__oval    ;
  logic         [1 : 0] enc__odat    ;
  //
  logic         [3 : 0] dec__icode  ;
  logic         [4 : 0] dec__iptype ;
  logic        [12 : 0] dec__iN     ;
  logic         [3 : 0] dec__iNiter ;
  bit                   dec__itag   ;

  bit                   dec__isop  ;
  bit                   dec__ieop  ;
  bit                   dec__ival  ;

  logic                 dec__obusy ;
  logic                 dec__ordy  ;

  bit                   dec__ireq  ;
  logic                 dec__ofull ;

  logic                 dec__osop  ;
  logic                 dec__oeop  ;
  logic                 dec__oval  ;
  logic [pODAT_W-1 : 0] dec__odat  ;
  logic        [15 : 0] dec__oerr  ;
  logic                 dec__otag  ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  rsc_enc_wrp
  #(
    .pTAG_W       ( 1      ) ,
    .pCODE        ( pCODE  ) ,
    .pPTYPE       ( pPTYPE ) ,
    .pN           ( pN     ) ,
    .pUSE_OBUFFER ( 1      )
  )
  enc
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .itag    ( enc__itag    ) ,
    //
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
    .osop    ( enc__osop    ) ,
    .oeop    ( enc__oeop    ) ,
    .oeof    ( enc__oeof    ) ,
    .oval    ( enc__oval    ) ,
    .odat    ( enc__odat    ) ,
    .otag    (              )
  );

  initial enc__idbsclk = '1;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      enc__idbsclk <= !enc__idbsclk & !dec__obusy;
    end
  end

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
    dec__ieop <= enc.pUSE_OBUFFER ? enc__oeop : enc__oeof;
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

  logic signed [cDAT_W-1 : 0] dec__iLLR [2];

  always_comb begin
    dec__iLLR [1] = ngc_dat_re[11 : 12-cDAT_W] + ngc_dat_re[15];
    dec__iLLR [0] = ngc_dat_im[11 : 12-cDAT_W] + ngc_dat_im[15];
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  rsc_dec_wrp
  #(
    .pLLR_W                ( cDAT_W           ) ,
    .pODAT_W               ( pODAT_W          ) ,
    //
    .pTAG_W                ( 1                ) ,
    //
    .pCODE                 ( pCODE            ) ,
    .pPTYPE                ( pPTYPE           ) ,
    .pN                    ( pN               ) ,
    //
    .pUSE_SRC_EOP_VAL_MASK ( enc.pUSE_OBUFFER )
  )
  uut
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    //
    .iNiter  ( dec__iNiter ) ,
    //
    .itag    ( dec__itag   ) ,
    .isop    ( dec__isop   ) ,
    .ieop    ( dec__ieop   ) ,
    .ival    ( dec__ival   ) ,
    .iLLR    ( dec__iLLR   ) ,
    //
    .obusy   ( dec__obusy  ) ,
    .ordy    ( dec__ordy   ) ,
    //
    .ireq    ( dec__ireq   ) ,
    .ofull   ( dec__ofull  ) ,
    //
    .otag    ( dec__otag   ) ,
    .osop    ( dec__osop   ) ,
    .oeop    ( dec__oeop   ) ,
    .oval    ( dec__oval   ) ,
    .odat    ( dec__odat   ) ,
    .oerr    ( dec__oerr   )
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

  //------------------------------------------------------------------------------------------------------
  // tb settings
  //------------------------------------------------------------------------------------------------------

//const int Npkt = 1;
//const int Npkt = 128;
//const int Npkt = 1024;

  const int B = 1e5;
  const int Npkt = B/(pN*2);

//const int Npkt = 4;
//real EbNo [] = '{3.5};
//real EbNo [] = '{3.0, 4.0, 5.0} ;
//real EbNo [] = '{0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5};
  real EbNo [] = '{1.0, 2.0, 3.0, 4.0};

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
    enc__icode  <= '0;
    enc__iptype <= '0;
    enc__iN     <= '0;
    enc__itag   <= '0;
    //
    awgn.init_EbNo(.EbNo(EbNo[0]), .bps(2), .coderate(1.0), .Ps(cQPSK_POW), .seed(0));
    //
    @(posedge iclk iff !ireset);

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(2), .coderate(cCODE_RATE[pCODE]), .Ps(cQPSK_POW), .seed(2));
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
          if (i == 0) begin
            enc__icode  <= pCODE;
            enc__iptype <= pPTYPE;
            enc__iN     <= pN;
            enc__itag   <= ~enc__itag;
          end
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
        if ((n % 32) == 0) begin
          $display("sent %0d packets", n);
        end
      end
    end
  end

  //
  //
  //
  assign dec__icode   = enc__icode;
  assign dec__iptype  = enc__iptype;
  assign dec__iN      = enc__iN;
  assign dec__iNiter  = pNiter;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (dec__isop & dec__ival) begin
        dec__itag <= ~dec__itag;
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
          end
        end
      end
      while (n < Npkt);
      $display("decode EbN0 = %0f done. ber = %0e, fer = %0e", EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/bits);
      //
    end
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo = %f: ber = %0e. fer = %0e", bits, EbNo[k], numerr[k]*1.0/bits, est_numerr[k]*1.0/bits);
    end
    $stop;
  end

endmodule


