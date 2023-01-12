/*


  parameter int pBMAX   = 10 ;
  parameter int pDAT_W  =  8 ;
  parameter int pLLR_W  =  4 ;



  logic                       llr_even_qam_demapper_core__iclk            ;
  logic                       llr_even_qam_demapper_core__ireset          ;
  logic                       llr_even_qam_demapper_core__iclkena         ;
  logic                       llr_even_qam_demapper_core__ival            ;
  logic                       llr_even_qam_demapper_core__isop            ;
  logic               [3 : 0] llr_even_qam_demapper_core__iqam            ;
  logic signed [pDAT_W-1 : 0] llr_even_qam_demapper_core__idat            ;
  logic                       llr_even_qam_demapper_core__oval            ;
  logic                       llr_even_qam_demapper_core__osop            ;
  logic               [3 : 0] llr_even_qam_demapper_core__oqam            ;
  logic signed [pLLR_W-1 : 0] llr_even_qam_demapper_core__oLLR    [0 : 5] ;



  llr_even_qam_demapper_core
  #(
    .pBMAX  ( pBMAX  ) ,
    .pDAT_W ( pDAT_W ) ,
    .pLLR_W ( pLLR_W )
  )
  llr_even_qam_demapper_core
  (
    .iclk    ( llr_even_qam_demapper_core__iclk    ) ,
    .ireset  ( llr_even_qam_demapper_core__ireset  ) ,
    .iclkena ( llr_even_qam_demapper_core__iclkena ) ,
    .ival    ( llr_even_qam_demapper_core__ival    ) ,
    .isop    ( llr_even_qam_demapper_core__isop    ) ,
    .iqam    ( llr_even_qam_demapper_core__iqam    ) ,
    .idat    ( llr_even_qam_demapper_core__idat    ) ,
    .oval    ( llr_even_qam_demapper_core__oval    ) ,
    .osop    ( llr_even_qam_demapper_core__osop    ) ,
    .oqam    ( llr_even_qam_demapper_core__oqam    ) ,
    .oLLR    ( llr_even_qam_demapper_core__oLLR    )
  );


  assign llr_even_qam_demapper_core__iclk    = '0 ;
  assign llr_even_qam_demapper_core__ireset  = '0 ;
  assign llr_even_qam_demapper_core__iclkena = '0 ;
  assign llr_even_qam_demapper_core__ival    = '0 ;
  assign llr_even_qam_demapper_core__isop    = '0 ;
  assign llr_even_qam_demapper_core__iqam    = '0 ;
  assign llr_even_qam_demapper_core__idat    = '0 ;



*/

//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : llr_even_qam_demapper_core.sv
// Description   : even QAM : QPSK, QAM16, QAM64, QAM256, QAM1024, QAM4096 LLR demapper
//                 Module work with LSB first endian. Module delay is 6 tick.
//

