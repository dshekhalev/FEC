/*


  parameter int pDAT_W = 2;



  logic dvb_pi_by_2_bpsk_mapper__iclk    ;
  logic dvb_pi_by_2_bpsk_mapper__ireset  ;
  logic dvb_pi_by_2_bpsk_mapper__iclkena ;
  //
  logic dvb_pi_by_2_bpsk_mapper__irotate ;
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
    .pDAT_W ( pDAT_W )
  )
  dvb_pi_by_2_bpsk_mapper
  (
    .iclk    ( dvb_pi_by_2_bpsk_mapper__iclk    ) ,
    .ireset  ( dvb_pi_by_2_bpsk_mapper__ireset  ) ,
    .iclkena ( dvb_pi_by_2_bpsk_mapper__iclkena ) ,
    //
    .irotate ( dvb_pi_by_2_bpsk_mapper__irotate ) ,
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
  assign dvb_pi_by_2_bpsk_mapper__irotate = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__isop    = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__ival    = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__ieop    = '0 ;
  assign dvb_pi_by_2_bpsk_mapper__idat    = '0 ;



*/

//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pi_by_2_bpsk_mapper.sv
// Description   : DVB pi/2 mapper with phase rotation for PLS
//

module dvb_pi_by_2_bpsk_mapper
#(
  parameter int pDAT_W = 2
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  irotate ,
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

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                irotate ;  // rotate phase to pi/2 for PLS if b0 = 1
  //
  input  logic                isop    ;
  input  logic                ival    ;
  input  logic                ieop    ;
  input  logic                idat    ;
  //
  output logic                osop    ;
  output logic                oval    ;
  output logic                oeop    ;
  output logic [pDAT_W-1 : 0] odat_re ;
  output logic [pDAT_W-1 : 0] odat_im ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cP_ONE = 2**(pDAT_W-1) - 1;
  localparam int cM_ONE = -cP_ONE;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic even_ff;

  logic signed [pDAT_W-1 : 0] dat;

  //------------------------------------------------------------------------------------------------------
  // irotate = 0 :
  //    even symbols  :   (1 - 2*idat) + 1i*(1 - 2*idat)
  //    odd symbols      -(1 - 2*idat) + 1i*(1 - 2*idat)
  // irotate = 1 :
  //    even symbols  :  -(1 - 2*idat) + 1i*(1 - 2*idat)
  //    odd symbols   :  -(1 - 2*idat) - 1i*(1 - 2*idat)
  //------------------------------------------------------------------------------------------------------

  wire even = isop ? 1'b1 : !even_ff;

  assign dat = idat ? cM_ONE : cP_ONE;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= isop;
      oval <= ival;
      oeop <= ieop;
      if (ival) begin
        even_ff <= even;
        //
        if (irotate) begin  // pi/2 rotation
          odat_re <= -dat;
          odat_im <= even ? dat : -dat;
        end
        else begin
          odat_re <= even ? dat : -dat;
          odat_im <=        dat;
        end
      end
    end
  end

endmodule
