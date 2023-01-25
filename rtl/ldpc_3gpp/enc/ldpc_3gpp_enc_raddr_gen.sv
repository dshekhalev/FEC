/*



  parameter int pADDR_W        = 8 ;
  parameter bit pUSE_VAR_DAT_W = 0 ;



  logic                   ldpc_3gpp_enc_raddr_gen__iclk        ;
  logic                   ldpc_3gpp_enc_raddr_gen__ireset      ;
  logic                   ldpc_3gpp_enc_raddr_gen__iclkena     ;
  //
  hb_zc_t                 ldpc_3gpp_enc_raddr_gen__iused_dat_w ;
  //
  logic                   ldpc_3gpp_enc_raddr_gen__iclear      ;
  logic                   ldpc_3gpp_enc_raddr_gen__ienable     ;
  //
  logic   [pADDR_W-1 : 0] ldpc_3gpp_enc_raddr_gen__oraddr      ;
  logic                   ldpc_3gpp_enc_raddr_gen__orval       ;



  ldpc_3gpp_enc_raddr_gen
  #(
    .pADDR_W        ( pADDR_W        ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  ldpc_3gpp_enc_raddr_gen
  (
    .iclk        ( ldpc_3gpp_enc_raddr_gen__iclk        ) ,
    .ireset      ( ldpc_3gpp_enc_raddr_gen__ireset      ) ,
    .iclkena     ( ldpc_3gpp_enc_raddr_gen__iclkena     ) ,
    //
    .iused_dat_w ( ldpc_3gpp_enc_raddr_gen__iused_dat_w ) ,
    //
    .iclear      ( ldpc_3gpp_enc_raddr_gen__iclear      ) ,
    .ienable     ( ldpc_3gpp_enc_raddr_gen__ienable     ) ,
    //
    .oraddr      ( ldpc_3gpp_enc_raddr_gen__oraddr      ) ,
    .orval       ( ldpc_3gpp_enc_raddr_gen__orval       )
  );


  assign ldpc_3gpp_enc_raddr_gen__iclk        = '0 ;
  assign ldpc_3gpp_enc_raddr_gen__ireset      = '0 ;
  assign ldpc_3gpp_enc_raddr_gen__iclkena     = '0 ;
  assign ldpc_3gpp_enc_raddr_gen__iused_dat_w = '0 ;
  assign ldpc_3gpp_enc_raddr_gen__iclear      = '0 ;
  assign ldpc_3gpp_enc_raddr_gen__ienable     = '0 ;



*/

`include "define.vh"

module ldpc_3gpp_enc_raddr_gen
#(
  parameter int pADDR_W        = 8 ,
  parameter bit pUSE_VAR_DAT_W = 0
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  iused_dat_w ,
  //
  iclear      ,
  ienable     ,
  //
  oraddr      ,
  orval
);

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk        ;
  input  logic                   ireset      ;
  input  logic                   iclkena     ;
  //
  input  hb_zc_t                 iused_dat_w ;
  //
  input  logic                   iclear      ;
  input  logic                   ienable     ;
  //
  output logic   [pADDR_W-1 : 0] oraddr      ;
  output logic                   orval       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [cLOG2_DAT_W : 0] rcnt;
  logic                   raddr_val;
  logic           [1 : 0] read_val;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_VAR_DAT_W) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          raddr_val <= iclear | (ienable & rcnt[cLOG2_DAT_W]);
          //
          if (iclear) begin
            oraddr  <= '0;
            rcnt    <= iused_dat_w;
          end
          else if (ienable) begin
            rcnt    <= rcnt[cLOG2_DAT_W] ? iused_dat_w : (rcnt + iused_dat_w);
            oraddr  <= oraddr + rcnt[cLOG2_DAT_W];
          end
        end
      end
    end
    else begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          raddr_val <= (iclear | ienable);
          //
          if (iclear) begin
            oraddr <= '0;
          end
          else if (ienable) begin
            oraddr <= oraddr + 1'b1;
          end
        end // iclkena
      end // iclk
    end
  endgenerate

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      read_val <= (read_val << 1) | raddr_val;
    end
  end

  assign orval = read_val[1]; // ram read latency is 2 tick (!!!)

endmodule
