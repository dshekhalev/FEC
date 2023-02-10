/*



  parameter int pDAT_W = 4 ;



  logic                dvb_pls_dec_rm_dec__iclk             ;
  logic                dvb_pls_dec_rm_dec__ireset           ;
  logic                dvb_pls_dec_rm_dec__iclkena          ;
  //
  logic                dvb_pls_dec_rm_dec__isop             ;
  logic                dvb_pls_dec_rm_dec__ival             ;
  logic                dvb_pls_dec_rm_dec__ieop             ;
  logic                dvb_pls_dec_rm_dec__iadd_n_sub       ;
  metric_idx_t         dvb_pls_dec_rm_dec__iidx             ;
  metric_t             dvb_pls_dec_rm_dec__idat             ;
  metric_t             dvb_pls_dec_rm_dec__imetric_sub      ;
  //
  logic                dvb_pls_dec_rm_dec__isort_sop        ;
  logic                dvb_pls_dec_rm_dec__isort_val        ;
  logic                dvb_pls_dec_rm_dec__isort_eop        ;
  logic                dvb_pls_dec_rm_dec__ohadamard_done   ;
  //
  logic                dvb_pls_dec_rm_dec__obit6_metric_val ;
  metric_sum_t         dvb_pls_dec_rm_dec__obit6_metric     ;
  //
  logic                dvb_pls_dec_rm_dec__oval             ;
  logic        [5 : 0] dvb_pls_dec_rm_dec__odat             ;



  dvb_pls_dec_rm_dec
  #(
    .pDAT_W ( pDAT_W )
  )
  dvb_pls_dec_rm_dec
  (
    .iclk              ( dvb_pls_dec_rm_dec__iclk              ) ,
    .ireset            ( dvb_pls_dec_rm_dec__ireset            ) ,
    .iclkena           ( dvb_pls_dec_rm_dec__iclkena           ) ,
    //
    .isop              ( dvb_pls_dec_rm_dec__isop              ) ,
    .ival              ( dvb_pls_dec_rm_dec__ival              ) ,
    .ieop              ( dvb_pls_dec_rm_dec__ieop              ) ,
    .iadd_n_sub        ( dvb_pls_dec_rm_dec__iadd_n_sub        ) ,
    .iidx              ( dvb_pls_dec_rm_dec__iidx              ) ,
    .idat              ( dvb_pls_dec_rm_dec__idat              ) ,
    //
    .isort_sop         ( dvb_pls_dec_rm_dec__isort_sop         ) ,
    .isort_val         ( dvb_pls_dec_rm_dec__isort_val         ) ,
    .isort_eop         ( dvb_pls_dec_rm_dec__isort_eop         ) ,
    .ohadamard_done    ( dvb_pls_dec_rm_dec__ohadamard_done    ) ,
    //
    .obit6_metric_oval ( dvb_pls_dec_rm_dec__obit6_metric_oval ) ,
    .obit6_metric      ( dvb_pls_dec_rm_dec__obit6_metric      ) ,
    //
    .oval              ( dvb_pls_dec_rm_dec__oval              ) ,
    .odat              ( dvb_pls_dec_rm_dec__odat              )
  );


  assign dvb_pls_dec_rm_dec__iclk       = '0 ;
  assign dvb_pls_dec_rm_dec__ireset     = '0 ;
  assign dvb_pls_dec_rm_dec__iclkena    = '0 ;
  assign dvb_pls_dec_rm_dec__isop       = '0 ;
  assign dvb_pls_dec_rm_dec__ival       = '0 ;
  assign dvb_pls_dec_rm_dec__ieop       = '0 ;
  assign dvb_pls_dec_rm_dec__iadd_n_sub = '0 ;
  assign dvb_pls_dec_rm_dec__iidx       = '0 ;
  assign dvb_pls_dec_rm_dec__idat       = '0 ;
  assign dvb_pls_dec_rm_dec__isort_sop  = '0 ;
  assign dvb_pls_dec_rm_dec__isort_val  = '0 ;
  assign dvb_pls_dec_rm_dec__isort_eop  = '0 ;



*/

//
// Project       : PLS DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pls_dec_rm_dec.sv
// Description   : Read-Muller 1 order decoder based upon Hadamard32 transform with maximum likelihood metric
//


