/*



  parameter int pADDR_W       = 8 ;
  //
  parameter int pBCNV_MAX_IDX = 3 ;


  logic                       b_nb_ldpc_g_tab__iclk           ;
  logic                       b_nb_ldpc_g_tab__ireset         ;
  logic                       b_nb_ldpc_g_tab__iclkena        ;
  //
  code_idx_t                  b_nb_ldpc_g_tab__icode_idx      ;
  //
  col_t                       b_nb_ldpc_g_tab__oused_col      ;
  row_t                       b_nb_ldpc_g_tab__oused_row      ;
  col_t                       b_nb_ldpc_g_tab__oused_data_col ;
  cycle_idx_t                 b_nb_ldpc_g_tab__ocycle_max_num ;
  //
  logic                       b_nb_ldpc_g_tab__idat_n_parity  ;
  //
  logic                       b_nb_ldpc_g_tab__icycle_read    ;
  cycle_idx_t                 b_nb_ldpc_g_tab__icycle_idx     ;
  //
  logic                       b_nb_ldpc_g_tab__oread          ;
  strb_t                      b_nb_ldpc_g_tab__orstrb         ;
  logic       [pADDR_W-1 : 0] b_nb_ldpc_g_tab__oraddr         ;
  gf_data_t                   b_nb_ldpc_g_tab__ogdat          ;



  b_nb_ldpc_g_tab
  #(
    .pADDR_W       ( pADDR_W       ) ,
    //
    .pBCNV_MAX_IDX ( pBCNV_MAX_IDX )
  )
  b_nb_ldpc_g_tab
  (
    .iclk           ( b_nb_ldpc_g_tab__iclk           ) ,
    .ireset         ( b_nb_ldpc_g_tab__ireset         ) ,
    .iclkena        ( b_nb_ldpc_g_tab__iclkena        ) ,
    //
    .icode_idx      ( b_nb_ldpc_g_tab__icode_idx      ) ,
    //
    .oused_col      ( b_nb_ldpc_g_tab__oused_col      ) ,
    .oused_row      ( b_nb_ldpc_g_tab__oused_row      ) ,
    .oused_data_col ( b_nb_ldpc_g_tab__oused_data_col ) ,
    .ocycle_max_num ( b_nb_ldpc_g_tab__ocycle_max_num ) ,
    //
    .idat_n_parity  ( b_nb_ldpc_g_tab__idat_n_parity  ) ,
    //
    .icycle_read    ( b_nb_ldpc_g_tab__icycle_read    ) ,
    .icycle_idx     ( b_nb_ldpc_g_tab__icycle_idx     ) ,
    //
    .oread          ( b_nb_ldpc_g_tab__oread          ) ,
    .orstrb         ( b_nb_ldpc_g_tab__orstrb         ) ,
    .oraddr         ( b_nb_ldpc_g_tab__oraddr         ) ,
    .ogdat          ( b_nb_ldpc_g_tab__ogdat          )
  );


  assign b_nb_ldpc_g_tab__iclk           = '0 ;
  assign b_nb_ldpc_g_tab__ireset         = '0 ;
  assign b_nb_ldpc_g_tab__iclkena        = '0 ;
  assign b_nb_ldpc_g_tab__icode_idx      = '0 ;
  assign b_nb_ldpc_g_tab__idat_n_parity = '0 ;
  assign b_nb_ldpc_g_tab__icycle_read   = '0 ;
  assign b_nb_ldpc_g_tab__icycle_idx    = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_g_tab.svh
// Description   : generation table context unit
//                 read delay 3 ticks
//

module b_nb_ldpc_g_tab
#(
  parameter int pADDR_W       = 8 ,
  //
  parameter int pBCNV_MAX_IDX = 3   // 0   - cBCNV1_SF3 only
                                    // 1   - cBCNV1_SF3/cBCNV1_SF2 only
                                    // other - cBCNV1_SF3/cBCNV1_SF2/cBCNV2/cBCNV3
)
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  icode_idx      ,
  //
  oused_col      ,
  oused_row      ,
  oused_data_col ,
  ocycle_max_num ,
  //
  idat_n_parity  ,
  //
  icycle_read    ,
  icycle_idx     ,
  //
  oread          ,
  orstrb         ,
  oraddr         ,
  ogdat
);

  `include "b_nb_ldpc_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk           ;
  input  logic                       ireset         ;
  input  logic                       iclkena        ;
  //
  input  code_idx_t                  icode_idx      ;
  //
  output col_t                       oused_col      ;
  output row_t                       oused_row      ;
  output col_t                       oused_data_col ;
  output cycle_idx_t                 ocycle_max_num ;
  //
  input  logic                       idat_n_parity  ;
  //
  input  logic                       icycle_read    ;
  input  cycle_idx_t                 icycle_idx     ;
  //
  output logic                       oread          ;
  output strb_t                      orstrb         ;
  output logic       [pADDR_W-1 : 0] oraddr         ;
  output gf_data_t                   ogdat          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "b_nb_ldpc_g_tab.svh"

  typedef struct packed {
    logic         sop;
    logic         sof;
    logic         eop;
    logic         eof;
    logic [7 : 0] addr;
    logic [5 : 0] gdat;
  } ctx_dat_t;

  typedef logic [cG_CTX_TAB_ADDR_W-1 : 0] ctx_addr_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  code_idx_t  code_idx;

  logic       ctx_read;
  ctx_addr_t  ctx_raddr;

  ctx_addr_t  ctx_data_offset;

  logic       ctx_rval;
  ctx_dat_t   ctx_rdat;

  //------------------------------------------------------------------------------------------------------
  // code idx mask
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    case (pBCNV_MAX_IDX)
      0       : code_idx = icode_idx & 2'b00;
      1       : code_idx = icode_idx & 2'b01;
      default : code_idx = icode_idx & 2'b11;
    endcase
  end

  //------------------------------------------------------------------------------------------------------
  // code parameters decoding (no need register here)
  //------------------------------------------------------------------------------------------------------

  assign oused_col      = cCOL_TAB       [code_idx];
  assign oused_row      = cROW_TAB       [code_idx];
  assign oused_data_col = cROW_TAB       [code_idx];
  assign ocycle_max_num = cG_CTX_SIZE_TAB[code_idx];

  //------------------------------------------------------------------------------------------------------
  // context decoding
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    case (pBCNV_MAX_IDX)
      0       : ctx_data_offset = cG_BCNV1_SF3_CTX_DATA_OFFSET;
      1       : ctx_data_offset = cG_BCNV1_SF_CTX_DATA_OFFSET;
      default : ctx_data_offset = cG_CTX_DATA_OFFSET;
    endcase
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ctx_read  <= icycle_read;
      ctx_raddr <= icycle_idx + (idat_n_parity ? ctx_data_offset : cG_CTX_OFFSET_TAB[code_idx]);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ctx_rval    <= ctx_read;
      //
      case (pBCNV_MAX_IDX)
        0       : ctx_rdat  <= cG_BCNV1_SF3_CTX_TAB [ctx_raddr[cG_BCNV1_SF3_CTX_TAB_ADDR_W-1 : 0]];
        1       : ctx_rdat  <= cG_BCNV1_SF_CTX_TAB  [ctx_raddr[cG_BCNV1_SF_CTX_TAB_ADDR_W-1  : 0]];
        default : ctx_rdat  <= cG_CTX_TAB           [ctx_raddr];
      endcase
      //
      oread       <= ctx_rval;
      orstrb.sop  <= ctx_rdat.sop;
      orstrb.sof  <= ctx_rdat.sof;
      orstrb.eop  <= ctx_rdat.eop;
      orstrb.eof  <= ctx_rdat.eof;
      oraddr      <= ctx_rdat.addr;
      ogdat       <= ctx_rdat.gdat;
    end
  end

endmodule
