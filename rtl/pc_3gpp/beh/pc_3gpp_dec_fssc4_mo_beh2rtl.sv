/*






  logic                pc_3gpp_dec_sc_beh__iclk     ;
  logic                pc_3gpp_dec_sc_beh__ireset   ;
  logic                pc_3gpp_dec_sc_beh__iclkena  ;
  logic                pc_3gpp_dec_sc_beh__isop     ;
  logic                pc_3gpp_dec_sc_beh__ival     ;
  logic                pc_3gpp_dec_sc_beh__ieop     ;
  logic [pLLR_W-1 : 0] pc_3gpp_dec_sc_beh__iLLR     ;
  logic                pc_3gpp_dec_sc_beh__ordy     ;
  logic                pc_3gpp_dec_sc_beh__osop     ;
  logic                pc_3gpp_dec_sc_beh__oval     ;
  logic                pc_3gpp_dec_sc_beh__oeop     ;
  logic                pc_3gpp_dec_sc_beh__odat     ;
  int                  pc_3gpp_dec_sc_beh__oerr     ;



  pc_3gpp_dec_sc_beh
  pc_3gpp_dec_sc_beh
  (
    .iclk    ( pc_3gpp_dec_sc_beh__iclk    ) ,
    .ireset  ( pc_3gpp_dec_sc_beh__ireset  ) ,
    .iclkena ( pc_3gpp_dec_sc_beh__iclkena ) ,
    .isop    ( pc_3gpp_dec_sc_beh__isop    ) ,
    .ival    ( pc_3gpp_dec_sc_beh__ival    ) ,
    .ieop    ( pc_3gpp_dec_sc_beh__ieop    ) ,
    .iLLR    ( pc_3gpp_dec_sc_beh__iLLR    ) ,
    .ordy    ( pc_3gpp_dec_sc_beh__ordy    ) ,
    .osop    ( pc_3gpp_dec_sc_beh__osop    ) ,
    .oval    ( pc_3gpp_dec_sc_beh__oval    ) ,
    .oeop    ( pc_3gpp_dec_sc_beh__oeop    ) ,
    .odat    ( pc_3gpp_dec_sc_beh__odat    ) ,
    .oerr    ( pc_3gpp_dec_sc_beh__oerr    )
  );


  assign pc_3gpp_dec_sc_beh__iclk    = '0 ;
  assign pc_3gpp_dec_sc_beh__ireset  = '0 ;
  assign pc_3gpp_dec_sc_beh__iclkena = '0 ;
  assign pc_3gpp_dec_sc_beh__isop    = '0 ;
  assign pc_3gpp_dec_sc_beh__ival    = '0 ;
  assign pc_3gpp_dec_sc_beh__ieop    = '0 ;
  assign pc_3gpp_dec_sc_beh__iLLR    = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_fssc4_mo_beh2rtl.sv
// Description   : PC 3GPP {1024, 512} encoder without interleaving and with optional CRC5 encoder
//                 fast x4 serail successive cancellation decoder behaviour model look like RTL
//

`include "define.vh"

module pc_3gpp_dec_fssc4_mo_beh2rtl
#(
  parameter int pLLR_W    =        4 ,
  parameter int pN_MAX    =     1024 ,
  parameter int pDATA_N   = pN_MAX/2 ,
  parameter bit pUSE_CRC  =        0 ,
  parameter bit pUSE_ROA  =        1 ,  // use only reverse order addressing
  //
  parameter int pCMD_LOG  =        0 ,  // 0/1/2 - no any log/write to file/ write to file and display
  parameter bit pUSE_LOG  =        0
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  iLLR    ,
  ordy    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  oerr    ,
  ocrc_err
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                isop    ;
  input  logic                ival    ;
  input  logic                ieop    ;
  input  logic [pLLR_W-1 : 0] iLLR    ;
  output logic                ordy    ;
  //
  output logic                osop    ;
  output logic                oval    ;
  output logic                oeop    ;
  output logic                odat    ;
  output int                  oerr    ;
  output logic                ocrc_err;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cNLOG2 = clogb2(pN_MAX);

  localparam int cDAT_W = pLLR_W + cNLOG2;  // maximum data width

  typedef logic signed [pLLR_W-1 : 0] llr_t;

  typedef logic signed [cDAT_W-1 : 0] alpha_dat_t;

  typedef logic signed [cDAT_W-1 : 0] alpha_f_dat_t; // full word for mathematic

  typedef bit   datN_t [pN_MAX];
  typedef llr_t llrN_t [pN_MAX];

  typedef alpha_dat_t llr8_t [8];
  typedef alpha_dat_t llr4_t [4];

  typedef bit [cNLOG2-1 : 0] addr_t;

  `include "../../pc_3gpp/pc_3gpp_ts_38_212_tab.svh"

  localparam int info_bits_16_addr_tab [16] = '{
    15, 14, 13, 11, 7, 12, 10, 9, 6, 5, 3, 8, 4, 2, 1, 0
  };

  localparam int info_bits_32_addr_tab [32] = '{
    31, 30, 29, 27, 23, 15, 28, 26, 25, 22, 21, 14, 19, 13, 11, 24, 20, 7, 18, 12, 17, 10, 9, 6, 5, 16, 3, 8, 4, 2, 1, 0
  };

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cUSED_N_MAX = pN_MAX/8;

  addr_t        addr;

  llr_t         chLLR          [cUSED_N_MAX][8];
  bit   [7 : 0] frozen_bits    [cUSED_N_MAX];
  bit   [7 : 0] frozen_bits_ro [cUSED_N_MAX];

  logic [7 : 0] b_sc        [cUSED_N_MAX][2];
  bit   [7 : 0] outB        [cUSED_N_MAX];

  alpha_dat_t   llr_sc      [cUSED_N_MAX][8];
  bit   [7 : 0] hd_data     [cUSED_N_MAX];

  bit           coded_bits  [pN_MAX];
  bit           info_bits   [pN_MAX];

  bit   [4 : 0] crc;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    //
    bit tmp_bits  [pN_MAX];
    //
    bit [4 : 0] crc, crc_ref;
    bit         tbit;
    //
    addr_t taddr;
    int    biterr;
    //
    ordy <= 1'b1;
    osop <= 1'b0;
    oval <= 1'b0;
    oeop <= 1'b0;
    odat <= 1'b0;
    //
    forever begin
      @(posedge iclk);
      if (ival) begin
        if (isop) begin
          frozen_bits = '{default : '1};
          //
          addr        = 0;
        end
        //
        taddr = pUSE_ROA ? reverse_bit(addr++, cNLOG2) : addr++;
        // saturate & metric invertion
        if (&{iLLR[pLLR_W-1], ~iLLR[pLLR_W-2 : 0]}) begin // -2^(N-1)
          chLLR[taddr/8][taddr % 8] = {1'b0, {(pLLR_W-2){1'b1}} ,1'b1};   // -(2^(N-1) - 1)
        end
        else begin
          chLLR[taddr/8][taddr % 8] = -iLLR;
        end
        // frozen bit map
        case (pN_MAX)
          16      : taddr = info_bits_16_addr_tab[addr];
          32      : taddr = info_bits_32_addr_tab[addr];
          default : taddr = bits_addr_tab [addr];
        endcase
        //
        if (addr < (pDATA_N + (pUSE_CRC*5))) begin
          frozen_bits[taddr/8][taddr % 8] = 1'b0;
          //
          taddr = reverse_bit(taddr, cNLOG2);
          frozen_bits_ro[taddr/8][taddr % 8] = 1'b0;
        end
        else begin
          frozen_bits[taddr/8][taddr % 8] = 1'b1;
          //
          taddr = reverse_bit(taddr, cNLOG2);
          frozen_bits_ro[taddr/8][taddr % 8] = 1'b1;
        end
        //
        if (ieop) begin
          ordy <= 1'b0;
          //
          // do decode
          tmp_bits = do_ns_decode(cNLOG2, biterr);
          //
          repeat (10) @(posedge iclk);
          info_bits = tmp_bits;
          //
          oerr = biterr;
          //
          if (pUSE_CRC) begin
            crc = 0;
            for (int i = 0; i < 5; i++) begin
              crc_ref[i] = info_bits[bits_addr_tab[pDATA_N + i]];
            end
          end
          //
          for (int i = 0; i < pDATA_N; i++) begin
            oval <= 1'b1;
            osop <= (i == 0);
            oeop <= (i == pDATA_N-1);
            //
            case (pN_MAX)
              16      : tbit = info_bits[info_bits_16_addr_tab[i]];
              32      : tbit = info_bits[info_bits_32_addr_tab[i]];
              default : tbit = info_bits[bits_addr_tab[i]];
            endcase
            odat <= tbit;
            //
            crc = get_crc(crc, tbit);
            if (i == pDATA_N-1) begin
              ocrc_err <= pUSE_CRC & (crc != crc_ref);
            end
            //
            @(posedge iclk);
            oval <= 1'b0;
            osop <= 1'b0;
            oeop <= 1'b0;
          end
          //
          ordy <= 1'b1;
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decode function
  //
  // arrays :
  //  frozen_bits [phi]             - frozen bits array
  //  b_sc        [lambda][beta][phi]   - layer bit data
  //  llr_sc      [lambda][beta][phi]   - layer LLR data
  //
  //------------------------------------------------------------------------------------------------------

  logic [7 : 0] m_rb_sc [cUSED_N_MAX][2];
  bit   [7 : 0] outRam  [cUSED_N_MAX];

  function automatic int get_i_sc (input int lambda, beta, m);
    get_i_sc = beta + 2**(m-lambda);
  endfunction

  function automatic int get_bi_sc (input int lambda, beta, m);
    get_bi_sc = beta + (2**(m-lambda))/8;
  endfunction

  int     cmd_fp;
  int     dec_fp;

  string  cmd_fname = $psprintf("cmd_sequence_%m.log");
  string  dec_fname = $psprintf("dec_sequence_%m.log");

  // work by 4 bits per cycle
  function automatic datN_t do_ns_decode (input int m, output int biterr);

    int         waddr;
    int         raddr;

    int         taddr;

    datN_t      tmp_data;

    int         fp;
    string      fname;
    //
    bit [7 : 0] frozenb;
    llr8_t      llr2fg;
    llr4_t      llr2dec;
    bit [7 : 0] decodeb;
  begin
    //
    for (int beta = 0; beta < 2**m/8; beta++) begin
      for (int b = 0; b < 8; b++) begin
        hd_data[beta][b] = (chLLR[beta][b] < 0); // metric inversion
      end
    end
    //
    if (pCMD_LOG != 0) begin
      cmd_fp = $fopen(cmd_fname, "w");
      if (pCMD_LOG >= 3) begin
        dec_fp = $fopen(dec_fname, "w");
      end
    end
    //
    for (int phi = 0; phi < 2**(m - 3); phi++) begin

      //
      // calc F8/G8..... functions througth tree
//    wide_recursivelyCalcP(m-3, phi, m);

      // decoder tree up to 2^10
//    if (phi[5 : 0] == 0)  do_wide_CalcP(m-9, phi[6], m);  // F512/G512
//    if (phi[4 : 0] == 0)  do_wide_CalcP(m-8, phi[5], m);  // F256/G256
//    if (phi[3 : 0] == 0)  do_wide_CalcP(m-7, phi[4], m);  // F128/G128
//    if (phi[2 : 0] == 0)  do_wide_CalcP(m-6, phi[3], m);  //  F64/G64
//    if (phi[1 : 0] == 0)  do_wide_CalcP(m-5, phi[2], m);  //  F32/G32
//    if (phi[0 : 0] == 0)  do_wide_CalcP(m-4, phi[1], m);  //  F16/G16
//                          do_wide_CalcP(m-3, phi[0], m);  //   F8/G8

      if      (phi[5 : 0] == 0) begin
        do_wide_CalcP(m-9, phi[6], m);  // F512/G512
        do_wide_CalcP(m-8, phi[5], m);  // F256/G256
        do_wide_CalcP(m-7, phi[4], m);  // F128/G128
        do_wide_CalcP(m-6, phi[3], m);  //  F64/G64
        do_wide_CalcP(m-5, phi[2], m);  //  F32/G32
        do_wide_CalcP(m-4, phi[1], m);  //  F16/G16
      end
      else if (phi[4 : 0] == 0) begin
        do_wide_CalcP(m-8, phi[5], m);  // F256/G256
        do_wide_CalcP(m-7, phi[4], m);  // F128/G128
        do_wide_CalcP(m-6, phi[3], m);  //  F64/G64
        do_wide_CalcP(m-5, phi[2], m);  //  F32/G32
        do_wide_CalcP(m-4, phi[1], m);  //  F16/G16
      end
      else if (phi[3 : 0] == 0) begin
        do_wide_CalcP(m-7, phi[4], m);  // F128/G128
        do_wide_CalcP(m-6, phi[3], m);  //  F64/G64
        do_wide_CalcP(m-5, phi[2], m);  //  F32/G32
        do_wide_CalcP(m-4, phi[1], m);  //  F16/G16
      end
      else if (phi[2 : 0] == 0) begin
        do_wide_CalcP(m-6, phi[3], m);  //  F64/G64
        do_wide_CalcP(m-5, phi[2], m);  //  F32/G32
        do_wide_CalcP(m-4, phi[1], m);  //  F16/G16
      end
      else if (phi[1 : 0] == 0) begin
        do_wide_CalcP(m-5, phi[2], m);  //  F32/G32
        do_wide_CalcP(m-4, phi[1], m);  //  F16/G16
      end
      else if (phi[0 : 0] == 0) begin
        do_wide_CalcP(m-4, phi[1], m);  //  F16/G16
      end

      do_wide_CalcP(m-3, phi[0], m);  //   F8/G8

      //------------------------------------------------------------------------------------------------------
      // BEGIN internal decoding of polar 8x8 code
      //------------------------------------------------------------------------------------------------------

      // prepare frozen bits to cycle
      frozenb = frozen_bits[phi];

      raddr = 1; //get_bi_sc(m-3, 0, m);

      llr2fg = llr_sc[raddr];

      if (frozenb == 8'hFF) begin
        decodeb = decode_Rate0_8();
      end
      else if (frozenb == 8'h00) begin
        decodeb = decode_Rate1_8(llr2fg);
      end
      else if (frozenb[0 +: 4] == 4'hF) begin
//      decodeb[0 +: 4] = decode_Rate0_4();
        // G4 section
        llr2dec         = CalcG4(llr2fg, 4'h0, m-2, m);
        decodeb[4 +: 4] = rtl_do_fast_decision4(llr2dec, frozenb[4 +: 4]);
        // Comb4 section
        decodeb         = Comb4(4'h0, decodeb[4 +: 4], m-2, m);
      end
      else if (frozenb[4 +: 4] == 4'hF) begin
        // F4 section
        llr2dec         = CalcF4(llr2fg, m-2, m);
        decodeb[0 +: 4] = rtl_do_fast_decision4(llr2dec, frozenb[0 +: 4]);
//      decodeb[4 +: 4] = decode_Rate0_4();
        // Comb4 section
        decodeb         = Comb4(decodeb[0 +: 4], 4'h0, m-2, m);
      end
      else begin
        // F4 section
        llr2dec         = CalcF4(llr2fg, m-2, m);

        decodeb[0 +: 4] = rtl_do_fast_decision4(llr2dec, frozenb[0 +: 4]);
        // G4 section
        llr2dec         = CalcG4(llr2fg, decodeb[0 +: 4], m-2, m);

        decodeb[4 +: 4] = rtl_do_fast_decision4(llr2dec, frozenb[4 +: 4]);
        // Comb4 section
        decodeb         = Comb4(decodeb[0 +: 4], decodeb[4 +: 4], m-2, m);
      end

      waddr = 1; // get_bi_sc(m-3, 0, m);

      b_sc[waddr][phi % 2] = decodeb;

      if (pCMD_LOG >= 3) begin
        $fdisplay(dec_fp, "Decode %0p (opcode %b) -> %b", llr2fg, frozenb, decodeb);
      end

      //------------------------------------------------------------------------------------------------------
      // END :: internal decoding of polar 8x8 code
      //------------------------------------------------------------------------------------------------------

      // Comb8... function througth tree
//    if ((phi % 2) == 1)
//      wide_recursivelyUpdateB(m-3, phi, m);

      // coder tree up to 2^10
      if (phi[0]) do_wide_UpdateB(m-3, phi[1], m); else continue;  // comb8
      if (phi[1]) do_wide_UpdateB(m-4, phi[2], m); else continue;  // comb16
      if (phi[2]) do_wide_UpdateB(m-5, phi[3], m); else continue;  // comb32
      if (phi[3]) do_wide_UpdateB(m-6, phi[4], m); else continue;  // comb64
      if (phi[4]) do_wide_UpdateB(m-7, phi[5], m); else continue;  // comb128
      if (phi[5]) do_wide_UpdateB(m-8, phi[6], m); else continue;  // comb256
      if (phi[6]) do_wide_UpdateB(m-9, phi[7], m); else continue;  // comb512

    end

    if (pUSE_LOG) begin
      fname = $psprintf("bit_layer_%m.log");
      fp = $fopen(fname, "w");

      $fdisplay(fp, "bit layer %p", b_sc);

      $fclose(fp);

      fname = $psprintf("llr_layer_%m.log");
      fp = $fopen(fname, "w");

      $fdisplay(fp, "LLR layer %p", llr_sc);

      $fclose(fp);
    end

    if (pCMD_LOG != 0) begin
      $fclose(cmd_fp);
      if (pCMD_LOG >= 3) begin
        $fclose(dec_fp);
      end
    end

    //
    biterr = 0;
    for (int beta = 0; beta < cUSED_N_MAX; beta++) begin
      for (int b = 0; b < 8; b++) begin
        biterr += (outB[beta][b] ^ hd_data[beta][b]);
      end
    end

    //------------------------------------------------------------------------------------------------------
    // re encode to get info word by reverse encoding
    //------------------------------------------------------------------------------------------------------

    for (int i = 0; i < pN_MAX/8; i++) begin
      outB[i] &= ~frozen_bits_ro[i];
    end

    // revers order re encoding
    do_ns_Rencode(m);
    //
    for (int i = 0; i < pN_MAX; i++) begin
      do_ns_decode[i] = outRam[i/8][i % 8];
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // decode phase tree functions : reverse bit order only
  //------------------------------------------------------------------------------------------------------

  function automatic void do_wide_CalcP (input int lambda, phi, m);
    int n;
    bit u_p;
    int b_rhs0, b_rhs1;
    //
    llr8_t  llr2fg;
    llr4_t  llr4fg;
    bit [3 : 0] decodedb;
    //
    int waddr;
    int raddr;
  begin
    //
    // internal layers F vs G functions :: use 8 LLR data to get 4 LLR per cycle
    //
    n = 2**(m - lambda);
    //
    for (int beta = 0; beta < n/4; beta++) begin
      waddr = get_bi_sc(lambda, beta/2, m);
      // bit raddr = waddr
      if (beta[0]) begin
        decodedb = b_sc[waddr][0][4 +: 4];
      end
      else begin
        decodedb = b_sc[waddr][0][0 +: 4];
      end
      //
      if (lambda == 1) begin
        raddr = beta;

        for (int i = 0; i < 8; i++) begin
          llr2fg[i] = chLLR[raddr][i];
        end
      end
      else begin
        raddr = get_bi_sc(lambda-1, beta, m);

        for (int i = 0; i < 8; i++) begin
          llr2fg[i] = llr_sc[raddr][i];
        end
      end
      //
      if ((phi % 2) == 0) begin
        llr4fg = CalcF_by4(llr2fg);
        //
        if (pCMD_LOG >= 1) begin
          if (beta == 0) begin
            $fdisplay(cmd_fp, "F%0d layer %0d", n, lambda);
            if (pCMD_LOG >= 2) $display("F%0d layer %0d", n, lambda);
          end
          if (pCMD_LOG >= 3) begin
            if (lambda == 1) begin
              $fdisplay(dec_fp, "F4 LLR -> [%0d][%0d]. %0p", waddr, beta[0], llr2fg);
            end
            else begin
              $fdisplay(dec_fp, "F4 [%0d]-> [%0d][%0d]. %0p", raddr, waddr, beta[0], llr2fg);
            end
          end
        end
      end
      else begin
        llr4fg = CalcG_by4(llr2fg, decodedb);
        //
        if (pCMD_LOG >= 1) begin
          if (beta == 0) begin
            $fdisplay(cmd_fp, "G%0d layer %0d", n, lambda);
            if (pCMD_LOG >= 2) $display("G%0d layer %0d", n, lambda);
          end
          if (pCMD_LOG >= 3) begin
            if (lambda == 1) begin
              $fdisplay(dec_fp, "G4 LLR -> [%0d][%0d]. %0p", waddr, beta[0], llr2fg);
            end
            else begin
              $fdisplay(dec_fp, "G4 [%0d] & [%0d][%0d]-> [%0d][%0d]. %0p & %b -> %0p", raddr, waddr, beta[0],
                        waddr, beta[0], llr2fg, decodedb, llr4fg);
            end
          end
        end
      end
      //
      if (beta[0])
        llr_sc[waddr][4 +: 4] = llr4fg;
      else
        llr_sc[waddr][0 +: 4] = llr4fg;
    end
  end
  endfunction

  function automatic void do_wide_UpdateB (input int lambda, phi, m);
    int waddr;
    int raddr;

    int psi;
    int n;
    bit [3 : 0] bitL, bitR;
    bit [7 : 0] decodedb;
  begin
    //
//  psi = phi/2;
    psi = phi;
    //
    n = 2**(m-lambda);
    //
    for (int beta = 0; beta < n/4; beta++) begin
      raddr = get_bi_sc(lambda, beta/2, m);

      if (beta[0]) begin
        bitL = b_sc[get_bi_sc(lambda, beta/2, m)][0][4 +: 4];
        bitR = b_sc[get_bi_sc(lambda, beta/2, m)][1][4 +: 4];
      end
      else begin
        bitL = b_sc[get_bi_sc(lambda, beta/2, m)][0][0 +: 4];
        bitR = b_sc[get_bi_sc(lambda, beta/2, m)][1][0 +: 4];
      end
      //
      decodedb = Comb_by4(bitL, bitR);
      //
      if (lambda == 1) begin
        waddr = beta;
        //
        outB[waddr] = decodedb;
      end
      else begin
        waddr = get_bi_sc(lambda-1, beta, m);
        //
        b_sc[waddr][psi % 2] = decodedb;
      end
      //
      if (pCMD_LOG >= 1) begin
        if (beta == 0) begin
          $fdisplay(cmd_fp, "Comb%0d layer %0d", n, lambda);
          if (pCMD_LOG >= 2) $display("Comb%0d layer %0d", n, lambda);
        end
        if (pCMD_LOG >= 3) begin
          if (lambda == 1) begin
            $fdisplay(dec_fp, "COMB8 [%0d][%0d]-> [%0d][%0d]. %b vs %b = %b" , raddr, beta[0], waddr, psi % 2, bitL, bitR, decodedb);
          end
          else begin
            $fdisplay(dec_fp, "COMB8 [%0d][%0d]-> [%0d][%0d]. %b vs %b", raddr, beta[0], waddr, psi % 2, bitL, bitR);
          end
        end
      end
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // common fast decode 4 bit function
  //------------------------------------------------------------------------------------------------------

  // reverse order
  function automatic bit [3 : 0] rtl_do_fast_decision4 (input llr4_t llr = '{default : 0}, bit [3 : 0] frozenb);
    bit [3 : 0] decodeb;
    llr4_t      llr2dec;
    bit [3 : 0] bit2out;
  begin
    llr2dec = {llr[0], llr[2],
               llr[1], llr[3]};

    decodeb = do_fast_decision4(llr2dec, frozenb);

    bit2out = {decodeb[3], decodeb[1],
               decodeb[2], decodeb[0]};

    return bit2out;
  end
  endfunction

  // linear order
  function automatic bit [3 : 0] do_fast_decision4 (input llr4_t llr, bit [3 : 0] frozenb);
    bit [3 : 0] decodeb;
  begin
    case (frozenb)
      4'b1111   : begin
        decodeb = decode_Rate0_4(llr);
      end
      4'b0000   : begin
        decodeb = decode_Rate1_4 (llr);
      end
      4'b0111   : begin
        decodeb = decode_Rep_4 (llr);
      end
      4'b0001   : begin
        decodeb = decode_Spc_4 (llr);
      end
      4'b0011   : begin
        decodeb = decode_Rate0_2_Rate1_2 (llr);
      end
      4'b0101   : begin
        decodeb = decode_Rep_2_Rep_2 (llr);
      end

      default : begin
        decodeb = decode_sc_4(llr, frozenb);

        $display("unknown opcode use sc %b", frozenb);
        $stop;
      end
    endcase

    return decodeb;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // alpha functions : reverse bit order only
  //------------------------------------------------------------------------------------------------------

  function automatic llr4_t CalcF_by4 (input llr8_t llr);
    llr4_t llrL;
    llr4_t llrR;
    llr4_t cnode_llr;
  begin
    llrL = '{llr[0], llr[2], llr[4], llr[6]};
    llrR = '{llr[1], llr[3], llr[5], llr[7]};
    //
    for (int beta = 0; beta < 4; beta++) begin
      cnode_llr[beta] = cnode(llrL[beta], llrR[beta]);
    end
    //
    return cnode_llr;
  end
  endfunction

  // phi % 2 == 1.
  function automatic llr4_t CalcG_by4 (input llr8_t llr, input bit [3 : 0] decodebL);
    bit u_p;
    llr4_t llrL;
    llr4_t llrR;
    llr4_t vnode_llr;
  begin
    llrL = '{llr[0], llr[2], llr[4], llr[6]};
    llrR = '{llr[1], llr[3], llr[5], llr[7]};
    //
    for (int beta = 0; beta < 4; beta++) begin
      u_p = decodebL[beta];
      //
      vnode_llr[beta] = vnode(llrL[beta], llrR[beta], u_p);
    end
    //
    return vnode_llr;
  end
  endfunction

  function automatic llr4_t CalcF4 (input llr8_t llr, input int lambda, m);
    int n;
    llr4_t cnode_llr;
  begin
    if (lambda != (m-2)) begin
      $display("Error: incorrect layer access in this function call");
      $stop;
    end
    //
    cnode_llr = CalcF_by4 (llr);
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "F4 layer %0d", lambda);
      if (pCMD_LOG >= 2) $display("F4 layer %0d", lambda);
    end
    //
    return cnode_llr;
  end
  endfunction

  // phi % 2 == 1
  function automatic llr4_t CalcG4 (input llr8_t llr, input bit [3 : 0] decodebL, input int lambda, m);
    int n;
    bit u_p;
    llr4_t vnode_llr;
  begin
    if (lambda != (m-2)) begin
      $display("Error: incorrect layer access in this function call");
      $stop;
    end
    //
    vnode_llr = CalcG_by4(llr, decodebL);
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "G4 layer %0d", lambda);
      if (pCMD_LOG >= 2) $display("G4 layer %0d", lambda);
    end
    //
    return vnode_llr;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // bit functions : reverse bit order only
  //------------------------------------------------------------------------------------------------------

  function automatic bit [7 : 0] Comb_by4 (input bit [3 : 0] bitL, bitR);
  begin
    {Comb_by4[6], Comb_by4[4], Comb_by4[2], Comb_by4[0]} = bitL ^ bitR;
    {Comb_by4[7], Comb_by4[5], Comb_by4[3], Comb_by4[1]} = bitR;
  end
  endfunction

  function automatic bit [7 : 0] Comb4 (input bit [3 : 0] bitL, bitR, input int lambda, m);
    int n;
  begin
    if (lambda != (m-2)) begin
      $display("Error: incorrect layer access in this function call");
      $stop;
    end
    //
    Comb4 = Comb_by4(bitL, bitR);
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Comb%0d layer %0d", n, lambda);
      if (pCMD_LOG >= 2) $display("Comb%0d layer %0d", n, lambda);
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // fast decode 2 bit functions : linear order
  //------------------------------------------------------------------------------------------------------

  // 2'b11
  function automatic bit [1 : 0] decode_Rate0_2 (input alpha_dat_t llr0, llr1);
    decode_Rate0_2 = 2'b00;
  endfunction

  // 2'b00
  function automatic bit [1 : 0] decode_Rate1_2 (input alpha_dat_t llr0, llr1);
    decode_Rate1_2[0] = (llr0 >= 0) ? 0 : 1;
    decode_Rate1_2[1] = (llr1 >= 0) ? 0 : 1;
  endfunction

  // 4'b01
  function automatic bit [1 : 0] decode_Rep_2 (input alpha_dat_t llr0, llr1);
    alpha_f_dat_t this_llr;
  begin
    this_llr = llr0 + llr1;
    decode_Rep_2[0] = (this_llr >= 0) ? 0 : 1;
    decode_Rep_2[1] = (this_llr >= 0) ? 0 : 1;
  end
  endfunction

  // 4'b10
  function automatic bit [1 : 0] decode_Sp01_2 (input alpha_dat_t llr0, llr1);
    alpha_dat_t this_llr;
  begin
//  this_llr = cnode(llr0, llr1);
    decode_Sp01_2[0] = (llr0 >= 0) ^ (llr1 >= 0); // (this_llr >= 0) ? 0 : 1;
    decode_Sp01_2[1] = 0;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // fast decode 8 bit functions : linear order
  //------------------------------------------------------------------------------------------------------

  // 8'b11111111
  function automatic bit [7 : 0] decode_Rate0_8 (input alpha_dat_t llr [8] = '{default : '0});
    decode_Rate0_8 = 8'h00;
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Rate0_8(opcode 11111111)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Rate0_8(opcode 11111111)");
    end
  endfunction

  // 8'b00000000
  function automatic bit [7 : 0] decode_Rate1_8 (input alpha_dat_t llr [8]);
    for (int i = 0; i < 8; i++) begin
      decode_Rate1_8[i] = (llr[i] >= 0) ? 0 : 1;
    end
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Rate1_8(opcode 00000000)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Rate1_8(opcode 00000000)");
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // fast decode 4 bit functions : linear order
  //------------------------------------------------------------------------------------------------------

  // 4'b1111
  function automatic bit [3 : 0] decode_Rate0_4 (input alpha_dat_t llr [4] = '{default : '0});
    decode_Rate0_4 = 4'b0000;
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Rate0_4(opcode 1111)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Rate0_4(opcode 1111)");
    end
  endfunction

  // 4'b0000
  function automatic bit [3 : 0] decode_Rate1_4 (input alpha_dat_t llr [4]);
    for (int i = 0; i < 4; i++) begin
      decode_Rate1_4[i] = (llr[i] >= 0) ? 0 : 1;
    end
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Rate1_4(opcode 0000)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Rate1_4(opcode 0000)");
    end
  endfunction

  // 4'b0111
  function automatic bit [3 : 0] decode_Rep_4 (input alpha_dat_t llr [4]);
    alpha_f_dat_t sum_llr;
  begin
    sum_llr = llr[0] + llr[1] + llr[2] + llr[3];
    for (int i = 0; i < 4; i++) begin
      decode_Rep_4[i] = (sum_llr >= 0) ? 0 : 1;
    end
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Rep_4(opcode 0111)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Rep_4(opcode 0111)");
    end
  end
  endfunction

  // 4'b0001
  function automatic bit [3 : 0] decode_Spc_4 (input alpha_dat_t llr [4]);
    alpha_dat_t tmp_llr [4];
    bit           pc;
    //
    alpha_dat_t min_llr     [2];
    int           min_llr_idx [2];
    int           min_rslt       ;
  begin
    pc = 0;
    for (int i = 0; i < 4; i++) begin
      pc ^= ((llr[i] >= 0) ? 0 : 1);
    end
    //
    for (int i = 0; i < 4; i++) begin
      tmp_llr[i] = absLLR(llr[i]);
    end
    min_llr     [0] = (tmp_llr[1] > tmp_llr[0]) ? tmp_llr[0] : tmp_llr[1];
    min_llr_idx [0] = (tmp_llr[1] > tmp_llr[0]) ?         0  :         1;

    min_llr     [1] = (tmp_llr[3] > tmp_llr[2]) ? tmp_llr[3] : tmp_llr[2];
    min_llr_idx [1] = (tmp_llr[3] > tmp_llr[2]) ?         3  :         2 ;
    //
    min_rslt = (min_llr[1] > min_llr[0]) ? min_llr_idx[0] : min_llr_idx[1];
    //
    for (int i = 0; i < 4; i++) begin
      if (pc == 0) begin // no parity error
        decode_Spc_4[i] = (llr[i] >= 0) ? 0 : 1;
      end
      else begin
        decode_Spc_4[i] = (llr[i] >= 0) ? 1 : 0;
      end
    end
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Spc_4(opcode 1000)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Spc_4(opcode 1000)");
    end
  end
  endfunction

  // 4'b0011
  function automatic bit [3 : 0] decode_Rate0_2_Rate1_2 (input alpha_dat_t llr [4]);
    alpha_f_dat_t sum_llr [2];
  begin
    sum_llr[0] = llr[0] + llr[2]; // vnode(llr[0], llr[2], 0);
    sum_llr[1] = llr[1] + llr[3]; // vnode(llr[1], llr[3], 0);
    //
    decode_Rate0_2_Rate1_2[0] = (sum_llr[0] >= 0) ? 0 : 1;
    decode_Rate0_2_Rate1_2[2] = (sum_llr[0] >= 0) ? 0 : 1;
    //
    decode_Rate0_2_Rate1_2[1] = (sum_llr[1] >= 0) ? 0 : 1;
    decode_Rate0_2_Rate1_2[3] = (sum_llr[1] >= 0) ? 0 : 1;
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Rate0_2_Rate1_2(opcode 0011)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Rate0_2_Rate1_2(opcode 0011)");
    end
  end
  endfunction

  // 4'b0101
  function automatic bit [3 : 0] decode_Rep_2_Rep_2 (input alpha_dat_t llr [4]);
    alpha_dat_t this_llr;

    bit    this_bit0;
    bit    this_bit1;

    alpha_dat_t this_llr0;
    alpha_dat_t this_llr1;
  begin
    //
    this_llr0 = cnode(llr[0], llr[2]);
    this_llr1 = cnode(llr[1], llr[3]);

    this_llr  = this_llr0 + this_llr1;
    this_bit0 = (this_llr >= 0) ? 0 : 1;
    //
    this_llr0 = vnode(llr[0], llr[2], this_bit0); // rep
    this_llr1 = vnode(llr[1], llr[3], this_bit0);

    this_llr  = this_llr0 + this_llr1;
    this_bit1 = (this_llr >= 0) ? 0 : 1;

    decode_Rep_2_Rep_2[0] = this_bit1 ^ this_bit0;
    decode_Rep_2_Rep_2[1] = this_bit1 ^ this_bit0;

    decode_Rep_2_Rep_2[2] = this_bit1;  // rep
    decode_Rep_2_Rep_2[3] = this_bit1;
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Rep_2_Rep_2(opcode 0101)");
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Rep_2_Rep_2(opcode 0101)");
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // classic SC decode 4 bit function : linear order
  //------------------------------------------------------------------------------------------------------

  function automatic bit [3 : 0] decode_sc_4 (input alpha_dat_t llr [4], bit [3 : 0] frozenb);
    alpha_dat_t sLLR  [2][4];
    bit         b[2][4];
  begin
    sLLR[0][0] = cnode(llr[0], llr[2]);
    sLLR[0][1] = cnode(llr[1], llr[3]);
    //
    //
    sLLR[1][0] = cnode(sLLR[0][0], sLLR[0][1]);
    b   [1][0] = frozenb[0] ? 1'b0 : ((sLLR[1][0] >= 0) ? 0 : 1);
    //
    sLLR[1][1] = vnode(sLLR[0][0], sLLR[0][1], b[1][0]);
    b   [1][1] = frozenb[1] ? 1'b0 : ((sLLR[1][1] >= 0) ? 0 : 1);
    //
    b[0][0] = b[1][0] ^ b[1][1];
    b[0][1] = b[1][1];
    //
    sLLR[0][2] = vnode(llr[0], llr[2], b[0][0]);
    sLLR[0][3] = vnode(llr[1], llr[3], b[0][1]);
    //
    sLLR[1][2] = cnode(sLLR[0][2], sLLR[0][3]);
    b   [1][2] = frozenb[2] ? 1'b0 : ((sLLR[1][2] >= 0) ? 0 : 1);
    //
    sLLR[1][3] = vnode(sLLR[0][2], sLLR[0][3], b[1][2]);
    b   [1][3] = frozenb[3] ? 1'b0 : ((sLLR[1][3] >= 0) ? 0 : 1);
    //
    b[0][2] = b[1][2] ^ b[1][3];
    b[0][3] = b[1][3];
    //
    decode_sc_4[0] = b[0][0] ^ b[0][2];
    decode_sc_4[1] = b[0][1] ^ b[0][3];
    decode_sc_4[2] = b[0][2];
    decode_sc_4[3] = b[0][3];
    //
    if (pCMD_LOG >= 1) begin
      $fdisplay(cmd_fp, "Decode sc_4 (opcode %b)", frozenb);
      if (pCMD_LOG >= 2) $fdisplay(cmd_fp, "Decode sc_4 (opcode %b)", frozenb);
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // node functions
  //------------------------------------------------------------------------------------------------------

  function automatic alpha_dat_t cnode (input alpha_dat_t aL, aR);
    alpha_dat_t abs_aL,  abs_aR;
    bit    sign_aL, sign_aR;
  begin
    sign_aL = (aL < 0);
    sign_aR = (aR < 0);
    //
    abs_aL  = sign_aL ? -aL : aL;
    abs_aR  = sign_aR ? -aR : aR;
    //
    if (abs_aL < abs_aR) begin
      cnode = (sign_aL ^ sign_aR) ? -abs_aL : abs_aL;
    end
    else begin
      cnode = (sign_aL ^ sign_aR) ? -abs_aR : abs_aR;
    end
  end
  endfunction

  function automatic alpha_dat_t vnode (input alpha_dat_t aL, aR, bit bL);
    vnode = aR + (bL ? -aL : aL);
  endfunction

  function automatic alpha_dat_t absLLR (input alpha_dat_t dat);
    absLLR = (dat < 0) ? -dat : dat;
  endfunction

  //------------------------------------------------------------------------------------------------------
  // encode
  //------------------------------------------------------------------------------------------------------

  function automatic datN_t do_ns_encode (ref datN_t x, input int m);
    int     increment, step;
    datN_t  tmp;
    int     n;
  begin
    tmp = x;
    //
    n = 2**m;
    //
    for (int iter = 0; iter < m; iter++) begin
      increment = 2**iter;
      for (int j = 0; j < increment; j++) begin
        step = 2*increment;
        for (int i = 0; i < n; i += step) begin
          tmp[i+j] = tmp[i+j] ^ tmp[i+j+increment];
        end
      end
    end
    do_ns_encode = tmp;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // recursive 8bit encoder :: input is reverse order only
  //------------------------------------------------------------------------------------------------------

  function automatic void do_ns_Rencode (input int m);
    int waddr;
    int raddr;

    int n;
    bit [7 : 0] bit2code;
    bit [7 : 0] codedb;
  begin
    //
    n = 2**m;
    //
    for (int phi = 0; phi < (2**m)/8; phi++) begin

      bit2code  = outB[phi];

      codedb    = do_ns_encode_8x8(bit2code);

      b_sc[1][phi[0]] = codedb;

      // coder tree up to 2^10
      if (phi[0]) do_encode_UpdateB(m-3, phi[1], m); else continue;  // comb8
      if (phi[1]) do_encode_UpdateB(m-4, phi[2], m); else continue;  // comb16
      if (phi[2]) do_encode_UpdateB(m-5, phi[3], m); else continue;  // comb32
      if (phi[3]) do_encode_UpdateB(m-6, phi[4], m); else continue;  // comb64
      if (phi[4]) do_encode_UpdateB(m-7, phi[5], m); else continue;  // comb128
      if (phi[5]) do_encode_UpdateB(m-8, phi[6], m); else continue;  // comb256
      if (phi[6]) do_encode_UpdateB(m-9, phi[7], m); else continue;  // comb512
    end
  end
  endfunction

  //
  // revers bit order only
  function automatic bit [7 : 0] do_ns_encode_8x8 (input bit [7 : 0] bdat);
    bit [7 : 0] codedb;
  begin

    codedb[0] = bdat[0];
    codedb[1] = bdat[4];
    codedb[2] = bdat[2];
    codedb[3] = bdat[6];

    codedb[4] = bdat[1];
    codedb[5] = bdat[5];
    codedb[6] = bdat[3];
    codedb[7] = bdat[7];
    // layer 2
    codedb[0] ^= codedb[1];
    codedb[2] ^= codedb[3];
    codedb[4] ^= codedb[5];
    codedb[6] ^= codedb[7];
    // layer 1
    codedb[0] ^= codedb[2];
    codedb[1] ^= codedb[3];
    codedb[4] ^= codedb[6];
    codedb[5] ^= codedb[7];
    // layer 0
    codedb[0] ^= codedb[4];
    codedb[1] ^= codedb[5];
    codedb[2] ^= codedb[6];
    codedb[3] ^= codedb[7];
    //
    return codedb;
  end
  endfunction

  // revers bit order only
  function automatic void do_encode_UpdateB (input int lambda, phi, m);
    int waddr;
    int raddr;
    int psi;
    int n;
    bit [7 : 0] codedb;
    bit [7 : 0] bitL, bitR;
  begin
    //
    psi = phi;
    //
    n = 2**(m-lambda);
    //
    for (int beta = 0; beta < n/4; beta++) begin
      raddr = get_bi_sc(lambda, beta/2, m);

      bitL  = b_sc[raddr][0];
      bitR  = b_sc[raddr][1];

      if (lambda == 1) begin
        waddr = beta;
        //
        if (beta[0]) begin
          {outRam[waddr][6], outRam[waddr][4], outRam[waddr][2], outRam[waddr][0]} = bitL[4 +: 4] ^ bitR[4 +: 4];
          {outRam[waddr][7], outRam[waddr][5], outRam[waddr][3], outRam[waddr][1]} =                bitR[4 +: 4];
        end
        else begin
          {outRam[waddr][6], outRam[waddr][4], outRam[waddr][2], outRam[waddr][0]} = bitL[0 +: 4] ^ bitR[0 +: 4];
          {outRam[waddr][7], outRam[waddr][5], outRam[waddr][3], outRam[waddr][1]} =                bitR[0 +: 4];
        end
      end
      else begin
        waddr = get_bi_sc(lambda-1, beta,   m);
        //
        if (beta[0]) begin
          {b_sc[waddr][psi % 2][6], b_sc[waddr][psi % 2][4], b_sc[waddr][psi % 2][2], b_sc[waddr][psi % 2][0]} = bitL[4 +: 4] ^ bitR[4 +: 4];
          {b_sc[waddr][psi % 2][7], b_sc[waddr][psi % 2][5], b_sc[waddr][psi % 2][3], b_sc[waddr][psi % 2][1]} =                bitR[4 +: 4];
        end
        else begin
          {b_sc[waddr][psi % 2][6], b_sc[waddr][psi % 2][4], b_sc[waddr][psi % 2][2], b_sc[waddr][psi % 2][0]} = bitL[0 +: 4] ^ bitR[0 +: 4];
          {b_sc[waddr][psi % 2][7], b_sc[waddr][psi % 2][5], b_sc[waddr][psi % 2][3], b_sc[waddr][psi % 2][1]} =                bitR[0 +: 4];
        end
      end
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // address bit reverse function
  //------------------------------------------------------------------------------------------------------

  function automatic addr_t reverse_bit (input addr_t addr, int used_nlog2 = cNLOG2);
    reverse_bit = '0;
    for (int i = 0; i < used_nlog2; i++) begin
      reverse_bit[used_nlog2-1-i] = addr[i];
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function bit [4 : 0] get_crc (input bit [4 : 0] crc, bit dat);
    get_crc = {crc[0], crc[4 : 1] ^ {3'b000, dat}};
  endfunction

endmodule
