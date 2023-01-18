/*



  parameter int pADDR_W = 8 ;



  logic                 rsc_enc_source__iclk    ;
  logic                 rsc_enc_source__ireset  ;
  logic                 rsc_enc_source__iclkena ;
  //
  logic                 rsc_enc_source__ival    ;
  logic                 rsc_enc_source__isop    ;
  logic                 rsc_enc_source__ieop    ;
  logic         [1 : 0] rsc_enc_source__idat    ;
  //
  logic                 rsc_enc_source__obusy   ;
  logic                 rsc_enc_source__ordy    ;
  //
  logic                 rsc_enc_source__iempty  ;
  logic                 rsc_enc_source__iemptya ;
  logic                 rsc_enc_source__ifull   ;
  logic                 rsc_enc_source__ifulla  ;
  //
  logic                 rsc_enc_source__owrite  ;
  logic                 rsc_enc_source__owfull  ;
  logic [pADDR_W-1 : 0] rsc_enc_source__owaddr  ;
  logic         [1 : 0] rsc_enc_source__owdat   ;



  rsc_enc_source
  #(
    .pADDR_W ( pADDR_W )
  )
  rsc_enc_source
  (
    .iclk    ( rsc_enc_source__iclk    ) ,
    .ireset  ( rsc_enc_source__ireset  ) ,
    .iclkena ( rsc_enc_source__iclkena ) ,
    //
    .ival    ( rsc_enc_source__ival    ) ,
    .isop    ( rsc_enc_source__isop    ) ,
    .ieop    ( rsc_enc_source__ieop    ) ,
    .idat    ( rsc_enc_source__idat    ) ,
    //
    .obusy   ( rsc_enc_source__obusy   ) ,
    .ordy    ( rsc_enc_source__ordy    ) ,
    //
    .iempty  ( rsc_enc_source__iempty  ) ,
    .iemptya ( rsc_enc_source__iemptya ) ,
    .ifull   ( rsc_enc_source__ifull   ) ,
    .ifulla  ( rsc_enc_source__ifulla  ) ,
    //
    .owrite  ( rsc_enc_source__owrite  ) ,
    .owfull  ( rsc_enc_source__owfull  ) ,
    .owaddr  ( rsc_enc_source__owaddr  ) ,
    .owdat   ( rsc_enc_source__owdat   )
  );


  assign rsc_enc_source__iclk    = '0 ;
  assign rsc_enc_source__ireset  = '0 ;
  assign rsc_enc_source__iclkena = '0 ;
  assign rsc_enc_source__ival    = '0 ;
  assign rsc_enc_source__isop    = '0 ;
  assign rsc_enc_source__ieop    = '0 ;
  assign rsc_enc_source__idat    = '0 ;
  assign rsc_enc_source__iempty  = '0 ;
  assign rsc_enc_source__iemptya = '0 ;
  assign rsc_enc_source__ifull   = '0 ;
  assign rsc_enc_source__ifulla  = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_enc_source.sv
// Description   : RSC encoder source data unit
//


module rsc_enc_source
#(
  parameter int pADDR_W = 8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  ieop    ,
  idat    ,
  //
  obusy   ,
  ordy    ,
  //
  iempty  ,
  iemptya ,
  ifull   ,
  ifulla  ,
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
  input  logic                 ival    ;
  input  logic                 isop    ;
  input  logic                 ieop    ;
  input  logic         [1 : 0] idat    ;
  //
  output logic                 obusy   ;
  output logic                 ordy    ;
  //
  input  logic                 iempty  ;
  input  logic                 iemptya ;
  input  logic                 ifull   ;
  input  logic                 ifulla  ;
  //
  output logic                 owrite  ;
  output logic                 owfull  ;
  output logic [pADDR_W-1 : 0] owaddr  ;
  output logic         [1 : 0] owdat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pADDR_W-1 : 0] waddr;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign owrite = ival;
  assign owfull = ival & ieop;
  assign owaddr = isop ? '0 : waddr;
  assign owdat  = idat;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        waddr <= isop ? 1'b1 : (waddr + 1'b1);
      end
    end
  end

  assign ordy  = !ifulla;   // not ready if all buffers is full
  assign obusy = !iemptya;  // busy if any buffer is not empty

endmodule
