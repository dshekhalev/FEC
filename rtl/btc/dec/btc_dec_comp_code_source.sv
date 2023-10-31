/*



  parameter int pLLR_W   = 4 ;
  parameter int pEXTR_W  = 5 ;
  //
  parameter int pDEC_NUM = 8 ;
  parameter int pDEC_IDX = 0 ;



  logic   btc_dec_comp_code_source__iclk                 ;
  logic   btc_dec_comp_code_source__ireset               ;
  logic   btc_dec_comp_code_source__iclkena              ;
  //
  logic   btc_dec_comp_code_source__irow_mode            ;
  //
  logic   btc_dec_comp_code_source__ival                 ;
  strb_t  btc_dec_comp_code_source__istrb                ;
  llr_t   btc_dec_comp_code_source__iLLR      [pDEC_NUM] ;
  extr_t  btc_dec_comp_code_source__iLextr    [pDEC_NUM] ;
  alpha_t btc_dec_comp_code_source__ialpha               ;
  //
  logic   btc_dec_comp_code_source__oval                 ;
  strb_t  btc_dec_comp_code_source__ostrb                ;
  llr_t   btc_dec_comp_code_source__oLLR                 ;
  extr_t  btc_dec_comp_code_source__oLextr               ;
  alpha_t btc_dec_comp_code_source__oalpha               ;



  btc_dec_comp_code_source
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pEXTR_W  ( pEXTR_W  ) ,
    //
    .pDEC_NUM ( pDEC_NUM ) ,
    .pDEC_IDX ( pDEC_IDX )
  )
  btc_dec_comp_code_source
  (
    .iclk      ( btc_dec_comp_code_source__iclk      ) ,
    .ireset    ( btc_dec_comp_code_source__ireset    ) ,
    .iclkena   ( btc_dec_comp_code_source__iclkena   ) ,
    //
    .irow_mode ( btc_dec_comp_code_source__irow_mode ) ,
    //
    .ival      ( btc_dec_comp_code_source__ival      ) ,
    .istrb     ( btc_dec_comp_code_source__istrb     ) ,
    .iLLR      ( btc_dec_comp_code_source__iLLR      ) ,
    .iLextr    ( btc_dec_comp_code_source__iLextr    ) ,
    .ialpha    ( btc_dec_comp_code_source__ialpha    ) ,
    //
    .oval      ( btc_dec_comp_code_source__oval      ) ,
    .ostrb     ( btc_dec_comp_code_source__ostrb     ) ,
    .oLLR      ( btc_dec_comp_code_source__oLLR      ) ,
    .oLextr    ( btc_dec_comp_code_source__oLextr    ) ,
    .oalpha    ( btc_dec_comp_code_source__oalpha    )
  );


  assign btc_dec_comp_code_source__iclk      = '0 ;
  assign btc_dec_comp_code_source__ireset    = '0 ;
  assign btc_dec_comp_code_source__iclkena   = '0 ;
  assign btc_dec_comp_code_source__irow_mode = '0 ;
  assign btc_dec_comp_code_source__ival      = '0 ;
  assign btc_dec_comp_code_source__istrb     = '0 ;
  assign btc_dec_comp_code_source__iLLR      = '0 ;
  assign btc_dec_comp_code_source__iLextr    = '0 ;
  assing btc_dec_comp_code_source__ialpha    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code_source.sv
// Description   : component code source unit for row/col mode.
//                 col mode its simple register for single indexed metrics
//                 row mode its LLR/Lextr serializer from line
//

module btc_dec_comp_code_source
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  irow_mode ,
  //
  ival      ,
  istrb     ,
  iLLR      ,
  iLextr    ,
  ialpha    ,
  //
  oval      ,
  ostrb     ,
  oLLR      ,
  oLextr    ,
  oalpha
);

  parameter int pDEC_NUM = 8 ;
  parameter int pDEC_IDX = 0 ;

  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic   iclk                 ;
  input  logic   ireset               ;
  input  logic   iclkena              ;
  //
  input  logic   irow_mode            ;
  //
  input  logic   ival                 ;
  input  strb_t  istrb                ;
  input  llr_t   iLLR      [pDEC_NUM] ;
  input  extr_t  iLextr    [pDEC_NUM] ;
  input  alpha_t ialpha               ;
  //
  output logic   oval                 ;
  output strb_t  ostrb                ;
  output llr_t   oLLR                 ;
  output extr_t  oLextr               ;
  output alpha_t oalpha               ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DEC_NUM = $clog2(pDEC_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [cLOG2_DEC_NUM : 0] val_cnt;
  strb_t                    strb;

  llr_t                     LLR_line   [pDEC_NUM];
  extr_t                    Lextr_line [pDEC_NUM];

  //------------------------------------------------------------------------------------------------------
  // val generator
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val_cnt <= '0;
    end
    else if (iclkena) begin
      if (ival) begin
        if (irow_mode) begin
          val_cnt <= '0;
          val_cnt[cLOG2_DEC_NUM] <= 1'b1;
        end
        else begin
          val_cnt <= '1; // single pulse
        end
      end
      else begin
        val_cnt <= val_cnt + val_cnt[cLOG2_DEC_NUM];
      end
    end
  end

  assign oval = val_cnt[cLOG2_DEC_NUM];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        strb <= istrb;
      end
      //
      if (irow_mode) begin
        // regenerate strobes
        ostrb.sof   <= istrb.sof & ival;
        ostrb.sop   <= istrb.sop & ival;
        ostrb.eop   <=  strb.eop & (val_cnt[cLOG2_DEC_NUM-1 : 0] == (pDEC_NUM-2));
        ostrb.eof   <=  strb.eof & (val_cnt[cLOG2_DEC_NUM-1 : 0] == (pDEC_NUM-2));
        ostrb.mask  <=  strb.mask;
      end
      else begin
        ostrb   <= istrb;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // data shift registers : lsb first
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oalpha <= ialpha;
      if (irow_mode) begin
        if (ival) begin
          LLR_line   <= iLLR;
          Lextr_line <= iLextr;
        end
        else begin
          for (int i = 0; i < pDEC_NUM-1; i++) begin
            LLR_line  [i] <= LLR_line   [i+1];
            Lextr_line[i] <= Lextr_line [i+1];
          end
        end
      end
      else begin
        if (ival) begin
          LLR_line  [0] <= iLLR   [pDEC_IDX];
          Lextr_line[0] <= iLextr [pDEC_IDX];
        end
      end
    end
  end

  assign oLLR   = LLR_line  [0];
  assign oLextr = Lextr_line[0];

endmodule
