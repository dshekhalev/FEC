/*

  parameter int pLLR_W = 4 ;


  logic           vit_3by4_acsu__iclk          ;
  logic           vit_3by4_acsu__ireset        ;
  logic           vit_3by4_acsu__iclkena       ;
  logic           vit_3by4_acsu__ival          ;
  trel_bm_t       vit_3by4_acsu__ibm       [8] ;
  trel_statem_t   vit_3by4_acsu__istatem   [8] ;
  logic           vit_3by4_acsu__oval          ;
  trel_statem_t   vit_3by4_acsu__ostatem       ;
  trel_decision_t vit_3by4_acsu__odecision     ;



  vit_3by4_dec_acsu
  #(
    .pLLR_W ( pLLR_W )
  )
  vit_3by4_acsu
  (
    .iclk      ( vit_3by4_acsu__iclk      ) ,
    .ireset    ( vit_3by4_acsu__ireset    ) ,
    .iclkena   ( vit_3by4_acsu__iclkena   ) ,
    .ival      ( vit_3by4_acsu__ival      ) ,
    .ibm       ( vit_3by4_acsu__ibm       ) ,
    .istatem   ( vit_3by4_acsu__istatem   ) ,
    .oval      ( vit_3by4_acsu__oval      ) ,
    .odecision ( vit_3by4_acsu__odecision ) ,
    .ostatem   ( vit_3by4_acsu__ostatem   )
  );


  assign vit_3by4_acsu__iclk    = '0 ;
  assign vit_3by4_acsu__ireset  = '0 ;
  assign vit_3by4_acsu__iclkena = '0 ;
  assign vit_3by4_acsu__ival    = '0 ;
  assign vit_3by4_acsu__ibm     = '0 ;
  assign vit_3by4_acsu__istatem = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_acsu.sv
// Description   : viterbi Add-Compare Select Unit with module arithmetic
//

module vit_3by4_dec_acsu
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
  ostatem   ,
  odecision
);

  `include "vit_3by4_trellis.svh"
  `include "vit_3by4_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk          ;
  input  logic            ireset        ;
  input  logic            iclkena       ;
  //
  input  logic            ival          ;
  input  trel_bm_t        ibm       [8] ;
  input  trel_statem_t    istatem   [8] ;
  //
  output logic            oval          ;
  output trel_statem_t    ostatem       ;
  output trel_decision_t  odecision     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  trel_statem_t next_statem   [8];

  trel_statem_t next_statem1  [4];
  logic [2 : 0] next_idx1     [4];

  trel_statem_t next_statem2  [2];
  logic [2 : 0] next_idx2     [2];

  trel_statem_t next_statem3     ;
  logic [2 : 0] next_idx3        ;

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
    logic decision;
    for (int i = 0; i < 8; i++) begin
      next_statem[i] = ibm[i] + istatem[i];
    end
    // layer 1
    for (int i = 0; i < 4; i++) begin
      decision        = statem_a_max(next_statem[2*i],  next_statem[2*i+1]);
      next_statem1[i] = decision ?   next_statem[2*i] : next_statem[2*i+1];
      next_idx1   [i] = decision ?              (2*i) :            (2*i+1);
    end
    // layer 2
    for (int i = 0; i < 2; i++) begin
      decision        = statem_a_max(next_statem1[2*i],  next_statem1[2*i+1]);
      next_statem2[i] = decision ?   next_statem1[2*i] : next_statem1[2*i+1];
      next_idx2   [i] = decision ?   next_idx1   [2*i] : next_idx1   [2*i+1];
    end
    // layer 3
    decision      = statem_a_max(next_statem2[1],  next_statem2[0]);
    next_statem3  = decision ?   next_statem2[1] : next_statem2[0];
    next_idx3     = decision ?   next_idx2   [1] : next_idx2   [0];
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        odecision <= next_idx3;
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ostatem <= '0;
    end
    else if (iclkena) begin
      if (ival) begin
        ostatem <= next_statem3;
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
