/*


  parameter int pSYMB_M_W               = 4 ;
  parameter bit pSOP_STATE_SYNC_DISABLE = 0 ;


  logic      tcm_4D_8PSK_rp__iclk      ;
  logic      tcm_4D_8PSK_rp__ireset    ;
  logic      tcm_4D_8PSK_rp__iclkena   ;
  logic      tcm_4D_8PSK_rp__isop      ;
  logic      tcm_4D_8PSK_rp__ival      ;
  logic      tcm_4D_8PSK_rp__ieop      ;
  bm_t       tcm_4D_8PSK_rp__ibm       ;
  logic      tcm_4D_8PSK_rp__osop      ;
  logic      tcm_4D_8PSK_rp__oval      ;
  logic      tcm_4D_8PSK_rp__oeop      ;
  statem_t   tcm_4D_8PSK_rp__ostatem   ;
  decision_t tcm_4D_8PSK_rp__odecision ;



  tcm_dec_rp
  #(
    .pSYMB_M_W               ( pSYMB_M_W               ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE )
  )
  tcm_4D_8PSK_rp
  (
    .iclk      ( tcm_4D_8PSK_rp__iclk      ) ,
    .ireset    ( tcm_4D_8PSK_rp__ireset    ) ,
    .iclkena   ( tcm_4D_8PSK_rp__iclkena   ) ,
    .isop      ( tcm_4D_8PSK_rp__isop      ) ,
    .ival      ( tcm_4D_8PSK_rp__ival      ) ,
    .ieop      ( tcm_4D_8PSK_rp__ieop      ) ,
    .ibm       ( tcm_4D_8PSK_rp__ibm       ) ,
    .osop      ( tcm_4D_8PSK_rp__osop      ) ,
    .oval      ( tcm_4D_8PSK_rp__oval      ) ,
    .oeop      ( tcm_4D_8PSK_rp__oeop      ) ,
    .ostatem   ( tcm_4D_8PSK_rp__ostatem   )
    .odecision ( tcm_4D_8PSK_rp__odecision )
  );


  assign tcm_4D_8PSK_rp__iclk    = '0 ;
  assign tcm_4D_8PSK_rp__ireset  = '0 ;
  assign tcm_4D_8PSK_rp__iclkena = '0 ;
  assign tcm_4D_8PSK_rp__isop    = '0 ;
  assign tcm_4D_8PSK_rp__ival    = '0 ;
  assign tcm_4D_8PSK_rp__ieop    = '0 ;
  assign tcm_4D_8PSK_rp__ibm     = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_rp.sv
// Description   : viterbi recursive processor for 3/4 trellis
//

`include "define.vh"

module tcm_dec_rp
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  isop        ,
  ival        ,
  ieop        ,
  ibm         ,
  //
  osop        ,
  oval        ,
  oeop        ,
  ostatem     ,
  odecision
);

  parameter bit pSOP_STATE_SYNC_DISABLE = 0; // disable recursive processor state initialization at sop

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

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
  input  bm_t       ibm       ;
  // traceback interface
  output logic      osop      ;
  output logic      oval      ;
  output logic      oeop      ;
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
    end
  end

  generate
    genvar gstate;
    for (gstate = 0; gstate < cSTATE_NUM; gstate++) begin : acsu_inst_gen
      tcm_dec_acsu
      #(
        .pSYMB_M_W ( pSYMB_M_W )
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
