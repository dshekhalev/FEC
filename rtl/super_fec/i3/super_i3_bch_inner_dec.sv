/*



  localparam int pERR_W = 8;



  logic                super_i3_bch_inner_dec__iclk     ;
  logic                super_i3_bch_inner_dec__ireset   ;
  logic                super_i3_bch_inner_dec__iclkena  ;
  //
  logic                super_i3_bch_inner_dec__ival     ;
  logic                super_i3_bch_inner_dec__isop     ;
  logic      [127 : 0] super_i3_bch_inner_dec__idat     ;
  //
  logic                super_i3_bch_inner_dec__oval     ;
  logic                super_i3_bch_inner_dec__osop     ;
  logic                super_i3_bch_inner_dec__oeop     ;
  logic      [127 : 0] super_i3_bch_inner_dec__odat     ;
  //
  logic [pERR_W-1 : 0] super_i3_bch_inner_dec__odecerr  ;



  super_i3_bch_inner_dec
  #(
    .pERR_W ( pERR_W )
  )
  super_i3_bch_inner_dec
  (
    .iclk     ( super_i3_bch_inner_dec__iclk     ) ,
    .ireset   ( super_i3_bch_inner_dec__ireset   ) ,
    .iclkena  ( super_i3_bch_inner_dec__iclkena  ) ,
    //
    .ival     ( super_i3_bch_inner_dec__ival     ) ,
    .isop     ( super_i3_bch_inner_dec__isop     ) ,
    .idat     ( super_i3_bch_inner_dec__idat     ) ,
    //
    .oval     ( super_i3_bch_inner_dec__oval     ) ,
    .osop     ( super_i3_bch_inner_dec__osop     ) ,
    .odat     ( super_i3_bch_inner_dec__odat     ) ,
    //
    .odecerr  ( super_i3_bch_inner_dec__odecerr  )
  );


  assign super_i3_bch_inner_dec__iclk    = '0 ;
  assign super_i3_bch_inner_dec__ireset  = '0 ;
  assign super_i3_bch_inner_dec__iclkena = '0 ;
  assign super_i3_bch_inner_dec__ival    = '0 ;
  assign super_i3_bch_inner_dec__isop    = '0 ;
  assign super_i3_bch_inner_dec__idat    = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_bch_inner_dec.sv
// Description   : I.3 outer BCH (2040,1930) decoder array x16 with 8 bit data interface
//                 decoder don't use any correction if frame decfail occured
//

module super_i3_bch_inner_dec
#(
  parameter int pERR_W = 8
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  ival     ,
  isop     ,
  idat     ,
  //
  oval     ,
  osop     ,
  oeop     ,
  odat     ,
  //
  odecerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                ival    ;
  input  logic                isop    ;
  input  logic      [127 : 0] idat    ;
  //
  output logic                oval    ;
  output logic                osop    ;
  output logic                oeop    ;
  output logic      [127 : 0] odat    ;
  //
  output logic [pERR_W-1 : 0] odecerr ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "super_i3_bch_inner_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // syndrome
  ram_addr_t             syndrome_count__oram_waddr                        ;
  logic                  syndrome_count__oram_wptr                         ;
  dat_t                  syndrome_count__oram_wdat     [cDEC_NUM]          ;
  logic                  syndrome_count__oram_write                        ;
  //
  logic                  syndrome_count__osyndrome_val                     ;
  logic                  syndrome_count__osyndrome_ptr                     ;
  gf_dat_t               syndrome_count__osyndrome     [cDEC_NUM][1 : cT2] ;

  // in buffer
  logic                  in_buffer__iwrite  ;
  ram_addr_t             in_buffer__iwaddr  ;
  logic                  in_buffer__iwptr   ;
  ram_dat_t              in_buffer__iwdata  ;
  //
  logic                  in_buffer__iread   ;
  ram_addr_t             in_buffer__iraddr  ;
  logic                  in_buffer__irptr   ;
  ram_dat_t              in_buffer__ordata  ;

  // berlekamp
  logic                  berlekamp__isyndrome_val      [cDEC_NUM]          ;
  logic          [1 : 0] berlekamp__isyndrome_ptr      [cDEC_NUM]          ;
  gf_dat_t               berlekamp__isyndrome          [cDEC_NUM][1 : cT2] ;
  //
  logic                  berlekamp__oloc_poly_val      [cDEC_NUM]          ;
  gf_dat_t               berlekamp__oloc_poly          [cDEC_NUM][0 : cT]  ;
  logic          [1 : 0] berlekamp__oloc_poly_ptr      [cDEC_NUM]          ;
  logic                  berlekamp__oloc_decfail       [cDEC_NUM]          ;

  // chieny search
  logic                  chieny_search__iloc_poly_val                    ;
  logic                  chieny_search__iloc_poly_ptr                    ;
  gf_dat_t               chieny_search__iloc_poly     [cDEC_NUM][0 : cT] ;
  //
  dat_t                  chieny_search__iram_rdat     [cDEC_NUM]         ;
  ram_addr_t             chieny_search__oram_raddr                       ;
  logic                  chieny_search__oram_rptr                        ;
  logic                  chieny_search__oram_read                        ;
  //
  logic                  chieny_search__owrite                           ;
  ram_addr_t             chieny_search__owaddr                           ;
  logic                  chieny_search__owptr                            ;
  dat_t                  chieny_search__owdat         [cDEC_NUM]         ;
  dat_t                  chieny_search__owdat_nfixed  [cDEC_NUM]         ;
  //
  logic                  chieny_search__odone                            ;
  logic                  chieny_search__odone_ptr                        ;
  gf_dat_t               chieny_search__obiterr       [cDEC_NUM]         ;
  logic [cDEC_NUM-1 : 0] chieny_search__odecfail                         ;

  // decision buffers
  logic                  dat_buffer__iwrite        ;
  ram_addr_t             dat_buffer__iwaddr        ;
  logic                  dat_buffer__iwptr         ;
  ram_dat_t              dat_buffer__iwdata        ;
  ram_dat_t              dat_nfixed_buffer__iwdata ;

  //
  logic                  dat_buffer__iread         ;
  ram_addr_t             dat_buffer__iraddr        ;
  logic                  dat_buffer__irptr         ;
  ram_dat_t              dat_buffer__ordata        ;
  ram_dat_t              dat_nfixed_buffer__ordata ;

  //
  // decision
  logic                  decision__idat_val                    ;
  logic                  decision__idat_ptr                    ;
  logic [cDEC_NUM-1 : 0] decision__idat_decfail                ;
  //
  dat_t                  decision__iram_rdat        [cDEC_NUM] ;
  dat_t                  decision__iram_rdat_nfixed [cDEC_NUM] ;
  ram_addr_t             decision__oram_raddr                  ;
  logic                  decision__oram_rptr                   ;
  logic                  decision__oram_read                   ;

  //------------------------------------------------------------------------------------------------------
  // demapper & syndrome counter
  //------------------------------------------------------------------------------------------------------

  super_i3_bch_inner_syndrome_count
  syndrome_count
  (
    .iclk          ( iclk                          ) ,
    .ireset        ( ireset                        ) ,
    .iclkena       ( iclkena                       ) ,
    //
    .ival          ( ival                          ) ,
    .isop          ( isop                          ) ,
    .idat          ( idat                          ) ,
    //
    .oram_waddr    ( syndrome_count__oram_waddr    ) ,
    .oram_wptr     ( syndrome_count__oram_wptr     ) ,
    .oram_wdat     ( syndrome_count__oram_wdat     ) ,
    .oram_write    ( syndrome_count__oram_write    ) ,
    //
    .osyndrome_val ( syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( syndrome_count__osyndrome     )
  );

  //------------------------------------------------------------------------------------------------------
  // save data for chieny/decision. 2D is enougth
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( cRAM_ADDR_W ) ,
    .pDATA_W ( cRAM_DAT_W  ) ,
    .pBNUM_W ( 1           ) ,
    .pPIPE   ( 1           )    // pipeline register
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

  assign in_buffer__iwrite = syndrome_count__oram_write;
  assign in_buffer__iwptr  = syndrome_count__oram_wptr;
  assign in_buffer__iwaddr = syndrome_count__oram_waddr;

  // write in native format
  always_comb begin
    for (int i = 0; i < cDEC_NUM; i++) begin
      in_buffer__iwdata[i*cDAT_W +: cDAT_W] = syndrome_count__oram_wdat[i];
    end
  end

  assign in_buffer__iread  = chieny_search__oram_read;
  assign in_buffer__irptr  = chieny_search__oram_rptr;
  assign in_buffer__iraddr = chieny_search__oram_raddr;

  //------------------------------------------------------------------------------------------------------
  // each "decoder" use own berlekamp unit
  // t == 10 (bm time = 10*(2*10 + 1) + 1 = 211 tick < 255 tick can use slowest
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < cDEC_NUM; g++) begin : bm_inst_gen
      bch_berlekamp_ribm_t_by_t
      #(
        .m      ( cM      ) ,
        .d      ( cD      ) ,
        .k_max  ( cK_MAX  ) ,
        //
        .n      ( cN      ) ,
        //
        .irrpol ( cIRRPOL )
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
        .oloc_poly_ptr ( berlekamp__oloc_poly_ptr [g] ) ,
        .oloc_decfail  ( berlekamp__oloc_decfail  [g] )
      );

      assign berlekamp__isyndrome_val [g] = syndrome_count__osyndrome_val;
      assign berlekamp__isyndrome_ptr [g] = {1'b0, syndrome_count__osyndrome_ptr};
      assign berlekamp__isyndrome     [g] = syndrome_count__osyndrome [g];
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // chieny search
  //------------------------------------------------------------------------------------------------------

  super_i3_bch_inner_chieny_search
  chieny_search
  (
    .iclk          ( iclk                         ) ,
    .ireset        ( ireset                       ) ,
    .iclkena       ( iclkena                      ) ,
    //
    .iloc_poly_val ( chieny_search__iloc_poly_val ) ,
    .iloc_poly     ( chieny_search__iloc_poly     ) ,
    .iloc_poly_ptr ( chieny_search__iloc_poly_ptr ) ,
    //
    .iram_rdat     ( chieny_search__iram_rdat     ) ,
    .oram_raddr    ( chieny_search__oram_raddr    ) ,
    .oram_rptr     ( chieny_search__oram_rptr     ) ,
    .oram_read     ( chieny_search__oram_read     ) ,
    //
    .owrite        ( chieny_search__owrite        ) ,
    .owaddr        ( chieny_search__owaddr        ) ,
    .owptr         ( chieny_search__owptr         ) ,
    .owdat         ( chieny_search__owdat         ) ,
    .owdat_nfixed  ( chieny_search__owdat_nfixed  ) ,
    //
    .odone         ( chieny_search__odone         ) ,
    .odone_ptr     ( chieny_search__odone_ptr     ) ,
    .obiterr       ( chieny_search__obiterr       ) ,
    .odecfail      ( chieny_search__odecfail      )
  );

  assign chieny_search__iloc_poly_val = berlekamp__oloc_poly_val[0] ;
  assign chieny_search__iloc_poly_ptr = berlekamp__oloc_poly_ptr[0][0] ;
  assign chieny_search__iloc_poly     = berlekamp__oloc_poly ;

  // read in native format
  always_comb begin
    for (int i = 0; i < cDEC_NUM; i++) begin
      chieny_search__iram_rdat[i] = in_buffer__ordata[i*cDAT_W +: cDAT_W];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decision buffers (native formats)
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( cRAM_ADDR_W ) ,
    .pDATA_W ( cRAM_DAT_W  ) ,
    .pBNUM_W ( 1           ) ,
    .pPIPE   ( 1           )    // pipeline register
  )
  dat_buffer
  (
    .iclk    ( iclk               ) ,
    .ireset  ( ireset             ) ,
    .iclkena ( iclkena            ) ,
    //
    .iwrite  ( dat_buffer__iwrite ) ,
    .iwptr   ( dat_buffer__iwptr  ) ,
    .iwaddr  ( dat_buffer__iwaddr ) ,
    .iwdata  ( dat_buffer__iwdata ) ,
    //
    .iread   ( dat_buffer__iread  ) ,
    .irptr   ( dat_buffer__irptr  ) ,
    .iraddr  ( dat_buffer__iraddr ) ,
    .ordata  ( dat_buffer__ordata )
  );

  bch_buffer
  #(
    .pADDR_W ( cRAM_ADDR_W ) ,
    .pDATA_W ( cRAM_DAT_W  ) ,
    .pBNUM_W ( 1           ) ,
    .pPIPE   ( 1           )    // pipeline register
  )
  dat_nfixd_buffer
  (
    .iclk    ( iclk                      ) ,
    .ireset  ( ireset                    ) ,
    .iclkena ( iclkena                   ) ,
    //
    .iwrite  ( dat_buffer__iwrite        ) ,
    .iwptr   ( dat_buffer__iwptr         ) ,
    .iwaddr  ( dat_buffer__iwaddr        ) ,
    .iwdata  ( dat_nfixed_buffer__iwdata ) ,
    //
    .iread   ( dat_buffer__iread         ) ,
    .irptr   ( dat_buffer__irptr         ) ,
    .iraddr  ( dat_buffer__iraddr        ) ,
    .ordata  ( dat_nfixed_buffer__ordata )
  );

  assign dat_buffer__iwrite = chieny_search__owrite;
  assign dat_buffer__iwptr  = chieny_search__owptr;
  assign dat_buffer__iwaddr = chieny_search__owaddr;

  always_comb begin
    for (int i = 0; i < cDEC_NUM; i++) begin
      dat_buffer__iwdata       [i*cDAT_W +: cDAT_W] = chieny_search__owdat       [i];
      dat_nfixed_buffer__iwdata[i*cDAT_W +: cDAT_W] = chieny_search__owdat_nfixed[i];
    end
  end

  assign dat_buffer__iread  = decision__oram_read;
  assign dat_buffer__irptr  = decision__oram_rptr;
  assign dat_buffer__iraddr = decision__oram_raddr;

  //------------------------------------------------------------------------------------------------------
  // decision
  //------------------------------------------------------------------------------------------------------

  super_i3_bch_inner_decision
  #(
    .pERR_W ( pERR_W )
  )
  decision
  (
    .iclk             ( iclk                       ) ,
    .ireset           ( ireset                     ) ,
    .iclkena          ( iclkena                    ) ,
    //
    .idat_val         ( decision__idat_val         ) ,
    .idat_ptr         ( decision__idat_ptr         ) ,
    .idat_decfail     ( decision__idat_decfail     ) ,
    //
    .iram_rdat        ( decision__iram_rdat        ) ,
    .iram_rdat_nfixed ( decision__iram_rdat_nfixed ) ,
    .oram_raddr       ( decision__oram_raddr       ) ,
    .oram_rptr        ( decision__oram_rptr        ) ,
    .oram_read        ( decision__oram_read        ) ,
    //
    .oval             ( oval                       ) ,
    .osop             ( osop                       ) ,
    .oeop             ( oeop                       ) ,
    .odat             ( odat                       ) ,
    //
    .odecerr          ( odecerr                    )
  );

  assign decision__idat_val      = chieny_search__odone;
  assign decision__idat_ptr      = chieny_search__odone_ptr;
  assign decision__idat_decfail  = chieny_search__odecfail;

  always_comb begin
    for (int i = 0; i < cDEC_NUM; i++) begin
      decision__iram_rdat       [i] = dat_buffer__ordata        [i*cDAT_W +: cDAT_W];
      decision__iram_rdat_nfixed[i] = dat_nfixed_buffer__ordata [i*cDAT_W +: cDAT_W];
    end
  end

endmodule
