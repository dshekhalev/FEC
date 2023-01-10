/*



  parameter int pLLR_W       = 5 ;
  parameter int pLLR_FP      = 3 ;
  parameter int pMMAX_TYPE   = 0 ;
  parameter bit pUSE_SC_MODE = 0 ;



  logic      ccsds_turbo_dec_Lextr__iclk      ;
  logic      ccsds_turbo_dec_Lextr__ireset    ;
  logic      ccsds_turbo_dec_Lextr__iclkena   ;
  logic      ccsds_turbo_dec_Lextr__ival      ;
  logic      ccsds_turbo_dec_Lextr__idat      ;
  Lapri_t    ccsds_turbo_dec_Lextr__iLapri    ;
  Lapo_t     ccsds_turbo_dec_Lextr__iLapo     ;
  logic      ccsds_turbo_dec_Lextr__isc_init  ;
  logic      ccsds_turbo_dec_Lextr__isc_ena   ;
  Lextr_t    ccsds_turbo_dec_Lextr__iLextr    ;
  logic      ccsds_turbo_dec_Lextr__oval      ;
  Lextr_t    ccsds_turbo_dec_Lextr__oLextr    ;
  logic      ccsds_turbo_dec_Lextr__odat      ;
  logic      ccsds_turbo_dec_Lextr__oerr      ;



  ccsds_turbo_dec_Lextr
  #(
    .pLLR_W       ( pLLR_W       ) ,
    .pLLR_FP      ( pLLR_FP      ) ,
    .pMMAX_TYPE   ( pMMAX_TYPE   ) ,
    .pUSE_SC_MODE ( pUSE_SC_MODE )
  )
  ccsds_turbo_dec_Lextr
  (
    .iclk     ( ccsds_turbo_dec_Lextr__iclk     ) ,
    .ireset   ( ccsds_turbo_dec_Lextr__ireset   ) ,
    .iclkena  ( ccsds_turbo_dec_Lextr__iclkena  ) ,
    .ival     ( ccsds_turbo_dec_Lextr__ival     ) ,
    .idat     ( ccsds_turbo_dec_Lextr__idat     ) ,
    .iLapri   ( ccsds_turbo_dec_Lextr__iLapri   ) ,
    .iLapo    ( ccsds_turbo_dec_Lextr__iLapo    ) ,
    .isc_init ( ccsds_turbo_dec_Lextr__isc_init ) ,
    .isc_ena  ( ccsds_turbo_dec_Lextr__isc_ena  ) ,
    .iLextr   ( ccsds_turbo_dec_Lextr__iLextr   ) ,
    .oval     ( ccsds_turbo_dec_Lextr__oval     ) ,
    .oLextr   ( ccsds_turbo_dec_Lextr__oLextr   ) ,
    .odat     ( ccsds_turbo_dec_Lextr__odat     ) ,
    .oerr     ( ccsds_turbo_dec_Lextr__oerr     )
  );


  assign ccsds_turbo_dec_Lextr__iclk     = '0 ;
  assign ccsds_turbo_dec_Lextr__ireset   = '0 ;
  assign ccsds_turbo_dec_Lextr__iclkena  = '0 ;
  assign ccsds_turbo_dec_Lextr__ival     = '0 ;
  assign ccsds_turbo_dec_Lextr__idat     = '0 ;
  assign ccsds_turbo_dec_Lextr__iLapri   = '0 ;
  assign ccsds_turbo_dec_Lextr__iLapo    = '0 ;
  assign ccsds_turbo_dec_Lextr__isc_init = '0 ;
  assign ccsds_turbo_dec_Lextr__isc_ena  = '0 ;
  assign ccsds_turbo_dec_Lextr__iLextr   = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_Lextr.sv
// Description   : module to count sub iteration results : Lextr, bit pairs and estimated corrected errror.
//                 Module latency is 2 tick.
//

module ccsds_turbo_dec_Lextr
#(
  parameter int pLLR_W       = 5 ,
  parameter int pLLR_FP      = 3 ,
  parameter int pMMAX_TYPE   = 0 ,
  parameter bit pUSE_SC_MODE = 0
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  ival     ,
  idat     ,
  iLapri   ,
  iLapo    ,
  //
  isc_init ,
  isc_ena  ,
  iLextr   ,
  //
  oval     ,
  oLextr   ,
  odat     ,
  oerr
);

  `include "../ccsds_turbo_trellis.svh"

  `include "ccsds_turbo_dec_types.svh"
  `include "ccsds_turbo_mmax.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    iclk     ;
  input  logic    ireset   ;
  input  logic    iclkena  ;
  //
  input  logic    ival     ;
  input  logic    idat     ;
  input  Lapri_t  iLapri   ;
  input  Lapo_t   iLapo    ;
  // sc logic ports
  input  logic    isc_init ;
  input  logic    isc_ena  ;
  input  Lextr_t  iLextr   ;
  //
  output logic    oval     ;
  output Lextr_t  oLextr   ;
  output logic    odat     ;
  output logic    oerr     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] val;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic sc_ena;
  logic sc_init;
  logic pre_zero;
  logic pre_sign;

  generate
    if (pUSE_SC_MODE) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          sc_init   <= isc_init;
          sc_ena    <= isc_ena ;
          //
          pre_zero  <= iLextr.pre_zero;
          pre_sign  <= iLextr.pre_sign;
        end
      end
    end
    else begin
      assign sc_ena   = 1'b0;
      assign sc_init  = 1'b0;
      assign pre_zero = 1'b1;
      assign pre_sign = 1'b0;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // Lext
  //------------------------------------------------------------------------------------------------------

  Lapo_t Lext;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        Lext <= iLapo - iLapri;
      end
    end
  end

  Lapo_t     Lext_scale;
  logic      Lext_scale_sign;
  logic      Lext_scale_ovf;
  extr_llr_t Lext_scale_ovf_value;

  always_comb begin
    Lext_scale           = ((Lext <<< 2) + Lext + 4) >>> 3; // floor(Lext * 0.625 + 0.5)
    //
    Lext_scale_sign      = Lext_scale[cGAMMA_W-1];
    Lext_scale_ovf       = Lext_scale_sign ? !(&Lext_scale[cGAMMA_W-1 : cL_EXT_W-1]) :
                                              (|Lext_scale[cGAMMA_W-1 : cL_EXT_W-1]) ;

    Lext_scale_ovf_value = {Lext_scale_sign, ~{{cL_EXT_W-2}{Lext_scale_sign}}, 1'b1};
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val[0]) begin
        oLextr.value    <= Lext_scale_ovf ? Lext_scale_ovf_value : Lext_scale[cL_EXT_W-1:0];
        oLextr.pre_zero <= pre_zero;
        oLextr.pre_sign <= pre_sign;
        //
        if (pUSE_SC_MODE) begin
          if (sc_init) begin
            oLextr.pre_zero <= 1'b1;
            oLextr.pre_sign <= 1'b0;
          end
          else if (sc_ena) begin
            oLextr.pre_zero <= (Lext_scale == 0);
            oLextr.pre_sign <=  Lext_scale_sign;
            // // was not zero & sign change
            if (!pre_zero & (pre_sign ^ Lext_scale_sign)) begin
              oLextr.value    <= '0;
              oLextr.pre_zero <= 1'b1;
              oLextr.pre_sign <= 1'b0;
            end
          end // sc_ena
        end // pUSE_SC_MODE
      end // val[0]
    end // iclkena
  end // iclk

  //------------------------------------------------------------------------------------------------------
  // odat
  //------------------------------------------------------------------------------------------------------

  logic dat;
  logic dec_dat;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        dat     <= idat;
        dec_dat <= !iLapo[$high(iLapo)];
      end
      //
      if (val[0]) begin
        odat <= dec_dat;
        oerr <= dec_dat ^ dat;
      end
    end
  end

  assign oval = val[1];

endmodule
