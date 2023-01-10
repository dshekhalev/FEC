/*






  logic                 tcm_dec_demapper__iclk              ;
  logic                 tcm_dec_demapper__ireset            ;
  logic                 tcm_dec_demapper__iclkena           ;
  logic                 tcm_dec_demapper__icode             ;
  logic                 tcm_dec_demapper__isop              ;
  logic                 tcm_dec_demapper__ival              ;
  logic                 tcm_dec_demapper__ieop              ;
  bm_idx_t              tcm_dec_demapper__ibm_idx           ;
  symb_m_idx_t          tcm_dec_demapper__isymb_m_idx       ;
  symb_m_sign_t         tcm_dec_demapper__isymb_m_sign  [4] ;
  symb_m_hd_t           tcm_dec_demapper__isymb_hd          ;
  logic                 tcm_dec_demapper__osop              ;
  logic                 tcm_dec_demapper__oval              ;
  logic                 tcm_dec_demapper__oeop              ;
  logic         [2 : 0] tcm_dec_demapper__osymb         [4] ;
  logic         [3 : 0] tcm_dec_demapper__obiterr           ;



  tcm_dec_demapper
  tcm_dec_demapper
  (
    .iclk         ( tcm_dec_demapper__iclk         ) ,
    .ireset       ( tcm_dec_demapper__ireset       ) ,
    .iclkena      ( tcm_dec_demapper__iclkena      ) ,
    .icode        ( tcm_dec_demapper__icode        ) ,
    .isop         ( tcm_dec_demapper__isop         ) ,
    .ival         ( tcm_dec_demapper__ival         ) ,
    .ieop         ( tcm_dec_demapper__ieop         ) ,
    .ibm_idx      ( tcm_dec_demapper__ibm_idx      ) ,
    .isymb_m_idx  ( tcm_dec_demapper__isymb_m_idx  ) ,
    .isymb_m_sign ( tcm_dec_demapper__isymb_m_sign ) ,
    .isymb_hd     ( tcm_dec_demapper__isymb_hd     ) ,
    .osop         ( tcm_dec_demapper__osop         ) ,
    .oval         ( tcm_dec_demapper__oval         ) ,
    .oeop         ( tcm_dec_demapper__oeop         ) ,
    .osymb        ( tcm_dec_demapper__osymb        ) ,
    .obiterr      ( tcm_dec_demapper__obiterr      )
  );


  assign tcm_dec_demapper__iclk         = '0 ;
  assign tcm_dec_demapper__ireset       = '0 ;
  assign tcm_dec_demapper__iclkena      = '0 ;
  assign tcm_dec_demapper__icode        = '0 ;
  assign tcm_dec_demapper__isop         = '0 ;
  assign tcm_dec_demapper__ival         = '0 ;
  assign tcm_dec_demapper__ieop         = '0 ;
  assign tcm_dec_demapper__ibm_idx      = '0 ;
  assign tcm_dec_demapper__isymb_m_idx  = '0 ;
  assign tcm_dec_demapper__isymb_m_sign = '0 ;
  assign tcm_dec_demapper__isymb_hd     = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_demapper.sv
// Description   : 4D symbol demapper unit
//

`include "define.vh"

module tcm_dec_demapper
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  icode        ,
  //
  isop         ,
  ival         ,
  ieop         ,
  ibm_idx      ,
  isymb_m_idx  ,
  isymb_m_sign ,
  isymb_hd     ,
  //
  osop         ,
  oval         ,
  oeop         ,
  osymb        ,
  obiterr
);

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk               ;
  input  logic                 ireset             ;
  input  logic                 iclkena            ;
  //
  input  logic         [1 : 0] icode              ; // 0/1/2/3 - 2/2.25/2.5/2.75
  //
  input  logic                 isop               ;
  input  logic                 ival               ;
  input  logic                 ieop               ;
  input  trel_bm_idx_t         ibm_idx            ;
  input  symb_m_idx_t          isymb_m_idx        ;
  input  symb_m_sign_t         isymb_m_sign  [4]  ;
  input  symb_hd_t             isymb_hd           ;
  //
  output logic                 osop               ;
  output logic                 oval               ;
  output logic                 oeop               ;
  output logic         [2 : 0] osymb          [4] ;
  output logic         [3 : 0] obiterr            ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "tcm_symb_m_group_tab.svh"

  bit   [1 : 0] dec_symbol [4];
  logic [2 : 0] dem_symbol [4];

  logic [2 : 0] hd_symbol  [4];

  logic [2 : 0] biterr;
  logic [3 : 0] errcnt;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    case (icode)
      2'h0    : dec_symbol = cSM_IDX_200_TAB[ibm_idx][isymb_m_idx];
      2'h1    : dec_symbol = cSM_IDX_225_TAB[ibm_idx][isymb_m_idx];
      2'h2    : dec_symbol = cSM_IDX_250_TAB[ibm_idx][isymb_m_idx];
      default : dec_symbol = cSM_IDX_275_TAB[ibm_idx][isymb_m_idx];
    endcase

    for (int i = 0; i < 4; i++) begin
      dem_symbol[i] = {isymb_m_sign[i][dec_symbol[i]], dec_symbol[i]};
      hd_symbol [i] = {isymb_m_sign[i][isymb_hd  [i]], isymb_hd  [i]};
    end

    errcnt = 0;
    for (int i = 0; i < 4; i++) begin
      biterr = (dem_symbol[i] ^ hd_symbol[i]);
      for (int b = 0; b < 3; b++) begin
        errcnt = errcnt + biterr[b];
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        osop    <= isop;
        oeop    <= ieop;
        osymb   <= dem_symbol;
        obiterr <= errcnt;
      end
    end
  end

endmodule
