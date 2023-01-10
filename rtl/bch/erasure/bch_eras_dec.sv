/*

  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;
  parameter     pBM_TYPE  = "ibm_2t";
  parameter bit pBM_ASYNC = 1'b0;




  logic           bch_eras_dec__iclk      ;
  logic           bch_eras_dec__iclkena   ;
  logic           bch_eras_dec__ireset    ;
  logic           bch_eras_dec__isop      ;
  logic           bch_eras_dec__ival      ;
  logic           bch_eras_dec__ieop      ;
  logic           bch_eras_dec__idat      ;
  logic           bch_eras_dec__osop      ;
  logic           bch_eras_dec__oval      ;
  logic           bch_eras_dec__oeop      ;
  logic           bch_eras_dec__oeof      ;
  logic           bch_eras_dec__odat      ;
  logic           bch_eras_dec__odecfail  ;
  logic [m-1 : 0] bch_eras_dec__obiterr   ;



  bch_eras_dec
  #(
    .m         ( m         ) ,
    .k_max     ( k_max     ) ,
    .d         ( d         ) ,
    .n         ( n         ) ,
    .irrpol    ( irrpol    ) ,
    .pBM_TYPE  ( pBM_TYPE  ) ,
    .pBM_ASYNC ( pBM_ASYNC )
  )
  bch_eras_dec
  (
    .iclk     ( bch_eras_dec__iclk     ) ,
    .iclkena  ( bch_eras_dec__iclkena  ) ,
    .ireset   ( bch_eras_dec__ireset   ) ,
    .isop     ( bch_eras_dec__isop     ) ,
    .ival     ( bch_eras_dec__ival     ) ,
    .ieop     ( bch_eras_dec__ieop     ) ,
    .idat     ( bch_eras_dec__idat     ) ,
    .osop     ( bch_eras_dec__osop     ) ,
    .oval     ( bch_eras_dec__oval     ) ,
    .oeop     ( bch_eras_dec__oeop     ) ,
    .oeof     ( bch_eras_dec__oeof     ) ,
    .odat     ( bch_eras_dec__odat     ) ,
    .odecfail ( bch_eras_dec__odecfail ) ,
    .obiterr  ( bch_eras_dec__obiterr  )
  );


  assign bch_eras_dec__iclk    = '0 ;
  assign bch_eras_dec__iclkena = '0 ;
  assign bch_eras_dec__ireset  = '0 ;
  assign bch_eras_dec__isop    = '0 ;
  assign bch_eras_dec__ival    = '0 ;
  assign bch_eras_dec__ieop    = '0 ;
  assign bch_eras_dec__idat    = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_eras_dec.sv
// Description   : bch decoder with erasure top module.
//

`include "define.vh"

module bch_eras_dec
(
  iclk     ,
  iclkena  ,
  ireset   ,
  //
  isop     ,
  ival     ,
  ieop     ,
  idat     ,
  ieras    ,
  //
  osop     ,
  oval     ,
  oeop     ,
  oeof     ,
  odat     ,
  //
  odecfail ,
  obiterr
);

  `include "bch_parameters.svh"

  parameter pBM_TYPE      = "ribm_1t";      // use maximum  performance ribm unit
//parameter pBM_TYPE      = "ribm_2t";      // use medium   performance ribm unit
//parameter pBM_TYPE      = "ribm_t_by_t";  // use minimum  performance ribm unit

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk      ;
  input  logic           iclkena   ;
  input  logic           ireset    ;
  //
  input  logic           isop      ;
  input  logic           ival      ;
  input  logic           ieop      ;
  input  logic           idat      ;
  input  logic           ieras     ;
  //
  output logic           osop      ;
  output logic           oval      ;
  output logic           oeop      ;
  output logic           oeof      ;
  output logic           odat      ;
  //
  output logic           odecfail  ;
  output logic [m-1 : 0] obiterr   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  data_t  syndrome_count__oram_addr                 ;
  ptr_t   syndrome_count__oram_ptr                  ;
  logic   syndrome_count__oram_data                 ;
  logic   syndrome_count__oram_eras                 ;
  logic   syndrome_count__oram_write                ;
  logic   syndrome_count__osyndrome_val             ;
  ptr_t   syndrome_count__osyndrome_ptr             ;
  data_t  syndrome_count__osyndrome     [2][1 : t2] ;

  logic   berlekamp__oloc_poly_val                  ;
  ptr_t   berlekamp__oloc_poly_ptr                  ;
  data_t  berlekamp__oloc_poly          [2][0 : t]  ;

  data_t  chieny__oram_addr ;
  ptr_t   chieny__oram_ptr  ;
  logic   chieny__oram_read ;
  logic   chieny__iram_eras ;
  logic   chieny__iram_data ;

  data_t  chieny__owaddr        ;
  ptr_t   chieny__owptr         ;
  logic   chieny__odat_nfixed   ;

  logic           chieny__osop          ;
  logic           chieny__oval          ;
  logic           chieny__oeop          ;
  logic           chieny__oeof          ;
  logic   [1 : 0] chieny__odat          ;
  logic   [1 : 0] chieny__odecfail      ;
  data_t          chieny__obiterr   [2] ;
  data_t          chieny__odecerr   [2] ;

  logic   [1 : 0] decision__iram_data        ;
  logic           decision__iram_data_nfixed ;
  data_t          decision__oram_addr        ;
  ptr_t           decision__oram_ptr         ;
  logic           decision__oram_read        ;

  //------------------------------------------------------------------------------------------------------
  // count syndrome & store to buffer module
  //------------------------------------------------------------------------------------------------------

  bch_eras_syndrome_count
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  syndrome_count
  (
    .iclk          ( iclk    ) ,
    .ireset        ( ireset  ) ,
    .iclkena       ( iclkena ) ,
    //
    .isop          ( isop    ) ,
    .ival          ( ival    ) ,
    .ieop          ( ieop    ) ,
    .ieras         ( ieras   ) ,
    .idat          ( idat    ) ,
    //
    .oram_addr     ( syndrome_count__oram_addr     ) ,
    .oram_ptr      ( syndrome_count__oram_ptr      ) ,
    .oram_data     ( syndrome_count__oram_data     ) ,
    .oram_eras     ( syndrome_count__oram_eras     ) ,
    .oram_write    ( syndrome_count__oram_write    ) ,
    //
    .osyndrome_val ( syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( syndrome_count__osyndrome     )
  );

  //------------------------------------------------------------------------------------------------------
  // used BCH buffer. Buffers syncronization is based upon pipeline pointer transfer
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( m ) ,
    .pDATA_W ( 2 ) ,
    .pBNUM_W ( 2 ) ,  // 4D bufer
    .pPIPE   ( 0 )    // no pipeline register
  )
  in_buffer
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .iwrite  (  syndrome_count__oram_write                            ) ,
    .iwptr   (  syndrome_count__oram_ptr                              ) ,
    .iwaddr  (  syndrome_count__oram_addr                             ) ,
    .iwdata  ( {syndrome_count__oram_eras, syndrome_count__oram_data} ) ,
    //
    .iread   (  chieny__oram_read                                     ) ,
    .iraddr  (  chieny__oram_addr                                     ) ,
    .irptr   (  chieny__oram_ptr                                      ) ,
    .ordata  ( {chieny__iram_eras, chieny__iram_data}                 )
  );

  //------------------------------------------------------------------------------------------------------
  // error locator polynome search algorithm
  //------------------------------------------------------------------------------------------------------

  bch_eras_berlekamp
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   ) ,
    .pTYPE    ( pBM_TYPE )
  )
  berlekamp
  (
    .iclk          ( iclk    ) ,
    .ireset        ( ireset  ) ,
    .iclkena       ( iclkena ) ,
    //
    .isyndrome_val ( syndrome_count__osyndrome_val ) ,
    .isyndrome_ptr ( syndrome_count__osyndrome_ptr ) ,
    .isyndrome     ( syndrome_count__osyndrome     ) ,
    //
    .oloc_poly_val ( berlekamp__oloc_poly_val      ) ,
    .oloc_poly_ptr ( berlekamp__oloc_poly_ptr      ) ,
    .oloc_poly     ( berlekamp__oloc_poly          )
  );

  //------------------------------------------------------------------------------------------------------
  // locator polynome roots search & error correction algorithm
  //------------------------------------------------------------------------------------------------------

  bch_eras_chieny_search
  #(
    .m        ( m        ) ,
    .k_max    ( k_max    ) ,
    .d        ( d        ) ,
    .n        ( n        ) ,
    .irrpol   ( irrpol   )
  )
  chieny
  (
    .iclk          ( iclk    ) ,
    .ireset        ( ireset  ) ,
    .iclkena       ( iclkena ) ,
    //
    .iloc_poly_val ( berlekamp__oloc_poly_val ) ,
    .iloc_poly_ptr ( berlekamp__oloc_poly_ptr ) ,
    .iloc_poly     ( berlekamp__oloc_poly     ) ,
    //
    .oram_addr     ( chieny__oram_addr        ) ,
    .oram_ptr      ( chieny__oram_ptr         ) ,
    .oram_read     ( chieny__oram_read        ) ,
    .iram_data     ( chieny__iram_data        ) ,
    .iram_eras     ( chieny__iram_eras        ) ,
    //
    .owaddr        ( chieny__owaddr           ) ,
    .owptr         ( chieny__owptr            ) ,
    .odat_nfixed   ( chieny__odat_nfixed      ) ,
    //
    .osop          ( chieny__osop             ) ,
    .oval          ( chieny__oval             ) ,
    .oeop          ( chieny__oeop             ) ,
    .odat          ( chieny__odat             ) ,
    .oeof          ( chieny__oeof             ) ,
    .odecfail      ( chieny__odecfail         ) ,
    .obiterr       ( chieny__obiterr          ) ,
    .odecerr       ( chieny__odecerr          )
  );

  //------------------------------------------------------------------------------------------------------
  // decision ram
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( m ) ,
    .pDATA_W ( 3 ) ,
    .pBNUM_W ( 1 ) ,  // 2D bufer
    .pPIPE   ( 0 )    // no pipeline register
  )
  out_buffer
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .iwrite  (  chieny__oval                                     ) ,
    .iwptr   (  chieny__owptr[0]                                 ) ,
    .iwaddr  (  chieny__owaddr                                   ) ,
    .iwdata  ( {chieny__odat_nfixed, chieny__odat}               ) ,
    //
    .iread   (  decision__oram_read                              ) ,
    .iraddr  (  decision__oram_addr                              ) ,
    .irptr   (  decision__oram_ptr[0]                            ) ,
    .ordata  ( {decision__iram_data_nfixed, decision__iram_data} )
  );

  //------------------------------------------------------------------------------------------------------
  // decision itself
  //------------------------------------------------------------------------------------------------------

  bch_eras_decision
  #(
    .m      ( m      ) ,
    .k_max  ( k_max  ) ,
    .d      ( d      ) ,
    .n      ( n      ) ,
    .irrpol ( irrpol )
  )
  decision
  (
    .iclk             ( iclk    ) ,
    .ireset           ( ireset  ) ,
    .iclkena          ( iclkena ) ,
    //
    .idata_val        ( chieny__oval & chieny__oeof ) ,
    .idata_ptr        ( chieny__owptr               ) ,
    .idata_decfail    ( chieny__odecfail            ) ,
    .idata_biterr     ( chieny__obiterr             ) ,
    .idata_decerr     ( chieny__odecerr             ) ,
    //
    .iram_data        ( decision__iram_data         ) ,
    .iram_data_nfixed ( decision__iram_data_nfixed  ) ,
    .oram_addr        ( decision__oram_addr         ) ,
    .oram_ptr         ( decision__oram_ptr          ) ,
    .oram_read        ( decision__oram_read         ) ,
    //
    .osop             ( osop                        ) ,
    .oval             ( oval                        ) ,
    .oeop             ( oeop                        ) ,
    .odat             ( odat                        ) ,
    .oeof             ( oeof                        ) ,
    .odecfail         ( odecfail                    ) ,
    .obiterr          ( obiterr                     )
  );

endmodule
