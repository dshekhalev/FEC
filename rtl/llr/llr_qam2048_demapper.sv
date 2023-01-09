/*



  parameter int pDAT_W    = 8 ;
  parameter int pLLR_W    = 4 ;
  parameter bit pUSE_RAMB = 0 ;



  logic                       llr_qam2048_demapper__iclk             ;
  logic                       llr_qam2048_demapper__ireset           ;
  logic                       llr_qam2048_demapper__iclkena          ;
  logic                       llr_qam2048_demapper__ival             ;
  logic                       llr_qam2048_demapper__isop             ;
  logic               [3 : 0] llr_qam2048_demapper__iqam             ;
  logic signed [pDAT_W-1 : 0] llr_qam2048_demapper__idat_re          ;
  logic signed [pDAT_W-1 : 0] llr_qam2048_demapper__idat_im          ;
  logic                       llr_qam2048_demapper__oval             ;
  logic                       llr_qam2048_demapper__osop             ;
  logic               [3 : 0] llr_qam2048_demapper__oqam             ;
  logic signed [pLLR_W-1 : 0] llr_qam2048_demapper__oLLR    [0 : 10] ;



  llr_qam2048_demapper
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pLLR_W    ( pLLR_W    ) ,
    .pUSE_RAMB ( pUSE_RAMB )
  )
  llr_qam2048_demapper
  (
    .iclk    ( llr_qam2048_demapper__iclk    ) ,
    .ireset  ( llr_qam2048_demapper__ireset  ) ,
    .iclkena ( llr_qam2048_demapper__iclkena ) ,
    .ival    ( llr_qam2048_demapper__ival    ) ,
    .isop    ( llr_qam2048_demapper__isop    ) ,
    .iqam    ( llr_qam2048_demapper__iqam    ) ,
    .idat_re ( llr_qam2048_demapper__idat_re ) ,
    .idat_im ( llr_qam2048_demapper__idat_im ) ,
    .oval    ( llr_qam2048_demapper__oval    ) ,
    .osop    ( llr_qam2048_demapper__osop    ) ,
    .oqam    ( llr_qam2048_demapper__oqam    ) ,
    .oLLR    ( llr_qam2048_demapper__oLLR    )
  );


  assign llr_qam2048_demapper__iclk    = '0 ;
  assign llr_qam2048_demapper__ireset  = '0 ;
  assign llr_qam2048_demapper__iclkena = '0 ;
  assign llr_qam2048_demapper__ival    = '0 ;
  assign llr_qam2048_demapper__isop    = '0 ;
  assign llr_qam2048_demapper__iqam    = '0 ;
  assign llr_qam2048_demapper__idat_re = '0 ;
  assign llr_qam2048_demapper__idat_im = '0 ;



*/

//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : llr_qam2048_demapper.sv
// Description   : QAM2048 LLR demapper for LLR == 4 bit only
//

module llr_qam2048_demapper
#(
  parameter int pDAT_W    = 9 , // fixed, don't change
  parameter int pLLR_W    = 4 , // fixed, don't change
  parameter bit pUSE_RAMB = 0
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  iqam    ,
  idat_re ,
  idat_im ,
  //
  oval    ,
  osop    ,
  oqam    ,
  oLLR
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk            ;
  input  logic                       ireset          ;
  input  logic                       iclkena         ;
  //
  input  logic                       ival            ;
  input  logic                       isop            ;
  input  logic               [3 : 0] iqam            ;
  input  logic signed [pDAT_W-1 : 0] idat_re         ;
  input  logic signed [pDAT_W-1 : 0] idat_im         ;
  //
  output logic                       oval            ;
  output logic                       osop            ;
  output logic               [3 : 0] oqam            ;
  output logic signed [pLLR_W-1 : 0] oLLR    [0 :10] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic signed [pDAT_W-1 : 0] this_t;
  typedef logic signed [pLLR_W-1 : 0] llr_t;

  localparam this_t cONE      =  2**(pLLR_W-2);

  localparam this_t cEDGE_POS =  48*cONE-1;
  localparam this_t cEDGE_NEG = -48*cONE+1;  // it's pointers, not data

  localparam this_t cMAX_POS  =  2*cONE-1;
