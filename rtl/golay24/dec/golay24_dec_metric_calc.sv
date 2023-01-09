/*



  parameter int pLLR_W  = 4 ;



  logic     golay24_dec_metric_calc__iclk         ;
  logic     golay24_dec_metric_calc__ireset       ;
  logic     golay24_dec_metric_calc__iclkena      ;
  logic     golay24_dec_metric_calc__isop         ;
  logic     golay24_dec_metric_calc__ival         ;
  logic     golay24_dec_metric_calc__ieop         ;
  dat_t     golay24_dec_metric_calc__idat         ;
  logic     golay24_dec_metric_calc__ifailed      ;
  llr_t     golay24_dec_metric_calc__iLLR    [24] ;
  logic     golay24_dec_metric_calc__osop         ;
  logic     golay24_dec_metric_calc__oval         ;
  logic     golay24_dec_metric_calc__oeop         ;
  dat_t     golay24_dec_metric_calc__odat         ;
  metric_t  golay24_dec_metric_calc__ometric      ;



  golay24_dec_metric_calc
  #(
    .pLLR_W ( pLLR_W )
  )
  golay24_dec_metric_calc
  (
    .iclk    ( golay24_dec_metric_calc__iclk    ) ,
    .ireset  ( golay24_dec_metric_calc__ireset  ) ,
    .iclkena ( golay24_dec_metric_calc__iclkena ) ,
    .isop    ( golay24_dec_metric_calc__isop    ) ,
    .ival    ( golay24_dec_metric_calc__ival    ) ,
    .ieop    ( golay24_dec_metric_calc__ieop    ) ,
    .idat    ( golay24_dec_metric_calc__idat    ) ,
    .ifailed ( golay24_dec_metric_calc__ifailed ) ,
    .iLLR    ( golay24_dec_metric_calc__iLLR    ) ,
    .osop    ( golay24_dec_metric_calc__osop    ) ,
    .oval    ( golay24_dec_metric_calc__oval    ) ,
    .oeop    ( golay24_dec_metric_calc__oeop    ) ,
    .odat    ( golay24_dec_metric_calc__odat    ) ,
    .ometric ( golay24_dec_metric_calc__ometric )
  );


  assign golay24_dec_metric_calc__iclk         = '0 ;
  assign golay24_dec_metric_calc__ireset       = '0 ;
  assign golay24_dec_metric_calc__iclkena      = '0 ;
  assign golay24_dec_metric_calc__isop         = '0 ;
  assign golay24_dec_metric_calc__ival         = '0 ;
  assign golay24_dec_metric_calc__ieop         = '0 ;
  assign golay24_dec_metric_calc__idat         = '0 ;
  assign golay24_dec_metric_calc__ifailed      = '0 ;
  assign golay24_dec_metric_calc__iLLR         = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision$
// Date          : $Date$
// Workfile      : golay24_dec_candidate_gen.sv
// Description   : unit to calcualce candidate metric
//


module golay24_dec_metric_calc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat    ,
  ifailed ,
  iLLR    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  ometric
);

  `include "golay24_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk         ;
  input  logic    ireset       ;
  input  logic    iclkena      ;
  //
  input  logic    isop         ;
  input  logic    ival         ;
  input  logic    ieop         ;
  input  dat_t    idat         ;  // candidate data
  input  logic    ifailed      ;  // candidate failed flag
  input  llr_t    iLLR    [24] ;  // channel LLR
  //
  output logic    osop         ;
  output logic    oval         ;
  output logic    oeop         ;
  output dat_t    odat         ;  // candidate data
  output metric_t ometric      ;  // candidate metric

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [4 : 0] sop;
  logic [4 : 0] val;
  logic [4 : 0] eop;

  dat_t         dat    [5];

  metric_t      LLR   [24];

  metric_t      adder0 [8];
  metric_t      adder1 [4];
  metric_t      adder2 [2];
  metric_t      adder3;

  //------------------------------------------------------------------------------------------------------
  // correllate candidate data and LLR
  // mult 24 LLRs by data
  // 24 input adder tree
  //    8 adders for 3 input
  //    4 adders for 2 input
  //    2 adders for 2 input
  //    1 adders for 2 input
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | isop;
      eop <= (eop << 1) | ieop;
      // ival
      dat[0] <= idat;
      for (int i = 0; i < 24; i++) begin
        LLR[i] <= ifailed ? 0 : (idat[i] ? iLLR[i] : -iLLR[i]); // signed extension !!!
      end
      // val[0]
      dat[1] <= dat[0];
      for (int i = 0; i < 8; i++) begin
        adder0[i] <= LLR[3*i + 0] + LLR[3*i + 1] + LLR[3*i + 2];
      end
      // val[1]
      dat[2] <= dat[1];
      for (int i = 0; i < 4; i++) begin
        adder1[i] <= adder0[2*i + 0] + adder0[2*i + 1];
      end
      // val[2]
      dat[3]    <= dat[2];
      adder2[0] <= adder1[0] + adder1[1];
      adder2[1] <= adder1[2] + adder1[3];
      // val[3]
      dat[4]    <= dat[3];
      adder3    <= adder2[0] + adder2[1];
    end
  end

  assign osop    = sop [4];
  assign oval    = val [4];
  assign oeop    = eop [4];
  assign odat    = dat [4];
  assign ometric = adder3;

endmodule
