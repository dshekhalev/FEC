/*



  parameter int pIDX_GR       = 0 ;
  parameter int pIDX_LS       = 0 ;
  parameter int pIDX_ZC       = 3 ;
  parameter int pCODE         = 4 ;
  parameter int pDO_PUNCT     = 0 ;
  //
  parameter int pLLR_BY_CYCLE = 1 ;
  parameter int pROW_BY_CYCLE = 8 ;



  logic         ldpc_3gpp_dec_hb__iclk                           ;
  logic         ldpc_3gpp_dec_hb__ireset                         ;
  logic         ldpc_3gpp_dec_hb__iclkena                        ;
  //
  hb_zc_t       ldpc_3gpp_dec_hb__oused_zc                       ;
  hb_row_t      ldpc_3gpp_dec_hb__oused_row                      ;
  //
  hb_row_t      ldpc_3gpp_dec_hb__iwrow                          ;
  hb_row_t      ldpc_3gpp_dec_hb__irrow                          ;
  //
  mm_hb_value_t ldpc_3gpp_dec_hb__orHb       [pROW_BY_CYCLE][26] ;
  mm_hb_value_t ldpc_3gpp_dec_hb__owHb       [pROW_BY_CYCLE][26] ;
  logic         ldpc_3gpp_dec_hb__orHb_pmask [pROW_BY_CYCLE]     ;



  ldpc_3gpp_dec_hb
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pIDX_LS       ( pIDX_LS       ) ,
    .pIDX_ZC       ( pIDX_ZC       ) ,
    .pCODE         ( pCODE         ) ,
    .pDO_PUNCT     ( pDO_PUNCT     ) ,
    //
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE )
  )
  ldpc_3gpp_dec_hb
  (
    .iclk       ( ldpc_3gpp_dec_hb__iclk       ) ,
    .ireset     ( ldpc_3gpp_dec_hb__ireset     ) ,
    .iclkena    ( ldpc_3gpp_dec_hb__iclkena    ) ,
    //
    .oused_zc   ( ldpc_3gpp_dec_hb__oused_zc   ) ,
    .oused_row  ( ldpc_3gpp_dec_hb__oused_row  ) ,
    //
    .irrow      ( ldpc_3gpp_dec_hb__irrow      ) ,
    .iwrow      ( ldpc_3gpp_dec_hb__iwrow      ) ,
    //
    .orHb       ( ldpc_3gpp_dec_hb__orHb       ) ,
    .owHb       ( ldpc_3gpp_dec_hb__owHb       ) ,
    .orHb_pmask ( ldpc_3gpp_dec_hb__orHb_pmask )
  );


  assign ldpc_3gpp_dec_hb__iclk    = '0 ;
  assign ldpc_3gpp_dec_hb__ireset  = '0 ;
  assign ldpc_3gpp_dec_hb__iclkena = '0 ;
  assign ldpc_3gpp_dec_hb__irrow   = '0 ;
  assign ldpc_3gpp_dec_hb__iwrow   = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_hb.sv
// Description   : fixed mode 3GPP LDPC RTL decoder tables
//

`include "define.vh"

module ldpc_3gpp_dec_hb
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  irrow      ,
  iwrow      ,
  //
  oused_zc   ,
  oused_row  ,
  //
  orHb       ,
  owHb       ,
  //
  orHb_pmask
);

  `include "../ldpc_3gpp_constants.svh"
  `include "../ldpc_3gpp_hc.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk                           ;
  input  logic         ireset                         ;
  input  logic         iclkena                        ;
  //
  input  hb_row_t      irrow                          ;
  input  hb_row_t      iwrow                          ;
  //
  output hb_zc_t       oused_zc                       ;
  output hb_row_t      oused_row                      ;
  //
  output mm_hb_value_t orHb       [pROW_BY_CYCLE][26] ;
  output mm_hb_value_t owHb       [pROW_BY_CYCLE][26] ;
  //
  output logic         orHb_pmask [pROW_BY_CYCLE]     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCODE   = (pCODE < 4) ? 4 : pCODE;
  localparam int cHB_NUM = ceil(46,    pROW_BY_CYCLE);
  localparam int cPH_NUM = ceil(68-22, pROW_BY_CYCLE);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  mm_hb_value_t uHb       [pROW_BY_CYCLE][26][cHB_NUM];
  logic         uHb_pmask [pROW_BY_CYCLE][cPH_NUM];

  hb_zc_t       used_zc;
  hb_row_t      used_row;

  //------------------------------------------------------------------------------------------------------
  // get and convert Hb table
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    baseHc_t      Hb;
    mm_hb_value_t mmHb      [46][26];
    int           Hb_pmask  [68-22];
    //
    used_zc   = cZC_TAB[pIDX_LS][pIDX_ZC] / pLLR_BY_CYCLE;
    used_row  = ceil(cCODE, pROW_BY_CYCLE);
    //
    Hb = get_scaled_Hc(pIDX_GR, pIDX_LS, pIDX_ZC);
    //
    for (int row = 0; row < 46; row++) begin
      for (int col = 0; col < 26; col++) begin
        if (col >= cGR_MAJOR_BIT_COL[pIDX_GR]) begin
          mmHb[row][col]           = '0;
          mmHb[row][col].is_masked = 1'b1;
        end
        else if ((row >= 4) & (row >= pCODE)) begin
          mmHb[row][col]           = '0;
          mmHb[row][col].is_masked = 1'b1;
        end
        else begin
          mmHb[row][col].bshift     =   Hb[row][col] % pLLR_BY_CYCLE;
          mmHb[row][col].wshift     =   Hb[row][col] / pLLR_BY_CYCLE;
          mmHb[row][col].is_masked  =  (Hb[row][col] < 0);
          mmHb[row][col].is_max     = ((Hb[row][col] / pLLR_BY_CYCLE) == used_zc-1);
        end
      end
    end
    //
    for (int col = 0; col < 68-22; col++) begin
      if (col < 4) begin
        Hb_pmask[col] = 1'b1;
      end
      else begin
        Hb_pmask[col] = 1'b0; // (col >= cCODE) - replaced by zeros in source module
      end
    end
    //
    for (int row = 0; row < pROW_BY_CYCLE; row++) begin
      for (int num = 0; num < cHB_NUM; num++) begin
        for (int col = 0; col < 26; col++) begin
          if ((num*pROW_BY_CYCLE + row) >= 46) begin
            uHb[row][col][num]            = '0;
            uHb[row][col][num].is_masked  = 1'b1;
          end
          else begin
            uHb[row][col][num] = mmHb[num*pROW_BY_CYCLE + row][col];
          end
        end
      end
      //
      for (int num = 0; num < cPH_NUM; num++) begin
        if ((num*pROW_BY_CYCLE + row) >= 46) begin
          uHb_pmask[row][num] = 1'b1;
        end
        else begin
          uHb_pmask[row][num] = Hb_pmask[num*pROW_BY_CYCLE + row];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // sequential read
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oused_zc  <= used_zc;
      oused_row <= used_row;
      //
      for (int row = 0; row < pROW_BY_CYCLE; row++) begin
        for (int col = 0; col < 26; col++) begin
          orHb[row][col] <= uHb[row][col][irrow];
          owHb[row][col] <= uHb[row][col][iwrow];
        end
        orHb_pmask[row] <= uHb_pmask[row][irrow];
      end
    end
  end

endmodule
