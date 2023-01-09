/*


  parameter int pCONSTR_LENGTH            = 3;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};
  parameter int pLLR_W                    = 4;
  parameter int pTRB_LENGTH               = 5*pCONSTR_LENGTH;
  parameter int pERR_CNT_W                = 16 ;
  parameter int pTAG_W                    = 4 ;



  logic      vit_trb__iclk       ;
  logic      vit_trb__ireset     ;
  logic      vit_trb__iclkena    ;
  logic      vit_trb__isop       ;
  logic      vit_trb__ival       ;
  logic      vit_trb__ieop       ;
  tag_t      vit_trb__itag       ;
  boutputs_t vit_trb__ihd        ;
  statem_t   vit_trb__istatem    ;
  decision_t vit_trb__idecision  ;
  logic      vit_trb__osop       ;
  logic      vit_trb__oval       ;
  logic      vit_trb__oeop       ;
  tag_t      vit_trb__otag       ;
  logic      vit_trb__odat       ;
  boutputs_t vit_trb__obiterr    ;
  errcnt_t   vit_trb__oerrcnt    ;



  vit_trb
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pTRB_LENGTH    ( pTRB_LENGTH    ) ,
    .pERR_CNT_W     ( pERR_CNT_W     ) ,
    .pTAG_W         ( pTAG_W         )
  )
  vit_trb
  (
    .iclk      ( vit_trb__iclk      ) ,
    .ireset    ( vit_trb__ireset    ) ,
    .iclkena   ( vit_trb__iclkena   ) ,
    .isop      ( vit_trb__isop      ) ,
    .ival      ( vit_trb__ival      ) ,
    .ieop      ( vit_trb__ieop      ) ,
    .itag      ( vit_trb__itag      ) ,
    .ihd       ( vit_trb__ihd       ) ,
    .istatem   ( vit_trb__istatem   ) ,
    .idecision ( vit_trb__idecision ) ,
    .osop      ( vit_trb__osop      ) ,
    .oval      ( vit_trb__oval      ) ,
    .oeop      ( vit_trb__oeop      ) ,
    .otag      ( vit_trb__otag      ) ,
    .odat      ( vit_trb__odat      ) ,
    .obiterr   ( vit_trb__obiterr   ) ,
    .oerrcnt   ( vit_trb__oerrcnt   )
  );


  assign vit_trb__iclk      = '0 ;
  assign vit_trb__ireset    = '0 ;
  assign vit_trb__iclkena   = '0 ;
  assign vit_trb__isop      = '0 ;
  assign vit_trb__ival      = '0 ;
  assign vit_trb__ieop      = '0 ;
  assign vit_trb__itag      = '0 ;
  assign vit_trb__ihd       = '0 ;
  assign vit_trb__istatem   = '0 ;
  assign vit_trb__idecision = '0 ;



*/

//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_trb.sv
// Description   : viterbi traceback top unit
//


