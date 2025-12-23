/*



  parameter int pLLR_BY_CYCLE =  1 ;
  parameter int pROW_BY_CYCLE =  8 ;



  logic            ldpc_3gpp_dec_ctrl__iclk           ;
  logic            ldpc_3gpp_dec_ctrl__ireset         ;
  logic            ldpc_3gpp_dec_ctrl__iclkena        ;
  //
  logic    [7 : 0] ldpc_3gpp_dec_ctrl__iNiter         ;
  logic            ldpc_3gpp_dec_ctrl__ifmode         ;
  //
  logic            ldpc_3gpp_dec_ctrl__ibuf_empty     ;
  logic            ldpc_3gpp_dec_ctrl__iobuf_full     ;
  logic            ldpc_3gpp_dec_ctrl__obuf_rempty    ;
  //
  hb_zc_t          ldpc_3gpp_dec_ctrl__iused_zc       ;
  hb_row_t         ldpc_3gpp_dec_ctrl__iused_row      ;
  //
  logic            ldpc_3gpp_dec_ctrl__ivnode_busy    ;
  //
  logic            ldpc_3gpp_dec_ctrl__icnode_busy    ;
  logic            ldpc_3gpp_dec_ctrl__icnode_decfail ;
  //
  logic            ldpc_3gpp_dec_ctrl__oload_mode     ;
  logic            ldpc_3gpp_dec_ctrl__oc_nv_mode     ;
  logic            ldpc_3gpp_dec_ctrl__obypass        ;
  //
  logic            ldpc_3gpp_dec_ctrl__oread          ;
  logic            ldpc_3gpp_dec_ctrl__orstart        ;
  logic            ldpc_3gpp_dec_ctrl__orval          ;
  strb_t           ldpc_3gpp_dec_ctrl__orstrb         ;
  hb_row_t         ldpc_3gpp_dec_ctrl__orrow          ;
  //
  logic            ldpc_3gpp_dec_ctrl__olast_iter     ;
  //
  logic    [7 : 0] ldpc_3gpp_dec_ctrl__ouNiter        ;
  logic            ldpc_3gpp_dec_ctrl__obusy          ;



  ldpc_3gpp_dec_ctrl
  #(
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE )
  )
  ldpc_3gpp_dec_ctrl
  (
    .iclk           ( ldpc_3gpp_dec_ctrl__iclk           ) ,
    .ireset         ( ldpc_3gpp_dec_ctrl__ireset         ) ,
    .iclkena        ( ldpc_3gpp_dec_ctrl__iclkena        ) ,
    //
    .iNiter         ( ldpc_3gpp_dec_ctrl__iNiter         ) ,
    .ifmode         ( ldpc_3gpp_dec_ctrl__ifmode         ) ,
    //
    .ibuf_empty     ( ldpc_3gpp_dec_ctrl__ibuf_empty     ) ,
    .iobuf_full     ( ldpc_3gpp_dec_ctrl__iobuf_full     ) ,
    .obuf_rempty    ( ldpc_3gpp_dec_ctrl__obuf_rempty    ) ,
    //
    .iused_zc       ( ldpc_3gpp_dec_ctrl__iused_zc       ) ,
    .iused_row      ( ldpc_3gpp_dec_ctrl__iused_row      ) ,
    //
    .ivnode_busy    ( ldpc_3gpp_dec_ctrl__ivnode_busy    ) ,
    //
    .icnode_busy    ( ldpc_3gpp_dec_ctrl__icnode_busy    ) ,
    .icnode_decfail ( ldpc_3gpp_dec_ctrl__icnode_decfail ) ,
    //
    .oload_mode     ( ldpc_3gpp_dec_ctrl__oload_mode     ) ,
    .oc_nv_mode     ( ldpc_3gpp_dec_ctrl__oc_nv_mode     ) ,
    .obypass        ( ldpc_3gpp_dec_ctrl__obypass        ) ,
    //
    .oread          ( ldpc_3gpp_dec_ctrl__oread          ) ,
    .orstart        ( ldpc_3gpp_dec_ctrl__orstart        ) ,
    .orval          ( ldpc_3gpp_dec_ctrl__orval          ) ,
    .orstrb         ( ldpc_3gpp_dec_ctrl__orstrb         ) ,
    .orrow          ( ldpc_3gpp_dec_ctrl__orrow          ) ,
    //
    .olast_iter     ( ldpc_3gpp_dec_ctrl__olast_iter     ) ,
    //
    .ouNiter        ( ldpc_3gpp_dec_ctrl__ouNiter        ) ,
    .obusy          ( ldpc_3gpp_dec_ctrl__obusy          )
  );


  assign ldpc_3gpp_dec_ctrl__iclk           = '0 ;
  assign ldpc_3gpp_dec_ctrl__ireset         = '0 ;
  assign ldpc_3gpp_dec_ctrl__iclkena        = '0 ;
  assign ldpc_3gpp_dec_ctrl__iNiter         = '0 ;
  assign ldpc_3gpp_dec_ctrl__ifmode         = '0 ;
  assign ldpc_3gpp_dec_ctrl__ibuf_empty     = '0 ;
  assign ldpc_3gpp_dec_ctrl__iobuf_full     = '0 ;
  assign ldpc_3gpp_dec_ctrl__iused_zc       = '0 ;
  assign ldpc_3gpp_dec_ctrl__iused_row      = '0 ;
  assign ldpc_3gpp_dec_ctrl__ivnode_busy    = '0 ;
  assign ldpc_3gpp_dec_ctrl__icnode_busy    = '0 ;
  assign ldpc_3gpp_dec_ctrl__icnode_decfail = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_ctrl.sv
// Description   : Main FSM. Generate address generator & vnode/cnode engines control signals
//

module ldpc_3gpp_dec_ctrl
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  iNiter         ,
  ifmode         ,
  //
  iused_zc       ,
  iused_row      ,
  //
  ibuf_full      ,
  obuf_rempty    ,
  //
  iobuf_empty    ,
  //
  ivnode_busy    ,
  //
  icnode_busy    ,
  icnode_decfail ,
  //
  oload_mode     ,
  oc_nv_mode     ,
  obypass        ,
  //
  oread          ,
  orstart        ,
  orval          ,
  orstrb         ,
  orrow          ,
  //
  olast_iter     ,
  //
  ouNiter        ,
  obusy
);

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk           ;
  input  logic            ireset         ;
  input  logic            iclkena        ;
  //
  input  logic    [7 : 0] iNiter         ;
  input  logic            ifmode         ; // fast work mode with early stop
  //
  input  hb_zc_t          iused_zc       ;
  input  hb_row_t         iused_row      ;
  //
  // input buffer interface
  input  logic            ibuf_full      ;
  output logic            obuf_rempty    ;
  // output buffer interface
  input  logic            iobuf_empty    ;
  //
  input  logic            ivnode_busy    ;
  //
  input  logic            icnode_busy    ;
  input  logic            icnode_decfail ;
  //
  output logic            oload_mode     ;  // first iteration
  output logic            oc_nv_mode     ;
  output logic            obypass        ;  // iNiter == 0
  //
  output logic            oread          ;
  output logic            orstart        ;
  output logic            orval          ;
  output strb_t           orstrb         ;
  output hb_row_t         orrow          ;
  //
  output logic            olast_iter     ;
  //
  output logic    [7 : 0] ouNiter        ;
  output logic            obusy          ;

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
    logic   done;
    logic   zero;
    hb_zc_t value;
  } zc_cnt;

  struct packed {
    logic    done;
    logic    zero;
    hb_row_t value;
  } row_cnt;

  struct packed {
    logic [7 : 0] cnt;
    logic         last;
  } iter;

  logic fast_stop;

  hb_zc_t   used_zc_m2     ;
  logic     used_zc_less2  ;

  hb_row_t  used_row_m2    ;
  logic     used_row_less2 ;

  logic     do_pause; // delay for cnode matrix mult work if pLLR_BY_CYCLE > 1
  logic     do_hdone; // delay for hstep done if pLLR_BY_CYCLE > 1

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

  wire vstep_done   = zc_cnt.done & row_cnt.done;
  wire hstep_done   = (pLLR_BY_CYCLE != 1) ? do_hdone : (zc_cnt.done & row_cnt.done);

  always_comb begin
    case (state)
      cRESET_STATE      : next_state = cWAIT_STATE;
      //
      cWAIT_STATE       : next_state = ibuf_full    ? (do_bypass ? cWAIT_O_STATE : cVSTEP_STATE)    : cWAIT_STATE;
      //
      cVSTEP_STATE      : next_state = vstep_done   ? cWAIT_VDONE_STATE                             : cVSTEP_STATE;
      cWAIT_VDONE_STATE : next_state = !ivnode_busy ? (do_last ? cDONE_STATE : cHSTEP_STATE)        : cWAIT_VDONE_STATE;
      //
      cHSTEP_STATE      : next_state = hstep_done   ? cWAIT_HDONE_STATE                             : cHSTEP_STATE;
      cWAIT_HDONE_STATE : next_state = !icnode_busy ? (outbuf_nrdy ? cWAIT_O_STATE : cVSTEP_STATE)  : cWAIT_HDONE_STATE;
      //
      cWAIT_O_STATE     : next_state = !outbuf_nrdy ? cVSTEP_STATE : cWAIT_O_STATE;
      //
      cDONE_STATE       : next_state = cWAIT_STATE;  // need to wait addr_gen latency for set_empty signal
      //
      default           : next_state = cRESET_STATE;
    endcase
  end

  assign obusy = (state != cWAIT_STATE);

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cWAIT_STATE) begin
        iter.cnt  <= iNiter;
        iter.last <= (iNiter == 0);
      end
      else if (state == cWAIT_VDONE_STATE & !ivnode_busy) begin
        iter.cnt  <= iter.cnt - 1'b1;
        iter.last <= (iter.cnt == 1);
      end
      //
      // at (state == cWAIT_STATE) & ibuf full iused_zc and iused_row is constant or hold more then 2 times
      used_zc_m2      <= (iused_zc - 2);
      used_zc_less2   <= (iused_zc < 2);
      //
      used_row_m2     <= (iused_row - 2);
      used_row_less2  <= (iused_row < 2) | do_bypass; // need only one row for bypass
      //
      do_pause        <= 1'b0;
      do_hdone        <= 1'b0;
      case (state)
        cWAIT_STATE, cWAIT_HDONE_STATE, cWAIT_VDONE_STATE : begin
          zc_cnt        <= '0;
          zc_cnt.zero   <= 1'b1;
          zc_cnt.done   <= used_zc_less2;
          //
          row_cnt       <= '0;
          row_cnt.zero  <= 1'b1;
          row_cnt.done  <= used_row_less2;
          //
          if (state == cWAIT_STATE) begin
            ouNiter <= '0;
          end
        end
        //
        // zc  -> row (get full horizontal line in one row)
        cHSTEP_STATE : begin
          do_pause <= (pLLR_BY_CYCLE != 1) & !do_pause & zc_cnt.done;
          do_hdone <= (pLLR_BY_CYCLE != 1) & !do_pause & zc_cnt.done & row_cnt.done;
          if (!do_pause) begin
            zc_cnt.value <= zc_cnt.done   ? '0   : (zc_cnt.value + 1'b1);
            zc_cnt.done  <= used_zc_less2 ? 1'b1 : (zc_cnt.value == used_zc_m2);
            zc_cnt.zero  <= zc_cnt.done;
            //
            if (zc_cnt.done) begin
              row_cnt.value <= row_cnt.done   ? '0    : (row_cnt.value + 1'b1);
              row_cnt.done  <= used_row_less2 ? 1'b1  : (row_cnt.value == used_row_m2);
              row_cnt.zero  <= row_cnt.done;
              //
              if (row_cnt.done) begin
                ouNiter <= ouNiter + 1'b1;
              end
            end
          end
        end
        //
        // row ->  zc (get full vertical line in some rows
        cVSTEP_STATE : begin
          row_cnt.value <= row_cnt.done   ? '0    : (row_cnt.value + 1'b1);
          row_cnt.done  <= used_row_less2 ? 1'b1  : (row_cnt.value == used_row_m2);
          row_cnt.zero  <= row_cnt.done;
          //
          if (row_cnt.done) begin
            zc_cnt.value <= zc_cnt.done   ? '0   : (zc_cnt.value + 1'b1);
            zc_cnt.done  <= used_zc_less2 ? 1'b1 : (zc_cnt.value == used_zc_m2);
            zc_cnt.zero  <= zc_cnt.done;
          end
        end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output decoding
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cWAIT_STATE) begin
        oload_mode <= 1'b1;
        obypass    <= do_bypass;
      end
      else if (state == cWAIT_VDONE_STATE & !ivnode_busy) begin
        oload_mode <= 1'b0;
      end
      //
      oc_nv_mode <= (state == cHSTEP_STATE) | (state == cWAIT_HDONE_STATE);
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obuf_rempty <= 1'b0;
      oread       <= 1'b0;
    end
    else if (iclkena) begin
      obuf_rempty <= (next_state == cDONE_STATE);
      oread       <= (state == cVSTEP_STATE) | (state == cHSTEP_STATE & !do_pause);
    end
  end

  assign orstart  = orstrb.sof & orstrb.sop;

  assign orval    = oread; // TODO : add support of pLLR_BY_CYCLE = 2/4/8

  //------------------------------------------------------------------------------------------------------
  //  typedef struct packed {
  //    logic sof;  // start of node frame working (row == 0 & zc == 0)
  //    logic sop;  // start of node block working cnode_mode ? (zc  == 0)         : (row == 0)
  //    logic eop;  // end   of node block working cnode_mode ? (zc  == used_zc-1) : (row == used_row-1)
  //    logic eof;  // end   of node frame working (row == used_row-1 & zc == used_zc-1)
  //  } strb_t;
  //------------------------------------------------------------------------------------------------------

  assign orrow = row_cnt.value;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      orstrb <= '0;
      //
      if (state == cHSTEP_STATE) begin
        orstrb.sof <= !do_pause & /*zc_cnt.zero &*/ row_cnt.zero;
        orstrb.sop <= !do_pause & zc_cnt.zero;
        orstrb.eop <= !do_pause & zc_cnt.done;
        orstrb.eof <= !do_pause & /*zc_cnt.done &*/ row_cnt.done;
      end
      else if (state == cVSTEP_STATE) begin
        orstrb.sof <= zc_cnt.zero/* & row_cnt.zero*/;
        orstrb.sop <= row_cnt.zero;
        orstrb.eop <= row_cnt.done;
        orstrb.eof <= zc_cnt.done /*& row_cnt.done*/;
      end
      //
      olast_iter <= ((state == cVSTEP_STATE) | (state == cWAIT_VDONE_STATE)) & do_last;
    end
  end

endmodule
