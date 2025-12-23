/*



  parameter int pDAT_W    = 360 ;
  parameter int pTR_DAT_W =   8 ;
  parameter int pSHIFT_W  =   8 ;



  logic                   ldpc_dvb_enc_transponse_acc__iclk    ;
  logic                   ldpc_dvb_enc_transponse_acc__ireset  ;
  logic                   ldpc_dvb_enc_transponse_acc__iclkena ;
  //
  logic                   ldpc_dvb_enc_transponse_acc__ival    ;
  logic                   ldpc_dvb_enc_transponse_acc__iload   ;
  logic                   ldpc_dvb_enc_transponse_acc__iwrite  ;
  logic  [pSHIFT_W-1 : 0] ldpc_dvb_enc_transponse_acc__ishift  ;
  logic [pTR_DAT_W-1 : 0] ldpc_dvb_enc_transponse_acc__idat    ;
  //
  logic                   ldpc_dvb_enc_transponse_acc__owrite  ;
  logic    [pDAT_W-1 : 0] ldpc_dvb_enc_transponse_acc__owdat   ;



  ldpc_dvb_enc_transponse_acc
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pTR_DAT_W ( pTR_DAT_W ) ,
    .pSHIFT_W  ( pSHIFT_W  )
  )
  ldpc_dvb_enc_transponse_acc
  (
    .iclk    ( ldpc_dvb_enc_transponse_acc__iclk    ) ,
    .ireset  ( ldpc_dvb_enc_transponse_acc__ireset  ) ,
    .iclkena ( ldpc_dvb_enc_transponse_acc__iclkena ) ,
    //
    .ival    ( ldpc_dvb_enc_transponse_acc__ival    ) ,
    .iload   ( ldpc_dvb_enc_transponse_acc__iload   ) ,
    .iwrite  ( ldpc_dvb_enc_transponse_acc__iwrite  ) ,
    .ishift  ( ldpc_dvb_enc_transponse_acc__ishift  ) ,
    .idat    ( ldpc_dvb_enc_transponse_acc__idat    ) ,
    //
    .owrite  ( ldpc_dvb_enc_transponse_acc__owrite  ) ,
    .owdat   ( ldpc_dvb_enc_transponse_acc__owdat   )
  );


  assign ldpc_dvb_enc_transponse_acc__iclk    = '0 ;
  assign ldpc_dvb_enc_transponse_acc__ireset  = '0 ;
  assign ldpc_dvb_enc_transponse_acc__iclkena = '0 ;
  assign ldpc_dvb_enc_transponse_acc__ival    = '0 ;
  assign ldpc_dvb_enc_transponse_acc__iload   = '0 ;
  assign ldpc_dvb_enc_transponse_acc__iwrite  = '0 ;
  assign ldpc_dvb_enc_transponse_acc__ishift  = '0 ;
  assign ldpc_dvb_enc_transponse_acc__idat    = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_transponse_acc.sv
// Description   : special DWC accumulator for transponse {row x pDAT_W} parity bits
//

module ldpc_dvb_enc_transponse_acc
#(
  parameter int pDAT_W    =                   360 ,
  parameter int pTR_DAT_W =                     8 , // transponse dat_w, only 2^N (N = [1:6]) support
  parameter int pSHIFT_W  = $clog2(pTR_DAT_W) + 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  iload   ,
  iwrite  ,
  ishift  ,
  idat    ,
  //
  owrite  ,
  owdat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk    ;
  input  logic                   ireset  ;
  input  logic                   iclkena ;
  //
  input  logic                   ival    ;
  input  logic                   iload   ;
  input  logic                   iwrite  ;
  input  logic  [pSHIFT_W-1 : 0] ishift  ; // iload ? ashift : tshift
  input  logic [pTR_DAT_W-1 : 0] idat    ;
  //
  output logic                   owrite  ;
  output logic    [pDAT_W-1 : 0] owdat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pTR_DAT_W-1 : 0] tmp_line;
  logic    [pDAT_W-1 : 0] acc_line;

  //------------------------------------------------------------------------------------------------------
  // optional write logic
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
    end
    else if (iclkena) begin
      owrite <= ival & iwrite;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // acc logic
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (ishift[pSHIFT_W-1]) begin
          {tmp_line, acc_line} <= {iload ? idat : tmp_line, acc_line} >> pTR_DAT_W;
        end
        else begin
          {tmp_line, acc_line} <= {iload ? idat : tmp_line, acc_line} >> ishift[pSHIFT_W-2 : 0];
        end
      end
    end
  end

  assign owdat = acc_line;

endmodule
