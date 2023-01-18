/*



  parameter int pW      = 13 ;
  parameter int pADDR_W =  8 ;
  parameter int pDAT_W  =  2 ;
  parameter int pDTAG_W =  8 ;
  parameter int pTAG_W  =  8 ;



  logic                 rsc_dec_sink__iclk    ;
  logic                 rsc_dec_sink__ireset  ;
  logic                 rsc_dec_sink__iclkena ;
  logic      [pW-1 : 0] rsc_dec_sink__iN      ;
  logic                 rsc_dec_sink__ifull   ;
  logic  [pDAT_W-1 : 0] rsc_dec_sink__irdata  ;
  logic  [pDAT_W-1 : 0] rsc_dec_sink__irderr  ;
  logic [pDTAG_W-1 : 0] rsc_dec_sink__irdtag  ;
  logic        [15 : 0] rsc_dec_sink__ierr    ;
  logic  [pTAG_W-1 : 0] rsc_dec_sink__itag    ;
  logic                 rsc_dec_sink__orempty ;
  logic [pADDR_W-1 : 0] rsc_dec_sink__oraddr  ;
  logic                 rsc_dec_sink__ireq    ;
  logic                 rsc_dec_sink__ofull   ;
  logic                 rsc_dec_sink__osop    ;
  logic                 rsc_dec_sink__oeop    ;
  logic                 rsc_dec_sink__oval    ;
  logic  [pDAT_W-1 : 0] rsc_dec_sink__odat    ;
  logic  [pDAT_W-1 : 0] rsc_dec_sink__oderr   ;
  logic [pDTAG_W-1 : 0] rsc_dec_sink__odtag   ;
  logic  [pTAG_W-1 : 0] rsc_dec_sink__otag    ;
  logic        [15 : 0] rsc_dec_sink__oerr    ;



  rsc_dec_sink
  #(
    .pW      ( pW      ) ,
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pDTAG_W ( pDTAG_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  rsc_dec_sink
  (
    .iclk    ( rsc_dec_sink__iclk    ) ,
    .ireset  ( rsc_dec_sink__ireset  ) ,
    .iclkena ( rsc_dec_sink__iclkena ) ,
    .iN      ( rsc_dec_sink__iN      ) ,
    .ifull   ( rsc_dec_sink__ifull   ) ,
    .irdata  ( rsc_dec_sink__irdata  ) ,
    .irderr  ( rsc_dec_sink__irderr  ) ,
    .irdtag  ( rsc_dec_sink__irdtag  ) ,
    .ierr    ( rsc_dec_sink__ierr    ) ,
    .itag    ( rsc_dec_sink__itag    ) ,
    .orempty ( rsc_dec_sink__orempty ) ,
    .oraddr  ( rsc_dec_sink__oraddr  ) ,
    .ireq    ( rsc_dec_sink__ireq    ) ,
    .ofull   ( rsc_dec_sink__ofull   ) ,
    .otag    ( rsc_dec_sink__otag    ) ,
    .osop    ( rsc_dec_sink__osop    ) ,
    .oeop    ( rsc_dec_sink__oeop    ) ,
    .oval    ( rsc_dec_sink__oval    ) ,
    .odat    ( rsc_dec_sink__odat    ) ,
    .oderr   ( rsc_dec_sink__oderr   ) ,
    .odtag   ( rsc_dec_sink__odtag   ) ,
    .oerr    ( rsc_dec_sink__oerr    )
  );


  assign rsc_dec_sink__iclk    = '0 ;
  assign rsc_dec_sink__ireset  = '0 ;
  assign rsc_dec_sink__iclkena = '0 ;
  assign rsc_dec_sink__iN      = '0 ;
  assign rsc_dec_sink__ifull   = '0 ;
  assign rsc_dec_sink__irdata  = '0 ;
  assign rsc_dec_sink__irderr  = '0 ;
  assign rsc_dec_sink__irdtag  = '0 ;
  assign rsc_dec_sink__ierr    = '0 ;
  assign rsc_dec_sink__itag    = '0 ;
  assign rsc_dec_sink__ireq    = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_sink.sv
// Description   : Output interface of decoder. Read decoder duobits from ouput ram buffer and drive to external interface
//

`include "define.vh"

module rsc_dec_sink
#(
  parameter int pW      = 13 , // don't change
  parameter int pADDR_W =  8 ,
  parameter int pDAT_W  =  2 ,
  parameter int pDTAG_W =  8 ,
  parameter int pTAG_W  =  8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iN      ,
  //
  ifull   ,
  irdata  ,
  irderr  ,
  irdtag  ,
  ierr    ,
  itag    ,
  orempty ,
  oraddr  ,
  //
  ireq    ,
  ofull   ,
  //
  otag    ,
  osop    ,
  oeop    ,
  oval    ,
  odat    ,
  oderr   ,
  odtag   ,
  oerr
);

  `include "../rsc_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  logic      [pW-1 : 0] iN       ;
  //
  input  logic                 ifull    ;
  input  logic  [pDAT_W-1 : 0] irdata   ;
  input  logic  [pDAT_W-1 : 0] irderr   ;
  input  logic [pDTAG_W-1 : 0] irdtag   ;
  input  logic        [15 : 0] ierr     ;
  input  logic  [pTAG_W-1 : 0] itag     ;
  output logic                 orempty  ;
  output logic [pADDR_W-1 : 0] oraddr   ;
  //
  input  logic                 ireq     ;
  output logic                 ofull    ;
  //
  output logic  [pTAG_W-1 : 0] otag     ;
  output logic                 osop     ;
  output logic                 oeop     ;
  output logic                 oval     ;
  output logic  [pDAT_W-1 : 0] odat     ;
  output logic  [pDAT_W-1 : 0] oderr    ;
  output logic [pDTAG_W-1 : 0] odtag    ;
  output logic        [15 : 0] oerr     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cWORK_STATE
  } state;

  logic rd_done;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=            ifull ? cWORK_STATE  : cRESET_STATE;
        cWORK_STATE  : state <= (ireq & rd_done) ? cRESET_STATE : cWORK_STATE;
      endcase
    end
  end

  assign orempty = (state == cWORK_STATE & ireq & rd_done);

  //------------------------------------------------------------------------------------------------------
  // address generator
  //------------------------------------------------------------------------------------------------------

  localparam int cN_LSB = clogb2(pDAT_W/2);

  logic [pADDR_W-1 : 0] edgeS;

  wire [pW-1 : 0] used_N = iN[pW-1 : cN_LSB] - 2'd2;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        oraddr  <= '0;
        rd_done <= 1'b0;
        edgeS   <= used_N[pADDR_W-1 : 0];
      end
      else if (state == cWORK_STATE & ireq) begin
        oraddr  <= oraddr + 1'b1;
        rd_done <= (oraddr == edgeS);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output interface
  //------------------------------------------------------------------------------------------------------

  logic         sop;
  logic [1 : 0] val;
  logic [1 : 0] eop;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val   <= '0;
      ofull <= 1'b0;
      sop   <= '0;
      osop  <= 1'b0;
    end
    else if (iclkena) begin
      val <= (val << 1) | (state == cWORK_STATE  & ireq);
      sop <=              (state == cRESET_STATE & ifull); // align delay of output strobe generation line
      //
      if (state == cRESET_STATE & ifull) begin
        ofull <= 1'b1;
      end
      else if (orempty) begin
        ofull <= 1'b0;
      end
      //
      if (sop) begin
        osop <= 1'b1;
      end
      else if (oval) begin
        osop <= 1'b0;
      end
    end
  end

  assign oval = val[1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      eop  <= (eop << 1) | (state == cWORK_STATE & rd_done);
      //
      if (state == cRESET_STATE & ifull) begin
        oerr <= ierr;
        otag <= itag;
      end
      //
      odat  <= irdata;
      oderr <= irderr;
      odtag <= irdtag;
    end
  end

  assign oeop = eop[1];

endmodule
