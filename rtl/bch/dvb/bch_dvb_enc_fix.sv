/*


  parameter bit [1 : 0] pCODEGR   = 0;
  parameter bit [4 : 0] pCODERATE = 0;
  parameter bit         pXMODE    = 0;
  parameter int         pTAG_W    = 1;


  logic                bch_dvb_enc_fix__iclk    ;
  logic                bch_dvb_enc_fix__ireset  ;
  logic                bch_dvb_enc_fix__iclkena ;
  //
  logic                bch_dvb_enc_fix__isop    ;
  logic                bch_dvb_enc_fix__ieop    ;
  logic                bch_dvb_enc_fix__ieof    ;
  logic                bch_dvb_enc_fix__ival    ;
  logic [pTAG_W-1 : 0] bch_dvb_enc_fix__itag    ;
  logic                bch_dvb_enc_fix__idat    ;
  //
  logic                bch_dvb_enc_fix__osop    ;
  logic                bch_dvb_enc_fix__oval    ;
  logic                bch_dvb_enc_fix__oeop    ;
  logic [pTAG_W-1 : 0] bch_dvb_enc_fix__otag    ;
  logic                bch_dvb_enc_fix__odat    ;



  bch_dvb_enc_fix
  #(
    .pCODEGR   ( pCODEGR   ) ,
    .pCODERATE ( pCODERATE ) ,
    .pXMODE    ( pXMODE    ) ,
    .pTAG_W    ( pTAG_W    )
  )
  bch_dvb_enc_fix
  (
    .iclk    ( bch_dvb_enc_fix__iclk    ) ,
    .ireset  ( bch_dvb_enc_fix__ireset  ) ,
    .iclkena ( bch_dvb_enc_fix__iclkena ) ,
    //
    .isop    ( bch_dvb_enc_fix__isop    ) ,
    .ieop    ( bch_dvb_enc_fix__ieop    ) ,
    .ieof    ( bch_dvb_enc_fix__ieof    ) ,
    .ival    ( bch_dvb_enc_fix__ival    ) ,
    .itag    ( bch_dvb_enc_fix__itag    ) ,
    .idat    ( bch_dvb_enc_fix__idat    ) ,
    //
    .osop    ( bch_dvb_enc_fix__osop    ) ,
    .oval    ( bch_dvb_enc_fix__oval    ) ,
    .oeop    ( bch_dvb_enc_fix__oeop    ) ,
    .otag    ( bch_dvb_enc_fix__otag    ) ,
    .odat    ( bch_dvb_enc_fix__odat    )
  );


  assign bch_dvb_enc_fix__iclk    = '0 ;
  assign bch_dvb_enc_fix__ireset  = '0 ;
  assign bch_dvb_enc_fix__iclkena = '0 ;
  assign bch_dvb_enc_fix__isop    = '0 ;
  assign bch_dvb_enc_fix__ieop    = '0 ;
  assign bch_dvb_enc_fix__ieof    = '0 ;
  assign bch_dvb_enc_fix__ival    = '0 ;
  assign bch_dvb_enc_fix__itag    = '0 ;
  assign bch_dvb_enc_fix__idat    = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_dvb_enc_fix.sv
// Description   : bch DVB-S2/S2x encoder wrapper
//


module bch_dvb_enc_fix
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ieop    ,
  ieof    ,
  ival    ,
  itag    ,
  idat    ,
  //
  osop    ,
  oeop    ,
  oval    ,
  otag    ,
  odat
);

  parameter int pTAG_W = 1;

  `include "bch_dvb_fix_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                iclkena ;
  input  logic                ireset  ;
  //
  input  logic                isop    ;
  input  logic                ieop    ;
  input  logic                ieof    ;
  input  logic                ival    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  input  logic                idat    ;
  //
  output logic                osop    ;
  output logic                oval    ;
  output logic                oeop    ;
  output logic [pTAG_W-1 : 0] otag    ;
  output logic                odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cM      = cGF_M[pCODEGR];
  localparam int cK_MAX  = get_data_max_bits_num(pCODEGR, pCODERATE, pXMODE);
  localparam int cD      = 1 + 2*get_t_num(pCODEGR, pCODERATE, pXMODE);
  localparam int cN      = get_code_bits_num(pCODEGR, pCODERATE, pXMODE);
  localparam int cIRRPOL = cGF_IRRPOL[pCODEGR];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bch_enc
  #(
    .m      ( cM      ) ,
    .k_max  ( cK_MAX  ) ,
    .d      ( cD      ) ,
    .n      ( cN      ) ,
    .irrpol ( cIRRPOL )
  )
  bch_enc
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .isop    ( isop    ) ,
    .ieop    ( ieop    ) ,
    .ieof    ( ieof    ) ,
    .ival    ( ival    ) ,
    .idat    ( idat    ) ,
    //
    .osop    ( osop    ) ,
    .oval    ( oval    ) ,
    .oeop    ( oeop    ) ,
    .odat    ( odat    )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & isop) begin
        otag <= itag;
      end
    end
  end

endmodule