`ifdef MODEL_TECH
  localparam this_t cMIN_NEG  = -2*cONE+1;
`else
  localparam this_t cMIN_NEG  = -2*cONE;    // can do so, it's data
`endif

  localparam this_t cLEVEL_2  =  2*cONE;
  localparam this_t cLEVEL_4  =  4*cONE;
  localparam this_t cLEVEL_6  =  6*cONE;
  localparam this_t cLEVEL_8  =  8*cONE;
  localparam this_t cLEVEL_10 = 10*cONE;
  localparam this_t cLEVEL_12 = 12*cONE;
  localparam this_t cLEVEL_14 = 14*cONE;
  localparam this_t cLEVEL_16 = 16*cONE;
  localparam this_t cLEVEL_18 = 18*cONE;
  localparam this_t cLEVEL_20 = 20*cONE;
  localparam this_t cLEVEL_22 = 22*cONE;
  localparam this_t cLEVEL_24 = 24*cONE;
  localparam this_t cLEVEL_26 = 26*cONE;
  localparam this_t cLEVEL_28 = 28*cONE;
  localparam this_t cLEVEL_30 = 30*cONE;
  localparam this_t cLEVEL_32 = 32*cONE;
  localparam this_t cLEVEL_34 = 34*cONE;
  localparam this_t cLEVEL_36 = 36*cONE;
  localparam this_t cLEVEL_38 = 38*cONE;
  localparam this_t cLEVEL_40 = 40*cONE;
  localparam this_t cLEVEL_42 = 42*cONE;
  localparam this_t cLEVEL_44 = 44*cONE;
  localparam this_t cLEVEL_46 = 46*cONE;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [3 : 0] sop;
  logic [3 : 0] val;
  logic [3 : 0] qam [4];

  this_t        dat_re, dat4sat_re;
  this_t        dat_im, dat4sat_im;

  this_t        adat_re, are;
  this_t        adat_im, aim;

  this_t        addr_re;
  this_t        addr_re_m_8;
  this_t        addr_re_m_24;
  this_t        addr_re_m_32;

  this_t        addr_im;
  this_t        addr_im_m_24;
  this_t        addr_im_m_30;
  this_t        addr_im_m_32;

  logic         adat_re_less4;
  logic         adat_re_less8;
  logic         adat_re_less12;
  logic         adat_re_less16;
  logic         adat_re_less20;
  logic         adat_re_less24;
  logic         adat_re_less28;
  logic         adat_re_less32;
  logic         adat_re_less36;
  logic         adat_re_less40;
  logic         adat_re_less44;

  logic         adat_re_more24;
  logic         adat_re_more40;

  logic         adat_im_less4;
  logic         adat_im_less8;
  logic         adat_im_less12;
  logic         adat_im_less16;
  logic         adat_im_less20;
  logic         adat_im_less24;
  logic         adat_im_less28;
  logic         adat_im_less30;
  logic         adat_im_less32;
  logic         adat_im_less36;
  logic         adat_im_less40;
  logic         adat_im_less44;

  logic         adat_im_more38;
  logic         adat_im_more40;

  llr_t         bit0_llr [3 : 3];
  llr_t         bit1_llr [3 : 3];
  llr_t         bit2_llr [3 : 3];
  llr_t         bit3_llr [3 : 3];
  llr_t         bit4_llr [1 : 3]  /*synthesis keep*/;
  llr_t         bit5_llr [3 : 3];
  llr_t         bit6_llr [3 : 3];
  llr_t         bit7_llr [3 : 3];
  llr_t         bit8_llr [3 : 3];
  llr_t         bit9_llr [3 : 3];
  llr_t         bit10_llr [1 : 3] /*synthesis keep*/;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val   <= '0;
      oval  <= 1'b0;
    end
    else if (iclkena) begin
      val   <= (val << 1) | ival;
      oval  <= val[3];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | isop;
      qam[0] <= iqam;
      for (int i = 1; i < 4; i++) begin
        qam[i] <= qam[i-1];
      end
      //
      // ival
      dat_re <= idat_re;
      dat_im <= idat_im;
    end
  end


  generate
    if (pUSE_RAMB) begin

      `include "llr_qam2048_tab_part.svh"

      assign dat4sat_re = saturate(dat_re, cEDGE_NEG, cEDGE_POS);
      assign dat4sat_im = saturate(dat_im, cEDGE_NEG, cEDGE_POS);

      assign are        = (dat4sat_re < 0) ? -dat4sat_re : dat4sat_re;
      assign aim        = (dat4sat_im < 0) ? -dat4sat_im : dat4sat_im;

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          //
          // val[0]
          bit4_llr [1]    <= saturate_llr(-dat4sat_im);
          bit10_llr[1]    <= saturate_llr( dat4sat_re);

          addr_re         <= are;
          addr_re_m_8     <= are - cLEVEL_8;
          addr_re_m_24    <= are - cLEVEL_24;
          addr_re_m_32    <= are - cLEVEL_32;

          addr_im         <= aim;
          addr_im_m_24    <= aim - cLEVEL_24;
          addr_im_m_30    <= aim - cLEVEL_30;
          addr_im_m_32    <= aim - cLEVEL_32;

          //
          // val[1]
          bit4_llr [2]    <= bit4_llr [1];
          bit10_llr[2]    <= bit10_llr[1];

          adat_re         <=  addr_re;
          adat_im         <=  addr_im;

          adat_re_less4   <= (addr_re <= cLEVEL_4);
          adat_re_less8   <= (addr_re <= cLEVEL_8);
          adat_re_less12  <= (addr_re <= cLEVEL_12);
          adat_re_less16  <= (addr_re <= cLEVEL_16);
          adat_re_less20  <= (addr_re <= cLEVEL_20);
          adat_re_less24  <= (addr_re <= cLEVEL_24);
          adat_re_less28  <= (addr_re <= cLEVEL_28);
          adat_re_less32  <= (addr_re <= cLEVEL_32);
          adat_re_less36  <= (addr_re <= cLEVEL_36);
          adat_re_less40  <= (addr_re <= cLEVEL_40);
          adat_re_less44  <= (addr_re <= cLEVEL_44);

          adat_re_more24  <= (addr_re >= cLEVEL_24);
          adat_re_more40  <= (addr_re >= cLEVEL_40);

          adat_im_less4   <= (addr_im <= cLEVEL_4);
          adat_im_less8   <= (addr_im <= cLEVEL_8);
          adat_im_less12  <= (addr_im <= cLEVEL_12);
          adat_im_less16  <= (addr_im <= cLEVEL_16);
          adat_im_less20  <= (addr_im <= cLEVEL_20);
          adat_im_less24  <= (addr_im <= cLEVEL_24);
          adat_im_less28  <= (addr_im <= cLEVEL_28);
          adat_im_less30  <= (addr_im <= cLEVEL_30);
          adat_im_less32  <= (addr_im <= cLEVEL_32);
          adat_im_less36  <= (addr_im <= cLEVEL_36);
          adat_im_less40  <= (addr_im <= cLEVEL_40);
          adat_im_less44  <= (addr_im <= cLEVEL_44);

          adat_im_more38  <= (addr_im >= cLEVEL_38);
          adat_im_more40  <= (addr_im >= cLEVEL_40);
          //
          // val[2]
          bit4_llr [3]    <= bit4_llr [2];
          bit10_llr[3]    <= bit10_llr[2];
        end
      end

      logic  bit_tab_sel      [10];
      this_t bit_math_dat     [10];
      llr_t  bit_tab_dat      [10];
      llr_t  bit_tab_dat_reg  [10];

      always @(posedge iclk) begin
        if (iclkena) begin
          // val[1]
          bit_tab_dat[9]  <= cQAM2048_BIT9_LLR_TAB[{addr_im_m_24[5:0], addr_re_m_24[5:0]}];

          bit_tab_dat[8]  <= cQAM2048_BIT8_LLR_TAB[{addr_im_m_30[4:0], addr_re     [7:0]}];

          bit_tab_dat[7]  <= cQAM2048_BIT7_LLR_TAB[{addr_im_m_24[5:0], addr_re_m_32[5:0]}];
          bit_tab_dat[6]  <= cQAM2048_BIT6_LLR_TAB[{addr_im_m_24[5:0], addr_re_m_32[5:0]}];
          bit_tab_dat[5]  <= cQAM2048_BIT5_LLR_TAB[{addr_im_m_24[5:0], addr_re_m_32[5:0]}];

          bit_tab_dat[3]  <= cQAM2048_BIT3_LLR_TAB[{addr_im_m_24[5:0], addr_re_m_8 [5:0]}];

          bit_tab_dat[2]  <= cQAM2048_BIT2_LLR_TAB[{addr_im_m_32[5:0], addr_re_m_24[5:0]}];
          bit_tab_dat[1]  <= cQAM2048_BIT1_LLR_TAB[{addr_im_m_32[5:0], addr_re_m_24[5:0]}];
          bit_tab_dat[0]  <= cQAM2048_BIT0_LLR_TAB[{addr_im_m_32[5:0], addr_re_m_24[5:0]}];

          // val[2]
          bit_tab_dat_reg <= bit_tab_dat;

          bit_tab_sel[9]  <= !adat_im_less24 & !adat_re_less24 & !adat_im_more40 & !adat_re_more40;

          bit_tab_sel[8]  <= !adat_im_less30 & !adat_im_more38;

          bit_tab_sel[7]  <= !adat_re_less32 & !adat_im_less24 & !adat_im_more40;
          bit_tab_sel[6]  <= !adat_re_less32 & !adat_im_less24 & !adat_im_more40;
          bit_tab_sel[5]  <= !adat_re_less32 & !adat_im_less24 & !adat_im_more40;

          bit_tab_sel[3]  <= !adat_im_less24 & !adat_im_more40 & !adat_re_less8 & !adat_re_more24;

          bit_tab_sel[2]  <= !adat_im_less32 & !adat_re_less24 & !adat_re_more40;
          bit_tab_sel[1]  <= !adat_im_less32 & !adat_re_less24 & !adat_re_more40;
          bit_tab_sel[0]  <= !adat_im_less32 & !adat_re_less24 & !adat_re_more40;

          // bit 9
          if (adat_im_less30)
            bit_math_dat[9] <= cLEVEL_32 - adat_re;
          else if (adat_re_less24)
            bit_math_dat[9] <= cLEVEL_32 - adat_im;
          else
            bit_math_dat[9] <= -7;

          // bit 8
          if (adat_im_less30)
            bit_math_dat[8] <= adat_re - cLEVEL_16;
          else
            bit_math_dat[8] <= -7;

          // bit 7
          if (adat_re_less16)
            bit_math_dat[7] <= adat_re - cLEVEL_8;
          else if (adat_re_less32)
            bit_math_dat[7] <= cLEVEL_24 - adat_re;
          else if (adat_im_less24)
            bit_math_dat[7] <= adat_re - cLEVEL_40;
          else
            bit_math_dat[7] <= -7;
          // bit 6
          if (adat_re_less8)
            bit_math_dat[6] <= adat_re - cLEVEL_4;
          else if (adat_re_less16)
            bit_math_dat[6] <= cLEVEL_12 - adat_re;
          else if (adat_re_less24)
            bit_math_dat[6] <= adat_re - cLEVEL_20;
          else if (adat_re_less32)
            bit_math_dat[6] <= cLEVEL_28 - adat_re;
          else if (adat_im_less24) begin
            if (adat_re_less40)
              bit_math_dat[6] <= adat_re - cLEVEL_36;
            else
              bit_math_dat[6] <= cLEVEL_44 - adat_re;
          end
          else
            bit_math_dat[6] <= -7;
          // bit 5
          if (adat_re_less4)
            bit_math_dat[5] <= adat_re - cLEVEL_2;
          else if (adat_re_less8)
            bit_math_dat[5] <= cLEVEL_6 - adat_re;
          else if (adat_re_less12)
            bit_math_dat[5] <= adat_re - cLEVEL_10;
          else if (adat_re_less16)
            bit_math_dat[5] <= cLEVEL_14 - adat_re;
          else if (adat_re_less20)
            bit_math_dat[5] <= adat_re - cLEVEL_18;
          else if (adat_re_less24)
            bit_math_dat[5] <= cLEVEL_22 - adat_re;
          else if (adat_re_less28)
            bit_math_dat[5] <= adat_re - cLEVEL_26;
          else if (adat_re_less32)
            bit_math_dat[5] <= cLEVEL_30 - adat_re;
          else if (adat_im_less24) begin
            if (adat_re_less36)
              bit_math_dat[5] <= adat_re - cLEVEL_34;
            else if (adat_re_less40)
              bit_math_dat[5] <= cLEVEL_38 - adat_re;
            else if (adat_re_less44)
              bit_math_dat[5] <= adat_re - cLEVEL_42;
            else
              bit_math_dat[5] <= cLEVEL_46 - adat_re;
          end
          else
            bit_math_dat[5] <= -7;

          // bit 3
          if (adat_im_less24)
            bit_math_dat[3] <= cLEVEL_16 - adat_im;
          else if (adat_im_more40)
            bit_math_dat[3] <= cLEVEL_16 - adat_re;
          else if (adat_re_less8)
            bit_math_dat[3] <= adat_im - cLEVEL_32;
          else
            bit_math_dat[3] <= -7;

          // bit 2
          if (adat_im_less16)
            bit_math_dat[2] <= adat_im - cLEVEL_8;
          else if (adat_im_less32)
            bit_math_dat[2] <= cLEVEL_24 - adat_im;
          else if (adat_re_less24)
            bit_math_dat[2] <= adat_im - cLEVEL_40;
          else
            bit_math_dat[2] <= -7;
          // bit 1
          if (adat_im_less8)
            bit_math_dat[1] <= adat_im - cLEVEL_4;
          else if (adat_im_less16)
            bit_math_dat[1] <= cLEVEL_12 - adat_im;
          else if (adat_im_less24)
            bit_math_dat[1] <= adat_im - cLEVEL_20;
          else if (adat_im_less32)
            bit_math_dat[1] <= cLEVEL_28 - adat_im;
          else if (adat_re_less24) begin
            if (adat_im_less40)
              bit_math_dat[1] <= adat_im - cLEVEL_36;
            else
              bit_math_dat[1] <= cLEVEL_44 - adat_im;
          end
          else
            bit_math_dat[1] <= -7;
          // bit 0
          if (adat_im_less4)
            bit_math_dat[0] <= adat_im - cLEVEL_2;
          else if (adat_im_less8)
            bit_math_dat[0] <= cLEVEL_6 - adat_im;
          else if (adat_im_less12)
            bit_math_dat[0] <= adat_im - cLEVEL_10;
          else if (adat_im_less16)
            bit_math_dat[0] <= cLEVEL_14 - adat_im;
          else if (adat_im_less20)
            bit_math_dat[0] <= adat_im - cLEVEL_18;
          else if (adat_im_less24)
            bit_math_dat[0] <= cLEVEL_22 - adat_im;
          else if (adat_im_less28)
            bit_math_dat[0] <= adat_im - cLEVEL_26;
          else if (adat_im_less32)
            bit_math_dat[0] <= cLEVEL_30 - adat_im;
          else if (adat_re_less24) begin
            if (adat_im_less36)
              bit_math_dat[0] <= adat_im - cLEVEL_34;
            else if (adat_im_less40)
              bit_math_dat[0] <= cLEVEL_38 - adat_im;
            else if (adat_im_less44)
              bit_math_dat[0] <= adat_im - cLEVEL_42;
            else
              bit_math_dat[0] <= cLEVEL_46 - adat_im;
          end
          else
            bit_math_dat[0] <= -7;
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          // val[3]
          osop    <= sop[3];
          oqam    <= qam[3];

          oLLR[0] <= bit_tab_sel[0] ? bit_tab_dat_reg[0] : saturate_llr(bit_math_dat[0]);
          oLLR[1] <= bit_tab_sel[1] ? bit_tab_dat_reg[1] : saturate_llr(bit_math_dat[1]);
          oLLR[2] <= bit_tab_sel[2] ? bit_tab_dat_reg[2] : saturate_llr(bit_math_dat[2]);
          oLLR[3] <= bit_tab_sel[3] ? bit_tab_dat_reg[3] : saturate_llr(bit_math_dat[3]);

          oLLR[4] <= bit4_llr[3];

          oLLR[5] <= bit_tab_sel[5] ? bit_tab_dat_reg[5] : saturate_llr(bit_math_dat[5]);
          oLLR[6] <= bit_tab_sel[6] ? bit_tab_dat_reg[6] : saturate_llr(bit_math_dat[6]);
          oLLR[7] <= bit_tab_sel[7] ? bit_tab_dat_reg[7] : saturate_llr(bit_math_dat[7]);

          oLLR[8] <= bit_tab_sel[8] ? bit_tab_dat_reg[8] : saturate_llr(bit_math_dat[8]);

          oLLR[9] <= bit_tab_sel[9] ? bit_tab_dat_reg[9] : saturate_llr(bit_math_dat[9]);

          oLLR[10] <= bit10_llr[3];
        end
      end

    end
    else begin

      `include "llr_qam2048_tab_full.svh"

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          //
          // val[0]
          dat4sat_re  <= saturate(dat_re, cEDGE_NEG, cEDGE_POS);
          dat4sat_im  <= saturate(dat_im, cEDGE_NEG, cEDGE_POS);
          //
          // val[1]
          bit4_llr [2] <= saturate_llr(-dat4sat_im);
          bit10_llr[2] <= saturate_llr( dat4sat_re);

          adat_re     <= (dat4sat_re < 0) ? -dat4sat_re : dat4sat_re;
          adat_im     <= (dat4sat_im < 0) ? -dat4sat_im : dat4sat_im;
          //
          // val[2]
          bit4_llr [3] <= bit4_llr [2];
          bit10_llr[3] <= bit10_llr[2];

          are         <= adat_re;
          aim         <= adat_im;
        end
      end

      llr_t  bit9_llr_sub_tab [12][12];
      llr_t  bit8_llr_sub_tab [12][12];
      llr_t  bit7_llr_sub_tab [12][12];
      llr_t  bit6_llr_sub_tab [12][12];
      llr_t  bit5_llr_sub_tab [12][12];

      llr_t  bit3_llr_sub_tab [12][12];
      llr_t  bit2_llr_sub_tab [12][12];
      llr_t  bit1_llr_sub_tab [12][12];
      llr_t  bit0_llr_sub_tab [12][12];

      always @(posedge iclk) begin
        if (iclkena) begin
          for (int im = 0; im < 12; im++) begin : im_gen
            for (int re = 0; re < 12; re++) begin : re_gen
              // val[2]
              bit9_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT9_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
              bit8_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT8_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
              bit7_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT7_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
              bit6_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT6_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
              bit5_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT5_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];

              bit3_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT3_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
              bit2_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT2_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
              bit1_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT1_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
              bit0_llr_sub_tab[im[3:0]][re[3:0]] <= cQAM2048_BIT0_LLR[{im[3:0], adat_im[3:0]}][{re[3:0], adat_re[3:0]}];
            end
          end
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          // val[3]
          osop      <= sop[3];
          oqam      <= qam[3];

          oLLR[0]   <= bit0_llr_sub_tab[aim[7:4]][are[7:4]];
          oLLR[1]   <= bit1_llr_sub_tab[aim[7:4]][are[7:4]];
          oLLR[2]   <= bit2_llr_sub_tab[aim[7:4]][are[7:4]];
          oLLR[3]   <= bit3_llr_sub_tab[aim[7:4]][are[7:4]];

          oLLR[4]   <= bit4_llr[3];

          oLLR[5]   <= bit5_llr_sub_tab[aim[7:4]][are[7:4]];
          oLLR[6]   <= bit6_llr_sub_tab[aim[7:4]][are[7:4]];
          oLLR[7]   <= bit7_llr_sub_tab[aim[7:4]][are[7:4]];
          oLLR[8]   <= bit8_llr_sub_tab[aim[7:4]][are[7:4]];
          oLLR[9]   <= bit9_llr_sub_tab[aim[7:4]][are[7:4]];

          oLLR[10]  <= bit10_llr[3];
        end
      end

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function automatic this_t saturate (input this_t dat, this_t min, max);
    logic poverflow;
    logic noverflow;
  begin
    poverflow = (dat > max);
    noverflow = (dat < min);
    //
    if (poverflow | noverflow)
      saturate = poverflow ? max : min;
    else
      saturate = dat;
  end
  endfunction

  function automatic logic signed [pLLR_W-1 : 0] saturate_llr (input this_t dat);
    logic poverflow;
    logic noverflow;
  begin
    poverflow = (dat > cMAX_POS);
    noverflow = (dat < cMIN_NEG);
    //
    if (poverflow | noverflow)
      saturate_llr = poverflow ? cMAX_POS[pLLR_W-1 : 0] : cMIN_NEG[pLLR_W-1 : 0];
    else
      saturate_llr = dat[pLLR_W-1 : 0];
  end
  endfunction

endmodule
