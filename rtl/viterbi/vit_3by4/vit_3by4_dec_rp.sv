/*


  parameter int pLLR_W                    = 4 ;
  parameter int pTAG_W                    = 4 ;
  parameter bit pSOP_STATE_SYNC_DISABLE   = 0 ;



  logic      vit_3by4_rp__iclk      ;
  logic      vit_3by4_rp__ireset    ;
  logic      vit_3by4_rp__iclkena   ;
  logic      vit_3by4_rp__isop      ;
  logic      vit_3by4_rp__ival      ;
  logic      vit_3by4_rp__ieop      ;
  tag_t      vit_3by4_rp__itag      ;
  bm_t       vit_3by4_rp__ibm       ;
  logic      vit_3by4_rp__osop      ;
  logic      vit_3by4_rp__oval      ;
  logic      vit_3by4_rp__oeop      ;
  tag_t      vit_3by4_rp__otag      ;
  statem_t   vit_3by4_rp__ostatem   ;
  decision_t vit_3by4_rp__odecision ;



  vit_3by4_dec_rp
  #(
    .pLLR_W                  ( pLLR_W                  ) ,
    .pTAG_W                  ( pTAG_W                  ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE )
  )
  vit_3by4_rp
  (
    .iclk      ( vit_3by4_rp__iclk      ) ,
    .ireset    ( vit_3by4_rp__ireset    ) ,
    .iclkena   ( vit_3by4_rp__iclkena   ) ,
    .isop      ( vit_3by4_rp__isop      ) ,
    .ival      ( vit_3by4_rp__ival      ) ,
    .ieop      ( vit_3by4_rp__ieop      ) ,
    .itag      ( vit_3by4_rp__itag      ) ,
    .ibm       ( vit_3by4_rp__ibm       ) ,
    .osop      ( vit_3by4_rp__osop      ) ,
    .oval      ( vit_3by4_rp__oval      ) ,
    .oeop      ( vit_3by4_rp__oeop      ) ,
    .otag      ( vit_3by4_rp__otag      ) ,
    .ostatem   ( vit_3by4_rp__ostatem   )
    .odecision ( vit_3by4_rp__odecision )
  );


  assign vit_3by4_rp__iclk    = '0 ;
  assign vit_3by4_rp__ireset  = '0 ;
  assign vit_3by4_rp__iclkena = '0 ;
  assign vit_3by4_rp__isop    = '0 ;
  assign vit_3by4_rp__ival    = '0 ;
  assign vit_3by4_rp__ieop    = '0 ;
  assign vit_3by4_rp__itag    = '0 ;
  assign vit_3by4_rp__ibm     = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_rp.sv
// Description   : viterbi recursive processor
//

module vit_3by4_dec_rp
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  isop      ,
  ival      ,
  ieop      ,
  itag      ,
  ihd       ,
  ibm       ,
  //
  osop      ,
  oval      ,
  oeop      ,
  otag      ,
  ohd       ,
  ostatem   ,
  odecision
);

  parameter bit pSOP_STATE_SYNC_DISABLE = 0;

  `include "vit_3by4_trellis.svh"
  `include "vit_3by4_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk      ;
  input  logic      ireset    ;
  input  logic      iclkena   ;
  // branch metric interface
  input  logic      isop      ;
  input  logic      ival      ;
  input  logic      ieop      ;
  input  tag_t      itag      ;
  input  boutputs_t ihd       ;
  input  bm_t       ibm       ;
  // traceback interface
  output logic      osop      ;
  output logic      oval      ;
  output logic      oeop      ;
  output tag_t      otag      ;
  output boutputs_t ohd       ;
  output statem_t   ostatem   ;
  output decision_t odecision ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cSTATE_0_INIT  = 2**(cBM_W-1);
  localparam int cSTATE_INIT    =            0;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  trel_bm_t       acsu__ibm       [cSTATE_NUM] [8] ;
  trel_statem_t   acsu__istatem   [cSTATE_NUM] [8] ;

  trel_statem_t   acsu__ostatem   [cSTATE_NUM]     ;
  trel_decision_t acsu__odecision [cSTATE_NUM]     ;

  //------------------------------------------------------------------------------------------------------
  // recursive processor engines with module arithmetic
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= isop & ival;
      oeop <= ieop & ival;
      if (ival) begin
        otag <= itag;
        ohd  <= ihd;
      end
    end
  end

  generate
    genvar gstate;
    for (gstate = 0; gstate < cSTATE_NUM; gstate++) begin : acsu_inst_gen
      vit_3by4_dec_acsu
      #(
        .pLLR_W ( pLLR_W )
      )
      acsu
      (
        .iclk      ( iclk                     ) ,
        .ireset    ( ireset                   ) ,
        .iclkena   ( iclkena                  ) ,
        //
        .ival      ( ival                     ) ,
        .ibm       ( acsu__ibm       [gstate] ) ,
        .istatem   ( acsu__istatem   [gstate] ) ,
        //
        .oval      (                          ) ,
        .odecision ( acsu__odecision [gstate] ) ,
        .ostatem   ( acsu__ostatem   [gstate] )
      );
    end
  endgenerate

  always_comb begin
    acsu__istatem = '{default : '{default : '0}};
    acsu__ibm     = '{default : '{default : '0}};
    for (int state = 0; state < cSTATE_NUM; state++) begin
      for (int x3x2x1 = 0; x3x2x1 < 8; x3x2x1++) begin
        acsu__istatem[trel.nextStates[state][x3x2x1]][x3x2x1] =    acsu__ostatem[state];
        acsu__ibm[trel.nextStates[state][x3x2x1]][x3x2x1]     = ibm[trel.outputs[state][x3x2x1]];
        if (isop & !pSOP_STATE_SYNC_DISABLE) begin
          acsu__istatem[trel.nextStates[state][x3x2x1]][x3x2x1] = (state == 0) ? cSTATE_0_INIT : cSTATE_INIT;
        end
      end
    end
  end

  assign ostatem   = acsu__ostatem;
  assign odecision = acsu__odecision;

endmodule
