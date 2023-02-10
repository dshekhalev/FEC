/*



  parameter int pIDAT_W = 8 ;
  parameter int pODAT_W = pIDAT_W + 1 ;



  logic                        dvb_pi_by_2_bpsk_demapper__iclk    ;
  logic                        dvb_pi_by_2_bpsk_demapper__ireset  ;
  logic                        dvb_pi_by_2_bpsk_demapper__iclkena ;
  //
  logic                        dvb_pi_by_2_bpsk_demapper__isop    ;
  logic                        dvb_pi_by_2_bpsk_demapper__ival    ;
  logic                        dvb_pi_by_2_bpsk_demapper__ieop    ;
  logic signed [pIDAT_W-1 : 0] dvb_pi_by_2_bpsk_demapper__idat_re ;
  logic signed [pIDAT_W-1 : 0] dvb_pi_by_2_bpsk_demapper__idat_im ;
  //
  logic                        dvb_pi_by_2_bpsk_demapper__osop    ;
  logic                        dvb_pi_by_2_bpsk_demapper__oval    ;
  logic                        dvb_pi_by_2_bpsk_demapper__oeop    ;
  logic signed [pODAT_W-1 : 0] dvb_pi_by_2_bpsk_demapper__odat    ;



  dvb_pi_by_2_bpsk_demapper
  #(
    .pIDAT_W ( pIDAT_W ) ,
    .pODAT_W ( pODAT_W )
  )
  dvb_pi_by_2_bpsk_demapper
  (
    .iclk    ( dvb_pi_by_2_bpsk_demapper__iclk    ) ,
    .ireset  ( dvb_pi_by_2_bpsk_demapper__ireset  ) ,
    .iclkena ( dvb_pi_by_2_bpsk_demapper__iclkena ) ,
    //
    .isop    ( dvb_pi_by_2_bpsk_demapper__isop    ) ,
    .ival    ( dvb_pi_by_2_bpsk_demapper__ival    ) ,
    .ieop    ( dvb_pi_by_2_bpsk_demapper__ieop    ) ,
    .idat_re ( dvb_pi_by_2_bpsk_demapper__idat_re ) ,
    .idat_im ( dvb_pi_by_2_bpsk_demapper__idat_im ) ,
    //
    .osop    ( dvb_pi_by_2_bpsk_demapper__osop    ) ,
    .oval    ( dvb_pi_by_2_bpsk_demapper__oval    ) ,
    .oeop    ( dvb_pi_by_2_bpsk_demapper__oeop    ) ,
    .odat    ( dvb_pi_by_2_bpsk_demapper__odat    )
  );


  assign dvb_pi_by_2_bpsk_demapper__iclk    = '0 ;
  assign dvb_pi_by_2_bpsk_demapper__ireset  = '0 ;
  assign dvb_pi_by_2_bpsk_demapper__iclkena = '0 ;
  assign dvb_pi_by_2_bpsk_demapper__isop    = '0 ;
  assign dvb_pi_by_2_bpsk_demapper__ival    = '0 ;
  assign dvb_pi_by_2_bpsk_demapper__ieop    = '0 ;
  assign dvb_pi_by_2_bpsk_demapper__idat_re = '0 ;
  assign dvb_pi_by_2_bpsk_demapper__idat_im = '0 ;



*/

// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pi_by_2_bpsk_demapper.sv
// Description   : DVB pi/2 demapper. Remember there is no saturation unit.
//                 Do it external if need
//

module dvb_pi_by_2_bpsk_demapper
#(
  parameter int pIDAT_W = 8 ,
  parameter int pODAT_W = pIDAT_W + 1 // do saturation outside if need
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat_re ,
  idat_im ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                        iclk    ;
  input  logic                        ireset  ;
  input  logic                        iclkena ;
  //
  input  logic                        isop    ;
  input  logic                        ival    ;
  input  logic                        ieop    ;
  input  logic signed [pIDAT_W-1 : 0] idat_re ;
  input  logic signed [pIDAT_W-1 : 0] idat_im ;
  //
  output logic                        osop    ;
  output logic                        oval    ;
  output logic                        oeop    ;
  output logic signed [pODAT_W-1 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic even_ff;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  wire even = isop ? 1'b1 : !even_ff;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= isop;
      oval <= ival;
      oeop <= ieop;
      //
      if (ival) begin
        even_ff <= even;
        //
        odat    <= even ? (idat_re + idat_im) : (idat_im - idat_re);
      end
    end
  end

endmodule
