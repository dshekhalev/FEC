/*


  parameter int pSYMB_M_W          =  4 ;
  parameter int pTRB_LENGTH        = 64 ;
  parameter bit pUSE_FAST_DECISION =  0 ;


  logic           tcm_dec_trb__iclk              ;
  logic           tcm_dec_trb__ireset            ;
  logic           tcm_dec_trb__iclkena           ;
  logic           tcm_dec_trb__isop              ;
  logic           tcm_dec_trb__ival              ;
  logic           tcm_dec_trb__ieop              ;
  statem_t        tcm_dec_trb__istatem           ;
  decision_t      tcm_dec_trb__idecision         ;
  symb_m_idx_t    tcm_dec_trb__isymb_m_idx  [16] ;
  symb_m_sign_t   tcm_dec_trb__isymb_m_sign  [4] ;
  symb_hd_t       tcm_dec_trb__isymb_hd          ;
  logic           tcm_dec_trb__osop              ;
  logic           tcm_dec_trb__oval              ;
  logic           tcm_dec_trb__oeop              ;
  trel_bm_idx_t   tcm_dec_trb__obm_idx           ;
  symb_m_idx_t    tcm_dec_trb__osymb_m_idx       ;
  symb_m_sign_t   tcm_dec_trb__osymb_m_sign  [4] ;
  symb_hd_t       tcm_dec_trb__osymb_hd          ;



  tcm_dec_trb
  #(
    .pSYMB_M_W          ( pSYMB_M_W          ) ,
    .pTRB_LENGTH        ( pTRB_LENGTH        ) ,
    .pUSE_FAST_DECISION ( pUSE_FAST_DECISION )
  )
  tcm_dec_trb
  (
    .iclk         ( tcm_dec_trb__iclk         ) ,
    .ireset       ( tcm_dec_trb__ireset       ) ,
    .iclkena      ( tcm_dec_trb__iclkena      ) ,
    .isop         ( tcm_dec_trb__isop         ) ,
    .ival         ( tcm_dec_trb__ival         ) ,
    .ieop         ( tcm_dec_trb__ieop         ) ,
    .istatem      ( tcm_dec_trb__istatem      ) ,
    .idecision    ( tcm_dec_trb__idecision    ) ,
    .isymb_m_idx  ( tcm_dec_trb__isymb_m_idx  ) ,
    .isymb_m_sign ( tcm_dec_trb__isymb_m_sign ) ,
    .isymb_hd     ( tcm_dec_trb__isymb_hd     ) ,
    .osop         ( tcm_dec_trb__osop         ) ,
    .oval         ( tcm_dec_trb__oval         ) ,
    .oeop         ( tcm_dec_trb__oeop         ) ,
    .obm_idx      ( tcm_dec_trb__obm_idx      ) ,
    .osymb_m_idx  ( tcm_dec_trb__osymb_m_idx  ) ,
    .osymb_m_sign ( tcm_dec_trb__osymb_m_sign ) ,
    .osymb_hd     ( tcm_dec_trb__osymb_hd     )
  );


  assign tcm_dec_trb__iclk         = '0 ;
  assign tcm_dec_trb__ireset       = '0 ;
  assign tcm_dec_trb__iclkena      = '0 ;
  assign tcm_dec_trb__isop         = '0 ;
  assign tcm_dec_trb__ival         = '0 ;
  assign tcm_dec_trb__ieop         = '0 ;
  assign tcm_dec_trb__istatem      = '0 ;
  assign tcm_dec_trb__idecision    = '0 ;
  assign tcm_dec_trb__isymb_m_idx  = '0 ;
  assign tcm_dec_trb__isymb_m_sign = '0 ;
  assign tcm_dec_trb__isymb_hd     = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_trb.sv
// Description   : viterbi traceback top unit
//

`include "define.vh"

module tcm_dec_trb
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  isop         ,
  ival         ,
  ieop         ,
  istatem      ,
  idecision    ,
  isymb_m_idx  ,
  isymb_m_sign ,
  isymb_hd     ,
  //
  osop         ,
  oval         ,
  oeop         ,
  obm_idx      ,
  osymb_m_idx  ,
  osymb_m_sign ,
  osymb_hd
);

  parameter bit pUSE_FAST_DECISION = 1; // use fast decision (state 0) for usual (not flush) treaceback

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk               ;
  input  logic            ireset             ;
  input  logic            iclkena            ;
  //
  input  logic            isop               ;
  input  logic            ival               ;
  input  logic            ieop               ;
  input  statem_t         istatem            ;
  input  decision_t       idecision          ;
  input  symb_m_idx_t     isymb_m_idx   [16] ;
  input  symb_m_sign_t    isymb_m_sign   [4] ;
  input  symb_hd_t        isymb_hd           ;
  //
  output logic            osop               ;
  output logic            oval               ;
  output logic            oeop               ;
  output trel_bm_idx_t    obm_idx            ; // branch metric decision
  output symb_m_idx_t     osymb_m_idx        ; // subgroup decision
  output symb_m_sign_t    osymb_m_sign   [4] ; // metric signums for reconstruction
  output symb_hd_t        osymb_hd           ; // hard decision

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cTRB_RAM_DAT_W  = 2 + 4*2 + 4*4 + 16*4 + cSTATE_NUM*3; // {sop, eop, symb_hd[4], symb_m_sign[4], symb_m_idx[16], state_decision[64]}

  localparam int cTRB_LIFO_DAT_W = 2 + 4*2 + 4*4 + 4 + 4; // {sop, eop, symb_hd[4], symb_m_sign[4], symb_m_idx, bm_idx}

  typedef logic  [cTRB_RAM_DAT_W-1 : 0] trb_ram_dat_t;
  typedef logic [cTRB_LIFO_DAT_W-1 : 0] trb_lifo_dat_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // ctrl
  logic           ctrl__owrite             ;
  trb_ram_addr_t  ctrl__owaddr             ;
  logic           ctrl__owsop              ;
  logic           ctrl__oweop              ;
  decision_t      ctrl__owdecision         ;
  symb_m_idx_t    ctrl__owsymb_m_idx  [16] ;
  symb_m_sign_t   ctrl__owsymb_m_sign  [4] ;
  symb_hd_t       ctrl__owsymb_hd          ;

  logic           ctrl__otrb_flush     ;
  trb_ram_addr_t  ctrl__otrb_fraddr    ;
  trb_ram_addr_t  ctrl__otrb_fsize_m1  ;
  stateb_t        ctrl__otrb_fstate    ;

  logic           ctrl__otrb_start     ;
  trb_ram_addr_t  ctrl__otrb_raddr     ;
  trb_ram_addr_t  ctrl__otrb_size_m1   ;
  stateb_t        ctrl__otrb_state     ;

  //
  // RAM
  logic           ram__iwrite ;
  trb_ram_addr_t  ram__iwaddr ;
  trb_ram_dat_t   ram__iwdata ;
  trb_ram_addr_t  ram__iraddr ;
  trb_ram_dat_t   ram__ordata ;

  //
  // engine
  logic           engine__irsop              ;
  logic           engine__ireop              ;
  decision_t      engine__irdecision         ;
  symb_m_idx_t    engine__irsymb_m_idx  [16] ;
  symb_m_sign_t   engine__irsymb_m_sign  [4] ;
  symb_hd_t       engine__irsymb_hd          ;
  trb_ram_addr_t  engine__oraddr             ;

  logic           engine__ordy               ;

  logic           engine__owrite             ;
  logic           engine__oflush             ;
  trb_lifo_addr_t engine__owaddr             ;
  logic           engine__owsop              ;
  logic           engine__oweop              ;
  trel_bm_idx_t   engine__owbm_idx           ;
  symb_m_idx_t    engine__owsymb_m_idx       ;
  symb_m_sign_t   engine__owsymb_m_sign  [4] ;
  symb_hd_t       engine__owsymb_hd          ;

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

  tcm_dec_trb_ctrl
  #(
    .pSYMB_M_W          ( pSYMB_M_W          ) ,
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
    .idecision       ( idecision            ) ,
    .isymb_m_idx     ( isymb_m_idx          ) ,
    .isymb_m_sign    ( isymb_m_sign         ) ,
    .isymb_hd        ( isymb_hd             ) ,
    // ram control
    .owrite          ( ctrl__owrite         ) ,
    .owaddr          ( ctrl__owaddr         ) ,
    .owsop           ( ctrl__owsop          ) ,
    .oweop           ( ctrl__oweop          ) ,
    .owdecision      ( ctrl__owdecision     ) ,
    .owsymb_m_idx    ( ctrl__owsymb_m_idx   ) ,
    .owsymb_m_sign   ( ctrl__owsymb_m_sign  ) ,
    .owsymb_hd       ( ctrl__owsymb_hd      ) ,
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
  logic         [16*4-1 : 0] ctrl_wsymb_m_idx;
  logic          [4*4-1 : 0] ctrl_wsymb_m_sign;
  logic          [4*2-1 : 0] ctrl_wsymb_hd;

  always_comb begin
    for (int i = 0; i < cSTATE_NUM; i++) begin
      ctrl_wdecision[3*i +: 3]    = ctrl__owdecision[i];
    end
    for (int i = 0; i < 16; i++) begin
      ctrl_wsymb_m_idx[4*i +: 4]  = ctrl__owsymb_m_idx[i];
    end
    for (int i = 0; i < 4; i++) begin
      ctrl_wsymb_m_sign [4*i +: 4] = ctrl__owsymb_m_sign[i];
      ctrl_wsymb_hd     [2*i +: 2] = ctrl__owsymb_hd    [i];
    end
  end

  assign ram__iwdata = {ctrl__owsop, ctrl__oweop, ctrl_wsymb_hd, ctrl_wsymb_m_sign, ctrl_wsymb_m_idx, ctrl_wdecision};

  assign ram__iraddr = engine__oraddr;

  //------------------------------------------------------------------------------------------------------
  // traceback engine
  //------------------------------------------------------------------------------------------------------

  tcm_dec_trb_engine
  #(
    .pTRB_LENGTH ( pTRB_LENGTH )
  )
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
    .irsymb_m_idx  ( engine__irsymb_m_idx  ) ,
    .irsymb_m_sign ( engine__irsymb_m_sign ) ,
    .irsymb_hd     ( engine__irsymb_hd     ) ,
    .oraddr        ( engine__oraddr        ) ,
    // lifo
    .owrite        ( engine__owrite        ) ,
    .oflush        ( engine__oflush        ) ,
    .owaddr        ( engine__owaddr        ) ,
    .owsop         ( engine__owsop         ) ,
    .oweop         ( engine__oweop         ) ,
    .owbm_idx      ( engine__owbm_idx      ) ,
    .owsymb_m_idx  ( engine__owsymb_m_idx  ) ,
    .owsymb_m_sign ( engine__owsymb_m_sign ) ,
    .owsymb_hd     ( engine__owsymb_hd     )
  );

  logic [cSTATE_NUM*3-1 : 0] engine_rdecision;
  logic         [16*4-1 : 0] engine_rsymb_m_idx;
  logic          [4*4-1 : 0] engine_rsymb_m_sign;
  logic          [4*2-1 : 0] engine_rsymb_hd;

  assign {engine__irsop, engine__ireop, engine_rsymb_hd, engine_rsymb_m_sign, engine_rsymb_m_idx, engine_rdecision} = ram__ordata;

  always_comb begin
    for (int i = 0; i < cSTATE_NUM; i++) begin
      engine__irdecision[i] = engine_rdecision[3*i +: 3];
    end
    for (int i = 0; i < 16; i++) begin
      engine__irsymb_m_idx[i] = engine_rsymb_m_idx[4*i +: 4];
    end
    for (int i = 0; i < 4; i++) begin
      engine__irsymb_m_sign[i] = engine_rsymb_m_sign[4*i +: 4];
      engine__irsymb_hd    [i] = engine_rsymb_hd    [2*i +: 2];
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

  logic [4*4-1 : 0] engine_symb_m_sign;
  logic [4*2-1 : 0] engine_symb_hd;

  always_comb begin
    for (int i = 0; i < 4; i++) begin
      engine_symb_m_sign[4*i +: 4] = engine__owsymb_m_sign[i];
      engine_symb_hd    [2*i +: 2] = engine__owsymb_hd    [i];
    end
  end

  assign lifo__iwdat  = {engine__owsop, engine__oweop, engine_symb_hd, engine_symb_m_sign, engine__owsymb_m_idx, engine__owbm_idx};

  //------------------------------------------------------------------------------------------------------
  // output mapping & error counter
  //------------------------------------------------------------------------------------------------------

  logic             sop       ;
  logic             eop       ;
  trel_bm_idx_t     bm_idx    ;
  symb_m_idx_t      symb_m_idx;

  logic [4*4-1 : 0] wsymb_m_sign;
  logic [4*2-1 : 0] wsymb_hd    ;

  symb_m_sign_t     symb_m_sign [4] ;
  symb_hd_t         symb_hd         ;

  assign {sop, eop, wsymb_hd, wsymb_m_sign, symb_m_idx, bm_idx} = lifo__odat;

  always_comb begin
    for (int i = 0; i < 4; i++) begin
      symb_m_sign[i] = wsymb_m_sign[4*i +: 4];
      symb_hd    [i] = wsymb_hd    [2*i +: 2];
    end
  end

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
        obm_idx       <= bm_idx;
        osymb_m_idx   <= symb_m_idx;
        osymb_m_sign  <= symb_m_sign;
        osymb_hd      <= symb_hd;
      end
    end
  end

endmodule
