/*



  parameter int pDAT_W = 4 ;
  parameter int pTAG_W = 4 ;



  logic                dvb_pls_dec__iclk    ;
  logic                dvb_pls_dec__ireset  ;
  logic                dvb_pls_dec__iclkena ;
  //
  logic                dvb_pls_dec__isop    ;
  logic                dvb_pls_dec__ival    ;
  logic                dvb_pls_dec__ieop    ;
  logic [pDAT_W-1 : 0] dvb_pls_dec__idat    ;
  logic [pTAG_W-1 : 0] dvb_pls_dec__itag    ;
  //
  logic                dvb_pls_dec__ordy    ;
  //
  logic                dvb_pls_dec__oval    ;
  logic        [6 : 0] dvb_pls_dec__odat    ;
  logic [pTAG_W-1 : 0] dvb_pls_dec__otag    ;



  dvb_pls_dec
  #(
    .pDAT_W ( pDAT_W ) ,
    .pTAG_W ( pTAG_W )
  )
  dvb_pls_dec
  (
    .iclk    ( dvb_pls_dec__iclk    ) ,
    .ireset  ( dvb_pls_dec__ireset  ) ,
    .iclkena ( dvb_pls_dec__iclkena ) ,
    //
    .isop    ( dvb_pls_dec__isop    ) ,
    .ival    ( dvb_pls_dec__ival    ) ,
    .ieop    ( dvb_pls_dec__ieop    ) ,
    .idat    ( dvb_pls_dec__idat    ) ,
    .itag    ( dvb_pls_dec__itag    ) ,
    //
    .ordy    ( dvb_pls_dec__ordy    ) ,
    //
    .oval    ( dvb_pls_dec__oval    ) ,
    .odat    ( dvb_pls_dec__odat    ) ,
    .otag    ( dvb_pls_dec__otag    )
  );


  assign dvb_pls_dec__iclk    = '0 ;
  assign dvb_pls_dec__ireset  = '0 ;
  assign dvb_pls_dec__iclkena = '0 ;
  assign dvb_pls_dec__isop    = '0 ;
  assign dvb_pls_dec__ival    = '0 ;
  assign dvb_pls_dec__ieop    = '0 ;
  assign dvb_pls_dec__idat    = '0 ;
  assign dvb_pls_dec__itag    = '0 ;



*/

//
// Project       : PLS DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pls_dec.sv
// Description   : DVB PLS non-systematic code decoder with descrambler
//


