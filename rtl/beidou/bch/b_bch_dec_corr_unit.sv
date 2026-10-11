/*



  parameter bit pUSE_L_POLY       = 0 ;
  parameter int pLLR_W            = 4 ;
  parameter int pTAG_W            = 8 ;
  //
  parameter bit pDO_LLR_INVERSION = 0 ;



  logic                b_bch_dec_corr_unit__iclk      ;
  logic                b_bch_dec_corr_unit__ireset    ;
  logic                b_bch_dec_corr_unit__iclkena   ;
  //
  logic                b_bch_dec_corr_unit__isop      ;
  logic                b_bch_dec_corr_unit__isof      ;
  logic                b_bch_dec_corr_unit__ival      ;
  logic                b_bch_dec_corr_unit__ieop      ;
  logic                b_bch_dec_corr_unit__ieof      ;
  logic [pLLR_W-1 : 0] b_bch_dec_corr_unit__iLLR      ;
  logic                b_bch_dec_corr_unit__icand_dat ;
  logic [cDAT_W-1 : 0] b_bch_dec_corr_unit__icand_idx ;
  //
  logic                b_bch_dec_corr_unit__oval      ;
  logic [cDAT_W-1 : 0] b_bch_dec_corr_unit__odat      ;



  b_bch_dec_corr_unit
  #(
    .pUSE_L_POLY       ( pUSE_L_POLY       ) ,
    .pLLR_W            ( pLLR_W            ) ,
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  b_bch_dec_corr_unit
  (
    .iclk      ( b_bch_dec_corr_unit__iclk      ) ,
    .ireset    ( b_bch_dec_corr_unit__ireset    ) ,
    .iclkena   ( b_bch_dec_corr_unit__iclkena   ) ,
    //
    .isop      ( b_bch_dec_corr_unit__isop      ) ,
    .isof      ( b_bch_dec_corr_unit__isof      ) ,
    .ival      ( b_bch_dec_corr_unit__ival      ) ,
    .ieop      ( b_bch_dec_corr_unit__ieop      ) ,
    .ieof      ( b_bch_dec_corr_unit__ieof      ) ,
    .iLLR      ( b_bch_dec_corr_unit__iLLR      ) ,
    .icand_dat ( b_bch_dec_corr_unit__icand_dat ) ,
    .icand_idx ( b_bch_dec_corr_unit__icand_idx ) ,
    //
    .oval      ( b_bch_dec_corr_unit__oval      ) ,
    .odat      ( b_bch_dec_corr_unit__odat      )
  );


  assign b_bch_dec_corr_unit__iclk      = '0 ;
  assign b_bch_dec_corr_unit__ireset    = '0 ;
  assign b_bch_dec_corr_unit__iclkena   = '0 ;
  assign b_bch_dec_corr_unit__isop      = '0 ;
  assign b_bch_dec_corr_unit__isof      = '0 ;
  assign b_bch_dec_corr_unit__ival      = '0 ;
  assign b_bch_dec_corr_unit__ieop      = '0 ;
  assign b_bch_dec_corr_unit__ieof      = '0 ;
  assign b_bch_dec_corr_unit__iLLR      = '0 ;
  assign b_bch_dec_corr_unit__icand_dat = '0 ;
  assign b_bch_dec_corr_unit__icand_idx = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_dec_corr_unit.svh
// Description   : count codeword candidates metric via correlation & select most probably codeword
//

module b_bch_dec_corr_unit
#(
  parameter bit pUSE_L_POLY       = 0 ,
  parameter int pLLR_W            = 4 ,
  parameter int pTAG_W            = 8 ,
  //
  parameter bit pDO_LLR_INVERSION = 0
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  isop      ,
  isof      ,
  ival      ,
  ieop      ,
  ieof      ,
  iLLR      ,
  icand_dat ,
  icand_idx ,
  //
  oval      ,
  odat
);

  `include "b_bch_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = cDBIT_NUM[pUSE_L_POLY] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk      ;
  input  logic                       ireset    ;
  input  logic                       iclkena   ;
  //
  input  logic                       isop      ;
  input  logic                       isof      ;
  input  logic                       ival      ;
  input  logic                       ieop      ;
  input  logic                       ieof      ;
  input  logic signed [pLLR_W-1 : 0] iLLR      ;
  input  logic                       icand_dat ;
  input  logic        [cDAT_W-1 : 0] icand_idx ;
  //
  output logic                       oval      ;
  output logic        [cDAT_W-1 : 0] odat      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cMETRIC_W  = pLLR_W + $clog2(cBIT_NUM[pUSE_L_POLY]);

  typedef logic signed [cMETRIC_W-1 : 0] metric_t;
  typedef logic           [cDAT_W-1 : 0] idx_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  metric_t metric;
  idx_t    metric_idx;
  logic    metric_val;
  logic    metric_sop;
  logic    metric_eop;

  metric_t best_metric;
  idx_t    best_metric_idx;

  //------------------------------------------------------------------------------------------------------
  // metric count
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      metric_val <= ival & ieop;
      metric_sop <= isof;
      metric_eop <= ieof;
      //
      if (ival) begin
        if (isop) begin
          metric     <= get_metric(iLLR, icand_dat);
          metric_idx <= icand_idx;
        end
        else begin
          metric     <= metric + get_metric(iLLR, icand_dat);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decision
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= metric_val & metric_eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (metric_val) begin
        if (metric_sop) begin
          best_metric     <= metric;
          best_metric_idx <= metric_idx;
        end
        else begin
          if (metric > best_metric) begin
            best_metric     <= metric;
            best_metric_idx <= metric_idx;
          end
        end
      end
    end
  end

  assign odat = best_metric_idx;

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  function automatic metric_t get_metric (logic signed [pLLR_W-1 : 0] LLR, logic cand_bit);
  begin
    if (pLLR_W <= 1) begin
      get_metric = (LLR ^ cand_bit) ? -1 : 1; // use signed to make like soft decision
    end
    else begin
      if (pDO_LLR_INVERSION) begin
        get_metric = cand_bit ? -LLR :  LLR;
      end
      else begin
        get_metric = cand_bit ?  LLR : -LLR;
      end
    end
  end
  endfunction

endmodule
