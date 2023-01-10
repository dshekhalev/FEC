/*



  parameter int pADDR_W =  8 ;
  parameter int pDAT_W  =  2 ;
  parameter int pTAG_W  =  8 ;



  logic                 ccsds_turbo_dec_sink__iclk    ;
  logic                 ccsds_turbo_dec_sink__ireset  ;
  logic                 ccsds_turbo_dec_sink__iclkena ;
  ptab_dat_t            ccsds_turbo_dec_sink__iN      ;
  logic                 ccsds_turbo_dec_sink__ifull   ;
  logic  [pDAT_W-1 : 0] ccsds_turbo_dec_sink__irdata  ;
  logic        [15 : 0] ccsds_turbo_dec_sink__ierr    ;
  logic  [pTAG_W-1 : 0] ccsds_turbo_dec_sink__itag    ;
  logic                 ccsds_turbo_dec_sink__orempty ;
  logic [pADDR_W-1 : 0] ccsds_turbo_dec_sink__oraddr  ;
  logic                 ccsds_turbo_dec_sink__ireq    ;
  logic                 ccsds_turbo_dec_sink__ofull   ;
  logic  [pTAG_W-1 : 0] ccsds_turbo_dec_sink__otag    ;
  logic                 ccsds_turbo_dec_sink__osop    ;
  logic                 ccsds_turbo_dec_sink__oeop    ;
  logic                 ccsds_turbo_dec_sink__oval    ;
  logic  [pDAT_W-1 : 0] ccsds_turbo_dec_sink__odat    ;
  logic        [15 : 0] ccsds_turbo_dec_sink__oerr    ;



  ccsds_turbo_dec_sink
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pTAG_W  ( pTAG_W  )
  )
  ccsds_turbo_dec_sink
  (
    .iclk    ( ccsds_turbo_dec_sink__iclk    ) ,
    .ireset  ( ccsds_turbo_dec_sink__ireset  ) ,
    .iclkena ( ccsds_turbo_dec_sink__iclkena ) ,
    .iN      ( ccsds_turbo_dec_sink__iN      ) ,
    .ifull   ( ccsds_turbo_dec_sink__ifull   ) ,
    .irdata  ( ccsds_turbo_dec_sink__irdata  ) ,
    .ierr    ( ccsds_turbo_dec_sink__ierr    ) ,
    .itag    ( ccsds_turbo_dec_sink__itag    ) ,
    .orempty ( ccsds_turbo_dec_sink__orempty ) ,
    .oraddr  ( ccsds_turbo_dec_sink__oraddr  ) ,
    .ireq    ( ccsds_turbo_dec_sink__ireq    ) ,
    .ofull   ( ccsds_turbo_dec_sink__ofull   ) ,
    .otag    ( ccsds_turbo_dec_sink__otag    ) ,
    .osop    ( ccsds_turbo_dec_sink__osop    ) ,
    .oeop    ( ccsds_turbo_dec_sink__oeop    ) ,
    .oval    ( ccsds_turbo_dec_sink__oval    ) ,
    .odat    ( ccsds_turbo_dec_sink__odat    ) ,
    .oerr    ( ccsds_turbo_dec_sink__oerr    )
  );


  assign ccsds_turbo_dec_sink__iclk    = '0 ;
  assign ccsds_turbo_dec_sink__ireset  = '0 ;
  assign ccsds_turbo_dec_sink__iclkena = '0 ;
  assign ccsds_turbo_dec_sink__iN      = '0 ;
  assign ccsds_turbo_dec_sink__ifull   = '0 ;
  assign ccsds_turbo_dec_sink__irdata  = '0 ;
  assign ccsds_turbo_dec_sink__ierr    = '0 ;
  assign ccsds_turbo_dec_sink__itag    = '0 ;
  assign ccsds_turbo_dec_sink__ireq    = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_sink.sv
// Description   : Output interface of decoder. Read decoder duobits from ouput ram buffer and drive to external interface
//


module ccsds_turbo_dec_sink
#(
  parameter int pADDR_W =  8 ,
  parameter int pDAT_W  =  2 ,
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
  oerr
);

  `include "../ccsds_turbo_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  ptab_dat_t            iN       ;
  //
  input  logic                 ifull    ;
  input  logic  [pDAT_W-1 : 0] irdata   ;
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
  // address generator :: take into account DWC
  //------------------------------------------------------------------------------------------------------

  localparam int cN_LSB = $clog2(pDAT_W);

  logic [pADDR_W-1 : 0] edgeS;
  ptab_dat_t            used_N;

  assign used_N = iN[cW-1 : cN_LSB] - 2'd2;

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
      odat <= irdata;
    end
  end

  assign oeop = eop[1];

endmodule
