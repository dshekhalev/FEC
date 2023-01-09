//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : awgn.vh
// Description   : AWGN noise generator class
//

  typedef struct {
    real re;
    real im;
  } cmplx_real_dat_t;

  class awgn_class ;
    //
    // awgn paramters
    real EbNo;
    real bps;
    real coderate;
    real SNR;
    real sigma;
    int  seed;

    //
    // function to init awgn parameter's based upon EbNo
    //    EbNo      - EbNo in db
    //    bps       - bit per symbol
    //    coderate  - coderate for used coder
    //    Ps        - signal power
    //    seed      - initial generator seed
    //
    function automatic void init_EbNo (real EbNo = 1, bps = 2, coderate = 1, Ps = 1, int seed = 0);
      this.EbNo     = EbNo;
      this.bps      = bps;
      this.coderate = coderate;
      this.seed     = seed;
      this.SNR      = get_snr(EbNo, bps, coderate);
      this.sigma    = get_sigma(SNR, Ps);
    endfunction

    //
    // function to init awgn parameter's based upon SNR
    //    SNR       - SNR in db
    //    Ps        - signal power
    //    seed      - initial generator seed
    //
    function automatic void init_SNR (real SNR = 0, Ps = 1, int seed = 0);
      this.EbNo   = 1000;
      this.seed   = seed;
      this.SNR    = SNR;
      this.sigma  = get_sigma(SNR, Ps);
    endfunction

    //
    // function to count used SNR
    //    EbNo      - EbNo in db
    //    bps       - bit per symbol
    //    coderate  - coderate for used coder
    //
    function real get_snr (real EbNo = 1, bps = 2, coderate = 1);
      return (EbNo + 10*$log10(bps) + 10*$log10(coderate));
    endfunction

    //
    // function to count sigma for complex normal distortion generator
    //    SNR - signal to noise ration
    //    Ps  - signal power
    //
    function real get_sigma(real SNR = 1, Ps = 1);
      return $sqrt(Ps/(10.0**(SNR/10.0))/2.0);
    endfunction

    //
    // get complex noise function
    //

    function automatic cmplx_real_dat_t get_noise (bit bypass = 0);
    begin
      if (bypass) return '{0, 0};
      //
      get_noise.re = sigma * $dist_normal(seed, 0, 2**24)/2**24;
      //
      get_noise.im = sigma * $dist_normal(seed, 0, 2**24)/2**24;
      //
//    $display("noise sigma %0f (re/im)/sigma = {%0f, %0f}", sigma, get_noise.re, get_noise.im);
    end
    endfunction

    //
    // add complex noise function
    //

    function automatic cmplx_real_dat_t add (cmplx_real_dat_t dat, bit bypass = 0);
      real tmp_re;
      real tmp_im;
    begin
      if (bypass) return dat;
      //
      tmp_re = sigma * $dist_normal(seed, 0, 2**24)/2**24;
      add.re = dat.re + tmp_re;
      //
      tmp_im = sigma * $dist_normal(seed, 0, 2**24)/2**24;
      add.im = dat.im + tmp_im;
      //
//    $display("noise sigma %0f (re/im)/sigma = {%0f, %0f}", sigma, tmp_re/sigma, tmp_im/sigma);
    end
    endfunction

    //
    // count power of complex signal
    //

    function automatic real pow (cmplx_real_dat_t dat);
      return ((dat.re * dat.re) + (dat.im * dat.im));
    endfunction

    //
    // add complex noise function
    //

    function void log ();
      if (EbNo == 1000)
        $display("EbNo = unknown, SNR = %0f, sigma = %0f", SNR, sigma);
      else begin
        $display("EbNo  = %0f, bps = %0f, coderate = %0f", EbNo, bps, coderate);
        $display("SNR = %0f, sigma = %0f", SNR, sigma);
      end
    endfunction

  endclass
