/*



  parameter bit pUSE_L_POLY = 0 ;
  parameter int pADDR_W     = 6 ;



  logic                 b_bch_dec_ctrl__iclk        ;
  logic                 b_bch_dec_ctrl__ireset      ;
  logic                 b_bch_dec_ctrl__iclkena     ;
  //
  logic                 b_bch_dec_ctrl__isop        ;
  logic                 b_bch_dec_ctrl__ival        ;
  logic                 b_bch_dec_ctrl__ieop        ;
  logic                 b_bch_dec_ctrl__ordy        ;
  //
  logic                 b_bch_dec_ctrl__irdy        ;
  //
  logic                 b_bch_dec_ctrl__osop        ;
  logic                 b_bch_dec_ctrl__osof        ;
  logic                 b_bch_dec_ctrl__oval        ;
  logic                 b_bch_dec_ctrl__oeop        ;
  logic                 b_bch_dec_ctrl__oeof        ;
  //
  logic [pADDR_W-1 : 0] b_bch_dec_ctrl__oraddr      ;
  logic  [cDAT_W-1 : 0] b_bch_dec_ctrl__ocand_idx   ;
  //
  logic                 b_bch_dec_ctrl__orslt_phase ;



  b_bch_dec_ctrl
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pADDR_W     ( pADDR_W     )
  )
  b_bch_dec_ctrl
  (
    .iclk        ( b_bch_dec_ctrl__iclk        ) ,
    .ireset      ( b_bch_dec_ctrl__ireset      ) ,
    .iclkena     ( b_bch_dec_ctrl__iclkena     ) ,
    //
    .isop        ( b_bch_dec_ctrl__isop        ) ,
    .ival        ( b_bch_dec_ctrl__ival        ) ,
    .ieop        ( b_bch_dec_ctrl__ieop        ) ,
    .ordy        ( b_bch_dec_ctrl__ordy        ) ,
    //
    .irdy        ( b_bch_dec_ctrl__irdy        ) ,
    //
    .osop        ( b_bch_dec_ctrl__osop        ) ,
    .osof        ( b_bch_dec_ctrl__osof        ) ,
    .oval        ( b_bch_dec_ctrl__oval        ) ,
    .oeop        ( b_bch_dec_ctrl__oeop        ) ,
    .oeof        ( b_bch_dec_ctrl__oeof        ) ,
    //
    .oraddr      ( b_bch_dec_ctrl__oraddr      ) ,
    .ocand_idx   ( b_bch_dec_ctrl__ocand_idx   ) ,
    //
    .orslt_phase ( b_bch_dec_ctrl__orslt_phase )
  );


  assign b_bch_dec_ctrl__iclk    = '0 ;
  assign b_bch_dec_ctrl__ireset  = '0 ;
  assign b_bch_dec_ctrl__iclkena = '0 ;
  assign b_bch_dec_ctrl__isop    = '0 ;
  assign b_bch_dec_ctrl__ival    = '0 ;
  assign b_bch_dec_ctrl__ieop    = '0 ;
  assign b_bch_dec_ctrl__irdy    = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_dec_ctrl.svh
// Description   : decoder controler: sequential search of codeword ML decision
//

module b_bch_dec_ctrl
#(
  parameter bit pUSE_L_POLY = 0 ,
  parameter int pADDR_W     = 6
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  isop        ,
  ival        ,
  ieop        ,
  ordy        ,
  //
  irdy        ,
  //
  osop        ,
  osof        ,
  oval        ,
  oeop        ,
  oeof        ,
  //
  oraddr      ,
  ocand_idx   ,
  //
  orslt_phase
);

  `include "b_bch_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = cDBIT_NUM[pUSE_L_POLY] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk        ;
  input  logic                 ireset      ;
  input  logic                 iclkena     ;
  //
  input  logic                 isop        ;
  input  logic                 ival        ;
  input  logic                 ieop        ;
  output logic                 ordy        ;
  //
  input  logic                 irdy        ;
  //
  output logic                 osop        ;
  output logic                 osof        ;
  output logic                 oval        ;
  output logic                 oeop        ;
  output logic                 oeof        ;
  //
  output logic [pADDR_W-1 : 0] oraddr      ;
  output logic  [cDAT_W-1 : 0] ocand_idx   ;
  //
  output logic                 orslt_phase ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBIT_MAX     = cBIT_NUM[pUSE_L_POLY];
  localparam int cBIT_CNT_W   = $clog2(cBIT_MAX);

  localparam int cCAND_MAX    = 2**cDAT_W;
  localparam int cCAND_CNT_W  = $clog2(cCAND_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE       ,
    //
    cWAIT_STATE        ,
    //
    cDATA_STATE        ,
    cWAIT_DATA_STATE   ,
    //
    cWAIT_O_STATE      ,
    //
    cRSLT_STATE        ,
    cWAIT_RSLT_STATE   ,
    //
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  struct packed {
    logic                    zero;
    logic                    done;
    logic [cBIT_CNT_W-1 : 0] value;
  } bit_cnt;

  struct packed {
    logic                     zero;
    logic                     done;
    logic [cCAND_CNT_W-1 : 0] value;
  } cand_cnt;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire cycle_done = cand_cnt.done & bit_cnt.done;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE     : state <= cWAIT_STATE;
        //
        cWAIT_STATE      : state <= (ival & ieop) ? cDATA_STATE       : cWAIT_STATE;
        //
        cDATA_STATE      : state <= cycle_done    ? cWAIT_DATA_STATE  : cDATA_STATE;
        cWAIT_DATA_STATE : state <= cWAIT_O_STATE;
        //
        cWAIT_O_STATE    : state <= irdy          ? cRSLT_STATE       : cWAIT_O_STATE;
        //
        cRSLT_STATE      : state <= bit_cnt.done  ? cWAIT_RSLT_STATE  : cRSLT_STATE;
        cWAIT_RSLT_STATE : state <= cDONE_STATE;
        //
        cDONE_STATE      : state <= cWAIT_STATE;
      endcase
    end
  end

  assign ordy = (state == cWAIT_STATE);

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cDATA_STATE : begin
          bit_cnt.value <=  bit_cnt.done ? '0 : (bit_cnt.value + 1'b1);
          bit_cnt.done  <= (bit_cnt.value == (cBIT_MAX-2));
          bit_cnt.zero  <= bit_cnt.done;
          //
          if (bit_cnt.done) begin
            cand_cnt.value <=  cand_cnt.done ? '0 : (cand_cnt.value + 1'b1);
            cand_cnt.done  <= (cand_cnt.value == (cCAND_MAX-2));
            cand_cnt.zero  <= cand_cnt.done;
          end
        end
        cRSLT_STATE : begin
          bit_cnt.value <=  bit_cnt.done ? '0 : (bit_cnt.value + 1'b1);
          bit_cnt.done  <= (bit_cnt.value == (cBIT_MAX-2));
          bit_cnt.zero  <= bit_cnt.done;
        end
        //
        default : begin
          bit_cnt       <= '0;
          bit_cnt.zero  <= 1'b1;
          //
          cand_cnt      <= '0;
          cand_cnt.zero <= 1'b1;
        end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM decode
  //------------------------------------------------------------------------------------------------------

  assign osop        = bit_cnt.zero;
  assign osof        = cand_cnt.zero;
  assign oval        = (state == cDATA_STATE) | (state == cRSLT_STATE);
  assign oeop        = bit_cnt.done;
  assign oeof        = cand_cnt.done;
  //
  assign oraddr      = bit_cnt.value;
  assign ocand_idx   = cand_cnt.value;
  //
  assign orslt_phase = (state == cRSLT_STATE);

endmodule
