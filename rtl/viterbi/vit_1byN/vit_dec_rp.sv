/*


  parameter int pCONSTR_LENGTH            = 3;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};
  parameter int pLLR_W                    = 4 ;
  parameter int pTAG_W                    = 4 ;
  parameter bit pSOP_STATE_SYNC_DISABLE   = 0 ;
  parameter bit pUSE_ACSU_LA              = 0 ;



  logic      vit_dec_rp__iclk      ;
  logic      vit_dec_rp__ireset    ;
  logic      vit_dec_rp__iclkena   ;
  logic      vit_dec_rp__isop      ;
  logic      vit_dec_rp__ival      ;
  logic      vit_dec_rp__ieop      ;
  tag_t      vit_dec_rp__itag      ;
  bm_t       vit_dec_rp__ibm       ;
  logic      vit_dec_rp__osop      ;
  logic      vit_dec_rp__oval      ;
  logic      vit_dec_rp__oeop      ;
  tag_t      vit_dec_rp__otag      ;
  statem_t   vit_dec_rp__ostatem   ;
  decision_t vit_dec_rp__odecision ;



  vit_dec_rp
  #(
    .pCONSTR_LENGTH          ( pCONSTR_LENGTH          ) ,
    .pCODE_GEN_NUM           ( pCODE_GEN_NUM           ) ,
    .pCODE_GEN               ( pCODE_GEN               ) ,
    .pLLR_W                  ( pLLR_W                  ) ,
    .pTAG_W                  ( pTAG_W                  ) ,
    .pSOP_STATE_SYNC_DISABLE ( pSOP_STATE_SYNC_DISABLE ) ,
    .pUSE_ACSU_LA            ( pUSE_ACSU_LA            )
  )
  vit_dec_rp
  (
    .iclk      ( vit_dec_rp__iclk      ) ,
    .ireset    ( vit_dec_rp__ireset    ) ,
    .iclkena   ( vit_dec_rp__iclkena   ) ,
    .isop      ( vit_dec_rp__isop      ) ,
    .ival      ( vit_dec_rp__ival      ) ,
    .ieop      ( vit_dec_rp__ieop      ) ,
    .itag      ( vit_dec_rp__itag      ) ,
    .ibm       ( vit_dec_rp__ibm       ) ,
    .osop      ( vit_dec_rp__osop      ) ,
    .oval      ( vit_dec_rp__oval      ) ,
    .oeop      ( vit_dec_rp__oeop      ) ,
    .otag      ( vit_dec_rp__otag      ) ,
    .ostatem   ( vit_dec_rp__ostatem   )
    .odecision ( vit_dec_rp__odecision )
  );


  assign vit_dec_rp__iclk    = '0 ;
  assign vit_dec_rp__ireset  = '0 ;
  assign vit_dec_rp__iclkena = '0 ;
  assign vit_dec_rp__isop    = '0 ;
  assign vit_dec_rp__ival    = '0 ;
  assign vit_dec_rp__ieop    = '0 ;
  assign vit_dec_rp__itag    = '0 ;
  assign vit_dec_rp__ibm     = '0 ;



*/

//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_dec_rp.sv
// Description   : viterbi recursive processor
//


module vit_dec_rp
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
  parameter bit pUSE_ACSU_LA            = 0;  // use ACSU with look ahead

  `include "vit_trellis.svh"
  `include "vit_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk       ;
  input  logic      ireset     ;
  input  logic      iclkena    ;
  // branch metric interface
  input  logic      isop       ;
  input  logic      ival       ;
  input  logic      ieop       ;
  input  tag_t      itag       ;
  input  boutputs_t ihd        ;
  input  bm_t       ibm        ;
  // traceback interface
  output logic      osop       ;
  output logic      oval       ;
  output logic      oeop       ;
  output tag_t      otag       ;
  output boutputs_t ohd        ;
  output statem_t   ostatem    ;
  output decision_t odecision  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cSTATE_0_INIT  = cHD_MODE ?     0 : 2**(cBM_W-1);
  localparam int cSTATE_INIT    = cHD_MODE ? cBM_W :            0;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  trel_bm_t       acsu__ibm       [cSTATE_NUM] [2] ;
  trel_statem_t   acsu__istatem   [cSTATE_NUM] [2] ;

  trel_statem_t   acsu__ostatem   [cSTATE_NUM]     ;
  decision_t      acsu__odecision                  ;

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
      if (ival) begin
        osop <= isop;
        oeop <= ieop;
        otag <= itag;
        ohd  <= ihd;
      end
    end
  end

  generate
    genvar gstate;
    for (gstate = 0; gstate < cSTATE_NUM; gstate++) begin : acsu_inst_gen
      if (pUSE_ACSU_LA) begin
        vit_dec_acsu_la
        #(
          .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
          .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
          .pCODE_GEN      ( pCODE_GEN      ) ,
          //
          .pLLR_W         ( pLLR_W         )
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
      else begin
        vit_dec_acsu
        #(
          .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
          .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
          .pCODE_GEN      ( pCODE_GEN      ) ,
          //
          .pLLR_W         ( pLLR_W         )
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
    end
  endgenerate

  always_comb begin
    acsu__istatem = '{default : '{default : '0}};
    acsu__ibm     = '{default : '{default : '0}};
    for (int state = 0; state < cSTATE_NUM; state++) begin
      for (int b = 0; b < 2; b++) begin
        acsu__istatem[trel.nextStates[state][b]][state[0]] =    acsu__ostatem[state];
        acsu__ibm    [trel.nextStates[state][b]][state[0]] = ibm[trel.outputs[state][b]];
        //
        if (isop & !pSOP_STATE_SYNC_DISABLE) begin
          acsu__istatem[trel.nextStates[state][b]][state[0]] = (state == 0) ? cSTATE_0_INIT : cSTATE_INIT;
        end
      end
    end
  end

  assign ostatem   = acsu__ostatem;
  assign odecision = acsu__odecision;

endmodule
