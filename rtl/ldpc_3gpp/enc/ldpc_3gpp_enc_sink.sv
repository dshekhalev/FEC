/*



  parameter int pADDR_W = 1 ;
  parameter int pDAT_W  = 2 ;
  parameter int pTAG_W  = 4 ;



  logic                 ldpc_3gpp_enc_sink__iclk      ;
  logic                 ldpc_3gpp_enc_sink__ireset    ;
  logic                 ldpc_3gpp_enc_sink__iclkena   ;
  //
  logic [pADDR_W-1 : 0] ldpc_3gpp_enc_sink__inum_m1   ;
  //
  logic                 ldpc_3gpp_enc_sink__ifull     ;
  logic  [pDAT_W-1 : 0] ldpc_3gpp_enc_sink__irdat     ;
  logic  [pTAG_W-1 : 0] ldpc_3gpp_enc_sink__irtag     ;
  logic                 ldpc_3gpp_enc_sink__orempty   ;
  logic [pADDR_W-1 : 0] ldpc_3gpp_enc_sink__oraddr    ;
  //
  logic                 ldpc_3gpp_enc_sink__ireq      ;
  logic                 ldpc_3gpp_enc_sink__ofull     ;
  //
  logic                 ldpc_3gpp_enc_sink__osop      ;
  logic                 ldpc_3gpp_enc_sink__oeop      ;
  logic                 ldpc_3gpp_enc_sink__oval      ;
  logic  [pDAT_W-1 : 0] ldpc_3gpp_enc_sink__odat      ;
  logic  [pTAG_W-1 : 0] ldpc_3gpp_enc_sink__otag      ;



  ldpc_3gpp_enc_sink
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pTAG_W  ( pTAG_W  )
  )
  ldpc_3gpp_enc_sink
  (
    .iclk      ( ldpc_3gpp_enc_sink__iclk      ) ,
    .ireset    ( ldpc_3gpp_enc_sink__ireset    ) ,
    .iclkena   ( ldpc_3gpp_enc_sink__iclkena   ) ,
    //
    .inum_m1   ( ldpc_3gpp_enc_sink__inum_m1   ) ,
    //
    .ifull     ( ldpc_3gpp_enc_sink__ifull     ) ,
    .irdat     ( ldpc_3gpp_enc_sink__irdat     ) ,
    .irtag     ( ldpc_3gpp_enc_sink__irtag     ) ,
    .orempty   ( ldpc_3gpp_enc_sink__orempty   ) ,
    .oraddr    ( ldpc_3gpp_enc_sink__oraddr    ) ,
    //
    .ireq      ( ldpc_3gpp_enc_sink__ireq      ) ,
    .ofull     ( ldpc_3gpp_enc_sink__ofull     ) ,
    //
    .osop      ( ldpc_3gpp_enc_sink__osop      ) ,
    .oeop      ( ldpc_3gpp_enc_sink__oeop      ) ,
    .oval      ( ldpc_3gpp_enc_sink__oval      ) ,
    .odat      ( ldpc_3gpp_enc_sink__odat      ) ,
    .otag      ( ldpc_3gpp_enc_sink__otag      )
  );


  assign ldpc_3gpp_enc_sink__iclk     = '0 ;
  assign ldpc_3gpp_enc_sink__ireset   = '0 ;
  assign ldpc_3gpp_enc_sink__iclkena  = '0 ;
  //
  assign ldpc_3gpp_enc_sink__inum_m1  = '0 ;
  //
  assign ldpc_3gpp_enc_sink__ifull    = '0 ;
  assign ldpc_3gpp_enc_sink__irdat    = '0 ;
  assign ldpc_3gpp_enc_sink__irtag    = '0 ;
  assign ldpc_3gpp_enc_sink__ireq     = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_sink.sv
// Description   : ouput encoder interface module
//


module ldpc_3gpp_enc_sink
#(
  parameter int pADDR_W = 1 ,
  parameter int pDAT_W  = 8 ,
  //
  parameter int pTAG_W  = 4
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  inum_m1   ,
  //
  ifull     ,
  irdat     ,
  irtag     ,
  orempty   ,
  oraddr    ,
  //
  ireq      ,
  ofull     ,
  //
  osop      ,
  oeop      ,
  oval      ,
  odat      ,
  otag
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk     ;
  input  logic                   ireset   ;
  input  logic                   iclkena  ;
  //
  input  logic   [pADDR_W-1 : 0] inum_m1  ;
  //
  input  logic                   ifull    ;
  input  logic    [pDAT_W-1 : 0] irdat    ;
  input  logic    [pTAG_W-1 : 0] irtag    ;
  output logic                   orempty  ;
  output logic   [pADDR_W-1 : 0] oraddr   ;
  //
  input  logic                   ireq     ;
  output logic                   ofull    ;
  //
  output logic                   osop     ;
  output logic                   oeop     ;
  output logic                   oval     ;
  output logic    [pDAT_W-1 : 0] odat     ;
  output logic    [pTAG_W-1 : 0] otag     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [pADDR_W-1 : 0] addr_t;

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    addr_t done_value;
    logic  done;
    addr_t value;
  } cnt;

  logic [2 : 0] val;
  logic [2 : 0] eop;

  logic [1 : 0] set_sf; // set sop/full

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=  ifull            ? cDO_STATE    : cRESET_STATE;
        cDO_STATE    : state <= (ireq & cnt.done) ? cRESET_STATE : cDO_STATE;
      endcase
    end
  end

  assign orempty = (state == cDO_STATE & ireq & cnt.done);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        cnt            <= '0;
        cnt.done_value <= inum_m1 - 1'b1;
//      cnt.done       <= (inum_m1 < 2); // impossible because there is at least 12/24 zc blocks
      end
      else if (state == cDO_STATE & ireq) begin
        cnt.value <= cnt.done ? '0 : (cnt.value + 1'b1);
        cnt.done  <= (cnt.value == cnt.done_value);
      end
    end
  end

  assign oraddr = cnt.value;

  wire start = (state == cRESET_STATE & ifull);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val     <= '0;
      set_sf  <= '0;
      //
      ofull   <= 1'b0;
      osop    <= 1'b0;
    end
    else if (iclkena) begin
      val     <= (val << 1) | (state == cDO_STATE & ireq);
      //
      set_sf  <= (set_sf << 1) | start;
      //
      if (set_sf[1]) begin
        ofull <= 1'b1;
      end
      else if (orempty) begin
        ofull <= 1'b0;
      end
      //
      if (set_sf[1]) begin
        osop <= 1'b1;
      end
      else if (oval) begin
        osop <= 1'b0;
      end
    end
  end

  assign oval = val[2];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      eop <= (eop << 1) | (state == cDO_STATE & cnt.done);
      //
      odat <= irdat;
      if (start) begin
        otag <= irtag;
      end
    end
  end

  assign oeop = eop[2];

endmodule
