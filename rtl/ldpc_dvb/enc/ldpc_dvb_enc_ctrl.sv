/*






  logic       ldpc_dvb_enc_ctrl__iclk           ;
  logic       ldpc_dvb_enc_ctrl__ireset         ;
  logic       ldpc_dvb_enc_ctrl__iclkena        ;
  //
  logic       ldpc_dvb_enc_ctrl__ibuf_full      ;
  logic       ldpc_dvb_enc_ctrl__obuf_empty     ;
  logic       ldpc_dvb_enc_ctrl__iobuf_empty    ;
  //
  col_t       ldpc_dvb_enc_ctrl__iused_col      ;
  col_t       ldpc_dvb_enc_ctrl__iused_data_col ;
  row_t       ldpc_dvb_enc_ctrl__iused_row      ;
  //
  cycle_idx_t ldpc_dvb_enc_ctrl__icycle_max_num ;
  //
  logic       ldpc_dvb_enc_ctrl__ostart         ;
  //
  logic       ldpc_dvb_enc_ctrl__ip_busy        ;
  logic       ldpc_dvb_enc_ctrl__ocycle_read    ;
  cycle_idx_t ldpc_dvb_enc_ctrl__ocycle_idx     ;
  //
  logic       ldpc_dvb_enc_ctrl__ip_read_busy   ;
  logic       ldpc_dvb_enc_ctrl__op_read        ;
  strb_t      ldpc_dvb_enc_ctrl__op_strb        ;
  row_t       ldpc_dvb_enc_ctrl__op_row_idx     ;
  //
  logic       ldpc_dvb_enc_ctrl__obusy          ;



  ldpc_dvb_enc_ctrl
  ldpc_dvb_enc_ctrl
  (
    .iclk           ( ldpc_dvb_enc_ctrl__iclk           ) ,
    .ireset         ( ldpc_dvb_enc_ctrl__ireset         ) ,
    .iclkena        ( ldpc_dvb_enc_ctrl__iclkena        ) ,
    //
    .ibuf_full      ( ldpc_dvb_enc_ctrl__ibuf_full      ) ,
    .obuf_empty     ( ldpc_dvb_enc_ctrl__obuf_empty     ) ,
    .iobuf_empty    ( ldpc_dvb_enc_ctrl__iobuf_empty    ) ,
    //
    .iused_col      ( ldpc_dvb_enc_ctrl__iused_col      ) ,
    .iused_data_col ( ldpc_dvb_enc_ctrl__iused_data_col ) ,
    .iused_row      ( ldpc_dvb_enc_ctrl__iused_row      ) ,
    //
    .icycle_max_num ( ldpc_dvb_enc_ctrl__icycle_max_num ) ,
    //
    .ostart         ( ldpc_dvb_enc_ctrl__ostart         ) ,
    //
    .ip_busy        ( ldpc_dvb_enc_ctrl__ip_busy        ) ,
    .ocycle_read    ( ldpc_dvb_enc_ctrl__ocycle_read    ) ,
    .ocycle_idx     ( ldpc_dvb_enc_ctrl__ocycle_idx     ) ,
    //
    .ip_read_busy   ( ldpc_dvb_enc_ctrl__ip_read_busy   ) ,
    .op_read        ( ldpc_dvb_enc_ctrl__op_read        ) ,
    .op_strb        ( ldpc_dvb_enc_ctrl__op_strb        ) ,
    .op_row_idx     ( ldpc_dvb_enc_ctrl__op_row_idx     ) ,
    //
    .obusy          ( ldpc_dvb_enc_ctrl__obusy          )
  );


  assign ldpc_dvb_enc_ctrl__iclk           = '0 ;
  assign ldpc_dvb_enc_ctrl__ireset         = '0 ;
  assign ldpc_dvb_enc_ctrl__iclkena        = '0 ;
  assign ldpc_dvb_enc_ctrl__ibuf_full      = '0 ;
  assign ldpc_dvb_enc_ctrl__iobuf_empty    = '0 ;
  assign ldpc_dvb_enc_ctrl__iused_col      = '0 ;
  assign ldpc_dvb_enc_ctrl__iused_data_col = '0 ;
  assign ldpc_dvb_enc_ctrl__iused_row      = '0 ;
  assign ldpc_dvb_enc_ctrl__icycle_max_num = '0 ;
  assign ldpc_dvb_enc_ctrl__ip_busy        = '0 ;
  assign ldpc_dvb_enc_ctrl__ip_read_busy   = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_ctrl.sv
// Description   : encoder main controller
//

module ldpc_dvb_enc_ctrl
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  ibuf_full      ,
  obuf_empty     ,
  iobuf_empty    ,
  //
  iused_col      ,
  iused_data_col ,
  iused_row      ,
  //
  icycle_max_num ,
  //
  ostart         ,
  //
  ip_busy        ,
  ocycle_read    ,
  ocycle_idx     ,
  //
  ip_read_busy   ,
  op_read        ,
  op_strb        ,
  op_row_idx     ,
  //
  obusy
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic       iclk           ;
  input  logic       ireset         ;
  input  logic       iclkena        ;
  //
  input  logic       ibuf_full      ;
  output logic       obuf_empty     ;
  input  logic       iobuf_empty    ;
  //
  input  col_t       iused_col      ;
  input  col_t       iused_data_col ;
  input  row_t       iused_row      ;
  //
  input  cycle_idx_t icycle_max_num ;
  //
  output logic       ostart         ;
  // parity logic interface
  input  logic       ip_busy        ;
  output logic       ocycle_read    ;
  output cycle_idx_t ocycle_idx     ;
  // parity ram read interface
  input  logic       ip_read_busy   ;
  output logic       op_read        ;
  output strb_t      op_strb        ;
  output row_t       op_row_idx     ;
  //
  output logic       obusy          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE      ,
    //
    cWAIT_STATE       ,
    cINIT_STATE       ,
    //
    cDATA_STATE       ,
    cWAIT_DATA_STATE  ,
    //
    cDO_P_STATE       ,
    cWAIT_DO_P_STATE  ,
    //
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  struct packed {
    logic       done;
    cycle_idx_t value;
  } cycle_cnt;

  cycle_idx_t used_cycle_m2;

  struct packed {
    logic   done;
    logic   zero;
    row_t   value;
  } row_cnt;

  row_t       used_row_m2;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE      : state <= cWAIT_STATE;
        //
        cWAIT_STATE       : state <= (ibuf_full & iobuf_empty) ? cINIT_STATE      : cWAIT_STATE;
        // decode worked parameters
        cINIT_STATE       : state <= cDATA_STATE;
        // count parity bit and write data 2 output
        cDATA_STATE       : state <= cycle_cnt.done            ? cWAIT_DATA_STATE : cDATA_STATE;
        cWAIT_DATA_STATE  : state <= !ip_busy                  ? cDO_P_STATE      : cWAIT_DATA_STATE;
        // do IRA coding
        cDO_P_STATE       : state <= row_cnt.done              ? cWAIT_DO_P_STATE : cDO_P_STATE;
        cWAIT_DO_P_STATE  : state <= !ip_read_busy             ? cDONE_STATE      : cWAIT_DO_P_STATE;
        //
        cDONE_STATE       : state <= cWAIT_STATE;
      endcase
    end
  end

  assign obusy = (state != cWAIT_STATE);

  // FSM counters
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cINIT_STATE   : begin
          cycle_cnt     <= '0;
          //
          row_cnt       <= '0;
          row_cnt.zero  <= 1'b1;
          //
          used_row_m2   <= iused_row      - 2;
          used_cycle_m2 <= icycle_max_num - 2;
        end
        //
        cDATA_STATE   : begin
          cycle_cnt.value <= cycle_cnt.value + 1'b1;
          cycle_cnt.done  <= (cycle_cnt.value == used_cycle_m2);
        end
        //
        cDO_P_STATE : begin
          row_cnt.value <=  row_cnt.value + 1'b1;
          row_cnt.done  <= (row_cnt.value == used_row_m2);
          row_cnt.zero  <=  row_cnt.done;
        end
        //
        default : begin end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decode
  //------------------------------------------------------------------------------------------------------

  assign ocycle_read  = (state == cDATA_STATE);
  assign ocycle_idx   = cycle_cnt.value;

  assign op_read      = (state == cDO_P_STATE);

  assign op_strb.sof  = row_cnt.zero;
  assign op_strb.sop  = 1'b0;
  assign op_strb.eop  = 1'b0;
  assign op_strb.eof  = row_cnt.done;

  assign op_row_idx   = row_cnt.value;

  //
  //
  //

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obuf_empty <= 1'b0;
    end
    else begin
      obuf_empty <= (state == cDO_P_STATE) & row_cnt.zero;  // can change code contex now, all needed is latched
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostart <= (state == cINIT_STATE); // can delay for 1 tick to get more time for hs_gen read latency
    end
  end

endmodule
