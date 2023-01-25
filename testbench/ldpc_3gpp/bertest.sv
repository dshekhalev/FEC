//
// Project       : ldpc 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : bertest.sv
// Description   : testbench for 3GPP LDPC codec for QPSK AWGN
//

`timescale 1ns/1ns

`include "define.vh"
`include "awgn_class.svh"
`include "pkt_class.svh"

module bertest;

  localparam int cENC_DAT_W   = 8 ; // 1/2/4/8
  localparam int cDEC_DAT_W   = cENC_DAT_W ;

  `include "../rtl/ldpc_3gpp/ldpc_3gpp_constants.svh"

  parameter bit pIDX_GR       = 0 ;
  parameter int pIDX_LS       = 0 ;
  parameter int pIDX_ZC       = 7 ;
  parameter int pCODE         = 8 ;
  parameter int pDO_PUNCT     = 1 ;
  //
  parameter int pERR_W        = 16 ;
  //
  parameter int pLLR_NUM      =  4 ;  // == 1/2/4/8 & >= pLLR_BY_CYCLE & <= cZC_TAB[pIDX_LS][pIDX_GR] & integer multiply of cZC_TAB[pIDX_LS][pIDX_GR]
  parameter int pROW_BY_CYCLE =  8 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                    iclk          ;
  logic                    ireset        ;
  logic                    iclkena       ;

  logic                    iidxGr        ;
  logic            [2 : 0] iidxLs        ;
  logic            [2 : 0] iidxZc        ;
  logic            [5 : 0] icode         ;
  logic                    ipunct        ;

  logic            [7 : 0] iNiter        ;
  logic                    ifmode        ;
  //
  logic                    enc__isop     ;
  logic                    enc__ival     ;
  logic                    enc__ieop     ;
  logic [cENC_DAT_W-1 : 0] enc__idat     ;
  //
  logic                    enc__obusy    ;
  logic                    enc__ordy     ;
  //
  logic                    enc__ireq     ;
  logic                    enc__ofull    ;
  //
  logic                    enc__osop     ;
  logic                    enc__oval     ;
  logic                    enc__oeop     ;
  logic [cENC_DAT_W-1 : 0] enc__odat     ;

  logic                    dec__isop     ;
  logic                    dec__ival     ;
  logic                    dec__ieop     ;

  logic                    dec__obusy    ;
  logic                    dec__ordy     ;

  logic                    dec__ireq     ;
  logic                    dec__ofull    ;

  logic                    dec__osop     ;
  logic                    dec__oval     ;
  logic                    dec__oeop     ;
  logic [cDEC_DAT_W-1 : 0] dec__odat     ;

  logic                    dec__odecfail ;
  logic     [pERR_W-1 : 0] dec__oerr     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_wrp
  #(
    .pDAT_W    ( cENC_DAT_W ) ,
    //
    .pIDX_GR   ( pIDX_GR    ) ,
    .pIDX_LS   ( pIDX_LS    ) ,
    .pIDX_ZC   ( pIDX_ZC    ) ,
    .pCODE     ( pCODE      ) ,
    .pDO_PUNCT ( pDO_PUNCT  )
  )
  enc
  (
    .iclk      ( iclk       ) ,
    .ireset    ( ireset     ) ,
    .iclkena   ( iclkena    ) ,
    //
    .isop      ( enc__isop  ) ,
    .ival      ( enc__ival  ) ,
    .ieop      ( enc__ieop  ) ,
    .idat      ( enc__idat  ) ,
    .itag      ( '0         ) ,
    //
    .obusy     ( enc__obusy ) ,
    .ordy      ( enc__ordy  ) ,
    .osrc_err  (            ) ,
    //
    .ireq      ( enc__ireq  ) ,
    .ofull     ( enc__ofull ) ,
    //
    .osop      ( enc__osop  ) ,
    .oval      ( enc__oval  ) ,
    .oeop      ( enc__oeop  ) ,
    .odat      ( enc__odat  ) ,
    .otag      (            )
  );

  bit [2 : 0] enc_req_cnt;

  always_ff @(posedge iclk) begin
    enc_req_cnt <= enc_req_cnt + 1'b1;
  end

  generate
    if      (cENC_DAT_W == 1) begin
      assign enc__ireq = !dec__obusy;                       // when decoder is not busy
    end
    else if (cENC_DAT_W == 2) begin
      assign enc__ireq = !dec__obusy & &enc_req_cnt[0];     // 1/2 of cycle when decoder is not busy
    end
    else if (cENC_DAT_W == 4) begin
      assign enc__ireq = !dec__obusy & &enc_req_cnt[1 : 0]; // 1/4 of cycle when decoder is not busy
    end
    else begin
      assign enc__ireq = !dec__obusy & &enc_req_cnt[2 : 0]; // 1/8 of cycle when decoder is not busy
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // QPSK mapper. Power is 2
  //     00 = -1-1i
  //     01 = -1+1i
  //     10 =  1-1i
  //     11 =  1+1i
  //------------------------------------------------------------------------------------------------------

  const real cQPSK_POW = 2.0;

  logic     [7 : 0] enc_sop;
  logic     [7 : 0] enc_val;
  logic     [7 : 0] enc_eop;
  logic     [7 : 0] enc_dat;

  logic             qpsk_sop;
  logic             qpsk_val;
  logic             qpsk_eop;
  cmplx_real_dat_t  qpsk;

  bit eff;

  always_ff @(posedge iclk) begin
    case (cENC_DAT_W)
      1 : begin
        if (enc__oval) begin
          eff = enc__osop ? 1'b0 : !eff;
        end
        //
        enc_val <= enc__oval & eff;
        //
        if (enc__oval) begin
          enc_dat[eff] <= enc__odat;
        end
        //
        if (enc__oval & enc__osop)
          enc_sop <= 1'b1;
        else if (enc_val)
          enc_sop <= 1'b0;
        //
        if (enc__oval & enc__oeop)
          enc_eop <= 1'b1;
        else if (enc_val)
          enc_eop <= 1'b0;
      end
      2 : begin
        enc_sop <= (enc__oval & enc__osop) ? 8'b0000_0001 : (enc_sop >> 1);
        enc_val <=  enc__oval              ? 8'b0000_0001 : (enc_val >> 1);
        enc_eop <= (enc__oval & enc__oeop) ? 8'b0000_0001 : (enc_eop >> 1);
        enc_dat <=  enc__oval              ? enc__odat    : (enc_dat >> 1);
      end
      4 : begin
        enc_sop <= (enc__oval & enc__osop) ? 8'b0000_0001 : (enc_sop >> 1);
        enc_val <=  enc__oval              ? 8'b0000_0101 : (enc_val >> 1);
        enc_eop <= (enc__oval & enc__oeop) ? 8'b0000_0100 : (enc_eop >> 1);
        enc_dat <=  enc__oval              ? enc__odat    : (enc_dat >> 1);
      end
      8 : begin
        enc_sop <= (enc__oval & enc__osop) ? 8'b0000_0001 : (enc_sop >> 1);
        enc_val <=  enc__oval              ? 8'b0101_0101 : (enc_val >> 1);
        enc_eop <= (enc__oval & enc__oeop) ? 8'b0100_0000 : (enc_eop >> 1);
        enc_dat <=  enc__oval              ? enc__odat    : (enc_dat >> 1);
      end
      default : begin
        $display("unsupported cENC_DAT_W");
        $stop;
      end
    endcase
  end

  assign qpsk_sop = enc_sop[0];
  assign qpsk_val = enc_val[0];
  assign qpsk_eop = enc_eop[0];

  assign qpsk.re  = enc_dat[1] ? 1 : -1;
  assign qpsk.im  = enc_dat[0] ? 1 : -1;

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
    awgn_sop <= qpsk_sop;
    awgn_eop <= qpsk_eop;
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

//localparam int cDAT_W = 4; // {4.2}
  localparam int cDAT_W = 5; // {5.3}

  bit signed [cDAT_W-1 : 0] dat2llr_re;
  bit signed [cDAT_W-1 : 0] dat2llr_im;

  always_comb begin
    dat2llr_re = ngc_dat_re[11 : 12-cDAT_W];
    dat2llr_im = ngc_dat_im[11 : 12-cDAT_W];
  end

  //------------------------------------------------------------------------------------------------------
  // get LLR stream
  //------------------------------------------------------------------------------------------------------

  parameter int pLLR_W  =  cDAT_W;
  parameter int pNODE_W =  pLLR_W; //max(6, cDAT_W);

  bit                 [1 : 0] dec_sop;
  bit                 [1 : 0] dec_val;
  bit                 [1 : 0] dec_eop;
  logic signed [pLLR_W-1 : 0] dec_LLR  [8] ;

  logic signed [pLLR_W-1 : 0] dec__iLLR  [pLLR_NUM] ;

  generate
    if (pLLR_NUM == 1) begin
      always_ff @(posedge iclk) begin
        dec_sop <= (awgn_val & awgn_sop) ? 2'b01 : (dec_sop >> 1);
        dec_val <=  awgn_val             ? 2'b11 : (dec_val >> 1);
        dec_eop <= (awgn_val & awgn_eop) ? 2'b10 : (dec_eop >> 1);

        if (awgn_val) begin
          dec_LLR[0] <= dat2llr_im;
          dec_LLR[1] <= dat2llr_re;
        end
        else begin
          dec_LLR[0] <= dec_LLR[1];
        end
      end

      assign dec__iLLR[0] = dec_LLR[0];
    end
    else if (pLLR_NUM == 2) begin
      always_ff @(posedge iclk) begin
        dec_sop <= awgn_val & awgn_sop;
        dec_val <= awgn_val           ;
        dec_eop <= awgn_val & awgn_eop;

        if (awgn_val) begin
          dec_LLR[0] <= dat2llr_im;
          dec_LLR[1] <= dat2llr_re;
        end
      end

      assign dec__iLLR = dec_LLR[0 : 1];
    end
    else if (pLLR_NUM == 4) begin
      bit dff;

      always_ff @(posedge iclk) begin
        if (awgn_val) begin
          dff = awgn_sop ? 1'b0 : !dff;
        end
        //
        if (awgn_val & awgn_sop)
          dec_sop <= 1'b1;
        else if (dec_val)
          dec_sop <= 1'b0;
        //
        dec_val <= awgn_val & dff;
        //
        if (awgn_val & awgn_eop)
          dec_eop <= 1'b1;
        else if (dec_val)
          dec_eop <= 1'b0;
        //
        if (awgn_val) begin
          dec_LLR[2*dff + 0] <= dat2llr_im;
          dec_LLR[2*dff + 1] <= dat2llr_re;
        end
      end

      assign dec__iLLR = dec_LLR[0 : 3];
    end
  endgenerate

  assign dec__isop  = dec_sop[0];
  assign dec__ival  = dec_val[0];
  assign dec__ieop  = dec_eop[0];

  //------------------------------------------------------------------------------------------------------
  // decoder
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_wrp
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pIDX_LS       ( pIDX_LS       ) ,
    .pIDX_ZC       ( pIDX_ZC       ) ,
    .pCODE         ( pCODE         ) ,
    .pDO_PUNCT     ( pDO_PUNCT     ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pLLR_NUM      ( pLLR_NUM      ) ,
    //
    .pDAT_W        ( cDEC_DAT_W    ) ,
    //
    .pERR_W        ( pERR_W        ) ,
    //
    .pNODE_W       ( pNODE_W       ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE )
  )
  dec
  (
    .iclk      ( iclk          ) ,
    .ireset    ( ireset        ) ,
    .iclkena   ( iclkena       ) ,
    //
    .iNiter    ( iNiter        ) ,
    .ifmode    ( ifmode        ) ,
    //
    .ival      ( dec__ival     ) ,
    .isop      ( dec__isop     ) ,
    .ieop      ( dec__ieop     ) ,
    .itag      ( '0            ) ,
    .iLLR      ( dec__iLLR     ) ,
    //
    .obusy     ( dec__obusy    ) ,
    .ordy      ( dec__ordy     ) ,
    .osrc_err  (               ) ,
    //
    .ireq      ( dec__ireq     ) ,
    .ofull     ( dec__ofull    ) ,
    //
    .oval      ( dec__oval     ) ,
    .osop      ( dec__osop     ) ,
    .oeop      ( dec__oeop     ) ,
    .otag      (               ) ,
    .odat      ( dec__odat     ) ,
    //
    .odecfail  ( dec__odecfail ) ,
    .oerr      ( dec__oerr     )
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

  assign iNiter = 10;
  assign ifmode = 0;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  const int B = 1e5;

  int Npkt;

//real EbNo [] = '{1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0};
//real EbNo [] = '{3.625};
//real EbNo [] = '{4.0};
//real EbNo [] = '{3.5, 3.75, 4.0, 4.25, 4.5, 4.75, 5.0};
  real EbNo [] = '{2.5, 3.0, 3.5, 4.0, 4.5};
//real EbNo [] = '{4.25, 4.5, 4.75};
//real EbNo [] = '{0.5, 1.0, 1.5, 2.0, 2.5, 3.0};
//real EbNo [] = '{0.5, 0.75, 1.0, 1.25, 1.5, 1.75};

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

    coderate        = get_coderate(pIDX_GR, pCODE, pDO_PUNCT);
    data_bit_length = get_data_bit_length(pIDX_GR, pIDX_LS, pIDX_ZC);

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
        if ((n % 128) == 0) begin
          $display("sent %0d packets", n);
        end
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
    coderate        = get_coderate(pIDX_GR, pCODE, pDO_PUNCT);
    data_bit_length = get_data_bit_length(pIDX_GR, pIDX_LS, pIDX_ZC);
    code_bit_length = data_bit_length/coderate;
    //
    numerr      = new[EbNo.size()];
    est_numerr  = new[EbNo.size()];
    foreach (numerr[k]) begin
      numerr[k]     = 0;
      est_numerr[k] = 0;
    end
    decode    = new(data_bit_length);
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
          if (dec__osop) addr = 0;
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
            if ((n % 32) == 0) begin
              $display("%0t decode done %0d. decfail = %0d, err = %0d, est err %0d", $time, n, dec__odecfail, numerr[k], est_numerr[k]);
            end
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
      $display("bits %0d EbNo = %0.2f: ber = %0.2e. fer = %0.2e", Npkt*data_bit_length, EbNo[k], numerr[k]*1.0/(Npkt*data_bit_length), est_numerr[k]*1.0/(Npkt*code_bit_length));
    end
    //
    #1us;
    $display("test done %0t", $time);
    $stop;
  end

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  function automatic real get_coderate (input bit idxGr, int code, bit do_punct);
  begin
    if (idxGr) begin
      if (do_punct)
        get_coderate = 1.0*10/(8 + code);
      else
        get_coderate = 1.0*10/(10 + code);
    end
    else begin
      if (do_punct)
        get_coderate = 1.0*22/(20 + code);
      else
        get_coderate = 1.0*22/(22 + code);
    end
  end
  endfunction

endmodule


