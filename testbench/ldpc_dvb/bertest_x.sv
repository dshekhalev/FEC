//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for DVB-S2X LDPC codec for QPSK AWGN
//

`timescale 1ns/1ns

`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest_x;

  `include "../rtl/ldpc_dvb/ldpc_dvb_constants.svh"

  localparam int cENC_DAT_W   = 360 ; // multuply 360
  localparam int cDEC_DAT_W   = cENC_DAT_W ;

  parameter int pERR_W        = 16 ;
  //
  parameter int pLLR_NUM      =  cENC_DAT_W ;  // multuply 360
  //
  parameter int pNORM_FACTOR =  7 ;
  parameter bit pNORM_OFFSET =  0 ;
  parameter bit pUSE_SC_MODE =  1 ;

  parameter bit pCODEGR       = cCODEGR_LARGE  ;  // short(0)/large(1)/middle(2) graph
//parameter bit pCODEGR       = cCODEGR_MEDIUM ;
//parameter bit pCODEGR       = cCODEGR_SHORT  ;

  parameter int pCODERATE     = cXCODERATE_L_90by180 ; // coderate table see in ldpc_dvb_constants.svh
//parameter int pCODERATE     = cXCODERATE_M_1by3 ;
//parameter int pCODERATE     = cXCODERATE_S_7by15 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  code_ctx_t tb_code_ctx;

  assign tb_code_ctx.gr       = pCODEGR;
  assign tb_code_ctx.coderate = pCODERATE;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                    iclk           ;
  logic                    ireset         ;
  logic                    iclkena        ;

  logic            [7 : 0] iNiter         ;
  logic                    ifmode         ;

  //
  // encoder
  logic                    enc__isop      ;
  logic                    enc__ival      ;
  logic                    enc__ieop      ;
  logic [cENC_DAT_W-1 : 0] enc__idat      ;
  //
  logic                    enc__obusy     ;
  logic                    enc__ordy      ;
  //
  logic                    enc__ireq      ;
  logic                    enc__ofull     ;
  //
  logic                    enc__osop      ;
  logic                    enc__oval      ;
  logic                    enc__oeop      ;
  logic [cENC_DAT_W-1 : 0] enc__odat      ;

  //
  // decoder
  logic                    dec__isop      ;
  logic                    dec__ival      ;
  logic                    dec__ieop      ;

  logic                    dec__obusy     ;
  logic                    dec__ordy      ;

  logic                    dec__ireq      ;
  logic                    dec__ofull     ;

  logic                    dec__osop      ;
  logic                    dec__oval      ;
  logic                    dec__oeop      ;
  logic [cDEC_DAT_W-1 : 0] dec__odat      ;

  logic                    dec__odecfail  ;
  logic     [pERR_W-1 : 0] dec__oerr      ;

  //------------------------------------------------------------------------------------------------------
  // encoder
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_fix
  #(
    .pDAT_W    ( cENC_DAT_W ) ,
    .pCODEGR   ( pCODEGR    ) ,
    .pCODERATE ( pCODERATE  ) ,
    .pXMODE    ( 1          )
  )
  enc
  (
    .iclk      ( iclk        ) ,
    .ireset    ( ireset      ) ,
    //
    .iclkin    ( iclk        ) ,
    //
    .isop      ( enc__isop   ) ,
    .ival      ( enc__ival   ) ,
    .ieop      ( enc__ieop   ) ,
    .idat      ( enc__idat   ) ,
    .itag      ( '0          ) ,
    //
    .obusy     ( enc__obusy  ) ,
    .ordy      ( enc__ordy   ) ,
    //
    .iclkout   ( iclk        ) ,
    .ireq      ( enc__ireq   ) ,
    .ofull     ( enc__ofull  ) ,
    //
    .osop      ( enc__osop   ) ,
    .oval      ( enc__oval   ) ,
    .oeop      ( enc__oeop   ) ,
    .odat      ( enc__odat   ) ,
    .otag      (             )
  );

  assign enc__ireq = dec__ordy;

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper. Power is 2
  //     00 = -1-1i
  //     01 = -1+1i
  //     10 =  1-1i
  //     11 =  1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  bit               qpsk_sop  ;
  bit               qpsk_val  ;
  bit               qpsk_eop  ;
  cmplx_real_dat_t  qpsk     [pLLR_NUM/2] ;

  always_ff @(posedge iclk) begin
    qpsk_sop <= enc__osop;
    qpsk_val <= enc__oval;
    qpsk_eop <= enc__oeop;
    //
    for (int i = 0; i < pLLR_NUM/2; i++) begin
      qpsk[i].re <= enc__odat[2*i + 1] ? 1 : -1;
      qpsk[i].im <= enc__odat[2*i + 0] ? 1 : -1;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // awgn channel
  //------------------------------------------------------------------------------------------------------

  awgn_class        awgn = new;

  cmplx_real_dat_t  awgn_ch  [pLLR_NUM/2];
  bit               awgn_sop;
  bit               awgn_eop;
  bit               awgn_val;

  const bit awgn_bypass = 0;

  always_ff @(posedge iclk) begin
    awgn_sop <= qpsk_sop;
    awgn_eop <= qpsk_eop;
    awgn_val <= qpsk_val;
    if (qpsk_val) begin
      for (int i = 0; i < pLLR_NUM/2; i++) begin
        awgn_ch[i] <= awgn.add(qpsk[i], awgn_bypass);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // scale data: set QPSK ref point to -+1024 point and saturate canstellation to -2047 : + 2047 point
  //------------------------------------------------------------------------------------------------------

  const int NGC_MAX = 2047;
  const int NGC_REF = 1024;

  bit signed [15 : 0] ngc_dat_re [pLLR_NUM/2];
  bit signed [15 : 0] ngc_dat_im [pLLR_NUM/2];

  always_comb begin
    for (int i = 0; i < pLLR_NUM/2; i++) begin
      ngc_dat_re[i] = $floor(awgn_ch[i].re * NGC_REF + 0.5);
      ngc_dat_im[i] = $floor(awgn_ch[i].im * NGC_REF + 0.5);
      // saturate
      if (ngc_dat_re[i] > NGC_MAX) begin
        ngc_dat_re[i] = NGC_MAX;
      end
      else if (ngc_dat_re[i] < -NGC_MAX) begin
        ngc_dat_re[i] = -NGC_MAX;
      end
      //
      if (ngc_dat_im[i] > NGC_MAX) begin
        ngc_dat_im[i] = NGC_MAX;
      end
      else if (ngc_dat_im[i] < -NGC_MAX) begin
        ngc_dat_im[i] = -NGC_MAX;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // cut off bits for decoder
  //  take 5bits {5.3} from ref point
  //------------------------------------------------------------------------------------------------------

//localparam int cDAT_W = 4; // {4.2}
  localparam int cDAT_W = 5; // {5.3}

  bit signed [cDAT_W-1 : 0] dat2llr_re [pLLR_NUM/2];
  bit signed [cDAT_W-1 : 0] dat2llr_im [pLLR_NUM/2];

  always_comb begin
    for (int i = 0; i < pLLR_NUM/2; i++) begin
      dat2llr_re[i] = ngc_dat_re[i][11 : 12-cDAT_W];
      dat2llr_im[i] = ngc_dat_im[i][11 : 12-cDAT_W];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // get LLR stream
  //------------------------------------------------------------------------------------------------------

  parameter int pLLR_W  =  cDAT_W;
  parameter int pNODE_W =  pLLR_W + 2; //max(6, cDAT_W);

  logic signed [pLLR_W-1 : 0] dec__iLLR  [pLLR_NUM] ;

  always_comb begin
    dec__isop = awgn_sop;
    dec__ival = awgn_val;
    dec__ieop = awgn_eop;
    for (int i = 0; i < pLLR_NUM/2; i++) begin
      dec__iLLR[2*i + 1] = dat2llr_re[i];
      dec__iLLR[2*i + 0] = dat2llr_im[i];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_fix
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pLLR_NUM     ( pLLR_NUM     ) ,
    //
    .pDAT_W       ( cDEC_DAT_W   ) ,
    //
    .pNODE_W      ( pNODE_W      ) ,
    //
    .pCODEGR      ( pCODEGR      ) ,
    .pCODERATE    ( pCODERATE    ) ,
    .pXMODE       ( 1            ) ,
    //
    .pNORM_FACTOR ( pNORM_FACTOR ) ,
    .pNORM_OFFSET ( pNORM_OFFSET ) ,
    .pUSE_SC_MODE ( pUSE_SC_MODE )
  )
  uut
  (
    .iclk      ( iclk          ) ,
    .ireset    ( ireset        ) ,
    //
    .iNiter    ( iNiter        ) ,
    .ifmode    ( ifmode        ) ,
    //
    .iclkin    ( iclk          ) ,
    //
    .isop      ( dec__isop     ) ,
    .ival      ( dec__ival     ) ,
    .ieop      ( dec__ieop     ) ,
    .itag      ( '0            ) ,
    .iLLR      ( dec__iLLR     ) ,
    //
    .obusy     ( dec__obusy    ) ,
    .ordy      ( dec__ordy     ) ,
    //
    .iclkout   ( iclk          ) ,
    .ireq      ( 1'b1          ) ,
    .ofull     (               ) ,
    //
    .osop      ( dec__osop     ) ,
    .oval      ( dec__oval     ) ,
    .oeop      ( dec__oeop     ) ,
    .odat      ( dec__odat     ) ,
    .otag      (               ) ,
    //
    .odecfail  ( dec__odecfail ) ,
    .oerr      ( dec__oerr     )
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

  assign iNiter = 50;
  assign ifmode = 1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  const int B = 1e5;

  int Npkt;

//real EbNo [] = '{4.0};
//real EbNo [] = '{3.5, 3.75, 4.0, 4.25, 4.5, 4.75, 5.0};
//real EbNo [] = '{2.5, 3.0, 3.5, 4.0, 4.5, 4.75};
//real EbNo [] = '{4.25, 4.5, 4.75};
//real EbNo [] = '{0.5, 1.0, 1.5, 2.0, 2.5, 3.0};
  real EbNo [] = '{1.0, 1.125, 1.25, 1.375, 1.5, 1.625, 1.75};

  //------------------------------------------------------------------------------------------------------
  // data generator
  //------------------------------------------------------------------------------------------------------

  event test_done;

  pkt_class #(1) code_queue [$];

  initial begin
    real coderate;
    int  data_bit_length;

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
    //
    data_bit_length = get_used_data_col(tb_code_ctx, 1) * cZC_MAX;
    coderate        = get_used_coderate(tb_code_ctx, 1);

    Npkt = B/data_bit_length;

    foreach (EbNo[k]) begin
      //
      repeat (10) @(posedge iclk);
      awgn.init_EbNo(.EbNo(EbNo[k]), .bps(2), .coderate(coderate), .Ps(cQPSK_POW), .seed(2));
      awgn.log();
      void'(awgn.add('{0, 0}, 0));
      repeat (10) @(posedge iclk);
      //
      @(posedge iclk iff enc__ordy);
      //
      for (int n = 0; n < Npkt; n++) begin

        // generate data
        code = new(data_bit_length);
        void'(code.randomize());

        // drive data
        for (int i = 0; i < data_bit_length/cENC_DAT_W; i++) begin
          enc__ival <= 1'b1;
          enc__isop <= (i == 0);
          enc__ieop <= (i == data_bit_length/cENC_DAT_W-1);
          for (int j = 0; j < cENC_DAT_W; j++) begin
            enc__idat[j] <= code.dat[cENC_DAT_W*i + j];
          end
          @(posedge iclk iff enc__ordy);
          enc__ival <= 1'b0;
          enc__isop <= 1'b0;
          enc__ieop <= 1'b0;
        end
        // save reference
        code_queue.push_back(code);
        //
        @(posedge iclk iff enc__ordy);
        //
        $display("sent %0d packets", n);
      end
      //
      @(test_done);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // data reciver & checker
  //------------------------------------------------------------------------------------------------------

  int numerr      [];
  int est_numerr  [];

  initial begin
    real coderate;
    int  data_bit_length;
    int  code_bit_length;
    //
    pkt_class #(1) decode;
    pkt_class #(1) code;
    //
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
    //
    //
    @(posedge iclk iff !ireset);
    repeat (2) @(posedge iclk);
    //
    foreach (EbNo[k]) begin
      n = 0;
      //
      do begin
        @(posedge iclk);
        if (dec__oval) begin
          if (dec__osop) begin
            addr            = 0;
            //
            data_bit_length = get_used_data_col(tb_code_ctx, 1) * cZC_MAX;
            code_bit_length = get_used_col(tb_code_ctx) * cZC_MAX;;
            coderate        = get_used_coderate(tb_code_ctx, 1);
            //
            decode          = new(data_bit_length);
          end
          //
          for (int i = 0; i < cDEC_DAT_W; i++) begin
            decode.dat[addr] = dec__odat[i];
            addr++;
          end
          //
          if (dec__oeop) begin
            n++;
            code    = code_queue.pop_front();

            err     = code.do_compare(decode);
            //
            numerr[k]     += err;
            est_numerr[k] += dec__oerr;
            //
            $display("%0t decode done %0d. decfail = %0d, err = %0d, est err %0d", $time, n, dec__odecfail, numerr[k], est_numerr[k]);
          end
        end
      end
      while (n < Npkt);
      -> test_done;

      // intermediate results
      $display("decode EbN0(SNR) = %0.2f(%0.2f) done. ber = %0.2e, fer = %0.2e", EbNo[k], awgn.SNR, numerr[k]*1.0/(Npkt*data_bit_length), est_numerr[k]*1.0/(Npkt*code_bit_length));
    end
    // final results
    for (int k = 0; k < EbNo.size(); k++) begin
      $display("bits %0d EbNo(SNR) = %0.2f(%0.2f) : ber = %0.2e. fer = %0.2e", Npkt*data_bit_length, EbNo[k], awgn.get_snr(EbNo[k], .bps(2), .coderate(coderate)),
               numerr[k]*1.0/(Npkt*data_bit_length), est_numerr[k]*1.0/(Npkt*code_bit_length));
    end
    //
    #1us;
    $display("test done %0t", $time);
    $stop;
  end

endmodule


