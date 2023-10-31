/*



  parameter int pRDAT_W  =  8 ;
  parameter int pRADDR_W =  8 ;
  //
  parameter int pERR_W   = 16 ;
  //
  parameter int pTAG_W   =  8 ;



  logic                             btc_dec_sink__iclk      ;
  logic                             btc_dec_sink__ireset    ;
  logic                             btc_dec_sink__iclkena   ;
  //
  btc_code_mode_t                   btc_dec_sink__ixmode    ;
  btc_code_mode_t                   btc_dec_sink__iymode    ;
  btc_short_mode_t                  btc_dec_sink__ismode    ;
  //
  logic                             btc_dec_sink__irfull    ;
  logic             [pRDAT_W-1 : 0] btc_dec_sink__irdat     ;
  logic              [pTAG_W-1 : 0] btc_dec_sink__irtag     ;
  //
  logic              [pERR_W-1 : 0] btc_dec_sink__irerr     ;
  logic                             btc_dec_sink__irdecfail ;
  //
  logic                             btc_dec_sink__orempty   ;
  logic            [pRADDR_W-1 : 0] btc_dec_sink__oraddr    ;
  //
  logic                             btc_dec_sink__ireq      ;
  logic                             btc_dec_sink__ofull     ;
  //
  logic                             btc_dec_sink__oval      ;
  logic                             btc_dec_sink__osop      ;
  logic                             btc_dec_sink__oeop      ;
  logic                             btc_dec_sink__odat      ;
  logic              [pTAG_W-1 : 0] btc_dec_sink__otag      ;
  //
  logic                             btc_dec_sink__odecfail  ;
  logic              [pERR_W-1 : 0] btc_dec_sink__oerr      ;
  logic              [pERR_W-1 : 0] btc_dec_sink__onum      ;



  btc_dec_sink
  #(
    .pRDAT_W  ( pRDAT_W  ) ,
    .pRADDR_W ( pRADDR_W ) ,
    //
    .pERR_W   ( pERR_W   ) ,
    //
    .pTAG_W   ( pTAG_W   )
  )
  btc_dec_sink
  (
    .iclk      ( btc_dec_sink__iclk      ) ,
    .ireset    ( btc_dec_sink__ireset    ) ,
    .iclkena   ( btc_dec_sink__iclkena   ) ,
    //
    .ixmode    ( btc_dec_sink__ixmode    ) ,
    .iymode    ( btc_dec_sink__iymode    ) ,
    .ismode    ( btc_dec_sink__ismode    ) ,
    //
    .irfull    ( btc_dec_sink__irfull    ) ,
    .irdat     ( btc_dec_sink__irdat     ) ,
    .irtag     ( btc_dec_sink__irtag     ) ,
    //
    .irerr     ( btc_dec_sink__irerr     ) ,
    .irdecfail ( btc_dec_sink__irdecfail ) ,
    //
    .orempty   ( btc_dec_sink__orempty   ) ,
    .oraddr    ( btc_dec_sink__oraddr    ) ,
    //
    .ireq      ( btc_dec_sink__ireq      ) ,
    .ofull     ( btc_dec_sink__ofull     ) ,
    //
    .oval      ( btc_dec_sink__oval      ) ,
    .osop      ( btc_dec_sink__osop      ) ,
    .oeop      ( btc_dec_sink__oeop      ) ,
    .odat      ( btc_dec_sink__odat      ) ,
    .otag      ( btc_dec_sink__otag      ) ,
    //
    .odecfail  ( btc_dec_sink__odecfail  ) ,
    .oerr      ( btc_dec_sink__oerr      ) ,
    .onum      ( btc_dec_sink__onum      )
  );


  assign btc_dec_sink__iclk      = '0 ;
  assign btc_dec_sink__ireset    = '0 ;
  assign btc_dec_sink__iclkena   = '0 ;
  assign btc_dec_sink__ixmode    = '0 ;
  assign btc_dec_sink__iymode    = '0 ;
  assign btc_dec_sink__ismode    = '0 ;
  assign btc_dec_sink__irfull    = '0 ;
  assign btc_dec_sink__irdat     = '0 ;
  assign btc_dec_sink__irtag     = '0 ;
  assign btc_dec_sink__irerr     = '0 ;
  assign btc_dec_sink__irdecfail = '0 ;
  assign btc_dec_sink__ireq      = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_sink.sv
// Description   : BTC decoder sink unit with single bit data output
//

module btc_dec_sink
#(
  parameter int pRDAT_W  =  1 ,
  parameter int pRADDR_W =  8 ,
  //
  parameter int pERR_W   = 16 ,
  //
  parameter int pTAG_W   =  8
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  ixmode    ,
  iymode    ,
  ismode    ,
  //
  irfull    ,
  irdat     ,
  irtag     ,
  //
  irerr     ,
  irdecfail ,
  //
  orempty   ,
  oraddr    ,
  //
  ireq      ,
  ofull     ,
  //
  oval      ,
  osop      ,
  oeop      ,
  odat      ,
  otag      ,
  //
  odecfail  ,
  oerr      ,
  onum
);

  `include "../btc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                             iclk      ;
  input  logic                             ireset    ;
  input  logic                             iclkena   ;
  //
  input  btc_code_mode_t                   ixmode    ;
  input  btc_code_mode_t                   iymode    ;
  input  btc_short_mode_t                  ismode    ;
  //
  input  logic                             irfull    ;
  input  logic             [pRDAT_W-1 : 0] irdat     ;
  input  logic              [pTAG_W-1 : 0] irtag     ;
  //
  input  logic              [pERR_W-1 : 0] irerr     ;
  input  logic                             irdecfail ;
  //
  output logic                             orempty   ;
  output logic            [pRADDR_W-1 : 0] oraddr    ;
  //
  input  logic                             ireq      ;
  output logic                             ofull     ;
  //
  output logic                             oval      ;
  output logic                             osop      ;
  output logic                             oeop      ;
  output logic                             odat      ;
  output logic              [pTAG_W-1 : 0] otag      ;
  //
  output logic                             odecfail  ;
  output logic              [pERR_W-1 : 0] oerr      ;
  output logic              [pERR_W-1 : 0] onum      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  logic [cLOG2_ROW_MAX-1 : 0] col_length_m2;

  struct packed {
    logic                       done;
    logic [cLOG2_ROW_MAX-1 : 0] value;
  } row_idx;

  logic [cLOG2_COL_MAX-1 : 0] row_length_m2;

  struct packed {
    logic                       done;
    logic [cLOG2_COL_MAX-1 : 0] value;
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
        row_idx       <= '0;
        col_idx       <= '0;
        //
        row_length_m2 <= get_data_bits(ixmode) - 2;
        col_length_m2 <= get_data_bits(iymode) - 2;
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

  assign oraddr[0             +: cLOG2_COL_MAX] = col_idx.value;
  assign oraddr[cLOG2_COL_MAX +: cLOG2_ROW_MAX] = row_idx.value;

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
        otag      <= irtag;
        odecfail  <= irdecfail;
        oerr      <= irerr;
        // errors count based upon only row data (!!!)
        onum      <= cDATA_ERR_BIT_SIZE[{iymode, ixmode}];
      end
    end
  end

  assign oeop = eop [2];

endmodule
