/*



  parameter int pLLR_W  =  8 ;
  parameter int pLLR_FP =  8 ;
  parameter int pADDR_W =  8 ;



  logic                     ccsds_turbo_dec_source__iclk         ;
  logic                     ccsds_turbo_dec_source__ireset       ;
  logic                     ccsds_turbo_dec_source__iclkena      ;
  logic             [1 : 0] ccsds_turbo_dec_source__icode        ;
  logic             [1 : 0] ccsds_turbo_dec_source__inidx        ;
  logic                     ccsds_turbo_dec_source__isop         ;
  logic                     ccsds_turbo_dec_source__ieop         ;
  logic                     ccsds_turbo_dec_source__ival         ;
  bit_llr_t                 ccsds_turbo_dec_source__iLLR         ;
  logic                     ccsds_turbo_dec_source__ifulla       ;
  logic                     ccsds_turbo_dec_source__iemptya      ;
  logic                     ccsds_turbo_dec_source__obusy        ;
  logic                     ccsds_turbo_dec_source__ordy         ;
  logic                     ccsds_turbo_dec_source__owrite       ;
  logic                     ccsds_turbo_dec_source__owfull       ;
  logic     [pADDR_W-1 : 0] ccsds_turbo_dec_source__owaddr       ;
  bit_llr_t                 ccsds_turbo_dec_source__osLLR        ;
  bit_llr_t                 ccsds_turbo_dec_source__oa0LLR   [3] ;
  bit_llr_t                 ccsds_turbo_dec_source__oa1LLR   [3] ;



  ccsds_turbo_dec_source
  #(
    .pLLR_W  ( pLLR_W   ) ,
    .pLLR_FP ( pLLR_FP  ) ,
    .pADDR_W ( pADDR_W  )
  )
  ccsds_turbo_dec_source
  (
    .iclk    ( ccsds_turbo_dec_source__iclk    ) ,
    .ireset  ( ccsds_turbo_dec_source__ireset  ) ,
    .iclkena ( ccsds_turbo_dec_source__iclkena ) ,
    .icode   ( ccsds_turbo_dec_source__icode   ) ,
    .inidx   ( ccsds_turbo_dec_source__inidx   ) ,
    .isop    ( ccsds_turbo_dec_source__isop    ) ,
    .ieop    ( ccsds_turbo_dec_source__ieop    ) ,
    .ival    ( ccsds_turbo_dec_source__ival    ) ,
    .iLLR    ( ccsds_turbo_dec_source__iLLR    ) ,
    .ifulla  ( ccsds_turbo_dec_source__ifulla  ) ,
    .iemptya ( ccsds_turbo_dec_source__iemptya ) ,
    .obusy   ( ccsds_turbo_dec_source__obusy   ) ,
    .ordy    ( ccsds_turbo_dec_source__ordy    ) ,
    .owrite  ( ccsds_turbo_dec_source__owrite  ) ,
    .owfull  ( ccsds_turbo_dec_source__owfull  ) ,
    .owaddr  ( ccsds_turbo_dec_source__owaddr  ) ,
    .osLLR   ( ccsds_turbo_dec_source__osLLR   ) ,
    .oa0LLR  ( ccsds_turbo_dec_source__oa0LLR  ) ,
    .oa1LLR  ( ccsds_turbo_dec_source__oa1LLR  )
  );


  assign ccsds_turbo_dec_source__iclk    = '0 ;
  assign ccsds_turbo_dec_source__ireset  = '0 ;
  assign ccsds_turbo_dec_source__iclkena = '0 ;
  assign ccsds_turbo_dec_source__icode   = '0 ;
  assign ccsds_turbo_dec_source__inidx   = '0 ;
  assign ccsds_turbo_dec_source__isop    = '0 ;
  assign ccsds_turbo_dec_source__ieop    = '0 ;
  assign ccsds_turbo_dec_source__ival    = '0 ;
  assign ccsds_turbo_dec_source__iLLR    = '0 ;
  assign ccsds_turbo_dec_source__ifulla  = '0 ;
  assign ccsds_turbo_dec_source__iemptya = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_source.sv
// Description   : Input interface of decoder. Prepare S/Y/W duobits using puncture pattern in input ram buffer
//


module ccsds_turbo_dec_source
#(
  parameter int pLLR_W  =  5 ,
  parameter int pLLR_FP =  2 ,
  parameter int pADDR_W =  8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  inidx   ,
  //
  isop    ,
  ieop    ,
  ival    ,
  iLLR    ,
  //
  ifulla  ,
  iemptya ,
  obusy   ,
  ordy    ,
  //
  owrite  ,
  owfull  ,
  owaddr  ,
  osLLR   ,
  oa0LLR  ,
  oa1LLR
);

  `include "../ccsds_turbo_parameters.svh"
  `include "ccsds_turbo_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                     iclk         ;
  input  logic                     ireset       ;
  input  logic                     iclkena      ;
  //
  input  logic             [1 : 0] icode        ;
  input  logic             [1 : 0] inidx        ;
  //
  input  logic                     isop         ;
  input  logic                     ieop         ;
  input  logic                     ival         ;
  input  bit_llr_t                 iLLR         ;
  //
  input  logic                     ifulla       ;
  input  logic                     iemptya      ;
  output logic                     obusy        ;
  output logic                     ordy         ;
  //
  output logic                     owrite       ;
  output logic                     owfull       ;
  output logic     [pADDR_W-1 : 0] owaddr       ;
  output bit_llr_t                 osLLR        ;
  output bit_llr_t                 oa0LLR   [3] ;
  output bit_llr_t                 oa1LLR   [3] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] code;

  struct packed {
    logic         done;
    logic [2 : 0] val;
  } code_cnt;

  logic sop;
  logic val;
  logic eop;

  logic sel;

  bit_llr_t LLR [6];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ordy  = !owfull & !ifulla;   // not ready if all buffers is full
  assign obusy =  owfull | !iemptya;  // busy if any buffer is not empty

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      sop    <= 1'b0;
      val    <= 1'b0;
      eop    <= 1'b0;
      //
      owrite <= 1'b0;
      owfull <= 1'b0;
    end
    else if (iclkena) begin
      val    <= ival & !isop & code_cnt.done;
      eop    <= ival & ieop;
      //
      if (ival & isop) begin
        sop <= 1'b1;
      end
      else if (val) begin
        sop <= 1'b0;
      end
      //
      owrite <= val;
      owfull <= eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (isop) begin
          code          <= icode;
          code_cnt.val  <= 1'b1;
          code_cnt.done <= (get_code_cnt_max(icode) == 0);
        end
        else begin
          code_cnt.val  <=  code_cnt.done ? '0 : (code_cnt.val + 1'b1);
          code_cnt.done <= (code_cnt.val == get_code_cnt_max(code));
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        for (int i = 0; i < $size(LLR); i++) begin
          LLR[i] <= (i == 0) ? iLLR : LLR[i-1];
        end
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val) begin
        owaddr <= sop ? '0   : (owaddr + 1'b1);
        sel    <= sop ? 1'b0 : !sel;
        case (code)
          cCODE_1by2 : begin
            osLLR <= LLR[1];
            if (sop | sel) begin
              oa0LLR[0] <= LLR[0];
              oa1LLR[0] <= '0;
            end
            else begin
              oa0LLR[0] <= '0;
              oa1LLR[0] <= LLR[0];
            end
            oa0LLR[1] <= '0;
            oa0LLR[2] <= '0;
            //
            oa1LLR[2] <= '0;
          end
          cCODE_1by3 : begin
            osLLR     <= LLR[2];
            oa0LLR[0] <= LLR[1];
            oa0LLR[1] <= '0;
            oa0LLR[2] <= '0;
            //
            oa1LLR[0] <= LLR[0];
            oa1LLR[2] <= '0;
          end
          //
          cCODE_1by4 : begin
            osLLR     <= LLR[3];
            oa0LLR[0] <= '0;
            oa0LLR[1] <= LLR[2];
            oa0LLR[2] <= LLR[1];
            //
            oa1LLR[0] <= LLR[0];
            oa1LLR[2] <= '0;
          end
          //
          cCODE_1by6 : begin
            osLLR     <= LLR[5];
            oa0LLR[0] <= LLR[4];
            oa0LLR[1] <= LLR[3];
            oa0LLR[2] <= LLR[2];
            //
            oa1LLR[0] <= LLR[1];
            oa1LLR[2] <= LLR[0];
          end
        endcase
      end
    end
  end

  assign oa1LLR[1] = '0;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function int get_code_cnt_max (input bit [1 : 0] code);
    get_code_cnt_max = 0; // 2-2
    case (code)
       cCODE_1by2 : get_code_cnt_max = 0; // 2-2
       cCODE_1by3 : get_code_cnt_max = 1; // 3-2
       cCODE_1by4 : get_code_cnt_max = 2; // 4-2
       cCODE_1by6 : get_code_cnt_max = 4; // 6-2
    endcase
  endfunction

endmodule
