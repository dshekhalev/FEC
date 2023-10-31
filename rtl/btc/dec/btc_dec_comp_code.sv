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
  logic                            btc_dec_comp_code__irow_mode            ;
  alpha_t                          btc_dec_comp_code__ialpha               ;
  //
  logic           [pDEC_NUM-1 : 0] btc_dec_comp_code__ival                 ;
  strb_t                           btc_dec_comp_code__istrb                ;
  llr_t                            btc_dec_comp_code__iLLR      [pDEC_NUM] ;
  extr_t                           btc_dec_comp_code__iLextr    [pDEC_NUM] ;
  //
  logic                            btc_dec_comp_code__oval                 ;
  strb_t                           btc_dec_comp_code__ostrb     [pDEC_NUM] ;
  extr_t                           btc_dec_comp_code__oLextr    [pDEC_NUM] ;
  //
  logic            [pADDR_W-1 : 0] btc_dec_comp_code__owaddr               ;
  //
  logic           [pDEC_NUM-1 : 0] btc_dec_comp_code__obitdat              ;
  logic             [pERR_W-1 : 0] btc_dec_comp_code__obiterr              ;
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
    .iclk      ( btc_dec_comp_code__iclk      ) ,
    .ireset    ( btc_dec_comp_code__ireset    ) ,
    .iclkena   ( btc_dec_comp_code__iclkena   ) ,
    //
    .ixmode    ( btc_dec_comp_code__ixmode    ) ,
    .iymode    ( btc_dec_comp_code__iymode    ) ,
    //
    .istart    ( btc_dec_comp_code__istart    ) ,
    .irow_mode ( btc_dec_comp_code__irow_mode ) ,
    .ialpha    ( btc_dec_comp_code__ialpha    ) ,
    //
    .ival      ( btc_dec_comp_code__ival      ) ,
    .istrb     ( btc_dec_comp_code__istrb     ) ,
    .iLLR      ( btc_dec_comp_code__iLLR      ) ,
    .iLextr    ( btc_dec_comp_code__iLextr    ) ,
    //
    .oval      ( btc_dec_comp_code__oval      ) ,
    .ostrb     ( btc_dec_comp_code__ostrb     ) ,
    .oLextr    ( btc_dec_comp_code__oLextr    ) ,
    //
    .owaddr    ( btc_dec_comp_code__owaddr    ) ,
    //
    .obitdat   ( btc_dec_comp_code__obitdat   ) ,
    .obiterr   ( btc_dec_comp_code__obiterr   ) ,
    //
    .odecfail  ( btc_dec_comp_code__odecfail  )
  );


  assign btc_dec_comp_code__iclk      = '0 ;
  assign btc_dec_comp_code__ireset    = '0 ;
  assign btc_dec_comp_code__iclkena   = '0 ;
  assign btc_dec_comp_code__ixmode    = '0 ;
  assign btc_dec_comp_code__iymode    = '0 ;
  assign btc_dec_comp_code__istart    = '0 ;
  assign btc_dec_comp_code__irow_mode = '0 ;
  assign btc_dec_comp_code__ialpha    = '0 ;
  assign btc_dec_comp_code__ival      = '0 ;
  assign btc_dec_comp_code__istrb     = '0 ;
  assign btc_dec_comp_code__iLLR      = '0 ;
  assign btc_dec_comp_code__iLextr    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code.sv
// Description   : component code top level for row/col soft decoding
//

