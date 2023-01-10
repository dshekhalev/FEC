/*



  parameter int pDAT_W          =  5 ;
  parameter int pODAT_W         =  2 ;
  parameter int pTAG_W          =  8 ;
  parameter int pN_MAX          = 64 ;
  parameter int pMMAX_TYPE      =  0 ;
  parameter bit pUSE_FIXED_CODE =  0 ;
  parameter bit pUSE_SC_MODE    =  1 ;



  logic                ccsds_turbo_dec__iclk     ;
  logic                ccsds_turbo_dec__ireset   ;
  logic                ccsds_turbo_dec__iclkena  ;
  logic        [1 : 0] ccsds_turbo_dec__icode    ;
  logic        [1 : 0] ccsds_turbo_dec__inidx    ;
  logic        [7 : 0] ccsds_turbo_dec__iNiter   ;
  logic [pTAG_W-1 : 0] ccsds_turbo_dec__itag     ;
  logic                ccsds_turbo_dec__isop     ;
  logic                ccsds_turbo_dec__ieop     ;
  logic                ccsds_turbo_dec__ival     ;
  logic [pDAT_W-1 : 0] ccsds_turbo_dec__idat_re  ;
  logic [pDAT_W-1 : 0] ccsds_turbo_dec__idat_im  ;
  logic        [3 : 0] ccsds_turbo_dec__iqam     ;
  logic                ccsds_turbo_dec__obusy    ;
  logic                ccsds_turbo_dec__ordy     ;
  logic                ccsds_turbo_dec__ireq     ;
  logic                ccsds_turbo_dec__ofull    ;
  logic [pTAG_W-1 : 0] ccsds_turbo_dec__otag     ;
  logic                ccsds_turbo_dec__osop     ;
  logic                ccsds_turbo_dec__oeop     ;
  logic                ccsds_turbo_dec__oval     ;
  logic                ccsds_turbo_dec__odat     ;
  logic       [15 : 0] ccsds_turbo_dec__oerr     ;



  ccsds_turbo_dec_top
  #(
    .pDAT_W          ( pDAT_W          ) ,
    .pODAT_W         ( pODAT_W         ) ,
    .pTAG_W          ( pTAG_W          ) ,
    .pN_MAX          ( pN_MAX          ) ,
    .pMMAX_TYPE      ( pMMAX_TYPE      ) ,
    .pUSE_FIXED_CODE ( pUSE_FIXED_CODE ) ,
    .pUSE_RP_P_COMP  ( pUSE_SC_MODE    )
  )
  ccsds_turbo_dec
  (
    .iclk    ( ccsds_turbo_dec__iclk    ) ,
    .ireset  ( ccsds_turbo_dec__ireset  ) ,
    .iclkena ( ccsds_turbo_dec__iclkena ) ,
    .icode   ( ccsds_turbo_dec__icode   ) ,
    .inidx   ( ccsds_turbo_dec__inidx   ) ,
    .iNiter  ( ccsds_turbo_dec__iNiter  ) ,
    .itag    ( ccsds_turbo_dec__itag    ) ,
    .isop    ( ccsds_turbo_dec__isop    ) ,
    .ieop    ( ccsds_turbo_dec__ieop    ) ,
    .ival    ( ccsds_turbo_dec__ival    ) ,
    .idat_re ( ccsds_turbo_dec__idat_re ) ,
    .idat_im ( ccsds_turbo_dec__idat_im ) ,
    .iqam    ( ccsds_turbo_dec__iqam    ) ,
    .obusy   ( ccsds_turbo_dec__obusy   ) ,
    .ordy    ( ccsds_turbo_dec__ordy    ) ,
    .ireq    ( ccsds_turbo_dec__ireq    ) ,
    .ofull   ( ccsds_turbo_dec__ofull   ) ,
    .otag    ( ccsds_turbo_dec__otag    ) ,
    .osop    ( ccsds_turbo_dec__osop    ) ,
    .oeop    ( ccsds_turbo_dec__oeop    ) ,
    .oval    ( ccsds_turbo_dec__oval    ) ,
    .odat    ( ccsds_turbo_dec__odat    ) ,
    .oerr    ( ccsds_turbo_dec__oerr    )
  );


  assign ccsds_turbo_dec__iclk    = '0 ;
  assign ccsds_turbo_dec__ireset  = '0 ;
  assign ccsds_turbo_dec__iclkena = '0 ;
  assign ccsds_turbo_dec__icode   = '0 ;
  assign ccsds_turbo_dec__inidx   = '0 ;
  assign ccsds_turbo_dec__iNiter  = '0 ;
  assign ccsds_turbo_dec__itag    = '0 ;
  assign ccsds_turbo_dec__isop    = '0 ;
  assign ccsds_turbo_dec__ieop    = '0 ;
  assign ccsds_turbo_dec__ival    = '0 ;
  assign ccsds_turbo_dec__idat_re = '0 ;
  assign ccsds_turbo_dec__idat_im = '0 ;
  assign ccsds_turbo_dec__iqam    = '0 ;
  assign ccsds_turbo_dec__ireq    = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_top.sv
// Description   : RTL dynamic parameters rsc2 decoder with QAM LLR metric counter block
//


module ccsds_turbo_dec_top
#(
  parameter int pDAT_W          =       5 ,
  parameter int pODAT_W         =       1 ,
  parameter int pTAG_W          =       8 ,
  parameter int pN_MAX          = 223*8*5 ,  // number of data bits
  //
  parameter int pMMAX_TYPE      =       0 ,
  //
  parameter bit pUSE_FIXED_CODE =       0 ,
  parameter bit pUSE_SC_MODE    =       1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  inidx   ,
  iNiter  ,
  //
  itag    ,
  isop    ,
  ieop    ,
  ival    ,
  idat_re ,
  idat_im ,
  //
  iqam    ,
  //
  obusy   ,
  ordy    ,
  //
  ireq    ,
  ofull   ,
  //
  otag    ,
  osop    ,
  oeop    ,
  oval    ,
  odat    ,
  oerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk     ;
  input  logic                       ireset   ;
  input  logic                       iclkena  ;
  //
  input  logic               [1 : 0] icode    ;
  input  logic               [1 : 0] inidx    ;
  input  logic               [7 : 0] iNiter   ;
  //
  input  logic        [pTAG_W-1 : 0] itag     ;
  input  logic                       isop     ;
  input  logic                       ieop     ;
  input  logic                       ival     ;
  input  logic signed [pDAT_W-1 : 0] idat_re  ; // abs(idat_re) < 1
  input  logic signed [pDAT_W-1 : 0] idat_im  ; // abs(idat_im) < 1
  input  logic               [3 : 0] iqam     ;
  //
  output logic                       obusy    ;
  output logic                       ordy     ;
  //
  input  logic                       ireq     ;
  output logic                       ofull    ;
  //
  output logic        [pTAG_W-1 : 0] otag     ;
  output logic                       osop     ;
  output logic                       oeop     ;
  output logic                       oval     ;
  output logic       [pODAT_W-1 : 0] odat     ;
  output logic              [15 : 0] oerr     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLLR_W   = pDAT_W;
  localparam int cLLR_FP  = pDAT_W - 2; // defined by used LLR counting
                                        // 4 bit (s0.3) -> 4 bit (s1.2)
                                        // 5 bit (s0.4) -> 5 bit (s1.3)

  logic        [pTAG_W-1 : 0] dec__itag ;
  logic                       dec__isop ;
  logic                       dec__ieop ;
  logic                       dec__ival ;
  logic signed [cLLR_W-1 : 0] dec__iLLR ;

  logic signed   [cLLR_W : 0] bpsk_LLR;
  logic signed [cLLR_W-1 : 0] psk8_LLR  [3] ;
  logic signed [cLLR_W-1 : 0] dec_LLR   [3];

  logic         sop;
  logic [2 : 0] eop;
  logic [2 : 0] val;


  //------------------------------------------------------------------------------------------------------
  // count LLR metric
  // BPSK mapper
  //      0 = -1 - 1i
  //      1 =  1 + 1i
  // QPSK mapper.
  //     00 = -1 - 1i
  //     01 = -1 + 1i
  //     10 =  1 - 1i
  //     11 =  1 + 1i
  //  8PSK mapper : a = cos(pi/8) == 0.924, b = cos(3*pi/8) == 0.383
  //    000 = -b - ai
  //    001 = -a - bi
  //    011 =  a - bi
  //    010 =  b - ai
  //    110 =  b + ai
  //    111 =  a + bi
  //    101 = -a + bi
  //    100 = -b + ai
  //------------------------------------------------------------------------------------------------------

  assign bpsk_LLR = idat_re + idat_im;

  assign psk8_LLR[2] = idat_im;
  assign psk8_LLR[1] = idat_re;
  assign psk8_LLR[0] = abs_psk8(idat_re) - abs_psk8(idat_im);

  function logic [cLLR_W-1 : 0] abs_psk8 (input logic [cLLR_W-1 : 0] dat);
    abs_psk8 = (dat ^ {cLLR_W{dat[cLLR_W-1]}}) + dat[cLLR_W-1];
  endfunction

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dec__itag <= itag;
      //
      case (iqam)
        //
        4'h1 : begin // BPSK :: write as is
          val <= ival ? 3'b100 : (val << 1);
          sop <= (ival & isop);
          eop <= (ival & ieop) ?  3'b100 : (eop << 1);
          //
          if (ival) begin
            {dec_LLR[2], dec_LLR[1], dec_LLR[1]} <= {bpsk_LLR[cLLR_W : 1], {cLLR_W{1'b0}}, {cLLR_W{1'b0}}};
          end
        end
        //
        4'h2 : begin // QPSK :: write as 2 cycle
          val <= ival ? 3'b110 : (val << 1);
          sop <= (ival & isop);
          eop <= (ival & ieop) ?  3'b010 : (eop << 1);
          //
          if (ival) begin
            {dec_LLR[2], dec_LLR[1], dec_LLR[1]} <= {idat_re, idat_im, {cLLR_W{1'b0}}};
          end
          else if (val != 0) begin
            {dec_LLR[2], dec_LLR[1], dec_LLR[1]} <= {dec_LLR[1], dec_LLR[1], {cLLR_W{1'b0}}};
          end
        end
        //
        4'h3 : begin // 8PSK :: write as 3 cycle
          val <= ival ? 3'b111 : (val << 1);
          sop <= (ival & isop);
          eop <= (ival & ieop) ?  3'b001 : (eop << 1);
          //
          if (ival) begin
            {dec_LLR[2], dec_LLR[1], dec_LLR[1]} <= {psk8_LLR[2],  psk8_LLR[1],  psk8_LLR[0]};
          end
          else if (val != 0) begin
            {dec_LLR[2], dec_LLR[1], dec_LLR[1]} <= {dec_LLR[1], dec_LLR[1], {cLLR_W{1'b0}}};
          end
        end
      endcase
    end
  end

  assign dec__isop = sop;
  assign dec__ieop = eop[2];
  assign dec__ival = val[2];
  assign dec__iLLR = dec_LLR[2];

  //------------------------------------------------------------------------------------------------------
  // decoder itself
  //------------------------------------------------------------------------------------------------------

  ccsds_turbo_dec
  #(
    .pLLR_W           ( cLLR_W          ) ,
    .pLLR_FP          ( cLLR_FP         ) ,
    .pODAT_W          ( pODAT_W         ) ,
    .pTAG_W           ( pTAG_W          ) ,
    .pMMAX_TYPE       ( pMMAX_TYPE      ) ,
    .pN_MAX           ( pN_MAX          ) ,
    .pUSE_FIXED_CODE  ( pUSE_FIXED_CODE ) ,
    .pUSE_SC_MODE     ( pUSE_SC_MODE    )
  )
  dec
  (
    .iclk    ( iclk      ) ,
    .ireset  ( ireset    ) ,
    .iclkena ( iclkena   ) ,
    //
    .icode   ( icode     ) ,
    .inidx   ( inidx     ) ,
    .iNiter  ( iNiter    ) ,
    //
    .itag    ( dec__itag ) ,
    .isop    ( dec__isop ) ,
    .ieop    ( dec__ieop ) ,
    .ival    ( dec__ival ) ,
    .iLLR    ( dec__iLLR ) ,
    //
    .obusy   ( obusy     ) ,
    .ordy    ( ordy      ) ,
    //
    .ireq    ( ireq      ) ,
    .ofull   ( ofull     ) ,
    //
    .otag    ( otag      ) ,
    .osop    ( osop      ) ,
    .oeop    ( oeop      ) ,
    .oval    ( oval      ) ,
    .odat    ( odat      ) ,
    .oerr    ( oerr      )
  );

endmodule
