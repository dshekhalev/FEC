/*


  parameter int pSYMB_M_W = 4 ;


  logic           tcm_4D_8PSK_acsu__iclk          ;
  logic           tcm_4D_8PSK_acsu__ireset        ;
  logic           tcm_4D_8PSK_acsu__iclkena       ;
  logic           tcm_4D_8PSK_acsu__ival          ;
  trel_bm_t       tcm_4D_8PSK_acsu__ibm       [8] ;
  trel_statem_t   tcm_4D_8PSK_acsu__istatem   [8] ;
  logic           tcm_4D_8PSK_acsu__oval          ;
  trel_statem_t   tcm_4D_8PSK_acsu__ostatem       ;
  trel_decision_t tcm_4D_8PSK_acsu__odecision     ;



  tcm_dec_acsu
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_4D_8PSK_acsu
  (
    .iclk      ( tcm_4D_8PSK_acsu__iclk      ) ,
    .ireset    ( tcm_4D_8PSK_acsu__ireset    ) ,
    .iclkena   ( tcm_4D_8PSK_acsu__iclkena   ) ,
    .ival      ( tcm_4D_8PSK_acsu__ival      ) ,
    .ibm       ( tcm_4D_8PSK_acsu__ibm       ) ,
    .istatem   ( tcm_4D_8PSK_acsu__istatem   ) ,
    .oval      ( tcm_4D_8PSK_acsu__oval      ) ,
    .ostatem   ( tcm_4D_8PSK_acsu__ostatem   ) ,
    .odecision ( tcm_4D_8PSK_acsu__odecision )
  );


  assign tcm_4D_8PSK_acsu__iclk    = '0 ;
  assign tcm_4D_8PSK_acsu__ireset  = '0 ;
  assign tcm_4D_8PSK_acsu__iclkena = '0 ;
  assign tcm_4D_8PSK_acsu__ival    = '0 ;
  assign tcm_4D_8PSK_acsu__ibm     = '0 ;
  assign tcm_4D_8PSK_acsu__istatem = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_acsu.sv
// Description   : viterbi Add-Compare Select Unit for 3/4 trellis with module arithmetic
//

`include "define.vh"

module tcm_dec_acsu
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

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

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

  trel_statem_t bm            [8];

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
    //
    for (int i = 0; i < 8; i++) begin
      bm[i] = $unsigned(ibm[i]);  // unsigned extend (!!!)
    end
    //
    for (int i = 0; i < 8; i++) begin
      next_statem[i] = bm[i] + istatem[i];
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
