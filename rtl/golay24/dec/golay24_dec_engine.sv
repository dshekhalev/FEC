/*






  logic   golay24_dec_engine__iclk     ;
  logic   golay24_dec_engine__ireset   ;
  logic   golay24_dec_engine__iclkena  ;
  logic   golay24_dec_engine__isop     ;
  logic   golay24_dec_engine__ival     ;
  logic   golay24_dec_engine__ieop     ;
  dat_t   golay24_dec_engine__idat     ;
  logic   golay24_dec_engine__osop     ;
  logic   golay24_dec_engine__oval     ;
  logic   golay24_dec_engine__oeop     ;
  logic   golay24_dec_engine__ofailed  ;
  dat_t   golay24_dec_engine__odat     ;



  golay24_dec_engine
  golay24_dec_engine
  (
    .iclk    ( golay24_dec_engine__iclk    ) ,
    .ireset  ( golay24_dec_engine__ireset  ) ,
    .iclkena ( golay24_dec_engine__iclkena ) ,
    .isop    ( golay24_dec_engine__isop    ) ,
    .ival    ( golay24_dec_engine__ival    ) ,
    .ieop    ( golay24_dec_engine__ieop    ) ,
    .idat    ( golay24_dec_engine__idat    ) ,
    .osop    ( golay24_dec_engine__osop    ) ,
    .oval    ( golay24_dec_engine__oval    ) ,
    .oeop    ( golay24_dec_engine__oeop    ) ,
    .ofailed ( golay24_dec_engine__ofailed ) ,
    .odat    ( golay24_dec_engine__odat    )
  );


  assign golay24_dec_engine__iclk    = '0 ;
  assign golay24_dec_engine__ireset  = '0 ;
  assign golay24_dec_engine__iclkena = '0 ;
  assign golay24_dec_engine__isop    = '0 ;
  assign golay24_dec_engine__ival    = '0 ;
  assign golay24_dec_engine__ieop    = '0 ;
  assign golay24_dec_engine__idat    = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision$
// Date          : $Date$
// Workfile      : golay24_dec_engine.sv
// Description   : hd LUT based decoder
//


module golay24_dec_engine
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  ofailed ,
  odat
);

  `include "../golay24_functions.svh"
  `include "golay24_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk     ;
  input  logic  ireset   ;
  input  logic  iclkena  ;
  //
  input  logic  isop     ;
  input  logic  ival     ;
  input  logic  ieop     ;
  input  dat_t  idat     ;
  //
  output logic  osop     ;
  output logic  oval     ;
  output logic  oeop     ;
  output logic  ofailed  ;
  output dat_t  odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic  [3 : 0] sop;
  logic  [3 : 0] val;
  logic  [3 : 0] eop;

  dat_t          dat [3];
  syndrome_t     syndrome;

  logic [15 : 0] s_tab_dat;

  logic          failed;
  logic [14 : 0] biterr_idx;
  logic [23 : 0] biterr_mask;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= 1'b0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  assign biterr_mask = (24'h1 << biterr_idx[14 : 10]) | (24'h1 << biterr_idx[9 : 5]) | (24'h1 << biterr_idx[4 : 0]);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop       <= (sop << 1) | isop;
      eop       <= (eop << 1) | ieop;
      //
      dat[0]    <= idat;
      syndrome  <= get_syndrome(idat);

      dat[1]    <= dat[0];
      s_tab_dat <= cS_SYNDROME_TAB[syndrome];

      dat[2]    <= dat[1];
      {failed, biterr_idx} <= s_tab_dat;

      ofailed   <= failed;
      odat      <= dat[2] ^ biterr_mask;
    end
  end

  assign osop = sop[3];
  assign oval = val[3];
  assign oeop = eop[3];

endmodule
