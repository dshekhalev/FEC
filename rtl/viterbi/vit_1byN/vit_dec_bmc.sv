/*



  parameter int pCONSTR_LENGTH            = 3;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};
  parameter int pLLR_W                    = 4 ;
  parameter int pTAG_W                    = 4 ;



  logic      vit_dec_bmc__iclk                    ;
  logic      vit_dec_bmc__ireset                  ;
  logic      vit_dec_bmc__iclkena                 ;
  logic      vit_dec_bmc__isop                    ;
  logic      vit_dec_bmc__ival                    ;
  logic      vit_dec_bmc__ieop                    ;
  tag_t      vit_dec_bmc__itag                    ;
  boutputs_t vit_dec_bmc__idat                    ;
  llr_t      vit_dec_bmc__iLLR    [pCODE_GEN_NUM] ;
  logic      vit_dec_bmc__osop                    ;
  logic      vit_dec_bmc__oval                    ;
  logic      vit_dec_bmc__oeop                    ;
  tag_t      vit_dec_bmc__otag                    ;
  boutputs_t vit_dec_bmc__ohd                     ;
  bm_t       vit_dec_bmc__obm                     ;



  vit_dec_bmc
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pTAG_W         ( pTAG_W         )
  )
  vit_dec_bmc
  (
    .iclk    ( vit_dec_bmc__iclk    ) ,
    .ireset  ( vit_dec_bmc__ireset  ) ,
    .iclkena ( vit_dec_bmc__iclkena ) ,
    .isop    ( vit_dec_bmc__isop    ) ,
    .ival    ( vit_dec_bmc__ival    ) ,
    .ieop    ( vit_dec_bmc__ieop    ) ,
    .itag    ( vit_dec_bmc__itag    ) ,
    .idat    ( vit_dec_bmc__idat    ) ,
    .iLLR    ( vit_dec_bmc__iLLR    ) ,
    .osop    ( vit_dec_bmc__osop    ) ,
    .oval    ( vit_dec_bmc__oval    ) ,
    .oeop    ( vit_dec_bmc__oeop    ) ,
    .otag    ( vit_dec_bmc__otag    ) ,
    .ohd     ( vit_dec_bmc__ohd     ) ,
    .obm     ( vit_dec_bmc__obm     )
  );


  assign vit_dec_bmc__iclk    = '0 ;
  assign vit_dec_bmc__ireset  = '0 ;
  assign vit_dec_bmc__iclkena = '0 ;
  assign vit_dec_bmc__isop    = '0 ;
  assign vit_dec_bmc__ival    = '0 ;
  assign vit_dec_bmc__ieop    = '0 ;
  assign vit_dec_bmc__itag    = '0 ;
  assign vit_dec_bmc__idat    = '0 ;
  assign vit_dec_bmc__iLLR    = '0 ;



*/

//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_dec_bmc.sv
// Description   : viterbi branch hard/soft metric calculator
//


module vit_dec_bmc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  itag    ,
  idat    ,
  iLLR    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  otag    ,
  ohd     ,
  obm
);

  `include "vit_trellis.svh"
  `include "vit_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk                   ;
  input  logic      ireset                 ;
  input  logic      iclkena                ;
  //
  input  logic      isop                   ;
  input  logic      ival                   ;
  input  logic      ieop                   ;
  input  tag_t      itag                   ;
  input  boutputs_t idat                   ;  // hard decsion
  input  llr_t      iLLR    [pCODE_GEN_NUM];  // soft decsion
  //
  output logic      osop                   ;
  output logic      oval                   ;
  output logic      oeop                   ;
  output tag_t      otag                   ;
  output boutputs_t ohd                    ;
  output bm_t       obm                    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  llr_t LLR [pCODE_GEN_NUM];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  // saturate minimum LLR to prevent overflow
  always_comb begin
    for (int i = 0; i < pCODE_GEN_NUM; i++) begin
      if (&{iLLR[i][pLLR_W-1], ~iLLR[i][pLLR_W-2 : 0]}) begin// -2^(N-1)
        LLR[i] <= {1'b1, {(pLLR_W-2){1'b0}}, 1'b1};   // -(2^(N-1) - 1)
      end
      else begin
        LLR[i] <= iLLR[i];
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        osop  <= isop;
        oeop  <= ieop;
        otag  <= itag;
        for (int i = 0; i < pCODE_GEN_NUM; i++) begin
          ohd[i] <= cHD_MODE ? idat[i]                        : !LLR[i][pLLR_W-1]; // LLR is not inverted 0/1 -> -1/+1
        end
        for (int i = 0; i < cBM_NUM; i++) begin
          obm[i] <= cHD_MODE ? get_hamming_distance(idat, i)  : get_LLR_metric(LLR, i);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // used functions. LLR metric is not inverted 0/1 -> -1/+1
  //------------------------------------------------------------------------------------------------------

  function trel_bm_t get_LLR_metric (input llr_t LLR [pCODE_GEN_NUM], boutputs_t trel_dat);
    trel_bm_t tmp;
  begin
    tmp = '0;
    for (int i = 0; i < pCODE_GEN_NUM; i++) begin
      tmp = trel_dat[i] ? (tmp + LLR[i]) : (tmp - LLR[i]);
    end
    get_LLR_metric = tmp;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // hamming metric
  //------------------------------------------------------------------------------------------------------

  function trel_ubm_t get_hamming_distance (input boutputs_t dat, boutputs_t trel_dat);
    trel_ubm_t  tmp;
    boutputs_t  bit_diff;
  begin
    bit_diff = dat ^ trel_dat;
    //
    tmp = '0;
    for (int i = 0; i < pCODE_GEN_NUM; i++) begin
      tmp = tmp + bit_diff[i];
    end
    get_hamming_distance = tmp;
  end
  endfunction

endmodule
