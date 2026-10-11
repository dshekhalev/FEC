/*



  parameter bit pUSE_L_POLY       = 0 ;
  parameter int pLLR_W            = 4 ;
  parameter int pTAG_W            = 8 ;
  //
  parameter bit pDO_LLR_INVERSION = 0 ;



  logic                b_bch_dec__iclk       ;
  logic                b_bch_dec__ireset     ;
  logic                b_bch_dec__iclkena    ;
  //
  logic                b_bch_dec__isop       ;
  logic                b_bch_dec__ival       ;
  logic                b_bch_dec__ieop       ;
  logic [pLLR_W-1 : 0] b_bch_dec__iLLR       ;
  logic [pTAG_W-1 : 0] b_bch_dec__itag       ;
  logic                b_bch_dec__ordy       ;
  //
  logic                b_bch_dec__oframe_err ;
  //
  logic                b_bch_dec__irdy       ;
  logic                b_bch_dec__oval       ;
  logic [cDAT_W-1 : 0] b_bch_dec__odat       ;
  logic [cDAT_W-1 : 0] b_bch_dec__oerr       ;
  logic [pTAG_W-1 : 0] b_bch_dec__otag       ;



  b_bch_dec
  #(
    .pUSE_L_POLY       ( pUSE_L_POLY       ) ,
    .pLLR_W            ( pLLR_W            ) ,
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  b_bch_dec
  (
    .iclk       ( b_bch_dec__iclk       ) ,
    .ireset     ( b_bch_dec__ireset     ) ,
    .iclkena    ( b_bch_dec__iclkena    ) ,
    //
    .isop       ( b_bch_dec__isop       ) ,
    .ival       ( b_bch_dec__ival       ) ,
    .ieop       ( b_bch_dec__ieop       ) ,
    .iLLR       ( b_bch_dec__iLLR       ) ,
    .itag       ( b_bch_dec__itag       ) ,
    .ordy       ( b_bch_dec__ordy       ) ,
    //
    .oframe_err ( b_bch_dec__oframe_err ) ,
    //
    .irdy       ( b_bch_dec__irdy       ) ,
    .oval       ( b_bch_dec__oval       ) ,
    .odat       ( b_bch_dec__odat       ) ,
    .oerr       ( b_bch_dec__oerr       ) ,
    .otag       ( b_bch_dec__otag       )
  );


  assign b_bch_dec__iclk    = '0 ;
  assign b_bch_dec__ireset  = '0 ;
  assign b_bch_dec__iclkena = '0 ;
  assign b_bch_dec__isop    = '0 ;
  assign b_bch_dec__ival    = '0 ;
  assign b_bch_dec__ieop    = '0 ;
  assign b_bch_dec__iLLR    = '0 ;
  assign b_bch_dec__itag    = '0 ;
  assign b_bch_dec__irdy    = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_dec.svh
// Description   : hard/soft decoder with data word output
//                 input is serial stream, MSB first (!!!)
//

module b_bch_dec
#(
  parameter bit pUSE_L_POLY       = 0 ,
  parameter int pLLR_W            = 4 ,
  parameter int pTAG_W            = 8 ,
  //
  parameter bit pDO_LLR_INVERSION = 0
)
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  isop       ,
  ival       ,
  ieop       ,
  iLLR       ,
  itag       ,
  ordy       ,
  //
  oframe_err ,
  //
  irdy       ,
  oval       ,
  odat       ,
  oerr       ,
  otag
);

  `include "b_bch_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = cDBIT_NUM[pUSE_L_POLY] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk       ;
  input  logic                ireset     ;
  input  logic                iclkena    ;
  //
  input  logic                isop       ;
  input  logic                ival       ;
  input  logic                ieop       ;
  input  logic [pLLR_W-1 : 0] iLLR       ;
  input  logic [pTAG_W-1 : 0] itag       ;
  output logic                ordy       ;
  //
  output logic                oframe_err ;
  //
  input  logic                irdy       ;
  output logic                oval       ;
  output logic [cDAT_W-1 : 0] odat       ;
  output logic [cDAT_W-1 : 0] oerr       ;
  output logic [pTAG_W-1 : 0] otag       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cRAM_ADDR_W = $clog2(cBIT_NUM[pUSE_L_POLY]);
  localparam int cRAM_DAT_W  = pLLR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // source
  logic                     source__isop       ;
  logic                     source__ival       ;
  logic                     source__ieop       ;
  logic      [pLLR_W-1 : 0] source__iLLR       ;
  //
  logic                     source__oframe_err ;
  //
  logic                     source__owrite     ;
  logic [cRAM_ADDR_W-1 : 0] source__owaddr     ;
  logic  [cRAM_DAT_W-1 : 0] source__owLRR      ;

  logic      [pTAG_W-1 : 0] source_tag         ;

  // ram
  logic                     mem__iwrite ;
  logic [cRAM_ADDR_W-1 : 0] mem__iwaddr ;
  logic  [cRAM_DAT_W-1 : 0] mem__iwdat  ;
  //
  logic [cRAM_ADDR_W-1 : 0] mem__iraddr ;
  logic  [cRAM_DAT_W-1 : 0] mem__ordat  ;

  logic                     cand_gen__isop    ;
  logic                     cand_gen__isof    ;
  logic                     cand_gen__ival    ;
  logic                     cand_gen__ieop    ;
  logic                     cand_gen__ieof    ;
  logic      [cDAT_W-1 : 0] cand_gen__idat    ;
  //
  logic                     cand_gen__osop    ;
  logic                     cand_gen__osof    ;
  logic                     cand_gen__oval    ;
  logic                     cand_gen__oeop    ;
  logic                     cand_gen__oeof    ;
  logic                     cand_gen__odat    ;

  // ctrl
  logic                     ctrl__irdy        ;
  //
  logic                     ctrl__osop        ;
  logic                     ctrl__osof        ;
  logic                     ctrl__oval        ;
  logic                     ctrl__oeop        ;
  logic                     ctrl__oeof        ;
  //
  logic [cRAM_ADDR_W-1 : 0] ctrl__oraddr      ;
  logic      [cDAT_W-1 : 0] ctrl__ocand_idx   ;
  //
  logic                     ctrl__orslt_phase ;

  // correlator
  logic                     corr_unit__isop      ;
  logic                     corr_unit__isof      ;
  logic                     corr_unit__ival      ;
  logic                     corr_unit__ieop      ;
  logic                     corr_unit__ieof      ;
  logic      [pLLR_W-1 : 0] corr_unit__iLLR      ;
  logic                     corr_unit__icand_dat ;
  logic      [cDAT_W-1 : 0] corr_unit__icand_idx ;
  //
  logic                     corr_unit__oval      ;
  logic      [cDAT_W-1 : 0] corr_unit__odat      ;

  // error counter
  logic                     err_cnt__isop      ;
  logic                     err_cnt__ival      ;
  logic                     err_cnt__ieop      ;
  logic      [pLLR_W-1 : 0] err_cnt__iLLR      ;
  logic                     err_cnt__icand_dat ;
  //
  logic                     err_cnt__oval      ;
  logic      [cDAT_W-1 : 0] err_cnt__oerr      ;

  //------------------------------------------------------------------------------------------------------
  // source unit
  //------------------------------------------------------------------------------------------------------

  b_bch_dec_source
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pLLR_W      ( pLLR_W      ) ,
    .pADDR_W     ( cRAM_ADDR_W )
  )
  source
  (
    .iclk       ( iclk               ) ,
    .ireset     ( ireset             ) ,
    .iclkena    ( iclkena            ) ,
    //
    .isop       ( source__isop       ) ,
    .ival       ( source__ival       ) ,
    .ieop       ( source__ieop       ) ,
    .iLLR       ( source__iLLR       ) ,
    //
    .oframe_err ( source__oframe_err ) ,
    //
    .owrite     ( source__owrite     ) ,
    .owaddr     ( source__owaddr     ) ,
    .owLRR      ( source__owLRR      )
  );

  assign source__isop = isop        ;
  assign source__ival = ival & ordy ;
  assign source__ieop = ieop        ;
  assign source__iLLR = iLLR        ;

  assign oframe_err   = source__oframe_err;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & isop & ordy) begin
        source_tag <= itag;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  b_bch_dec_ctrl
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pADDR_W     ( cRAM_ADDR_W  )
  )
  ctrl
  (
    .iclk        ( iclk              ) ,
    .ireset      ( ireset            ) ,
    .iclkena     ( iclkena           ) ,
    //
    .isop        ( isop              ) ,
    .ival        ( ival              ) ,
    .ieop        ( ieop              ) ,
    .ordy        ( ordy              ) ,
    //
    .irdy        ( ctrl__irdy        ) ,
    //
    .osop        ( ctrl__osop        ) ,
    .osof        ( ctrl__osof        ) ,
    .oval        ( ctrl__oval        ) ,
    .oeop        ( ctrl__oeop        ) ,
    .oeof        ( ctrl__oeof        ) ,
    //
    .oraddr      ( ctrl__oraddr      ) ,
    .ocand_idx   ( ctrl__ocand_idx   ) ,
    //
    .orslt_phase ( ctrl__orslt_phase )
  );

  assign ctrl__irdy = !oval | (oval & irdy);

  //------------------------------------------------------------------------------------------------------
  // input bufer
  //------------------------------------------------------------------------------------------------------

  codec_mem_block
  #(
    .pADDR_W   ( cRAM_ADDR_W ) ,
    .pDAT_W    ( cRAM_DAT_W  ) ,
    .pPIPE     ( 0           )    // 1 tick reading
  )
  codec_mem_block
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    //
    .iwrite  ( mem__iwrite ) ,
    .iwaddr  ( mem__iwaddr ) ,
    .iwdat   ( mem__iwdat  ) ,
    //
    .iraddr  ( mem__iraddr ) ,
    .ordat   ( mem__ordat  )
  );

  assign mem__iwrite  = source__owrite ;
  assign mem__iwaddr  = source__owaddr ;
  assign mem__iwdat   = source__owLRR  ;
  //
  assign mem__iraddr  = ctrl__oraddr ;

  //------------------------------------------------------------------------------------------------------
  // candidate generator
  //------------------------------------------------------------------------------------------------------

  b_bch_dec_cand_gen
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pTAG_W      ( pTAG_W      )
  )
  cand_gen
  (
    .iclk    ( iclk           ) ,
    .ireset  ( ireset         ) ,
    .iclkena ( iclkena        ) ,
    //
    .isop    ( cand_gen__isop ) ,
    .isof    ( cand_gen__isof ) ,
    .ival    ( cand_gen__ival ) ,
    .ieop    ( cand_gen__ieop ) ,
    .ieof    ( cand_gen__ieof ) ,
    .idat    ( cand_gen__idat ) ,
    //
    .osop    ( cand_gen__osop ) ,
    .osof    ( cand_gen__osof ) ,
    .oval    ( cand_gen__oval ) ,
    .oeop    ( cand_gen__oeop ) ,
    .oeof    ( cand_gen__oeof ) ,
    .odat    ( cand_gen__odat )
  );

  assign cand_gen__isop = ctrl__osop ;
  assign cand_gen__isof = ctrl__osof ;
  assign cand_gen__ival = ctrl__oval ;
  assign cand_gen__ieop = ctrl__oeop ;
  assign cand_gen__ieof = ctrl__oeof ;

  assign cand_gen__idat = ctrl__orslt_phase ? corr_unit__odat : ctrl__ocand_idx ;

  //------------------------------------------------------------------------------------------------------
  // align delay
  //------------------------------------------------------------------------------------------------------

  logic cand_gen_rslt_phase;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      cand_gen_rslt_phase <= ctrl__orslt_phase;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // corellator
  //------------------------------------------------------------------------------------------------------

  b_bch_dec_corr_unit
  #(
    .pUSE_L_POLY       ( pUSE_L_POLY       ) ,
    .pLLR_W            ( pLLR_W            ) ,
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  corr_unit
  (
    .iclk      ( iclk                 ) ,
    .ireset    ( ireset               ) ,
    .iclkena   ( iclkena              ) ,
    //
    .isop      ( corr_unit__isop      ) ,
    .isof      ( corr_unit__isof      ) ,
    .ival      ( corr_unit__ival      ) ,
    .ieop      ( corr_unit__ieop      ) ,
    .ieof      ( corr_unit__ieof      ) ,
    .iLLR      ( corr_unit__iLLR      ) ,
    .icand_dat ( corr_unit__icand_dat ) ,
    .icand_idx ( corr_unit__icand_idx ) ,
    //
    .oval      ( corr_unit__oval      ) ,
    .odat      ( corr_unit__odat      )
  );

  assign corr_unit__isop      = cand_gen__osop ;
  assign corr_unit__isof      = cand_gen__osof ;
  assign corr_unit__ival      = cand_gen__oval & !cand_gen_rslt_phase;
  assign corr_unit__ieop      = cand_gen__oeop ;
  assign corr_unit__ieof      = cand_gen__oeof ;
  assign corr_unit__icand_dat = cand_gen__odat ;

  assign corr_unit__iLLR      = mem__ordat ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      corr_unit__icand_idx <= ctrl__ocand_idx; // align delay
    end
  end

  //------------------------------------------------------------------------------------------------------
  // error couunter
  //------------------------------------------------------------------------------------------------------

  b_bch_dec_err_cnt
  #(
    .pUSE_L_POLY       ( pUSE_L_POLY       ) ,
    .pLLR_W            ( pLLR_W            ) ,
    .pTAG_W            ( pTAG_W            ) ,
    //
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  err_cnt
  (
    .iclk      ( iclk               ) ,
    .ireset    ( ireset             ) ,
    .iclkena   ( iclkena            ) ,
    //
    .isop      ( err_cnt__isop      ) ,
    .ival      ( err_cnt__ival      ) ,
    .ieop      ( err_cnt__ieop      ) ,
    .iLLR      ( err_cnt__iLLR      ) ,
    .icand_dat ( err_cnt__icand_dat ) ,
    //
    .oval      ( err_cnt__oval      ) ,
    .oerr      ( err_cnt__oerr      )
  );

  assign err_cnt__isop      = cand_gen__osop ;
  assign err_cnt__ival      = cand_gen__oval & cand_gen_rslt_phase;
  assign err_cnt__ieop      = cand_gen__oeop ;
  assign err_cnt__icand_dat = cand_gen__odat ;

  assign err_cnt__iLLR      = mem__ordat ;

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      if (!oval | (oval & irdy)) begin
        oval <= err_cnt__oval;
      end
    end
  end

  logic [pTAG_W-1 : 0] tag2out;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (!oval | (oval & irdy)) begin
        if (err_cnt__oval) begin
          odat <= corr_unit__odat;
          oerr <= err_cnt__oerr;
          //
          otag <= source_tag;
        end
      end
    end
  end

endmodule
