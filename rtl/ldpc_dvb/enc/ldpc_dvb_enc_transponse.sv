/*



  parameter int pADDR_W   =   8 ;
  parameter int pDAT_W    = 360 ;
  parameter int pTR_DAT_W =   8 ;



  logic                 ldpc_dvb_enc_transponse__iclk       ;
  logic                 ldpc_dvb_enc_transponse__ireset     ;
  logic                 ldpc_dvb_enc_transponse__iclkena    ;
  //
  logic [pADDR_W-1 : 0] ldpc_dvb_enc_transponse__iwrow      ;
  logic [pADDR_W-1 : 0] ldpc_dvb_enc_transponse__iwdata_col ;
  //
  logic                 ldpc_dvb_enc_transponse__iwrite     ;
  logic                 ldpc_dvb_enc_transponse__iwfull     ;
  logic [pADDR_W-1 : 0] ldpc_dvb_enc_transponse__iwaddr     ;
  logic  [pDAT_W-1 : 0] ldpc_dvb_enc_transponse__iwdat      ;
  logic                 ldpc_dvb_enc_transponse__ipwrite    ;
  logic [pADDR_W-1 : 0] ldpc_dvb_enc_transponse__ipwaddr    ;
  logic                 ldpc_dvb_enc_transponse__ordy       ;
  //
  logic                 ldpc_dvb_enc_transponse__owrite     ;
  logic                 ldpc_dvb_enc_transponse__owfull     ;
  logic [pADDR_W-1 : 0] ldpc_dvb_enc_transponse__owaddr     ;
  logic  [pDAT_W-1 : 0] ldpc_dvb_enc_transponse__owdat      ;



  ldpc_dvb_enc_transponse
  #(
    .pADDR_W   ( pADDR_W   ) ,
    .pDAT_W    ( pDAT_W    ) ,
    .pTR_DAT_W ( pTR_DAT_W )
  )
  ldpc_dvb_enc_transponse
  (
    .iclk       ( ldpc_dvb_enc_transponse__iclk       ) ,
    .ireset     ( ldpc_dvb_enc_transponse__ireset     ) ,
    .iclkena    ( ldpc_dvb_enc_transponse__iclkena    ) ,
    //
    .iwrow      ( ldpc_dvb_enc_transponse__iwrow      ) ,
    .iwdata_col ( ldpc_dvb_enc_transponse__iwdata_col ) ,
    //
    .iwrite     ( ldpc_dvb_enc_transponse__iwrite     ) ,
    .iwfull     ( ldpc_dvb_enc_transponse__iwfull     ) ,
    .iwaddr     ( ldpc_dvb_enc_transponse__iwaddr     ) ,
    .iwdat      ( ldpc_dvb_enc_transponse__iwdat      ) ,
    .ipwrite    ( ldpc_dvb_enc_transponse__ipwrite    ) ,
    .ipwaddr    ( ldpc_dvb_enc_transponse__ipwaddr    ) ,
    .ordy       ( ldpc_dvb_enc_transponse__ordy       ) ,
    //
    .owrite     ( ldpc_dvb_enc_transponse__owrite     ) ,
    .owfull     ( ldpc_dvb_enc_transponse__owfull     ) ,
    .owaddr     ( ldpc_dvb_enc_transponse__owaddr     ) ,
    .owdat      ( ldpc_dvb_enc_transponse__owdat      )
  );


  assign ldpc_dvb_enc_transponse__iclk       = '0 ;
  assign ldpc_dvb_enc_transponse__ireset     = '0 ;
  assign ldpc_dvb_enc_transponse__iclkena    = '0 ;
  assign ldpc_dvb_enc_transponse__iwrow      = '0 ;
  assign ldpc_dvb_enc_transponse__iwdata_col = '0 ;
  assign ldpc_dvb_enc_transponse__iwrite     = '0 ;
  assign ldpc_dvb_enc_transponse__iwfull     = '0 ;
  assign ldpc_dvb_enc_transponse__iwaddr     = '0 ;
  assign ldpc_dvb_enc_transponse__iwdat      = '0 ;
  assign ldpc_dvb_enc_transponse__ipwrite    = '0 ;
  assign ldpc_dvb_enc_transponse__ipwaddr    = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_transponse.sv
// Description   : transponse {row x pDAT_W} parity bits matrix unit
//

module ldpc_dvb_enc_transponse
#(
  parameter int pADDR_W   =   8 ,
  parameter int pDAT_W    = 360 ,
  parameter int pTR_DAT_W =   8   // transponse dat_w, only 2^N (N = [1:6]) support
)
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  iwrow      ,
  iwdata_col ,
  //
  iwrite     ,
  iwfull     ,
  iwaddr     ,
  iwdat      ,
  ipwrite    ,
  ipwaddr    ,
  ordy       ,
  //
  owrite     ,
  owfull     ,
  owaddr     ,
  owdat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk       ;
  input  logic                 ireset     ;
  input  logic                 iclkena    ;
  //
  input  logic [pADDR_W-1 : 0] iwrow      ;
  input  logic [pADDR_W-1 : 0] iwdata_col ;
  //
  input  logic                 iwrite     ;
  input  logic                 iwfull     ;
  input  logic [pADDR_W-1 : 0] iwaddr     ;
  input  logic  [pDAT_W-1 : 0] iwdat      ;
  input  logic                 ipwrite    ;
  input  logic [pADDR_W-1 : 0] ipwaddr    ;
  output logic                 ordy       ;
  //
  output logic                 owrite     ;
  output logic                 owfull     ;
  output logic [pADDR_W-1 : 0] owaddr     ;
  output logic  [pDAT_W-1 : 0] owdat      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_TR_DAT_W = $clog2(pTR_DAT_W);

  localparam int cMEM_ADDR_W    = pADDR_W - cLOG2_TR_DAT_W;
  localparam int cMEM_DAT_W     = pDAT_W;

  localparam int cSHIFT_W       = cLOG2_TR_DAT_W + 1; // +1 bit for full shift
  localparam int cROW_W         = pADDR_W;
  localparam int cSEL_W         = $clog2(pDAT_W);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // parity mem
  logic                     mem__iwrite [pTR_DAT_W];
  logic [cMEM_ADDR_W-1 : 0] mem__iwaddr [pTR_DAT_W];
  logic  [cMEM_DAT_W-1 : 0] mem__iwdat  [pTR_DAT_W];
  //
  logic [cMEM_ADDR_W-1 : 0] mem__iraddr [pTR_DAT_W];
  logic  [cMEM_DAT_W-1 : 0] mem__ordat  [pTR_DAT_W];

  // ctrl
  logic      [cROW_W-1 : 0] ctrl__iwrow   ;
  logic                     ctrl__iwfull  ;
  logic                     ctrl__ordy    ;
  //
  logic                     ctrl__ibusy   ;
  logic                     ctrl__odone   ;
  //
  logic      [cROW_W-1 : 0] ctrl__otrow   ;
  logic      [cSEL_W-1 : 0] ctrl__otsel   ;
  //
  logic                     ctrl__oval    ;
  logic                     ctrl__oload   ;
  logic                     ctrl__owrite  ;
  logic    [cSHIFT_W-1 : 0] ctrl__oashift ;
  logic    [cSHIFT_W-1 : 0] ctrl__otshift ;

  // accumulator
  logic                     acc__ival     ;
  logic                     acc__iload    ;
  logic                     acc__iwrite   ;
  logic    [cSHIFT_W-1 : 0] acc__ishift   ;
  logic   [pTR_DAT_W-1 : 0] acc__idat     ;
  //
  logic                     acc__owrite   ;
  logic      [pDAT_W-1 : 0] acc__owdat    ;

  //------------------------------------------------------------------------------------------------------
  // small rams buffer (1 tick read delay) for parity bits
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < pTR_DAT_W; g++) begin : transp_ram_gen_inst
      codec_mem_block
      #(
        .pADDR_W   ( cMEM_ADDR_W        ) ,
        .pDAT_W    ( cMEM_DAT_W         ) ,
        .pPIPE     ( 0                  ) , // 1 tick read delay
        .pUSE_DRAM ( (cMEM_ADDR_W <= 6) )   // use distributed ram for <= 64 words
      )
      mem
      (
        .iclk    ( iclk             ) ,
        .ireset  ( ireset           ) ,
        .iclkena ( iclkena          ) ,
        //
        .iwrite  ( mem__iwrite  [g] ) ,
        .iwaddr  ( mem__iwaddr  [g] ) ,
        .iwdat   ( mem__iwdat   [g] ) ,
        //
        .iraddr  ( mem__iraddr  [g] ) ,
        .ordat   ( mem__ordat   [g] )
      );

      assign mem__iwrite [g] = ipwrite & (ipwaddr[cLOG2_TR_DAT_W-1 : 0] == g);
      assign mem__iwaddr [g] =            ipwaddr[pADDR_W-1 : cLOG2_TR_DAT_W] ;
      assign mem__iwdat  [g] = iwdat ;
      //
      assign mem__iraddr [g] = ctrl__otrow ;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_transponse_ctrl
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pTR_DAT_W ( pTR_DAT_W ) ,
    //
    .pROW_W    ( cROW_W    ) ,
    .pSEL_W    ( cSEL_W    ) ,
    .pSHIFT_W  ( cSHIFT_W  )
  )
  ctrl
  (
    .iclk    ( iclk          ) ,
    .ireset  ( ireset        ) ,
    .iclkena ( iclkena       ) ,
    //
    .iwrow   ( ctrl__iwrow   ) ,
    .iwfull  ( ctrl__iwfull  ) ,
    .ordy    ( ctrl__ordy    ) ,
    //
    .ibusy   ( ctrl__ibusy   ) ,
    .odone   ( ctrl__odone   ) ,
    //
    .otrow   ( ctrl__otrow   ) ,
    .otsel   ( ctrl__otsel   ) ,
    //
    .oval    ( ctrl__oval    ) ,
    .oload   ( ctrl__oload   ) ,
    .owrite  ( ctrl__owrite  ) ,
    .oashift ( ctrl__oashift ) ,
    .otshift ( ctrl__otshift )
  );

  assign ctrl__iwrow  = iwrow  ;
  assign ctrl__iwfull = iwfull ;

  assign ctrl__ibusy  = acc__ival ;

  assign ordy         = ctrl__ordy;
  assign owfull       = ctrl__odone;

  //------------------------------------------------------------------------------------------------------
  // line accumulator
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_enc_transponse_acc
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pTR_DAT_W ( pTR_DAT_W ) ,
    .pSHIFT_W  ( cSHIFT_W  )
  )
  acc
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .ival    ( acc__ival    ) ,
    .iload   ( acc__iload   ) ,
    .iwrite  ( acc__iwrite  ) ,
    .ishift  ( acc__ishift  ) ,
    .idat    ( acc__idat    ) ,
    //
    .owrite  ( acc__owrite  ) ,
    .owdat   ( acc__owdat   )
  );

  // 2 tick delay inside ctrl
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      acc__ival <= 1'b0;
    end
    else if (iclkena) begin
      acc__ival <= ctrl__oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      acc__iload  <= ctrl__oload;
      acc__iwrite <= ctrl__owrite;
      acc__ishift <= ctrl__oload ? ctrl__oashift : ctrl__otshift;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // 1 tick ram read delay
  // + do wide muxing 360 -> 1 2 phased : ceil(360/16)x(16 -> 1) & ceil(360/16) -> 1
  //------------------------------------------------------------------------------------------------------

  localparam int cTMUX_NUM = (pDAT_W/16) + ((pDAT_W % 16) != 0);

  logic       [cSEL_W-1 : 0] ctrl_tsel             ;
  logic       [cSEL_W-1 : 4] tmux_sel              ;
  logic    [cTMUX_NUM-1 : 0] tmux_dat  [pTR_DAT_W] ;

  // remove simulation warning
  logic [cTMUX_NUM*16-1 : 0] mem_rdat  [pTR_DAT_W] ;

  always_comb begin
    for (int i = 0; i < pTR_DAT_W; i++) begin
      mem_rdat[i] = mem__ordat[i];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // allign 1 tick ram read delay
      ctrl_tsel <= ctrl__otsel;
      // mux lsw and save msw mix idx to next tick
      for (int i = 0; i < pTR_DAT_W; i++) begin
        for (int m = 0; m < cTMUX_NUM; m++) begin
          tmux_dat[i][m] <= mem_rdat[i][{m[cSEL_W-1-4 : 0], ctrl_tsel[3 : 0]}];
        end
      end
      tmux_sel <= ctrl_tsel[cSEL_W-1 : 4];
      // mux msw
      for (int i = 0; i < pTR_DAT_W; i++) begin
        acc__idat[i] <= tmux_dat[i][tmux_sel];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output muxer
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
    end
    else if (iclkena) begin
      owrite <= (iwrite & !ipwrite) | acc__owrite;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite) begin
        owaddr <= !ipwrite ? iwaddr : (iwdata_col - 1'b1); // hold last address for parity start addr with incr
      end
      else if (acc__owrite) begin
        owaddr <= owaddr + 1'b1;
      end
      owdat <= iwrite ? iwdat : acc__owdat;
    end
  end

endmodule
