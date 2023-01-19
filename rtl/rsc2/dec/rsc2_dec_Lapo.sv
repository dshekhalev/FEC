/*



  parameter bit pB_nF      = 0 ;
  parameter int pLLR_W     = 5 ;
  parameter int pLLR_FP    = 3 ;
  parameter int pMMAX_TYPE = 0;



  logic   rsc2_dec_Lapo__iclk     ;
  logic   rsc2_dec_Lapo__ireset   ;
  logic   rsc2_dec_Lapo__iclkena  ;
  logic   rsc2_dec_Lapo__ival     ;
  gamma_t rsc2_dec_Lapo__igamma   ;
  state_t rsc2_dec_Lapo__istate   ;
  logic   rsc2_dec_Lapo__oval     ;
  Lapo_t  rsc2_dec_Lapo__oLapo    ;



  rsc2_dec_Lapo
  #(
    .pB_nF      ( pB_nF      ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  rsc2_dec_Lapo
  (
    .iclk    ( rsc2_dec_Lapo__iclk    ) ,
    .ireset  ( rsc2_dec_Lapo__ireset  ) ,
    .iclkena ( rsc2_dec_Lapo__iclkena ) ,
    .ival    ( rsc2_dec_Lapo__ival    ) ,
    .igamma  ( rsc2_dec_Lapo__igamma  ) ,
    .istate  ( rsc2_dec_Lapo__istate  ) ,
    .oval    ( rsc2_dec_Lapo__oval    ) ,
    .oLapo   ( rsc2_dec_Lapo__oLapo   )
  );


  assign rsc2_dec_Lapo__iclk    = '0 ;
  assign rsc2_dec_Lapo__ireset  = '0 ;
  assign rsc2_dec_Lapo__iclkena = '0 ;
  assign rsc2_dec_Lapo__ival    = '0 ;
  assign rsc2_dec_Lapo__igamma  = '0 ;
  assign rsc2_dec_Lapo__istate  = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_dec_Lextr.sv
// Description   : module to count aposteriory LLR : sum(bm(s, s')) = sum(alpha(s, k) * gamma_e(s, s') * beta(s',k+1))
//                 Module latency us 5 tick.
//

module rsc2_dec_Lapo
#(
  parameter bit pB_nF       = 0 ,
  parameter int pLLR_W      = 5 ,
  parameter int pLLR_FP     = 3 ,
  parameter int pMMAX_TYPE  = 0
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  igamma  ,
  istate  ,
  //
  oval    ,
  oLapo
);

  `include "rsc2_dec_types.svh"
  `include "rsc2_trellis.svh"
  `include "rsc2_mmax.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk    ;
  input  logic    ireset  ;
  input  logic    iclkena ;
  //
  input  logic    ival    ;
  input  gamma_t  igamma  ;  // pB_nF ? (gamma_e + beta  [k+1]) : (gamma_e + alpha [k])
  input  state_t  istate  ;  // pB_nF ?            alpha [k]                 beta  [k+1])
  //
  output logic    oval    ;
  output Lapo_t   oLapo   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [5 : 0] val;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset)
      val <= '0;
    else if (iclkena)
      val <= (val << 1) | ival;
  end

  //------------------------------------------------------------------------------------------------------
  // bm(s, s') = alpha(s, k) * gamma_e(s, s') * beta(s',k+1)
  //------------------------------------------------------------------------------------------------------

  bm_t bm ;

  generate
    if (pB_nF) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (ival) begin
            for (int state = 0; state < 16; state++) begin
              for (int inb = 0; inb < 4; inb++) begin
                bm[state][inb] <= igamma[state][inb] + istate[state];
              end // inb
            end // state
          end // ival
        end // iclkena
      end // iclk
    end
    else begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (ival) begin
            for (int state = 0; state < 16; state++) begin
              for (int inb = 0; inb < 4; inb++) begin
                bm[state][inb] <= igamma[state][inb] + istate[trel.nextStates[state][inb]];
              end // inb
            end // state
          end // ival
        end // iclkena
      end // iclk
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // sum(bm(s, duobit_data))
  //------------------------------------------------------------------------------------------------------

  trel_branch_t tmp01       [4];
  trel_branch_t tmp23       [4];
  trel_branch_t tmp45       [4];
  trel_branch_t tmp67       [4];
  trel_branch_t tmp89       [4];
  trel_branch_t tmpAB       [4];
  trel_branch_t tmpCD       [4];
  trel_branch_t tmpEF       [4];

  trel_branch_t tmp0123     [4];
  trel_branch_t tmp4567     [4];
  trel_branch_t tmp89AB     [4];
  trel_branch_t tmpCDEF     [4];

  trel_branch_t tmp01234567 [4];
  trel_branch_t tmp89ABCDEF [4];

  trel_branch_t tmpLLR      [4];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int inb = 0; inb < 4; inb++) begin
        if (pMMAX_TYPE == 1) begin
          // layer 1
          if (val[0]) begin
            tmp01[inb] <= bm_mmax1(bm[0][inb],  bm[1][inb]);
            tmp23[inb] <= bm_mmax1(bm[2][inb],  bm[3][inb]);
            tmp45[inb] <= bm_mmax1(bm[4][inb],  bm[5][inb]);
            tmp67[inb] <= bm_mmax1(bm[6][inb],  bm[7][inb]);
            tmp89[inb] <= bm_mmax1(bm[8][inb],  bm[9][inb]);
            tmpAB[inb] <= bm_mmax1(bm[10][inb], bm[11][inb]);
            tmpCD[inb] <= bm_mmax1(bm[12][inb], bm[13][inb]);
            tmpEF[inb] <= bm_mmax1(bm[14][inb], bm[15][inb]);
          end
          // layer 2
          if (val[1]) begin
            tmp0123[inb] <= bm_mmax1(tmp01[inb], tmp23[inb]);
            tmp4567[inb] <= bm_mmax1(tmp45[inb], tmp67[inb]);
            tmp89AB[inb] <= bm_mmax1(tmp89[inb], tmpAB[inb]);
            tmpCDEF[inb] <= bm_mmax1(tmpCD[inb], tmpEF[inb]);
          end
          // layer 3
          if (val[2]) begin
            tmp01234567[inb] <= bm_mmax1(tmp0123[inb], tmp4567[inb]);
            tmp89ABCDEF[inb] <= bm_mmax1(tmp89AB[inb], tmpCDEF[inb]);
          end
          // layer 4
          if (val[3]) begin
            tmpLLR[inb] <= bm_mmax1(tmp01234567[inb], tmp89ABCDEF[inb]);
          end
        end
        else begin
          // layer 1
          if (val[0]) begin
            tmp01[inb] <= bm_mmax(bm[0][inb],  bm[1][inb]);
            tmp23[inb] <= bm_mmax(bm[2][inb],  bm[3][inb]);
            tmp45[inb] <= bm_mmax(bm[4][inb],  bm[5][inb]);
            tmp67[inb] <= bm_mmax(bm[6][inb],  bm[7][inb]);
            tmp89[inb] <= bm_mmax(bm[8][inb],  bm[9][inb]);
            tmpAB[inb] <= bm_mmax(bm[10][inb], bm[11][inb]);
            tmpCD[inb] <= bm_mmax(bm[12][inb], bm[13][inb]);
            tmpEF[inb] <= bm_mmax(bm[14][inb], bm[15][inb]);
          end
          // layer 2
          if (val[1]) begin
            tmp0123[inb] <= bm_mmax(tmp01[inb], tmp23[inb]);
            tmp4567[inb] <= bm_mmax(tmp45[inb], tmp67[inb]);
            tmp89AB[inb] <= bm_mmax(tmp89[inb], tmpAB[inb]);
            tmpCDEF[inb] <= bm_mmax(tmpCD[inb], tmpEF[inb]);
          end
          // layer 3
          if (val[2]) begin
            tmp01234567[inb] <= bm_mmax(tmp0123[inb], tmp4567[inb]);
            tmp89ABCDEF[inb] <= bm_mmax(tmp89AB[inb], tmpCDEF[inb]);
          end
          // layer 4
          if (val[3]) begin
            tmpLLR[inb] <= bm_mmax(tmp01234567[inb], tmp89ABCDEF[inb]);
          end
        end
      end
      // offset
      if (val[4]) begin
        for (int i = 1; i < 4; i++) begin
          oLapo[i] <= tmpLLR[i] - tmpLLR[0];
        end
      end
    end
  end

  assign oval = val[5];

endmodule
