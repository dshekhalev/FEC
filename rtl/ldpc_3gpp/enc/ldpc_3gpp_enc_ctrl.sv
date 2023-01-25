/*


  parameter bit pPIPE        = 1 ;
  parameter bit pUSE_P1_SLOW = 0 ;


  logic    ldpc_3gpp_enc_ctrl__iclk         ;
  logic    ldpc_3gpp_enc_ctrl__ireset       ;
  logic    ldpc_3gpp_enc_ctrl__iclkena      ;
  //
  logic    ldpc_3gpp_enc_ctrl__ibuf_full    ;
  logic    ldpc_3gpp_enc_ctrl__obuf_rempty  ;
  logic    ldpc_3gpp_enc_ctrl__iobuf_empty  ;
  //
  hb_zc_t  ldpc_3gpp_enc_ctrl__iused_zc     ;
  hb_row_t ldpc_3gpp_enc_ctrl__iused_row    ;
  //
  logic    ldpc_3gpp_enc_ctrl__oaddr_clear  ;
  logic    ldpc_3gpp_enc_ctrl__oaddr_enable ;
  //
  hb_row_t ldpc_3gpp_enc_ctrl__ohb_row      ;
  //
  logic    ldpc_3gpp_enc_ctrl__oacu_write   ;
  logic    ldpc_3gpp_enc_ctrl__oacu_wstart  ;
  hb_col_t ldpc_3gpp_enc_ctrl__oacu_wcol    ;
  strb_t   ldpc_3gpp_enc_ctrl__oacu_wstrb   ;
  //
  logic    ldpc_3gpp_enc_ctrl__oacu_read    ;
  logic    ldpc_3gpp_enc_ctrl__oacu_rstart  ;
  logic    ldpc_3gpp_enc_ctrl__oacu_rval    ;
  strb_t   ldpc_3gpp_enc_ctrl__oacu_rstrb   ;
  hb_row_t ldpc_3gpp_enc_ctrl__oacu_rrow    ;
  //
  logic    ldpc_3gpp_enc_ctrl__op1_read     ;
  logic    ldpc_3gpp_enc_ctrl__op1_rstart   ;
  logic    ldpc_3gpp_enc_ctrl__op1_rval     ;
  strb_t   ldpc_3gpp_enc_ctrl__op1_rstrb    ;
  //
  logic    ldpc_3gpp_enc_ctrl__op2_read     ;
  logic    ldpc_3gpp_enc_ctrl__op2_rstart   ;
  logic    ldpc_3gpp_enc_ctrl__op2_rval     ;
  strb_t   ldpc_3gpp_enc_ctrl__op2_rstrb    ;
  hb_row_t ldpc_3gpp_enc_ctrl__op2_rrow     ;
  //
  logic    ldpc_3gpp_enc_ctrl__op3_read     ;
  logic    ldpc_3gpp_enc_ctrl__op3_rstart   ;
  logic    ldpc_3gpp_enc_ctrl__op3_rval     ;
  strb_t   ldpc_3gpp_enc_ctrl__op3_rstrb    ;



  ldpc_3gpp_enc_ctrl
  #(
    .pPIPE        ( pPIPE        ) ,
    .pUSE_P1_SLOW ( pUSE_P1_SLOW )
  )
  ldpc_3gpp_enc_ctrl
  (
    .iclk         ( ldpc_3gpp_enc_ctrl__iclk         ) ,
    .ireset       ( ldpc_3gpp_enc_ctrl__ireset       ) ,
    .iclkena      ( ldpc_3gpp_enc_ctrl__iclkena      ) ,
    //
    .ibuf_full    ( ldpc_3gpp_enc_ctrl__ibuf_full    ) ,
    .obuf_rempty  ( ldpc_3gpp_enc_ctrl__obuf_rempty  ) ,
    .iobuf_empty  ( ldpc_3gpp_enc_ctrl__iobuf_empty  ) ,
    //
    .iused_zc     ( ldpc_3gpp_enc_ctrl__iused_zc     ) ,
    .iused_row    ( ldpc_3gpp_enc_ctrl__iused_row    ) ,
    //
    .oaddr_clear  ( ldpc_3gpp_enc_ctrl__oaddr_clear  ) ,
    .oaddr_enable ( ldpc_3gpp_enc_ctrl__oaddr_enable ) ,
    //
    .ohb_row      ( ldpc_3gpp_enc_ctrl__ohb_row      ) ,
    //
    .oacu_write   ( ldpc_3gpp_enc_ctrl__oacu_write   ) ,
    .oacu_wstart  ( ldpc_3gpp_enc_ctrl__oacu_wstart  ) ,
    .oacu_wcol    ( ldpc_3gpp_enc_ctrl__oacu_wcol    ) ,
    .oacu_wstrb   ( ldpc_3gpp_enc_ctrl__oacu_wstrb   ) ,
    //
    .oacu_read    ( ldpc_3gpp_enc_ctrl__oacu_read    ) ,
    .oacu_rstart  ( ldpc_3gpp_enc_ctrl__oacu_rstart  ) ,
    .oacu_rval    ( ldpc_3gpp_enc_ctrl__oacu_rval    ) ,
    .oacu_rstrb   ( ldpc_3gpp_enc_ctrl__oacu_rstrb   ) ,
    .oacu_rrow    ( ldpc_3gpp_enc_ctrl__oacu_rrow    ) ,
    //
    .op1_read     ( ldpc_3gpp_enc_ctrl__op1_read     ) ,
    .op1_rstart   ( ldpc_3gpp_enc_ctrl__op1_rstart   ) ,
    .op1_rval     ( ldpc_3gpp_enc_ctrl__op1_rval     ) ,
    .op1_rstrb    ( ldpc_3gpp_enc_ctrl__op1_rstrb    ) ,
    //
    .op2_read     ( ldpc_3gpp_enc_ctrl__op2_read     ) ,
    .op2_rstart   ( ldpc_3gpp_enc_ctrl__op2_rstart   ) ,
    .op2_rval     ( ldpc_3gpp_enc_ctrl__op2_rval     ) ,
    .op2_rstrb    ( ldpc_3gpp_enc_ctrl__op2_rstrb    ) ,
    .op2_rrow     ( ldpc_3gpp_enc_ctrl__op2_rrow     ) ,
    //
    .op3_read     ( ldpc_3gpp_enc_ctrl__op3_read     ) ,
    .op3_rstart   ( ldpc_3gpp_enc_ctrl__op3_rstart   ) ,
    .op3_rval     ( ldpc_3gpp_enc_ctrl__op3_rval     ) ,
    .op3_rstrb    ( ldpc_3gpp_enc_ctrl__op3_rstrb    ) ,
  );


  assign ldpc_3gpp_enc_ctrl__iclk        = '0 ;
  assign ldpc_3gpp_enc_ctrl__ireset      = '0 ;
  assign ldpc_3gpp_enc_ctrl__iclkena     = '0 ;
  assign ldpc_3gpp_enc_ctrl__ibuf_full   = '0 ;
  assign ldpc_3gpp_enc_ctrl__iobuf_empty = '0 ;
  assign ldpc_3gpp_enc_ctrl__iused_zc    = '0 ;
  assign ldpc_3gpp_enc_ctrl__iused_row   = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_ctrl.sv
// Description   : encoder main controller
//

`include "define.vh"

module ldpc_3gpp_enc_ctrl
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  ibuf_full    ,
  obuf_rempty  ,
  iobuf_empty  ,
  //
  iinvPsi_zero ,
  iused_zc     ,
  iused_row    ,
  iused_col    ,
  //
  oaddr_clear  ,
  oaddr_enable ,
  //
  ohb_row      ,
  //
  oacu_write   ,
  oacu_wstart  ,
  oacu_wstrb   ,
  oacu_wcol    ,
  //
  oacu_read    ,
  oacu_rstart  ,
  oacu_rval    ,
  oacu_rstrb   ,
  oacu_rrow    ,
  //
  op1_read     ,
  op1_rstart   ,
  op1_rval     ,
  op1_rstrb    ,
  //
  op2_read     ,
  op2_rstart   ,
  op2_rval     ,
  op2_rstrb    ,
  op2_rrow     ,
  //
  op3_read     ,
  op3_rstart   ,
  op3_rval     ,
  op3_rstrb
);

  parameter bit pPIPE         = 1 ;  // use matrix multiply pipeline or not

  parameter bit pUSE_P1_SLOW  = 0 ;  // use slow sequential mathematics for P1 couning

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk         ;
  input  logic    ireset       ;
  input  logic    iclkena      ;
  //
  input  logic    ibuf_full    ;
  output logic    obuf_rempty  ;
  input  logic    iobuf_empty  ;
  //
  input  logic    iinvPsi_zero ;
  input  hb_zc_t  iused_zc     ;
  input  hb_row_t iused_row    ;
  input  hb_col_t iused_col    ;
  //
  output logic    oaddr_clear  ;
  output logic    oaddr_enable ;
  //
  output hb_row_t ohb_row      ;
  //
  output logic    oacu_write   ;
  output logic    oacu_wstart  ;
  output strb_t   oacu_wstrb   ;
  output hb_col_t oacu_wcol    ;
  //
  output logic    oacu_read    ;
  output logic    oacu_rstart  ;
  output logic    oacu_rval    ;
  output strb_t   oacu_rstrb   ;
  output hb_row_t oacu_rrow    ;
  //
  output logic    op1_read     ;
  output logic    op1_rstart   ;
  output logic    op1_rval     ;
  output strb_t   op1_rstrb    ;
  //
  output logic    op2_read     ;
  output logic    op2_rstart   ;
  output logic    op2_rval     ;
  output strb_t   op2_rstrb    ;
  output hb_row_t op2_rrow     ;
  //
  output logic    op3_read     ;
  output logic    op3_rstart   ;
  output logic    op3_rval     ;
  output strb_t   op3_rstrb    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  struct packed {
    logic     done;   // used_zc for writing/ used_zc + 1 for reading
    logic     zero;
    logic     one;
    hb_zc_t   value;
  } zc_cnt;

  logic   used_zc_less2; // < 2
  hb_zc_t used_zc_m1;    //  -1
  hb_zc_t used_zc_m2;    //  -2

  struct packed {
    logic     done;
    logic     zero;
    hb_col_t  value;
  } col_cnt;

  hb_col_t used_col_m2;

  struct packed {
    logic     last;
    logic     done;
    logic     zero;
    hb_row_t  value;
  } row_cnt;

  hb_row_t used_row_m1;
  hb_row_t used_row_m2;

  enum bit [3 : 0] {
    cRESET_STATE       ,
    //
    cWAIT_STATE        ,
    cINIT_STATE        ,
    //
    cDATA_STATE        ,  // upload ACTu engine
    cWAIT_DATA_STATE   ,
    //
    cGET_AU_STATE      ,  // A*u' for sequential p1 count
    cWAIT_AU_STATE     ,
    //
    cGET_P1_STATE      ,  // E*(T^-1)*A*u' + C*u'
    cWAIT_GET_P1_STATE ,  //
    //
    cDO_P1_STATE       ,  // p1 = inv(-E*T^-1*B+D)*(E*(T^-1)*A*u' + C*u')
    cWAIT_P1_STATE     ,
    //
    cDO_P2_STATE       ,  // p2 = (T^-1)*(A*u'+B*p1')
    cWAIT_P2_STATE     ,
    //
    cDO_P3_STATE       ,  // p3 = T*{u, p1, p2}
    cWAIT_P3_STATE     ,
    //
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  logic [7 : 0] delay;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire wr_delay = delay[1];
  wire mm_delay = delay[4 + pPIPE];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE        : state <= cWAIT_STATE;
        //
        cWAIT_STATE         : state <= (ibuf_full & iobuf_empty)    ? cINIT_STATE                                     : cWAIT_STATE;
        // decode worked parameters
        cINIT_STATE         : state <= cDATA_STATE;
        // upload data
        cDATA_STATE         : state <= (zc_cnt.done & col_cnt.done) ? cWAIT_DATA_STATE                                : cDATA_STATE;
        cWAIT_DATA_STATE    : state <= wr_delay                     ? (pUSE_P1_SLOW ? cGET_AU_STATE : cGET_P1_STATE)  : cWAIT_DATA_STATE;
        // 1 block + 1 bit
        cGET_AU_STATE       : state <= (zc_cnt.done & row_cnt.done) ? cWAIT_AU_STATE                                  : cGET_AU_STATE;
        cWAIT_AU_STATE      : state <= mm_delay                     ? cGET_P1_STATE                                   : cWAIT_AU_STATE;
        // 1 block + 1 bit
        cGET_P1_STATE       : state <= zc_cnt.done                  ? cWAIT_GET_P1_STATE                              : cGET_P1_STATE;
        cWAIT_GET_P1_STATE  : state <= mm_delay                     ? (iinvPsi_zero  ? cDO_P2_STATE  : cDO_P1_STATE)  : cWAIT_GET_P1_STATE;
        // 1 block + 1 bit
        cDO_P1_STATE        : state <= zc_cnt.done                  ? cWAIT_P1_STATE                                  : cDO_P1_STATE;
        cWAIT_P1_STATE      : state <= mm_delay                     ? cDO_P2_STATE                                    : cWAIT_P1_STATE;
        // 3 block + 1 bit
        cDO_P2_STATE        : state <= (zc_cnt.done & row_cnt.done) ? cWAIT_P2_STATE                                  : cDO_P2_STATE;
        cWAIT_P2_STATE      : state <= mm_delay                     ? (row_cnt.last ? cDONE_STATE : cDO_P3_STATE)     : cWAIT_P2_STATE;
        //
        cDO_P3_STATE        : state <= (zc_cnt.done & row_cnt.last) ? cWAIT_P3_STATE                                  : cDO_P3_STATE;
        cWAIT_P3_STATE      : state <= mm_delay                     ? cDONE_STATE                                     : cWAIT_P3_STATE;
        //
        cDONE_STATE         : state <= cWAIT_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      delay         <= '0;
      //
      case (state)
        cINIT_STATE   : begin
          zc_cnt        <= '0;
          zc_cnt.done   <= (iused_zc < 2);  // for writing
          zc_cnt.zero   <= 1'b1;
          //
          row_cnt       <= '0;
          row_cnt.zero  <= 1'b1;
          //
          col_cnt       <= '0;
          col_cnt.zero  <= 1'b1;
          //
          used_zc_m1    <=  iused_zc - 1;
          used_zc_m2    <=  iused_zc - 2;
          used_zc_less2 <= (iused_zc < 2);
          //
          used_row_m1   <= iused_row - 1;
          used_row_m2   <= iused_row - 2;
          //
          used_col_m2   <= iused_col - 2;
        end
        //
        cDATA_STATE   : begin
          zc_cnt.value  <= zc_cnt.done   ?   '0 : (zc_cnt.value + 1'b1);
          zc_cnt.done   <= used_zc_less2 ? 1'b1 : (zc_cnt.value == used_zc_m2);
          zc_cnt.zero   <= zc_cnt.done;
          zc_cnt.one    <= zc_cnt.zero;
          //
          if (zc_cnt.done) begin
            col_cnt.value <= col_cnt.value + 1'b1;
            col_cnt.done  <= (col_cnt.value == used_col_m2);
            col_cnt.zero  <= col_cnt.done;
          end
        end
        //
        cWAIT_DATA_STATE, cWAIT_AU_STATE, cWAIT_GET_P1_STATE, cWAIT_P1_STATE, cWAIT_P2_STATE, cWAIT_P3_STATE : begin
          delay       <= (delay << 1) | 1'b1;
          //
          zc_cnt      <= '0;
          zc_cnt.zero <= 1'b1;
          //
          if (pUSE_P1_SLOW & (state == cWAIT_GET_P1_STATE)) begin
            row_cnt       <= '0;
            row_cnt.zero  <= 1'b1;
          end
        end
        // + 1
        cGET_AU_STATE : begin
          zc_cnt.value  <= zc_cnt.done ? '0 : (zc_cnt.value + 1'b1);
          zc_cnt.done   <= (zc_cnt.value == used_zc_m1);  // + 1 bit
          zc_cnt.zero   <= zc_cnt.done;
          zc_cnt.one    <= zc_cnt.zero;
          //
          row_cnt.last  <= (row_cnt.value == used_row_m1);
          if (zc_cnt.done) begin
            row_cnt.value <= row_cnt.value + 1'b1;
            row_cnt.done  <= (row_cnt.value == 1);
            row_cnt.zero  <=  row_cnt.done;
          end
        end
        // + 1
        cGET_P1_STATE : begin
          zc_cnt.value  <= zc_cnt.done ? '0 : (zc_cnt.value + 1'b1);
          zc_cnt.done   <= (zc_cnt.value == used_zc_m1);  // + 1 bit
          zc_cnt.zero   <= zc_cnt.done;
          zc_cnt.one    <= zc_cnt.zero;
        end
        // + 1
        cDO_P1_STATE  : begin
          zc_cnt.value  <= zc_cnt.done ? '0 : (zc_cnt.value + 1'b1);
          zc_cnt.done   <= (zc_cnt.value == used_zc_m1);  // + 1 bit
          zc_cnt.zero   <= zc_cnt.done;
          zc_cnt.one    <= zc_cnt.zero;
        end
        // + 1
        cDO_P2_STATE  : begin
          zc_cnt.value  <= zc_cnt.done ? '0 : (zc_cnt.value + 1'b1);
          zc_cnt.done   <= (zc_cnt.value == used_zc_m1);  // + 1 bit
          zc_cnt.zero   <= zc_cnt.done;
          zc_cnt.one    <= zc_cnt.zero;
          //
          row_cnt.last  <= (row_cnt.value == used_row_m2); // -1
          if (zc_cnt.done) begin
            row_cnt.value <= row_cnt.done ? 4 : row_cnt.value + 1'b1;
            row_cnt.done  <= (row_cnt.value == 1);
            row_cnt.zero  <=  row_cnt.done;
          end
        end
        // + 1
        cDO_P3_STATE : begin
          zc_cnt.value  <= zc_cnt.done ? '0 : (zc_cnt.value + 1'b1);
          zc_cnt.done   <= (zc_cnt.value == used_zc_m1);  // + 1 bit
          zc_cnt.zero   <= zc_cnt.done;
          zc_cnt.one    <= zc_cnt.zero;
          //
          row_cnt.last  <= (row_cnt.value == used_row_m1);
          if (zc_cnt.done) begin
            row_cnt.value <=  row_cnt.value + 1'b1;
            row_cnt.done  <= (row_cnt.value == 1);
            row_cnt.zero  <=  row_cnt.done;
          end
        end
        //
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decode
  //------------------------------------------------------------------------------------------------------

  assign oaddr_clear  = (state == cINIT_STATE);
  assign oaddr_enable = (state == cDATA_STATE);

  assign ohb_row      = row_cnt.value;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obuf_rempty <= 1'b0;
      //
      oacu_write  <= 1'b0;
      //
      oacu_rval   <= 1'b0;
      op1_rval    <= 1'b0;
      op2_rval    <= 1'b0;
      op3_rval    <= 1'b0;
    end
    else if (iclkena) begin
      obuf_rempty <= (((state == cWAIT_P2_STATE) & row_cnt.last) | (state == cWAIT_P3_STATE)) & mm_delay;
      //
      oacu_write  <= (state == cDATA_STATE);
      //
      oacu_rval   <= (state == cGET_AU_STATE | state == cGET_P1_STATE) & !zc_cnt.zero;
      op1_rval    <= (state ==  cDO_P1_STATE) & !zc_cnt.zero;
      op2_rval    <= (state ==  cDO_P2_STATE) & !zc_cnt.zero;
      op3_rval    <= (state ==  cDO_P3_STATE) & !zc_cnt.zero;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oacu_wstart     <= (state == cDATA_STATE) & zc_cnt.zero;
      oacu_wstrb.sof  <= (state == cDATA_STATE) & zc_cnt.zero & col_cnt.zero;
      oacu_wstrb.sop  <= (state == cDATA_STATE) & zc_cnt.zero;
      oacu_wstrb.eop  <= (state == cDATA_STATE) & zc_cnt.done;
      oacu_wstrb.eof  <= (state == cDATA_STATE) & zc_cnt.done & col_cnt.done;
      oacu_wcol       <= col_cnt.value;
      //
      oacu_read       <= (state == cGET_AU_STATE | state == cGET_P1_STATE | state == cDO_P3_STATE);
      oacu_rstart     <= (state == cGET_AU_STATE | state == cGET_P1_STATE | state == cDO_P3_STATE) &  zc_cnt.zero;
      oacu_rstrb.sof  <= (state == cGET_AU_STATE | state == cGET_P1_STATE) & zc_cnt.one ;
      oacu_rstrb.sop  <= (state == cGET_AU_STATE | state == cGET_P1_STATE) & zc_cnt.one ;
      oacu_rstrb.eop  <= (state == cGET_AU_STATE | state == cGET_P1_STATE) & zc_cnt.done;
      oacu_rstrb.eof  <= (state == cGET_AU_STATE | state == cGET_P1_STATE) & zc_cnt.done;
      oacu_rrow       <= row_cnt.value;
      //
      op1_read        <= (state == cDO_P1_STATE);
      op1_rstart      <= (state == cDO_P1_STATE) & zc_cnt.zero;
      op1_rstrb.sof   <= (state == cDO_P1_STATE) & zc_cnt.one & row_cnt.zero;
      op1_rstrb.sop   <= (state == cDO_P1_STATE) & zc_cnt.one ;
      op1_rstrb.eop   <= (state == cDO_P1_STATE) & zc_cnt.done;
      op1_rstrb.eof   <= 1'b0; // n.u.
      //
      op2_read        <= (state == cGET_P1_STATE | state == cDO_P2_STATE | state == cDO_P3_STATE);
      op2_rstart      <= (state == cGET_P1_STATE | state == cDO_P2_STATE | state == cDO_P3_STATE) &  zc_cnt.zero;
      op2_rstrb.sof   <= 1'b0; // n.u.
      op2_rstrb.sop   <= (state == cDO_P2_STATE) & zc_cnt.one;
      op2_rstrb.eop   <= (state == cDO_P2_STATE) & zc_cnt.done;
      op2_rstrb.eof   <= (state == cDO_P2_STATE) & zc_cnt.done & row_cnt.last;
      op2_rrow        <= row_cnt.value;
      //
      op3_read        <= (state == cDO_P3_STATE);
      op3_rstart      <= (state == cDO_P3_STATE) & zc_cnt.zero;
      op3_rstrb.sof   <= 1'b0; // n.u.
      op3_rstrb.sop   <= (state == cDO_P3_STATE) & zc_cnt.one;
      op3_rstrb.eop   <= (state == cDO_P3_STATE) & zc_cnt.done;
      op3_rstrb.eof   <= (state == cDO_P3_STATE) & zc_cnt.done & row_cnt.last;
    end
  end

endmodule