module vit_trb
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  isop      ,
  ival      ,
  ieop      ,
  itag      ,
  ihd       ,
  istatem   ,
  idecision ,
  //
  osop      ,
  oval      ,
  oeop      ,
  otag      ,
  odat      ,
  obiterr   ,
  oerrcnt
);

  `include "vit_trellis.svh"
  `include "vit_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk      ;
  input  logic      ireset    ;
  input  logic      iclkena   ;
  //
  input  logic      isop      ;
  input  logic      ival      ;
  input  logic      ieop      ;
  input  tag_t      itag      ;
  input  boutputs_t ihd       ;
  input  statem_t   istatem   ;
  input  decision_t idecision ;
  //
  output logic      osop      ;
  output logic      oval      ;
  output logic      oeop      ;
  output tag_t      otag      ;
  output logic      odat      ;
  output boutputs_t obiterr   ;
  output errcnt_t   oerrcnt   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cTRB_RAM_DAT_W  = 2 + pCODE_GEN_NUM + cSTATE_NUM; // {sop, eop, hd,        state_decisions}
  localparam int cTRB_LIFO_DAT_W = 2 + pTAG_W + pCODE_GEN_NUM + 1; // {tag, sop, eop, hd_biterr, data}

  typedef logic  [cTRB_RAM_DAT_W-1 : 0] trb_ram_dat_t;
  typedef logic [cTRB_LIFO_DAT_W-1 : 0] trb_lifo_dat_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // ctrl
  logic           ctrl__owrite         ;
  trb_ram_addr_t  ctrl__owaddr         ;
  logic           ctrl__owsop          ;
  logic           ctrl__oweop          ;
  boutputs_t      ctrl__owhd           ;
  decision_t      ctrl__owdecision     ;

  tag_t           ctrl__otrb_tag       ;

  logic           ctrl__otrb_flush     ;
  trb_ram_addr_t  ctrl__otrb_fraddr    ;
  trb_ram_addr_t  ctrl__otrb_fsize_m1  ;
  trb_ram_addr_t  ctrl__otrb_fterm_idx ;
  stateb_t        ctrl__otrb_fstate    ;
  logic           ctrl__otrb_fdecision ;

  logic           ctrl__otrb_start     ;
  trb_ram_addr_t  ctrl__otrb_raddr     ;
  trb_ram_addr_t  ctrl__otrb_size_m1   ;
  trb_ram_addr_t  ctrl__otrb_term_idx  ;
  stateb_t        ctrl__otrb_state     ;
  logic           ctrl__otrb_decision  ;

  //
  // RAM
  logic           ram__iwrite ;
  trb_ram_addr_t  ram__iwaddr ;
  trb_ram_dat_t   ram__iwdata ;
  trb_ram_addr_t  ram__iraddr ;
  trb_ram_dat_t   ram__ordata ;

  //
  // engine
  logic           engine__irsop       ;
  logic           engine__ireop       ;
  boutputs_t      engine__irhd        ;
  decision_t      engine__irdecision  ;
  trb_ram_addr_t  engine__oraddr      ;

  logic           engine__ordy        ;

  logic           engine__owrite      ;
  logic           engine__oflush      ;
  trb_lifo_addr_t engine__owaddr      ;
  logic           engine__owsop       ;
  logic           engine__oweop       ;
  tag_t           engine__owtag       ;
  logic           engine__owdat       ;
  boutputs_t      engine__owbiterr    ;

  //
  // LIFO
  logic           lifo__iwrite;
  logic           lifo__iflush;
  trb_lifo_addr_t lifo__iwaddr;
  trb_lifo_dat_t  lifo__iwdat;

  logic           lifo__oval;
  trb_lifo_dat_t  lifo__odat;

  //------------------------------------------------------------------------------------------------------
  // trb main FSM
  //------------------------------------------------------------------------------------------------------

  vit_trb_ctrl
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    //
    .pLLR_W         ( pLLR_W         ) ,
    //
    .pTRB_LENGTH    ( pTRB_LENGTH    ) ,
    //
    .pTAG_W         ( pTAG_W         )
  )
  ctrl
  (
    .iclk            ( iclk                 ) ,
    .ireset          ( ireset               ) ,
    .iclkena         ( iclkena              ) ,
    // rp interfrace
    .isop            ( isop                 ) ,
    .ival            ( ival                 ) ,
    .ieop            ( ieop                 ) ,
    .itag            ( itag                 ) ,
    .ihd             ( ihd                  ) ,
    .istatem         ( istatem              ) ,
    .idecision       ( idecision            ) ,
    // ram control
    .owrite          ( ctrl__owrite         ) ,
    .owaddr          ( ctrl__owaddr         ) ,
    .owsop           ( ctrl__owsop          ) ,
    .oweop           ( ctrl__oweop          ) ,
    .owhd            ( ctrl__owhd           ) ,
    .owdecision      ( ctrl__owdecision     ) ,
    // trb control
    .itrb_engine_rdy ( engine__ordy         ) ,
    //
    .otrb_tag        ( ctrl__otrb_tag       ) ,
    //
    .otrb_flush      ( ctrl__otrb_flush     ) ,
    .otrb_fraddr     ( ctrl__otrb_fraddr    ) ,
    .otrb_fsize_m1   ( ctrl__otrb_fsize_m1  ) ,
    .otrb_fterm_idx  ( ctrl__otrb_fterm_idx ) ,
    .otrb_fstate     ( ctrl__otrb_fstate    ) ,
    .otrb_fdecision  ( ctrl__otrb_fdecision ) ,
    //
    .otrb_start      ( ctrl__otrb_start     ) ,
    .otrb_raddr      ( ctrl__otrb_raddr     ) ,
    .otrb_size_m1    ( ctrl__otrb_size_m1   ) ,
    .otrb_term_idx   ( ctrl__otrb_term_idx  ) ,
    .otrb_state      ( ctrl__otrb_state     ) ,
    .otrb_decision   ( ctrl__otrb_decision  )
  );

  //------------------------------------------------------------------------------------------------------
  // traceback ram
  //------------------------------------------------------------------------------------------------------

  vit_trb_ram
  #(
    .pADDR_W ( $bits(trb_ram_addr_t) ) ,
    .pDATA_W ( $bits(trb_ram_dat_t)  )
  )
  ram
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .iwrite  ( ram__iwrite  ) ,
    .iwaddr  ( ram__iwaddr  ) ,
    .iwdata  ( ram__iwdata  ) ,
    //
    .iraddr  ( ram__iraddr  ) ,
    .ordata  ( ram__ordata  )
  );

  assign ram__iwrite =  ctrl__owrite;
  assign ram__iwaddr =  ctrl__owaddr;
  assign ram__iwdata = {ctrl__owhd, ctrl__owsop, ctrl__oweop, ctrl__owdecision};

  assign ram__iraddr = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // traceback engine
  //------------------------------------------------------------------------------------------------------

  vit_trb_engine
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    //
    .pTRB_LENGTH    ( pTRB_LENGTH    ) ,
    //
    .pTAG_W         ( pTAG_W         )
  )
  engine
  (
    .iclk       ( iclk                 ) ,
    .ireset     ( ireset               ) ,
    .iclkena    ( iclkena              ) ,
    // control
    .istart     ( ctrl__otrb_start     ) ,  // can be out of order
    .iraddr     ( ctrl__otrb_raddr     ) ,
    .isize_m1   ( ctrl__otrb_size_m1   ) ,
    .ifterm_idx ( ctrl__otrb_fterm_idx ) ,
    .istate     ( ctrl__otrb_state     ) ,
    .idecision  ( ctrl__otrb_decision  ) ,
    //
    .iflush     ( ctrl__otrb_flush     ) ,  // can be out of order
    .ifraddr    ( ctrl__otrb_fraddr    ) ,
    .ifsize_m1  ( ctrl__otrb_fsize_m1  ) ,
    .iterm_idx  ( ctrl__otrb_term_idx  ) ,
    .ifstate    ( ctrl__otrb_fstate    ) ,
    .ifdecision ( ctrl__otrb_fdecision ) ,
    //
    .itag       ( ctrl__otrb_tag       ) ,
    .ordy       ( engine__ordy         ) ,
    // trb ram
    .irsop      ( engine__irsop        ) ,
    .ireop      ( engine__ireop        ) ,
    .irhd       ( engine__irhd         ) ,
    .irdecision ( engine__irdecision   ) ,
    .oraddr     ( engine__oraddr       ) ,
    // lifo
    .owrite     ( engine__owrite       ) ,
    .oflush     ( engine__oflush       ) ,
    .owaddr     ( engine__owaddr       ) ,
    .owsop      ( engine__owsop        ) ,
    .oweop      ( engine__oweop        ) ,
    .owtag      ( engine__owtag        ) ,
    .owdat      ( engine__owdat        ) ,
    .owbiterr   ( engine__owbiterr     )
  );

  assign {engine__irhd, engine__irsop, engine__ireop, engine__irdecision} = ram__ordata;

  //------------------------------------------------------------------------------------------------------
  // 2D LIFO
  //------------------------------------------------------------------------------------------------------

  vit_trb_lifo
  #(
    .pADDR_W ( cTRB_LIFO_ADDR_W ) ,
    .pDAT_W  ( cTRB_LIFO_DAT_W  ) ,
    .pBNUM_W ( 2                )   // 4D
  )
  lifo
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .iwrite  ( lifo__iwrite ) ,
    .iflush  ( lifo__iflush ) ,
    .iwaddr  ( lifo__iwaddr ) ,
    .iwdat   ( lifo__iwdat  ) ,
    //
    .oval    ( lifo__oval   ) ,
    .odat    ( lifo__odat   )
  );

  assign lifo__iwrite =  engine__owrite;
  assign lifo__iflush =  engine__oflush;
  assign lifo__iwaddr =  engine__owaddr;
  assign lifo__iwdat  = {engine__owbiterr, engine__owtag, engine__owsop, engine__oweop, engine__owdat};

  //------------------------------------------------------------------------------------------------------
  // output mapping & error counter
  //------------------------------------------------------------------------------------------------------

  logic      sop    ;
  logic      eop    ;
  tag_t      tag    ;
  logic      dat    ;
  boutputs_t biterr ;

  assign {biterr, tag, sop, eop, dat} = lifo__odat;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= lifo__oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= sop & lifo__oval;
      oeop <= eop & lifo__oval;
      if (lifo__oval) begin
        obiterr <= get_bit_err(biterr);
        odat    <= dat;
        if (sop) begin
          otag <= tag;
        end
        //
        oerrcnt <= sop ? get_bit_err(biterr) : (oerrcnt + get_bit_err(biterr));
      end
    end
  end

  function automatic boutputs_t get_bit_err (input boutputs_t biterr);
    get_bit_err = 0;
    for (int i = 0; i < pCODE_GEN_NUM; i++) begin
      get_bit_err = get_bit_err + biterr[i];
    end
  endfunction

endmodule