module dvb_pls_dec
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat    ,
  itag    ,
  //
  ordy    ,
  //
  oval    ,
  odat    ,
  otag
);

  parameter int pTAG_W = 4;

  `include "dvb_pls_dec_types.svh"

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
  input  logic [pDAT_W-1 : 0] idat    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  //
  output logic                ordy    ;
  //
  output logic                oval    ;
  output logic        [6 : 0] odat    ;
  output logic [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pTAG_W-1 : 0] used_tag;
  //
  // symbol metric counter
  logic         symb_metric__osop         ;
  logic         symb_metric__oval         ;
  logic         symb_metric__oeop         ;
  logic         symb_metric__oadd_n_sub   ;
  metric_idx_t  symb_metric__oidx         ;
  metric_t      symb_metric__odat         ;

  //
  // main ctrl
  logic         ctrl__osort_sop           ;
  logic         ctrl__osort_val           ;
  logic         ctrl__osort_eop           ;

  //
  // bit6 decoder phase 0
  logic         bit6_dec__ometric_val     ;
  metric_sum_t  bit6_dec__ometric         ;

  //
  // rm decoder and bit 6 phase 1
  logic         rm_dec__ohadamard_done    ;
  //
  logic         rm_dec__obit6_metric_val  ;
  metric_sum_t  rm_dec__obit6_metric      ;
  //
  logic         rm_dec__oval              ;
  logic [5 : 0] rm_dec__odat              ;

  //------------------------------------------------------------------------------------------------------
  // descrambler and symbol metric counter
  //------------------------------------------------------------------------------------------------------

  dvb_pls_dec_symb_metric
  #(
    .pDAT_W ( pDAT_W )
  )
  symb_metric
  (
    .iclk        ( iclk                     ) ,
    .ireset      ( ireset                   ) ,
    .iclkena     ( iclkena                  ) ,
    //
    .isop        ( isop                     ) ,
    .ival        ( ival                     ) ,
    .ieop        ( ieop                     ) ,
    .idat        ( idat                     ) ,
    //
    .osop        ( symb_metric__osop        ) ,
    .oval        ( symb_metric__oval        ) ,
    .oeop        ( symb_metric__oeop        ) ,
    .oadd_n_sub  ( symb_metric__oadd_n_sub  ) ,
    .oidx        ( symb_metric__oidx        ) ,
    .odat        ( symb_metric__odat        )
  );

  //------------------------------------------------------------------------------------------------------
  // main ctrl
  //------------------------------------------------------------------------------------------------------

  dvb_pls_dec_ctrl
  ctrl
  (
    .iclk           ( iclk                   ) ,
    .ireset         ( ireset                 ) ,
    .iclkena        ( iclkena                ) ,
    //
    .isop           ( isop                   ) ,
    .ival           ( ival                   ) ,
    .ieop           ( ieop                   ) ,
    .ordy           ( ordy                   ) ,
    //
    .ihadamard_done ( rm_dec__ohadamard_done ) ,
    .osort_sop      ( ctrl__osort_sop        ) ,
    .osort_val      ( ctrl__osort_val        ) ,
    .osort_eop      ( ctrl__osort_eop        )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & isop) begin
        used_tag <= itag;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // bit [5 : 0] decoder & bit 6 path 0 decoder
  //------------------------------------------------------------------------------------------------------

  dvb_pls_dec_rm_dec
  #(
    .pDAT_W ( pDAT_W )
  )
  rm_dec
  (
    .iclk             ( iclk                     ) ,
    .ireset           ( ireset                   ) ,
    .iclkena          ( iclkena                  ) ,
    //
    .isop             ( symb_metric__osop        ) ,
    .ival             ( symb_metric__oval        ) ,
    .ieop             ( symb_metric__oeop        ) ,
    .iadd_n_sub       ( symb_metric__oadd_n_sub  ) ,
    .iidx             ( symb_metric__oidx        ) ,
    .idat             ( symb_metric__odat        ) ,
    //
    .isort_sop        ( ctrl__osort_sop          ) ,
    .isort_val        ( ctrl__osort_val          ) ,
    .isort_eop        ( ctrl__osort_eop          ) ,
    .ohadamard_done   ( rm_dec__ohadamard_done   ) ,
    //
    .obit6_metric_val ( rm_dec__obit6_metric_val ) ,
    .obit6_metric     ( rm_dec__obit6_metric     ) ,
    //
    .oval             ( rm_dec__oval             ) ,
    .odat             ( rm_dec__odat             )
  );

  //------------------------------------------------------------------------------------------------------
  // bit 6 path 1 decoder
  //------------------------------------------------------------------------------------------------------

  dvb_pls_dec_bit6_dec
  #(
    .pDAT_W ( pDAT_W )
  )
  bit6_dec
  (
    .iclk        ( iclk                    ) ,
    .ireset      ( ireset                  ) ,
    .iclkena     ( iclkena                 ) ,
    //
    .isop        ( symb_metric__osop       ) ,
    .ival        ( symb_metric__oval       ) ,
    .ieop        ( symb_metric__oeop       ) ,
    .iadd_n_sub  ( symb_metric__oadd_n_sub ) ,
    .idat        ( symb_metric__odat       ) ,
    //
    .ometric_val ( bit6_dec__ometric_val   ) ,
    .ometric     ( bit6_dec__ometric       )
  );

  //------------------------------------------------------------------------------------------------------
  // bit 6 decision take 2 cycles to allign with rm_dec output
  //------------------------------------------------------------------------------------------------------

  metric_sum_t bit6_dec0_metric;
  logic        bit6_dec0;

  metric_sum_t bit6_dec1_metric;
  logic        bit6_dec1;

  logic        bit6_dec_rslt;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // 1 tick
      bit6_dec0_metric <= abs_metric_sum(bit6_dec__ometric);
      bit6_dec0        <= (bit6_dec__ometric >= 0);
      //
      bit6_dec1_metric <= abs_metric_sum(rm_dec__obit6_metric);
      bit6_dec1        <= (rm_dec__obit6_metric >= 0);
      // 2 tick
      bit6_dec_rslt    <= (bit6_dec0_metric >= bit6_dec1_metric) ? bit6_dec0 : bit6_dec1;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  assign oval = rm_dec__oval;
  assign odat = {bit6_dec_rslt, rm_dec__odat};

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ctrl__osort_val & ctrl__osort_eop) begin // can do so because has enogth time
        otag <= used_tag;
      end
    end
  end

endmodule
