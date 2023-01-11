/*



  parameter int pADDR_W        = 8 ;
  parameter int pLLR_W         = 5 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;
  parameter int pTAG_W         = 8 ;



  logic                        ldpc_dec_ibuffer__iclk                                    ;
  logic                        ldpc_dec_ibuffer__ireset                                  ;
  logic                        ldpc_dec_ibuffer__iclkena                                 ;
  logic [pNODE_BY_CYCLE-1 : 0] ldpc_dec_ibuffer__iwrite                                  ;
  logic                        ldpc_dec_ibuffer__iwfull                                  ;
  logic        [pADDR_W-1 : 0] ldpc_dec_ibuffer__iwaddr                                  ;
  logic signed  [pLLR_W-1 : 0] ldpc_dec_ibuffer__iLLR    [pLLR_BY_CYCLE]                 ;
  logic         [pTAG_W-1 : 0] ldpc_dec_ibuffer__iwtag                                   ;
  logic                        ldpc_dec_ibuffer__irempty                                 ;
  logic        [pADDR_W-1 : 0] ldpc_dec_ibuffer__iraddr                                  ;
  logic signed  [pLLR_W-1 : 0] ldpc_dec_ibuffer__oLLR    [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic         [pTAG_W-1 : 0] ldpc_dec_ibuffer__ortag                                   ;
  logic                        ldpc_dec_ibuffer__oempty                                  ;
  logic                        ldpc_dec_ibuffer__oemptya                                 ;
  logic                        ldpc_dec_ibuffer__ofull                                   ;
  logic                        ldpc_dec_ibuffer__ofulla                                  ;



  ldpc_dec_ibuffer
  #(
    .pADDR_W        ( pADDR_W        ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pTAG_W         ( pTAG_W         )
  )
  ldpc_dec_ibuffer
  (
    .iclk    ( ldpc_dec_ibuffer__iclk    ) ,
    .ireset  ( ldpc_dec_ibuffer__ireset  ) ,
    .iclkena ( ldpc_dec_ibuffer__iclkena ) ,
    .iwrite  ( ldpc_dec_ibuffer__iwrite  ) ,
    .iwfull  ( ldpc_dec_ibuffer__iwfull  ) ,
    .iwaddr  ( ldpc_dec_ibuffer__iwaddr  ) ,
    .iLLR    ( ldpc_dec_ibuffer__iLLR    ) ,
    .iwtag   ( ldpc_dec_ibuffer__iwtag   ) ,
    .irempty ( ldpc_dec_ibuffer__irempty ) ,
    .iraddr  ( ldpc_dec_ibuffer__iraddr  ) ,
    .oLLR    ( ldpc_dec_ibuffer__oLLR    ) ,
    .ortag   ( ldpc_dec_ibuffer__ortag   ) ,
    .oempty  ( ldpc_dec_ibuffer__oempty  ) ,
    .oemptya ( ldpc_dec_ibuffer__oemptya ) ,
    .ofull   ( ldpc_dec_ibuffer__ofull   ) ,
    .ofulla  ( ldpc_dec_ibuffer__ofulla  )
  );


  assign ldpc_dec_ibuffer__iclk    = '0 ;
  assign ldpc_dec_ibuffer__ireset  = '0 ;
  assign ldpc_dec_ibuffer__iclkena = '0 ;
  assign ldpc_dec_ibuffer__iwrite  = '0 ;
  assign ldpc_dec_ibuffer__iwfull  = '0 ;
  assign ldpc_dec_ibuffer__iwaddr  = '0 ;
  assign ldpc_dec_ibuffer__iLLR    = '0 ;
  assign ldpc_dec_ibuffer__iwtag   = '0 ;
  assign ldpc_dec_ibuffer__irempty = '0 ;
  assign ldpc_dec_ibuffer__iraddr  = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_ibuffer.sv
// Description   : input 2D ram buffer with 2D tag interface. Ram read latency is 2 tick
//

module ldpc_dec_ibuffer
#(
  parameter int pADDR_W         = 8 ,
  parameter int pLLR_W          = 5 ,
  parameter int pLLR_BY_CYCLE   = 1 ,
  parameter int pNODE_BY_CYCLE  = 1 ,
  parameter int pTAG_W          = 8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwfull  ,
  iwaddr  ,
  iLLR    ,
  iwtag   ,
  //
  irempty ,
  iraddr  ,
  oLLR    ,
  ortag   ,
  //
  oempty  ,
  oemptya ,
  ofull   ,
  ofulla
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                        iclk                                    ;
  input  logic                        ireset                                  ;
  input  logic                        iclkena                                 ;
  //
  input  logic [pNODE_BY_CYCLE-1 : 0] iwrite                                  ;
  input  logic                        iwfull                                  ;
  input  logic        [pADDR_W-1 : 0] iwaddr                                  ;
  input  logic signed  [pLLR_W-1 : 0] iLLR    [pLLR_BY_CYCLE]                 ;
  input  logic         [pTAG_W-1 : 0] iwtag                                   ;
  //
  input  logic                        irempty                                 ;
  input  logic        [pADDR_W-1 : 0] iraddr                                  ;
  output logic signed  [pLLR_W-1 : 0] oLLR    [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output logic         [pTAG_W-1 : 0] ortag                                   ;
  //
  output logic                        oempty                                  ; // any buffer is empty
  output logic                        oemptya                                 ; // all buffers is empty
  output logic                        ofull                                   ; // any buffer is full
  output logic                        ofulla                                  ; // all buffers is full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W  = pADDR_W + 1;
  localparam int cDAT_W   = pLLR_BY_CYCLE * pLLR_W;

  logic b_wused ; // bank write used
  logic b_rused ; // bank read used

  //------------------------------------------------------------------------------------------------------
  // buffer logic
  //------------------------------------------------------------------------------------------------------

  codec_buffer_nD_slogic
  #(
    .pBNUM_W ( 1 )  // 2D buffer
  )
  nD_slogic
  (
    .iclk     ( iclk    ) ,
    .ireset   ( ireset  ) ,
    .iclkena  ( iclkena ) ,
    //
    .iwfull   ( iwfull  ) ,
    .ob_wused ( b_wused ) ,
    .irempty  ( irempty ) ,
    .ob_rused ( b_rused ) ,
    //
    .oempty   ( oempty  ) ,
    .oemptya  ( oemptya ) ,
    .ofull    ( ofull   ) ,
    .ofulla   ( ofulla  )
  );

  //------------------------------------------------------------------------------------------------------
  // LLR ram
  //------------------------------------------------------------------------------------------------------

  logic  [cDAT_W-1 : 0] mem__iwdat ;
  logic  [cDAT_W-1 : 0] mem__ordat [pNODE_BY_CYCLE];

  always_comb begin
    for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
      mem__iwdat[llra*pLLR_W +: pLLR_W] = iLLR[llra];
      //
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        oLLR[llra][n] = mem__ordat[n][llra*pLLR_W +: pLLR_W];
      end
    end
  end

  generate
    genvar gn;
    for (gn = 0; gn < pNODE_BY_CYCLE; gn++) begin : mem_n_inst
      codec_mem_block
      #(
        .pADDR_W ( cADDR_W ) ,
        .pDAT_W  ( cDAT_W  ) ,
        .pPIPE   ( 1       )
      )
      mem
      (
        .iclk    ( iclk    ) ,
        .ireset  ( ireset  ) ,
        .iclkena ( iclkena ) ,
        //
        .iwrite  ( iwrite[gn]        ) ,
        .iwaddr  ( {b_wused, iwaddr} ) ,
        .iwdat   ( mem__iwdat        ) ,
        //
        .iraddr  ( {b_rused, iraddr} ) ,
        .ordat   ( mem__ordat[gn]    )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // tag ram
  //------------------------------------------------------------------------------------------------------

  logic [pTAG_W-1 : 0] tram [2] /* synthesis ramstyle = "logic" */;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwfull) begin
        tram [b_wused] <= iwtag;
      end
    end
  end

  assign ortag = tram[b_rused];

endmodule
