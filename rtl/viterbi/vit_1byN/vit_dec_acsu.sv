/*

  parameter int pCONSTR_LENGTH            = 3;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};
  parameter int pLLR_W                    = 4 ;


  logic           vit_dec_acsu__iclk          ;
  logic           vit_dec_acsu__ireset        ;
  logic           vit_dec_acsu__iclkena       ;
  logic           vit_dec_acsu__ival          ;
  trel_bm_t       vit_dec_acsu__ibm       [2] ;
  trel_statem_t   vit_dec_acsu__istatem   [2] ;
  logic           vit_dec_acsu__oval          ;
  trel_decision_t vit_dec_acsu__odecision     ;
  trel_statem_t   vit_dec_acsu__ostatem       ;



  vit_dec_acsu
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    .pLLR_W         ( pLLR_W         )
  )
  vit_dec_acsu
  (
    .iclk      ( vit_dec_acsu__iclk      ) ,
    .ireset    ( vit_dec_acsu__ireset    ) ,
    .iclkena   ( vit_dec_acsu__iclkena   ) ,
    .ival      ( vit_dec_acsu__ival      ) ,
    .ibm       ( vit_dec_acsu__ibm       ) ,
    .istatem   ( vit_dec_acsu__istatem   ) ,
    .oval      ( vit_dec_acsu__oval      ) ,
    .odecision ( vit_dec_acsu__odecision ) ,
    .ostatem   ( vit_dec_acsu__ostatem   )
  );


  assign vit_dec_acsu__iclk    = '0 ;
  assign vit_dec_acsu__ireset  = '0 ;
  assign vit_dec_acsu__iclkena = '0 ;
  assign vit_dec_acsu__ival    = '0 ;
  assign vit_dec_acsu__ibm     = '0 ;
  assign vit_dec_acsu__istatem = '0 ;



*/

//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_dec_acsu.sv
// Description   : viterbi Add-Compare Select Unit with module arithmetic
//

module vit_dec_acsu
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  ival      ,
  ibm       ,
  istatem   ,
  //
  oval      ,
  odecision ,
  ostatem
);

  `include "vit_trellis.svh"
  `include "vit_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk          ;
  input  logic            ireset        ;
  input  logic            iclkena       ;
  //
  input  logic            ival          ;
  input  trel_bm_t        ibm       [2] ;
  input  trel_statem_t    istatem   [2] ;
  //
  output logic            oval          ;
  output trel_decision_t  odecision     ;
  output trel_statem_t    ostatem       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  trel_statem_t bm          [2] ;
  trel_statem_t next_statem [2];
  logic         decision;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // add compare select
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    if (cHD_MODE) begin
      bm[0] = $unsigned(ibm[0]);
      bm[1] = $unsigned(ibm[1]);
    end
    else begin
      bm[0] = $signed(ibm[0]);
      bm[1] = $signed(ibm[1]);
    end
  end

  assign next_statem[0] = bm[0] + istatem[0];
  assign next_statem[1] = bm[1] + istatem[1];

  assign decision = statem_a_decision(next_statem[1], next_statem[0], cHD_MODE);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        odecision <= decision;
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ostatem <= '0;
    end
    else if (iclkena) begin
      if (ival) begin
        ostatem <= next_statem[decision];
      end
    end
  end

  // synthesis translate_off
  initial begin
    odecision = '0;
    ostatem   = '0;
  end
  // synthesis translate_on
endmodule
