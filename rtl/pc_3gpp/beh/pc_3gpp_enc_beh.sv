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

//------------------------------------------------------------------------------------------------------
// PC 3GPP {1024, 512} encoder without interleaving and with optional CRC5 encoder
//------------------------------------------------------------------------------------------------------

`include "define.vh"

module pc_3gpp_enc_beh
#(
  parameter int pN_MAX    =     1024 ,
  parameter int pDATA_N   = pN_MAX/2 ,
  parameter bit pUSE_CRC  =        0
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

  addr_t addr;

  bit info_bits_padded [pN_MAX];

  bit [4 : 0] crc;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    //
    bit tmp_bits [pN_MAX];
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
//        $display("data to code %p", info_bits_padded);
          tmp_bits = info_bits_padded;
          // do encode
          tmp_bits = do_ns_encode(tmp_bits, cNLOG2);
          //
//        $display("coded data %p", tmp_bits);
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
