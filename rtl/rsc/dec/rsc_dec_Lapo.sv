/*



  parameter bit pB_nF      = 0 ;
  parameter int pLLR_W     = 5 ;
  parameter int pLLR_FP    = 3 ;
  parameter int pMMAX_TYPE = 0;



  logic   rsc_dec_Lapo__iclk     ;
  logic   rsc_dec_Lapo__ireset   ;
  logic   rsc_dec_Lapo__iclkena  ;
  logic   rsc_dec_Lapo__ival     ;
  gamma_t rsc_dec_Lapo__igamma   ;
  state_t rsc_dec_Lapo__istate   ;
  logic   rsc_dec_Lapo__oval     ;
  Lapo_t  rsc_dec_Lapo__oLapo    ;



  rsc_dec_Lapo
  #(
    .pB_nF      ( pB_nF      ) ,
    .pLLR_W     ( pLLR_W     ) ,
    .pLLR_FP    ( pLLR_FP    ) ,
    .pMMAX_TYPE ( pMMAX_TYPE )
  )
  rsc_dec_Lapo
  (
    .iclk    ( rsc_dec_Lapo__iclk    ) ,
    .ireset  ( rsc_dec_Lapo__ireset  ) ,
    .iclkena ( rsc_dec_Lapo__iclkena ) ,
    .ival    ( rsc_dec_Lapo__ival    ) ,
    .igamma  ( rsc_dec_Lapo__igamma  ) ,
    .istate  ( rsc_dec_Lapo__istate  ) ,
    .oval    ( rsc_dec_Lapo__oval    ) ,
    .oLapo   ( rsc_dec_Lapo__oLapo   )
  );


  assign rsc_dec_Lapo__iclk    = '0 ;
  assign rsc_dec_Lapo__ireset  = '0 ;
  assign rsc_dec_Lapo__iclkena = '0 ;
  assign rsc_dec_Lapo__ival    = '0 ;
  assign rsc_dec_Lapo__igamma  = '0 ;
  assign rsc_dec_Lapo__istate  = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_Lextr.sv
// Description   : module to count aposteriory LLR : sum(bm(s, s')) = sum(alpha(s, k) * gamma_e(s, s') * beta(s',k+1))
//                 Module latency us 5 tick.
//

module rsc_dec_Lapo
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

  `include "rsc_dec_types.svh"
  `include "rsc_trellis.svh"
  `include "rsc_mmax.svh"

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

  logic [4 : 0] val;

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
            for (int state = 0; state < 8; state++) begin
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
            for (int state = 0; state < 8; state++) begin
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

  trel_branch_t tmp01   [4];
  trel_branch_t tmp23   [4];
  trel_branch_t tmp45   [4];
  trel_branch_t tmp67   [4];

  trel_branch_t tmp0123 [4];
  trel_branch_t tmp4567 [4];

  trel_branch_t tmpLLR  [4];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int inb = 0; inb < 4; inb++) begin
        if (pMMAX_TYPE == 1) begin
          // layer 1
          if (val[0]) begin
            tmp01[inb] <= bm_mmax1(bm[0][inb], bm[1][inb]);
            tmp23[inb] <= bm_mmax1(bm[2][inb], bm[3][inb]);
            tmp45[inb] <= bm_mmax1(bm[4][inb], bm[5][inb]);
            tmp67[inb] <= bm_mmax1(bm[6][inb], bm[7][inb]);
          end
          // layer 2
          if (val[1]) begin
            tmp0123[inb] <= bm_mmax1(tmp01[inb], tmp23[inb]);
            tmp4567[inb] <= bm_mmax1(tmp45[inb], tmp67[inb]);
          end
          // layer 3
          if (val[2]) begin
            tmpLLR[inb] <= bm_mmax1(tmp0123[inb], tmp4567[inb]);
          end
        end
        else begin
          // layer 1
          if (val[0]) begin
            tmp01[inb] <= bm_mmax(bm[0][inb], bm[1][inb]);
            tmp23[inb] <= bm_mmax(bm[2][inb], bm[3][inb]);
            tmp45[inb] <= bm_mmax(bm[4][inb], bm[5][inb]);
            tmp67[inb] <= bm_mmax(bm[6][inb], bm[7][inb]);
          end
          // layer 2
          if (val[1]) begin
            tmp0123[inb] <= bm_mmax(tmp01[inb], tmp23[inb]);
            tmp4567[inb] <= bm_mmax(tmp45[inb], tmp67[inb]);
          end
          // layer 3
          if (val[2]) begin
            tmpLLR[inb] <= bm_mmax(tmp0123[inb], tmp4567[inb]);
          end
        end
      end
      // offset
      if (val[3]) begin
        for (int i = 1; i < 4; i++) begin
          oLapo[i] <= tmpLLR[i] - tmpLLR[0];
        end
      end
    end
  end

  assign oval = val[4];

endmodule
