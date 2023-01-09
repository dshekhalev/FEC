/*


  parameter int pCONSTR_LENGTH            = 3;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};
  parameter int pTAG_W                    = 4 ;



  logic                       vit_enc__iclk     ;
  logic                       vit_enc__ireset   ;
  logic                       vit_enc__iclkena  ;
  logic                       vit_enc__isop     ;
  logic                       vit_enc__ival     ;
  logic                       vit_enc__ieop     ;
  logic        [pTAG_W-1 : 0] vit_enc__itag     ;
  logic                       vit_enc__idat     ;
  logic                       vit_enc__ordy     ;
  logic                       vit_enc__osop     ;
  logic                       vit_enc__oval     ;
  logic                       vit_enc__oeop     ;
  logic        [pTAG_W-1 : 0] vit_enc__otag     ;
  logic [pCODE_GEN_NUM-1 : 0] vit_enc__odat     ;



  vit_enc
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    .pTAG_W         ( pTAG_W         )
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
    .ordy    ( vit_enc__ordy    ) ,
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
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_enc.sv
// Description   : convolution coder based upon shift register with N polynomes without feedback
//                 coder has internal trellis initialization and termination control.
//                 sop initialize trellis to S0.
//                 eop initialize trellis terminate by pCONSTR_LENGTH-1 zeros and move state to S0 again
//

module vit_enc
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
  ordy    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  otag    ,
  odat
);

  `include "vit_trellis.svh"

  parameter int pTAG_W = 4;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk     ;
  input  logic                       ireset   ;
  input  logic                       iclkena  ;
  //
  input  logic                       isop     ;
  input  logic                       ival     ;
  input  logic                       ieop     ;
  input  logic        [pTAG_W-1 : 0] itag     ;
  input  logic                       idat     ;
  output logic                       ordy     ; // trellis termination wait
  //
  output logic                       osop     ;
  output logic                       oval     ;
  output logic                       oeop     ;
  output logic        [pTAG_W-1 : 0] otag     ;
  output logic [pCODE_GEN_NUM-1 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  stateb_t state;

  struct packed {
    logic     do_term;
    stateb_t  value;
  } wcnt;

  //------------------------------------------------------------------------------------------------------
  // do coding througth trellis. it's more universal
  //------------------------------------------------------------------------------------------------------

  wire val = (ival & ordy) | wcnt.do_term;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval  <= 1'b0;
      state <= '0;
      wcnt  <= '0;
    end
    else if (iclkena) begin
      oval  <= val;
      if (val) begin
        if (wcnt.do_term) begin
          state <= trel.nextStates[state][0];
        end
        else begin
          state <= isop ? trel.nextStates[0][idat] : trel.nextStates[state][idat];
        end
      end
      //
      if (ival & ordy & ieop) begin
        wcnt <= -(pCONSTR_LENGTH-1);
      end
      else begin
        wcnt <= wcnt + wcnt.do_term;
      end
    end
  end

  assign ordy = !wcnt.do_term;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & ordy) begin
        osop <= isop;
        if (isop) begin
          otag <= itag;
        end
      end
      //
      oeop <= wcnt.do_term & &wcnt.value;
      if (val) begin
        if (wcnt.do_term) begin
          odat <= trel.outputs[state][0];
        end
        else begin
          odat <= isop ? trel.outputs[0][idat] : trel.outputs[state][idat];
        end
      end
    end
  end

endmodule