module btc_dec_comp_code
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  ixmode    ,
  iymode    ,
  //
  istart    ,
  irow_mode ,
  ialpha    ,
  //
  ival      ,
  istrb     ,
  iLLR      ,
  iLextr    ,
  //
  oval      ,
  ostrb     ,
  oLextr    ,
  //
  owaddr    ,
  //
  obitdat   ,
  obiterr   ,
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
  input  logic                            istart               ;  // iteration start
  input  logic                            irow_mode            ;  // row/col mode
  input  alpha_t                          ialpha               ;  // iteration row/col scale factor
  //
  input  logic           [pDEC_NUM-1 : 0] ival                 ;
  input  strb_t                           istrb                ;
  input  llr_t                            iLLR      [pDEC_NUM] ;
  input  extr_t                           iLextr    [pDEC_NUM] ;
  //
  output logic                            oval                 ;
  output strb_t                           ostrb                ;
  output extr_t                           oLextr    [pDEC_NUM] ;
  //
  output logic            [pADDR_W-1 : 0] owaddr               ;
  //
  output logic           [pDEC_NUM-1 : 0] obitdat              ;
  output logic             [pERR_W-1 : 0] obiterr              ;
  //
  output logic                            odecfail             ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DEC_NUM      = $clog2(pDEC_NUM);
  localparam int cLOG2_USED_COL_MAX = cLOG2_COL_MAX - cLOG2_DEC_NUM; // rows store in pDEC_NUM memory

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                   source__oval    [pDEC_NUM] ;
  strb_t                  source__ostrb   [pDEC_NUM] ;
  llr_t                   source__oLLR    [pDEC_NUM] ;
  extr_t                  source__oLextr  [pDEC_NUM] ;
  alpha_t                 source__oalpha  [pDEC_NUM] ;

  //
  // component code decoders
  logic                   code__istart    [pDEC_NUM];
  btc_code_mode_t         code__imode     [pDEC_NUM];
  //
  logic                   code__ival      [pDEC_NUM];
  strb_t                  code__istrb     [pDEC_NUM];
  llr_t                   code__iLLR      [pDEC_NUM];
  extr_t                  code__iLextr    [pDEC_NUM];
  alpha_t                 code__ialpha    [pDEC_NUM];

  logic                   code__oval      [pDEC_NUM];
  strb_t                  code__ostrb     [pDEC_NUM];
  extr_t                  code__oLextr    [pDEC_NUM];
  //
  logic                   code__obitdat   [pDEC_NUM];
  logic                   code__obiterr   [pDEC_NUM];
  //
  logic                   code__odecfail  [pDEC_NUM];

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
  //
  logic    [pERR_W-1 : 0] sink__obiterr              ;

  //
  // address generation unit
  logic [cLOG2_ROW_MAX-1 : 0] col_data_length_m2;
  logic [cLOG2_ROW_MAX-1 : 0] col_code_length_m2;

  struct packed {
    logic                       dec_done;
    logic                       code_done;
    logic [cLOG2_ROW_MAX-1 : 0] value;
  } row_idx;

  logic   [cLOG2_USED_COL_MAX : 0] row_length; // + 1 bit for 2^maximum(N);
  logic [cLOG2_USED_COL_MAX-1 : 0] row_length_m2;
  logic                            row_length_less_eq_1;

  struct packed {
    logic                            done;
    logic [cLOG2_USED_COL_MAX-1 : 0] value;
  } col_idx;

  //------------------------------------------------------------------------------------------------------
  // cc source
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < pDEC_NUM; g++) begin : source_inst_gen
      btc_dec_comp_code_source
      #(
        .pLLR_W   ( pLLR_W   ) ,
        .pEXTR_W  ( pEXTR_W  ) ,
        //
        .pDEC_NUM ( pDEC_NUM ) ,
        .pDEC_IDX ( g        )
      )
      source
      (
        .iclk      ( iclk               ) ,
        .ireset    ( ireset             ) ,
        .iclkena   ( iclkena            ) ,
        //
        .irow_mode ( irow_mode          ) ,
        //
        .ival      ( ival           [g] ) ,
        .istrb     ( istrb              ) ,
        .iLLR      ( iLLR               ) ,
        .iLextr    ( iLextr             ) ,
        .ialpha    ( ialpha             ) ,
        //
        .oval      ( source__oval   [g] ) ,
        .ostrb     ( source__ostrb  [g] ) ,
        .oLLR      ( source__oLLR   [g] ) ,
        .oLextr    ( source__oLextr [g] ) ,
        .oalpha    ( source__oalpha [g] )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // cc engines
  //------------------------------------------------------------------------------------------------------

  generate
    for (g = 0; g < pDEC_NUM; g++) begin : comp_code_inst_gen
      btc_dec_comp_code_engine
      #(
        .pLLR_W  ( pLLR_W  ) ,
        .pEXTR_W ( pEXTR_W )
      )
      code
      (
        .iclk      ( iclk                ) ,
        .ireset    ( ireset              ) ,
        .iclkena   ( iclkena             ) ,
        //
        .istart    ( code__istart    [g] ) ,
        .imode     ( code__imode     [g] ) ,
        .ialpha    ( code__ialpha    [g] ) ,
        //
        .ival      ( code__ival      [g] ) ,
        .istrb     ( code__istrb     [g] ) ,
        .iLLR      ( code__iLLR      [g] ) ,
        .iLextr    ( code__iLextr    [g] ) ,
        //
        .oval      ( code__oval      [g] ) ,
        .ostrb     ( code__ostrb     [g] ) ,
        .oLextr    ( code__oLextr    [g] ) ,
        .obitdat   ( code__obitdat   [g] ) ,
        .obiterr   ( code__obiterr   [g] ) ,
        //
        .odecfail  ( code__odecfail  [g] )
      );

      assign code__istart [g] = istart ;

      assign code__ival   [g] = source__oval   [g] ;
      assign code__istrb  [g] = source__ostrb  [g] ;
      assign code__iLLR   [g] = source__oLLR   [g] ;
      assign code__iLextr [g] = source__oLextr [g] ;

      assign code__ialpha [g] = source__oalpha [g] ;

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

  // there is +1 register inside sink_unit (2 tick bit error counting)
  assign obiterr = sink__obiterr;

  //------------------------------------------------------------------------------------------------------
  // address generation units (row/col)
  //------------------------------------------------------------------------------------------------------

  assign row_length = (get_code_bits(ixmode) >> cLOG2_DEC_NUM);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // have enougth time for reclock
      col_data_length_m2   <= get_data_bits(iymode) - 2;
      col_code_length_m2   <= get_code_bits(iymode) - 2;
      row_length_m2        <=  row_length - 2;
      row_length_less_eq_1 <= (row_length <= 1);
      //
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

  assign owaddr[0                  +: cLOG2_USED_COL_MAX] = col_idx.value;
  assign owaddr[cLOG2_USED_COL_MAX +: cLOG2_ROW_MAX]      = row_idx.value;

  //------------------------------------------------------------------------------------------------------
  // decfail accumulate unit
  //------------------------------------------------------------------------------------------------------

  logic                  col_decfail_val;
  logic [pDEC_NUM-1 : 0] row_decfail_val;

  logic [pDEC_NUM-1 : 0] decfail;

  always_comb begin
    // parralel
    col_decfail_val = code__oval[0] & code__ostrb[0].eop;
    // quazi parallel
    for (int i = 0; i < pDEC_NUM; i++) begin
      row_decfail_val[i] = code__oval [i] & code__ostrb[i].eop;
    end
    // decfail common for both
    for (int i = 0; i < pDEC_NUM; i++) begin
      decfail [i] = code__odecfail [i] & code__oval [i] & code__ostrb[i].eop & !code__ostrb[i].mask;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (istart) begin
        odecfail <= 1'b0;
      end
      else begin
        if (irow_mode) begin
          if (row_decfail_val != 0) begin
            odecfail <= odecfail | (|decfail);
          end
        end
        else begin
          if (col_decfail_val) begin
            odecfail <= odecfail | (|decfail);
          end
        end
      end
    end
  end

endmodule
