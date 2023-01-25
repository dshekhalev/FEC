/*



  parameter int pADDR_W  = 8 ;
  parameter int pDAT_W   = 8 ;



  logic                 ldpc_3gpp_enc_source__iclk    ;
  logic                 ldpc_3gpp_enc_source__ireset  ;
  logic                 ldpc_3gpp_enc_source__iclkena ;
  //
  logic                 ldpc_3gpp_enc_source__isop    ;
  logic                 ldpc_3gpp_enc_source__ieop    ;
  logic                 ldpc_3gpp_enc_source__ival    ;
  logic  [pDAT_W-1 : 0] ldpc_3gpp_enc_source__idat    ;
  //
  logic                 ldpc_3gpp_enc_source__ifulla  ;
  logic                 ldpc_3gpp_enc_source__iemptya ;
  //
  logic                 ldpc_3gpp_enc_source__ordy    ;
  logic                 ldpc_3gpp_enc_source__obusy   ;
  //
  logic                 ldpc_3gpp_enc_source__owrite  ;
  logic                 ldpc_3gpp_enc_source__owfull  ;
  logic [pADDR_W-1 : 0] ldpc_3gpp_enc_source__owaddr  ;
  logic  [pDAT_W-1 : 0] ldpc_3gpp_enc_source__owdat   ;



  ldpc_3gpp_enc_source
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  )
  )
  ldpc_3gpp_enc_source
  (
    .iclk    ( ldpc_3gpp_enc_source__iclk    ) ,
    .ireset  ( ldpc_3gpp_enc_source__ireset  ) ,
    .iclkena ( ldpc_3gpp_enc_source__iclkena ) ,
    //
    .isop    ( ldpc_3gpp_enc_source__isop    ) ,
    .ieop    ( ldpc_3gpp_enc_source__ieop    ) ,
    .ival    ( ldpc_3gpp_enc_source__ival    ) ,
    .idat    ( ldpc_3gpp_enc_source__idat    ) ,
    //
    .ifulla  ( ldpc_3gpp_enc_source__ifulla  ) ,
    .iemptya ( ldpc_3gpp_enc_source__iemptya ) ,
    //
    .ordy    ( ldpc_3gpp_enc_source__ordy    ) ,
    .obusy   ( ldpc_3gpp_enc_source__obusy   ) ,
    //
    .owrite  ( ldpc_3gpp_enc_source__owrite  ) ,
    .owfull  ( ldpc_3gpp_enc_source__owfull  ) ,
    .owaddr  ( ldpc_3gpp_enc_source__owaddr  ) ,
    .owdat   ( ldpc_3gpp_enc_source__owdat   )
  );


  assign ldpc_3gpp_enc_source__iclk    = '0 ;
  assign ldpc_3gpp_enc_source__ireset  = '0 ;
  assign ldpc_3gpp_enc_source__iclkena = '0 ;
  assign ldpc_3gpp_enc_source__isop    = '0 ;
  assign ldpc_3gpp_enc_source__ieop    = '0 ;
  assign ldpc_3gpp_enc_source__ival    = '0 ;
  assign ldpc_3gpp_enc_source__idat    = '0 ;
  assign ldpc_3gpp_enc_source__ifulla  = '0 ;
  assign ldpc_3gpp_enc_source__iemptya = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_source.sv
// Description   : input encoder interface module
//

module ldpc_3gpp_enc_source
#(
  parameter int pADDR_W  = 8 ,
  parameter int pDAT_W   = 8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ieop    ,
  ival    ,
  idat    ,
  //
  ifulla  ,
  iemptya ,
  //
  ordy    ,
  obusy   ,
  //
  owrite  ,
  owfull  ,
  owaddr  ,
  owdat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk    ;
  input  logic                 ireset  ;
  input  logic                 iclkena ;
  //
  input  logic                 isop    ;
  input  logic                 ieop    ;
  input  logic                 ival    ;
  input  logic  [pDAT_W-1 : 0] idat    ;
  //
  input  logic                 ifulla  ;
  input  logic                 iemptya ;
  //
  output logic                 ordy    ;
  output logic                 obusy   ;
  //
  output logic                 owrite  ;
  output logic                 owfull  ;
  output logic [pADDR_W-1 : 0] owaddr  ;
  output logic  [pDAT_W-1 : 0] owdat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
      owfull <= 1'b0;
    end
    else if (iclkena) begin
      owrite <= ival;
      owfull <= ival & ieop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owdat  <= idat;
      if (ival) begin
        owaddr <= isop ? '0 : (owaddr + 1'b1);
      end
    end
  end

  assign ordy  = !owfull & !ifulla;   // not ready if all buffers is full
  assign obusy =  owfull | !iemptya;  // busy if any buffer is not empty

endmodule
