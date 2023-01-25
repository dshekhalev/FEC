/*



  parameter int pDAT_W          = 8 ;
  parameter int pTAG_W          = 4 ;
  //
  parameter bit pIDX_GR         = 0 ;
  parameter int pIDX_LS         = 0 ;
  parameter int pIDX_ZC         = 7 ;
  parameter int pCODE           = 4 ;
  parameter int pDO_PUNCT       = 0 ;
  //
  parameter bit pUSE_HSHAKE     = 0 ;
  parameter bit pUSE_FIXED_CODE = 0 ;
  parameter bit pUSE_P1_SLOW    = 1 ;
  parameter bit pUSE_HC_SROM    = 1 ;
  parameter bit pUSE_VAR_DAT_W  = 0 ;


  logic                ldpc_3gpp_enc__iclk      ;
  logic                ldpc_3gpp_enc__ireset    ;
  logic                ldpc_3gpp_enc__iclkena   ;
  //
  logic        [6 : 0] ldpc_3gpp_enc__inidx     ;
  logic        [5 : 0] ldpc_3gpp_enc__icode     ;
  logic                ldpc_3gpp_enc__ido_punct ;
  //
  logic                ldpc_3gpp_enc__isop      ;
  logic                ldpc_3gpp_enc__ival      ;
  logic                ldpc_3gpp_enc__ieop      ;
  logic [pDAT_W-1 : 0] ldpc_3gpp_enc__idat      ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_enc__itag      ;
  //
  logic                ldpc_3gpp_enc__obusy     ;
  logic                ldpc_3gpp_enc__ordy      ;
  logic                ldpc_3gpp_enc__osrc_err  ;
  //
  logic                ldpc_3gpp_enc__ireq      ;
  logic                ldpc_3gpp_enc__ofull     ;
  //
  logic                ldpc_3gpp_enc__osop      ;
  logic                ldpc_3gpp_enc__oval      ;
  logic                ldpc_3gpp_enc__oeop      ;
  logic [pDAT_W-1 : 0] ldpc_3gpp_enc__odat      ;
  logic [pTAG_W-1 : 0] ldpc_3gpp_enc__otag      ;



  ldpc_3gpp_enc
  #(
    .pDAT_W          ( pDAT_W          ) ,
    .pTAG_W          ( pTAG_W          ) ,
    //
    .pIDX_GR         ( pIDX_GR         ) ,
    .pIDX_LS         ( pIDX_LS         ) ,
    .pIDX_ZC         ( pIDX_ZC         ) ,
    .pCODE           ( pCODE           ) ,
    .pDO_PUNCT       ( pDO_PUNCT       ) ,
    //
    .pUSE_HSHAKE     ( pUSE_HSHAKE     ) ,
    .pUSE_FIXED_CODE ( pUSE_FIXED_CODE ) ,
    .pUSE_P1_SLOW    ( pUSE_P1_SLOW    ) ,
    .pUSE_HC_SROM    ( pUSE_HC_SROM    ) ,
    .pUSE_VAR_DAT_W  ( pUSE_VAR_DAT_W  )
  )
  ldpc_3gpp_enc
  (
    .iclk      ( ldpc_3gpp_enc__iclk      ) ,
    .ireset    ( ldpc_3gpp_enc__ireset    ) ,
    .iclkena   ( ldpc_3gpp_enc__iclkena   ) ,
    //
    .inidx     ( ldpc_3gpp_enc__inidx     ) ,
    .icode     ( ldpc_3gpp_enc__icode     ) ,
    .ido_punct ( ldpc_3gpp_enc__ido_punct ) ,
    //
    .isop      ( ldpc_3gpp_enc__isop      ) ,
    .ival      ( ldpc_3gpp_enc__ival      ) ,
    .ieop      ( ldpc_3gpp_enc__ieop      ) ,
    .idat      ( ldpc_3gpp_enc__idat      ) ,
    .itag      ( ldpc_3gpp_enc__itag      ) ,
    //
    .obusy     ( ldpc_3gpp_enc__obusy     ) ,
    .ordy      ( ldpc_3gpp_enc__ordy      ) ,
    .osrc_err  ( ldpc_3gpp_enc__osrc_err  ) ,
    //
    .ireq      ( ldpc_3gpp_enc__ireq      ) ,
    .ofull     ( ldpc_3gpp_enc__ofull     ) ,
    //
    .osop      ( ldpc_3gpp_enc__osop      ) ,
    .oval      ( ldpc_3gpp_enc__oval      ) ,
    .oeop      ( ldpc_3gpp_enc__oeop      ) ,
    .odat      ( ldpc_3gpp_enc__odat      ) ,
    .otag      ( ldpc_3gpp_enc__otag      )
  );


  assign ldpc_3gpp_enc__iclk      = '0 ;
  assign ldpc_3gpp_enc__ireset    = '0 ;
  assign ldpc_3gpp_enc__iclkena   = '0 ;
  //
  assign ldpc_3gpp_enc__inidx     = '0 ;
  assign ldpc_3gpp_enc__icode     = '0 ;
  assign ldpc_3gpp_enc__ido_punct = '0 ;
  //
  assign ldpc_3gpp_enc__isop      = '0 ;
  assign ldpc_3gpp_enc__ival      = '0 ;
  assign ldpc_3gpp_enc__ieop      = '0 ;
  assign ldpc_3gpp_enc__idat      = '0 ;
  assign ldpc_3gpp_enc__itag      = '0 ;
  //
  assign ldpc_3gpp_enc__ireq      = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc.sv
// Description   : 3GPP LDPC RTL encoder
//

`include "define.vh"

module ldpc_3gpp_enc
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  inidx     ,
  icode     ,
  ido_punct ,
  //
  isop      ,
  ival      ,
  ieop      ,
  idat      ,
  itag      ,
  //
  obusy     ,
  ordy      ,
  osrc_err  ,
  //
  ireq      ,
  ofull     ,
  //
  osop      ,
  oval      ,
  oeop      ,
  odat      ,
  otag
);

  parameter int pTAG_W          = 4 ;

  parameter bit pUSE_HSHAKE     = 0 ; // use(1) handshake ival & ordy iinterface or use simple
  parameter bit pUSE_FIXED_CODE = 0 ; // use variable of fixed mode engine
  parameter bit pUSE_P1_SLOW    = 1 ; // use(1) slow sequential mathematics for P1 couning
  parameter bit pUSE_HC_SROM    = 1 ; // use(1) small rom for HC
  parameter bit pUSE_VAR_DAT_W  = 0 ; // used dat bitwidth is fixed pDAT_W (0) or variable

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk      ;
  input  logic                ireset    ;
  input  logic                iclkena   ;
  //
  input  logic        [6 : 0] inidx     ; // {idxGr[0], idxLs[2 : 0], idxZc[2 : 0]}
  input  logic        [5 : 0] icode     ; // graph1/graph2 [4:46]/[4:42]
  input  logic                ido_punct ; // do 3GPP puncture (1)
  //
  input  logic                isop      ;
  input  logic                ival      ;
  input  logic                ieop      ;
  input  logic [pDAT_W-1 : 0] idat      ;
  input  logic [pTAG_W-1 : 0] itag      ;
  //
  output logic                obusy     ;
  output logic                ordy      ;
  output logic                osrc_err  ; // source error if handshake is not using
  //
  input  logic                ireq      ;
  output logic                ofull     ;
  //
  output logic                osop      ;
  output logic                oval      ;
  output logic                oeop      ;
  output logic [pDAT_W-1 : 0] odat      ;
  output logic [pTAG_W-1 : 0] otag      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cZC            = pUSE_FIXED_CODE ? cZC_TAB[pIDX_LS][pIDX_ZC]/pDAT_W : cZC_MAX/pDAT_W;

  localparam int cCODE          = (pCODE < 4) ? 4 : pCODE;

  localparam int cIRAM_MAX_NUM  = pIDX_GR ?  10*cZC          :  22*cZC;

  localparam int cORAM_MAX_NUM  = pIDX_GR ? (10 + cCODE)*cZC : (22 + cCODE)*cZC;

  localparam int cIB_ADDR_W     = clogb2(cIRAM_MAX_NUM);
  localparam int cIB_TAG_W      = pTAG_W + (pUSE_FIXED_CODE ? 0 : $bits(code_ctx_t));

  localparam int cOB_ADDR_W     = clogb2(cORAM_MAX_NUM);
  localparam int cOB_TAG_W      = pTAG_W + cOB_ADDR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // source
  logic                    source__ival     ;

  logic                    source__owrite   ;
  logic                    source__owfull   ;
  logic [cIB_ADDR_W-1 : 0] source__owaddr   ;
  dat_t                    source__owdat    ;

  //
  // input buffer
  logic  [cIB_TAG_W-1 : 0] ibuffer__iwtag   ;

  logic                    ibuffer__irempty ;
  logic [cIB_ADDR_W-1 : 0] ibuffer__iraddr  ;
  logic     [pDAT_W-1 : 0] ibuffer__ordat   ;
  logic  [cIB_TAG_W-1 : 0] ibuffer__ortag   ;

  logic                    ibuffer__oempty  ;
  logic                    ibuffer__oemptya ;
  logic                    ibuffer__ofull   ;
  logic                    ibuffer__ofulla  ;

  //
  // engine
  logic                    engine__irbuf_full  ;
  code_ctx_t               engine__icode_ctx   ;
  //
  logic     [pDAT_W-1 : 0] engine__irdat       ;
  logic     [pTAG_W-1 : 0] engine__irtag       ;
  logic                    engine__orempty     ;
  logic [cIB_ADDR_W-1 : 0] engine__oraddr      ;
  //
  logic                    engine__iwbuf_empty ;
  //
  code_ctx_t               engine__ocode_ctx   ;
  //
  logic                    engine__owrite      ;
  logic                    engine__owfull      ;
  logic [cOB_ADDR_W-1 : 0] engine__owaddr      ;
  logic     [pDAT_W-1 : 0] engine__owdat       ;
  logic     [pTAG_W-1 : 0] engine__owtag       ;

  //
  // output buffer
  logic                    obuffer__iwrite  ;
  logic                    obuffer__iwfull  ;
  logic [cOB_ADDR_W-1 : 0] obuffer__iwaddr  ;
  logic     [pDAT_W-1 : 0] obuffer__iwdat   ;
  logic  [cOB_TAG_W-1 : 0] obuffer__iwtag   ;

  logic                    obuffer__irempty ;
  logic [cOB_ADDR_W-1 : 0] obuffer__iraddr  ;
  logic     [pDAT_W-1 : 0] obuffer__ordat   ;
  logic  [cOB_TAG_W-1 : 0] obuffer__ortag   ;

  logic                    obuffer__oempty  ;
  logic                    obuffer__oemptya ;
  logic                    obuffer__ofull   ;
  logic                    obuffer__ofulla  ;

  //
  // sink
  logic [cOB_ADDR_W-1 : 0] sink__inum_m1    ;
  //
  logic                    sink__ifull      ;
  dat_t                    sink__irdat      ;
  logic     [pTAG_W-1 : 0] sink__irtag      ;
  logic                    sink__orempty    ;
  logic [cOB_ADDR_W-1 : 0] sink__oraddr     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  code_ctx_t used_code_ctx;

  assign  used_code_ctx.idxGr    = inidx[6]  | pIDX_GR;
  assign {used_code_ctx.idxLs,
          used_code_ctx.idxZc}   = inidx[5 : 0];
  assign  used_code_ctx.code     = icode;
  assign  used_code_ctx.do_punct = ido_punct | pDO_PUNCT;

  //------------------------------------------------------------------------------------------------------
  // source
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_source
  #(
    .pADDR_W ( cIB_ADDR_W ) ,
    .pDAT_W  ( pDAT_W     )
  )
  source
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .isop    ( isop             ) ,
    .ieop    ( ieop             ) ,
    .ival    ( source__ival     ) ,
    .idat    ( idat             ) ,
    //
    .ifulla  ( ibuffer__ofulla  ) ,
    .iemptya ( ibuffer__oemptya ) ,
    //
    .ordy    ( ordy             ) ,
    .obusy   ( obusy            ) ,
    //
    .owrite  ( source__owrite   ) ,
    .owfull  ( source__owfull   ) ,
    .owaddr  ( source__owaddr   ) ,
    .owdat   ( source__owdat    )
  );

  assign source__ival = pUSE_HSHAKE ? (ival & ordy) :  ival;
  assign osrc_err     = pUSE_HSHAKE ? 1'b0          : (ival & !ordy);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & isop) begin
        ibuffer__iwtag <= pUSE_FIXED_CODE ? itag : {used_code_ctx, itag};
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // input buffer :: 2 tick read delay
  //------------------------------------------------------------------------------------------------------

  codec_buffer
  #(
    .pADDR_W ( cIB_ADDR_W ) ,
    .pDAT_W  ( pDAT_W     ) ,
    .pTAG_W  ( cIB_TAG_W  ) ,
    .pPIPE   ( 1          )
  )
  ibuffer
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( source__owrite   ) ,
    .iwfull  ( source__owfull   ) ,
    .iwaddr  ( source__owaddr   ) ,
    .iwdat   ( source__owdat    ) ,
    .iwtag   ( ibuffer__iwtag   ) ,
    //
    .irempty ( ibuffer__irempty ) ,
    .iraddr  ( ibuffer__iraddr  ) ,
    .ordat   ( ibuffer__ordat   ) ,
    .ortag   ( ibuffer__ortag   ) ,
    //
    .oempty  ( ibuffer__oempty  ) ,
    .oemptya ( ibuffer__oemptya ) ,
    .ofull   ( ibuffer__ofull   ) ,
    .ofulla  ( ibuffer__ofulla  )
  );

  assign ibuffer__irempty = engine__orempty;
  assign ibuffer__iraddr  = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // engine
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_engine
  #(
    .pIDX_GR         ( pIDX_GR         ) ,
    .pIDX_LS         ( pIDX_LS         ) ,
    .pIDX_ZC         ( pIDX_ZC         ) ,
    .pCODE           ( cCODE           ) ,
    .pDO_PUNCT       ( pDO_PUNCT       ) ,
    //
    .pRADDR_W        ( cIB_ADDR_W      ) ,
    .pWADDR_W        ( cOB_ADDR_W      ) ,
    .pDAT_W          ( pDAT_W          ) ,
    .pTAG_W          ( pTAG_W          ) ,
    //
    .pUSE_FIXED_CODE ( pUSE_FIXED_CODE ) ,
    .pUSE_P1_SLOW    ( pUSE_P1_SLOW    ) ,
    .pUSE_HC_SROM    ( pUSE_HC_SROM    ) ,
    .pUSE_VAR_DAT_W  ( pUSE_VAR_DAT_W  )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .icode_ctx   ( engine__icode_ctx   ) ,
    //
    .irdat       ( engine__irdat       ) ,
    .irtag       ( engine__irtag       ) ,
    .orempty     ( engine__orempty     ) ,
    .oraddr      ( engine__oraddr      ) ,
    //
    .iwbuf_empty ( engine__iwbuf_empty ) ,
    //
    .ocode_ctx   ( engine__ocode_ctx   ) ,
    //
    .owrite      ( engine__owrite      ) ,
    .owfull      ( engine__owfull      ) ,
    .owaddr      ( engine__owaddr      ) ,
    .owdat       ( engine__owdat       ) ,
    .owtag       ( engine__owtag       )
  );

  assign engine__irbuf_full   = ibuffer__ofull;

  always_comb begin
    if (pUSE_FIXED_CODE) begin
       engine__icode_ctx  = '0;
       engine__irtag      = ibuffer__ortag;
    end
    else begin
      {engine__icode_ctx,
       engine__irtag}     = ibuffer__ortag;
    end
  end

  assign engine__irdat        = ibuffer__ordat;

  assign engine__iwbuf_empty  = obuffer__oempty;

  //------------------------------------------------------------------------------------------------------
  // output buffer
  //------------------------------------------------------------------------------------------------------

  codec_buffer
  #(
    .pADDR_W ( cOB_ADDR_W ) ,
    .pDAT_W  ( pDAT_W     ) ,
    .pTAG_W  ( cOB_TAG_W  ) ,
    .pPIPE   ( 1          )
  )
  obuffer
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .iwrite  ( obuffer__iwrite  ) ,
    .iwfull  ( obuffer__iwfull  ) ,
    .iwaddr  ( obuffer__iwaddr  ) ,
    .iwdat   ( obuffer__iwdat   ) ,
    .iwtag   ( obuffer__iwtag   ) ,
    //
    .irempty ( obuffer__irempty ) ,
    .iraddr  ( obuffer__iraddr  ) ,
    .ordat   ( obuffer__ordat   ) ,
    .ortag   ( obuffer__ortag   ) ,
    //
    .oempty  ( obuffer__oempty  ) ,
    .oemptya ( obuffer__oemptya ) ,
    .ofull   ( obuffer__ofull   ) ,
    .ofulla  ( obuffer__ofulla  )
  );

  assign obuffer__iwrite  = engine__owrite;
  assign obuffer__iwfull  = engine__owfull;
  assign obuffer__iwaddr  = engine__owaddr;
  assign obuffer__iwdat   = engine__owdat;

  assign obuffer__iwtag   = {engine__owaddr, engine__owtag};

  assign obuffer__irempty = sink__orempty;
  assign obuffer__iraddr  = sink__oraddr;

  //------------------------------------------------------------------------------------------------------
  // output sink
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_enc_sink
  #(
    .pADDR_W ( cOB_ADDR_W ) ,
    .pDAT_W  ( pDAT_W     ) ,
    .pTAG_W  ( pTAG_W     )
  )
  sink
  (
    .iclk      ( iclk           ) ,
    .ireset    ( ireset         ) ,
    .iclkena   ( iclkena        ) ,
    //
    .inum_m1   ( sink__inum_m1  ) ,
    //
    .ifull     ( sink__ifull    ) ,
    .irdat     ( sink__irdat    ) ,
    .irtag     ( sink__irtag    ) ,
    .orempty   ( sink__orempty  ) ,
    .oraddr    ( sink__oraddr   ) ,
    //
    .ireq      ( ireq           ) ,
    .ofull     ( ofull          ) ,
    //
    .osop      ( osop           ) ,
    .oeop      ( oeop           ) ,
    .oval      ( oval           ) ,
    .odat      ( odat           ) ,
    .otag      ( otag           )
  );

  assign sink__ifull      = obuffer__ofull;
  assign sink__irdat      = obuffer__ordat;

  assign {sink__inum_m1,
          sink__irtag}    = obuffer__ortag;

endmodule
