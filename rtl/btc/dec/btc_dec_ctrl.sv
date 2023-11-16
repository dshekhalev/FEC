/*



  parameter int pADDR_W  = 8 ;
  parameter int pDEC_NUM = 8 ;



  logic                             btc_dec_ctrl__iclk        ;
  logic                             btc_dec_ctrl__ireset      ;
  logic                             btc_dec_ctrl__iclkena     ;
  //
  btc_code_mode_t                   btc_dec_ctrl__ixmode      ;
  btc_code_mode_t                   btc_dec_ctrl__iymode      ;
  btc_short_mode_t                  btc_dec_ctrl__ismode      ;
  logic                     [3 : 0] btc_dec_ctrl__iNiter      ;
  logic                             btc_dec_ctrl__ifmode      ;
  //
  logic                             btc_dec_ctrl__irbuf_full  ;
  logic                             btc_dec_ctrl__obuf_rempty ;
  //
  logic                             btc_dec_ctrl__iwbuf_empty ;
  //
  logic             [pADDR_W-1 : 0] btc_dec_ctrl__obuf_addr   ;
  //
  logic                             btc_dec_ctrl__orow_mode   ;
  //
  logic                             btc_dec_ctrl__idec_busy   ;
  logic            [pDEC_NUM-1 : 0] btc_dec_ctrl__odec_val    ;
  strb_t                            btc_dec_ctrl__odec_strb   ;
  alpha_t                           btc_dec_ctrl__odec_alpha  ;
  //
  logic                             btc_dec_ctrl__idecfail    ;
  logic                             btc_dec_ctrl__ostart_iter ;
  logic                             btc_dec_ctrl__olast_iter  ;


  btc_dec_ctrl
  #(
    .pADDR_W  ( pADDR_W  ) ,
    .pDEC_NUM ( pDEC_NUM )
  )
  btc_dec_ctrl
  (
    .iclk        ( btc_dec_ctrl__iclk        ) ,
    .ireset      ( btc_dec_ctrl__ireset      ) ,
    .iclkena     ( btc_dec_ctrl__iclkena     ) ,
    //
    .ixmode      ( btc_dec_ctrl__ixmode      ) ,
    .iymode      ( btc_dec_ctrl__iymode      ) ,
    .ismode      ( btc_dec_ctrl__ismode      ) ,
    .iNiter      ( btc_dec_ctrl__iNiter      ) ,
    .ifmode      ( btc_dec_ctrl__ifmode      ) ,
    //
    .irbuf_full  ( btc_dec_ctrl__irbuf_full  ) ,
    .obuf_rempty ( btc_dec_ctrl__obuf_rempty ) ,
    //
    .iwbuf_empty ( btc_dec_ctrl__iwbuf_empty ) ,
    //
    .obuf_addr   ( btc_dec_ctrl__obuf_addr   ) ,
    //
    .orow_mode   ( btc_dec_ctrl__orow_mode   ) ,
    //
    .idec_busy   ( btc_dec_ctrl__idec_busy   ) ,
    .odec_val    ( btc_dec_ctrl__odec_val    ) ,
    .odec_strb   ( btc_dec_ctrl__odec_strb   ) ,
    .odec_alpha  ( btc_dec_ctrl__odec_alpha  ) ,
    //
    .idecfail    ( btc_dec_ctrl__idecfail    ) ,
    .ostart_iter ( btc_dec_ctrl__ostart_iter ) ,
    .olast_iter  ( btc_dec_ctrl__olast_iter  )
  );


  assign btc_dec_ctrl__iclk        = '0 ;
  assign btc_dec_ctrl__ireset      = '0 ;
  assign btc_dec_ctrl__iclkena     = '0 ;
  assign btc_dec_ctrl__ixmode      = '0 ;
  assign btc_dec_ctrl__iymode      = '0 ;
  assign btc_dec_ctrl__ismode      = '0 ;
  assign btc_dec_ctrl__iNiter      = '0 ;
  assign btc_dec_ctrl__ifmode      = '0 ;
  assign btc_dec_ctrl__irbuf_full  = '0 ;
  assign btc_dec_ctrl__iwbuf_empty = '0 ;
  assign btc_dec_ctrl__idec_busy   = '0 ;
  assign btc_dec_ctrl__idecfail    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_ctrl.sv
// Description   : BTC decoder controller
//

module btc_dec_ctrl
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  ixmode      ,
  iymode      ,
  ismode      ,
  iNiter      ,
  ifmode      ,
  //
  irbuf_full  ,
  obuf_rempty ,
  //
  iwbuf_empty ,
  //
  obuf_addr   ,
  //
  orow_mode   ,
  //
  idec_busy   ,
  odec_val    ,
  odec_strb   ,
  odec_alpha  ,
  //
  idecfail    ,
  ostart_iter ,
  olast_iter
);

  parameter int pADDR_W  = 8 ;
  parameter int pDEC_NUM = 8 ;

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                             iclk           ;
  input  logic                             ireset         ;
  input  logic                             iclkena        ;
  //
  input  btc_code_mode_t                   ixmode         ;
  input  btc_code_mode_t                   iymode         ;
  input  btc_short_mode_t                  ismode         ;
  input  logic                     [3 : 0] iNiter         ;
  input  logic                             ifmode         ;
  //
  input  logic                             irbuf_full     ;
  output logic                             obuf_rempty    ;
  //
  input  logic                             iwbuf_empty    ;
  //
  output logic             [pADDR_W-1 : 0] obuf_addr      ;
  //
  output logic                             orow_mode      ;
  //
  input  logic                             idec_busy      ;
  output logic            [pDEC_NUM-1 : 0] odec_val       ;
  output strb_t                            odec_strb      ;
  output alpha_t                           odec_alpha     ;
  //
  input  logic                             idecfail       ;
  output logic                             ostart_iter    ;
  output logic                             olast_iter     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DEC_NUM      = $clog2(pDEC_NUM);
  localparam int cLOG2_USED_ROW_MAX = cLOG2_ROW_MAX - cLOG2_DEC_NUM; // rows store in pDEC_NUM memory

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE      ,
    //
    cWAIT_STATE       ,
    //
    cDO_COL_STATE     ,
    cWAIT_COL_STATE   ,
    //
    cDO_ROW_STATE     ,
    cWAIT_ROW_STATE   ,
    //
    cWAIT_O_STATE     ,
    //
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  logic [cLOG2_COL_MAX-1 : 0] col_data_length_m1;
  logic [cLOG2_COL_MAX-1 : 0] col_code_length_m2;

  logic [cLOG2_ROW_MAX-1 : 0] row_code_length_m2;

  struct packed {
    logic                       zero;
    logic                       dec_done;
    logic                       code_done;
    logic [cLOG2_COL_MAX-1 : 0] value;
  } row_idx;

  logic [cLOG2_USED_ROW_MAX   : 0] row_length; // + 1 bit for 2^maximum(N);
  logic [cLOG2_USED_ROW_MAX-1 : 0] row_length_m2;

  struct packed {
    logic                            zero;
    logic                            done;
    logic [cLOG2_USED_ROW_MAX-1 : 0] value;
  } col_idx;

  logic [3 : 0] Niter_m2;

  struct packed {
    logic [3 : 0] cnt;
    logic         last;
  } iter;

  logic fast_stop;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cWAIT_STATE) begin
        fast_stop <= 1'b0;
      end
      else if ((state == cWAIT_ROW_STATE) & !idec_busy) begin
        fast_stop <= ifmode & !idecfail & (ixmode.code_type != cSPC_CODE) & (iymode.code_type != cSPC_CODE); // spc codes has uncertain decfail
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire col_code_done  = col_idx.done & row_idx.code_done;
  wire row_code_done  = col_idx.done & row_idx.code_done; // decode array must used fully

  wire do_bypass      = (iNiter == 0);
  wire outbuf_nrdy    = iter.last & !iwbuf_empty;
  wire do_last        = iter.last | fast_stop;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE    : state <= cWAIT_STATE;
        // col decode first
        cWAIT_STATE     : state <= irbuf_full     ? cDO_COL_STATE                                   : cWAIT_STATE;
        //
        cDO_COL_STATE   : state <=  col_code_done ? cWAIT_COL_STATE                                 : cDO_COL_STATE;
        cWAIT_COL_STATE : state <= !idec_busy     ? (outbuf_nrdy  ? cWAIT_O_STATE : cDO_ROW_STATE)  : cWAIT_COL_STATE;
        //
        cDO_ROW_STATE   : state <=  row_code_done ? cWAIT_ROW_STATE                                 : cDO_ROW_STATE;
        cWAIT_ROW_STATE : state <= !idec_busy     ? (do_last      ? cDONE_STATE   : cDO_COL_STATE)  : cWAIT_ROW_STATE;
        //
        cWAIT_O_STATE   : state <= !outbuf_nrdy   ? cDONE_STATE                                     : cDO_ROW_STATE;
        //
        cDONE_STATE     : state <= cWAIT_STATE;
      endcase
    end
  end

  assign obuf_rempty = (state == cDONE_STATE);

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  assign col_data_length_m1 = get_data_bits(iymode) - 1;

  assign col_code_length_m2 = get_code_bits(iymode) - 2;
  assign row_code_length_m2 = get_code_bits(iymode) - 2;

  assign row_length         = (get_code_bits(ixmode) >> cLOG2_DEC_NUM);
  assign row_length_m2      = row_length - 2;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cWAIT_STATE : begin
          col_idx       <= '0;
          col_idx.zero  <= 1'b1;
          col_idx.done  <= (row_length <= 1);
          //
          row_idx       <= '0;
          row_idx.zero  <= 1'b1;
          //
          iter.cnt      <= '0;
          iter.last     <= (iNiter <= 1);
          Niter_m2      <= iNiter - 2;
        end
        //
        // col decoding
        cDO_COL_STATE : begin
          row_idx.value     <=  row_idx.code_done ? '0 : (row_idx.value + 1'b1);
          row_idx.code_done <= (row_idx.value == col_code_length_m2);
          row_idx.zero      <=  row_idx.code_done;
          //
          if (row_idx.code_done) begin
            col_idx.value <=  col_idx.done ? '0 : col_idx.value + 1'b1;
            col_idx.done  <= (col_idx.value == row_length_m2) | (row_length <= 1);
            col_idx.zero  <=  col_idx.done;
          end
        end
        //
        // row decoding
        cDO_ROW_STATE : begin
          row_idx.value[cLOG2_DEC_NUM-1 : 0] <=  row_idx.dec_done ? '0 : (row_idx.value[cLOG2_DEC_NUM-1 : 0] + 1'b1);
          row_idx.dec_done                   <= (row_idx.value[cLOG2_DEC_NUM-1 : 0] == (pDEC_NUM - 2));
          row_idx.code_done                  <= (row_idx.value == row_code_length_m2);
          row_idx.zero                       <=  row_idx.code_done;
          //
          if (row_idx.dec_done) begin
            col_idx.value <=  col_idx.done ? '0 : (col_idx.value + 1'b1);
            col_idx.done  <= (col_idx.value == row_length_m2) | (row_length <= 1);
            col_idx.zero  <=  col_idx.done;
            //
            if (col_idx.done) begin
              row_idx.value[cLOG2_ROW_MAX-1 : cLOG2_DEC_NUM] <= row_idx.value[cLOG2_ROW_MAX-1 : cLOG2_DEC_NUM] + 1'b1;
            end
          end
        end
        //
        cWAIT_ROW_STATE, cWAIT_COL_STATE : begin
          col_idx       <= '0;
          col_idx.zero  <= 1'b1;
          col_idx.done  <= (row_length <= 1);
          //
          row_idx       <= '0;
          row_idx.zero  <= 1'b1;
          //
          if (state == cWAIT_ROW_STATE) begin
            if (!idec_busy) begin
              iter.cnt  <=  iter.cnt + 1'b1;
              iter.last <= (iter.cnt == Niter_m2);
            end
          end
        end
        //
        default : begin end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // scale tables
  //------------------------------------------------------------------------------------------------------

  alpha_t cSPC_COL_ALPHA   [16];
  alpha_t cSPC_ROW_ALPHA   [16];

  alpha_t cE_HAM_COL_ALPHA [16];
  alpha_t cE_HAM_ROW_ALPHA [16];

  always_comb begin
    cSPC_COL_ALPHA   = '{0 : cALPHA_0,    default : cALPHA_1};    // col first init here
    cSPC_ROW_ALPHA   = '{0 : cALPHA_0p5,  default : cALPHA_1};
    //
    cE_HAM_COL_ALPHA = '{0 : cALPHA_0,    default : cALPHA_0p5};  // col first init here
    cE_HAM_ROW_ALPHA = '{0 : cALPHA_0p5,  default : cALPHA_0p5};
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  assign obuf_addr[0                  +: cLOG2_USED_ROW_MAX] = col_idx.value;
  assign obuf_addr[cLOG2_USED_ROW_MAX +: cLOG2_COL_MAX]      = row_idx.value;

  //
  // have more then 2 tick address reading for modes
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostart_iter <= (state == cDO_COL_STATE) & row_idx.zero & col_idx.zero;
      olast_iter  <= ((state == cDO_ROW_STATE) | (state == cWAIT_ROW_STATE)) & do_last;
      //
      orow_mode   <= (state == cDO_ROW_STATE) | (state == cWAIT_ROW_STATE);
    end
  end

  wire [cLOG2_DEC_NUM-1 : 0] dec_sel = row_idx.value[cLOG2_DEC_NUM-1 : 0];

  //
  // there is register outside
  always_comb begin
    odec_val  = '0;
    odec_strb = '0;
    if ((state == cDO_COL_STATE) | (state == cWAIT_COL_STATE)) begin // work in parallel
      odec_val      = (state == cDO_COL_STATE) ? '1 : '0;
      //
      odec_strb.sof = row_idx.zero & col_idx.zero;
      odec_strb.sop = row_idx.zero;
      odec_strb.eop = row_idx.code_done;
      odec_strb.eof = row_idx.code_done & col_idx.done;
      //
      if (row_idx.value > col_data_length_m1) begin
        odec_alpha  = '0; // no extrinsic for column parity checks
      end
      else begin
        odec_alpha  = (iymode.code_type == cSPC_CODE) ? cSPC_COL_ALPHA[iter.cnt] : cE_HAM_COL_ALPHA[iter.cnt];
      end
    end
    else begin // work quasi serial
      for (int i = 0; i < pDEC_NUM; i++) begin
        odec_val[i] = (state == cDO_ROW_STATE) & (dec_sel == i);
      end
      //
      odec_strb.sof   = row_idx.zero & col_idx.zero & (dec_sel == 0);
      odec_strb.sop   = col_idx.zero;
      odec_strb.eop   = col_idx.done;
      odec_strb.eof   = row_idx.code_done & col_idx.done & (dec_sel == (pDEC_NUM-1));
      // mask rows without coding for bits and biterr
      odec_strb.mask  = (row_idx.value > col_data_length_m1);
      //
      odec_alpha      = (ixmode.code_type == cSPC_CODE) ? cSPC_ROW_ALPHA[iter.cnt] : cE_HAM_ROW_ALPHA[iter.cnt];
    end
  end

endmodule
