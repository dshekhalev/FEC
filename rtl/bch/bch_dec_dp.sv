/*

  parameter int m         =   4 ;
  parameter int k_max     =   5 ;
  parameter int d         =   7 ;
  parameter int n         =  15 ;
  parameter int irrpol    = 285 ;
  parameter     pBM_TYPE  = "ibm_2t";
  parameter bit pBM_ASYNC = 1'b0;




  logic           bch_dec_dp__iclk      ;
  logic           bch_dec_dp__ireset    ;
  logic           bch_dec_dp__iclkena   ;
  //
  logic           bch_dec_dp__isop      ;
  logic           bch_dec_dp__ival      ;
  logic           bch_dec_dp__ieop      ;
  logic           bch_dec_dp__idat      ;
  //
  logic           bch_dec_dp__osop      ;
  logic           bch_dec_dp__oval      ;
  logic           bch_dec_dp__oeop      ;
  logic           bch_dec_dp__oeof      ;
  logic           bch_dec_dp__odat      ;
  //
  logic           bch_dec_dp__odecfail  ;
  logic [m-1 : 0] bch_dec_dp__obiterr   ;



  bch_dec_dp
  #(
    .m         ( m         ) ,
    .k_max     ( k_max     ) ,
    .d         ( d         ) ,
    .n         ( n         ) ,
    .irrpol    ( irrpol    ) ,
    .pBM_TYPE  ( pBM_TYPE  ) ,
    .pBM_ASYNC ( pBM_ASYNC )
  )
  bch_dec_dp
  (
    .iclk     ( bch_dec_dp__iclk     ) ,
    .ireset   ( bch_dec_dp__ireset   ) ,
    .iclkena  ( bch_dec_dp__iclkena  ) ,
    //
    .isop     ( bch_dec_dp__isop     ) ,
    .ival     ( bch_dec_dp__ival     ) ,
    .ieop     ( bch_dec_dp__ieop     ) ,
    .idat     ( bch_dec_dp__idat     ) ,
    //
    .osop     ( bch_dec_dp__osop     ) ,
    .oval     ( bch_dec_dp__oval     ) ,
    .oeop     ( bch_dec_dp__oeop     ) ,
    .oeof     ( bch_dec_dp__oeof     ) ,
    .odat     ( bch_dec_dp__odat     ) ,
    //
    .odecfail ( bch_dec_dp__odecfail ) ,
    .obiterr  ( bch_dec_dp__obiterr  )
  );


  assign bch_dec_dp__iclk    = '0 ;
  assign bch_dec_dp__ireset  = '0 ;
  assign bch_dec_dp__iclkena = '0 ;
  assign bch_dec_dp__isop    = '0 ;
  assign bch_dec_dp__ival    = '0 ;
  assign bch_dec_dp__ieop    = '0 ;
  assign bch_dec_dp__idat    = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_dec_dp.sv
// Description   : bch decoder top module with dual passing througth data. No any data correction if decfail occured, but has high latency
//


module bch_dec_dp
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  isop     ,
  ival     ,
  ieop     ,
  idat     ,
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

//parameter pBM_TYPE      = "ibm_2t";       // use maximum  performance ibm unit
//parameter pBM_TYPE      = "ibm_4t";       // use medium   performance ibm unit
//parameter pBM_TYPE      = "ibm_2t_by_t";  // use minimum  performance ibm unit

  parameter pBM_TYPE      = "ribm_1t";      // use maximum  performance ribm unit
//parameter pBM_TYPE      = "ribm_2t";      // use medium   performance ribm unit
//parameter pBM_TYPE      = "ribm_t_by_t";  // use minimum  performance ribm unit

  parameter bit pBM_ASYNC = 1'b0;           // use asynchronus berlekamp unit (let to use less performance units)

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk      ;
  input  logic           ireset    ;
  input  logic           iclkena   ;
  //
  input  logic           isop      ;
  input  logic           ival      ;
  input  logic           ieop      ;
  input  logic           idat      ;
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

  data_t  syndrome_count__oram_addr             ;
  ptr_t   syndrome_count__oram_ptr              ;
  logic   syndrome_count__oram_data             ;
  logic   syndrome_count__oram_write            ;
  logic   syndrome_count__osyndrome_val         ;
  ptr_t   syndrome_count__osyndrome_ptr         ;
  data_t  syndrome_count__osyndrome    [1 : t2] ;

  logic   berlekamp__oloc_poly_val              ;
  data_t  berlekamp__oloc_poly         [0 : t]  ;
  data_t  berlekamp__oloc_poly_deg              ;
  ptr_t   berlekamp__oloc_poly_ptr              ;
  logic   berlekamp__oloc_decfail               ;

  data_t  chieny__oram_addr ;
  ptr_t   chieny__oram_ptr  ;
  logic   chieny__oram_read ;
  logic   chieny__iram_data ;

  data_t  chieny__owaddr      ;
  ptr_t   chieny__owptr       ;
  logic   chieny__odat_nfixed ;

  logic   chieny__osop        ;
  logic   chieny__oval        ;
  logic   chieny__oeop        ;
  logic   chieny__oeof        ;
  logic   chieny__odat        ;
  logic   chieny__odecfail    ;
  data_t  chieny__obiterr     ;

  logic   decision__iram_data        ;
  logic   decision__iram_data_nfixed ;
  data_t  decision__oram_addr        ;
  ptr_t   decision__oram_ptr         ;
  logic   decision__oram_read        ;

  //------------------------------------------------------------------------------------------------------
  // used BCH buffer. Buffers syncronization is based upon pipeline pointer transfer
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( m ) ,
    .pDATA_W ( 1 ) ,
    .pBNUM_W ( 2 ) ,  // 4D bufer
    .pPIPE   ( 0 )    // no pipeline register
  )
  in_buffer
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .iwrite  ( syndrome_count__oram_write ) ,
    .iwptr   ( syndrome_count__oram_ptr   ) ,
    .iwaddr  ( syndrome_count__oram_addr  ) ,
    .iwdata  ( syndrome_count__oram_data  ) ,
    //
    .iread   ( chieny__oram_read ) ,
    .iraddr  ( chieny__oram_addr ) ,
    .irptr   ( chieny__oram_ptr  ) ,
    .ordata  ( chieny__iram_data )
  );

  //------------------------------------------------------------------------------------------------------
  // count syndrome & store to buffer module
  //------------------------------------------------------------------------------------------------------

  bch_syndrome_count
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
    .idat          ( idat    ) ,
    //
    .oram_addr     ( syndrome_count__oram_addr     ) ,
    .oram_ptr      ( syndrome_count__oram_ptr      ) ,
    .oram_data     ( syndrome_count__oram_data     ) ,
    .oram_write    ( syndrome_count__oram_write    ) ,
    //
    .osyndrome_val ( syndrome_count__osyndrome_val ) ,
    .osyndrome_ptr ( syndrome_count__osyndrome_ptr ) ,
    .osyndrome     ( syndrome_count__osyndrome     )
  );

  //------------------------------------------------------------------------------------------------------
  // error locator polynome search algorithm
  //------------------------------------------------------------------------------------------------------

  generate
    if (pBM_ASYNC) begin
      logic _syndrome_count__osyndrome_val;
      logic _berlekamp__oloc_poly_val;

      bch_berlekamp
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
        .iclkena       ( 1'b1    ) ,
        //
        .isyndrome_val ( _syndrome_count__osyndrome_val ) ,
        .isyndrome_ptr (  syndrome_count__osyndrome_ptr ) ,
        .isyndrome     (  syndrome_count__osyndrome     ) ,
        //
        .oloc_poly_val ( _berlekamp__oloc_poly_val      ) ,
        .oloc_poly     (  berlekamp__oloc_poly          ) ,
        .oloc_poly_deg (  berlekamp__oloc_poly_deg      ) ,
        .oloc_poly_ptr (  berlekamp__oloc_poly_ptr      ) ,
        .oloc_decfail  (  berlekamp__oloc_decfail       )
      );

      assign _syndrome_count__osyndrome_val = iclkena & syndrome_count__osyndrome_val;

      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          berlekamp__oloc_poly_val <= 1'b0;
        end
        else if (_berlekamp__oloc_poly_val) begin// use RS "latch" for resynchronize
          berlekamp__oloc_poly_val <= 1'b1;
        end
        else if (iclkena) begin
          berlekamp__oloc_poly_val <= 1'b0;
        end
      end
    end
    else begin
      bch_berlekamp
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
        .oloc_poly_val ( berlekamp__oloc_poly_val     ) ,
        .oloc_poly     ( berlekamp__oloc_poly         ) ,
        .oloc_poly_deg ( berlekamp__oloc_poly_deg     ) ,
        .oloc_poly_ptr ( berlekamp__oloc_poly_ptr     ) ,
        .oloc_decfail  ( berlekamp__oloc_decfail      )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // locator polynome roots search & error correction algorithm
  //------------------------------------------------------------------------------------------------------

  bch_chieny_search
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
    .iloc_poly     ( berlekamp__oloc_poly     ) ,
    .iloc_poly_ptr ( berlekamp__oloc_poly_ptr ) ,
    .iloc_decfail  ( berlekamp__oloc_decfail  ) ,
    //
    .oram_addr     ( chieny__oram_addr        ) ,
    .oram_ptr      ( chieny__oram_ptr         ) ,
    .oram_read     ( chieny__oram_read        ) ,
    .iram_data     ( chieny__iram_data        ) ,
    //
    .owaddr        ( chieny__owaddr           ) ,
    .owptr         ( chieny__owptr            ) ,
    .odat_nfixed   ( chieny__odat_nfixed      ) ,
    //
    .osop          ( chieny__osop     ) ,
    .oval          ( chieny__oval     ) ,
    .oeop          ( chieny__oeop     ) ,
    .odat          ( chieny__odat     ) ,
    .oeof          ( chieny__oeof     ) ,
    .odecfail      ( chieny__odecfail ) ,
    .obiterr       ( chieny__obiterr  )
  );

  //------------------------------------------------------------------------------------------------------
  // decision ram
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( m ) ,
    .pDATA_W ( 2 ) ,
    .pBNUM_W ( 1 ) ,  // 2D bufer
    .pPIPE   ( 0 )    // no pipeline register
  )
  out_buffer
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .iwrite  ( chieny__oval                                      ) ,
    .iwptr   ( chieny__owptr                                     ) ,
    .iwaddr  ( chieny__owaddr                                    ) ,
    .iwdata  ( {chieny__odat_nfixed, chieny__odat}               ) ,
    //
    .iread   ( decision__oram_read                               ) ,
    .iraddr  ( decision__oram_addr                               ) ,
    .irptr   ( decision__oram_ptr                                ) ,
    .ordata  ( {decision__iram_data_nfixed, decision__iram_data} )
  );

  //------------------------------------------------------------------------------------------------------
  // decision itself
  //------------------------------------------------------------------------------------------------------

  bch_decision
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
