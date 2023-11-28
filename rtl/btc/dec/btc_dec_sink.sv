/*



  parameter int pRDAT_W  =  8 ;
  parameter int pRADDR_W =  8 ;
  //
  parameter int pERR_W   = 16 ;
  //
  parameter int pTAG_W   =  8 ;
  //
  parameter int pDB_NUM  =  1 ;



  logic                             btc_dec_sink__iclk                ;
  logic                             btc_dec_sink__ireset              ;
  logic                             btc_dec_sink__iclkena             ;
  //
  btc_code_mode_t                   btc_dec_sink__ixmode    [pDB_NUM] ;
  btc_code_mode_t                   btc_dec_sink__iymode    [pDB_NUM] ;
  btc_short_mode_t                  btc_dec_sink__ismode    [pDB_NUM] ;
  //
  logic                             btc_dec_sink__irfull    [pDB_NUM] ;
  logic             [pRDAT_W-1 : 0] btc_dec_sink__irdat     [pDB_NUM] ;
  logic              [pTAG_W-1 : 0] btc_dec_sink__irtag     [pDB_NUM] ;
  //
  logic              [pERR_W-1 : 0] btc_dec_sink__irerr     [pDB_NUM] ;
  logic              [pERR_W-1 : 0] btc_dec_sink__irerr_num [pDB_NUM] ;
  logic                             btc_dec_sink__irdecfail [pDB_NUM] ;
  //
  logic                             btc_dec_sink__orempty   [pDB_NUM] ;
  logic            [pRADDR_W-1 : 0] btc_dec_sink__oraddr              ;
  //
  logic                             btc_dec_sink__ireq                ;
  logic                             btc_dec_sink__ofull               ;
  //
  logic                             btc_dec_sink__oval                ;
  logic                             btc_dec_sink__osop                ;
  logic                             btc_dec_sink__oeop                ;
  logic                             btc_dec_sink__odat                ;
  logic              [pTAG_W-1 : 0] btc_dec_sink__otag                ;
  //
  logic                             btc_dec_sink__odecfail            ;
  logic              [pERR_W-1 : 0] btc_dec_sink__oerr                ;
  logic              [pERR_W-1 : 0] btc_dec_sink__onum                ;



  btc_dec_sink
  #(
    .pRDAT_W  ( pRDAT_W  ) ,
    .pRADDR_W ( pRADDR_W ) ,
    //
    .pERR_W   ( pERR_W   ) ,
    //
    .pTAG_W   ( pTAG_W   ) ,
    //
    .pDB_NUM  ( pDB_NUM  )
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
    .irerr_num ( btc_dec_sink__irerr_num ) ,
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
  parameter int pRDAT_W           =  1 ,
  parameter int pRADDR_W          =  8 ,
  //
  parameter int pERR_W            = 16 ,
  //
  parameter int pTAG_W            =  8 ,
  //
  parameter int pDB_NUM           =  1    // decoder block number
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
  irerr_num ,
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

  input  logic                             iclk                ;
  input  logic                             ireset              ;
  input  logic                             iclkena             ;
  //
  input  btc_code_mode_t                   ixmode    [pDB_NUM] ;
  input  btc_code_mode_t                   iymode    [pDB_NUM] ;
  input  btc_short_mode_t                  ismode    [pDB_NUM] ;
  //
  input  logic                             irfull    [pDB_NUM] ;
  input  logic             [pRDAT_W-1 : 0] irdat     [pDB_NUM] ;
  input  logic              [pTAG_W-1 : 0] irtag     [pDB_NUM] ;
  //
  input  logic              [pERR_W-1 : 0] irerr     [pDB_NUM] ;
  input  logic              [pERR_W-1 : 0] irerr_num [pDB_NUM] ;
  input  logic                             irdecfail [pDB_NUM] ;
  //
  output logic                             orempty   [pDB_NUM] ;
  output logic            [pRADDR_W-1 : 0] oraddr              ;
  //
  input  logic                             ireq                ;
  output logic                             ofull               ;
  //
  output logic                             oval                ;
  output logic                             osop                ;
  output logic                             oeop                ;
  output logic                             odat                ;
  output logic              [pTAG_W-1 : 0] otag                ;
  //
  output logic                             odecfail            ;
  output logic              [pERR_W-1 : 0] oerr                ;
  output logic              [pERR_W-1 : 0] onum                ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DB_NUM = $clog2(pDB_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [1 : 0] {
    cRESET_STATE,
    cINIT_STATE ,
    cDO_STATE   ,
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  btc_code_mode_t  xmode;
  btc_code_mode_t  ymode;

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

  logic [cLOG2_DB_NUM-1 : 0] sel;
  logic [cLOG2_DB_NUM-1 : 0] sel2dat;

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
        cRESET_STATE : state <=  irfull[sel]       ? cINIT_STATE  : cRESET_STATE;
        //
        cINIT_STATE  : state <= cDO_STATE;
        //
        cDO_STATE    : state <= (ireq & work_done) ? cDONE_STATE  : cDO_STATE;
        //
        cDONE_STATE  : state <= cRESET_STATE;
      endcase
    end
  end

  always_comb begin
    for (int i = 0; i < pDB_NUM; i++) begin
      orempty[i] = (state == cDONE_STATE) & (i == sel);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decoder block select arbiter
  //------------------------------------------------------------------------------------------------------

  generate
    if (pDB_NUM <= 1) begin
      assign sel = 1'b0;
    end
    else begin
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          sel <= '0;
        end
        else if (iclkena) begin
          if (state == cDONE_STATE) begin
            if (pDB_NUM == 2**cLOG2_DB_NUM) begin
              sel <= sel + 1'b1;
            end
            else begin
              sel <= (sel == pDB_NUM-1) ? '0 : (sel + 1'b1);
            end
          end
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // used mode selection
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        xmode <= ixmode[sel];
        ymode <= iymode[sel];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cINIT_STATE) begin
        row_idx       <= '0;
        col_idx       <= '0;
        //
        row_length_m2 <= get_data_bits(xmode) - 2;
        col_length_m2 <= get_data_bits(ymode) - 2;
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

  assign oraddr[0             +: cLOG2_ROW_MAX] = col_idx.value;
  assign oraddr[cLOG2_ROW_MAX +: cLOG2_COL_MAX] = row_idx.value;

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  wire start = (state == cINIT_STATE);

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
      else if (state == cDONE_STATE) begin
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
      odat <= irdat[sel2dat];
      //
      if (start) begin
        otag      <= irtag    [sel];
        odecfail  <= irdecfail[sel];
        oerr      <= irerr    [sel];
        onum      <= irerr_num[sel];
      end
      //
      if (state == cDO_STATE) begin
        sel2dat   <= sel;
      end
    end
  end

  assign oeop = eop [2];

endmodule
