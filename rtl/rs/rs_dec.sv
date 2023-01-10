/*



  parameter int n         = 240 ;
  parameter int check     =  30 ;
  parameter int m         =   8 ;
  parameter int irrpol    = 285 ;
  parameter int genstart  =   0 ;
  parameter int rootspace =   1 ;
  parameter int sym_err_w =   m ;
  parameter int bit_err_w =   m ;
  parameter     pBM_TYPE  = "ribm_6check"



  logic                   rs_dec__iclk          ;
  logic                   rs_dec__ireset        ;
  logic                   rs_dec__iclkena       ;
  logic                   rs_dec__isop          ;
  logic                   rs_dec__ival          ;
  logic                   rs_dec__ieop          ;
  logic         [m-1 : 0] rs_dec__idat          ;
  logic                   rs_dec__osop          ;
  logic                   rs_dec__oval          ;
  logic                   rs_dec__oeop          ;
  logic                   rs_dec__oeof          ;
  logic         [m-1 : 0] rs_dec__odat          ;
  logic                   rs_dec__odecfail      ;
  logic [sym_err_w-1 : 0] rs_dec__onum_err_sym  ;
  logic [bit_err_w-1 : 0] rs_dec__onum_err_bit  ;



  rs_dec
  #(
    .n         ( n         ) ,
    .check     ( check     ) ,
    .m         ( m         ) ,
    .irrpol    ( irrpol    ) ,
    .genstart  ( genstart  ) ,
    .rootspace ( rootspace ) ,
    .sym_err_w ( sym_err_w ) ,
    .bit_err_w ( bit_err_w ) ,
    .pBM_TYPE  ( pBM_TYPE  )
  )
  rs_dec
  (
    .iclk         ( rs_dec__iclk         ) ,
    .ireset       ( rs_dec__ireset       ) ,
    .iclkena      ( rs_dec__iclkena      ) ,
    .isop         ( rs_dec__isop         ) ,
    .ival         ( rs_dec__ival         ) ,
    .ieop         ( rs_dec__ieop         ) ,
    .idat         ( rs_dec__idat         ) ,
    .osop         ( rs_dec__osop         ) ,
    .oval         ( rs_dec__oval         ) ,
    .oeop         ( rs_dec__oeop         ) ,
    .oeof         ( rs_dec__oeof         ) ,
    .odat         ( rs_dec__odat         ) ,
    .odecfail     ( rs_dec__odecfail     ) ,
    .onum_err_sym ( rs_dec__onum_err_sym ) ,
    .onum_err_bit ( rs_dec__onum_err_bit )
  );


  assign rs_dec__iclk    = '0 ;
  assign rs_dec__ireset  = '0 ;
  assign rs_dec__iclkena = '0 ;
  assign rs_dec__isop    = '0 ;
  assign rs_dec__ival    = '0 ;
  assign rs_dec__ieop    = '0 ;
  assign rs_dec__idat    = '0 ;



*/

//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_dec.sv
// Description   : rs decoder top module
//



