/*


  parameter int pADDR_W        = 8 ;
  parameter int pDAT_W         = 8 ;
  //
  parameter int pTAG_W         = 2 ;
  //
  parameter bit pUSE_VAR_DAT_W = 0 ;



  logic                      ldpc_3gpp_enc_muxout__iclk        ;
  logic                      ldpc_3gpp_enc_muxout__ireset      ;
  logic                      ldpc_3gpp_enc_muxout__iclkena     ;
  //
  hb_zc_t                    ldpc_3gpp_enc_muxout__iused_dat_w ;
  //
  logic       [pTAG_W-1 : 0] ldpc_3gpp_enc_muxout__itag        ;
  code_ctx_t                 ldpc_3gpp_enc_muxout__icode_ctx   ;
  //
  logic                      ldpc_3gpp_enc_muxout__iacu_val    ;
  logic                      ldpc_3gpp_enc_muxout__iacu_pmask  ;
  strb_t                     ldpc_3gpp_enc_muxout__iacu_strb   ;
  dat_t                      ldpc_3gpp_enc_muxout__iacu_dat    ;
  //
  logic                      ldpc_3gpp_enc_muxout__ip1_val     ;
  strb_t                     ldpc_3gpp_enc_muxout__ip1_strb    ;
  dat_t                      ldpc_3gpp_enc_muxout__ip1_dat     ;
  //
  logic                      ldpc_3gpp_enc_muxout__ip2_val     ;
  strb_t                     ldpc_3gpp_enc_muxout__ip2_strb    ;
  dat_t                      ldpc_3gpp_enc_muxout__ip2_dat     ;
  //
  logic                      ldpc_3gpp_enc_muxout__ip3_val     ;
  strb_t                     ldpc_3gpp_enc_muxout__ip3_strb    ;
  dat_t                      ldpc_3gpp_enc_muxout__ip3_dat     ;
  //
  logic                      ldpc_3gpp_enc_muxout__owrite      ;
  logic                      ldpc_3gpp_enc_muxout__owfull      ;
  logic      [pADDR_W-1 : 0] ldpc_3gpp_enc_muxout__owaddr      ;
  dat_t                      ldpc_3gpp_enc_muxout__owdat       ;
  logic       [pTAG_W-1 : 0] ldpc_3gpp_enc_muxout__owtag       ;
  code_ctx_t                 ldpc_3gpp_enc_muxout__ocode_ctx   ;



  ldpc_3gpp_enc_muxout
  #(
    .pADDR_W        ( pADDR_W        ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pTAG_W         ( pTAG_W         ) ,
    //
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  ldpc_3gpp_enc_muxout
  (
    .iclk        ( ldpc_3gpp_enc_muxout__iclk        ) ,
    .ireset      ( ldpc_3gpp_enc_muxout__ireset      ) ,
    .iclkena     ( ldpc_3gpp_enc_muxout__iclkena     ) ,
    //
    .iused_dat_w ( ldpc_3gpp_enc_muxout__iused_dat_w ) ,
    //
    .itag        ( ldpc_3gpp_enc_muxout__itag        ) ,
    .icode_ctx   ( ldpc_3gpp_enc_muxout__icode_ctx   ) ,
    //
    .iacu_val    ( ldpc_3gpp_enc_muxout__iacu_val    ) ,
    .iacu_pmask  ( ldpc_3gpp_enc_muxout__iacu_pmask  ) ,
    .iacu_strb   ( ldpc_3gpp_enc_muxout__iacu_strb   ) ,
    .iacu_dat    ( ldpc_3gpp_enc_muxout__iacu_dat    ) ,
    //
    .ip1_val     ( ldpc_3gpp_enc_muxout__ip1_val     ) ,
    .ip1_strb    ( ldpc_3gpp_enc_muxout__ip1_strb    ) ,
    .ip1_dat     ( ldpc_3gpp_enc_muxout__ip1_dat     ) ,
    //
    .ip2_val     ( ldpc_3gpp_enc_muxout__ip2_val     ) ,
    .ip2_strb    ( ldpc_3gpp_enc_muxout__ip2_strb    ) ,
    .ip2_dat     ( ldpc_3gpp_enc_muxout__ip2_dat     ) ,
    //
    .ip3_val     ( ldpc_3gpp_enc_muxout__ip3_val     ) ,
    .ip3_strb    ( ldpc_3gpp_enc_muxout__ip3_strb    ) ,
    .ip3_dat     ( ldpc_3gpp_enc_muxout__ip3_dat     ) ,
    //
    .owrite      ( ldpc_3gpp_enc_muxout__owrite      ) ,
    .owfull      ( ldpc_3gpp_enc_muxout__owfull      ) ,
    .owaddr      ( ldpc_3gpp_enc_muxout__owaddr      ) ,
    .owdat       ( ldpc_3gpp_enc_muxout__owdat       ) ,
    .owtag       ( ldpc_3gpp_enc_muxout__owtag       ) ,
    .ocode_ctx   ( ldpc_3gpp_enc_muxout__ocode_ctx   )
  );


  assign ldpc_3gpp_enc_muxout__iclk        = '0 ;
  assign ldpc_3gpp_enc_muxout__ireset      = '0 ;
  assign ldpc_3gpp_enc_muxout__iclkena     = '0 ;
  assign ldpc_3gpp_enc_muxout__iused_dat_w = '0 ;
  assign ldpc_3gpp_enc_muxout__itag        = '0 ;
  assign ldpc_3gpp_enc_muxout__icode_ctx   = '0 ;
  assign ldpc_3gpp_enc_muxout__iacu_val    = '0 ;
  assign ldpc_3gpp_enc_muxout__iacu_pmask  = '0 ;
  assign ldpc_3gpp_enc_muxout__iacu_strb   = '0 ;
  assign ldpc_3gpp_enc_muxout__iacu_dat    = '0 ;
  assign ldpc_3gpp_enc_muxout__ip1_val     = '0 ;
  assign ldpc_3gpp_enc_muxout__ip1_strb    = '0 ;
  assign ldpc_3gpp_enc_muxout__ip1_dat     = '0 ;
  assign ldpc_3gpp_enc_muxout__ip2_val     = '0 ;
  assign ldpc_3gpp_enc_muxout__ip2_strb    = '0 ;
  assign ldpc_3gpp_enc_muxout__ip2_dat     = '0 ;
  assign ldpc_3gpp_enc_muxout__ip3_val     = '0 ;
  assign ldpc_3gpp_enc_muxout__ip3_strb    = '0 ;
  assign ldpc_3gpp_enc_muxout__ip3_dat     = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_muxout.sv
// Description   : data/parity bits output multipexer
//

module ldpc_3gpp_enc_muxout
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  iused_dat_w ,
  //
  itag        ,
  icode_ctx   ,
  //
  iacu_val    ,
  iacu_pmask  ,
  iacu_strb   ,
  iacu_dat    ,
  //
  ip1_val     ,
  ip1_strb    ,
  ip1_dat     ,
  //
  ip2_val     ,
  ip2_strb    ,
  ip2_dat     ,
  //
  ip3_val     ,
  ip3_strb    ,
  ip3_dat     ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  owtag       ,
  ocode_ctx
);

  parameter int pADDR_W        = 8 ;
  parameter int pTAG_W         = 2 ;
  parameter bit pUSE_VAR_DAT_W = 0 ;

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                      iclk        ;
  input  logic                      ireset      ;
  input  logic                      iclkena     ;
  //
  input  hb_zc_t                    iused_dat_w ;
  //
  input  logic       [pTAG_W-1 : 0] itag        ;
  input  code_ctx_t                 icode_ctx   ;
  //
  input  logic                      iacu_val    ;
  input  logic                      iacu_pmask  ;
  input  strb_t                     iacu_strb   ;
  input  dat_t                      iacu_dat    ;
  //
  input  logic                      ip1_val     ;
  input  strb_t                     ip1_strb    ;
  input  dat_t                      ip1_dat     ;
  //
  input  logic                      ip2_val     ;
  input  strb_t                     ip2_strb    ;
  input  dat_t                      ip2_dat     ;
  //
  input  logic                      ip3_val     ;
  input  strb_t                     ip3_strb    ;
  input  dat_t                      ip3_dat     ;
  //
  output logic                      owrite      ;
  output logic                      owfull      ;
  output logic      [pADDR_W-1 : 0] owaddr      ;
  output dat_t                      owdat       ;
  output logic       [pTAG_W-1 : 0] owtag       ;
  output code_ctx_t                 ocode_ctx   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                   mux_write;
  logic                   mux_wstart;
  logic                   mux_wfull;
  dat_t                   mux_wdat;

  logic                   write;
  logic                   wstart;
  logic                   wfull;
  dat_t                   wdat;

  logic [cLOG2_DAT_W : 0] wcnt; // +1 tick for overflow control

  logic                   do_last;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign mux_wstart = iacu_val & iacu_strb.sof;
  assign mux_wfull  = (ip2_val & ip2_strb.eof) | (ip3_val & ip3_strb.eof);

  always_comb begin
    if (icode_ctx.do_punct) begin
      mux_write = (iacu_val & !iacu_pmask) | ip1_val | ip2_val | ip3_val;
    end
    else begin
      mux_write = iacu_val | ip1_val | ip2_val | ip3_val;
    end
    //
    mux_wdat = iacu_dat;
    if (ip3_val) begin
      mux_wdat = ip3_dat;
    end
    else if (ip2_val) begin
      mux_wdat = ip2_dat;
    end
    else if (ip1_val) begin
      mux_wdat = ip1_dat;
    end
  end

  generate
    if (pUSE_VAR_DAT_W) begin
      //
      // repack data from used_dat_w to pDAT_W
      //
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          write   <= 1'b0;
          wfull   <= 1'b0;
          //
          do_last <= 1'b0;
          //
          owrite  <= 1'b0;
          owfull  <= 1'b0;
        end
        else if (iclkena) begin
          write <= mux_write;
          wfull <= mux_wfull;
          // detect the amount of null bits in word
          if (wfull & !wcnt[cLOG2_DAT_W]) begin
            do_last <= 1'b1;
          end
          else if (wcnt[cLOG2_DAT_W] ) begin
            do_last <= 1'b0;
          end
          //
          owrite <= (write & wcnt[cLOG2_DAT_W]) | (do_last & wcnt[cLOG2_DAT_W]);
          owfull <= (wfull & wcnt[cLOG2_DAT_W]) | (do_last & wcnt[cLOG2_DAT_W]);
        end
      end
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          wstart <= mux_wstart;
          wdat   <= mux_wdat;
          // count number of bits in word
          if (mux_wstart) begin
            wcnt <= mux_write ? iused_dat_w : '0; // no write at mux_wstart if puncture used
          end
          else if (mux_write | do_last) begin
            wcnt <= wcnt[cLOG2_DAT_W] ? iused_dat_w : (wcnt + iused_dat_w);
          end
          //
          if (write | (do_last & !wcnt[cLOG2_DAT_W])) begin
            owdat <= {wdat, owdat} >> iused_dat_w;
          end
          //
          owaddr <= wstart ? '0 : (owaddr + owrite);
          //
          if (wstart) begin
            owtag     <= itag;
            ocode_ctx <= icode_ctx;
          end
        end
      end

    end
    else begin
      //
      // drive data as is
      //
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          owrite <= 1'b0;
          owfull <= 1'b0;
        end
        else if (iclkena) begin
          owrite <= mux_write;
          owfull <= mux_wfull;
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          owdat  <= mux_wdat;
          //
          owaddr <= mux_wstart ? '0 : (owaddr + owrite);
          //
          if (mux_wstart) begin
            owtag     <= itag;
            ocode_ctx <= ocode_ctx;
          end
        end
      end

    end
  endgenerate

endmodule
