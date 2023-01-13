/*



  parameter int pN_MAX   = 1024 ;
  parameter int pLLR_W   =    4 ;
  parameter int pWORD_W  =    8 ;



  logic           pc_3gpp_dec_alu_8x8__iclk        ;
  logic           pc_3gpp_dec_alu_8x8__ireset      ;
  logic           pc_3gpp_dec_alu_8x8__iclkena     ;
  logic           pc_3gpp_dec_alu_8x8__ialpha_val  ;
  alpha_w_t       pc_3gpp_dec_alu_8x8__ialpha      ;
  beta_w_dat_t    pc_3gpp_dec_alu_8x8__ifrzb       ;
  frozenb_type_t  pc_3gpp_dec_alu_8x8__ifrzb_type  ;
  logic           pc_3gpp_dec_alu_8x8__obeta_val   ;
  beta_w_dat_t    pc_3gpp_dec_alu_8x8__obeta       ;



  pc_3gpp_dec_alu_8x8
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pLLR_W  ( pLLR_W  ) ,
    .pWORD_W ( pWORD_W )
  )
  pc_3gpp_dec_alu_8x8
  (
    .iclk       ( pc_3gpp_dec_alu_8x8__iclk       ) ,
    .ireset     ( pc_3gpp_dec_alu_8x8__ireset     ) ,
    .iclkena    ( pc_3gpp_dec_alu_8x8__iclkena    ) ,
    .ialpha_val ( pc_3gpp_dec_alu_8x8__ialpha_val ) ,
    .ialpha     ( pc_3gpp_dec_alu_8x8__ialpha     ) ,
    .ifrzb      ( pc_3gpp_dec_alu_8x8__ifrzb      ) ,
    .ifrzb_type ( pc_3gpp_dec_alu_8x8__ifrzb_type ) ,
    .obeta_val  ( pc_3gpp_dec_alu_8x8__obeta_val  ) ,
    .obeta      ( pc_3gpp_dec_alu_8x8__obeta      )
  );


  assign pc_3gpp_dec_alu_8x8__iclk       = '0 ;
  assign pc_3gpp_dec_alu_8x8__ireset     = '0 ;
  assign pc_3gpp_dec_alu_8x8__iclkena    = '0 ;
  assign pc_3gpp_dec_alu_8x8__ialpha_val = '0 ;
  assign pc_3gpp_dec_alu_8x8__ialpha     = '0 ;
  assign pc_3gpp_dec_alu_8x8__ifrzb      = '0 ;
  assign pc_3gpp_dec_alu_8x8__ifrzb_type = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_alu_8x8.sv
// Description   : Fast unrolled polar 8x8 decoder
//

`include "define.vh"

module pc_3gpp_dec_alu_8x8
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  ialpha_val ,
  ialpha     ,
  //
  ifrzb      ,
  ifrzb_type ,
  //
  obeta_val  ,
  obeta
);

  `include "pc_3gpp_dec_types.svh"
  `include "pc_3gpp_dec_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk        ;
  input  logic          ireset      ;
  input  logic          iclkena     ;
  //
  input  logic          ialpha_val  ;
  input  alpha_w_t      ialpha      ;
  //
  input  beta_w_dat_t   ifrzb       ;
  input  frozenb_type_t ifrzb_type  ;
  //
  output logic          obeta_val   ;
  output beta_w_dat_t   obeta       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [3 : 0] val;
  logic [3 : 0] bval;

  alpha_hw_t    tmpFG4;

  alpha_hw_t    tmpF4;
  alpha_hw_t    tmpG4_ones;
  alpha_hw_t    tmpG4_zeros;

  beta_w_dat_t  decodeb;
  beta_w_dat_t  frozenb;

  //------------------------------------------------------------------------------------------------------
  //
  // cDEC_RATE0_8, cDEC_RATE1_8 : 1 - 0 - 0 - 0 - 0
  // cDEC_RATE0_4_X_4           : 1 - 1 - 1 - 0 - 0
  // cDEC_X_4_RATE0_4           : 1 - 0 - 0 - 1 - 1
  // cDEC_X_8                   : 1 - 1 - 1 - 1 - 1
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val   <= '0;
      bval  <= '0;
    end
    else if (iclkena) begin
      val   <= (val << 1);
      bval  <= (bval << 1);
      if (ialpha_val) begin
        case (ifrzb_type)
          cDEC_RATE0_8      : begin val <= 4'b0000; bval <= 4'b0000; end
          cDEC_RATE1_8      : begin val <= 4'b0000; bval <= 4'b0000; end
          cDEC_RATE0_4_X_4  : begin val <= 4'b0001; bval <= 4'b0100; end
          cDEC_X_4_RATE0_4  : begin val <= 4'b0100; bval <= 4'b0100; end
          cDEC_X_8          : begin val <= 4'b0001; bval <= 4'b0001; end
          default           : begin val <= 4'b0001; bval <= 4'b0001; end
        endcase
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    if (ialpha_val & (ifrzb_type == cDEC_RATE0_8 | ifrzb_type == cDEC_RATE1_8))
      obeta_val = 1'b1;
    else
      obeta_val = bval[3];
  end

  always_comb begin
    if (ialpha_val) begin
      obeta = (ifrzb_type == cDEC_RATE1_8) ? decode_Rate1_8(ialpha) : decode_Rate0_8(ialpha);
    end
    else begin
      obeta = do_comb4(decodeb[0 +: 4], decodeb[4 +: 4]);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // cDEC_X_8, cDEC_RATE0_4_X_4, cDEC_X_4_RATE0_4
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      unique case (1)
        ialpha_val : begin
          frozenb     <= ifrzb;
          decodeb     <= '0;
          //
          tmpFG4      <= do_F4(ialpha);
          tmpG4_ones  <= do_G4(ialpha, 4'b1111, 0);
          tmpG4_zeros <= do_G4(ialpha, 4'b0000, 0);
          //
          if (ifrzb_type == cDEC_X_4_RATE0_4) begin
            tmpFG4 <= do_G4(ialpha, 4'b0000, 0);
          end
        end
        val[0]  : begin
          decodeb[0 +: 4] <= do_ns_decode_4x4(tmpFG4, frozenb[0 +: 4]);
        end
        val[1]  : begin
          for (int i = 0; i < pWORD_W/2; i++) begin
            tmpFG4[i] <= decodeb[i] ? tmpG4_ones[i] : tmpG4_zeros[i];
          end
        end
        val[2]  : begin
          decodeb[4 +: 4] <= do_ns_decode_4x4(tmpFG4, frozenb[4 +: 4]);
        end
        default : begin end
      endcase
    end
  end

endmodule
