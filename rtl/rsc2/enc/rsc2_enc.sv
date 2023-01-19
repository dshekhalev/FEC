/*



  parameter int pTAG_W          =  8 ;
  parameter int pN_MAX          = 48 ;
  parameter bit pUSE_FIXED_CODE =  0 ;
  parameter bit pUSE_OBUFFER    =  0 ;



  logic                rsc2_enc__iclk    ;
  logic                rsc2_enc__ireset  ;
  logic                rsc2_enc__iclkena ;
  logic        [3 : 0] rsc2_enc__icode   ;
  logic        [5 : 0] rsc2_enc__iptype  ;
  logic                rsc2_enc__isop    ;
  logic                rsc2_enc__ieop    ;
  logic                rsc2_enc__ival    ;
  logic        [1 : 0] rsc2_enc__idat    ;
  logic [pTAG_W-1 : 0] rsc2_enc__itag    ;
  logic                rsc2_enc__obusy   ;
  logic                rsc2_enc__ordy    ;
  logic                rsc2_enc__idbsclk ;
  logic                rsc2_enc__ofull   ;
  logic                rsc2_enc__osop    ;
  logic                rsc2_enc__oeop    ;
  logic                rsc2_enc__oeof    ;
  logic                rsc2_enc__oval    ;
  logic        [1 : 0] rsc2_enc__odat    ;
  logic [pTAG_W-1 : 0] rsc2_enc__otag    ;



  rsc2_enc
  #(
    .pTAG_W          ( pTAG_W          ) ,
    .pN_MAX          ( pN_MAX          ) ,
    .pUSE_FIXED_CODE ( pUSE_FIXED_CODE ) ,
    .pUSE_OBUFFER    ( pUSE_OBUFFER    )
  )
  rsc2_enc
  (
    .iclk    ( rsc2_enc__iclk    ) ,
    .ireset  ( rsc2_enc__ireset  ) ,
    .iclkena ( rsc2_enc__iclkena ) ,
    .icode   ( rsc2_enc__icode   ) ,
    .iptype  ( rsc2_enc__iptype  ) ,
    .isop    ( rsc2_enc__isop    ) ,
    .ieop    ( rsc2_enc__ieop    ) ,
    .ival    ( rsc2_enc__ival    ) ,
    .idat    ( rsc2_enc__idat    ) ,
    .itag    ( rsc2_enc__itag    ) ,
    .obusy   ( rsc2_enc__obusy   ) ,
    .ordy    ( rsc2_enc__ordy    ) ,
    .idbsclk ( rsc2_enc__idbsclk ) ,
    .ofull   ( rsc2_enc__ofull   ) ,
    .osop    ( rsc2_enc__osop    ) ,
    .oeop    ( rsc2_enc__oeop    ) ,
    .oeof    ( rsc2_enc__oeof    ) ,
    .oval    ( rsc2_enc__oval    ) ,
    .odat    ( rsc2_enc__odat    ) ,
    .otag    ( rsc2_enc__otag    )
  );


  assign rsc2_enc__iclk    = '0 ;
  assign rsc2_enc__ireset  = '0 ;
  assign rsc2_enc__iclkena = '0 ;
  assign rsc2_enc__icode   = '0 ;
  assign rsc2_enc__iptype  = '0 ;
  assign rsc2_enc__isop    = '0 ;
  assign rsc2_enc__ieop    = '0 ;
  assign rsc2_enc__ival    = '0 ;
  assign rsc2_enc__idat    = '0 ;
  assign rsc2_enc__itag    = '0 ;
  assign rsc2_enc__idbsclk = '0 ;


*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_enc.sv
// Description   : RSC2 encoder with dynamic encoding parameters change on fly : coderate/permutation type vs packet length.
//

`include "define.vh"

module rsc2_enc
#(
  parameter int pTAG_W          =    8 ,
  parameter int pN_MAX          = 2048 ,  // maximum number of data duobit's <= 4096
  parameter bit pUSE_FIXED_CODE =    0 ,  // 1 - icode/iptype/iN is constant, 0 - icode/iptype/iN is variable
  parameter bit pUSE_OBUFFER    =    0    // use output buffer at encoder output
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  iptype  ,
  //
  isop    ,
  ieop    ,
  ival    ,
  idat    ,
  itag    ,
  //
  obusy   ,
  ordy    ,
  //
  idbsclk ,
  ofull   ,
  //
  osop    ,
  oeop    ,
  oeof    ,
  oval    ,
  odat    ,
  otag
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic        [3 : 0] icode   ; // coderate [0 : 7] - [1/3; 1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8]
  input  logic        [5 : 0] iptype  ; // permutation type [0: 33] - reordered Table A-1/2/4/5
  //
  input  logic                isop    ;
  input  logic                ieop    ;
  input  logic                ival    ;
  input  logic        [1 : 0] idat    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  //
  output logic                obusy   ;
  output logic                ordy    ;
  //
  input  logic                idbsclk ; // output debit symbol clock
  output logic                ofull   ;
  //
  output logic                osop    ;
  output logic                oeop    ;
  output logic                oeof    ;
  output logic                oval    ;
  output logic        [1 : 0] odat    ;
  output logic [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../rsc2_constants.svh"

  localparam int cIB_ADDR_W = clogb2(pN_MAX);
  localparam int cIB_TAG_W  = (pUSE_FIXED_CODE ? 0 : $bits(code_ctx_t)) + pTAG_W; // {icode, iptype, iN, itag}

  localparam int cOB_ADDR_W = clogb2(pN_MAX*3);     // min coderare is 1/3
  localparam int cOB_TAG_W  = cOB_ADDR_W + pTAG_W;  // {Ndbits, itag}

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  code_ctx_t               used_code_ctx    ;
  //
  // source
  logic                    source__iempty   ;
  logic                    source__iemptya  ;
  logic                    source__ifull    ;
  logic                    source__ifulla   ;
  //
  logic                    source__owrite   ;
  logic                    source__owfull   ;
  logic [cIB_ADDR_W-1 : 0] source__owaddr   ;
  logic            [1 : 0] source__owdat    ;
  //
  // input buffer
  logic                    ibuf__iwrite     ;
  logic                    ibuf__iwfull     ;
  logic [cIB_ADDR_W-1 : 0] ibuf__iwaddr     ;
  logic            [1 : 0] ibuf__iwdata     ;
  logic  [cIB_TAG_W-1 : 0] ibuf__iwtag      ;

  logic                    ibuf__iread      ;
  logic                    ibuf__irempty    ;
  logic [cIB_ADDR_W-1 : 0] ibuf__iraddr0    ;
  logic            [1 : 0] ibuf__ordata0    ;
  logic [cIB_ADDR_W-1 : 0] ibuf__iraddr1    ;
  logic            [1 : 0] ibuf__ordata1    ;
  logic  [cIB_TAG_W-1 : 0] ibuf__ortag      ;

  logic                    ibuf__oempty     ;
  logic                    ibuf__oemptya    ;
  logic                    ibuf__ofull      ;
  logic                    ibuf__ofulla     ;
  //
  // engine
  logic                    engine__idbsclk     ;
  //
  logic                    engine__irbuf_full  ;
  code_ctx_t               engine__icode_ctx   ;
  //
  logic            [1 : 0] engine__irdat       ;
  logic            [1 : 0] engine__irpdat      ;
  logic     [pTAG_W-1 : 0] engine__irtag       ;
  logic                    engine__orempty     ;
  logic [cIB_ADDR_W-1 : 0] engine__oaddr       ;
  logic [cIB_ADDR_W-1 : 0] engine__opaddr      ;
  //
  logic                    engine__iwbuf_empty ;
  //
  logic                    engine__osop        ;
  logic                    engine__oeop        ;
  logic                    engine__oeof        ;
  logic                    engine__oval        ;
  logic            [1 : 0] engine__odat        ;
  logic     [pTAG_W-1 : 0] engine__otag        ;
  //
  logic                    engine__owrite      ;
  logic                    engine__owfull      ;
  logic [cOB_ADDR_W-1 : 0] engine__ownum       ;
  logic [cOB_ADDR_W-1 : 0] engine__owaddr      ;
  logic            [1 : 0] engine__owdat       ;
  logic     [pTAG_W-1 : 0] engine__owtag       ;
  //
  // output buffer
  logic                    obuf__iwrite   ;
  logic                    obuf__iwfull   ;
  logic [cOB_ADDR_W-1 : 0] obuf__iwaddr   ;
  logic            [1 : 0] obuf__iwdat    ;
  logic  [cOB_TAG_W-1 : 0] obuf__iwtag    ;
  //
  logic                    obuf__irempty  ;
  logic [cOB_ADDR_W-1 : 0] obuf__iraddr   ;
  logic            [1 : 0] obuf__ordat    ;
  logic  [cOB_TAG_W-1 : 0] obuf__ortag    ;
  //
  logic                    obuf__oempty   ;
  logic                    obuf__oemptya  ;
  logic                    obuf__ofull    ;
  logic                    obuf__ofulla   ;
  //
  // sink
  logic [cOB_ADDR_W-1 : 0] sink__irsize  ;
  logic                    sink__irfull  ;
  logic            [1 : 0] sink__irdat   ;
  logic     [pTAG_W-1 : 0] sink__irtag   ;
  logic                    sink__orempty ;
  logic [cOB_ADDR_W-1 : 0] sink__oraddr  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign used_code_ctx.code   = icode  ;
  assign used_code_ctx.ptype  = iptype ;

  //------------------------------------------------------------------------------------------------------
  // source unit
  //------------------------------------------------------------------------------------------------------

  rsc_enc_source
  #(
    .pADDR_W ( cIB_ADDR_W )
  )
  source
  (
    .iclk    ( iclk            ) ,
    .ireset  ( ireset          ) ,
    .iclkena ( iclkena         ) ,
    //
    .ival    ( ival            ) ,
    .isop    ( isop            ) ,
    .ieop    ( ieop            ) ,
    .idat    ( idat            ) ,
    //
    .obusy   ( obusy           ) ,
    .ordy    ( ordy            ) ,
    //
    .iempty  ( source__iempty  ) ,
    .iemptya ( source__iemptya ) ,
    .ifull   ( source__ifull   ) ,
    .ifulla  ( source__ifulla  ) ,
    //
    .owrite  ( source__owrite  ) ,
    .owfull  ( source__owfull  ) ,
    .owaddr  ( source__owaddr  ) ,
    .owdat   ( source__owdat   )
  );

  assign source__iempty  = ibuf__oempty  ;
  assign source__iemptya = ibuf__oemptya ;
  assign source__ifull   = ibuf__ofull   ;
  assign source__ifulla  = ibuf__ofulla  ;

  //------------------------------------------------------------------------------------------------------
  // input data buffer
  //------------------------------------------------------------------------------------------------------

  rsc_enc_ibuffer
  #(
    .pADDR_W ( cIB_ADDR_W ) ,
    .pDATA_W ( 2          ) , // duobit
    .pTAG_W  ( cIB_TAG_W  ) ,
    .pBNUM_W ( 1          ) , // double buffering
    .pPIPE   ( 0          )
  )
  ibuf
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .iwrite  ( ibuf__iwrite  ) ,
    .iwfull  ( ibuf__iwfull  ) ,
    .iwaddr  ( ibuf__iwaddr  ) ,
    .iwdata  ( ibuf__iwdata  ) ,
    .iwtag   ( ibuf__iwtag   ) ,
    //
    .iread   ( ibuf__iread   ) ,
    .irempty ( ibuf__irempty ) ,
    .iraddr0 ( ibuf__iraddr0 ) ,
    .ordata0 ( ibuf__ordata0 ) ,
    .iraddr1 ( ibuf__iraddr1 ) ,
    .ordata1 ( ibuf__ordata1 ) ,
    .ortag   ( ibuf__ortag   ) ,
    //
    .oempty  ( ibuf__oempty  ) ,
    .oemptya ( ibuf__oemptya ) ,
    .ofull   ( ibuf__ofull   ) ,
    .ofulla  ( ibuf__ofulla  )
  );

  // write side
  assign ibuf__iwrite   = source__owrite;
  assign ibuf__iwfull   = source__owfull;
  assign ibuf__iwaddr   = source__owaddr;
  assign ibuf__iwdata   = source__owdat ;

  assign ibuf__iwtag    = pUSE_FIXED_CODE ? itag : {used_code_ctx, itag};

  // read side
  assign ibuf__iread    = 1'b1;
  assign ibuf__irempty  = engine__orempty;
  assign ibuf__iraddr1  = engine__oaddr ;
  assign ibuf__iraddr0  = engine__opaddr;

  //------------------------------------------------------------------------------------------------------
  // encoder engine
  //------------------------------------------------------------------------------------------------------

  rsc2_enc_engine
  #(
    .pRADDR_W   ( cIB_ADDR_W      ) ,
    .pWADDR_W   ( cOB_ADDR_W      ) ,
    //
    .pTAG_W     ( pTAG_W          )
  )
  engine
  (
    .iclk        ( iclk                ) ,
    .ireset      ( ireset              ) ,
    .iclkena     ( iclkena             ) ,
    //
    .idbsclk     ( engine__idbsclk     ) ,
    //
    .irbuf_full  ( engine__irbuf_full  ) ,
    .icode_ctx   ( engine__icode_ctx   ) ,
    //
    .irdat       ( engine__irdat       ) ,
    .irpdat      ( engine__irpdat      ) ,
    .irtag       ( engine__irtag       ) ,
    .orempty     ( engine__orempty     ) ,
    .oaddr       ( engine__oaddr       ) ,
    .opaddr      ( engine__opaddr      ) ,
    //
    .iwbuf_empty ( engine__iwbuf_empty ) ,
    //
    .osop        ( engine__osop        ) ,
    .oeop        ( engine__oeop        ) ,
    .oeof        ( engine__oeof        ) ,
    .oval        ( engine__oval        ) ,
    .odat        ( engine__odat        ) ,
    .otag        ( engine__otag        ) ,
    //
    .owrite      ( engine__owrite      ) ,
    .owfull      ( engine__owfull      ) ,
    .ownum       ( engine__ownum       ) ,
    .owaddr      ( engine__owaddr      ) ,
    .owdat       ( engine__owdat       ) ,
    .owtag       ( engine__owtag       )
  );

  assign engine__irbuf_full  = ibuf__ofull ;

  assign engine__irdat       = ibuf__ordata1 ;
  assign engine__irpdat      = ibuf__ordata0 ;

  always_comb begin
    if (pUSE_FIXED_CODE) begin
      engine__icode_ctx   = used_code_ctx;
      engine__irtag       = ibuf__ortag;
    end
    else begin
      {engine__icode_ctx,
       engine__irtag}     = ibuf__ortag;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output buffer
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_OBUFFER) begin

      assign engine__idbsclk      = 1'b1;

      assign engine__iwbuf_empty  = obuf__oempty;

      //
      // output buffer
      //
      codec_buffer
      #(
        .pADDR_W ( cOB_ADDR_W ) ,
        .pDAT_W  ( 2          ) , // duobit
        .pTAG_W  ( cOB_TAG_W  ) ,
        .pBNUM_W ( 1          ) , // double buffering
        .pPIPE   ( 0          )
      )
      obuf
      (
        .iclk     ( iclk          ) ,
        .ireset   ( ireset        ) ,
        .iclkena  ( iclkena       ) ,
        //
        .iwrite   ( obuf__iwrite  ) ,
        .iwfull   ( obuf__iwfull  ) ,
        .iwaddr   ( obuf__iwaddr  ) ,
        .iwdat    ( obuf__iwdat   ) ,
        .iwtag    ( obuf__iwtag   ) ,
        //
        .irempty  ( obuf__irempty ) ,
        .iraddr   ( obuf__iraddr  ) ,
        .ordat    ( obuf__ordat   ) ,
        .ortag    ( obuf__ortag   ) ,
        //
        .oempty   ( obuf__oempty  ) ,
        .oemptya  ( obuf__oemptya ) ,
        .ofull    ( obuf__ofull   ) ,
        .ofulla   ( obuf__ofulla  )
      );

      assign obuf__iwrite   = engine__owrite ;
      assign obuf__iwfull   = engine__owfull ;
      assign obuf__iwaddr   = engine__owaddr ;
      assign obuf__iwdat    = engine__owdat  ;

      assign obuf__iwtag    = {engine__ownum, engine__owtag} ;

      assign obuf__irempty  = sink__orempty;
      assign obuf__iraddr   = sink__oraddr;
      //
      // sink
      //
      rsc_enc_sink
      #(
        .pADDR_W ( cOB_ADDR_W ) ,
        .pTAG_W  ( pTAG_W     )
      )
      sink
      (
        .iclk    ( iclk          ) ,
        .ireset  ( ireset        ) ,
        .iclkena ( iclkena       ) ,
        //
        .irsize  ( sink__irsize  ) ,
        //
        .irfull  ( sink__irfull  ) ,
        .irdat   ( sink__irdat   ) ,
        .irtag   ( sink__irtag   ) ,
        .orempty ( sink__orempty ) ,
        .oraddr  ( sink__oraddr  ) ,
        //
        .ireq    ( idbsclk       ) ,
        .ofull   ( ofull         ) ,
        //
        .osop    ( osop          ) ,
        .oeop    ( oeop          ) ,
        .oval    ( oval          ) ,
        .odat    ( odat          ) ,
        .otag    ( otag          )
      );

      assign sink__irfull   = obuf__ofull ;
      assign sink__irdat    = obuf__ordat ;

      assign {sink__irsize,
              sink__irtag}  = obuf__ortag ;

      // use for compatibility
      assign oeof = oeop & oval;
    end
    else begin
      assign engine__idbsclk      = idbsclk;

      assign engine__iwbuf_empty  = 1'b1;

      assign osop                 = engine__osop;
      assign oeop                 = engine__oeop;
      assign oeof                 = engine__oeof;
      assign oval                 = engine__oval;
      assign odat                 = engine__odat;
      assign otag                 = engine__otag;
    end
  endgenerate

endmodule
