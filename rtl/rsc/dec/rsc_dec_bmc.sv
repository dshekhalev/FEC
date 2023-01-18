/*



  parameter int pLLR_W   = 5 ;



  logic               rsc_dec_bmc__iclk             ;
  logic               rsc_dec_bmc__ireset           ;
  logic               rsc_dec_bmc__iclkena          ;
  logic               rsc_dec_bmc__ival             ;
  logic               rsc_dec_bmc__ieven            ;
  logic               rsc_dec_bmc__ibitswap         ;
  logic               rsc_dec_bmc__iLextr_clr       ;
  bit_llr_t           rsc_dec_bmc__isLLR    [0 : 1] ;
  bit_llr_t           rsc_dec_bmc__iyLLR    [0 : 1] ;
  bit_llr_t           rsc_dec_bmc__iwLLR    [0 : 1] ;
  Lextr_t             rsc_dec_bmc__iLextr           ;
  logic               rsc_dec_bmc__oval             ;
  gamma_t             rsc_dec_bmc__ogamma           ;
  Lapri_t             rsc_dec_bmc__oLapri           ;
  logic       [1 : 0] rsc_dec_bmc__ohd              ;



  rsc_dec_bmc
  #(
    .pLLR_W  ( pLLR_W  )
  )
  rsc_dec_bmc
  (
    .iclk       ( rsc_dec_bmc__iclk       ) ,
    .ireset     ( rsc_dec_bmc__ireset     ) ,
    .iclkena    ( rsc_dec_bmc__iclkena    ) ,
    .ival       ( rsc_dec_bmc__ival       ) ,
    .ieven      ( rsc_dec_bmc__ieven      ) ,
    .ibitswap   ( rsc_dec_bmc__ibitswap   ) ,
    .iLextr_clr ( rsc_dec_bmc__iLextr_clr ) ,
    .isLLR      ( rsc_dec_bmc__isLLR      ) ,
    .iyLLR      ( rsc_dec_bmc__iyLLR      ) ,
    .iwLLR      ( rsc_dec_bmc__iwLLR      ) ,
    .iLextr     ( rsc_dec_bmc__iLextr     ) ,
    .oval       ( rsc_dec_bmc__oval       ) ,
    .ogamma     ( rsc_dec_bmc__ogamma     ) ,
    .oLapri     ( rsc_dec_bmc__oLapri     ) ,
    .ohd        ( rsc_dec_bmc__ohd        )
  );


  assign rsc_dec_bmc__iclk       = '0 ;
  assign rsc_dec_bmc__ireset     = '0 ;
  assign rsc_dec_bmc__iclkena    = '0 ;
  assign rsc_dec_bmc__ival       = '0 ;
  assign rsc_dec_bmc__ieven      = '0 ;
  assign rsc_dec_bmc__ibitswap   = '0 ;
  assign rsc_dec_bmc__iLextr_clr = '0 ;
  assign rsc_dec_bmc__isLLR      = '0 ;
  assign rsc_dec_bmc__iyLLR      = '0 ;
  assign rsc_dec_bmc__iwLLR      = '0 ;
  assign rsc_dec_bmc__iLextr     = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_bmc.sv
// Description   : data/parity duobit LLR & branch metric LLR calculator
//

module rsc_dec_bmc
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
  ibitswap   ,
  iLextr_clr ,
  isLLR      ,
  iyLLR      ,
  iwLLR      ,
  iLextr     ,
  //
  oval       ,
  ogamma     ,
  oLapri     ,
  ohd
);

  `include "rsc_dec_types.svh"
  `include "rsc_trellis.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic             iclk             ;
  input  logic             ireset           ;
  input  logic             iclkena          ;
  //
  input  logic             ival             ;
  input  logic             ieven            ; // 1/0 - no permutate(even)/permutate (odd)
  input  logic             ibitswap         ; // swap systematic duobit pair for permutation
  input  logic             iLextr_clr       ; // clear extrinsic info (first half iteration)
  //
  input  bit_llr_t         isLLR    [0 : 1] ; // systematic bit LLR
  input  bit_llr_t         iyLLR    [0 : 1] ; // parity y-bit LLR
  input  bit_llr_t         iwLLR    [0 : 1] ; // parity w-bit LLR
  input  Lextr_t           iLextr           ; // apriory extrinsic info
  //
  output logic             oval             ;
  output gamma_t           ogamma           ; // transition metric
  output Lapri_t           oLapri           ; // data apriory duobit LLR
  output logic     [1 : 0] ohd              ; // systematic hard decision

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [2 : 0] val;

  dbit_allr_t   dLLR;
  dbit_allr_t   pLLR;

  Lextr_t       Lextr;

  Lapri_t       Lapri;

  logic [1 : 0] hd;

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

  wire bitswap = !ieven & ibitswap;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        // systematic bits & extrinsic
        if (iLextr_clr) begin
          Lextr[1] <= '0;
          Lextr[2] <= '0;
          Lextr[3] <= '0;
        end
        else begin
          Lextr[1] <= bitswap ? iLextr[2] : iLextr[1];
          Lextr[2] <= bitswap ? iLextr[1] : iLextr[2];
          Lextr[3] <=                       iLextr[3];
        end

        dLLR[1] <= bitswap ? get_duobit_LLR(isLLR[1], isLLR[0], 2) : get_duobit_LLR(isLLR[1], isLLR[0], 1);
        dLLR[2] <= bitswap ? get_duobit_LLR(isLLR[1], isLLR[0], 1) : get_duobit_LLR(isLLR[1], isLLR[0], 2);
        dLLR[3] <=                                                   get_duobit_LLR(isLLR[1], isLLR[0], 3);
        // hard decicion
        hd      <= ~{isLLR[1][pLLR_W-1], isLLR[0][pLLR_W-1]};

        // parity bits
        pLLR [1] <= ieven ? get_duobit_LLR(iyLLR[1], iwLLR[1], 1) : get_duobit_LLR(iyLLR[0], iwLLR[0], 1);
        pLLR [2] <= ieven ? get_duobit_LLR(iyLLR[1], iwLLR[1], 2) : get_duobit_LLR(iyLLR[0], iwLLR[0], 2);
        pLLR [3] <= ieven ? get_duobit_LLR(iyLLR[1], iwLLR[1], 3) : get_duobit_LLR(iyLLR[0], iwLLR[0], 3);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // get transition metric
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int i = 1; i < 4; i++) begin
      Lapri [i] = dLLR[i] + Lextr[i];
    end
  end

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
  //    b1/b0 - LLR of bits
  //    t   - 2'b01/2'b10/2'b11 duobit type
  function automatic dbit_llr_t get_duobit_LLR (input bit_llr_t b1, b0, input int t);
    case (t)
      2'b01   : return b0;
      2'b10   : return b1;
      2'b11   : return b1 + b0;
      default : return 0;
    endcase
  endfunction

  //
  // function to get branch metric
  function automatic gamma_t get_gamma (input Lapri_t ind, input dbit_allr_t inp);
    int outb;
  begin
    for (int state = 0; state < 8; state++) begin
      for (int inb = 0; inb < 4; inb++) begin
        outb = trel.outputs[state][inb];
        // systematic + parity bits
        if (inb == 0) begin
          get_gamma[state][inb] = (outb == 0) ? 0 : inp[outb];
        end
        else if (outb == 0) begin
          get_gamma[state][inb] = ind[inb];
        end
        else begin
          get_gamma[state][inb] = ind[inb] + inp[outb];
        end
      end
    end
  end
  endfunction

endmodule
