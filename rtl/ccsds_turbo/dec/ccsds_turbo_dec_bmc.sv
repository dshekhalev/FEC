/*



  parameter int pLLR_W   = 5 ;
  parameter int pLLR_FP  = 3 ;



  logic               ccsds_turbo_dec_bmc__iclk             ;
  logic               ccsds_turbo_dec_bmc__ireset           ;
  logic               ccsds_turbo_dec_bmc__iclkena          ;
  logic               ccsds_turbo_dec_bmc__ival             ;
  logic               ccsds_turbo_dec_bmc__ieven            ;
  logic               ccsds_turbo_dec_bmc__iterm            ;
  logic               ccsds_turbo_dec_bmc__iLextr_clr       ;
  bit_llr_t           ccsds_turbo_dec_bmc__isLLR    [0 : 1] ;
  bit_llr_t           ccsds_turbo_dec_bmc__iyLLR    [0 : 1] ;
  bit_llr_t           ccsds_turbo_dec_bmc__iwLLR    [0 : 1] ;
  Lextr_t             ccsds_turbo_dec_bmc__iLextr           ;
  logic               ccsds_turbo_dec_bmc__oval             ;
  gamma_t             ccsds_turbo_dec_bmc__ogamma           ;
  Lapri_t             ccsds_turbo_dec_bmc__oLapri           ;
  logic       [1 : 0] ccsds_turbo_dec_bmc__ohd              ;



  ccsds_turbo_dec_bmc
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pLLR_FP ( pLLR_FP )
  )
  ccsds_turbo_dec_bmc
  (
    .iclk       ( ccsds_turbo_dec_bmc__iclk       ) ,
    .ireset     ( ccsds_turbo_dec_bmc__ireset     ) ,
    .iclkena    ( ccsds_turbo_dec_bmc__iclkena    ) ,
    .ival       ( ccsds_turbo_dec_bmc__ival       ) ,
    .ieven      ( ccsds_turbo_dec_bmc__ieven      ) ,
    .iterm      ( ccsds_turbo_dec_bmc__iterm      ) ,
    .iLextr_clr ( ccsds_turbo_dec_bmc__iLextr_clr ) ,
    .isLLR      ( ccsds_turbo_dec_bmc__isLLR      ) ,
    .iyLLR      ( ccsds_turbo_dec_bmc__iyLLR      ) ,
    .iwLLR      ( ccsds_turbo_dec_bmc__iwLLR      ) ,
    .iLextr     ( ccsds_turbo_dec_bmc__iLextr     ) ,
    .oval       ( ccsds_turbo_dec_bmc__oval       ) ,
    .ogamma     ( ccsds_turbo_dec_bmc__ogamma     ) ,
    .oLapri     ( ccsds_turbo_dec_bmc__oLapri     ) ,
    .ohd        ( ccsds_turbo_dec_bmc__ohd        )
  );


  assign ccsds_turbo_dec_bmc__iclk       = '0 ;
  assign ccsds_turbo_dec_bmc__ireset     = '0 ;
  assign ccsds_turbo_dec_bmc__iclkena    = '0 ;
  assign ccsds_turbo_dec_bmc__ival       = '0 ;
  assign ccsds_turbo_dec_bmc__ieven      = '0 ;
  assign ccsds_turbo_dec_bmc__iterm      = '0 ;
  assign ccsds_turbo_dec_bmc__iLextr_clr = '0 ;
  assign ccsds_turbo_dec_bmc__isLLR      = '0 ;
  assign ccsds_turbo_dec_bmc__iyLLR      = '0 ;
  assign ccsds_turbo_dec_bmc__iwLLR      = '0 ;
  assign ccsds_turbo_dec_bmc__iLextr     = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_bmc.sv
// Description   : data/parity duobit LLR & branch metric LLR calculator with look ahead normalization
//

module ccsds_turbo_dec_bmc
#(
  parameter int pLLR_W   = 5 ,
  parameter int pLLR_FP  = 3
)
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  ival       ,
  ieven      ,
  iterm      ,
  iLextr_clr ,
  isLLR      ,
  ia0LLR     ,
  ia1LLR     ,
  iLextr     ,
  //
  oval       ,
  ogamma     ,
  oLapri     ,
  ohd
);

  `include "../ccsds_turbo_trellis.svh"

  `include "ccsds_turbo_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk           ;
  input  logic      ireset         ;
  input  logic      iclkena        ;
  //
  input  logic      ival           ;
  input  logic      ieven          ; // 1/0 - no permutate(even)/permutate (odd)
  input  logic      iterm          ; // 1/0 - terminate/no terminate trellis symbols
  input  logic      iLextr_clr     ; // clear extrinsic info (first half iteration)
  //
  input  bit_llr_t  isLLR          ; // systematic bit LLR
  input  bit_llr_t  ia0LLR     [3] ; // parity a0 bit LLR
  input  bit_llr_t  ia1LLR     [3] ; // parity a1 bit LLR
  input  extr_llr_t iLextr         ; // apriory extrinsic info
  //
  output logic      oval           ;
  output gamma_t    ogamma         ; // transition metric
  output Lapri_t    oLapri         ; // data apriory duobit LLR
  output logic      ohd            ; // systematic hard decision

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] val;

  pbit_allr_t   pLLR;

  Lapri_t       Lapri;

  logic         hd;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // get systematic duobits and prepare parity & Lext
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        // systematic bits & extrinsic (if no terminate)
        if (!ieven & iterm) begin
          Lapri <= '0;    // no metric, no extrinsic at permutated trellis
        end
        else if (iterm) begin
          Lapri <= isLLR; // only metric, no extrinsic
        end
        else begin
          Lapri <= iLextr_clr ? isLLR : (isLLR + iLextr);
        end

        // hard decicion
        hd    <= !isLLR[pLLR_W-1];

        // parity bits
        for (int i = 1; i < 8; i++) begin
          pLLR [i] <= ieven ? get_parity_bit_LLR(ia0LLR[2], ia0LLR[1], ia0LLR[0], i) : get_parity_bit_LLR(ia1LLR[2], 0, ia1LLR[0], i);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // get transition metric
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val[0]) begin
        ogamma  <= get_gamma(Lapri, pLLR);
        oLapri  <= Lapri;
        ohd     <= hd;
      end
    end
  end

  assign oval = val[1];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // function to get duobit LLR.
  //    b2/b1/b0 - LLR of bits
  //    t   - [0..7] parity type
  function automatic pbit_llr_t get_parity_bit_LLR (input bit_llr_t b2, b1, b0, input int t);
    case (t)
      3'b001  : return b0;
      3'b010  : return b1;
      3'b100  : return b2;
      //
      3'b011  : return b1 + b0;
      3'b101  : return b2 + b0;
      3'b110  : return b2 + b1;
      //
      3'b111  : return b2 + b1 + b0;
      //
      default : return 0;
    endcase
  endfunction

  //
  // function to get branch metric
  function automatic gamma_t get_gamma (input Lapri_t ind, input pbit_allr_t inp);
    int outb;
  begin
    for (int state = 0; state < cSTATE_NUM; state++) begin
      for (int inb = 0; inb < cBIT_NUM; inb++) begin
        outb = trel.outputs[state][inb];
        // systematic + parity bits
        if (inb == 0) begin
          get_gamma[state][inb] = (outb == 0) ? 0 : inp[outb];
        end
        else if (outb == 0) begin
          get_gamma[state][inb] = ind;
        end
        else begin
          get_gamma[state][inb] = ind + inp[outb];
        end
      end
    end
  end
  endfunction

endmodule
