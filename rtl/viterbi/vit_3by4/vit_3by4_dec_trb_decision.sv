/*


  parameter int pLLR_W = 4;


  logic    vit_3by4_dec_trb_decision__iclk    ;
  logic    vit_3by4_dec_trb_decision__ireset  ;
  logic    vit_3by4_dec_trb_decision__iclkena ;
  logic    vit_3by4_dec_trb_decision__ival    ;
  statem_t vit_3by4_dec_trb_decision__istatem ;
  logic    vit_3by4_dec_trb_decision__oval    ;
  stateb_t vit_3by4_dec_trb_decision__ostate  ;



  vit_3by4_dec_trb_decision
  #(
    .pLLR_W ( pLLR_W )
  )
  vit_3by4_dec_trb_decision
  (
    .iclk    ( vit_3by4_dec_trb_decision__iclk    ) ,
    .ireset  ( vit_3by4_dec_trb_decision__ireset  ) ,
    .iclkena ( vit_3by4_dec_trb_decision__iclkena ) ,
    .ival    ( vit_3by4_dec_trb_decision__ival    ) ,
    .istatem ( vit_3by4_dec_trb_decision__istatem ) ,
    .oval    ( vit_3by4_dec_trb_decision__oval    ) ,
    .ostate  ( vit_3by4_dec_trb_decision__ostate  )
  );


  assign vit_3by4_dec_trb_decision__iclk    = '0 ;
  assign vit_3by4_dec_trb_decision__ireset  = '0 ;
  assign vit_3by4_dec_trb_decision__iclkena = '0 ;
  assign vit_3by4_dec_trb_decision__ival    = '0 ;
  assign vit_3by4_dec_trb_decision__istate  = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_dec_trb_decision.v
// Description   : trellis path decision tree for module arithmetic
//


module vit_3by4_dec_trb_decision
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  istatem ,
  //
  oval    ,
  ostate
);

  `include "vit_3by4_trellis.svh"
  `include "vit_3by4_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk    ;
  input  logic    ireset  ;
  input  logic    iclkena ;
  //
  input  logic    ival    ;
  input  statem_t istatem ;
  //
  output logic    oval    ;
  output stateb_t ostate  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cTREE_DEPTH = pCONSTR_LENGTH-1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [cTREE_DEPTH-1 : 0] val;

  trel_statem_t next_statem [cTREE_DEPTH][cSTATE_NUM/2];
  trel_statem_t statem      [cTREE_DEPTH][cSTATE_NUM/2];

  stateb_t      next_state  [cTREE_DEPTH][cSTATE_NUM/2];
  stateb_t      state       [cTREE_DEPTH][cSTATE_NUM/2];

  //------------------------------------------------------------------------------------------------------
  // detect min tree
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  always_comb begin
    logic tdecision;
    //
    for (int i = 0; i < cTREE_DEPTH; i++) begin
      for (int j = 0; j < (cSTATE_NUM/2 >> i); j++) begin
        if (i == 0) begin
          tdecision = statem_a_max(istatem[2*j], istatem[2*j+1]);
          //
          next_statem [i][j] = tdecision ? istatem[2*j] : istatem[2*j+1];
          next_state  [i][j] = tdecision ?         2*j  :         2*j+1 ;
        end
        else begin
          tdecision = statem_a_max(statem[i-1][2*j], statem[i-1][2*j+1]);
          //
          next_statem [i][j] = tdecision ? statem [i-1][2*j] : statem [i-1][2*j+1];
          next_state  [i][j] = tdecision ? state  [i-1][2*j] : state  [i-1][2*j+1];
        end
      end // state num
    end // depth
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      statem <= next_statem;
      state  <= next_state;
    end
  end

  assign oval   = val  [cTREE_DEPTH-1];
  assign ostate = state[cTREE_DEPTH-1][0];

endmodule
