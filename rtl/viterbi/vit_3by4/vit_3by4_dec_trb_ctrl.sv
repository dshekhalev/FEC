/*


  parameter int pLLR_W             =  4 ;
  parameter int pTRB_LENGTH        = 64 ;
  parameter bit pUSE_FAST_DECISION =  0 ;


  logic           vit_3by4_dec_trb_ctrl__iclk              ;
  logic           vit_3by4_dec_trb_ctrl__ireset            ;
  logic           vit_3by4_dec_trb_ctrl__iclkena           ;
  logic           vit_3by4_dec_trb_ctrl__isop              ;
  logic           vit_3by4_dec_trb_ctrl__ival              ;
  logic           vit_3by4_dec_trb_ctrl__ieop              ;
  boutputs_t      vit_3by4_dec_trb_ctrl__ihd               ;
  statem_t        vit_3by4_dec_trb_ctrl__istatem           ;
  decision_t      vit_3by4_dec_trb_ctrl__idecision         ;
  logic           vit_3by4_dec_trb_ctrl__owrite            ;
  trb_addr_t      vit_3by4_dec_trb_ctrl__owaddr            ;
  logic           vit_3by4_dec_trb_ctrl__owsop             ;
  logic           vit_3by4_dec_trb_ctrl__oweop             ;
  boutputs_t      vit_3by4_dec_trb_ctrl__owhd              ;
  trel_decision_t vit_3by4_dec_trb_ctrl__owdecision        ;
  logic           vit_3by4_dec_trb_ctrl__itrb_engine_rdy   ;
  logic           vit_3by4_dec_trb_ctrl__otrb_flush        ;
  trb_addr_t      vit_3by4_dec_trb_ctrl__otrb_fraddr       ;
  trb_addr_t      vit_3by4_dec_trb_ctrl__otrb_fsize_m1     ;
  trb_addr_t      vit_3by4_dec_trb_ctrl__otrb_fterm_idx    ;
  stateb_t        vit_3by4_dec_trb_ctrl__otrb_fstate       ;
  logic           vit_3by4_dec_trb_ctrl__otrb_start        ;
  trb_addr_t      vit_3by4_dec_trb_ctrl__otrb_raddr        ;
  trb_addr_t      vit_3by4_dec_trb_ctrl__otrb_size_m1      ;
  trb_addr_t      vit_3by4_dec_trb_ctrl__otrb_term_idx     ;
  stateb_t        vit_3by4_dec_trb_ctrl__otrb_state        ;



  vit_3by4_dec_trb_ctrl
  #(
    .pLLR_W             ( pLLR_W             ) ,
    .pTRB_LENGTH        ( pTRB_LENGTH        ) ,
    .pUSE_FAST_DECISION ( pUSE_FAST_DECISION )
  )
  vit_3by4_dec_trb_ctrl
  (
    .iclk            ( vit_3by4_dec_trb_ctrl__iclk            ) ,
    .ireset          ( vit_3by4_dec_trb_ctrl__ireset          ) ,
    .iclkena         ( vit_3by4_dec_trb_ctrl__iclkena         ) ,
    .isop            ( vit_3by4_dec_trb_ctrl__isop            ) ,
    .ival            ( vit_3by4_dec_trb_ctrl__ival            ) ,
    .ieop            ( vit_3by4_dec_trb_ctrl__ieop            ) ,
    .ihd             ( vit_3by4_dec_trb_ctrl__ihd             ) ,
    .istatem         ( vit_3by4_dec_trb_ctrl__istatem         ) ,
    .idecision       ( vit_3by4_dec_trb_ctrl__idecision       ) ,
    .owrite          ( vit_3by4_dec_trb_ctrl__owrite          ) ,
    .owaddr          ( vit_3by4_dec_trb_ctrl__owaddr          ) ,
    .owsop           ( vit_3by4_dec_trb_ctrl__owsop           ) ,
    .oweop           ( vit_3by4_dec_trb_ctrl__oweop           ) ,
    .owdecision      ( vit_3by4_dec_trb_ctrl__owdecision      ) ,
    .itrb_engine_rdy ( vit_3by4_dec_trb_ctrl__itrb_engine_rdy ) ,
    .otrb_flush      ( vit_3by4_dec_trb_ctrl__otrb_flush      ) ,
    .otrb_fraddr     ( vit_3by4_dec_trb_ctrl__otrb_rfaddr     ) ,
    .otrb_fsize_m1   ( vit_3by4_dec_trb_ctrl__otrb_fsize_m1   ) ,
    .otrb_fstate     ( vit_3by4_dec_trb_ctrl__otrb_fstate     ) ,
    .otrb_start      ( vit_3by4_dec_trb_ctrl__otrb_start      ) ,
    .otrb_raddr      ( vit_3by4_dec_trb_ctrl__otrb_faddr      ) ,
    .otrb_size_m1    ( vit_3by4_dec_trb_ctrl__otrb_size_m1    ) ,
    .otrb_state      ( vit_3by4_dec_trb_ctrl__otrb_state      )
  );


  assign vit_3by4_dec_trb_ctrl__iclk            = '0 ;
  assign vit_3by4_dec_trb_ctrl__ireset          = '0 ;
  assign vit_3by4_dec_trb_ctrl__iclkena         = '0 ;
  assign vit_3by4_dec_trb_ctrl__isop            = '0 ;
  assign vit_3by4_dec_trb_ctrl__ival            = '0 ;
  assign vit_3by4_dec_trb_ctrl__ieop            = '0 ;
  assign vit_3by4_dec_trb_ctrl__iwtag           = '0 ;
  assign vit_3by4_dec_trb_ctrl__istatem         = '0 ;
  assign vit_3by4_dec_trb_ctrl__idecision       = '0 ;
  assign vit_3by4_dec_trb_ctrl__itrb_engine_rdy = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_dec_trb_ctrl.sv
// Description   : viterbi classic 2 traceback depth (2L) + up to 2L flush
//                 use previous traceback state logic to get traceback initial state immediate
//


module vit_3by4_dec_trb_ctrl
(
  iclk            ,
  ireset          ,
  iclkena         ,
  //
  isop            ,
  ival            ,
  ieop            ,
  istatem         ,
  idecision       ,
  ihd             ,
  //
  owrite          ,
  owaddr          ,
  owsop           ,
  oweop           ,
  owdecision      ,
  owhd            ,
  //
  itrb_engine_rdy ,
  //
  otrb_flush      ,
  otrb_fraddr     ,
  otrb_fsize_m1   ,
  otrb_fstate     ,
  //
  otrb_start      ,
  otrb_raddr      ,
  otrb_size_m1    ,
  otrb_state
);

  parameter bit pUSE_FAST_DECISION = 1; // use fast decision (state 0) for usual (not flush) treaceback

  `include "vit_3by4_trellis.svh"
  `include "vit_3by4_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk            ;
  input  logic          ireset          ;
  input  logic          iclkena         ;
  // acsu interface
  input  logic          isop            ;
  input  logic          ival            ;
  input  logic          ieop            ;
  input  statem_t       istatem         ;
  input  decision_t     idecision       ;
  input  boutputs_t     ihd             ;
  // traceback ram write interface
  output logic          owrite          ;
  output trb_ram_addr_t owaddr          ;
  output logic          owsop           ;
  output logic          oweop           ;
  output decision_t     owdecision      ;
  output boutputs_t     owhd            ;
  // traceback engine interface
  input  logic          itrb_engine_rdy ;  // traceback engine ready
  //
  output logic          otrb_flush      ;  // flush immediatly
  output trb_ram_addr_t otrb_fraddr     ;
  output trb_ram_addr_t otrb_fsize_m1   ;
  output stateb_t       otrb_fstate     ;
  //
  output logic          otrb_start      ;  // start regular traceback
  output trb_ram_addr_t otrb_raddr      ;
  output trb_ram_addr_t otrb_size_m1    ;
  output stateb_t       otrb_state      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  stateb_t pre_trb_state [cSTATE_NUM];

  logic    decision__oval    ;
  stateb_t decision__ostate  ;

  logic    val;
  logic    do_start;
  logic    do_stop;
  logic    trb_offset;

  //------------------------------------------------------------------------------------------------------
  // write to traceback RAM
  //  address is counter by pTRB_LENGTH module with self-synchronus nD buffer control
  //------------------------------------------------------------------------------------------------------

  // synthesis translate_off
  initial begin
    owaddr = '0; // self synchronus
  end
  // synthesis translate_on

  logic waddr_trb_edge;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owrite <= ival;
      if (ival) begin
        if (isop | waddr_trb_edge) begin
          owaddr.bidx     <= owaddr.bidx + 1'b1;
          owaddr.addr     <= '0;
          waddr_trb_edge  <= 1'b0;
        end
        else begin
          owaddr.addr     <= owaddr.addr + 1'b1;
          waddr_trb_edge  <= (owaddr.addr == (pTRB_LENGTH-2));
        end
        //
        owsop       <= isop;
        oweop       <= ieop;
        owdecision  <= idecision;
        owhd        <= ihd;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // pre traceback state
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    stateb_t tmp_pre_state;
    //
    if (iclkena) begin
      if (ival) begin
        for (int state = 0; state < cSTATE_NUM; state++) begin
          tmp_pre_state = trel.preStates[state][idecision[state]];
          //
          if (isop | waddr_trb_edge) begin
            pre_trb_state[state] <= tmp_pre_state;
          end
          else begin
            pre_trb_state[state] <= pre_trb_state[tmp_pre_state];
          end
        end // state
      end // ival
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // state metric decision. delay == pCONSTR_LENGTH-1
  //------------------------------------------------------------------------------------------------------

  vit_3by4_dec_trb_decision
  #(
    .pLLR_W ( pLLR_W )
  )
  decision
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .ival    ( ival             ) ,
    .istatem ( istatem          ) ,
    .oval    ( decision__oval   ) ,
    .ostate  ( decision__ostate )
  );

  //------------------------------------------------------------------------------------------------------
  // trace back "FSM" at module input
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val         <= 1'b0;
      do_start    <= 1'b0;
      do_stop     <= 1'b0;
      trb_offset  <= 1'b0;
    end
    else if (iclkena) begin
      val       <= ival;
      do_start  <= ival & isop;
      //
      do_stop   <= ival & ieop;
      // trb length frame "counter"
      if (do_start | do_stop) begin
        trb_offset <= 1'b0;
      end
      else if (val & waddr_trb_edge) begin
        trb_offset <= 1'b1;
      end
    end
  end

  wire trb_decision = val & waddr_trb_edge;
  wire trb_start    = trb_decision & trb_offset;  // do intermediate 1 buffer : "full"
  wire trb_s_flush  =  trb_start & do_stop;       // flush 1 buffer           : "full"
  wire trb_flush    = !trb_start & do_stop;       // flush 2 buffer           : "full" and "not full"

  //------------------------------------------------------------------------------------------------------
  // latch all state to wait state traceback decision
  //------------------------------------------------------------------------------------------------------

  trb_ram_addr_t trb_raddr;
  trb_ram_addr_t trb_f_raddr;

  trb_ram_addr_t trb_fsize_m1;
  trb_ram_addr_t trb_fraddr;

  stateb_t       used_pre_trb_state   [64];
  stateb_t       used_f_pre_trb_state [64];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (trb_decision) begin
        used_pre_trb_state <= pre_trb_state;
      end
      if (trb_flush & trb_offset) begin
        used_f_pre_trb_state <= pre_trb_state;
      end
      //
      if (trb_start) begin
        trb_raddr.bidx <= owaddr.bidx - 1'b1;
      end
      if (trb_flush & trb_offset) begin
        trb_f_raddr.bidx <= owaddr.bidx - 1'b1;
      end
      //
      // flush "full" buffer
      if (trb_s_flush | trb_flush) begin
        trb_fsize_m1    <= trb_s_flush ? pTRB_LENGTH-1 : owaddr.addr;
        trb_fraddr.addr <= trb_s_flush ? pTRB_LENGTH-1 : owaddr.addr;
        trb_fraddr.bidx <= owaddr.bidx;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // align delay with decision delay pCONSTR_LENGTH-2
  //------------------------------------------------------------------------------------------------------

  localparam int cDELAY = pCONSTR_LENGTH - 2;

  logic [cDELAY-1 : 0] trb_start_line;
  logic [cDELAY-1 : 0] trb_fstart_line;
  logic [cDELAY-1 : 0] trb_flush_line;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      trb_start_line  <= '0;
      trb_fstart_line <= '0;
      trb_flush_line  <= '0;
    end
    else if (iclkena) begin
      trb_start_line  <= (trb_start_line  << 1) |  trb_start;
      trb_fstart_line <= (trb_fstart_line << 1) | (trb_flush & trb_offset);
      trb_flush_line  <= (trb_flush_line  << 1) | (trb_s_flush | trb_flush);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // traceback engine parameters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      otrb_start <= 1'b0;
      otrb_flush <= 1'b0;
    end
    else if (iclkena) begin
      if (!otrb_start & (trb_start_line[cDELAY-1] | trb_fstart_line[cDELAY-1])) begin
        otrb_start <= 1'b1;
      end
      else if (otrb_start & itrb_engine_rdy & (trb_start_line[cDELAY-1] | trb_fstart_line[cDELAY-1])) begin
        otrb_start <= 1'b1;
      end
      else if (otrb_start & itrb_engine_rdy) begin
        otrb_start <= 1'b0;
      end
      //
      if (!otrb_flush & trb_flush_line[cDELAY-1]) begin
        otrb_flush <= 1'b1;
      end
      else if (otrb_flush & !otrb_start & itrb_engine_rdy) begin
        otrb_flush <= 1'b0;
      end
    end
  end

  assign otrb_size_m1     = pTRB_LENGTH-1;
  assign otrb_raddr.addr  = pTRB_LENGTH-1;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      //
      // traceback "full" buffer using pre_trb_state or flush "full buffer" at "full" + "not full" using the same
      if (trb_start_line[cDELAY-1] | trb_fstart_line[cDELAY-1]) begin
        otrb_raddr.bidx <= trb_start_line[cDELAY-1] ? trb_raddr.bidx                        : trb_f_raddr.bidx;
        //
        if (pUSE_FAST_DECISION) begin
          otrb_state    <= trb_start_line[cDELAY-1] ? used_pre_trb_state [0]                : used_f_pre_trb_state[decision__ostate];
        end
        else begin
          otrb_state    <= trb_start_line[cDELAY-1] ? used_pre_trb_state [decision__ostate] : used_f_pre_trb_state[decision__ostate];
        end
      end
      //
      // flush "full" buffer
      if (trb_flush_line[cDELAY-1]) begin
        otrb_fsize_m1 <= trb_fsize_m1;
        otrb_fraddr   <= trb_fraddr;
        otrb_fstate   <= decision__ostate;
      end
    end
  end

endmodule