module rs_dec
(
  iclk         ,
  ireset       ,
  iclkena      ,
  isop         ,
  ival         ,
  ieop         ,
  idat         ,
  osop         ,
  oval         ,
  oeop         ,
  oeof         ,
  odat         ,
  odecfail     ,
  onum_err_sym ,
  onum_err_bit
);

  `include "rs_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

//parameter pBM_TYPE = "ribm_1check";             // use maximum  performance unit
//parameter pBM_TYPE = "ribm_3check";             // use medium   performance unit
  parameter pBM_TYPE = "ribm_6check";             // use minimum  performance unit
//parameter pBM_TYPE = "ribm_1p5check_by_check";  // use least    performance unit

  parameter bit pBM_ASYNC = 1'b0;       // use asynchronus berlekamp unit (let to use less performance units)

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk         ;
  input  logic                   ireset       ;
  input  logic                   iclkena      ;
  input  logic                   isop         ;
  input  logic                   ival         ;
  input  logic                   ieop         ;
  input  logic         [m-1 : 0] idat         ;
  output logic                   osop         ;
  output logic                   oval         ;
  output logic                   oeop         ;
  output logic                   oeof         ;
  output logic         [m-1 : 0] odat         ;
  output logic                   odecfail     ;
  output logic [sym_err_w-1 : 0] onum_err_sym ;
  output logic [bit_err_w-1 : 0] onum_err_bit ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  data_t  syndrome_count__oram_addr                ;
  ptr_t   syndrome_count__oram_ptr                 ;
  data_t  syndrome_count__oram_data                ;
  logic   syndrome_count__oram_write               ;
  logic   syndrome_count__osyndrome_val            ;
  ptr_t   syndrome_count__osyndrome_ptr            ;
  data_t  syndrome_count__osyndrome    [1 : check] ;

  logic   berlekamp__oloc_poly_val                ;
  data_t  berlekamp__oloc_poly         [0 : errs] ;
  data_t  berlekamp__oomega_poly       [1 : errs] ;
  ptr_t   berlekamp__oloc_poly_ptr                ;
  data_t  berlekamp__oloc_poly_deg                ;
  logic   berlekamp__oloc_decfail                 ;

  data_t  chieny_search__oram_addr ;
  ptr_t   chieny_search__oram_ptr  ;
  logic   chieny_search__oram_read ;
  data_t  chieny_search__iram_data ;

  //------------------------------------------------------------------------------------------------------
  // used BCH buffer. Buffers syncronization is based upon pipeline pointer transfer
  //------------------------------------------------------------------------------------------------------

  bch_buffer
  #(
    .pADDR_W ( m ) ,
    .pDATA_W ( m ) ,
    .pBNUM_W ( 2 ) ,  // 4D bufer
    .pPIPE   ( 1 )
  )
  bch_buffer
  (
    .iclk     ( iclk    ) ,
    .ireset   ( ireset  ) ,
    .iclkena  ( iclkena ) ,
    //
    .iwrite   ( syndrome_count__oram_write ) ,
    .iwptr    ( syndrome_count__oram_ptr   ) ,
    .iwaddr   ( syndrome_count__oram_addr  ) ,
    .iwdata   ( syndrome_count__oram_data  ) ,
    //
    .iread    ( chieny_search__oram_read   ) ,
    .iraddr   ( chieny_search__oram_addr   ) ,
    .irptr    ( chieny_search__oram_ptr    ) ,
    .ordata   ( chieny_search__iram_data   )
  );

  //------------------------------------------------------------------------------------------------------
  // count syndrome & store to buffer module
  //------------------------------------------------------------------------------------------------------

  rs_syndrome_count
  #(
    .n         ( n         ) ,
    .check     ( check     ) ,
    .m         ( m         ) ,
    .irrpol    ( irrpol    ) ,
    .genstart  ( genstart  ) ,
    .rootspace ( rootspace )
  )
  syndrome_count
  (
    .iclk          ( iclk                          ) ,
    .iclkena       ( iclkena                       ) ,
    .ireset        ( ireset                        ) ,
    //
    .isop          ( isop                          ) ,
    .ival          ( ival                          ) ,
    .ieop          ( ieop                          ) ,
    .idat          ( idat                          ) ,
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

      rs_berlekamp
      #(
        .n         ( n         ) ,
        .check     ( check     ) ,
        .m         ( m         ) ,
        .irrpol    ( irrpol    ) ,
        .genstart  ( genstart  ) ,
        .rootspace ( rootspace ) ,
        .pTYPE     ( pBM_TYPE  )
      )
      rs_berlekamp
      (
        .iclk          ( iclk          ) ,
        .iclkena       ( 1'b1          ) ,
        .ireset        ( ireset        ) ,
        //
        .isyndrome_val ( _syndrome_count__osyndrome_val ) ,
        .isyndrome_ptr (  syndrome_count__osyndrome_ptr ) ,
        .isyndrome     (  syndrome_count__osyndrome     ) ,
        //
        .oloc_poly_val ( _berlekamp__oloc_poly_val      ) ,
        .oloc_poly     (  berlekamp__oloc_poly          ) ,
        .oomega_poly   (  berlekamp__oomega_poly        ) ,
        .oloc_poly_ptr (  berlekamp__oloc_poly_ptr      ) ,
        .oloc_poly_deg (  berlekamp__oloc_poly_deg      ) ,
        .oloc_decfail  (  berlekamp__oloc_decfail       )
      );

      assign _syndrome_count__osyndrome_val = iclkena & syndrome_count__osyndrome_val;

      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset)
          berlekamp__oloc_poly_val <= 1'b0;
        else if (_berlekamp__oloc_poly_val) // use RS "latch" for resynchronize
          berlekamp__oloc_poly_val <= 1'b1;
        else if (iclkena)
          berlekamp__oloc_poly_val <= 1'b0;
      end
    end
    else begin
      rs_berlekamp
      #(
        .n         ( n         ) ,
        .check     ( check     ) ,
        .m         ( m         ) ,
        .irrpol    ( irrpol    ) ,
        .genstart  ( genstart  ) ,
        .rootspace ( rootspace ) ,
        .pTYPE     ( pBM_TYPE  )
      )
      rs_berlekamp
      (
        .iclk          ( iclk          ) ,
        .iclkena       ( iclkena       ) ,
        .ireset        ( ireset        ) ,
        //
        .isyndrome_val ( syndrome_count__osyndrome_val ) ,
        .isyndrome_ptr ( syndrome_count__osyndrome_ptr ) ,
        .isyndrome     ( syndrome_count__osyndrome     ) ,
        //
        .oloc_poly_val ( berlekamp__oloc_poly_val      ) ,
        .oloc_poly     ( berlekamp__oloc_poly          ) ,
        .oomega_poly   ( berlekamp__oomega_poly        ) ,
        .oloc_poly_ptr ( berlekamp__oloc_poly_ptr      ) ,
        .oloc_poly_deg ( berlekamp__oloc_poly_deg      ) ,
        .oloc_decfail  ( berlekamp__oloc_decfail       )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // locator polynome roots search & error correction algorithm
  //------------------------------------------------------------------------------------------------------

  localparam bit RIBM_MODE =  (pBM_TYPE == "ribm_1check") || (pBM_TYPE == "ribm_3check") ||
                              (pBM_TYPE == "ribm_6check") || (pBM_TYPE == "ribm_1p5check_by_check");

  rs_chieny_search
  #(
    .n          ( n          ) ,
    .check      ( check      ) ,
    .m          ( m          ) ,
    .irrpol     ( irrpol     ) ,
    .genstart   ( genstart   ) ,
    .rootspace  ( rootspace  ) ,
    .sym_err_w  ( sym_err_w  ) ,
    .bit_err_w  ( bit_err_w  ) ,
    .pRIBM_MODE ( RIBM_MODE  )
  )
  chieny
  (
    .iclk          ( iclk                     ) ,
    .iclkena       ( iclkena                  ) ,
    .ireset        ( ireset                   ) ,
    //
    .iloc_poly_val ( berlekamp__oloc_poly_val ) ,
    .iloc_poly     ( berlekamp__oloc_poly     ) ,
    .iomega_poly   ( berlekamp__oomega_poly   ) ,
    .iloc_poly_ptr ( berlekamp__oloc_poly_ptr ) ,
    .iloc_decfail  ( berlekamp__oloc_decfail  ) ,
    //
    .iram_data     ( chieny_search__iram_data ) ,
    .oram_addr     ( chieny_search__oram_addr ) ,
    .oram_ptr      ( chieny_search__oram_ptr  ) ,
    .oram_read     ( chieny_search__oram_read ) ,
    //
    .osop          ( osop                     ) ,
    .oval          ( oval                     ) ,
    .oeop          ( oeop                     ) ,
    .oeof          ( oeof                     ) ,
    .odat          ( odat                     ) ,
    //
    .odecfail      ( odecfail                 ) ,
    .onum_err_sym  ( onum_err_sym             ) ,
    .onum_err_bit  ( onum_err_bit             )
  );

endmodule
