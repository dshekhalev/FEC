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
  logic  [pSHIFT_W-1 : 0] ldpc_dvb_enc_transponse_acc__iashift ;
  logic  [pSHIFT_W-1 : 0] ldpc_dvb_enc_transponse_acc__itshift ;
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
    .iashift ( ldpc_dvb_enc_transponse_acc__iashift ) ,
    .itshift ( ldpc_dvb_enc_transponse_acc__itshift ) ,
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
  assign ldpc_dvb_enc_transponse_acc__iashift = '0 ;
  assign ldpc_dvb_enc_transponse_acc__itshift = '0 ;
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
  parameter int pDAT_W    = 360 ,
  parameter int pTR_DAT_W =   8 ,
  parameter int pSHIFT_W  =   8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  iload   ,
  iwrite  ,
  iashift ,
  itshift ,
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
  input  logic  [pSHIFT_W-1 : 0] iashift ;
  input  logic  [pSHIFT_W-1 : 0] itshift ;
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
        if (iload) begin
          {tmp_line, acc_line} <= {idat, acc_line} >> get_shift_value(iashift);
        end
        else begin
          acc_line <= {tmp_line, acc_line} >> get_shift_value(itshift);
        end
      end
    end
  end

  assign owdat = acc_line;

  //------------------------------------------------------------------------------------------------------
  // function to scale shift to range [0 : pDAT_W]
  //------------------------------------------------------------------------------------------------------

  function logic [pSHIFT_W-1 : 0] get_shift_value (logic [pSHIFT_W-1 : 0] shift);
  begin
    get_shift_value = pDAT_W;
    if (shift < pDAT_W) begin
      get_shift_value = shift % pDAT_W;
    end
  end
  endfunction

endmodule
