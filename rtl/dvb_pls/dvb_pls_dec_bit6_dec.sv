/*



  parameter int pDAT_W = 4 ;



  logic        dvb_pls_dec_bit6_dec__iclk        ;
  logic        dvb_pls_dec_bit6_dec__ireset      ;
  logic        dvb_pls_dec_bit6_dec__iclkena     ;
  //
  logic        dvb_pls_dec_bit6_dec__isop        ;
  logic        dvb_pls_dec_bit6_dec__ival        ;
  logic        dvb_pls_dec_bit6_dec__ieop        ;
  logic        dvb_pls_dec_bit6_dec__iadd_n_sub  ;
  metric_t     dvb_pls_dec_bit6_dec__idat        ;
  //
  logic        dvb_pls_dec_bit6_dec__ometric_val ;
  metric_sum_t dvb_pls_dec_bit6_dec__ometric     ;



  dvb_pls_dec_bit6_dec
  #(
    .pDAT_W ( pDAT_W )
  )
  dvb_pls_dec_bit6_dec
  (
    .iclk        ( dvb_pls_dec_bit6_dec__iclk        ) ,
    .ireset      ( dvb_pls_dec_bit6_dec__ireset      ) ,
    .iclkena     ( dvb_pls_dec_bit6_dec__iclkena     ) ,
    //
    .isop        ( dvb_pls_dec_bit6_dec__isop        ) ,
    .ival        ( dvb_pls_dec_bit6_dec__ival        ) ,
    .ieop        ( dvb_pls_dec_bit6_dec__ieop        ) ,
    .iadd_n_sub  ( dvb_pls_dec_bit6_dec__iadd_n_sub  ) ,
    .idat        ( dvb_pls_dec_bit6_dec__idat        ) ,
    //
    .ometric_val ( dvb_pls_dec_bit6_dec__ometric_val ) ,
    .ometric     ( dvb_pls_dec_bit6_dec__ometric     )
  );


  assign dvb_pls_dec_bit6_dec__iclk        = '0 ;
  assign dvb_pls_dec_bit6_dec__ireset      = '0 ;
  assign dvb_pls_dec_bit6_dec__iclkena     = '0 ;
  assign dvb_pls_dec_bit6_dec__isop        = '0 ;
  assign dvb_pls_dec_bit6_dec__ival        = '0 ;
  assign dvb_pls_dec_bit6_dec__ieop        = '0 ;
  assign dvb_pls_dec_bit6_dec__iadd_n_sub  = '0 ;
  assign dvb_pls_dec_bit6_dec__idat        = '0 ;



*/

//
// Project       : PLS DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pls_dec_bit6_dec.sv
// Description   : DVB PLS bit 6 maximum likelihood decoder
//


module dvb_pls_dec_bit6_dec
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  isop        ,
  ival        ,
  ieop        ,
  iadd_n_sub  ,
  idat        ,
  //
  ometric_val ,
  ometric
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
  input  logic        iadd_n_sub  ;
  input  metric_t     idat        ;
  //
  output logic        ometric_val ; // bit6 metric
  output metric_sum_t ometric     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         sop;
  logic         val;
  logic         eop;
  logic         add_n_sub;
  metric_t      abs_dat;

  logic         sum_val;
  metric_sum_t  metric_sum_add;
  metric_sum_t  metric_sum_sub;

  //------------------------------------------------------------------------------------------------------
  // get abs
  //------------------------------------------------------------------------------------------------------

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
      sop       <= isop;
      eop       <= ieop;
      add_n_sub <= iadd_n_sub;
      abs_dat   <= abs_metric(idat);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // count metric accumulate data
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      sum_val <= 1'b0;
    end
    else if (iclkena) begin
      sum_val <= val & eop & !add_n_sub;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val) begin
        if (add_n_sub) begin
          metric_sum_add <= sop ? abs_dat : (metric_sum_add + abs_dat);
        end
        else begin
          metric_sum_sub <= sop ? abs_dat : (metric_sum_sub + abs_dat);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // bit 6 metric
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ometric_val <= 1'b0;
    end
    else if (iclkena) begin
      ometric_val <= sum_val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (sum_val) begin
        ometric <= metric_sum_sub - metric_sum_add;
      end
    end
  end

endmodule
