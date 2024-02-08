/*






  logic           g709_dec__iclk    ;
  logic           g709_dec__ireset  ;
  logic           g709_dec__iclkena ;
  //
  logic           g709_dec__ival    ;
  logic           g709_dec__isop    ;
  logic [127 : 0] g709_dec__idat    ;
  //
  logic           g709_dec__oval    ;
  logic           g709_dec__osop    ;
  logic [127 : 0] g709_dec__odat    ;
  //
  logic           g709_dec__odecval ;
  logic   [4 : 0] g709_dec__odecerr ;
  logic   [7 : 0] g709_dec__osymerr ;
  logic  [10 : 0] g709_dec__obiterr ;



  g709_dec
  g709_dec
  (
    .iclk    ( g709_dec__iclk    ) ,
    .ireset  ( g709_dec__ireset  ) ,
    .iclkena ( g709_dec__iclkena ) ,
    //
    .ival    ( g709_dec__ival    ) ,
    .isop    ( g709_dec__isop    ) ,
    .idat    ( g709_dec__idat    ) ,
    //
    .oval    ( g709_dec__oval    ) ,
    .osop    ( g709_dec__osop    ) ,
    .odat    ( g709_dec__odat    ) ,
    //
    .odecval ( g709_dec__odecval ) ,
    .odecerr ( g709_dec__odecerr ) ,
    .osymerr ( g709_dec__osymerr ) ,
    .obiterr ( g709_dec__obiterr )
  );


  assign g709_dec__iclk    = '0 ;
  assign g709_dec__ireset  = '0 ;
  assign g709_dec__iclkena = '0 ;
  assign g709_dec__ival    = '0 ;
  assign g709_dec__isop    = '0 ;
  assign g709_dec__idat    = '0 ;



*/

//
// Project       : fec (G.709)
// Author        : Shekhalev Denis (des00)
// Workfile      : g709_dec.sv
// Description   : 16-byte interleaved RS(255,239) decoder top level
//                 This decoder don't use output code selection. If RS decfail occured wrong data go to ouput
//

