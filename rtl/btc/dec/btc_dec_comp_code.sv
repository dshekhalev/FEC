/*



  parameter int pLLR_W   =  5 ;
  parameter int pEXTR_W  =  6 ;
  //
  parameter int pADDR_W  =  8 ;
  //
  parameter int pERR_W   = 16 ;
  parameter int pDEC_NUM =  8 ;



  logic                            btc_dec_comp_code__iclk                 ;
  logic                            btc_dec_comp_code__ireset               ;
  logic                            btc_dec_comp_code__iclkena              ;
  //
  btc_code_mode_t                  btc_dec_comp_code__ixmode               ;
  btc_code_mode_t                  btc_dec_comp_code__iymode               ;
  //
  logic                            btc_dec_comp_code__istart               ;
  logic                            btc_dec_comp_code__istart_iter          ;
  logic                            btc_dec_comp_code__irow_mode            ;
  alpha_t                          btc_dec_comp_code__ialpha               ;
  //
  logic           [pDEC_NUM-1 : 0] btc_dec_comp_code__ival                 ;
  strb_t                           btc_dec_comp_code__istrb                ;
  logic                            btc_dec_comp_code__ismask    [pDEC_NUM] ;
  llr_t                            btc_dec_comp_code__iLLR      [pDEC_NUM] ;
  extr_t                           btc_dec_comp_code__iLextr    [pDEC_NUM] ;
  //
  logic                            btc_dec_comp_code__oval                 ;
  strb_t                           btc_dec_comp_code__ostrb     [pDEC_NUM] ;
  extr_t                           btc_dec_comp_code__oLextr    [pDEC_NUM] ;
  logic           [pDEC_NUM-1 : 0] btc_dec_comp_code__obitdat              ;
  //
  logic            [pADDR_W-1 : 0] btc_dec_comp_code__owaddr               ;
  //
  logic             [pERR_W-1 : 0] btc_dec_comp_code__obiterr              ;
  logic                            btc_dec_comp_code__obiterr_val          ;
  logic             [pERR_W-1 : 0] btc_dec_comp_code__obiterr_num          ;
  //
  logic                            btc_dec_comp_code__odecfail             ;



  btc_dec_comp_code
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pEXTR_W  ( pEXTR_W  ) ,
    .pERR_W   ( pERR_W   ) ,
    .pDEC_NUM ( pDEC_NUM )
  )
  btc_dec_comp_code
  (
    .iclk        ( btc_dec_comp_code__iclk        ) ,
    .ireset      ( btc_dec_comp_code__ireset      ) ,
    .iclkena     ( btc_dec_comp_code__iclkena     ) ,
    //
    .ixmode      ( btc_dec_comp_code__ixmode      ) ,
    .iymode      ( btc_dec_comp_code__iymode      ) ,
    //
    .istart      ( btc_dec_comp_code__istart      ) ,
    .istart_iter ( btc_dec_comp_code__istart_iter ) ,
    .irow_mode   ( btc_dec_comp_code__irow_mode   ) ,
    .ialpha      ( btc_dec_comp_code__ialpha      ) ,
    //
    .ival        ( btc_dec_comp_code__ival        ) ,
    .istrb       ( btc_dec_comp_code__istrb       ) ,
    .ismask      ( btc_dec_comp_code__ismask      ) ,
    .iLLR        ( btc_dec_comp_code__iLLR        ) ,
    .iLextr      ( btc_dec_comp_code__iLextr      ) ,
    //
    .oval        ( btc_dec_comp_code__oval        ) ,
    .ostrb       ( btc_dec_comp_code__ostrb       ) ,
    .oLextr      ( btc_dec_comp_code__oLextr      ) ,
    .obitdat     ( btc_dec_comp_code__obitdat     ) ,
    //
    .owaddr      ( btc_dec_comp_code__owaddr      ) ,
    //
    .obiterr     ( btc_dec_comp_code__obiterr     ) ,
    .obiterr_val ( btc_dec_comp_code__obiterr_val ) ,
    .obiterr_num ( btc_dec_comp_code__obiterr_num ) ,
    //
    .odecfail    ( btc_dec_comp_code__odecfail    )
  );


  assign btc_dec_comp_code__iclk        = '0 ;
  assign btc_dec_comp_code__ireset      = '0 ;
  assign btc_dec_comp_code__iclkena     = '0 ;
  assign btc_dec_comp_code__ixmode      = '0 ;
  assign btc_dec_comp_code__iymode      = '0 ;
  assign btc_dec_comp_code__istart      = '0 ;
  assign btc_dec_comp_code__istart_iter = '0 ;
  assign btc_dec_comp_code__irow_mode   = '0 ;
  assign btc_dec_comp_code__ialpha      = '0 ;
  assign btc_dec_comp_code__ival        = '0 ;
  assign btc_dec_comp_code__istrb       = '0 ;
  assign btc_dec_comp_code__ismask      = '0 ;
  assign btc_dec_comp_code__iLLR        = '0 ;
  assign btc_dec_comp_code__iLextr      = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code.sv
// Description   : component code top level for row/col soft decoding
//

module btc_dec_comp_code
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  ixmode      ,
  iymode      ,
  //
  istart      ,
  istart_iter ,
  irow_mode   ,
  ialpha      ,
  //
  ival        ,
  istrb       ,
  ismask      ,
  iLLR        ,
  iLextr      ,
  //
  oval        ,
  ostrb       ,
  oLextr      ,
  obitdat     ,
  //
  owaddr      ,
  //
  obiterr     ,
  obiterr_val ,
  obiterr_num ,
  //
  odecfail
);

  parameter int pADDR_W  =  8 ;
  //
  parameter int pERR_W   = 16 ;
  parameter int pDEC_NUM =  8 ;

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                            iclk                 ;
  input  logic                            ireset               ;
  input  logic                            iclkena              ;
  //
  input  btc_code_mode_t                  ixmode               ;  // component code modes
  input  btc_code_mode_t                  iymode               ;
  //
  input  logic                            istart               ;  // decoding start
  input  logic                            istart_iter          ;  // iteration start
  input  logic                            irow_mode            ;  // row/col mode
  input  alpha_t                          ialpha               ;  // iteration row/col scale factor
  //
  input  logic           [pDEC_NUM-1 : 0] ival                 ;
  input  strb_t                           istrb                ;
  input  logic                            ismask    [pDEC_NUM] ;
  input  llr_t                            iLLR      [pDEC_NUM] ;
  input  extr_t                           iLextr    [pDEC_NUM] ;
  //
  output logic                            oval                 ;
  output strb_t                           ostrb                ;
  output extr_t                           oLextr    [pDEC_NUM] ;
  output logic           [pDEC_NUM-1 : 0] obitdat              ;
  //
  output logic            [pADDR_W-1 : 0] owaddr               ;
  //
  output logic             [pERR_W-1 : 0] obiterr              ;
  output logic                            obiterr_val          ;
  output logic             [pERR_W-1 : 0] obiterr_num          ;
  //
  output logic                            odecfail             ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DEC_NUM      = $clog2(pDEC_NUM);
  localparam int cLOG2_USED_ROW_MAX = cLOG2_ROW_MAX - cLOG2_DEC_NUM; // rows store in pDEC_NUM memory

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                   source__oval    [pDEC_NUM] ;
  strb_t                  source__ostrb   [pDEC_NUM] ;
  logic                   source__och_hd  [pDEC_NUM] ;
  extr_t                  source__oLapri  [pDEC_NUM] ;

  //
  // component code decoders
  logic                   code__istart        [pDEC_NUM] ;
  btc_code_mode_t         code__imode         [pDEC_NUM] ;
  //
  logic                   code__ival          [pDEC_NUM] ;
  strb_t                  code__istrb         [pDEC_NUM] ;
  logic                   code__ich_hd        [pDEC_NUM] ;
  extr_t                  code__iLapri        [pDEC_NUM] ;

  logic                   code__oval          [pDEC_NUM] ;
  strb_t                  code__ostrb         [pDEC_NUM] ;
  extr_t                  code__oLextr        [pDEC_NUM] ;
  //
  logic                   code__obitdat       [pDEC_NUM] ;
  logic                   code__obiterr       [pDEC_NUM] ;
  //
  logic                   code__odecfail      [pDEC_NUM] ;
  logic                   code__odecfail_val  [pDEC_NUM] ;

  //
  // sink
  logic  [pDEC_NUM-1 : 0] sink__ival                 ;
  strb_t                  sink__istrb     [pDEC_NUM] ;
  extr_t                  sink__iLextr    [pDEC_NUM] ;
  //
  logic  [pDEC_NUM-1 : 0] sink__ibitdat              ;
  logic  [pDEC_NUM-1 : 0] sink__ibiterr              ;
  //
  logic                   sink__oval                 ;
  strb_t                  sink__ostrb                ;
  extr_t                  sink__oLextr    [pDEC_NUM] ;
  logic  [pDEC_NUM-1 : 0] sink__obitdat              ;
  logic  [pDEC_NUM-1 : 0] sink__obiterr              ;

  //
  // address generation unit
  logic [cLOG2_COL_MAX-1 : 0] col_data_length_m1;
  logic [cLOG2_COL_MAX-1 : 0] col_code_length_m2;

  struct packed {
    logic                       dec_done;
    logic                       code_done;
    logic [cLOG2_COL_MAX-1 : 0] value;
  } row_idx;

  logic [cLOG2_USED_ROW_MAX   : 0] row_length; // + 1 bit for 2^maximum(N);
  logic [cLOG2_USED_ROW_MAX-1 : 0] row_length_m2;
  logic                            row_length_less_eq_1;

  struct packed {
    logic                            done;
    logic [cLOG2_USED_ROW_MAX-1 : 0] value;
  } col_idx;

  //
  // biterr counter
  logic [pDEC_NUM-1 : 0] biterr;
  logic                  biterr_val;
  strb_t                 biterr_strb;
  logic [pDEC_NUM-1 : 0] biterr_mask;

  //------------------------------------------------------------------------------------------------------
  // cc source
  //------------------------------------------------------------------------------------------------------

  btc_dec_comp_code_source
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pEXTR_W  ( pEXTR_W  ) ,
    //
    .pDEC_NUM ( pDEC_NUM )
  )
  source
  (
    .iclk      ( iclk           ) ,
    .ireset    ( ireset         ) ,
    .iclkena   ( iclkena        ) ,
    //
    .irow_mode ( irow_mode      ) ,
    //
    .ival      ( ival           ) ,
    .istrb     ( istrb          ) ,
    .ismask    ( ismask         ) ,
    .iLLR      ( iLLR           ) ,
    .iLextr    ( iLextr         ) ,
    .ialpha    ( ialpha         ) ,
    //
    .oval      ( source__oval   ) ,
    .ostrb     ( source__ostrb  ) ,
    .och_hd    ( source__och_hd ) ,
    .oLapri    ( source__oLapri )
  );

  //------------------------------------------------------------------------------------------------------
  // cc engines
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < pDEC_NUM; g++) begin : comp_code_inst_gen
      btc_dec_comp_code_engine
      #(
        .pLLR_W  ( pLLR_W  ) ,
        .pEXTR_W ( pEXTR_W )
      )
      code
      (
        .iclk         ( iclk                   ) ,
        .ireset       ( ireset                 ) ,
        .iclkena      ( iclkena                ) ,
        //
        .istart       ( code__istart       [g] ) ,
        .imode        ( code__imode        [g] ) ,
        //
        .ival         ( code__ival         [g] ) ,
        .istrb        ( code__istrb        [g] ) ,
        .ich_hd       ( code__ich_hd       [g] ) ,
        .iLapri       ( code__iLapri       [g] ) ,
        //
        .oval         ( code__oval         [g] ) ,
        .ostrb        ( code__ostrb        [g] ) ,
        .oLextr       ( code__oLextr       [g] ) ,
        .obitdat      ( code__obitdat      [g] ) ,
        .obiterr      ( code__obiterr      [g] ) ,
        //
        .odecfail     ( code__odecfail     [g] ) ,
        .odecfail_val ( code__odecfail_val [g] )
      );

      assign code__istart [g] = istart_iter ;

      assign code__ival   [g] = source__oval   [g] ;
      assign code__istrb  [g] = source__ostrb  [g] ;
      assign code__ich_hd [g] = source__och_hd [g] ;
      assign code__iLapri [g] = source__oLapri [g] ;

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          code__imode [g] <= irow_mode ? ixmode : iymode ;
        end
      end

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // cc sink
  //------------------------------------------------------------------------------------------------------

  btc_dec_comp_code_sink
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pEXTR_W  ( pEXTR_W  ) ,
    //
    .pERR_W   ( pERR_W   ) ,
    //
    .pDEC_NUM ( pDEC_NUM )
  )
  sink
  (
    .iclk      ( iclk           ) ,
    .ireset    ( ireset         ) ,
    .iclkena   ( iclkena        ) ,
    //
    .irow_mode ( irow_mode      ) ,
    //
    .ival      ( sink__ival     ) ,
    .istrb     ( sink__istrb    ) ,
    .iLextr    ( sink__iLextr   ) ,
    .ibitdat   ( sink__ibitdat  ) ,
    .ibiterr   ( sink__ibiterr  ) ,
    //
    .oval      ( sink__oval     ) ,
    .ostrb     ( sink__ostrb    ) ,
    .oLextr    ( sink__oLextr   ) ,
    .obitdat   ( sink__obitdat  ) ,
    .obiterr   ( sink__obiterr  )
  );

  always_comb begin
    for (int i = 0; i < pDEC_NUM; i++) begin
      sink__ival    [i] = code__oval    [i];
      sink__istrb   [i] = code__ostrb   [i];
      sink__iLextr  [i] = code__oLextr  [i];
      sink__ibitdat [i] = code__obitdat [i];
      sink__ibiterr [i] = code__obiterr [i];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= sink__oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostrb   <= sink__ostrb;
      oLextr  <= sink__oLextr;
      obitdat <= sink__obitdat;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // address generation units (row/col)
  //------------------------------------------------------------------------------------------------------

  // has regiser upside
  assign col_data_length_m1   = get_data_bits(iymode) - 1;
  assign col_code_length_m2   = get_code_bits(iymode) - 2;

  assign row_length           = (get_code_bits(ixmode) >> cLOG2_DEC_NUM);
  assign row_length_m2        =  row_length - 2;
  assign row_length_less_eq_1 = (row_length <= 1);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (sink__oval) begin
        if (sink__ostrb.sof) begin
          col_idx       <= '0;
          col_idx.done  <= row_length_less_eq_1;
          //
          row_idx       <= '0;
        end
        else if (irow_mode) begin
          row_idx.value[cLOG2_DEC_NUM-1 : 0] <=  row_idx.dec_done ? '0 : (row_idx.value[cLOG2_DEC_NUM-1 : 0]+ 1'b1);
          row_idx.dec_done                   <= (row_idx.value[cLOG2_DEC_NUM-1 : 0] == (pDEC_NUM - 2));
          //
          if (row_idx.dec_done) begin
            col_idx.value <=  col_idx.done ? '0 : (col_idx.value + 1'b1);
            col_idx.done  <= (col_idx.value == row_length_m2) | row_length_less_eq_1;
            //
            if (col_idx.done) begin
              row_idx.value[cLOG2_ROW_MAX-1 : cLOG2_DEC_NUM] <= row_idx.value[cLOG2_ROW_MAX-1 : cLOG2_DEC_NUM] + 1'b1;
            end
          end
        end
        else begin
          row_idx.value     <=  row_idx.code_done ? '0 : (row_idx.value + 1'b1);
          row_idx.code_done <= (row_idx.value == col_code_length_m2);
          //
          if (row_idx.code_done) begin
            col_idx.value <=  col_idx.done ? '0 : col_idx.value + 1'b1;
            col_idx.done  <= (col_idx.value == row_length_m2) | row_length_less_eq_1;
          end
        end
      end
    end
  end

  assign owaddr[0                  +: cLOG2_USED_ROW_MAX] = col_idx.value;
  assign owaddr[cLOG2_USED_ROW_MAX +: cLOG2_COL_MAX]      = row_idx.value;

  //------------------------------------------------------------------------------------------------------
  // get col/row shortened and unused for error row bitmask
  //------------------------------------------------------------------------------------------------------

  logic [pDEC_NUM-1 : 0] tbiterr;
  logic [pDEC_NUM-1 : 0] tbiterr_mask;

  always_comb begin
    tbiterr_mask = '0;
    //
    for (int i = 0; i < pDEC_NUM; i++) begin
      if (row_idx.value > col_data_length_m1) begin // parity rows
        tbiterr_mask[i] = 1'b1;
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      biterr_val <= 1'b0;
    end
    else if (iclkena) begin
      biterr_val <= oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // align bitmask(row_idx, col_idx) generation
      tbiterr     <= sink__obiterr;
      //
      biterr      <= tbiterr;
      biterr_strb <= ostrb;
      biterr_mask <= tbiterr_mask;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // error counter
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obiterr_val <= 1'b0;
    end
    else if (iclkena) begin
      obiterr_val <= biterr_val & biterr_strb.eof;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (biterr_val) begin
        obiterr     <= biterr_strb.sof ? sum_vector(biterr & ~biterr_mask)  : (obiterr      + sum_vector(biterr & ~biterr_mask));
        obiterr_num <= biterr_strb.sof ? sum_vector(         ~biterr_mask)  : (obiterr_num  + sum_vector(         ~biterr_mask));
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decfail based upon Lextr gradient
  //------------------------------------------------------------------------------------------------------

  logic [pDEC_NUM-1 : 0] decfail_val;
  logic [pDEC_NUM-1 : 0] decfail;
  logic                  decfail_acc;
  logic                  decfail_post;

  always_comb begin
    for (int i = 0; i < pDEC_NUM; i++) begin
      decfail     [i] = code__odecfail     [i] & code__odecfail_val[i];
      decfail_val [i] = code__odecfail_val [i];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (istart_iter) begin
        decfail_acc <= 1'b0;
      end
      else if (irow_mode & (decfail_val != 0)) begin
        decfail_acc <= decfail_acc | (decfail != 0);
      end
      //
      if (istart) begin
        decfail_post <= 1'b1;
        odecfail     <= 1'b1;
      end
      else if (irow_mode & oval & ostrb.eof) begin
        decfail_post <= decfail_acc;
        odecfail     <= decfail_acc | decfail_post;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  function logic [pERR_W-1 : 0] sum_vector (input logic [pDEC_NUM-1 : 0] biterr);
  begin
    sum_vector = '0;
    for (int i = 0; i < pDEC_NUM; i++) begin
      sum_vector += biterr[i];
    end
  end
  endfunction

endmodule
