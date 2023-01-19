/*



  parameter int pRADDR_W   = 16 ;
  parameter int pWADDR_W   = 16 ;
  parameter int pTAG_W     =  4 ;


  logic                       rsc2_enc_engine__iclk        ;
  logic                       rsc2_enc_engine__ireset      ;
  logic                       rsc2_enc_engine__iclkena     ;
  //
  logic                       rsc2_enc_engine__idbsclk     ;
  //
  logic                       rsc2_enc_engine__irbuf_full  ;
  code_ctx_t                  rsc2_enc_engine__icode_ctx   ;
  //
  logic               [1 : 0] rsc2_enc_engine__irdat       ;
  logic               [1 : 0] rsc2_enc_engine__irpdat      ;
  logic        [pTAG_W-1 : 0] rsc2_enc_engine__irtag       ;
  logic                       rsc2_enc_engine__orempty     ;
  logic      [pRADDR_W-1 : 0] rsc2_enc_engine__oaddr       ;
  logic      [pRADDR_W-1 : 0] rsc2_enc_engine__opaddr      ;
  //
  logic                       rsc2_enc_engine__iwbuf_empty ;
  //
  logic                       rsc2_enc_engine__osop        ;
  logic                       rsc2_enc_engine__oeop        ;
  logic                       rsc2_enc_engine__oeof        ;
  logic                       rsc2_enc_engine__oval        ;
  logic               [1 : 0] rsc2_enc_engine__odat        ;
  logic        [pTAG_W-1 : 0] rsc2_enc_engine__otag        ;
  //
  logic                       rsc2_enc_engine__owrite      ;
  logic                       rsc2_enc_engine__owfull      ;
  logic      [pWADDR_W-1 : 0] rsc2_enc_engine__ownum       ;
  logic      [pWADDR_W-1 : 0] rsc2_enc_engine__owaddr      ;
  logic               [1 : 0] rsc2_enc_engine__owdat       ;
  logic        [pTAG_W-1 : 0] rsc2_enc_engine__owtag       ;



  rsc2_enc_engine
  #(
    .pRADDR_W   ( pRADDR_W   ) ,
    .pWADDR_W   ( pWADDR_W   ) ,
    //
    .pTAG_W     ( pTAG_W     )
  )
  rsc2_enc_engine
  (
    .iclk        ( rsc2_enc_engine__iclk        ) ,
    .ireset      ( rsc2_enc_engine__ireset      ) ,
    .iclkena     ( rsc2_enc_engine__iclkena     ) ,
    //
    .idbsclk     ( rsc2_enc_engine__idbsclk     ) ,
    //
    .irbuf_full  ( rsc2_enc_engine__irbuf_full  ) ,
    .icode_ctx   ( rsc2_enc_engine__icode_ctx   ) ,
    //
    .irdat       ( rsc2_enc_engine__irdat       ) ,
    .irpdat      ( rsc2_enc_engine__irpdat      ) ,
    .irtag       ( rsc2_enc_engine__irtag       ) ,
    .orempty     ( rsc2_enc_engine__orempty     ) ,
    .oaddr       ( rsc2_enc_engine__oaddr       ) ,
    .opaddr      ( rsc2_enc_engine__opaddr      ) ,
    //
    .iwbuf_empty ( rsc2_enc_engine__iwbuf_empty ) ,
    //
    .osop        ( rsc2_enc_engine__osop        ) ,
    .oeop        ( rsc2_enc_engine__oeop        ) ,
    .oeof        ( rsc2_enc_engine__oeof        ) ,
    .oval        ( rsc2_enc_engine__oval        ) ,
    .odat        ( rsc2_enc_engine__odat        ) ,
    .otag        ( rsc2_enc_engine__otag        ) ,
    //
    .owrite      ( rsc2_enc_engine__owrite      ) ,
    .owfull      ( rsc2_enc_engine__owfull      ) ,
    .ownum       ( rsc2_enc_engine__ownum       ) ,
    .owaddr      ( rsc2_enc_engine__owaddr      ) ,
    .owdat       ( rsc2_enc_engine__owdat       ) ,
    .owtag       ( rsc2_enc_engine__owtag       )
  );


  assign rsc2_enc_engine__iclk        = '0 ;
  assign rsc2_enc_engine__ireset      = '0 ;
  assign rsc2_enc_engine__iclkena     = '0 ;
  assign rsc2_enc_engine__idbsclk     = '0 ;
  assign rsc2_enc_engine__irbuf_full  = '0 ;
  assign rsc2_enc_engine__icode_ctx   = '0 ;
  assign rsc2_enc_engine__irdat       = '0 ;
  assign rsc2_enc_engine__irpdat      = '0 ;
  assign rsc2_enc_engine__irtag       = '0 ;
  assign rsc2_enc_engine__iwbuf_empty = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_enc_engine.sv
// Description   : RSC2 encoder engine top level
//

module rsc2_enc_engine
#(
  parameter int pRADDR_W   = 16 ,
  parameter int pWADDR_W   = 16 ,
  //
  parameter int pTAG_W     =  4
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  idbsclk     ,
  //
  irbuf_full  ,
  icode_ctx   ,
  //
  irdat       ,
  irpdat      ,
  irtag       ,
  orempty     ,
  oaddr       ,
  opaddr      ,
  //
  iwbuf_empty ,
  //
  osop        ,
  oeop        ,
  oeof        ,
  oval        ,
  odat        ,
  otag        ,
  //
  owrite      ,
  owfull      ,
  ownum       ,
  owaddr      ,
  owdat       ,
  owtag
);

  `include "../rsc2_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk        ;
  input  logic                       ireset      ;
  input  logic                       iclkena     ;
  //
  input  logic                       idbsclk     ;
  //
  input  logic                       irbuf_full  ;
  input  code_ctx_t                  icode_ctx   ;
  // input ram interface
  input  logic               [1 : 0] irdat       ;  // direct data
  input  logic               [1 : 0] irpdat      ;  // permutated data
  input  logic        [pTAG_W-1 : 0] irtag       ;
  output logic                       orempty     ;
  output logic      [pRADDR_W-1 : 0] oaddr       ;  // direct address
  output logic      [pRADDR_W-1 : 0] opaddr      ;  // permutated address
  //
  input  logic                       iwbuf_empty ;
  // output bit interface
  output logic                       osop        ;
  output logic                       oeop        ;
  output logic                       oeof        ;
  output logic                       oval        ;
  output logic               [1 : 0] odat        ;
  output logic        [pTAG_W-1 : 0] otag        ;
  // output ram interface
  output logic                       owrite      ;
  output logic                       owfull      ;
  output logic      [pWADDR_W-1 : 0] ownum       ;
  output logic      [pWADDR_W-1 : 0] owaddr      ;
  output logic               [1 : 0] owdat       ;
  output logic        [pTAG_W-1 : 0] owtag       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // parameter table
  logic          [5 : 0] ptab__iptype         ;

  logic         [12 : 0] used_N               ;
  logic          [3 : 0] used_Nmod15          ;
  logic         [12 : 0] used_P       [0 : 3] ;
  logic         [12 : 0] used_Pincr           ;

  logic          [3 : 0] used_code            ;
  logic          [3 : 0] used_code_r  [0 : 1] ;

  //
  // address generator
  logic                  paddr_gen__iclear  ;
  logic                  paddr_gen__ienable ;

  logic         [12 : 0] paddr_gen__oaddr   ;
  logic         [12 : 0] paddr_gen__opaddr  ;
  logic                  paddr_gen__obitinv ;

  //
  // ctrl
  logic                  ctrl__oaddr_clear  ;
  logic                  ctrl__oaddr_enable ;

  logic                  ctrl__ostate_clear ;
  logic                  ctrl__ostate_load  ;

  logic                  ctrl__oval         ;
  logic                  ctrl__osop         ;
  logic                  ctrl__oeop         ;
  logic                  ctrl__olast        ;
  logic          [1 : 0] ctrl__ostage       ;

  //
  // convolution engine
  logic                  enc__iclear         ;
  logic                  enc__iload          ;
  logic          [3 : 0] enc__istate [0 : 1] ;
  logic                  enc__isop           ;
  logic                  enc__ival           ;
  logic                  enc__ieop           ;
  logic          [2 : 0] enc__itag           ;
  logic          [1 : 0] enc__idat   [0 : 1] ;

  logic                  enc__osop   [0 : 1] ;
  logic                  enc__oval   [0 : 1] ;
  logic                  enc__oeop   [0 : 1] ;
  logic          [2 : 0] enc__otag   [0 : 1] ;
  logic          [1 : 0] enc__odat   [0 : 1] ;
  logic          [1 : 0] enc__odaty          ;
  logic          [1 : 0] enc__odatw          ;
  logic          [3 : 0] enc__ostate [0 : 1] ;

  //
  // puncture modules
  logic                  punct_sop;
  logic                  punct_val;
  logic                  punct_eop;
  logic                  punct_eof;
  logic          [1 : 0] punct_dat;
  logic          [1 : 0] punct_type;

  logic                  puncty__oval;
  logic          [1 : 0] puncty__odat;

  logic                  punctw__oval;
  logic          [1 : 0] punctw__odat;

  //------------------------------------------------------------------------------------------------------
  // decode permutation type parameters
  //------------------------------------------------------------------------------------------------------

  rsc2_ptable
  ptab
  (
    .iclk       ( iclk         ) ,
    .ireset     ( ireset       ) ,
    .iclkena    ( iclkena      ) ,
    //
    .iptype     ( ptab__iptype ) ,
    //
    .oN         ( used_N       ) ,
    .oNm1       (              ) , // n.u.
    .oNmod15    ( used_Nmod15  ) ,
    //
    .oP         ( used_P       ) ,
    .oP0comp    (              ) , // n.u.
    .oPincr     ( used_Pincr   )
  );

  assign used_code    = icode_ctx.code;

  assign ptab__iptype = icode_ctx.ptype;

  //------------------------------------------------------------------------------------------------------
  // input data buffer address generator
  //------------------------------------------------------------------------------------------------------

  rsc_enc_paddr_gen
  paddr_gen
  (
    .iclk     ( iclk    ) ,
    .ireset   ( ireset  ) ,
    .iclkena  ( iclkena ) ,
    //
    .iclear   ( paddr_gen__iclear  ) ,
    .ienable  ( paddr_gen__ienable ) ,
    //
    .iP       ( used_P             ) ,
    .iN       ( used_N             ) ,
    .iPincr   ( used_Pincr         ) ,
    .iPdvbinv ( 1'b1               ) ,
    //
    .oaddr    ( paddr_gen__oaddr   ) ,
    .opaddr   ( paddr_gen__opaddr  ) ,
    .obitinv  ( paddr_gen__obitinv )
  );

  assign paddr_gen__iclear  = ctrl__oaddr_clear;
  assign paddr_gen__ienable = ctrl__oaddr_enable;

  assign oaddr  = paddr_gen__oaddr  [pRADDR_W-1 : 0];
  assign opaddr = paddr_gen__opaddr [pRADDR_W-1 : 0];

  //------------------------------------------------------------------------------------------------------
  // align input buffer read latency
  //------------------------------------------------------------------------------------------------------

  logic buffin_bit_inv;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      buffin_bit_inv <= paddr_gen__obitinv;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // main FSM
  //------------------------------------------------------------------------------------------------------

  rsc_enc_ctrl
  ctrl
  (
    .iclk         ( iclk               ) ,
    .ireset       ( ireset             ) ,
    .iclkena      ( iclkena            ) ,
    //
    .idbsclk      ( idbsclk            ) ,
    //
    .icode        ( used_code          ) ,
    .iN           ( used_N             ) ,
    //
    .ibuf_full    ( irbuf_full         ) ,
    .obuf_empty   ( orempty            ) ,
    .iobuf_empty  ( iwbuf_empty        ) ,
    //
    .oaddr_clear  ( ctrl__oaddr_clear  ) ,
    .oaddr_enable ( ctrl__oaddr_enable ) ,
    //
    .ostate_clear ( ctrl__ostate_clear ) ,
    .ostate_load  ( ctrl__ostate_load  ) ,
    //
    .osop         ( ctrl__osop         ) ,
    .oeop         ( ctrl__oeop         ) ,
    .oval         ( ctrl__oval         ) ,
    .olast        ( ctrl__olast        ) ,
    .ostage       ( ctrl__ostage       )
  );

  //------------------------------------------------------------------------------------------------------
  // convolution coders with SC counters
  //------------------------------------------------------------------------------------------------------

  generate
    genvar i;
    for (i = 0; i < 2; i++) begin : engine_inst
      rsc2_enc_conv_engine
      #(
        .pTAG_W ( 3 )
      )
      enc
      (
        .iclk    ( iclk             ) ,
        .ireset  ( ireset           ) ,
        .iclkena ( iclkena          ) ,
        //
        .iclear  ( enc__iclear      ) ,
        .iload   ( enc__iload       ) ,
        .istate  ( enc__istate  [i] ) ,
        //
        .isop    ( enc__isop        ) ,
        .ival    ( enc__ival        ) ,
        .ieop    ( enc__ieop        ) ,
        .idat    ( enc__idat    [i] ) ,
        .itag    ( enc__itag        ) ,
        //
        .osop    ( enc__osop    [i] ) ,
        .oval    ( enc__oval    [i] ) ,
        .oeop    ( enc__oeop    [i] ) ,
        .otag    ( enc__otag    [i] ) ,
        .odat    ( enc__odat    [i] ) ,
        .odaty   ( enc__odaty   [i] ) ,
        .odatw   ( enc__odatw   [i] ) ,
        .ostate  ( enc__ostate  [i] )
      );

      rsc2_sctable
      sctab0
      (
        .iclk     ( iclk            ) ,
        .ireset   ( ireset          ) ,
        .iclkena  ( iclkena         ) ,
        //
        .iNmod15  ( used_Nmod15     ) ,
        //
        .istate   ( enc__ostate [i] ) ,
        .ostate   ( enc__istate [i] ) ,
        .ostate_r (                 )
      );
    end
  endgenerate

  assign enc__idat[1] = irdat;
  assign enc__idat[0] = buffin_bit_inv ? {irpdat[0], irpdat[1]} : irpdat;

  //
  // align input buffer read latency
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      enc__ival <= 1'b0;
    end
    else if (iclkena) begin
      enc__ival <= ctrl__oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      enc__iclear <=  ctrl__ostate_clear;
      enc__iload  <=  ctrl__ostate_load ;
      //
      enc__isop   <=  ctrl__osop;
      enc__ieop   <=  ctrl__oeop;
      enc__itag   <= {ctrl__olast, ctrl__ostage};
      //
      used_code_r[0] <= used_code;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // align engine delay
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      used_code_r[1] <= used_code_r[0];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // puncture modules has 1 tick delay
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      punct_val <= 1'b0;
    end
    else if (iclkena) begin
      punct_val <= enc__oval [1];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      punct_dat   <= enc__odat [1];
      punct_sop   <= enc__osop [1] & (enc__otag[1][1 : 0] == 0);
      punct_eop   <= enc__oeop [1] & (enc__otag[1][1 : 0] == 0);
      punct_eof   <= enc__oeop [1] &  enc__otag[1][2];
      punct_type  <= enc__otag [1][1 : 0] ;
    end
  end

  rsc2_enc_punct
  #(
    .pWnY ( 0 )
  )
  puncty
  (
    .iclk    ( iclk           ) ,
    .ireset  ( ireset         ) ,
    .iclkena ( iclkena        ) ,
    //
    .icode   ( used_code_r[1] ) ,
    //
    .isop    ( enc__osop  [1] ) ,
    .ival    ( enc__oval  [1] ) ,
    .idat    ( enc__odaty     ) ,
    //
    .oval    ( puncty__oval   ) ,
    .odat    ( puncty__odat   )
  );

  rsc2_enc_punct
  #(
    .pWnY ( 1 )
  )
  punctw
  (
    .iclk    ( iclk           ) ,
    .ireset  ( ireset         ) ,
    .iclkena ( iclkena        ) ,
    //
    .icode   ( used_code_r[1] ) ,
    //
    .isop    ( enc__osop  [1] ) ,
    .ival    ( enc__oval  [1] ) ,
    .idat    ( enc__odatw     ) ,
    //
    .oval    ( punctw__oval   ) ,
    .odat    ( punctw__odat   )
  );

  //------------------------------------------------------------------------------------------------------
  // output stream assembler
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= punct_sop;
      oeop <= punct_eop;
      //
      if (punct_val) begin
        case (punct_type)
          2'b00   : odat <= punct_dat;
          2'b01   : odat <= puncty__odat;
          2'b10   : odat <= punctw__odat;
          default : begin end
        endcase
        //
        if (punct_sop) begin
          otag <= irtag;
        end
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
      oeof <= 1'b0; // is single strobe too
    end
    else if (iclkena) begin
      oeof <= punct_eof;
      case (punct_type)
        2'b00   : oval <= punct_val;
        2'b01   : oval <= puncty__oval;
        2'b10   : oval <= punctw__oval;
        default : oval <= punct_val;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output ram converter
  //------------------------------------------------------------------------------------------------------

  // make 1 tick offset to get owaddr == number of output dbits
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owfull <= 1'b0;
    end
    else if (iclkena) begin
      owfull <= oeof;
    end
  end

  assign owrite = oval;
  assign owdat  = odat;
  assign owtag  = otag;

  // ownum has enough bitwidth because its x3 of input maximum data length
  assign ownum  = owaddr; // +1 of last owaddr because owfull has 1 tick offset

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owaddr <= (punct_val & punct_sop) ? '0 : (owaddr + owrite);
    end
  end

endmodule

