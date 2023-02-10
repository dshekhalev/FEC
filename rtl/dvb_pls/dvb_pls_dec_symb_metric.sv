/*



  parameter int pDAT_W = 4 ;



  logic        dvb_pls_dec_symb_metric__iclk        ;
  logic        dvb_pls_dec_symb_metric__ireset      ;
  logic        dvb_pls_dec_symb_metric__iclkena     ;
  //
  logic        dvb_pls_dec_symb_metric__isop        ;
  logic        dvb_pls_dec_symb_metric__ival        ;
  logic        dvb_pls_dec_symb_metric__ieop        ;
  dat_t        dvb_pls_dec_symb_metric__idat        ;
  //
  logic        dvb_pls_dec_symb_metric__osop        ;
  logic        dvb_pls_dec_symb_metric__oval        ;
  logic        dvb_pls_dec_symb_metric__oeop        ;
  logic        dvb_pls_dec_symb_metric__oadd_n_sub  ;
  metric_idx_t dvb_pls_dec_symb_metric__oidx        ;
  metric_t     dvb_pls_dec_symb_metric__odat        ;



  dvb_pls_dec_symb_metric
  #(
    .pDAT_W ( pDAT_W )
  )
  dvb_pls_dec_symb_metric
  (
    .iclk        ( dvb_pls_dec_symb_metric__iclk        ) ,
    .ireset      ( dvb_pls_dec_symb_metric__ireset      ) ,
    .iclkena     ( dvb_pls_dec_symb_metric__iclkena     ) ,
    //
    .isop        ( dvb_pls_dec_symb_metric__isop        ) ,
    .ival        ( dvb_pls_dec_symb_metric__ival        ) ,
    .ieop        ( dvb_pls_dec_symb_metric__ieop        ) ,
    .idat        ( dvb_pls_dec_symb_metric__idat        ) ,
    //
    .osop        ( dvb_pls_dec_symb_metric__osop        ) ,
    .oval        ( dvb_pls_dec_symb_metric__oval        ) ,
    .oeop        ( dvb_pls_dec_symb_metric__oeop        ) ,
    .oadd_n_sub  ( dvb_pls_dec_symb_metric__oadd_n_sub  ) ,
    .oidx        ( dvb_pls_dec_symb_metric__oidx        ) ,
    .odat        ( dvb_pls_dec_symb_metric__odat        )
  );


  assign dvb_pls_dec_symb_metric__iclk    = '0 ;
  assign dvb_pls_dec_symb_metric__ireset  = '0 ;
  assign dvb_pls_dec_symb_metric__iclkena = '0 ;
  assign dvb_pls_dec_symb_metric__isop    = '0 ;
  assign dvb_pls_dec_symb_metric__ival    = '0 ;
  assign dvb_pls_dec_symb_metric__ieop    = '0 ;
  assign dvb_pls_dec_symb_metric__idat    = '0 ;



*/

//
// Project       : PLS DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pls_dec_symb_metric.sv
// Description   : Module to get even/odd metrics in sequential form to optimize resources
//


module dvb_pls_dec_symb_metric
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  isop        ,
  ival        ,
  ieop        ,
  idat        ,
  //
  osop        ,
  oval        ,
  oeop        ,
  oadd_n_sub  ,
  oidx        ,
  odat
);

  `include "dvb_pls_dec_types.svh"
  `include "dvb_pls_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic        iclk        ;
  input  logic        ireset      ;
  input  logic        iclkena     ;
  //
  input  logic        isop        ;
  input  logic        ival        ;
  input  logic        ieop        ;
  input  dat_t        idat        ;
  //
  output logic        osop        ;
  output logic        oval        ;
  output logic        oeop        ;
  output logic        oadd_n_sub  ;
  output metric_idx_t oidx        ;
  output metric_t     odat        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_W = $clog2(64);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                 descr_bit;
  logic  [cCNT_W-1 : 0] descr_cnt;

  logic                 dat_sop;
  logic                 dat_val;
  logic                 dat_eop;
  dat_t                 dat;
  dat_t                 dat_pre;

  logic                 metric_sop;
  logic                 metric_val;
  logic                 metric_eop;
  metric_t              metric_add;
  metric_t              metric_sub;

  //------------------------------------------------------------------------------------------------------
  // saturation & decsrambler
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      dat_val <= 1'b0;
    end
    else if (iclkena) begin
      dat_val <= ival & !isop & descr_cnt[0];
    end
  end

  assign descr_bit = isop ? cSCRAMBLE_WORD[0] : cSCRAMBLE_WORD[descr_cnt];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dat_eop <= ieop;
      //
      if (ival) begin
        descr_cnt <= isop ?  1 : (descr_cnt + 1'b1);
        //
        if (&{idat[pDAT_W-1], ~idat[pDAT_W-2 : 0]}) begin // -2^(N-1)
          dat <= descr_bit ? {1'b0, {(pDAT_W-2){1'b1}}, 1'b1} : //  (2^(N-1) - 1)
                             {1'b1, {(pDAT_W-2){1'b0}}, 1'b1};  // -(2^(N-1) - 1)
        end
        else begin
          dat <= descr_bit ? -idat : idat;
        end
        //
        dat_pre <= dat;
      end
      //
      if (ival & isop) begin
        dat_sop <= 1'b1;
      end
      else if (dat_val) begin
        dat_sop <= 1'b0;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // get add/sub symbol
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      metric_val <= 1'b0;
    end
    else if (iclkena) begin
      metric_val <= dat_val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (dat_val) begin
        metric_sop  <= dat_sop;
        metric_eop  <= dat_eop;
        metric_add  <= dat_pre + dat;
        metric_sub  <= dat_pre - dat;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // serialize stream
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] val;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= metric_val ? 2'b11 : (val << 1);
    end
  end

  assign oval = val[1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (metric_val) begin
        osop <= metric_sop;
        oeop <= metric_eop;
        oidx <= metric_sop ? '0 : (oidx + 1'b1);
      end
      odat       <= metric_val ? metric_add : metric_sub;
      oadd_n_sub <= metric_val;
    end
  end

endmodule
