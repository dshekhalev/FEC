/*



  parameter int pDAT_W  = 8 ;
  parameter int pLLR_W  = 4 ;



  logic                       llr_bpsk_8psk_demapper__iclk            ;
  logic                       llr_bpsk_8psk_demapper__ireset          ;
  logic                       llr_bpsk_8psk_demapper__iclkena         ;
  logic                       llr_bpsk_8psk_demapper__ival            ;
  logic                       llr_bpsk_8psk_demapper__isop            ;
  logic               [3 : 0] llr_bpsk_8psk_demapper__iqam            ;
  logic signed [pDAT_W-1 : 0] llr_bpsk_8psk_demapper__idat_re         ;
  logic signed [pDAT_W-1 : 0] llr_bpsk_8psk_demapper__idat_im         ;
  logic                       llr_bpsk_8psk_demapper__oval            ;
  logic                       llr_bpsk_8psk_demapper__osop            ;
  logic               [3 : 0] llr_bpsk_8psk_demapper__oqam            ;
  logic signed [pLLR_W-1 : 0] llr_bpsk_8psk_demapper__oLLR    [0 : 4] ;



  llr_bpsk_8psk_demapper
  #(
    .pDAT_W ( pDAT_W ) ,
    .pLLR_W ( pLLR_W )
  )
  llr_bpsk_8psk_demapper
  (
    .iclk    ( llr_bpsk_8psk_demapper__iclk    ) ,
    .ireset  ( llr_bpsk_8psk_demapper__ireset  ) ,
    .iclkena ( llr_bpsk_8psk_demapper__iclkena ) ,
    .ival    ( llr_bpsk_8psk_demapper__ival    ) ,
    .isop    ( llr_bpsk_8psk_demapper__isop    ) ,
    .iqam    ( llr_bpsk_8psk_demapper__iqam    ) ,
    .idat_re ( llr_bpsk_8psk_demapper__idat_re ) ,
    .idat_im ( llr_bpsk_8psk_demapper__idat_im ) ,
    .oval    ( llr_bpsk_8psk_demapper__oval    ) ,
    .osop    ( llr_bpsk_8psk_demapper__osop    ) ,
    .oqam    ( llr_bpsk_8psk_demapper__oqam    ) ,
    .oLLR    ( llr_bpsk_8psk_demapper__oLLR    )
  );


  assign llr_bpsk_8psk_demapper__iclk    = '0 ;
  assign llr_bpsk_8psk_demapper__ireset  = '0 ;
  assign llr_bpsk_8psk_demapper__iclkena = '0 ;
  assign llr_bpsk_8psk_demapper__ival    = '0 ;
  assign llr_bpsk_8psk_demapper__isop    = '0 ;
  assign llr_bpsk_8psk_demapper__iqam    = '0 ;
  assign llr_bpsk_8psk_demapper__idat_re = '0 ;
  assign llr_bpsk_8psk_demapper__idat_im = '0 ;



*/

//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : llr_bpsk_8psk_demapper.v
// Description   : QPSK & 8PSK LLR demapper
//

module llr_bpsk_8psk_demapper
#(
  parameter int pDAT_W  = 8 , // must be pLLR_W + 1
  parameter int pLLR_W  = 4   //
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
  output logic signed [pLLR_W-1 : 0] oLLR    [0 : 2] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic signed [pDAT_W : 0] this_t; // + 1 bit

  localparam this_t cONE      =  2**(pLLR_W-2);

  // metric saturation
  localparam this_t cMAX_POS  =  2*cONE-1;
  localparam this_t cMIN_NEG  = -2*cONE;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [3 : 0] sop;
  logic [3 : 0] val;
  logic [3 : 0] qam [4];

  this_t        dat_re;
  this_t        dat_im;

  this_t        adat_re;
  this_t        adat_im;

  this_t        bit0_llr [1 : 3] ;
  this_t        bit1_llr [1 : 3] ;
  this_t        bit2_llr [1 : 3] ;

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
      dat_re      <= idat_re;
      dat_im      <= idat_im;

      adat_re     <= (idat_re < 0) ? -idat_re : idat_re;
      adat_im     <= (idat_im < 0) ? -idat_im : idat_im;
      //
      // val[0]
      bit2_llr[1] <= dat_im;
      bit1_llr[1] <= dat_re;
      bit0_llr[1] <= (qam[0][1] == 0) ? (dat_re + dat_im) : (adat_re - adat_im);
      // val[1]
      bit2_llr[2] <= saturate_llr(bit2_llr[1]);
      bit1_llr[2] <= saturate_llr(bit1_llr[1]);
      bit0_llr[2] <= saturate_llr(bit0_llr[1]);
      // val[2]
      bit2_llr[3] <= bit2_llr[2];
      bit1_llr[3] <= bit1_llr[2];
      bit0_llr[3] <= bit0_llr[2];
      //
      if (val[3]) begin
        osop    <= sop[3];
        oqam    <= qam[3];

        oLLR[0] <= bit0_llr[3][pLLR_W-1 : 0];
        oLLR[1] <= bit1_llr[3][pLLR_W-1 : 0];
        oLLR[2] <= bit2_llr[3][pLLR_W-1 : 0];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
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
