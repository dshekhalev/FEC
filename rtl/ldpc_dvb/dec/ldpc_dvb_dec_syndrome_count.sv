/*






  logic  ldpc_dvb_dec_syndrome_count__iclk      ;
  logic  ldpc_dvb_dec_syndrome_count__ireset    ;
  logic  ldpc_dvb_dec_syndrome_count__iclkena   ;
  //
  logic  ldpc_dvb_dec_syndrome_count__istart    ;
  //
  logic  ldpc_dvb_dec_syndrome_count__ival      ;
  strb_t ldpc_dvb_dec_syndrome_count__istrb     ;
  zdat_t ldpc_dvb_dec_syndrome_count__ivnode_hd ;
  //
  logic  ldpc_dvb_dec_syndrome_count__oval      ;
  logic  ldpc_dvb_dec_syndrome_count__odat      ;



  ldpc_dvb_dec_syndrome_count
  ldpc_dvb_dec_syndrome_count
  (
    .iclk      ( ldpc_dvb_dec_syndrome_count__iclk      ) ,
    .ireset    ( ldpc_dvb_dec_syndrome_count__ireset    ) ,
    .iclkena   ( ldpc_dvb_dec_syndrome_count__iclkena   ) ,
    //
    .istart    ( ldpc_dvb_dec_syndrome_count__istart    ) ,
    //
    .ival      ( ldpc_dvb_dec_syndrome_count__ival      ) ,
    .istrb     ( ldpc_dvb_dec_syndrome_count__istrb     ) ,
    .ivnode_hd ( ldpc_dvb_dec_syndrome_count__ivnode_hd ) ,
    //
    .oval      ( ldpc_dvb_dec_syndrome_count__oval      ) ,
    .odat      ( ldpc_dvb_dec_syndrome_count__odat      )
  );


  assign ldpc_dvb_dec_syndrome_count__iclk      = '0 ;
  assign ldpc_dvb_dec_syndrome_count__ireset    = '0 ;
  assign ldpc_dvb_dec_syndrome_count__iclkena   = '0 ;
  assign ldpc_dvb_dec_syndrome_count__istart    = '0 ;
  assign ldpc_dvb_dec_syndrome_count__ival      = '0 ;
  assign ldpc_dvb_dec_syndrome_count__istrb     = '0 ;
  assign ldpc_dvb_dec_syndrome_count__ivnode_hd = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_syndrome_count.sv
// Description   : Syndrome counter for fast output mode
//

module ldpc_dvb_dec_syndrome_count
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  istart    ,
  //
  ival      ,
  istrb     ,
  ivnode_hd ,
  //
  oval      ,
  odat
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk      ;
  input  logic  ireset    ;
  input  logic  iclkena   ;
  //
  input  logic  istart    ;
  //
  input  logic  ival      ;
  input  strb_t istrb     ;
  input  zdat_t ivnode_hd ;
  //
  output logic  oval      ;
  output logic  odat      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic  syndrome_val;
  zdat_t syndrome;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      syndrome_val <= 1'b0;
      oval         <= 1'b0;
    end
    else if (iclkena) begin
      syndrome_val <= ival & istrb.eop;
      oval         <= syndrome_val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // count syndrome by row
      if (ival) begin
        syndrome <= istrb.sop ? ivnode_hd : (syndrome ^ ivnode_hd);
      end
      // accumulate syndromes
      if (ival & istrb.sop & istrb.sof) begin
        odat <= '0;
      end
      else if (syndrome_val) begin
        odat <= odat | (|syndrome);
      end
    end
  end

endmodule
