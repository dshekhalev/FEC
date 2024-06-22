/*






  logic  ldpc_dvb_enc_mux__iclk           ;
  logic  ldpc_dvb_enc_mux__ireset         ;
  logic  ldpc_dvb_enc_mux__iclkena        ;
  //
  col_t  ldpc_dvb_enc_mux__iused_data_col ;
  //
  logic  ldpc_dvb_enc_mux__ival           ;
  col_t  ldpc_dvb_enc_mux__icol           ;
  zdat_t ldpc_dvb_enc_mux__idat           ;
  //
  logic  ldpc_dvb_enc_mux__ipval          ;
  strb_t ldpc_dvb_enc_mux__ipstrb         ;
  zdat_t ldpc_dvb_enc_mux__ipacc          ;
  zdat_t ldpc_dvb_enc_mux__ipline         ;
  //
  logic  ldpc_dvb_enc_mux__owfull         ;
  logic  ldpc_dvb_enc_mux__owrite         ;
  col_t  ldpc_dvb_enc_mux__owaddr         ;
  zdat_t ldpc_dvb_enc_mux__owdat          ;
  //
  logic  ldpc_dvb_enc_mux__opwrite        ;
  col_t  ldpc_dvb_enc_mux__opwaddr        ;



  ldpc_dvb_enc_mux
  ldpc_dvb_enc_mux
  (
    .iclk           ( ldpc_dvb_enc_mux__iclk           ) ,
    .ireset         ( ldpc_dvb_enc_mux__ireset         ) ,
    .iclkena        ( ldpc_dvb_enc_mux__iclkena        ) ,
    //
    .iused_data_col ( ldpc_dvb_enc_mux__iused_data_col ) ,
    //
    .ival           ( ldpc_dvb_enc_mux__ival           ) ,
    .icol           ( ldpc_dvb_enc_mux__icol           ) ,
    .idat           ( ldpc_dvb_enc_mux__idat           ) ,
    //
    .ipval          ( ldpc_dvb_enc_mux__ipval          ) ,
    .ipstrb         ( ldpc_dvb_enc_mux__ipstrb         ) ,
    .ipacc          ( ldpc_dvb_enc_mux__ipacc          ) ,
    .ipline         ( ldpc_dvb_enc_mux__ipline         ) ,
    //
    .owfull         ( ldpc_dvb_enc_mux__owfull         ) ,
    .owrite         ( ldpc_dvb_enc_mux__owrite         ) ,
    .owaddr         ( ldpc_dvb_enc_mux__owaddr         ) ,
    .owdat          ( ldpc_dvb_enc_mux__owdat          ) ,
    //
    .opwrite        ( ldpc_dvb_enc_mux__opwrite        ) ,
    .opwaddr        ( ldpc_dvb_enc_mux__opwaddr        )
  );


  assign ldpc_dvb_enc_mux__iclk           = '0 ;
  assign ldpc_dvb_enc_mux__ireset         = '0 ;
  assign ldpc_dvb_enc_mux__iclkena        = '0 ;
  assign ldpc_dvb_enc_mux__iused_data_col = '0 ;
  assign ldpc_dvb_enc_mux__ival           = '0 ;
  assign ldpc_dvb_enc_mux__icol           = '0 ;
  assign ldpc_dvb_enc_mux__idat           = '0 ;
  assign ldpc_dvb_enc_mux__ipval          = '0 ;
  assign ldpc_dvb_enc_mux__ipstrb         = '0 ;
  assign ldpc_dvb_enc_mux__ipacc          = '0 ;
  assign ldpc_dvb_enc_mux__ipline         = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_mux.sv
// Description   : encoder engine data/parity bits output muxer
//

module ldpc_dvb_enc_mux
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  iused_data_col ,
  //
  ival           ,
  icol           ,
  idat           ,
  //
  ipval          ,
  ipstrb         ,
  ipacc          ,
  ipline         ,
  //
  owfull         ,
  owrite         ,
  owaddr         ,
  owdat          ,
  //
  opwrite        ,
  opwaddr
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk           ;
  input  logic  ireset         ;
  input  logic  iclkena        ;
  //
  input  col_t  iused_data_col ;
  //
  input  logic  ival           ;
  input  col_t  icol           ;
  input  zdat_t idat           ;
  //
  input  logic  ipval          ;
  input  strb_t ipstrb         ;
  input  zdat_t ipacc          ;
  input  zdat_t ipline         ;
  //
  output logic  owfull         ;
  output logic  owrite         ;
  output col_t  owaddr         ;
  output zdat_t owdat          ;
  //
  output logic  opwrite        ;
  output col_t  opwaddr        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite  <= 1'b0;
      owfull  <= 1'b0;
      opwrite <= 1'b0;
    end
    else if (iclkena) begin
      owrite  <= (ival | ipval);
      owfull  <= (ipval & ipstrb.eof);
      opwrite <= ipval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival | ipval) begin
        owaddr  <= icol;
        owdat   <= idat;
        if (ipval) begin
          owaddr  <= ipstrb.sof ? iused_data_col    : (owaddr + 1'b1);
          owdat   <= ipstrb.sof ? (ipacc ^ ipline)  : (ipacc ^ owdat);
          opwaddr <= ipstrb.sof ? '0                : (opwaddr + 1'b1);
        end
      end
    end
  end

endmodule
