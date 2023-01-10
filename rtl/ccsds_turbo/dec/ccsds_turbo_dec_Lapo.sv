/*



  parameter bit pB_nF      = 0 ;
  parameter int pLLR_W     = 5 ;
  parameter int pLLR_FP    = 3 ;
  parameter int pMMAX_TYPE = 0;



  logic   ccsds_turbo_dec_Lapo__iclk     ;
  logic   ccsds_turbo_dec_Lapo__ireset   ;
  logic   ccsds_turbo_dec_Lapo__iclkena  ;
  logic   ccsds_turbo_dec_Lapo__ival     ;
  gamma_t ccsds_turbo_dec_Lapo__igamma   ;
  state_t ccsds_turbo_dec_Lapo__istate   ;
  logic   ccsds_turbo_dec_Lapo__oval     ;
  Lapo_t  ccsds_turbo_dec_Lapo__oLapo    ;



  ccsds_turbo_dec_Lapo
  #(
    .pB_nF      ( pB_nF      ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  ccsds_turbo_dec_Lapo
  (
    .iclk    ( ccsds_turbo_dec_Lapo__iclk    ) ,
    .ireset  ( ccsds_turbo_dec_Lapo__ireset  ) ,
    .iclkena ( ccsds_turbo_dec_Lapo__iclkena ) ,
    .ival    ( ccsds_turbo_dec_Lapo__ival    ) ,
    .igamma  ( ccsds_turbo_dec_Lapo__igamma  ) ,
    .istate  ( ccsds_turbo_dec_Lapo__istate  ) ,
    .oval    ( ccsds_turbo_dec_Lapo__oval    ) ,
    .oLapo   ( ccsds_turbo_dec_Lapo__oLapo   )
  );


  assign ccsds_turbo_dec_Lapo__iclk    = '0 ;
  assign ccsds_turbo_dec_Lapo__ireset  = '0 ;
  assign ccsds_turbo_dec_Lapo__iclkena = '0 ;
  assign ccsds_turbo_dec_Lapo__ival    = '0 ;
  assign ccsds_turbo_dec_Lapo__igamma  = '0 ;
  assign ccsds_turbo_dec_Lapo__istate  = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_Lextr.sv
// Description   : module to count aposteriory LLR : sum(bm(s, s')) = sum(alpha(s, k) * gamma_e(s, s') * beta(s',k+1))
//                 Module latency us 5 tick.
//

module ccsds_turbo_dec_Lapo
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

  `include "../ccsds_turbo_trellis.svh"

  `include "ccsds_turbo_dec_types.svh"
  `include "ccsds_turbo_mmax.svh"

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
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
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
              for (int inb = 0; inb < 2; inb++) begin
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
              for (int inb = 0; inb < 2; inb++) begin
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

  trel_branch_t tmp01       [cBIT_NUM] ;
  trel_branch_t tmp23       [cBIT_NUM] ;
  trel_branch_t tmp45       [cBIT_NUM] ;
  trel_branch_t tmp67       [cBIT_NUM] ;
  trel_branch_t tmp89       [cBIT_NUM] ;
  trel_branch_t tmpAB       [cBIT_NUM] ;
  trel_branch_t tmpCD       [cBIT_NUM] ;
  trel_branch_t tmpEF       [cBIT_NUM] ;

  trel_branch_t tmp0123     [cBIT_NUM] ;
  trel_branch_t tmp4567     [cBIT_NUM] ;
  trel_branch_t tmp89AB     [cBIT_NUM] ;
  trel_branch_t tmpCDEF     [cBIT_NUM] ;

  trel_branch_t tmp01234567 [cBIT_NUM] ;
  trel_branch_t tmp89ABCDEF [cBIT_NUM] ;

  trel_branch_t tmpLLR      [cBIT_NUM] ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int inb = 0; inb < cBIT_NUM; inb++) begin
        if (pMMAX_TYPE == 1) begin
          // layer 1
          if (val[0]) begin
            tmp01[inb] <= bm_mmax1(bm[ 0][inb], bm[ 1][inb]);
            tmp23[inb] <= bm_mmax1(bm[ 2][inb], bm[ 3][inb]);
            tmp45[inb] <= bm_mmax1(bm[ 4][inb], bm[ 5][inb]);
            tmp67[inb] <= bm_mmax1(bm[ 6][inb], bm[ 7][inb]);
            tmp89[inb] <= bm_mmax1(bm[ 8][inb], bm[ 9][inb]);
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
            tmp01[inb] <= bm_mmax(bm[ 0][inb], bm[ 1][inb]);
            tmp23[inb] <= bm_mmax(bm[ 2][inb], bm[ 3][inb]);
            tmp45[inb] <= bm_mmax(bm[ 4][inb], bm[ 5][inb]);
            tmp67[inb] <= bm_mmax(bm[ 6][inb], bm[ 7][inb]);
            tmp89[inb] <= bm_mmax(bm[ 8][inb], bm[ 9][inb]);
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
        oLapo <= tmpLLR[1] - tmpLLR[0];
      end
    end
  end

  assign oval = val[5];

endmodule
