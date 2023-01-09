/*



  parameter int pLLR_W  = 1 ;
  parameter int pTAG_W  = 1 ;



  logic         golay24_dec_decision__iclk          ;
  logic         golay24_dec_decision__ireset        ;
  logic         golay24_dec_decision__iclkena       ;
  logic         golay24_dec_decision__isop          ;
  logic         golay24_dec_decision__ival          ;
  logic         golay24_dec_decision__ieop          ;
  tag_t         golay24_dec_decision__itag          ;
  dat_t         golay24_dec_decision__ich_hd        ;
  metric_t      golay24_dec_decision__ich_metric    ;
  dat_t         golay24_dec_decision__icand_dat     ;
  metric_t      golay24_dec_decision__icand_metric  ;
  logic         golay24_dec_decision__oval          ;
  tag_t         golay24_dec_decision__otag          ;
  dat_t         golay24_dec_decision__odat          ;
  logic [3 : 0] golay24_dec_decision__oerr          ;



  golay24_dec_decision
  #(
    .pLLR_W ( pLLR_W ) ,
    .pTAG_W ( pTAG_W )
  )
  golay24_dec_decision
  (
    .iclk         ( golay24_dec_decision__iclk         ) ,
    .ireset       ( golay24_dec_decision__ireset       ) ,
    .iclkena      ( golay24_dec_decision__iclkena      ) ,
    .isop         ( golay24_dec_decision__isop         ) ,
    .ival         ( golay24_dec_decision__ival         ) ,
    .ieop         ( golay24_dec_decision__ieop         ) ,
    .itag         ( golay24_dec_decision__itag         ) ,
    .ich_hd       ( golay24_dec_decision__ich_hd       ) ,
    .ich_metric   ( golay24_dec_decision__ich_metric   ) ,
    .icand_dat    ( golay24_dec_decision__icand_dat    ) ,
    .icand_metric ( golay24_dec_decision__icand_metric ) ,
    .oval         ( golay24_dec_decision__oval         ) ,
    .otag         ( golay24_dec_decision__otag         ) ,
    .odat         ( golay24_dec_decision__odat         ) ,
    .oerr         ( golay24_dec_decision__oerr         )
  );


  assign golay24_dec_decision__iclk         = '0 ;
  assign golay24_dec_decision__ireset       = '0 ;
  assign golay24_dec_decision__iclkena      = '0 ;
  assign golay24_dec_decision__isop         = '0 ;
  assign golay24_dec_decision__ival         = '0 ;
  assign golay24_dec_decision__ieop         = '0 ;
  assign golay24_dec_decision__itag         = '0 ;
  assign golay24_dec_decision__ich_hd       = '0 ;
  assign golay24_dec_decision__ich_metric   = '0 ;
  assign golay24_dec_decision__icand_dat    = '0 ;
  assign golay24_dec_decision__icand_metric = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision$
// Date          : $Date$
// Workfile      : golay24_dec_decision.sv
// Description   : ML sequential search unit: count candidate metric euclidean distance to channel metric and select candidate with mininum distance
//


module golay24_dec_decision
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  isop         ,
  ival         ,
  ieop         ,
  itag         ,
  //
  ich_hd       ,
  ich_metric   ,
  //
  icand_dat    ,
  icand_metric ,
  //
  oval         ,
  otag         ,
  odat         ,
  oerr
);

  `include "golay24_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk          ;
  input  logic         ireset        ;
  input  logic         iclkena       ;
  //
  input  logic         isop          ;
  input  logic         ival          ;
  input  logic         ieop          ;
  input  tag_t         itag          ;
  //
  input  dat_t         ich_hd        ;  // channel hd
  input  metric_t      ich_metric    ;  // channel metric
  //
  input  dat_t         icand_dat     ;  // candidate data
  input  metric_t      icand_metric  ;  // candidate metric
  //
  output logic         oval          ;
  output tag_t         otag          ;
  output dat_t         odat          ;
  output logic [3 : 0] oerr          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic sop;
  logic val;
  logic eop;

  tag_t   tag;

  dat_t   ch_hd;

  metric_t cand_diff;
  metric_t cand_dist;
  dat_t    cand_dat;

  metric_t min_dist;
  dat_t    min_dat ;

  logic    search_done;

  //------------------------------------------------------------------------------------------------------
  //
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
      sop <= isop;
      eop <= ieop;
      //
      if (ival & isop) begin
        ch_hd <= ich_hd;
        tag   <= itag;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // get candidate distance
  //------------------------------------------------------------------------------------------------------

  assign cand_diff = icand_metric - ich_metric;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        cand_dat  <= icand_dat;
        // get candidate distance
        cand_dist <= (cand_diff ^ {cMETRIC_W{cand_diff[cMETRIC_W-1]}}) + cand_diff[cMETRIC_W-1];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // select ML candidate
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      search_done <= 1'b0;
    end
    else if (iclkena) begin
      search_done <= val & eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val) begin
        if (sop) begin
          min_dist <= cand_dist;
          min_dat  <= cand_dat;
        end
        else if (cand_dist < min_dist) begin
          min_dist <= cand_dist;
          min_dat  <= cand_dat;
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // search result
  //  do 2 cycle error adding by move oval pulse to 1 cycle because have enougth time (24 vs 17 clocks)
  //------------------------------------------------------------------------------------------------------

  logic         val2out;
  logic [3 : 0] err [2];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      {oval, val2out} <= 1'b0;
    end
    else if (iclkena) begin
      {oval, val2out} <= {val2out, search_done};
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (search_done) begin
        otag    <= tag;
        odat    <= min_dat;
        err[0]  <= get_errors(min_dat[11 :  0] ^ ch_hd[11 :  0]);
        err[1]  <= get_errors(min_dat[23 : 12] ^ ch_hd[23 : 12]);
      end
      //
      if (val2out) begin
        oerr <= err[0] + err[1];;
      end
    end
  end

  function bit [3 : 0] get_errors (dat_t biterr);
    get_errors = 0;
    for (int i = 0; i < 12; i++) begin
      get_errors += biterr[i];
    end
  endfunction

endmodule
