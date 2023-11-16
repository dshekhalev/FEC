/*



  parameter int pTAG_W   = 8 ;
  parameter int pRDAT_W  = 8 ;
  parameter int pRADDR_W = 8 ;



  logic                             btc_enc_sink__iclk    ;
  logic                             btc_enc_sink__ireset  ;
  logic                             btc_enc_sink__iclkena ;
  //
  btc_code_mode_t                   btc_enc_sink__ixmode  ;
  btc_code_mode_t                   btc_enc_sink__iymode  ;
  btc_short_mode_t                  btc_enc_sink__ismode  ;
  //
  logic                             btc_enc_sink__irfull  ;
  logic             [pRDAT_W-1 : 0] btc_enc_sink__irdat   ;
  logic              [pTAG_W-1 : 0] btc_enc_sink__irtag   ;
  logic                             btc_enc_sink__oread   ;
  logic                             btc_enc_sink__orempty ;
  logic            [pRADDR_W-1 : 0] btc_enc_sink__oraddr  ;
  //
  logic                             btc_enc_sink__ireq    ;
  logic                             btc_enc_sink__ofull   ;
  //
  logic                             btc_enc_sink__oval    ;
  logic                             btc_enc_sink__osop    ;
  logic                             btc_enc_sink__oeop    ;
  logic                             btc_enc_sink__odat    ;
  logic              [pTAG_W-1 : 0] btc_enc_sink__otag    ;



  btc_enc_sink
  #(
    .pTAG_W   ( pTAG_W   ) ,
    .pRDAT_W  ( pRDAT_W  ) ,
    .pRADDR_W ( pRADDR_W )
  )
  btc_enc_sink
  (
    .iclk    ( btc_enc_sink__iclk    ) ,
    .ireset  ( btc_enc_sink__ireset  ) ,
    .iclkena ( btc_enc_sink__iclkena ) ,
    //
    .ixmode  ( btc_enc_sink__ixmode  ) ,
    .iymode  ( btc_enc_sink__iymode  ) ,
    .ismode  ( btc_enc_sink__ismode  ) ,
    //
    .irfull  ( btc_enc_sink__irfull  ) ,
    .irdat   ( btc_enc_sink__irdat   ) ,
    .irtag   ( btc_enc_sink__irtag   ) ,
    .oread   ( btc_enc_sink__oread   ) ,
    .orempty ( btc_enc_sink__orempty ) ,
    .oraddr  ( btc_enc_sink__oraddr  ) ,
    //
    .ireq    ( btc_enc_sink__ireq    ) ,
    .ofull   ( btc_enc_sink__ofull   ) ,
    //
    .oval    ( btc_enc_sink__oval    ) ,
    .osop    ( btc_enc_sink__osop    ) ,
    .oeop    ( btc_enc_sink__oeop    ) ,
    .odat    ( btc_enc_sink__odat    ) ,
    .otag    ( btc_enc_sink__otag    )
  );


  assign btc_enc_sink__iclk    = '0 ;
  assign btc_enc_sink__ireset  = '0 ;
  assign btc_enc_sink__iclkena = '0 ;
  assign btc_enc_sink__ixmode  = '0 ;
  assign btc_enc_sink__iymode  = '0 ;
  assign btc_enc_sink__ismode  = '0 ;
  assign btc_enc_sink__irfull  = '0 ;
  assign btc_enc_sink__irdat   = '0 ;
  assign btc_enc_sink__irtag   = '0 ;
  assign btc_enc_sink__ireq    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_enc_sink.sv
// Description   : BTC encoder sink unit with bitserial output
//

module btc_enc_sink
#(
  parameter int pTAG_W   = 8 ,
  parameter int pRDAT_W  = 8 ,
  parameter int pRADDR_W = 8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ixmode  ,
  iymode  ,
  ismode  ,
  //
  irfull  ,
  irdat   ,
  irtag   ,
  oread   ,
  orempty ,
  oraddr  ,
  //
  ireq    ,
  ofull   ,
  //
  oval    ,
  osop    ,
  oeop    ,
  odat    ,
  otag
);

  `include "../btc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                             iclk    ;
  input  logic                             ireset  ;
  input  logic                             iclkena ;
  //
  input  btc_code_mode_t                   ixmode  ;
  input  btc_code_mode_t                   iymode  ;
  input  btc_short_mode_t                  ismode  ;
  //
  input  logic                             irfull  ;
  input  logic             [pRDAT_W-1 : 0] irdat   ;
  input  logic              [pTAG_W-1 : 0] irtag   ;
  output logic                             oread   ;
  output logic                             orempty ;
  output logic            [pRADDR_W-1 : 0] oraddr  ;
  //
  input  logic                             ireq    ;
  output logic                             ofull   ;
  //
  output logic                             oval    ;
  output logic                             osop    ;
  output logic                             oeop    ;
  output logic                             odat    ;
  output logic              [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  logic [cLOG2_COL_MAX-1 : 0] col_length_m2;

  struct packed {
    logic                       done;
    logic [cLOG2_COL_MAX-1 : 0] value;
  } row_idx;

  logic [cLOG2_ROW_MAX-1 : 0] row_length_m2;

  struct packed {
    logic                       done;
    logic [cLOG2_ROW_MAX-1 : 0] value;
  } col_idx;

  logic [2 : 0] val;
  logic [2 : 0] eop;

  logic [1 : 0] set_sf; // set sop/full

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire work_done = col_idx.done & row_idx.done;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=  irfull            ? cDO_STATE    : cRESET_STATE;
        cDO_STATE    : state <= (ireq & work_done) ? cRESET_STATE : cDO_STATE;
      endcase
    end
  end

  assign orempty = (state == cDO_STATE & ireq & work_done);

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        row_idx <= '0;
        col_idx <= '0;
        //
        row_length_m2 <= get_code_bits(ixmode) - 2;
        col_length_m2 <= get_code_bits(iymode) - 2;
      end
      else if (state == cDO_STATE & ireq) begin
        col_idx.value <=  col_idx.done ? '0 : (col_idx.value + 1'b1);
        col_idx.done  <= (col_idx.value == row_length_m2);
        //
        if (col_idx.done) begin
          row_idx.value <=  row_idx.value + 1'b1;
          row_idx.done  <= (row_idx.value == col_length_m2);
        end
      end
    end
  end

  assign oread  = 1'b1;

  assign oraddr[0             +: cLOG2_ROW_MAX] = col_idx.value;
  assign oraddr[cLOG2_ROW_MAX +: cLOG2_COL_MAX] = row_idx.value;

  //------------------------------------------------------------------------------------------------------
  // output mapping
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
      val     <= (val  << 1) | (state == cDO_STATE & ireq);
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
      eop  <= (eop << 1) | (state == cDO_STATE & work_done);
      //
      odat <= irdat;
      //
      if (start) begin
        otag <= irtag;
      end
    end
  end

  assign oeop = eop [2];

endmodule
