/*



  parameter int pLLR_W    = 4 ;
  parameter int pTAG_W    = 4 ;
  parameter int pIDX_NUM  = 4 ;



  logic    golay24_dec_source__iclk                  ;
  logic    golay24_dec_source__ireset                ;
  logic    golay24_dec_source__iclkena               ;
  logic    golay24_dec_source__isop                  ;
  logic    golay24_dec_source__ival                  ;
  logic    golay24_dec_source__ieop                  ;
  tag_t    golay24_dec_source__itag                  ;
  llr_t    golay24_dec_source__iLLR                  ;
  logic    golay24_dec_source__oval                  ;
  tag_t    golay24_dec_source__otag                  ;
  data_t   golay24_dec_source__och_hd                ;
  metric_t golay24_dec_source__och_metric            ;
  llr_t    golay24_dec_source__oLLR             [24] ;
  idx_t    golay24_dec_source__oidx       [pIDX_NUM] ;



  golay24_dec_source
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pTAG_W   ( pTAG_W   ) ,
    .pIDX_NUM ( pIDX_NUM )
  )
  golay24_dec_source
  (
    .iclk       ( golay24_dec_source__iclk       ) ,
    .ireset     ( golay24_dec_source__ireset     ) ,
    .iclkena    ( golay24_dec_source__iclkena    ) ,
    .isop       ( golay24_dec_source__isop       ) ,
    .ival       ( golay24_dec_source__ival       ) ,
    .ieop       ( golay24_dec_source__ieop       ) ,
    .itag       ( golay24_dec_source__itag       ) ,
    .iLLR       ( golay24_dec_source__iLLR       ) ,
    .oval       ( golay24_dec_source__oval       ) ,
    .otag       ( golay24_dec_source__otag       ) ,
    .och_hd     ( golay24_dec_source__och_hd     ) ,
    .och_metric ( golay24_dec_source__och_metric ) ,
    .oLLR       ( golay24_dec_source__oLLR       ) ,
    .oidx       ( golay24_dec_source__oidx       )
  );


  assign golay24_dec_source__iclk    = '0 ;
  assign golay24_dec_source__ireset  = '0 ;
  assign golay24_dec_source__iclkena = '0 ;
  assign golay24_dec_source__isop    = '0 ;
  assign golay24_dec_source__ival    = '0 ;
  assign golay24_dec_source__ieop    = '0 ;
  assign golay24_dec_source__itag    = '0 ;
  assign golay24_dec_source__iLLR    = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Workfile      : golay24_dec_source.sv
// Description   : golay soft decoder source unit: saturate input LLRs, count channel metric
//                  detect least reliable LLR indexes for candidate generation
//

module golay24_dec_source
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  isop       ,
  ival       ,
  ieop       ,
  itag       ,
  iLLR       ,
  //
  oval       ,
  otag       ,
  och_hd     ,
  och_metric ,
  oLLR       ,
  oidx
);

  parameter int pIDX_NUM  = 4;

  `include "golay24_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk                  ;
  input  logic    ireset                ;
  input  logic    iclkena               ;
  //
  input  logic    isop                  ;
  input  logic    ival                  ;
  input  logic    ieop                  ;
  input  tag_t    itag                  ;
  input  llr_t    iLLR                  ;
  //
  output logic    oval                  ;
  output tag_t    otag                  ;
  output dat_t    och_hd                ; // channel hard decision
  output metric_t och_metric            ; // channel metric
  output llr_t    oLLR             [24] ; // saturated LLR
  output idx_t    oidx       [pIDX_NUM] ; // least reliable LLRs indexes

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic sop;
  logic val;
  logic eop;

  tag_t tag;

  llr_t LLR;
  llr_t aLLR;
  idx_t aLLR_idx;

  //------------------------------------------------------------------------------------------------------
  // take abs
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      sop <= 1'b0;
      val <= 1'b0;
      eop <= 1'b0;
    end
    else if (iclkena) begin
      sop <= isop & ival;
      val <= ival ;
      eop <= ieop & ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (&{iLLR[pLLR_W-1], ~iLLR[pLLR_W-2 : 0]}) begin // -2^(N-1)
          LLR   <= {1'b1, {(pLLR_W-2){1'b0}}, 1'b1};    // -(2^(N-1) - 1)
          aLLR  <= {1'b0, {(pLLR_W-2){1'b1}}, 1'b1};    //  (2^(N-1) - 1)
        end
        else begin
          LLR   <=  iLLR;
          aLLR  <= (iLLR ^ {pLLR_W{iLLR[pLLR_W-1]}}) + iLLR[pLLR_W-1];
        end
        aLLR_idx  <= isop ? '0 : (aLLR_idx + 1'b1);
        tag       <= itag;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // assemble data
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val) begin
        for (int i = 23; i >= 0; i--) begin
          oLLR[i] <= (i == 23) ? LLR : oLLR[i+1];
        end
      end
      //
      if (sop) begin
        otag <= tag;
      end
    end
  end

  always_comb begin
    for (int i = 0; i < 24; i++) begin
      och_hd[i] = !oLLR[i][pLLR_W-1];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // count channel metric
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val) begin
        och_metric <= sop ? aLLR : (och_metric + aLLR);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // looking for least relaible symbols
  //------------------------------------------------------------------------------------------------------

  golay24_dec_sort_list
  #(
    .pDAT_W   ( pLLR_W       ) ,
    .pIDX_W   ( $size(idx_t) ) ,
    .pIDX_NUM ( pIDX_NUM     )
  )
  sort_list
  (
    .iclk    ( iclk     ) ,
    .ireset  ( ireset   ) ,
    .iclkena ( iclkena  ) ,
    //
    .iload   ( sop      ) ,
    .ival    ( val      ) ,
    .idat    ( aLLR     ) ,
    .iidx    ( aLLR_idx ) ,
    //
    .odat    (          ) ,
    .oidx    ( oidx     )
  );

  //------------------------------------------------------------------------------------------------------
  // data is ready
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= eop;
    end
  end

endmodule
