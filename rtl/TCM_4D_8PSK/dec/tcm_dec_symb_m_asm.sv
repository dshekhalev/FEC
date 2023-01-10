/*



  parameter int pSYMB_M_W = 8 ;



  logic         tcm_dec_symb_m_asm__iclk             ;
  logic         tcm_dec_symb_m_asm__ireset           ;
  logic         tcm_dec_symb_m_asm__iclkena          ;
  logic         tcm_dec_symb_m_asm__i1sps            ;
  logic         tcm_dec_symb_m_asm__isop             ;
  logic         tcm_dec_symb_m_asm__ival             ;
  logic         tcm_dec_symb_m_asm__ieop             ;
  symb_m_t      tcm_dec_symb_m_asm__isymb_m          ;
  symb_m_sign_t tcm_dec_symb_m_asm__isymb_m_sign     ;
  logic         tcm_dec_symb_m_asm__osop             ;
  logic         tcm_dec_symb_m_asm__oval             ;
  logic         tcm_dec_symb_m_asm__oeop             ;
  symb_m_t      tcm_dec_symb_m_asm__osymb_m      [4] ;
  symb_m_sign_t tcm_dec_symb_m_asm__osymb_m_sign [4] ;



  tcm_dec_symb_m_asm
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_dec_symb_m_asm
  (
    .iclk         ( tcm_dec_symb_m_asm__iclk         ) ,
    .ireset       ( tcm_dec_symb_m_asm__ireset       ) ,
    .iclkena      ( tcm_dec_symb_m_asm__iclkena      ) ,
    .i1sps        ( tcm_dec_symb_m_asm__i1sps        ) ,
    .isop         ( tcm_dec_symb_m_asm__isop         ) ,
    .ival         ( tcm_dec_symb_m_asm__ival         ) ,
    .ieop         ( tcm_dec_symb_m_asm__ieop         ) ,
    .isymb_m      ( tcm_dec_symb_m_asm__isymb_m      ) ,
    .isymb_m_sign ( tcm_dec_symb_m_asm__isymb_m_sign ) ,
    .osop         ( tcm_dec_symb_m_asm__osop         ) ,
    .oval         ( tcm_dec_symb_m_asm__oval         ) ,
    .oeop         ( tcm_dec_symb_m_asm__oeop         ) ,
    .osymb_m      ( tcm_dec_symb_m_asm__osymb_m      ) ,
    .osymb_m_sign ( tcm_dec_symb_m_asm__osymb_m_sign )
  );


  assign tcm_dec_symb_m_asm__iclk         = '0 ;
  assign tcm_dec_symb_m_asm__ireset       = '0 ;
  assign tcm_dec_symb_m_asm__iclkena      = '0 ;
  assign tcm_dec_symb_m_asm__i1sps        = '0 ;
  assign tcm_dec_symb_m_asm__isop         = '0 ;
  assign tcm_dec_symb_m_asm__ival         = '0 ;
  assign tcm_dec_symb_m_asm__ieop         = '0 ;
  assign tcm_dec_symb_m_asm__isymb_m      = '0 ;
  assign tcm_dec_symb_m_asm__isymb_m_sign = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_symb_m_asm.sv
// Description   : 4D symbol metric assembler
//

`include "define.vh"

module tcm_dec_symb_m_asm
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  i1sps         ,
  //
  isop          ,
  ival          ,
  ieop          ,
  isymb_m       ,
  isymb_m_sign  ,
  //
  osop          ,
  oval          ,
  oeop          ,
  osymb_m       ,
  osymb_m_sign
);

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk             ;
  input  logic          ireset           ;
  input  logic          iclkena          ;
  // 8PSK interface
  input  logic          i1sps            ; // symbol frequency
  //
  input  logic          isop             ;
  input  logic          ival             ; // first symbol of 4D symbol
  input  logic          ieop             ;
  input  symb_m_t       isymb_m          ;
  input  symb_m_sign_t  isymb_m_sign     ;
  // 4D 8PSK interface
  output logic          osop             ;
  output logic          oval             ;
  output logic          oeop             ;
  output symb_m_t       osymb_m      [4] ;
  output symb_m_sign_t  osymb_m_sign [4] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] symb_cnt;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (i1sps) begin
        symb_cnt  <= ival ? 1'b1 : (symb_cnt + 1'b1);
        // (Z0, Z1, Z2, Z3}, Z0 - first
        osymb_m     [3] <= isymb_m;
        osymb_m_sign[3] <= isymb_m_sign;
        for (int i = 0; i < 3; i++) begin
          osymb_m     [i] <= osymb_m      [i+1];
          osymb_m_sign[i] <= osymb_m_sign [i+1];
        end
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      osop <= 1'b0;
      oval <= 1'b0;
      oeop <= 1'b0;
    end
    else if (iclkena) begin
      oval <= i1sps & !ival & &symb_cnt;
      //
      if (i1sps & isop) begin
        osop <= 1'b1;
      end
      else if (oval) begin
        osop <= 1'b0;
      end
      //
      if (i1sps & ieop) begin
        oeop <= 1'b1;
      end
      else if (oval) begin
        oeop <= 1'b0;
      end
    end
  end

endmodule
