/*






  logic  pc_3gpp_enc_beh__iclk     ;
  logic  pc_3gpp_enc_beh__ireset   ;
  logic  pc_3gpp_enc_beh__iclkena  ;
  logic  pc_3gpp_enc_beh__isop     ;
  logic  pc_3gpp_enc_beh__ival     ;
  logic  pc_3gpp_enc_beh__ieop     ;
  logic  pc_3gpp_enc_beh__idat     ;
  logic  pc_3gpp_enc_beh__ordy     ;
  logic  pc_3gpp_enc_beh__osop     ;
  logic  pc_3gpp_enc_beh__oval     ;
  logic  pc_3gpp_enc_beh__oeop     ;
  logic  pc_3gpp_enc_beh__odat     ;



  pc_3gpp_enc_beh
  pc_3gpp_enc_beh
  (
    .iclk    ( pc_3gpp_enc_beh__iclk    ) ,
    .ireset  ( pc_3gpp_enc_beh__ireset  ) ,
    .iclkena ( pc_3gpp_enc_beh__iclkena ) ,
    .isop    ( pc_3gpp_enc_beh__isop    ) ,
    .ival    ( pc_3gpp_enc_beh__ival    ) ,
    .ieop    ( pc_3gpp_enc_beh__ieop    ) ,
    .idat    ( pc_3gpp_enc_beh__idat    ) ,
    .ordy    ( pc_3gpp_enc_beh__ordy    ) ,
    .osop    ( pc_3gpp_enc_beh__osop    ) ,
    .oval    ( pc_3gpp_enc_beh__oval    ) ,
    .oeop    ( pc_3gpp_enc_beh__oeop    ) ,
    .odat    ( pc_3gpp_enc_beh__odat    )
  );


  assign pc_3gpp_enc_beh__iclk    = '0 ;
  assign pc_3gpp_enc_beh__ireset  = '0 ;
  assign pc_3gpp_enc_beh__iclkena = '0 ;
  assign pc_3gpp_enc_beh__isop    = '0 ;
  assign pc_3gpp_enc_beh__ival    = '0 ;
  assign pc_3gpp_enc_beh__ieop    = '0 ;
  assign pc_3gpp_enc_beh__idat    = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_sc_beh.sv
// Description   : PC 3GPP {1024, 512} encoder without interleaving and with optional CRC5 encoder
//                 recursive encoder behaviour model look like RTL
//

`include "define.vh"

module pc_3gpp_enc_opt_beh2rtl
#(
  parameter int pN_MAX    =     1024 ,
  parameter int pDATA_N   = pN_MAX/2 ,
  parameter bit pUSE_CRC  =        0 ,
  parameter bit pCMD_LOG  =        0
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat    ,
  ordy    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk          ;
  input  logic  ireset        ;
  input  logic  iclkena       ;
  //
  input  logic  isop          ;
  input  logic  ival          ;
  input  logic  ieop          ;
  input  logic  idat          ;
  output logic  ordy          ;
  //
  output logic  osop          ;
  output logic  oval          ;
  output logic  oeop          ;
  output logic  odat          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cNLOG2 = clogb2(pN_MAX);

  typedef bit datN_t [pN_MAX];

  typedef bit [cNLOG2-1 : 0] addr_t;

  `include "../../pc_3gpp/pc_3gpp_ts_38_212_tab.svh"

  localparam int info_bits_16_addr_tab [16] = '{
    15, 14, 13, 11, 7, 12, 10, 9, 6, 5, 3, 8, 4, 2, 1, 0
  };

  localparam int info_bits_32_addr_tab [32] = '{
    31, 30, 29, 27, 23, 15, 28, 26, 25, 22, 21, 14, 19, 13, 11, 24, 20, 7, 18, 12, 17, 10, 9, 6, 5, 16, 3, 8, 4, 2, 1, 0
  };

  localparam int cUSED_N_MAX = pN_MAX/8;

  logic [7 : 0] inRam   [cUSED_N_MAX];

  logic [7 : 0] b_sc    [cUSED_N_MAX][2];

  bit   [7 : 0] outRam  [cUSED_N_MAX];

  addr_t      addr;
  bit [4 : 0] crc;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    //
    int taddr;
    //
    datN_t info_bits_padded;
    datN_t tmp_bits;
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
          info_bits_padded = '{default : 0};
          addr = 0;
          crc  = 0;
        end
        //
        case (pN_MAX)
          16      : info_bits_padded[info_bits_16_addr_tab[addr++]] = idat;
          32      : info_bits_padded[info_bits_32_addr_tab[addr++]] = idat;
          default : info_bits_padded[bits_addr_tab[addr++]]  = idat;
        endcase
        crc = get_crc(crc, idat);
        //
        if (ieop) begin
          ordy <= 1'b0;
          if (pUSE_CRC) begin
            for (int i = 0; i < 5; i++) begin
              case (pN_MAX)
                16      : info_bits_padded[info_bits_16_addr_tab[addr++]] = crc[i];
                32      : info_bits_padded[info_bits_32_addr_tab[addr++]] = crc[i];
                default : info_bits_padded[bits_addr_tab[addr++]]         = crc[i];
              endcase
            end
          end

          // do rtl encode
          for (int i = 0; i < pN_MAX; i++) begin
            taddr = reverse_bit(i, cNLOG2);
//          inRam[i/8][i % 8] = info_bits_padded[taddr];
            inRam[taddr/8][taddr % 8] = info_bits_padded[i];
          end
          do_ns_Rencode(cNLOG2);
          //
          for (int i = 0; i < pN_MAX; i++) begin
            tmp_bits[i] = outRam[i/8][i % 8];
          end
          //
          @(posedge iclk);
          //
          for (int i = 0; i < pN_MAX; i++) begin
            oval <= 1'b1;
            osop <= (i == 0);
            oeop <= (i == pN_MAX-1);
            odat <= tmp_bits[i];
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
  // classic behaviour encoder
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
  // recursive 8bit encoder
  //------------------------------------------------------------------------------------------------------

  logic [7 : 0] m_rb_sc [pN_MAX/8][2];
  bit   [7 : 0] m_routB [pN_MAX/8];

  int cLAMBDA_OFFSET [8] = '{128, 64, 32, 16, 8, 4, 2, 1};

  function automatic int get_bi_sc (input int lambda, beta, m);
//  get_bi_sc = beta + (2**(m-lambda))/8;
    get_bi_sc = beta + cLAMBDA_OFFSET[lambda];
  endfunction

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

      bit2code  = inRam[phi];

      codedb    = do_ns_encode_8x8(bit2code);

      b_sc[1][phi[0]] = codedb;

      if (pCMD_LOG)
        $display("do 8x8 code. phi %0d", phi);

      // coder tree up to 2^10

//    if (phi[0]) UpdateB(m-3, phi,    m); else continue;  // comb8
//    if (phi[1]) UpdateB(m-4, phi/2,  m); else continue;  // comb16
//    if (phi[2]) UpdateB(m-5, phi/4,  m); else continue;  // comb32
//    if (phi[3]) UpdateB(m-6, phi/8,  m); else continue;  // comb64
//    if (phi[4]) UpdateB(m-7, phi/16, m); else continue;  // comb128
//    if (phi[5]) UpdateB(m-8, phi/32, m); else continue;  // comb256
//    if (phi[6]) UpdateB(m-9, phi/64, m); else continue;  // comb512

      if (phi[0]) UpdateB(m-3, phi[1], m); else continue;  // comb8
      if (phi[1]) UpdateB(m-4, phi[2], m); else continue;  // comb16
      if (phi[2]) UpdateB(m-5, phi[3], m); else continue;  // comb32
      if (phi[3]) UpdateB(m-6, phi[4], m); else continue;  // comb64
      if (phi[4]) UpdateB(m-7, phi[5], m); else continue;  // comb128
      if (phi[5]) UpdateB(m-8, phi[6], m); else continue;  // comb256
      if (phi[6]) UpdateB(m-9, phi[7], m); else continue;  // comb512
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
  function automatic void UpdateB (input int lambda, phi, m);
    int waddr;
    int raddr;
    int psi;
    int n;
    bit [7 : 0] codedb;
    bit [7 : 0] bitL, bitR;
  begin
    //
//  psi = phi/2;
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
      if (pCMD_LOG) begin
        if (beta == 0) begin
          if (lambda == m-3) begin
            $display("Comb%0d layer %0d phi %0d:: %0d times", n, lambda, phi, n/4);
          end
          else begin
            $display("Comb%0d layer %0d:: %0d times", n, lambda, n/4);
          end
        end
      end
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // address bit reverse function
  //------------------------------------------------------------------------------------------------------

  function addr_t reverse_bit (input addr_t addr, int used_nlog2 = cNLOG2);
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
