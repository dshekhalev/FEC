/*



  parameter int pDAT_W = 4 ;
  parameter int pTAG_W = 4 ;
  parameter bit pXMODE = 0 ;



  logic                dvb_pls_dec__iclk    ;
  logic                dvb_pls_dec__ireset  ;
  logic                dvb_pls_dec__iclkena ;
  //
  logic                dvb_pls_dec__isop    ;
  logic                dvb_pls_dec__ival    ;
  logic                dvb_pls_dec__ieop    ;
  logic [pDAT_W-1 : 0] dvb_pls_dec__idat_re ;
  logic [pDAT_W-1 : 0] dvb_pls_dec__idat_im ;
  logic [pTAG_W-1 : 0] dvb_pls_dec__itag    ;
  logic                dvb_pls_dec__ordy    ;
  //
  logic                dvb_pls_dec__oval    ;
  logic        [6 : 0] dvb_pls_dec__odat    ;
  logic [pTAG_W-1 : 0] dvb_pls_dec__otag    ;



  dvb_pls_dec
  #(
    .pDAT_W ( pDAT_W ) ,
    .pTAG_W ( pTAG_W ) ,
    .pXMODE ( pXMODE )
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
    .idat_re ( dvb_pls_dec__idat_re ) ,
    .idat_im ( dvb_pls_dec__idat_im ) ,
    .itag    ( dvb_pls_dec__itag    ) ,
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
  assign dvb_pls_dec__idat_re = '0 ;
  assign dvb_pls_dec__idat_im = '0 ;
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
  idat_re ,
  idat_im ,
  itag    ,
  ordy    ,
  //
  oval    ,
  odat    ,
  otag
);

  parameter int pTAG_W = 4;
  parameter bit pXMODE = 0;

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
  input  dat_t                idat_re ;
  input  dat_t                idat_im ;
  input  logic [pTAG_W-1 : 0] itag    ;
  output logic                ordy    ;
  //
  output logic                oval    ;
  output logic        [7 : 0] odat    ; // PLS_CODE = {modcode, ptype}
  output logic [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pTAG_W-1 : 0] used_tag;

  //
  // demapper
  logic         sop;
  logic         val;
  logic         eop;

  bdat_t        dat_hypo [2];

  //
  // symbol metric counter
  logic         symb_metric__osop       [2] ;
  logic         symb_metric__oval       [2] ;
  logic         symb_metric__oeop       [2] ;
  logic         symb_metric__oadd_n_sub [2] ;
  metric_idx_t  symb_metric__oidx       [2] ;
  metric_t      symb_metric__odat       [2] ;

  //
  // main ctrl
  logic         ctrl__osort_sop           ;
  logic         ctrl__osort_val           ;
  logic         ctrl__osort_eop           ;

  //
  // rm decoder for b0 = 0
  logic         rm_dec__ohadamard_done      ;
  //
  logic         rm_dec_b0__oval             ;
  logic [0 : 7] rm_dec_b0__odat             ;
  metric_sum_t  rm_dec_b0__odat_metric      ;

  //
  // rm decoder for b0 = 1
  logic         rm_dec_b1__oval             ;
  logic [0 : 7] rm_dec_b1__odat             ;
  metric_sum_t  rm_dec_b1__odat_metric      ;

  //------------------------------------------------------------------------------------------------------
  // demapper
  //------------------------------------------------------------------------------------------------------

  logic even;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= 1'b0;
    end
    else if (iclkena) begin
      val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= isop;
      val <= ival;
      eop <= ieop;
      //
      if (ival) begin
        even <= isop ? 1'b0 : !even;
        //
        dat_hypo[0] <= (isop | even) ? (idat_re + idat_im) : ( idat_im - idat_re);
        dat_hypo[1] <= (isop | even) ? (idat_im - idat_re) : (-idat_im - idat_re);  // pi/2 rotate
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // descrambler and symbol metric counter
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g <= pXMODE; g++) begin : symb_metric_gen_inst
      dvb_pls_dec_symb_metric
      #(
        .pDAT_W ( pDAT_W )
      )
      symb_metric
      (
        .iclk        ( iclk                        ) ,
        .ireset      ( ireset                      ) ,
        .iclkena     ( iclkena                     ) ,
        //
        .isop        ( sop                         ) ,
        .ival        ( val                         ) ,
        .ieop        ( eop                         ) ,
        .idat        ( dat_hypo                [g] ) ,
        //
        .osop        ( symb_metric__osop       [g] ) ,
        .oval        ( symb_metric__oval       [g] ) ,
        .oeop        ( symb_metric__oeop       [g] ) ,
        .oadd_n_sub  ( symb_metric__oadd_n_sub [g] ) ,
        .oidx        ( symb_metric__oidx       [g] ) ,
        .odat        ( symb_metric__odat       [g] )
      );
    end
  endgenerate

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
  // bit [7 : 0] decoder for b0 == 0 hypothesis
  //------------------------------------------------------------------------------------------------------

  dvb_pls_dec_rm_dec
  #(
    .pDAT_W      ( pDAT_W ) ,
    .pBIT0_VALUE ( 0      )
  )
  rm_dec_b0
  (
    .iclk             ( iclk                        ) ,
    .ireset           ( ireset                      ) ,
    .iclkena          ( iclkena                     ) ,
    //
    .isop             ( symb_metric__osop       [0] ) ,
    .ival             ( symb_metric__oval       [0] ) ,
    .ieop             ( symb_metric__oeop       [0] ) ,
    .iadd_n_sub       ( symb_metric__oadd_n_sub [0] ) ,
    .iidx             ( symb_metric__oidx       [0] ) ,
    .idat             ( symb_metric__odat       [0] ) ,
    //
    .isort_sop        ( ctrl__osort_sop             ) ,
    .isort_val        ( ctrl__osort_val             ) ,
    .isort_eop        ( ctrl__osort_eop             ) ,
    .ohadamard_done   ( rm_dec__ohadamard_done      ) ,
    //
    .oval             ( rm_dec_b0__oval             ) ,
    .odat             ( rm_dec_b0__odat             ) ,
    .odat_metric      ( rm_dec_b0__odat_metric      )
  );

  //------------------------------------------------------------------------------------------------------
  // bit [7 : 0] decoder for b0 == 1 hypothesis
  //------------------------------------------------------------------------------------------------------

  generate
    if (pXMODE) begin : rm_dec_b1
      dvb_pls_dec_rm_dec
      #(
        .pDAT_W      ( pDAT_W ) ,
        .pBIT0_VALUE ( 1      )
      )
      rm_dec_b1
      (
        .iclk             ( iclk                        ) ,
        .ireset           ( ireset                      ) ,
        .iclkena          ( iclkena                     ) ,
        //
        .isop             ( symb_metric__osop       [1] ) ,
        .ival             ( symb_metric__oval       [1] ) ,
        .ieop             ( symb_metric__oeop       [1] ) ,
        .iadd_n_sub       ( symb_metric__oadd_n_sub [1] ) ,
        .iidx             ( symb_metric__oidx       [1] ) ,
        .idat             ( symb_metric__odat       [1] ) ,
        //
        .isort_sop        ( ctrl__osort_sop             ) ,
        .isort_val        ( ctrl__osort_val             ) ,
        .isort_eop        ( ctrl__osort_eop             ) ,
        .ohadamard_done   (                             ) , // n.u.
        //
        .oval             ( rm_dec_b1__oval             ) ,
        .odat             ( rm_dec_b1__odat             ) ,
        .odat_metric      ( rm_dec_b1__odat_metric      )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // bits decision & output mapping
  //  DVB use inverted notation {b0, b1...b7) for PLS
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= rm_dec_b0__oval;
    end
  end

  logic [0 : 7] bit_rslt;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      odat <= rm_dec_b0__odat;
      //
      if (pXMODE) begin
        if (rm_dec_b1__odat_metric > rm_dec_b0__odat_metric) begin
          odat <= rm_dec_b1__odat;
        end
      end
      //
      if (ctrl__osort_val & ctrl__osort_eop) begin // can do so because has enogth time
        otag <= used_tag;
      end
    end
  end

endmodule

