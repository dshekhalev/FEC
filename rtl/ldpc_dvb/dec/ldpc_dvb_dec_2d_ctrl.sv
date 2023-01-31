/*






  logic               ldpc_dvb_dec_2d_ctrl__iclk           ;
  logic               ldpc_dvb_dec_2d_ctrl__ireset         ;
  logic               ldpc_dvb_dec_2d_ctrl__iclkena        ;
  //
  logic       [7 : 0] ldpc_dvb_dec_2d_ctrl__iNiter         ;
  logic               ldpc_dvb_dec_2d_ctrl__ifmode         ;
  //
  logic               ldpc_dvb_dec_2d_ctrl__ibuf_full      ;
  logic               ldpc_dvb_dec_2d_ctrl__obuf_empty     ;
  logic               ldpc_dvb_dec_2d_ctrl__iobuf_empty    ;
  //
  col_t               ldpc_dvb_dec_2d_ctrl__iused_col      ;
  col_t               ldpc_dvb_dec_2d_ctrl__iused_data_col ;
  row_t               ldpc_dvb_dec_2d_ctrl__iused_row      ;
  cycle_idx_t         ldpc_dvb_dec_2d_ctrl__icycle_max_num ;
  //
  logic               ldpc_dvb_dec_2d_ctrl__ivnode_busy    ;
  //
  logic               ldpc_dvb_dec_2d_ctrl__icnode_busy    ;
  logic               ldpc_dvb_dec_2d_ctrl__icnode_decfail ;
  //
  logic               ldpc_dvb_dec_2d_ctrl__oload_mode     ;
  logic               ldpc_dvb_dec_2d_ctrl__oc_nv_mode     ;
  logic               ldpc_dvb_dec_2d_ctrl__ocycle_start   ;
  logic               ldpc_dvb_dec_2d_ctrl__ocycle_read    ;
  strb_t              ldpc_dvb_dec_2d_ctrl__ocycle_strb    ;
  cycle_idx_t         ldpc_dvb_dec_2d_ctrl__ocycle_idx     ;
  //
  logic               ldpc_dvb_dec_2d_ctrl__olast_iter     ;



  ldpc_dvb_dec_2d_ctrl
  ldpc_dvb_dec_2d_ctrl
  (
    .iclk           ( ldpc_dvb_dec_2d_ctrl__iclk           ) ,
    .ireset         ( ldpc_dvb_dec_2d_ctrl__ireset         ) ,
    .iclkena        ( ldpc_dvb_dec_2d_ctrl__iclkena        ) ,
    //
    .iNiter         ( ldpc_dvb_dec_2d_ctrl__iNiter         ) ,
    .ifmode         ( ldpc_dvb_dec_2d_ctrl__ifmode         ) ,
    //
    .ibuf_full      ( ldpc_dvb_dec_2d_ctrl__ibuf_full      ) ,
    .obuf_empty     ( ldpc_dvb_dec_2d_ctrl__obuf_empty     ) ,
    .iobuf_empty    ( ldpc_dvb_dec_2d_ctrl__iobuf_empty    ) ,
    //
    .iused_col      ( ldpc_dvb_dec_2d_ctrl__iused_col      ) ,
    .iused_data_col ( ldpc_dvb_dec_2d_ctrl__iused_data_col ) ,
    .iused_row      ( ldpc_dvb_dec_2d_ctrl__iused_row      ) ,
    .icycle_max_num ( ldpc_dvb_dec_2d_ctrl__icycle_max_num ) ,
    //
    .ivnode_busy    ( ldpc_dvb_dec_2d_ctrl__ivnode_busy    ) ,
    //
    .icnode_busy    ( ldpc_dvb_dec_2d_ctrl__icnode_busy    ) ,
    .icnode_decfail ( ldpc_dvb_dec_2d_ctrl__icnode_decfail ) ,
    //
    .oload_mode     ( ldpc_dvb_dec_2d_ctrl__oload_mode     ) ,
    .oc_nv_mode     ( ldpc_dvb_dec_2d_ctrl__oc_nv_mode     ) ,
    .ocycle_start   ( ldpc_dvb_dec_2d_ctrl__ocycle_start   ) ,
    .ocycle_read    ( ldpc_dvb_dec_2d_ctrl__ocycle_read    ) ,
    .ocycle_strb    ( ldpc_dvb_dec_2d_ctrl__ocycle_strb    ) ,
    .ocycle_idx     ( ldpc_dvb_dec_2d_ctrl__ocycle_idx     ) ,
    //
    .olast_iter     ( ldpc_dvb_dec_2d_ctrl__olast_iter     )
  );


  assign ldpc_dvb_dec_2d_ctrl__iclk           = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__ireset         = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__iclkena        = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__iNiter         = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__ifmode         = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__ibuf_full      = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__iobuf_empty    = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__iused_col      = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__iused_data_col = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__iused_row      = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__icycle_max_num = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__ivnode_busy    = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__icnode_busy    = '0 ;
  assign ldpc_dvb_dec_2d_ctrl__icnode_decfail = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_2d_engine.sv
// Description   : 2D min-sum main controller
//

module ldpc_dvb_dec_2d_ctrl
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  iNiter         ,
  ifmode         ,
  //
  ibuf_full      ,
  obuf_empty     ,
  iobuf_empty    ,
  //
  iused_col      ,
  iused_data_col ,
  iused_row      ,
  icycle_max_num ,
  //
  ivnode_busy    ,
  //
  icnode_busy    ,
  icnode_decfail ,
  //
  oload_mode     ,
  oc_nv_mode     ,
  ocycle_start   ,
  ocycle_read    ,
  ocycle_strb    ,
  ocycle_idx     ,
  //
  olast_iter
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic               iclk           ;
  input  logic               ireset         ;
  input  logic               iclkena        ;
  //
  input  logic       [7 : 0] iNiter         ;
  input  logic               ifmode         ;
  //
  input  logic               ibuf_full      ;
  output logic               obuf_empty     ;
  input  logic               iobuf_empty    ;
  //
  input  col_t               iused_col      ;
  input  col_t               iused_data_col ;
  input  row_t               iused_row      ;
  input  cycle_idx_t         icycle_max_num ;
  //
  input  logic               ivnode_busy    ;
  //
  input  logic               icnode_busy    ;
  input  logic               icnode_decfail ;
  //
  output logic               oload_mode     ;
  output logic               oc_nv_mode     ;
  output logic               ocycle_start   ;
  output logic               ocycle_read    ;
  output strb_t              ocycle_strb    ;
  output cycle_idx_t         ocycle_idx     ;
  //
  output logic               olast_iter     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE,
    cWAIT_STATE ,
    //
    cVSTEP_STATE,
    cWAIT_VDONE_STATE,
    //
    cHSTEP_STATE,
    cWAIT_HDONE_STATE,
    //
    cDONE_STATE,
    //
    cWAIT_O_STATE
  } next_state, state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  struct packed {
    logic       zero;
    logic       done;
    cycle_idx_t value;
  } cycle_cnt;

  cycle_idx_t used_cycle_m2;

  struct packed {
    logic [7 : 0] cnt;
    logic         last;
  } iter;

  logic     fast_stop;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      state <= next_state;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cWAIT_STATE) begin
        fast_stop <= 1'b0;
      end
      else if (state == cWAIT_HDONE_STATE & !icnode_busy) begin
        fast_stop <= ifmode & !icnode_decfail;
      end
    end
  end

  wire do_bypass    = (iNiter == 0);
  wire outbuf_nrdy  = iter.last & !iobuf_empty;
  wire do_last      = iter.last | fast_stop;

  always_comb begin
    case (state)
      cRESET_STATE      : next_state = cWAIT_STATE;
      //
      cWAIT_STATE       : next_state = ibuf_full      ? (do_bypass ? cWAIT_O_STATE : cHSTEP_STATE)    : cWAIT_STATE;
      //
      cHSTEP_STATE      : next_state = cycle_cnt.done ? cWAIT_HDONE_STATE                             : cHSTEP_STATE;
      cWAIT_HDONE_STATE : next_state = !icnode_busy   ? (outbuf_nrdy ? cWAIT_O_STATE : cVSTEP_STATE)  : cWAIT_HDONE_STATE;
      //
      cVSTEP_STATE      : next_state = cycle_cnt.done ? cWAIT_VDONE_STATE                             : cVSTEP_STATE;
      cWAIT_VDONE_STATE : next_state = !ivnode_busy   ? (do_last ? cDONE_STATE : cHSTEP_STATE)        : cWAIT_VDONE_STATE;
      //
      cWAIT_O_STATE     : next_state = !outbuf_nrdy   ? cVSTEP_STATE : cWAIT_O_STATE;
      //
      cDONE_STATE       : next_state = cWAIT_STATE;
      //
      default           : next_state = cRESET_STATE;
    endcase
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cWAIT_STATE : begin
          iter.cnt       <= iNiter;
          iter.last      <= (iNiter <= 1); // hstep include initialization
          //
          cycle_cnt      <= '0;
          cycle_cnt.zero <= 1'b1;
          //
          used_cycle_m2  <= icycle_max_num - 2;
        end
        //
        cHSTEP_STATE      : begin
          cycle_cnt.value <=  cycle_cnt.done ? '0 : (cycle_cnt.value + 1'b1);
          cycle_cnt.done  <= (cycle_cnt.value == used_cycle_m2);
          cycle_cnt.zero  <=  cycle_cnt.done;
        end
        //
        cVSTEP_STATE      : begin
          cycle_cnt.value <=  cycle_cnt.done ? '0 : (cycle_cnt.value + 1'b1);
          cycle_cnt.done  <= (cycle_cnt.value == used_cycle_m2);
          cycle_cnt.zero  <=  cycle_cnt.done;
        end
        //
        cWAIT_VDONE_STATE : begin
          if (!ivnode_busy) begin
            iter.cnt  <= iter.cnt - 1'b1;
            iter.last <= (iter.cnt == 1);
          end
        end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output decoding
  //------------------------------------------------------------------------------------------------------

  //
  // have more then 2 tick address reading for modes
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // hstep - load
      // vstep - bypass if iNiter == 0
      if (state == cWAIT_STATE) begin
        oload_mode  <= 1'b1;
      end
      else if (state == cWAIT_HDONE_STATE & !icnode_busy) begin
        oload_mode  <= 1'b0;
      end
      //
      oc_nv_mode  <= (state == cHSTEP_STATE) | (state == cWAIT_HDONE_STATE);
      //
      olast_iter  <= ((state == cVSTEP_STATE) | (state == cWAIT_VDONE_STATE)) & do_last;
    end
  end

  assign obuf_empty      = (state == cDONE_STATE);

  assign ocycle_start    = ((state == cVSTEP_STATE) | (state == cHSTEP_STATE)) & cycle_cnt.zero;
  assign ocycle_read     =  (state == cVSTEP_STATE) | (state == cHSTEP_STATE);

  assign ocycle_strb.sof = cycle_cnt.zero;
  assign ocycle_strb.sop = '0;
  assign ocycle_strb.eop = '0;
  assign ocycle_strb.eof = cycle_cnt.done;

  assign ocycle_idx      = cycle_cnt.value;

endmodule