module g709_dec
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  idat    ,
  //
  oval    ,
  osop    ,
  odat    ,
  //
  odecval ,
  odecerr ,
  osymerr ,
  obiterr
);

  `include "g709_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk    ;
  input  logic           ireset  ;
  input  logic           iclkena ;
  //
  input  logic           ival    ;
  input  logic           isop    ;
  input  logic [127 : 0] idat    ;
  //
  output logic           oval    ;
  output logic           osop    ;
  output logic [127 : 0] odat    ;
  //
  output logic           odecval ;
  output logic   [4 : 0] odecerr ;  // 16 max
  output logic   [7 : 0] osymerr ;  // 128 max
  output logic  [10 : 0] obiterr ;  // 1024 max

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_W = 8;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  struct packed {
    logic                eop;
    logic [cCNT_W-1 : 0] value;
  } cnt;

  // syndrome
  logic       syndrome_count__isop          [16]             ;
  logic       syndrome_count__ival          [16]             ;
  logic       syndrome_count__ieop          [16]             ;
  dat_t       syndrome_count__idat          [16]             ;
  //
  dat_t       syndrome_count__oram_addr     [16]             ;
  ptr_t       syndrome_count__oram_ptr      [16]             ;
  dat_t       syndrome_count__oram_data     [16]             ;
  logic       syndrome_count__oram_write    [16]             ;
  //
  logic       syndrome_count__osyndrome_val [16]             ;
  ptr_t       syndrome_count__osyndrome_ptr [16]             ;
  dat_t       syndrome_count__osyndrome     [16][1 : cCHECK] ;

  // in buffer
  logic       in_buffer__iwrite  ;
  ram_addr_t  in_buffer__iwaddr  ;
  logic       in_buffer__iwptr   ;
  ram_dat_t   in_buffer__iwdata  ;
  //
  logic       in_buffer__iread   ;
  ram_addr_t  in_buffer__iraddr  ;
  logic       in_buffer__irptr   ;
  ram_dat_t   in_buffer__ordata  ;

  // berlekamp
  logic       berlekamp__isyndrome_val [16]             ;
  ptr_t       berlekamp__isyndrome_ptr [16]             ;
  dat_t       berlekamp__isyndrome     [16][1 : cCHECK] ;
  //
  logic       berlekamp__oloc_poly_val [16]             ;
  dat_t       berlekamp__oloc_poly     [16] [0 : cERRS] ;
  dat_t       berlekamp__oomega_poly   [16] [1 : cERRS] ;
  ptr_t       berlekamp__oloc_poly_ptr [16]             ;
  logic       berlekamp__oloc_decfail  [16]             ;

  // chieny search
  logic       chieny_search__iloc_poly_val[16]             ;
  dat_t       chieny_search__iloc_poly    [16] [0 : cERRS] ;
  dat_t       chieny_search__iomega_poly  [16] [1 : cERRS] ;
  logic       chieny_search__iloc_decfail [16]             ;
  ptr_t       chieny_search__iloc_poly_ptr[16]             ;
  //
  dat_t       chieny_search__iram_data    [16]             ;
  dat_t       chieny_search__oram_addr    [16]             ;
  ptr_t       chieny_search__oram_ptr     [16]             ;
  logic       chieny_search__oram_read    [16]             ;
  //
  logic       chieny_search__osop         [16]             ;
  logic       chieny_search__oval         [16]             ;
  logic       chieny_search__oeop         [16]             ;
  logic       chieny_search__oeof         [16]             ;
  dat_t       chieny_search__odat         [16]             ;
  //
  logic       chieny_search__odecfail     [16]             ;
  symerr_t    chieny_search__onum_err_sym [16]             ;
  biterr_t    chieny_search__onum_err_bit [16]             ;

  //------------------------------------------------------------------------------------------------------
  // input framer
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (isop) begin
          cnt <= 1'b1; // look forward
        end
        else begin
          cnt.value <= cnt.eop ? '0 : (cnt.value + 1'b1);
          cnt.eop   <= (cnt.value == cN-2);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // syndrome counter
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < 16; g++) begin : syndrome_inst_gen
      rs_syndrome_count
      #(
        .n         ( cN         ) ,
        .check     ( cCHECK     ) ,
        .m         ( cM         ) ,
        .irrpol    ( cIRRPOL    ) ,
        .genstart  ( cGENSTART  ) ,
        .rootspace ( cROOTSPACE )
      )
      syndrome_count
      (
        .iclk          ( iclk                              ) ,
        .iclkena       ( iclkena                           ) ,
        .ireset        ( ireset                            ) ,
        //
        .isop          ( syndrome_count__isop          [g] ) ,
        .ival          ( syndrome_count__ival          [g] ) ,
        .ieop          ( syndrome_count__ieop          [g] ) ,
        .idat          ( syndrome_count__idat          [g] ) ,
        //
        .oram_addr     ( syndrome_count__oram_addr     [g] ) ,
        .oram_ptr      ( syndrome_count__oram_ptr      [g] ) ,
        .oram_data     ( syndrome_count__oram_data     [g] ) ,
        .oram_write    ( syndrome_count__oram_write    [g] ) ,
        //
        .osyndrome_val ( syndrome_count__osyndrome_val [g] ) ,
        .osyndrome_ptr ( syndrome_count__osyndrome_ptr [g] ) ,
        .osyndrome     ( syndrome_count__osyndrome     [g] )
      );

      assign syndrome_count__isop [g] = isop            ;
      assign syndrome_count__ival [g] = ival            ;
      assign syndrome_count__ieop [g] = cnt.eop & !isop ;
      assign syndrome_count__idat [g] = idat[g*8 +: 8]  ;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // save data for chieny/decision. 2D is enougth
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( $bits(ram_addr_t) ) ,
    .pDATA_W ( $bits(ram_dat_t)  ) ,
    .pBNUM_W ( 1                 ) ,  // 4D bufer
    .pPIPE   ( 1                 )
  )
  in_buffer
  (
    .iclk    ( iclk              ) ,
    .ireset  ( ireset            ) ,
    .iclkena ( iclkena           ) ,
    //
    .iwrite  ( in_buffer__iwrite ) ,
    .iwptr   ( in_buffer__iwptr  ) ,
    .iwaddr  ( in_buffer__iwaddr ) ,
    .iwdata  ( in_buffer__iwdata ) ,
    //
    .iread   ( in_buffer__iread  ) ,
    .iraddr  ( in_buffer__iraddr ) ,
    .irptr   ( in_buffer__irptr  ) ,
    .ordata  ( in_buffer__ordata )
  );

  always_comb begin
    in_buffer__iwrite = syndrome_count__oram_write[0];
    in_buffer__iwptr  = syndrome_count__oram_ptr  [0][0];
    in_buffer__iwaddr = syndrome_count__oram_addr [0];
    for (int i = 0; i < 16; i++) begin
      in_buffer__iwdata[i*8 +: 8] = syndrome_count__oram_data[i];
    end
  end

  assign in_buffer__iread  = chieny_search__oram_read [0];
  assign in_buffer__iraddr = chieny_search__oram_addr [0];
  assign in_buffer__irptr  = chieny_search__oram_ptr  [0][0];

  //------------------------------------------------------------------------------------------------------
  // berlecamp
  // check == 16 (bm time = 6*16 = 96 tick < 255 tick can use slowest
  //------------------------------------------------------------------------------------------------------

  generate
    for (g = 0; g < 16; g++) begin : bm_inst_gen
      rs_berlekamp_ribm_6check
      #(
        .n        ( cN         ) ,
        .check    ( cCHECK     ) ,
        .m        ( cM         ) ,
        .irrpol   ( cIRRPOL    ) ,
        .genstart ( cGENSTART  )
      )
      berlekamp
      (
        .iclk          ( iclk                         ) ,
        .ireset        ( ireset                       ) ,
        .iclkena       ( iclkena                      ) ,
        //
        .isyndrome_val ( berlekamp__isyndrome_val [g] ) ,
        .isyndrome_ptr ( berlekamp__isyndrome_ptr [g] ) ,
        .isyndrome     ( berlekamp__isyndrome     [g] ) ,
        //
        .oloc_poly_val ( berlekamp__oloc_poly_val [g] ) ,
        .oloc_poly     ( berlekamp__oloc_poly     [g] ) ,
        .oomega_poly   ( berlekamp__oomega_poly   [g] ) ,
        .oloc_poly_ptr ( berlekamp__oloc_poly_ptr [g] ) ,
        .oloc_decfail  ( berlekamp__oloc_decfail  [g] )
      );

      assign berlekamp__isyndrome_val [g] = syndrome_count__osyndrome_val [0];
      assign berlekamp__isyndrome_ptr [g] = syndrome_count__osyndrome_ptr [0];
      assign berlekamp__isyndrome     [g] = syndrome_count__osyndrome     [g];

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // chieny search
  //------------------------------------------------------------------------------------------------------

  generate
    for (g = 0; g < 16; g++) begin : chieny_inst_gen
      rs_chieny_search
      #(
        .n          ( cN              ) ,
        .check      ( cCHECK          ) ,
        .m          ( cM              ) ,
        .irrpol     ( cIRRPOL         ) ,
        .genstart   ( cGENSTART       ) ,
        .rootspace  ( cROOTSPACE      ) ,
        //
        .sym_err_w  ( $bits(symerr_t) ) ,
        .bit_err_w  ( $bits(biterr_t) ) ,
        .pRIBM_MODE ( 1               )
      )
      chieny
      (
        .iclk          ( iclk                            ) ,
        .iclkena       ( iclkena                         ) ,
        .ireset        ( ireset                          ) ,
        //
        .iloc_poly_val ( berlekamp__oloc_poly_val    [g] ) ,
        .iloc_poly     ( berlekamp__oloc_poly        [g] ) ,
        .iomega_poly   ( berlekamp__oomega_poly      [g] ) ,
        .iloc_poly_ptr ( berlekamp__oloc_poly_ptr    [g] ) ,
        .iloc_decfail  ( berlekamp__oloc_decfail     [g] ) ,
        //
        .iram_data     ( chieny_search__iram_data    [g] ) ,
        .oram_addr     ( chieny_search__oram_addr    [g] ) ,
        .oram_ptr      ( chieny_search__oram_ptr     [g] ) ,
        .oram_read     ( chieny_search__oram_read    [g] ) ,
        //
        .osop          ( chieny_search__osop         [g] ) ,
        .oval          ( chieny_search__oval         [g] ) ,
        .oeop          ( chieny_search__oeop         [g] ) ,
        .oeof          ( chieny_search__oeof         [g] ) ,
        .odat          ( chieny_search__odat         [g] ) ,
        //
        .odecfail      ( chieny_search__odecfail     [g] ) ,
        .onum_err_sym  ( chieny_search__onum_err_sym [g] ) ,
        .onum_err_bit  ( chieny_search__onum_err_bit [g] )
      );

      assign chieny_search__iloc_poly_val [g] = berlekamp__oloc_poly_val [0];
      assign chieny_search__iloc_poly_ptr [g] = berlekamp__oloc_poly_ptr [0];
      assign chieny_search__iloc_poly     [g] = berlekamp__oloc_poly     [g];
      assign chieny_search__iomega_poly   [g] = berlekamp__oomega_poly   [g];
      assign chieny_search__iloc_decfail  [g] = berlekamp__oloc_decfail  [g];

      assign chieny_search__iram_data     [g] = in_buffer__ordata[g*8 +: 8] ;

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    oval = chieny_search__oval[0];
    osop = chieny_search__osop[0];
    for (int i = 0; i < 16; i++) begin
      odat[i*8 +: 8] = chieny_search__odat[i];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // error counting
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      odecval <= chieny_search__oeof[0];
      odecerr <= get_decerr(chieny_search__odecfail);
      osymerr <= get_symerr(chieny_search__onum_err_sym);
      obiterr <= get_biterr(chieny_search__onum_err_bit);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  function automatic logic [4 : 0] get_decerr (input logic decfail [16]);
    get_decerr = '0;
    for (int i = 0; i < 16; i++) begin
      get_decerr += decfail[i];
    end
  endfunction

  function automatic logic [7 : 0] get_symerr (input symerr_t symerr [16]);
    get_symerr = '0;
    for (int i = 0; i < 16; i++) begin
      get_symerr += symerr[i];
    end
  endfunction

  function automatic logic [10 : 0] get_biterr (input biterr_t biterr [16]);
    get_biterr = '0;
    for (int i = 0; i < 16; i++) begin
      get_biterr += biterr[i];
    end
  endfunction

endmodule
