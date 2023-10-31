/*



  parameter int pADDR_W = 1 ;



  logic                            btc_enc_ctrl__iclk          ;
  logic                            btc_enc_ctrl__ireset        ;
  logic                            btc_enc_ctrl__iclkena       ;
  //
  btc_code_mode_t                  btc_enc_ctrl__ixmode        ;
  btc_code_mode_t                  btc_enc_ctrl__iymode        ;
  btc_short_mode_t                 btc_enc_ctrl__ismode        ;
  //
  logic                            btc_enc_ctrl__irbuf_full    ;
  logic                            btc_enc_ctrl__orempty       ;
  //
  logic                            btc_enc_ctrl__iwbuf_empty   ;
  //
  logic            [pADDR_W-1 : 0] btc_enc_ctrl__obuf_addr     ;
  //
  logic                            btc_enc_ctrl__orow_mode     ;
  //
  logic                            btc_enc_ctrl__irow_enc_busy ;
  logic                            btc_enc_ctrl__orow_enc_sop  ;
  logic                            btc_enc_ctrl__orow_enc_eop  ;
  logic                            btc_enc_ctrl__orow_enc_val  ;
  //
  logic                            btc_enc_ctrl__icol_enc_busy ;
  logic                            btc_enc_ctrl__ocol_enc_sop  ;
  logic                            btc_enc_ctrl__ocol_enc_eop  ;
  logic                            btc_enc_ctrl__ocol_enc_eof  ;
  logic                            btc_enc_ctrl__ocol_enc_val  ;
  //
  logic                            btc_enc_ctrl__owrite        ;
  logic                            btc_enc_ctrl__owfull        ;



  btc_enc_ctrl
  #(
    .pADDR_W ( pADDR_W )
  )
  btc_enc_ctrl
  (
    .iclk          ( btc_enc_ctrl__iclk          ) ,
    .ireset        ( btc_enc_ctrl__ireset        ) ,
    .iclkena       ( btc_enc_ctrl__iclkena       ) ,
    //
    .ixmode        ( btc_enc_ctrl__ixmode        ) ,
    .iymode        ( btc_enc_ctrl__iymode        ) ,
    .ismode        ( btc_enc_ctrl__ismode        ) ,
    //
    .irbuf_full    ( btc_enc_ctrl__irbuf_full    ) ,
    .orempty       ( btc_enc_ctrl__orempty       ) ,
    //
    .iwbuf_empty   ( btc_enc_ctrl__iwbuf_empty   ) ,
    //
    .obuf_addr     ( btc_enc_ctrl__obuf_addr     ) ,
    //
    .orow_mode     ( btc_enc_ctrl__orow_mode     ) ,
    //
    .irow_enc_busy ( btc_enc_ctrl__irow_enc_busy ) ,
    .orow_enc_sop  ( btc_enc_ctrl__orow_enc_sop  ) ,
    .orow_enc_eop  ( btc_enc_ctrl__orow_enc_eop  ) ,
    .orow_enc_val  ( btc_enc_ctrl__orow_enc_val  ) ,
    //
    .icol_enc_busy ( btc_enc_ctrl__icol_enc_busy ) ,
    .ocol_enc_sop  ( btc_enc_ctrl__ocol_enc_sop  ) ,
    .ocol_enc_eop  ( btc_enc_ctrl__ocol_enc_eop  ) ,
    .ocol_enc_eof  ( btc_enc_ctrl__ocol_enc_eof  ) ,
    .ocol_enc_val  ( btc_enc_ctrl__ocol_enc_val  ) ,
    //
    .owrite        ( btc_enc_ctrl__owrite        ) ,
    .owfull        ( btc_enc_ctrl__owfull        )
  );


  assign btc_enc_ctrl__iclk          = '0 ;
  assign btc_enc_ctrl__ireset        = '0 ;
  assign btc_enc_ctrl__iclkena       = '0 ;
  assign btc_enc_ctrl__ixmode        = '0 ;
  assign btc_enc_ctrl__iymode        = '0 ;
  assign btc_enc_ctrl__ismode        = '0 ;
  assign btc_enc_ctrl__irbuf_full    = '0 ;
  assign btc_enc_ctrl__iwbuf_empty   = '0 ;
  assign btc_enc_ctrl__irow_enc_busy = '0 ;
  assign btc_enc_ctrl__icol_enc_busy = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_enc_ctrl.sv
// Description   : BTC encoder controller
//

module btc_enc_ctrl
#(
  parameter int pDAT_W  = 8 ,
  parameter int pADDR_W = 8
)
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  ixmode        ,
  iymode        ,
  ismode        ,
  //
  irbuf_full    ,
  orempty       ,
  //
  iwbuf_empty   ,
  //
  obuf_addr     ,
  //
  orow_mode     ,
  //
  irow_enc_busy ,
  orow_enc_sop  ,
  orow_enc_eop  ,
  orow_enc_val  ,
  //
  icol_enc_busy ,
  ocol_enc_sop  ,
  ocol_enc_eop  ,
  ocol_enc_eof  ,
  ocol_enc_val  ,
  //
  owrite        ,
  owfull
);

  `include "../btc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                            iclk          ;
  input  logic                            ireset        ;
  input  logic                            iclkena       ;
  //
  input  btc_code_mode_t                  ixmode        ;
  input  btc_code_mode_t                  iymode        ;
  input  btc_short_mode_t                 ismode        ;
  //
  input  logic                            irbuf_full    ;
  output logic                            orempty       ;
  //
  input  logic                            iwbuf_empty   ;
  //
  output logic            [pADDR_W-1 : 0] obuf_addr     ;
  //
  output logic                            orow_mode     ;
  //
  input  logic                            irow_enc_busy ;
  output logic                            orow_enc_sop  ;
  output logic                            orow_enc_eop  ;
  output logic                            orow_enc_val  ;
  //
  input  logic                            icol_enc_busy ;
  output logic                            ocol_enc_sop  ;
  output logic                            ocol_enc_eop  ;
  output logic                            ocol_enc_eof  ;
  output logic                            ocol_enc_val  ;
  //
  output logic                            owrite        ;
  output logic                            owfull        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DAT_W        = $clog2(pDAT_W);
  localparam int cLOG2_USED_COL_MAX = cLOG2_COL_MAX - cLOG2_DAT_W; // rows store in pDAT_W memory

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE    ,
    //
    cWAIT_STATE     ,
    //
    cDO_ROW_STATE   ,
    cWAIT_ROW_STATE ,
    //
    cDO_COL_STATE   ,
    cWAIT_COL_STATE ,
    //
    cDO_WRITE_STATE ,
    //
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  logic [cLOG2_ROW_MAX-1 : 0] col_data_length_m2;
  logic [cLOG2_ROW_MAX-1 : 0] col_code_length_m2;

  struct packed {
    logic                       zero;
    logic                       data_done;
    logic                       code_done;
    logic [cLOG2_ROW_MAX-1 : 0] value;
  } row_idx;

  logic   [cLOG2_USED_COL_MAX : 0] row_length; // + 1 bit for 2^maximum(N);
  logic [cLOG2_USED_COL_MAX-1 : 0] row_length_m2;

  struct packed {
    logic                            zero;
    logic                            done;
    logic [cLOG2_USED_COL_MAX-1 : 0] value;
  } col_idx;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire row_code_done  = col_idx.done & row_idx.data_done; // encode only "data rows"
  wire col_code_done  = col_idx.done & row_idx.code_done;
  wire write_done     = col_idx.done & row_idx.code_done;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE    : state <= cWAIT_STATE;
        //
        cWAIT_STATE     : state <= (irbuf_full & iwbuf_empty) ? cDO_ROW_STATE   : cWAIT_STATE;
        //
        cDO_ROW_STATE   : state <=  row_code_done             ? cWAIT_ROW_STATE : cDO_ROW_STATE;
        cWAIT_ROW_STATE : state <= !irow_enc_busy             ? cDO_COL_STATE   : cWAIT_ROW_STATE;
        //
        cDO_COL_STATE   : state <=  col_code_done             ? cWAIT_COL_STATE : cDO_COL_STATE;
        cWAIT_COL_STATE : state <= !icol_enc_busy             ? cDO_WRITE_STATE : cWAIT_COL_STATE;
        //
        cDO_WRITE_STATE : state <=  write_done                ? cDONE_STATE     : cDO_WRITE_STATE;
        //
        cDONE_STATE     : state <= cWAIT_STATE;
      endcase
    end
  end

  assign orempty = (state == cDONE_STATE);

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  assign col_data_length_m2 = get_data_bits(iymode) - 2;
  assign col_code_length_m2 = get_code_bits(iymode) - 2;

  assign row_length         = (get_code_bits(ixmode) >> cLOG2_DAT_W);
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
        end
        //
        // row coding
        cDO_ROW_STATE : begin
          col_idx.value <=  col_idx.done ? '0 : (col_idx.value + 1'b1);
          col_idx.done  <= (col_idx.value == row_length_m2) | (row_length <= 1);
          col_idx.zero  <=  col_idx.done;
          //
          if (col_idx.done) begin
            row_idx.value     <=  row_idx.code_done ? '0 : (row_idx.value + 1'b1);
            row_idx.data_done <= (row_idx.value == col_data_length_m2);
            row_idx.code_done <= (row_idx.value == col_code_length_m2);
            row_idx.zero      <=  row_idx.code_done;
          end
        end
        //
        // col coding
        cDO_COL_STATE : begin
          row_idx.value     <=  row_idx.code_done ? '0 : (row_idx.value + 1'b1);
          row_idx.data_done <= (row_idx.value == col_data_length_m2);
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
        cWAIT_ROW_STATE, cWAIT_COL_STATE : begin
          col_idx       <= '0;
          col_idx.zero  <= 1'b1;
          col_idx.done  <= (row_length <= 1);
          //
          row_idx       <= '0;
          row_idx.zero  <= 1'b1;
        end
        //
        // writeback (write full row);
        cDO_WRITE_STATE : begin
          col_idx.value <=  col_idx.done ? '0 : (col_idx.value + 1'b1);
          col_idx.done  <= (col_idx.value == row_length_m2) | (row_length <= 1);
          col_idx.zero  <=  col_idx.done;
          //
          if (col_idx.done) begin
            row_idx.value     <=  row_idx.code_done ? '0 : (row_idx.value + 1'b1);
            row_idx.data_done <= (row_idx.value == col_data_length_m2);
            row_idx.code_done <= (row_idx.value == col_code_length_m2);
            row_idx.zero      <=  row_idx.code_done;
          end
        end
        //
        default : begin end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  assign obuf_addr[0                  +: cLOG2_USED_COL_MAX] = col_idx.value;
  assign obuf_addr[cLOG2_USED_COL_MAX +: cLOG2_ROW_MAX]      = row_idx.value;

  assign orow_mode    = (state == cDO_ROW_STATE) | (state == cWAIT_ROW_STATE);

  // there is register outside
  assign orow_enc_sop = col_idx.zero             ;
  assign orow_enc_eop = col_idx.done             ;
  assign orow_enc_val = (state == cDO_ROW_STATE) ;
  //
  assign ocol_enc_sop = row_idx.zero             ;
  assign ocol_enc_eop = row_idx.data_done        ;
  assign ocol_enc_eof = row_idx.code_done        ;
  assign ocol_enc_val = (state == cDO_COL_STATE) ;
  //
  assign owrite       = (state == cDO_WRITE_STATE) ;
  assign owfull       = (state == cDO_WRITE_STATE) & write_done ;

endmodule

