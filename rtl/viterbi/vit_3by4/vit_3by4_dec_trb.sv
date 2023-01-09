/*


  parameter int pLLR_W             =  4 ;
  parameter int pTRB_LENGTH        = 64 ;
  parameter int pERR_CNT_W         = 16 ;
  parameter bit pUSE_FAST_DECISION =  0 ;
  parameter int pTAG_W             =  4 ;


  logic           vit_3by4_dec_trb__iclk      ;
  logic           vit_3by4_dec_trb__ireset    ;
  logic           vit_3by4_dec_trb__iclkena   ;
  logic           vit_3by4_dec_trb__isop      ;
  logic           vit_3by4_dec_trb__ival      ;
  logic           vit_3by4_dec_trb__ieop      ;
  tag_t           vit_3by4_dec_trb__itag      ;
  boutputs_t      vit_3by4_dec_trb__ihd       ;
  statem_t        vit_3by4_dec_trb__istatem   ;
  decision_t      vit_3by4_dec_trb__idecision ;
  logic           vit_3by4_dec_trb__osop      ;
  logic           vit_3by4_dec_trb__oval      ;
  logic           vit_3by4_dec_trb__oeop      ;
  tag_t           vit_3by4_dec_trb__otag      ;
  trel_decision_t vit_3by4_dec_trb__odat      ;
  logic   [1 : 0] vit_3by4_dec_trb__obiterr   ;
  errcnt_t        vit_3by4_dec_trb__oerrcnt   ;



  vit_3by4_dec_trb
  #(
    .pLLR_W             ( pLLR_W             ) ,
    .pTRB_LENGTH        ( pTRB_LENGTH        ) ,
    .pERR_CNT_W         ( pERR_CNT_W         ) ,
    .pUSE_FAST_DECISION ( pUSE_FAST_DECISION ) ,
    .pTAG_W             ( pTAG_W             )
  )
  vit_3by4_dec_trb
  (
    .iclk      ( vit_3by4_dec_trb__iclk      ) ,
    .ireset    ( vit_3by4_dec_trb__ireset    ) ,
    .iclkena   ( vit_3by4_dec_trb__iclkena   ) ,
    .isop      ( vit_3by4_dec_trb__isop      ) ,
    .ival      ( vit_3by4_dec_trb__ival      ) ,
    .ieop      ( vit_3by4_dec_trb__ieop      ) ,
    .itag      ( vit_3by4_dec_trb__itag      ) ,
    .ihd       ( vit_3by4_dec_trb__ihd       ) ,
    .istatem   ( vit_3by4_dec_trb__istatem   ) ,
    .idecision ( vit_3by4_dec_trb__idecision ) ,
    .osop      ( vit_3by4_dec_trb__osop      ) ,
    .oval      ( vit_3by4_dec_trb__oval      ) ,
    .oeop      ( vit_3by4_dec_trb__oeop      ) ,
    .otag      ( vit_3by4_dec_trb__otag      ) ,
    .odat      ( vit_3by4_dec_trb__odat      ) ,
    .obiterr   ( vit_3by4_dec_trb__obiterr   ) ,
    .oerrcnt   ( vit_3by4_dec_trb__oerrcnt   )
  );


  assign vit_3by4_dec_trb__iclk         = '0 ;
  assign vit_3by4_dec_trb__ireset       = '0 ;
  assign vit_3by4_dec_trb__iclkena      = '0 ;
  assign vit_3by4_dec_trb__isop         = '0 ;
  assign vit_3by4_dec_trb__ival         = '0 ;
  assign vit_3by4_dec_trb__ieop         = '0 ;
  assign vit_3by4_dec_trb__itag         = '0 ;
  assign vit_3by4_dec_trb__ihd          = '0
  assign vit_3by4_dec_trb__istatem      = '0 ;
  assign vit_3by4_dec_trb__idecision    = '0 ;
  assign vit_3by4_dec_trb__ihd          = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_dec_trb.sv
// Description   : viterbi traceback top unit
//


module vit_3by4_dec_trb
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  isop        ,
  ival        ,
  ieop        ,
  itag        ,
  istatem     ,
  idecision   ,
  ihd         ,
  //
  osop        ,
  oval        ,
  oeop        ,
  otag        ,
  odat        ,
  obiterr     ,
  oerrcnt
);

  parameter bit pUSE_FAST_DECISION = 1; // use fast decision (state 0) for usual (not flush) treaceback

  `include "vit_3by4_trellis.svh"
  `include "vit_3by4_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk      ;
  input  logic           ireset    ;
  input  logic           iclkena   ;
  //
  input  logic           isop      ;
  input  logic           ival      ;
  input  logic           ieop      ;
  input  tag_t           itag      ;
  input  boutputs_t      ihd       ;
  input  statem_t        istatem   ;
  input  decision_t      idecision ;
  //
  output logic           osop      ;
  output logic           oval      ;
  output logic           oeop      ;
  output tag_t           otag      ;
  output trel_decision_t odat      ;
  output logic  [1 : 0]  obiterr   ;
  output errcnt_t        oerrcnt   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cTRB_RAM_DAT_W  = 2 + 4 + cSTATE_NUM*3; // {sop, eop, hd[4], state_decisions[3][cSTATE_NUM]}

  localparam int cTRB_LIFO_DAT_W = 2 + 4 + 3; // {sop, eop, biterr[4], decision[3]}

  typedef logic  [cTRB_RAM_DAT_W-1 : 0] trb_ram_dat_t;
  typedef logic [cTRB_LIFO_DAT_W-1 : 0] trb_lifo_dat_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // ctrl
  logic           ctrl__owrite        ;
  trb_ram_addr_t  ctrl__owaddr        ;
  logic           ctrl__owsop         ;
  logic           ctrl__oweop         ;
  decision_t      ctrl__owdecision    ;
  boutputs_t      ctrl__owhd          ;

  logic           ctrl__otrb_flush    ;
  trb_ram_addr_t  ctrl__otrb_fraddr   ;
  trb_ram_addr_t  ctrl__otrb_fsize_m1 ;
  stateb_t        ctrl__otrb_fstate   ;

  logic           ctrl__otrb_start    ;
  trb_ram_addr_t  ctrl__otrb_raddr    ;
  trb_ram_addr_t  ctrl__otrb_size_m1  ;
  stateb_t        ctrl__otrb_state    ;

  //
  // RAM
  logic           ram__iwrite ;
  trb_ram_addr_t  ram__iwaddr ;
  trb_ram_dat_t   ram__iwdata ;
  trb_ram_addr_t  ram__iraddr ;
  trb_ram_dat_t   ram__ordata ;

  //
  // engine
  logic           engine__irsop      ;
  logic           engine__ireop      ;
  decision_t      engine__irdecision ;
  boutputs_t      engine__irhd       ;
  trb_ram_addr_t  engine__oraddr     ;

  logic           engine__ordy       ;

  logic           engine__owrite     ;
  logic           engine__oflush     ;
  trb_lifo_addr_t engine__owaddr     ;
  logic           engine__owsop      ;
  logic           engine__oweop      ;
  trel_decision_t engine__owdat      ;
  boutputs_t      engine__owbiterr   ;

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

  vit_3by4_dec_trb_ctrl
  #(
    .pLLR_W             ( pLLR_W             ) ,
    .pTRB_LENGTH        ( pTRB_LENGTH        ) ,
    .pUSE_FAST_DECISION ( pUSE_FAST_DECISION )
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
    .istatem         ( istatem              ) ,
    .ihd             ( ihd                  ) ,
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
    .otrb_flush      ( ctrl__otrb_flush     ) ,
    .otrb_fraddr     ( ctrl__otrb_fraddr    ) ,
    .otrb_fsize_m1   ( ctrl__otrb_fsize_m1  ) ,
    .otrb_fstate     ( ctrl__otrb_fstate    ) ,
    //
    .otrb_start      ( ctrl__otrb_start     ) ,
    .otrb_raddr      ( ctrl__otrb_raddr     ) ,
    .otrb_size_m1    ( ctrl__otrb_size_m1   ) ,
    .otrb_state      ( ctrl__otrb_state     )
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

  logic [cSTATE_NUM*3-1 : 0] ctrl_wdecision;

  always_comb begin
    for (int i = 0; i < cSTATE_NUM; i++) begin
      ctrl_wdecision[3*i +: 3] = ctrl__owdecision[i];
    end
  end

  assign ram__iwdata = {ctrl__owsop, ctrl__oweop, ctrl__owhd, ctrl_wdecision};

  assign ram__iraddr = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // traceback engine
  //------------------------------------------------------------------------------------------------------

  vit_3by4_dec_trb_engine
  engine
  (
    .iclk          ( iclk                  ) ,
    .ireset        ( ireset                ) ,
    .iclkena       ( iclkena               ) ,
    // control
    .istart        ( ctrl__otrb_start      ) ,  // can be out of order
    .iraddr        ( ctrl__otrb_raddr      ) ,
    .isize_m1      ( ctrl__otrb_size_m1    ) ,
    .istate        ( ctrl__otrb_state      ) ,
    //
    .iflush        ( ctrl__otrb_flush      ) ,  // can be out of order
    .ifraddr       ( ctrl__otrb_fraddr     ) ,
    .ifsize_m1     ( ctrl__otrb_fsize_m1   ) ,
    .ifstate       ( ctrl__otrb_fstate     ) ,
    //
    .ordy          ( engine__ordy          ) ,
    // trb ram
    .irsop         ( engine__irsop         ) ,
    .ireop         ( engine__ireop         ) ,
    .irdecision    ( engine__irdecision    ) ,
    .irhd          ( engine__irhd          ) ,
    .oraddr        ( engine__oraddr        ) ,
    // lifo
    .owrite        ( engine__owrite        ) ,
    .oflush        ( engine__oflush        ) ,
    .owaddr        ( engine__owaddr        ) ,
    .owsop         ( engine__owsop         ) ,
    .oweop         ( engine__oweop         ) ,
    .owdat         ( engine__owdat         ) ,
    .owbiterr      ( engine__owbiterr      )
  );

  logic [cSTATE_NUM*3-1 : 0] engine_rdecision;

  assign {engine__irsop, engine__ireop, engine__irhd, engine_rdecision} = ram__ordata;

  always_comb begin
    for (int i = 0; i < cSTATE_NUM; i++) begin
      engine__irdecision[i] = engine_rdecision[3*i +: 3];
    end
  end

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

  assign lifo__iwdat  = {engine__owsop, engine__oweop, engine__owbiterr, engine__owdat};

  //------------------------------------------------------------------------------------------------------
  // output mapping & error counter
  //------------------------------------------------------------------------------------------------------

  logic             sop       ;
  logic             eop       ;
  trel_decision_t   dat       ;
  boutputs_t        biterr    ;

  assign {sop, eop, biterr, dat} = lifo__odat;

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
        odat    <= dat;
        obiterr <= get_bit_err(biterr);
        oerrcnt <= sop ? get_bit_err(biterr) : (oerrcnt + get_bit_err(biterr));
      end
    end
  end

  function automatic logic [1 : 0] get_bit_err (input boutputs_t biterr);
    get_bit_err = 0;
    for (int i = 0; i < 4; i++) begin
      get_bit_err = get_bit_err + biterr[i];
    end
  endfunction

endmodule