module dvb_pls_dec_rm_dec
(
  iclk             ,
  ireset           ,
  iclkena          ,
  //
  isop             ,
  ival             ,
  ieop             ,
  iadd_n_sub       ,
  iidx             ,
  idat             ,
  //
  isort_sop        ,
  isort_val        ,
  isort_eop        ,
  ohadamard_done   ,
  //
  obit6_metric_val ,
  obit6_metric     ,
  //
  oval             ,
  odat
);

  `include "dvb_pls_dec_types.svh"
  `include "dvb_pls_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk             ;
  input  logic                ireset           ;
  input  logic                iclkena          ;
  // input data inteface
  input  logic                isop             ;
  input  logic                ival             ;
  input  logic                ieop             ;
  input  logic                iadd_n_sub       ;
  input  metric_idx_t         iidx             ;
  input  metric_t             idat             ;
  // control interface
  input  logic                isort_sop        ;
  input  logic                isort_val        ;
  input  logic                isort_eop        ;
  output logic                ohadamard_done   ;
  // bit 6 soft decision interface
  output logic                obit6_metric_val ;
  output metric_sum_t         obit6_metric     ;
  // bit [5 : 0] hard decision interface
  output logic                oval             ;
  output logic        [5 : 0] odat             ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // hadamard32 row mult
  logic           mult_sop;
  logic           mult_val;
  logic           mult_eop;
  logic           mult_add_n_sub;

  logic [31 : 0]  mult_sel_add_n_sub;
  metric_t        mult2add;
  metric_t        mult2sub;

  //
  // hadamard col sum
  metric_sum_t  sum_add [32];
  metric_sum_t  sum_sub [32];

  //
  //
  logic         sum2sort_sop;
  logic         sum2sort_val;
  logic         sum2sort_eop;
  metric_idx_t  sum2sort_idx;
  //
  metric_sum_t  sum_add_abs;
  metric_sum_t  sum_sub_abs;
  logic         sum_add_sign;
  logic         sum_sub_sign;
  //
  //
  logic         max_val;

  metric_sum_t  max_add;
  metric_idx_t  max_idx_add;
  logic         max_sign_add;

  metric_sum_t  max_sub;
  metric_idx_t  max_idx_sub;
  logic         max_sign_sub;

  //------------------------------------------------------------------------------------------------------
  // mult by hadamard32 row
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      mult_val <= 1'b0;
    end
    else if (iclkena) begin
      mult_val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      mult_sop        <= isop;
      mult_eop        <= ieop;
      mult_add_n_sub  <= iadd_n_sub;
      //
      mult2add        <=  idat;
      mult2sub        <= -idat;
      for (int w = 0; w < 32; w++) begin
        mult_sel_add_n_sub[w] <= cHADAMARD32[w][iidx];
      end
    end
  end

  // 1 tick before
  assign ohadamard_done = mult_val & mult_eop & !mult_add_n_sub;

  //------------------------------------------------------------------------------------------------------
  // sum hadamard32 col
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // serial shift for simple sort
      if (isort_val) begin
        for (int w = 0; w < 31; w++) begin
          sum_add[w] <= sum_add[w+1];
          sum_sub[w] <= sum_sub[w+1];
        end
      end
      else begin
        if (mult_val) begin
          for (int w = 0; w < 32; w++) begin
            if (mult_add_n_sub) begin
              sum_add[w] <= (mult_sop ? 0 : sum_add[w]) + (mult_sel_add_n_sub[w] ? mult2add : mult2sub);
            end
            else begin
              sum_sub[w] <= (mult_sop ? 0 : sum_sub[w]) + (mult_sel_add_n_sub[w] ? mult2add : mult2sub);
            end
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // data 2 sort
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sum2sort_sop <= isort_sop;
      sum2sort_val <= isort_val;
      sum2sort_eop <= isort_eop;
      if (isort_val) begin
        sum2sort_idx <= isort_sop ? '0 : (sum2sort_idx + 1'b1);
      end
      //
      sum_add_abs  <= abs_metric_sum(sum_add[0]);
      sum_sub_abs  <= abs_metric_sum(sum_sub[0]);
      //
      sum_add_sign <= (sum_add[0] >= 0);
      sum_sub_sign <= (sum_sub[0] >= 0);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // serial sort units
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      max_val <= sum2sort_val & sum2sort_eop;
      //
      if (sum2sort_val) begin
        if (sum2sort_sop) begin
          max_add       <= sum_add_abs;
          max_idx_add   <= sum2sort_idx;
          max_sign_add  <= sum_add_sign;
          //
          max_sub       <= sum_sub_abs;
          max_idx_sub   <= sum2sort_idx;
          max_sign_sub  <= sum_sub_sign;
        end
        else begin
          if (sum_add_abs > max_add) begin
            max_add       <= sum_add_abs;
            max_idx_add   <= sum2sort_idx;
            max_sign_add  <= sum_add_sign;
          end
          //
          if (sum_sub_abs > max_sub) begin
            max_sub       <= sum_sub_abs;
            max_idx_sub   <= sum2sort_idx;
            max_sign_sub  <= sum_sub_sign;
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // bit 6 path 1 metric
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      obit6_metric_val <= max_val;
      obit6_metric     <= max_sub - max_add;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // do decode must be 3 tick to allign external bi6 logic
  //------------------------------------------------------------------------------------------------------

  logic  [2 : 0] val;

  logic          decode_add_n_sum;
  logic [31 : 0] decode_bits_add;
  logic [31 : 0] decode_bits_sub;

  logic [31 : 0] decode_bits;
  logic          decode_sign;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | max_val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      decode_add_n_sum  <= (max_add >= max_sub);
      decode_bits_add   <= cHADAMARD32[max_idx_add];
      decode_bits_sub   <= cHADAMARD32[max_idx_sub];
      //
      decode_bits       <= decode_add_n_sum ? decode_bits_add : decode_bits_sub;
      decode_sign       <= decode_add_n_sum ? max_sign_add    : max_sign_sub;
      //
      odat[0]           <= decode_bits[0] ^ decode_sign;
      odat[5]           <= decode_bits[0] ^ decode_bits[1];
      odat[4]           <= decode_bits[0] ^ decode_bits[2];
      odat[3]           <= decode_bits[0] ^ decode_bits[4];
      odat[2]           <= decode_bits[0] ^ decode_bits[8];
      odat[1]           <= decode_bits[0] ^ decode_bits[16];
    end
  end

  assign oval = val[2];

endmodule

