/*



  parameter int pNUM_W = 1 ;



  logic                ldpc_dvb_dec_node_restore_ctrl__iclk       ;
  logic                ldpc_dvb_dec_node_restore_ctrl__ireset     ;
  logic                ldpc_dvb_dec_node_restore_ctrl__iclkena    ;
  //
  logic                ldpc_dvb_dec_node_restore_ctrl__irdy       ;
  logic [pNUM_W-1 : 0] ldpc_dvb_dec_node_restore_ctrl__inum_m1    ;
  logic                ldpc_dvb_dec_node_restore_ctrl__oread      ;
  logic                ldpc_dvb_dec_node_restore_ctrl__orslt_read ;
  logic [pNUM_W-1 : 0] ldpc_dvb_dec_node_restore_ctrl__oread_idx  ;



  ldpc_dvb_dec_node_restore_ctrl
  #(
    .pNUM_W ( pNUM_W )
  )
  ldpc_dvb_dec_node_restore_ctrl
  (
    .iclk       ( ldpc_dvb_dec_node_restore_ctrl__iclk       ) ,
    .ireset     ( ldpc_dvb_dec_node_restore_ctrl__ireset     ) ,
    .iclkena    ( ldpc_dvb_dec_node_restore_ctrl__iclkena    ) ,
    //
    .irdy       ( ldpc_dvb_dec_node_restore_ctrl__irdy       ) ,
    .inum_m1    ( ldpc_dvb_dec_node_restore_ctrl__inum_m1    ) ,
    .oread      ( ldpc_dvb_dec_node_restore_ctrl__oread      ) ,
    .orslt_read ( ldpc_dvb_dec_node_restore_ctrl__orslt_read ) ,
    .oread_idx  ( ldpc_dvb_dec_node_restore_ctrl__oread_idx  )
  );


  assign ldpc_dvb_dec_node_restore_ctrl__iclk    = '0 ;
  assign ldpc_dvb_dec_node_restore_ctrl__ireset  = '0 ;
  assign ldpc_dvb_dec_node_restore_ctrl__iclkena = '0 ;
  assign ldpc_dvb_dec_node_restore_ctrl__irdy    = '0 ;
  assign ldpc_dvb_dec_node_restore_ctrl__inum_m1 = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_node_restore_ctrl.sv
// Description   : decoder node restore controller after all sequential operations
//

module ldpc_dvb_dec_node_restore_ctrl
#(
  parameter int pNUM_W = 1
)
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  irdy       ,
  inum_m1    ,
  oread      ,
  orslt_read ,
  oread_idx
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk       ;
  input  logic                ireset     ;
  input  logic                iclkena    ;
  //
  input  logic                irdy       ;
  input  logic [pNUM_W-1 : 0] inum_m1    ;
  output logic                oread      ;
  output logic                orslt_read ;
  output logic [pNUM_W-1 : 0] oread_idx  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic                done;
    logic [pNUM_W-1 : 0] value;
  } cnt;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire work_done = cnt.done & !irdy;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <= irdy      ? cDO_STATE    : cRESET_STATE;
        cDO_STATE    : state <= work_done ? cRESET_STATE : cDO_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  wire load_cnt = ((state == cRESET_STATE) & irdy) | ((state == cDO_STATE) & cnt.done & irdy);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (load_cnt) begin
        cnt.value <=  inum_m1;
        cnt.done  <= (inum_m1 == 0);
        oread_idx <= '0;
      end
      else if (state == cDO_STATE) begin
        cnt.value <=  cnt.value - 1'b1;
        cnt.done  <= (cnt.value == 1);
        //
        oread_idx <=  oread_idx + 1'b1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FIFO signals
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      orslt_read <= 1'b0;
    end
    else if (iclkena) begin
      orslt_read <= load_cnt;
    end
  end

  assign oread = (state == cDO_STATE);

endmodule
