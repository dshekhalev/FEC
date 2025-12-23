/*



  parameter int pRADDR_W = 1 ;
  parameter int pRDAT_W  = 2 ;
  //
  parameter int pDAT_W   = 2 ;
  parameter int pTAG_W   = 4 ;



  logic                  ldpc_dvb_enc_sink__iclk    ;
  logic                  ldpc_dvb_enc_sink__ireset  ;
  logic                  ldpc_dvb_enc_sink__iclkena ;
  //
  col_t                  ldpc_dvb_enc_sink__irsize  ;
  logic                  ldpc_dvb_enc_sink__irfull  ;
  logic  [pRDAT_W-1 : 0] ldpc_dvb_enc_sink__irdat   ;
  logic   [pTAG_W-1 : 0] ldpc_dvb_enc_sink__irtag   ;
  logic                  ldpc_dvb_enc_sink__orempty ;
  logic [pRADDR_W-1 : 0] ldpc_dvb_enc_sink__oraddr  ;
  //
  logic                  ldpc_dvb_enc_sink__ireq    ;
  logic                  ldpc_dvb_enc_sink__ofull   ;
  //
  logic                  ldpc_dvb_enc_sink__osop    ;
  logic                  ldpc_dvb_enc_sink__oeop    ;
  logic                  ldpc_dvb_enc_sink__oval    ;
  logic   [pDAT_W-1 : 0] ldpc_dvb_enc_sink__odat    ;
  logic   [pTAG_W-1 : 0] ldpc_dvb_enc_sink__otag    ;



  ldpc_dvb_enc_sink
  #(
    .pRADDR_W ( pRADDR_W ) ,
    .pRDAT_W  ( pRDAT_W  ) ,
    //
    .pDAT_W   ( pDAT_W   ) ,
    .pTAG_W   ( pTAG_W   )
  )
  ldpc_dvb_enc_sink
  (
    .iclk      ( ldpc_dvb_enc_sink__iclk      ) ,
    .ireset    ( ldpc_dvb_enc_sink__ireset    ) ,
    .iclkena   ( ldpc_dvb_enc_sink__iclkena   ) ,
    //
    .irsize    ( ldpc_dvb_enc_sink__irsize    ) ,
    .irfull    ( ldpc_dvb_enc_sink__irfull    ) ,
    .irdat     ( ldpc_dvb_enc_sink__irdat     ) ,
    .irtag     ( ldpc_dvb_enc_sink__irtag     ) ,
    .orempty   ( ldpc_dvb_enc_sink__orempty   ) ,
    .oraddr    ( ldpc_dvb_enc_sink__oraddr    ) ,
    //
    .ireq      ( ldpc_dvb_enc_sink__ireq      ) ,
    .ofull     ( ldpc_dvb_enc_sink__ofull     ) ,
    //
    .osop      ( ldpc_dvb_enc_sink__osop      ) ,
    .oeop      ( ldpc_dvb_enc_sink__oeop      ) ,
    .oval      ( ldpc_dvb_enc_sink__oval      ) ,
    .odat      ( ldpc_dvb_enc_sink__odat      ) ,
    .otag      ( ldpc_dvb_enc_sink__otag      )
  );


  assign ldpc_dvb_enc_sink__iclk    = '0 ;
  assign ldpc_dvb_enc_sink__ireset  = '0 ;
  assign ldpc_dvb_enc_sink__iclkena = '0 ;
  //
  assign ldpc_dvb_enc_sink__irsize  = '0 ;
  assign ldpc_dvb_enc_sink__irfull  = '0 ;
  assign ldpc_dvb_enc_sink__irdat   = '0 ;
  assign ldpc_dvb_enc_sink__irtag   = '0 ;
  assign ldpc_dvb_enc_sink__ireq    = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_sink.sv
// Description   : output encoder interface module with DWC
//

module ldpc_dvb_enc_sink
#(
  parameter int pRADDR_W = 8 ,
  parameter int pRDAT_W  = 8 ,
  //
  parameter int pDAT_W   = 8 ,
  parameter int pTAG_W   = 8
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

  `include "../ldpc_dvb_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk      ;
  input  logic                  ireset    ;
  input  logic                  iclkena   ;
  //
  input  col_t                  irsize    ;
  //
  input  logic                  irfull    ;
  input  logic  [pRDAT_W-1 : 0] irdat     ;
  input  logic   [pTAG_W-1 : 0] irtag     ;
  output logic                  orempty   ;
  output logic [pRADDR_W-1 : 0] oraddr    ;
  //
  input  logic                  ireq      ;
  output logic                  ofull     ;
  //
  output logic                  osop      ;
  output logic                  oeop      ;
  output logic                  oval      ;
  output logic   [pDAT_W-1 : 0] odat      ;
  output logic   [pTAG_W-1 : 0] otag      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDWC_FACTOR = pRDAT_W/pDAT_W;
  localparam int cDWC_CNT_W  = $clog2(cDWC_FACTOR);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic                    done;
    logic                    zero;
    logic [cDWC_CNT_W-1 : 0] value;
  } dwc_cnt;

  struct packed {
    logic done;
    col_t value;
  } col_cnt;

  logic         [2 : 0] val;
  logic         [2 : 0] eop;

  logic         [1 : 0] rval;
  logic [pRDAT_W-1 : 0] rdat;

  logic         [1 : 0] set_sf; // set sop/full

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire work_done = dwc_cnt.done & col_cnt.done;

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

  assign orempty = (state == cDO_STATE) & ireq & work_done;

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  generate
    if (cDWC_FACTOR == 1) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (state == cRESET_STATE) begin
            col_cnt <= '0;
          end
          else if ((state == cDO_STATE) & ireq) begin
            col_cnt.value <=  col_cnt.done ? '0 : (col_cnt.value + 1'b1);
            col_cnt.done  <= (col_cnt.value == (irsize - 2));
          end
        end
      end
      assign dwc_cnt.done = 1'b1;
      assign dwc_cnt.zero  = 1'b1;
    end
    else begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (state == cRESET_STATE) begin
            dwc_cnt       <= '0;
            dwc_cnt.done  <= (cDWC_FACTOR < 2);
            dwc_cnt.zero  <= 1'b1;
            //
            col_cnt       <= '0;
          end
          else if ((state == cDO_STATE) & ireq) begin
            dwc_cnt.value <=  dwc_cnt.done ? '0 : (dwc_cnt.value + 1'b1);
            dwc_cnt.done  <= (dwc_cnt.value == cDWC_FACTOR-2);
            dwc_cnt.zero  <= dwc_cnt.done;
            //
            if (dwc_cnt.done) begin
              col_cnt.value <=  col_cnt.done ? '0 : (col_cnt.value + 1'b1);
              col_cnt.done  <= (col_cnt.value == (irsize - 2));
            end
          end
        end
      end
    end
  endgenerate

  assign oraddr = col_cnt.value;

  //------------------------------------------------------------------------------------------------------
  // output logic
  //------------------------------------------------------------------------------------------------------

  wire start = (state == cRESET_STATE) & irfull;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val     <= '0;
      rval    <= '0;
      set_sf  <= '0;
      //
      ofull   <= 1'b0;
      osop    <= 1'b0;
    end
    else if (iclkena) begin
      val     <= (val  << 1) | ((state == cDO_STATE) & ireq);
      rval    <= (rval << 1) | ((state == cDO_STATE) & ireq & dwc_cnt.zero);
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
      eop  <= (eop << 1) | ((state == cDO_STATE) & ireq & work_done);
      //
      if (val[1]) begin
        rdat <= rval[1] ? irdat : (rdat >> pDAT_W);
      end
      //
      if (start) begin
        otag <= irtag;
      end
    end
  end

  assign odat = rdat[pDAT_W-1 : 0]; // lsb first
  assign oeop = eop [2];

endmodule
