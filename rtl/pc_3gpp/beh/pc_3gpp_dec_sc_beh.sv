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
// Workfile      : pc_3gpp_dec_sc_beh.sv
// Description   : PC 3GPP {1024, 512} encoder without interleaving and with optional CRC5 encoder
//                 serail successive cancellation decoder behaviour model
//

`include "define.vh"

module pc_3gpp_dec_sc_beh
#(
  parameter int pLLR_W    =        4 ,
  parameter int pN_MAX    =     1024 ,
  parameter int pDATA_N   = pN_MAX/2 ,
  parameter bit pUSE_CRC  =        0 ,
  parameter bit pUSE_ROA  =        0 ,  // use reverse order addressing
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
  oerr
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
  output logic [15 : 0]       oerr    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cNLOG2 = clogb2(pN_MAX);

  localparam int cDAT_W = pLLR_W + cNLOG2;  // maximum data width

  typedef logic signed [pLLR_W-1 : 0] llr_t;

  typedef logic signed [cDAT_W-1 : 0] this_t;

  typedef bit   datN_t [pN_MAX];
  typedef llr_t llrN_t [pN_MAX];

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

  addr_t addr;

  llr_t chLLR [pN_MAX];

  bit frozen_bits [pN_MAX];
  bit coded_bits  [pN_MAX];
  bit info_bits   [pN_MAX];

  bit [4 : 0] crc;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    //
    bit tmp_bits  [pN_MAX];
    bit tmp_cbits [pN_MAX];
    //
    bit [4 : 0] crc;
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
          chLLR = '{default : 0};
          addr = 0;
        end
        //
        taddr = pUSE_ROA ? reverse_bit(addr++, cNLOG2) : addr++;
        // saturate & metric invertion
        if (&{iLLR[pLLR_W-1], ~iLLR[pLLR_W-2 : 0]}) begin // -2^(N-1)
          chLLR[taddr] = {1'b0, {(pLLR_W-2){1'b1}} ,1'b1};   // -(2^(N-1) - 1)
        end
        else begin
          chLLR[taddr] = -iLLR;
        end
        //
        if (ieop) begin
          ordy <= 1'b0;
          //
          // do decode
          tmp_bits = do_ns_decode(chLLR, cNLOG2, tmp_cbits, biterr);
          //
          repeat (10) @(posedge iclk);
          info_bits = tmp_bits;
          //
          oerr = biterr;
          crc  = 0;
          for (int i = 0; i < pDATA_N; i++) begin
            oval <= 1'b1;
            osop <= (i == 0);
            oeop <= (i == pDATA_N-1);
            //
            case (pN_MAX)
              16      : odat <= info_bits[info_bits_16_addr_tab[i]];
              32      : odat <= info_bits[info_bits_32_addr_tab[i]];
              default : odat <= info_bits[bits_addr_tab[i]];
            endcase
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
  //  frozen_bits [phi]                 - frozen bits array
  //  b_sc        [lambda][beta][phi]   - layer bit data
  //  llr_sc      [lambda][beta][phi]   - layer LLR data
  //
  //------------------------------------------------------------------------------------------------------

  logic   b_sc    [0 : cNLOG2][pN_MAX][pN_MAX];
  this_t  llr_sc  [1 : cNLOG2][pN_MAX][pN_MAX];

  this_t  ch_llr  [pN_MAX]; // channel metric

  function automatic datN_t do_ns_decode (ref llrN_t x, input int m, ref datN_t decode_cdata, output int biterr);
    int    taddr;
    datN_t hd_data;
    datN_t tmp_data;
    int    fp;
    string fname;
  begin
    frozen_bits = '{default : 1};
    case (pN_MAX)
      16      : for (int i = 0; i < pDATA_N + (pUSE_CRC*5); i++) frozen_bits[info_bits_16_addr_tab[i]] = 0;
      32      : for (int i = 0; i < pDATA_N + (pUSE_CRC*5); i++) frozen_bits[info_bits_32_addr_tab[i]] = 0;
      default : for (int i = 0; i < pDATA_N + (pUSE_CRC*5); i++) frozen_bits[bits_addr_tab[i]]  = 0;
    endcase
    //
    for (int lambda = 0; lambda <= m; lambda++) begin
      for (int beta = 0; beta < 2**m; beta++) begin
        for (int phi = 0; phi < 2**m; phi++) begin
          b_sc[lambda][beta][phi] = 1'bx;
        end
      end
    end
    //
//  $display("frozen_bits %p", frozen_bits);
//  $display("data to decode %p", x);
    //
    for (int beta = 0; beta < 2**m; beta++) begin
      hd_data[beta] = (x[beta] < 0); // metric inversion
      ch_llr[beta]  = x[beta];
    end
    //
    for (int phi = 0; phi < 2**m; phi++) begin

      recursivelyCalcP(m, phi, m);

      if (frozen_bits[phi]) begin
        b_sc[m][0][phi] = 0;
      end
      else begin
        if (llr_sc[m][0][phi] >= 0) begin
          b_sc[m][0][phi] = 0;
        end
        else begin
          b_sc[m][0][phi] = 1;
        end
      end
      //
      if ((phi % 2) == 1) begin // reverse coding
        recursivelyUpdateB(m, phi, m);
      end
//    $display("phi %0d done, llr = %0d, bit = %0b", phi, llr_sc[m][0][phi], b_sc[m][0][phi]);
    end

    if (pUSE_LOG) begin
      fname = $psprintf("bit_layer_%m.log");
      fp = $fopen(fname, "w");

      for (int lambda = 0; lambda <= m; lambda++) begin
        for (int beta = 0; beta < 2**(m-lambda); beta++) begin
          $fdisplay(fp, "bit layer %0d, %0d = %p", lambda, beta, b_sc[lambda][beta]);
        end
        $fdisplay(fp, "");
      end
      $fclose(fp);

      fname = $psprintf("llr_layer_%m.log");
      fp = $fopen(fname, "w");

      for (int lambda = 1; lambda <= m; lambda++) begin
        for (int beta = 0; beta < 2**(m-lambda); beta++) begin
          $fdisplay(fp, "LLR layer %0d, %0d = %p", lambda, beta, llr_sc[lambda][beta]);
        end
        $fdisplay(fp, "");
      end
      $fclose(fp);
    end
    //
    for (int beta = 0; beta < 2**m; beta++) begin
      decode_cdata[beta] = b_sc[0][beta][0];
    end
    //
    biterr = 0;
    for (int beta = 0; beta < 2**m; beta++) begin
      biterr += (decode_cdata[beta] ^ hd_data[beta]);
    end
    //
    // re encode to get info word
    for (int i = 0; i < 2**m; i++) begin
      taddr = pUSE_ROA ? reverse_bit(i, cNLOG2) : i;
      //
      tmp_data[i] = decode_cdata[taddr];
    end

    for (int i = 0; i < 2**m; i++) begin
      if (frozen_bits[i]) tmp_data[i] = 1'b0;
    end
    //
    do_ns_decode = do_ns_encode(tmp_data, m);
  end
  endfunction

  //
  // go througth the tree
  function automatic void recursivelyCalcP (input int lambda, phi, m);
    int psi;
    int n;
    bit u_p;
    int b_rhs0, b_rhs1;
  begin
    if (lambda == 0) return;
    //
    psi = phi/2;
    //
    if ((phi % 2) == 0) recursivelyCalcP(lambda - 1, psi, m);
    //
    n = 2**(m - lambda);
    //
    for (int beta = 0; beta < n; beta++) begin
      if (pUSE_ROA) begin
        b_rhs0 = 2*beta;
        b_rhs1 = 2*beta+1;
      end
      else begin
        b_rhs0 = beta;
        b_rhs1 = beta+n;
      end
      //
      if ((phi % 2) == 0) begin
        if (lambda == 1) begin
          llr_sc[lambda][beta][phi] = cnode(ch_llr[b_rhs0], ch_llr[b_rhs1]);
        end
        else begin
          llr_sc[lambda][beta][phi] = cnode(llr_sc[lambda-1][b_rhs0][psi], llr_sc[lambda-1][b_rhs1][psi]);
        end
      end
      else begin
        u_p = b_sc[lambda][beta][phi-1];
        //
        if (lambda == 1) begin
          llr_sc[lambda][beta][phi] = vnode(ch_llr[b_rhs0], ch_llr[b_rhs1], u_p);
        end
        else begin
          llr_sc[lambda][beta][phi] = vnode(llr_sc[lambda-1][b_rhs0][psi], llr_sc[lambda-1][b_rhs1][psi], u_p);
        end
      end
    end
  end
  endfunction

  //
  // reverse layer coding
  function automatic void recursivelyUpdateB (input int lambda, phi, m);
    int psi;
    int n;
    int b_lhs0, b_lhs1;
  begin
    if ((phi % 2) == 0) begin
      $display("Error: phi should always be odd in this function call");
      $stop;
    end
    //
    psi = phi/2;
    //
    n = 2**(m-lambda);
    //
    for (int beta = 0; beta < n; beta++) begin
      if (pUSE_ROA) begin
        b_lhs0 = 2*beta;
        b_lhs1 = 2*beta+1;
      end
      else begin
        b_lhs0 = beta;
        b_lhs1 = beta+n;
      end
      //
      b_sc[lambda-1][b_lhs0][psi] = b_sc[lambda][beta][phi-1] ^ b_sc[lambda][beta][phi];
      b_sc[lambda-1][b_lhs1][psi] = b_sc[lambda][beta][phi];
    end
    //
    if ((psi % 2) == 1) begin
      recursivelyUpdateB(lambda - 1, psi, m);
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // node functions
  //------------------------------------------------------------------------------------------------------

  function automatic this_t cnode (input this_t aL, aR);
    this_t abs_aL,  abs_aR;
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

  function automatic this_t vnode (input this_t aL, aR, bit bL);
    vnode = aR + (bL ? -aL : aL);
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
