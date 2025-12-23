/*


  parameter int pTAG_W                    = 4 ;



  logic                vit_enc__iclk     ;
  logic                vit_enc__ireset   ;
  logic                vit_enc__iclkena  ;
  logic                vit_enc__isop     ;
  logic                vit_enc__ival     ;
  logic                vit_enc__ieop     ;
  logic [pTAG_W-1 : 0] vit_enc__itag     ;
  logic        [3 : 1] vit_enc__idat     ;
  logic                vit_enc__osop     ;
  logic                vit_enc__oval     ;
  logic                vit_enc__oeop     ;
  logic [pTAG_W-1 : 0] vit_enc__otag     ;
  logic        [3 : 0] vit_enc__odat     ;



  vit_3by4_enc
  #(
    .pTAG_W ( pTAG_W )
  )
  vit_enc
  (
    .iclk    ( vit_enc__iclk    ) ,
    .ireset  ( vit_enc__ireset  ) ,
    .iclkena ( vit_enc__iclkena ) ,
    .isop    ( vit_enc__isop    ) ,
    .ival    ( vit_enc__ival    ) ,
    .ieop    ( vit_enc__ieop    ) ,
    .itag    ( vit_enc__itag    ) ,
    .idat    ( vit_enc__idat    ) ,
    .osop    ( vit_enc__osop    ) ,
    .oval    ( vit_enc__oval    ) ,
    .oeop    ( vit_enc__oeop    ) ,
    .otag    ( vit_enc__otag    ) ,
    .odat    ( vit_enc__odat    )
  );


  assign vit_enc__iclk    = '0 ;
  assign vit_enc__ireset  = '0 ;
  assign vit_enc__iclkena = '0 ;
  assign vit_enc__isop    = '0 ;
  assign vit_enc__ival    = '0 ;
  assign vit_enc__ieop    = '0 ;
  assign vit_enc__itag    = '0 ;
  assign vit_enc__idat    = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_enc.sv
// Description   : viteri 3/4 encoder
//

module vit_3by4_enc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  itag    ,
  idat    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  otag    ,
  odat
);

  `include "vit_3by4_trellis.svh"

  parameter int pTAG_W = 4;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk     ;
  input  logic                ireset   ;
  input  logic                iclkena  ;
  //
  input  logic                isop     ;
  input  logic                ival     ;
  input  logic                ieop     ;
  input  logic [pTAG_W-1 : 0] itag     ;
  input  logic        [3 : 1] idat     ;
  //
  output logic                osop     ;
  output logic                oval     ;
  output logic                oeop     ;
  output logic [pTAG_W-1 : 0] otag     ;
  output logic        [3 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  stateb_t state;

  //------------------------------------------------------------------------------------------------------
  // do coding througth trellis. it's more universal
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval  <= 1'b0;
      state <= '0;
    end
    else if (iclkena) begin
      oval <= ival;
      if (ival) begin
        state <= isop ? trel.nextStates[0][idat] : trel.nextStates[state][idat];
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        osop <= isop;
        oeop <= ieop;
        if (isop) begin
          otag <= itag;
        end
        odat <= isop ? {idat, 1'b0} : {idat, state[0]};
      end
    end
  end

endmodule
