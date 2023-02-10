/*


  parameter bit pONE_IS_PLUS = 1 ;



  logic dvb_pi_by_2_bpsk_mapper__iclk    ;
  logic dvb_pi_by_2_bpsk_mapper__ireset  ;
  logic dvb_pi_by_2_bpsk_mapper__iclkena ;
  //
  logic dvb_pi_by_2_bpsk_mapper__isop    ;
  logic dvb_pi_by_2_bpsk_mapper__ival    ;
  logic dvb_pi_by_2_bpsk_mapper__ieop    ;
  logic dvb_pi_by_2_bpsk_mapper__idat    ;
  //
  logic dvb_pi_by_2_bpsk_mapper__osop    ;
  logic dvb_pi_by_2_bpsk_mapper__oval    ;
  logic dvb_pi_by_2_bpsk_mapper__oeop    ;
  logic dvb_pi_by_2_bpsk_mapper__odat_re ;
  logic dvb_pi_by_2_bpsk_mapper__odat_im ;



  dvb_pi_by_2_bpsk_mapper
  #(
    .pONE_IS_PLUS ( pONE_IS_PLUS )
  )
  dvb_pi_by_2_bpsk_mapper
  (
    .iclk    ( dvb_pi_by_2_bpsk_mapper__iclk    ) ,
    .ireset  ( dvb_pi_by_2_bpsk_mapper__ireset  ) ,
    .iclkena ( dvb_pi_by_2_bpsk_mapper__iclkena ) ,
    //
    .isop    ( dvb_pi_by_2_bpsk_mapper__isop    ) ,
    .ival    ( dvb_pi_by_2_bpsk_mapper__ival    ) ,
    .ieop    ( dvb_pi_by_2_bpsk_mapper__ieop    ) ,
    .idat    ( dvb_pi_by_2_bpsk_mapper__idat    ) ,
    //
    .osop    ( dvb_pi_by_2_bpsk_mapper__osop    ) ,
    .oval    ( dvb_pi_by_2_bpsk_mapper__oval    ) ,
    .oeop    ( dvb_pi_by_2_bpsk_mapper__oeop    ) ,
    .odat_re ( dvb_pi_by_2_bpsk_mapper__odat_re ) ,
    .odat_im ( dvb_pi_by_2_bpsk_mapper__odat_im )
  );


  assign dvb_pi_by_2_bpsk_mapper__iclk    = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__ireset  = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__iclkena = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__isop    = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__ival    = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__ieop    = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__idat    = '0 ;



*/

//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pi_by_2_bpsk_mapper.sv
// Description   : DVB pi/2 mapper with negative/posive polarity
//                 odat = pONE_IS_PLUS ? (0/1 == -1/1) : (0/1 == 1/-1)
//

module dvb_pi_by_2_bpsk_mapper
#(
  parameter bit pONE_IS_PLUS = 1  // default DVB-PLS
)
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
  odat_re ,
  odat_im
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic iclk    ;
  input  logic ireset  ;
  input  logic iclkena ;
  //
  input  logic isop    ;
  input  logic ival    ;
  input  logic ieop    ;
  input  logic idat    ;
  //
  output logic osop    ;
  output logic oval    ;
  output logic oeop    ;
  output logic odat_re ;  // 1/0 -> +1/-1
  output logic odat_im ;  // 1/0 -> +1/-1

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
      if (ival) begin
        even_ff <= even;
        //
        if (even) begin // DBV-S2 :: (1 - 2*idat) + 1i*(1 - 2*idat)
          odat_re <= pONE_IS_PLUS ? !idat : idat;
          odat_im <= pONE_IS_PLUS ? !idat : idat;
        end
        else begin // DBV-S2 :: -(1 - 2*idat) + 1i*(1 - 2*idat)
          odat_re <= pONE_IS_PLUS ?  idat : !idat;
          odat_im <= pONE_IS_PLUS ? !idat :  idat;
        end
      end
    end
  end

endmodule
