//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for NASA GSFC LDPC coder/decoder
//

`timescale 1ns/1ns

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest ;

  localparam pDAT_W         = 1;  // encoder bitwidth only 1/7 supported
  localparam pTAG_W         = 1;

  localparam pLLR_NUM       = 7;  // decoder bitwidth only 1/7 supported
  localparam pLLR_BY_CYCLE  = pLLR_NUM;

  localparam pODAT_W        = pLLR_BY_CYCLE;

  localparam pNORM_VNODE    = 1;
  localparam pNORM_CNODE    = 1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  real cCODE_RATE = 7.0/8;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                       iclk     ;
  logic                       ireset   ;
  logic                       iclkena  ;

  logic                       enc__isop     ;
  logic                       enc__ieop     ;
  logic                       enc__ieof     ;
  logic                       enc__ival     ;
  logic        [pTAG_W-1 : 0] enc__itag     ;
  logic        [pDAT_W-1 : 0] enc__idat     ;
  //
  logic                       enc__obusy    ;
  logic                       enc__ordy     ;
  //
  logic                       enc__osop     ;
  logic                       enc__oeop     ;
  logic                       enc__oeof     ;
  logic                       enc__oval     ;
  logic        [pDAT_W-1 : 0] enc__odat     ;
  logic        [pTAG_W-1 : 0] enc__otag     ;

  bit                 [7 : 0] dec__iNiter;
  bit                         dec__ifmode;

  logic                       dec__isop  ;
  logic                       dec__ieop  ;
  logic                       dec__ival  ;
  logic        [pTAG_W-1 : 0] dec__itag  ;

  logic                       dec__obusy ;
  logic                       dec__ordy  ;

  logic                       dec__osop   ;
  logic                       dec__oeop   ;
  logic                       dec__oval   ;
  logic       [pODAT_W-1 : 0] dec__odat   ;
  logic        [pTAG_W-1 : 0] dec__otag   ;

  logic              [15 : 0] dec__oerr   ;

  logic                       dec__odecfail;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  gsfc_ldpc_enc
  #(
    .pDAT_W ( pDAT_W ) ,
    .pTAG_W ( pTAG_W )
  )
  enc
  (
    .iclk    ( iclk       ) ,
    .ireset  ( ireset     ) ,
    .iclkena ( iclkena    ) ,
    //
    .isop    ( enc__isop  ) ,
    .ieop    ( enc__ieop  ) ,
    .ieof    ( enc__ieof  ) ,
    .ival    ( enc__ival  ) ,
    .itag    ( enc__itag  ) ,
    .idat    ( enc__idat  ) ,
    //
    .obusy   ( enc__obusy ) ,
    .ordy    ( enc__ordy  ) ,
    //
    .osop    ( enc__osop  ) ,
    .oeop    ( enc__oeop  ) ,
    .oeof    ( enc__oeof  ) ,
    .oval    ( enc__oval  ) ,
    .otag    ( enc__otag  ) ,
    .odat    ( enc__odat  )
  );

  assign enc__itag = '0;

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper. Power is
  //     00 = -1-1i
  //     01 = -1+1i
  //     10 =  1-1i
  //     11 =  1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  bit         enc_ff  ;

  bit [1 : 0] qpsk_sop;
  bit [1 : 0] qpsk_eop;
  bit [1 : 0] qpsk_eof;
  bit         qpsk_val;
  bit [1 : 0] qpsk_dat;

  always_ff @(posedge iclk) begin
    qpsk_val <= enc__oval & !enc__osop & enc_ff;
    if (enc__oval) begin
      enc_ff    <= enc__osop ? 1'b1  : ~enc_ff;
      qpsk_sop  <= enc__osop ? 2'b01 : (qpsk_sop << 1);
      qpsk_eop  <= enc__oeop ? 2'b10 : (qpsk_eop << 1);
      qpsk_eof  <= enc__oeof ? 2'b10 : (qpsk_eof << 1);
      qpsk_dat  <= (qpsk_dat << 1) | enc__odat[0];
    end
  end

  cmplx_real_dat_t   qpsk;

  assign qpsk.re = qpsk_dat[1] ? 1 : -1;
  assign qpsk.im = qpsk_dat[0] ? 1 : -1;

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  cmplx_real_dat_t  awgn_ch;
  bit               awgn_sop;
  bit               awgn_eop;
  bit               awgn_val;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    awgn_sop <= qpsk_sop[1];
    awgn_eop <= qpsk_eof[1]; // enc__oeop - it's systematic bits end
    awgn_val <= qpsk_val;
    if (qpsk_val) begin
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

//localparam int cDAT_W = 4;
  localparam int cDAT_W = 5;

  bit signed [cDAT_W-1 : 0] dat2llr_re;
  bit signed [cDAT_W-1 : 0] dat2llr_im;

  always_comb begin
    dat2llr_re = ngc_dat_re[11 : 12-cDAT_W];
    dat2llr_im = ngc_dat_im[11 : 12-cDAT_W];
  end

  //------------------------------------------------------------------------------------------------------
  // get LLR stream
  //------------------------------------------------------------------------------------------------------

  logic signed [cDAT_W-1 : 0] LLR [2];

  bit llr_val;
  bit llr_sop;
  bit llr_eop;

  always_ff @(posedge iclk) begin
    llr_val <= awgn_val;
    llr_sop <= awgn_sop;
    llr_eop <= awgn_eop;
    //
    if (awgn_val) begin
      LLR[1] <= dat2llr_re;
      LLR[0] <= dat2llr_im;
    end
  end

  logic signed [cDAT_W-1 : 0] LLR_buf [2];

  bit [1 : 0] sop2dec;
  bit [1 : 0] val2dec;
  bit [1 : 0] sel2dec;
  bit [1 : 0] eop2dec;

  always_ff @(posedge iclk) begin
    sop2dec                   <= llr_val ? {llr_sop, 1'b0}  : (sop2dec << 1);
    val2dec                   <= llr_val ? 2'b11            : (val2dec << 1);
    eop2dec                   <= llr_val ? {1'b0, llr_eop}  : (eop2dec << 1);
    {LLR_buf[1], LLR_buf[0]}  <= llr_val ? {LLR[1], LLR[0]} : {LLR[0], LLR[0]};
  end

  logic signed [cDAT_W-1 : 0] dec__iLLR  [pLLR_NUM] ;

  int llr_cnt;

  always_ff @(posedge iclk) begin
    if (pLLR_NUM == 1) begin
      dec__isop    <= sop2dec[1];
      dec__ival    <= val2dec[1];
      dec__ieop    <= eop2dec[1];
      dec__iLLR[0] <= LLR_buf[1];
      dec__itag    <= '0;
    end
    else begin
      dec__ival <= val2dec[1] & !sop2dec[1] & (llr_cnt == pLLR_NUM-2);
      //
      if (val2dec[1] & sop2dec[1])
        dec__isop <= 1'b1;
      else if (dec__ival)
        dec__isop <= 1'b0;
      //
      dec__ieop <= eop2dec[1];
      dec__itag <= '0;
      //
      if (val2dec[1]) begin
        llr_cnt <= (sop2dec[1] | (llr_cnt == pLLR_NUM-1)) ? '0 : (llr_cnt + 1'b1);
        for (int i = 0; i < pLLR_NUM; i++) begin
          if (i == pLLR_NUM-1)
            dec__iLLR[i] <= LLR_buf[1];
          else
            dec__iLLR[i] <= dec__iLLR[i+1];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  gsfc_ldpc_dec
  #(
    .pLLR_W         ( cDAT_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNORM_VNODE    ( pNORM_VNODE    ) ,
    .pNORM_CNODE    ( pNORM_CNODE    ) ,
    .pTAG_W         ( pTAG_W         )
  )
  dec
  (
    .iclk     ( iclk          ) ,
    .ireset   ( ireset        ) ,
    .iclkena  ( iclkena       ) ,
    //
    .iNiter   ( dec__iNiter   ) ,
    .ifmode   ( dec__ifmode   ) ,
    //
    .isop     ( dec__isop     ) ,
    .ieop     ( dec__ieop     ) ,
    .ival     ( dec__ival     ) ,
    .itag     ( dec__itag     ) ,
    .iLLR     ( dec__iLLR     ) ,
    //
    .obusy    ( dec__obusy    ) ,
    .ordy     ( dec__ordy     ) ,
    //
    .osop     ( dec__osop     ) ,
    .oeop     ( dec__oeop     ) ,
    .oval     ( dec__oval     ) ,
    .otag     ( dec__otag     ) ,
    .odat     ( dec__odat     ) ,
    //
    .odecfail ( dec__odecfail ) ,
    .oerr     ( dec__oerr     )
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

  assign dec__iNiter = 20;
  assign dec__ifmode = 1;

  const int B = 1e5;

  const int Npkt = B/enc.cLDPC_NUM;
//const int Npkt = 1;

//real EbNo [] = '{4.0};
  real EbNo [] = '{3.5, 3.625, 3.75, 3.875, 4.0};
//real EbNo [] = '{4.0, 4.125, 4.25, 4.375, 4.5, 4.625, 4.75, 4.825, 5.0};

  //------------------------------------------------------------------------------------------------------
  // data generator
  //------------------------------------------------------------------------------------------------------

  pkt_class #(1) code_queue [$];

  initial begin
    pkt_class #(1) code;
    //
    code_queue.delete();
    //
    enc__isop <= '0;
    enc__ieop <= '0;
    enc__ieof <= '0;
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
      void'(awgn.add('{0, 0}, 0));
      repeat (10) @(posedge iclk);
      //
      @(posedge iclk iff enc__ordy);
      //
      for (int n = 0; n < Npkt; n++) begin
        // generate data
        code = new(enc.cLDPC_DNUM);
        void'(code.randomize());

        // drive data
        for (int i = 0; i < enc.cLDPC_NUM/pDAT_W; i++) begin
          enc__ival <= 1'b1;
          enc__isop <= (i == 0);
          enc__ieop <= (i == enc.cLDPC_DNUM/pDAT_W-1);
          enc__ieof <= (i == enc.cLDPC_NUM/pDAT_W-1);
          if (i < enc.cLDPC_DNUM/pDAT_W) begin
            for (int j = 0; j < pDAT_W; j++) begin
              enc__idat[j] <= code.dat[pDAT_W*i + j];
            end
          end
          @(posedge iclk iff enc__ordy);
          enc__ival <= 1'b0;
          enc__isop <= 1'b0;
          enc__ieop <= 1'b0;
          enc__ieof <= 1'b0;
        end
        // save reference
        code_queue.push_back(code);
        // wait decoder free modules free
        repeat (16) @(posedge iclk);    // true hack

//      @(posedge iclk iff !dec__obusy);
        @(posedge iclk iff dec__ordy);
        //
        if ((n % 16) == 0)
          $display("sent %0d packets", n);
      end
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
    int addr;
    int err;
    int n;
    string s;
    //
    numerr      = new[EbNo.size()];
    est_numerr  = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr[k]     = 0;
      est_numerr[k] = 0;
    end
    decode = new(enc.cLDPC_DNUM);
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
          for (int i = 0; i < pODAT_W; i++) begin
            decode.dat[addr] = dec__odat[i];
            addr++;
          end
          //
          if (dec__oeop) begin
            est_numerr[k] += dec__oerr;
            //
            n++;
            code = code_queue.pop_front();
            err = code.do_compare(decode);
            numerr[k] += err;

            if ((n % 16) == 0) begin
              $display("decode done %0d. err = %0d, est err %0d", n, numerr[k], est_numerr[k]);
            end
          end
        end
      end
      while (n < Npkt);
      // intermediate results
      $display("decode EbN0 = %0.2f done. ber = %0.2e, fer = %0.2e", EbNo[k], numerr[k]*1.0/(Npkt*enc.cLDPC_DNUM), est_numerr[k]*1.0/(Npkt*enc.cLDPC_NUM));
    end
    // final results
    $display("");
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo = %0.2f: ber = %0.2e. fer = %0.2e", Npkt*enc.cLDPC_DNUM, EbNo[k], numerr[k]*1.0/(Npkt*enc.cLDPC_DNUM), est_numerr[k]*1.0/(Npkt*enc.cLDPC_NUM));
    end
    //
    #1us;
    $display("test done %0t", $time);
    $stop;
  end

endmodule


