/*



  parameter int pADDR_W =  8 ;
  parameter int pTAG_W  =  8 ;



  logic                 rsc_enc_sink__iclk    ;
  logic                 rsc_enc_sink__ireset  ;
  logic                 rsc_enc_sink__iclkena ;
  logic [pADDR_W-1 : 0] rsc_enc_sink__irsize  ;
  logic                 rsc_enc_sink__irfull  ;
  logic         [1 : 0] rsc_enc_sink__irdat   ;
  logic  [pTAG_W-1 : 0] rsc_enc_sink__irtag   ;
  logic                 rsc_enc_sink__orempty ;
  logic [pADDR_W-1 : 0] rsc_enc_sink__oraddr  ;
  logic                 rsc_enc_sink__ireq    ;
  logic                 rsc_enc_sink__ofull   ;
  logic                 rsc_enc_sink__osop    ;
  logic                 rsc_enc_sink__oeop    ;
  logic                 rsc_enc_sink__oval    ;
  logic         [1 : 0] rsc_enc_sink__odat    ;
  logic  [pTAG_W-1 : 0] rsc_enc_sink__otag    ;



  rsc_enc_sink
  #(
    .pADDR_W ( pADDR_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  rsc_enc_sink
  (
    .iclk    ( rsc_enc_sink__iclk    ) ,
    .ireset  ( rsc_enc_sink__ireset  ) ,
    .iclkena ( rsc_enc_sink__iclkena ) ,
    //
    .irsize  ( rsc_enc_sink__irsize  ) ,
    //
    .irfull  ( rsc_enc_sink__irfull  ) ,
    .irdat   ( rsc_enc_sink__irdat   ) ,
    .irtag   ( rsc_enc_sink__irtag   ) ,
    .orempty ( rsc_enc_sink__orempty ) ,
    .oraddr  ( rsc_enc_sink__oraddr  ) ,
    //
    .ireq    ( rsc_enc_sink__ireq    ) ,
    .ofull   ( rsc_enc_sink__ofull   ) ,
    //
    .osop    ( rsc_enc_sink__osop    ) ,
    .oeop    ( rsc_enc_sink__oeop    ) ,
    .oval    ( rsc_enc_sink__oval    ) ,
    .odat    ( rsc_enc_sink__odat    ) ,
    .otag    ( rsc_enc_sink__otag    )
  );


  assign rsc_enc_sink__iclk    = '0 ;
  assign rsc_enc_sink__ireset  = '0 ;
  assign rsc_enc_sink__iclkena = '0 ;
  assign rsc_enc_sink__irsize  = '0 ;
  assign rsc_enc_sink__irfull  = '0 ;
  assign rsc_enc_sink__irdat   = '0 ;
  assign rsc_enc_sink__irtag   = '0 ;
  assign rsc_enc_sink__ireq    = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_enc_sink.sv
// Description   : Output interface of encoder with output buffer. Read decoder duobits from ouput ram buffer and drive to external interface
//

module rsc_enc_sink
#(
  parameter int pADDR_W =  8 ,
  parameter int pTAG_W  =  8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  irsize  ,
  //
  irfull  ,
  irdat   ,
  irtag   ,
  orempty ,
  oraddr  ,
  //
  ireq    ,
  ofull   ,
  //
  osop    ,
  oeop    ,
  oval    ,
  odat    ,
  otag
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  logic [pADDR_W-1 : 0] irsize   ;
  //
  input  logic                 irfull   ;
  input  logic         [1 : 0] irdat    ;
  input  logic  [pTAG_W-1 : 0] irtag    ;
  output logic                 orempty  ;
  output logic [pADDR_W-1 : 0] oraddr   ;
  //
  input  logic                 ireq     ;
  output logic                 ofull    ;
  //
  output logic                 osop     ;
  output logic                 oeop     ;
  output logic                 oval     ;
  output logic         [1 : 0] odat     ;
  output logic  [pTAG_W-1 : 0] otag     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic                 done;
    logic [pADDR_W-1 : 0] value;
  } cnt;

  logic [1 : 0] val;
  logic [1 : 0] eop;

  logic [1 : 0] rdat;

  logic [0 : 0] set_sf; // set sop/full

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=  irfull           ? cDO_STATE    : cRESET_STATE;
        cDO_STATE    : state <= (ireq & cnt.done) ? cRESET_STATE : cDO_STATE;
      endcase
    end
  end

  assign orempty = (state == cDO_STATE & ireq & cnt.done);

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        cnt <= '0;
      end
      else if (state == cDO_STATE & ireq) begin
        cnt.value <= (cnt.value + 1'b1);
        cnt.done  <= (cnt.value == (irsize - 2));
      end
    end
  end

  assign oraddr = cnt.value;

  //------------------------------------------------------------------------------------------------------
  // ram reasd latency is 1 tick (!!!)
  //------------------------------------------------------------------------------------------------------

  wire start = (state == cRESET_STATE) & irfull;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val     <= '0;
      set_sf  <= '0;
      //
      ofull   <= 1'b0;
      osop    <= 1'b0;
    end
    else if (iclkena) begin
      val     <= (val << 1) | (state == cDO_STATE  & ireq);
      //
      set_sf  <= (set_sf << 1) | start;
      //
      if (set_sf[0]) begin
        ofull <= 1'b1;
      end
      else if (orempty) begin
        ofull <= 1'b0;
      end
      //
      if (set_sf[0]) begin
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
      eop  <= (eop << 1) | (state == cDO_STATE & cnt.done);
      //
      if (val[0]) begin
        rdat <= irdat;
      end
      //
      if (start) begin
        otag <= irtag;
      end
    end
  end

  assign odat = rdat;
  assign oeop = eop [1];

endmodule
