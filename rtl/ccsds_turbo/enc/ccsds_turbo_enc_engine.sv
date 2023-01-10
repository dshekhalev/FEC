/*




  logic         ccsds_turbo_enc_engine__iclk    ;
  logic         ccsds_turbo_enc_engine__ireset  ;
  logic         ccsds_turbo_enc_engine__iclkena ;
  logic         ccsds_turbo_enc_engine__isop    ;
  logic         ccsds_turbo_enc_engine__ival    ;
  logic         ccsds_turbo_enc_engine__ieop    ;
  logic         ccsds_turbo_enc_engine__iterm   ;
  logic         ccsds_turbo_enc_engine__idat    ;
  logic         ccsds_turbo_enc_engine__osop    ;
  logic         ccsds_turbo_enc_engine__oval    ;
  logic         ccsds_turbo_enc_engine__oeop    ;
  logic [3 : 0] ccsds_turbo_enc_engine__odat    ;



  ccsds_turbo_enc_engine
  ccsds_turbo_enc_engine
  (
    .iclk    ( ccsds_turbo_enc_engine__iclk    ) ,
    .ireset  ( ccsds_turbo_enc_engine__ireset  ) ,
    .iclkena ( ccsds_turbo_enc_engine__iclkena ) ,
    .isop    ( ccsds_turbo_enc_engine__isop    ) ,
    .ival    ( ccsds_turbo_enc_engine__ival    ) ,
    .ieop    ( ccsds_turbo_enc_engine__ieop    ) ,
    .iterm   ( ccsds_turbo_enc_engine__iterm   ) ,
    .idat    ( ccsds_turbo_enc_engine__idat    ) ,
    .osop    ( ccsds_turbo_enc_engine__osop    ) ,
    .oval    ( ccsds_turbo_enc_engine__oval    ) ,
    .oeop    ( ccsds_turbo_enc_engine__oeop    ) ,
    .odat    ( ccsds_turbo_enc_engine__odat    )
  );


  assign ccsds_turbo_enc_engine__iclk    = '0 ;
  assign ccsds_turbo_enc_engine__ireset  = '0 ;
  assign ccsds_turbo_enc_engine__iclkena = '0 ;
  assign ccsds_turbo_enc_engine__isop    = '0 ;
  assign ccsds_turbo_enc_engine__ival    = '0 ;
  assign ccsds_turbo_enc_engine__ieop    = '0 ;
  assign ccsds_turbo_enc_engine__iterm   = '0 ;
  assign ccsds_turbo_enc_engine__idat    = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_enc_engine.v
// Description   : ccsds_turbo convolution engine
//

module ccsds_turbo_enc_engine
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  iterm   ,
  idat    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat
);

  `include "../ccsds_turbo_trellis.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk    ;
  input  logic         ireset  ;
  input  logic         iclkena ;
  //
  input  logic         isop    ;
  input  logic         ival    ;
  input  logic         ieop    ;
  input  logic         iterm   ;
  input  logic         idat    ;
  //
  output logic         osop    ;
  output logic         oval    ;
  output logic         oeop    ;
  output logic [3 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         term;
  logic [3 : 0] state;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osop  <= 1'b0;
      oval  <= 1'b0;
      oeop  <= 1'b0;
    end
    else if (iclkena) begin
      osop <= ival & isop;
      oval <= ival;
      oeop <= ival & ieop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (isop) begin
          {term, odat, state} <= do_encode(idat, 4'h0);
        end
        else begin
          {term, odat, state} <= do_encode(iterm ? term : idat, state);
        end // isop
      end // ival
    end // iclkena
  end // iclk

endmodule
