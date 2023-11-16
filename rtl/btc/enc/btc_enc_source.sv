/*



  parameter int pWDAT_W  = 8 ;
  parameter int pWADDR_W = 8 ;



  logic                             btc_enc_source__iclk    ;
  logic                             btc_enc_source__ireset  ;
  logic                             btc_enc_source__iclkena ;
  //
  btc_code_mode_t                   btc_enc_source__ixmode  ;
  btc_code_mode_t                   btc_enc_source__iymode  ;
  btc_short_mode_t                  btc_enc_source__ismode  ;
  //
  logic                             btc_enc_source__ival    ;
  logic                             btc_enc_source__isop    ;
  logic                             btc_enc_source__ieop    ;
  logic                             btc_enc_source__idat    ;
  //
  logic                             btc_enc_source__ordy    ;
  logic                             btc_enc_source__obusy   ;
  //
  logic                             btc_enc_source__ifulla  ;
  logic                             btc_enc_source__iemptya ;
  //
  logic                             btc_enc_source__owrite  ;
  logic                             btc_enc_source__owfull  ;
  logic            [pWADDR_W-1 : 0] btc_enc_source__owaddr  ;
  logic             [pWDAT_W-1 : 0] btc_enc_source__owdat   ;



  btc_enc_source
  #(
    .pWDAT_W  ( pWDAT_W  ) ,
    .pWADDR_W ( pWADDR_W )
  )
  btc_enc_source
  (
    .iclk    ( btc_enc_source__iclk    ) ,
    .ireset  ( btc_enc_source__ireset  ) ,
    .iclkena ( btc_enc_source__iclkena ) ,
    //
    .ixmode  ( btc_enc_source__ixmode  ) ,
    .iymode  ( btc_enc_source__iymode  ) ,
    .ismode  ( btc_enc_source__ismode  ) ,
    //
    .ival    ( btc_enc_source__ival    ) ,
    .isop    ( btc_enc_source__isop    ) ,
    .ieop    ( btc_enc_source__ieop    ) ,
    .idat    ( btc_enc_source__idat    ) ,
    //
    .ordy    ( btc_enc_source__ordy    ) ,
    .obusy   ( btc_enc_source__obusy   ) ,
    //
    .ifulla  ( btc_enc_source__ifulla  ) ,
    .iemptya ( btc_enc_source__iemptya ) ,
    //
    .owrite  ( btc_enc_source__owrite  ) ,
    .owfull  ( btc_enc_source__owfull  ) ,
    .owaddr  ( btc_enc_source__owaddr  ) ,
    .owdat   ( btc_enc_source__owdat   )
  );


  assign btc_enc_source__iclk    = '0 ;
  assign btc_enc_source__ireset  = '0 ;
  assign btc_enc_source__iclkena = '0 ;
  assign btc_enc_source__ixmode  = '0 ;
  assign btc_enc_source__iymode  = '0 ;
  assign btc_enc_source__ismode  = '0 ;
  assign btc_enc_source__ival    = '0 ;
  assign btc_enc_source__isop    = '0 ;
  assign btc_enc_source__ieop    = '0 ;
  assign btc_enc_source__idat    = '0 ;
  assign btc_enc_source__ifulla  = '0 ;
  assign btc_enc_source__iemptya = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_enc_source.sv
// Description   : BTC encoder source unit with bitserial input
//

module btc_enc_source
#(
  parameter int pWDAT_W  = 8 ,
  parameter int pWADDR_W = 8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ixmode  ,
  iymode  ,
  ismode  ,
  //
  ival    ,
  isop    ,
  ieop    ,
  idat    ,
  //
  ordy    ,
  obusy   ,
  //
  ifulla  ,
  iemptya ,
  //
  owrite  ,
  owfull  ,
  owaddr  ,
  owdat
);

  `include "../btc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                             iclk    ;
  input  logic                             ireset  ;
  input  logic                             iclkena ;
  //
  input  btc_code_mode_t                   ixmode  ;
  input  btc_code_mode_t                   iymode  ;
  input  btc_short_mode_t                  ismode  ;
  //
  input  logic                             ival    ;
  input  logic                             isop    ;
  input  logic                             ieop    ;
  input  logic                             idat    ;
  //
  output logic                             ordy    ;
  output logic                             obusy   ;
  //
  input  logic                             ifulla  ;
  input  logic                             iemptya ;
  //
  output logic                             owrite  ;
  output logic                             owfull  ;
  output logic            [pWADDR_W-1 : 0] owaddr  ;
  output logic             [pWDAT_W-1 : 0] owdat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [cLOG2_COL_MAX-1 : 0] col_length_m2;

  struct packed {
    logic                       done;
    logic [cLOG2_COL_MAX-1 : 0] value;
  } row_idx;

  logic [cLOG2_ROW_MAX-1 : 0] row_length_m2;

  struct packed {
    logic                       done;
    logic [cLOG2_ROW_MAX-1 : 0] value;
  } col_idx;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
      owfull <= 1'b0;
    end
    else if (iclkena) begin
      owrite <= ival;
      owfull <= ival & ieop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        owdat <= idat;
        if (isop) begin
          col_idx <= '0;
          row_idx <= '0;
          //
          row_length_m2 <= get_data_bits(ixmode) - 2;
          col_length_m2 <= get_data_bits(iymode) - 2;
        end
        else begin
          col_idx.value <=  col_idx.done ? '0 : (col_idx.value + 1'b1);
          col_idx.done  <= (col_idx.value == row_length_m2);
          //
          if (col_idx.done) begin
            row_idx.value <=  row_idx.value + 1'b1;
            row_idx.done  <= (row_idx.value == col_length_m2);
          end
        end // isop
      end // ival
    end // iclkena
  end // iclk

  assign owaddr[0             +: cLOG2_ROW_MAX] = col_idx.value;
  assign owaddr[cLOG2_ROW_MAX +: cLOG2_COL_MAX] = row_idx.value;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (owrite) begin
        if (owfull) begin
          assert (row_idx.done & col_idx.done) else begin
            $error("%m ieop vs code mode error");
            $stop;
          end
        end
        if (row_idx.done & col_idx.done) begin
          assert (owfull) else begin
            $error("%m ieop vs code mode error");
            $stop;
          end
        end
      end // ival
    end // iclkena
  end // iclk
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ordy  = !owfull & !ifulla;   // not ready if all buffers is full
  assign obusy =  owfull | !iemptya;  // busy if any buffer is not empty

endmodule