module llr_even_qam_demapper_core
#(
  parameter int pBMAX   = 12 ,
  parameter int pDAT_W  =  9 ,  // must be pLLR_W + (bits_per_symbol/2-1)
  parameter int pLLR_W  =  4    //
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  iqam    ,
  idat    ,
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
  input  logic signed [pDAT_W-1 : 0] idat            ;
  //
  output logic                       oval            ;
  output logic                       osop            ;
  output logic               [3 : 0] oqam            ;
  output logic signed [pLLR_W-1 : 0] oLLR    [0 : 5] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic signed [pDAT_W-1 : 0] this_t;

  localparam this_t cEDGE_1   = 2**(pDAT_W-2);
  localparam this_t cEDGE_2   = cEDGE_1/2;
  localparam this_t cEDGE_3   = cEDGE_2/2;
  localparam this_t cEDGE_4   = cEDGE_3/2;
  localparam this_t cEDGE_5   = cEDGE_4/2;

  localparam this_t cONE      =  2**(pLLR_W-2);
  localparam this_t cMAX_POS  =  2*cONE-1;
  localparam this_t cMIN_NEG  = -2*cONE;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [4 : 0] sop;
  logic [4 : 0] val;
  logic [3 : 0] qam [5];

  this_t        bit0_llr     [0 : 4];
  this_t        bit1_llr     [0 : 4];
  this_t        bit2_llr     [1 : 4];
  this_t        bit3_llr     [2 : 4];
  this_t        bit4_llr     [3 : 4];
  this_t        bit5_llr     [4 : 4];

  logic         bit0_lsb_llr [0 : 4];
  logic         bit1_lsb_llr [0 : 4];
  logic         bit2_lsb_llr [1 : 4];
  logic         bit3_lsb_llr [2 : 4];
  logic         bit4_lsb_llr [3 : 4];
  logic         bit5_lsb_llr [3 : 4];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | isop;
      qam[0] <= iqam;
      for (int i = 1; i < 5; i++) begin
        qam[i] <= qam[i-1];
      end
      // stage 0
      bit0_llr[0]     <= (iqam <= 2) ? (idat >>> 1) : idat;
      bit1_llr[0]     <= sub_abs(cEDGE_1, idat);

      bit0_lsb_llr[0] <= (iqam <= 2) ?  idat[0]     : 1'b0;
      bit1_lsb_llr[0] <= 1'b0;
      // stage 1
      bit0_llr[1]     <= (qam[0] <= 4 & (pBMAX > 4)) ? (bit0_llr[0] >>> 1)  : bit0_llr[0];
      bit1_llr[1]     <= (qam[0] <= 4 & (pBMAX > 4)) ? (bit1_llr[0] >>> 1)  : bit1_llr[0];
      bit2_llr[1]     <= sub_abs(cEDGE_2, bit1_llr[0]);

      bit0_lsb_llr[1] <= (qam[0] <= 4 & (pBMAX > 4)) ?  bit0_llr[0][0]      : bit0_lsb_llr[0];
      bit1_lsb_llr[1] <= (qam[0] <= 4 & (pBMAX > 4)) ?  bit1_llr[0][0]      : bit1_lsb_llr[0];
      bit2_lsb_llr[1] <= 1'b0;
      // stage 2
      bit0_llr[2]     <= (qam[1] <= 6 & (pBMAX > 6)) ? (bit0_llr[1] >>> 1)  : bit0_llr[1];
      bit1_llr[2]     <= (qam[1] <= 6 & (pBMAX > 6)) ? (bit1_llr[1] >>> 1)  : bit1_llr[1];
      bit2_llr[2]     <= (qam[1] <= 6 & (pBMAX > 6)) ? (bit2_llr[1] >>> 1)  : bit2_llr[1];
      bit3_llr[2]     <= sub_abs(cEDGE_3, bit2_llr[1]);

      bit0_lsb_llr[2] <= (qam[1] <= 6 & (pBMAX > 6)) ?  bit0_llr[1][0]      : bit0_lsb_llr[1];
      bit1_lsb_llr[2] <= (qam[1] <= 6 & (pBMAX > 6)) ?  bit1_llr[1][0]      : bit1_lsb_llr[1];
      bit2_lsb_llr[2] <= (qam[1] <= 6 & (pBMAX > 6)) ?  bit2_llr[1][0]      : bit2_lsb_llr[1];
      bit3_lsb_llr[2] <= 1'b0;
      // stage 3
      bit0_llr[3]     <= (qam[2] <= 8 & (pBMAX > 8)) ? (bit0_llr[2] >>> 1)  : bit0_llr[2];
      bit1_llr[3]     <= (qam[2] <= 8 & (pBMAX > 8)) ? (bit1_llr[2] >>> 1)  : bit1_llr[2];
      bit2_llr[3]     <= (qam[2] <= 8 & (pBMAX > 8)) ? (bit2_llr[2] >>> 1)  : bit2_llr[2];
      bit3_llr[3]     <= (qam[2] <= 8 & (pBMAX > 8)) ? (bit3_llr[2] >>> 1)  : bit3_llr[2];
      bit4_llr[3]     <= sub_abs(cEDGE_4, bit3_llr[2]);

      bit0_lsb_llr[3] <= (qam[2] <= 8 & (pBMAX > 8)) ?  bit0_llr[2][0]      : bit0_lsb_llr[2];
      bit1_lsb_llr[3] <= (qam[2] <= 8 & (pBMAX > 8)) ?  bit1_llr[2][0]      : bit1_lsb_llr[2];
      bit2_lsb_llr[3] <= (qam[2] <= 8 & (pBMAX > 8)) ?  bit2_llr[2][0]      : bit2_lsb_llr[2];
      bit3_lsb_llr[3] <= (qam[2] <= 8 & (pBMAX > 8)) ?  bit3_llr[2][0]      : bit3_lsb_llr[2];
      bit4_lsb_llr[3] <= 1'b0;
      // stage 4
      bit0_llr[4]     <= (qam[3] <= 10 & (pBMAX > 10)) ? (bit0_llr[3] >>> 1) : bit0_llr[3];
      bit1_llr[4]     <= (qam[3] <= 10 & (pBMAX > 10)) ? (bit1_llr[3] >>> 1) : bit1_llr[3];
      bit2_llr[4]     <= (qam[3] <= 10 & (pBMAX > 10)) ? (bit2_llr[3] >>> 1) : bit2_llr[3];
      bit3_llr[4]     <= (qam[3] <= 10 & (pBMAX > 10)) ? (bit3_llr[3] >>> 1) : bit3_llr[3];
      bit4_llr[4]     <= (qam[3] <= 10 & (pBMAX > 10)) ? (bit4_llr[3] >>> 1) : bit4_llr[3];
      bit5_llr[4]     <= sub_abs(cEDGE_5,  bit4_llr[3]);

      bit0_lsb_llr[4] <= (qam[3] <= 10 & (pBMAX > 10)) ?  bit0_llr[3][0]     : bit0_lsb_llr[3];
      bit1_lsb_llr[4] <= (qam[3] <= 10 & (pBMAX > 10)) ?  bit1_llr[3][0]     : bit1_lsb_llr[3];
      bit2_lsb_llr[4] <= (qam[3] <= 10 & (pBMAX > 10)) ?  bit2_llr[3][0]     : bit2_lsb_llr[3];
      bit3_lsb_llr[4] <= (qam[3] <= 10 & (pBMAX > 10)) ?  bit3_llr[3][0]     : bit3_lsb_llr[3];
      bit4_lsb_llr[4] <= (qam[3] <= 10 & (pBMAX > 10)) ?  bit4_llr[3][0]     : bit4_lsb_llr[3];
      bit5_lsb_llr[4] <= 1'b0;
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val   <= '0;
      oval  <= 1'b0;
    end
    else if (iclkena) begin
      val   <= (val << 1) | ival;
      oval  <= val[4];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val[4]) begin
        osop    <= sop[4];
        oqam    <= qam[4];
        oLLR[0] <= saturate_llr(bit0_llr[4] + bit0_lsb_llr[4]);
        oLLR[1] <= saturate_llr(bit1_llr[4] + bit1_lsb_llr[4]);
        if (pBMAX > 4) begin
          oLLR[2] <= saturate_llr(bit2_llr[4] + bit2_lsb_llr[4]);
        end
        if (pBMAX > 6) begin
          oLLR[3] <= saturate_llr(bit3_llr[4] + bit3_lsb_llr[4]);
        end
        if (pBMAX > 8) begin
          oLLR[4] <= saturate_llr(bit4_llr[4] + bit4_lsb_llr[4]);
        end
        if (pBMAX > 10) begin
          oLLR[5] <= saturate_llr(bit5_llr[4] + bit5_lsb_llr[4]);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // function to count internale metrics :
  //  result = level - abs(dat) --> sign ? (cE + dat) : (cE - dat)
  //------------------------------------------------------------------------------------------------------

  function automatic this_t sub_abs (input this_t level, input this_t dat);
    logic sign;
  begin
    sign    = dat[pDAT_W-1];
    sub_abs = (sign ? level : (level+1)) + (dat ^ {pDAT_W{!sign}});
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // function to saturate metrics :
  //  result = (dat > cMAX_POS) ? cMAX_POS : ((dat < cMIN_NEG) ? cMIN_NEG : dat);
  //------------------------------------------------------------------------------------------------------

  function automatic logic signed [pLLR_W-1 : 0] saturate_llr (input this_t dat);
    logic poverflow;
    logic noverflow;
  begin
    poverflow = (dat > cMAX_POS);
    noverflow = (dat < cMIN_NEG);
    //
    if (poverflow | noverflow) begin
      saturate_llr = poverflow ? cMAX_POS[pLLR_W-1 : 0] : cMIN_NEG[pLLR_W-1 : 0];
    end
    else begin
      saturate_llr = dat[pLLR_W-1 : 0];
    end
  end
  endfunction

endmodule
