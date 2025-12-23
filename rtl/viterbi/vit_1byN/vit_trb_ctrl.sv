/*


  parameter int pCONSTR_LENGTH            = 3;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{6, 7};
  parameter int pLLR_W                    = 4;
  parameter int pTRB_LENGTH               = 5*pCONSTR_LENGTH;
  parameter int pTAG_W                    = 4 ;



  logic       vit_trb_ctrl__iclk            ;
  logic       vit_trb_ctrl__ireset          ;
  logic       vit_trb_ctrl__iclkena         ;
  logic       vit_trb_ctrl__isop            ;
  logic       vit_trb_ctrl__ival            ;
  logic       vit_trb_ctrl__ieop            ;
  tag_t       vit_trb_ctrl__itag            ;
  statem_t    vit_trb_ctrl__istatem         ;
  decision_t  vit_trb_ctrl__idecision       ;
  logic       vit_trb_ctrl__owrite          ;
  trb_addr_t  vit_trb_ctrl__owaddr          ;
  logic       vit_trb_ctrl__owsop           ;
  logic       vit_trb_ctrl__oweop           ;
  decision_t  vit_trb_ctrl__owdecision      ;
  logic       vit_trb_ctrl__itrb_engine_rdy ;
  tag_t       vit_trb_ctrl__otrb_tag        ;
  logic       vit_trb_ctrl__otrb_flush      ;
  trb_addr_t  vit_trb_ctrl__otrb_fraddr     ;
  trb_addr_t  vit_trb_ctrl__otrb_fsize_m1   ;
  trb_addr_t  vit_trb_ctrl__otrb_fterm_idx  ;
  stateb_t    vit_trb_ctrl__otrb_fstate     ;
  logic       vit_trb_ctrl__otrb_fdecision  ;
  logic       vit_trb_ctrl__otrb_start      ;
  trb_addr_t  vit_trb_ctrl__otrb_raddr      ;
  trb_addr_t  vit_trb_ctrl__otrb_size_m1    ;
  trb_addr_t  vit_trb_ctrl__otrb_term_idx   ;
  stateb_t    vit_trb_ctrl__otrb_state      ;
  logic       vit_trb_ctrl__otrb_decision   ;



  vit_trb_ctrl
  #(
    .pCONSTR_LENGTH ( pCONSTR_LENGTH ) ,
    .pCODE_GEN_NUM  ( pCODE_GEN_NUM  ) ,
    .pCODE_GEN      ( pCODE_GEN      ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pTRB_LENGTH    ( pTRB_LENGTH    ) ,
    .pTAG_W         ( pTAG_W         )
  )
  vit_trb_ctrl
  (
    .iclk            ( vit_trb_ctrl__iclk            ) ,
    .ireset          ( vit_trb_ctrl__ireset          ) ,
    .iclkena         ( vit_trb_ctrl__iclkena         ) ,
    .isop            ( vit_trb_ctrl__isop            ) ,
    .ival            ( vit_trb_ctrl__ival            ) ,
    .ieop            ( vit_trb_ctrl__ieop            ) ,
    .iwtag           ( vit_trb_ctrl__iwtag           ) ,
    .istatem         ( vit_trb_ctrl__istatem         ) ,
    .idecision       ( vit_trb_ctrl__idecision       ) ,
    .owrite          ( vit_trb_ctrl__owrite          ) ,
    .owaddr          ( vit_trb_ctrl__owaddr          ) ,
    .owsop           ( vit_trb_ctrl__owsop           ) ,
    .oweop           ( vit_trb_ctrl__oweop           ) ,
    .owdecision      ( vit_trb_ctrl__owdecision      ) ,
    .itrb_engine_rdy ( vit_trb_ctrl__itrb_engine_rdy ) ,
    .otrb_tag        ( vit_trb_ctrl__otrb_tag        ) ,
    .otrb_flush      ( vit_trb_ctrl__otrb_flush      ) ,
    .otrb_fraddr     ( vit_trb_ctrl__otrb_rfaddr     ) ,
    .otrb_fsize_m1   ( vit_trb_ctrl__otrb_fsize_m1   ) ,
    .otrb_fterm_idx  ( vit_trb_ctrl__otrb_fterm_idx  ) ,
    .otrb_fstate     ( vit_trb_ctrl__otrb_fstate     ) ,
    .otrb_fdecision  ( vit_trb_ctrl__otrb_fdecision  )
    .otrb_start      ( vit_trb_ctrl__otrb_start      ) ,
    .otrb_raddr      ( vit_trb_ctrl__otrb_faddr      ) ,
    .otrb_size_m1    ( vit_trb_ctrl__otrb_size_m1    ) ,
    .otrb_term_idx   ( vit_trb_ctrl__otrb_term_idx   ) ,
    .otrb_state      ( vit_trb_ctrl__otrb_state      ) ,
    .otrb_decision   ( vit_trb_ctrl__otrb_decision   )
  );


  assign vit_trb_ctrl__iclk            = '0 ;
  assign vit_trb_ctrl__ireset          = '0 ;
  assign vit_trb_ctrl__iclkena         = '0 ;
  assign vit_trb_ctrl__isop            = '0 ;
  assign vit_trb_ctrl__ival            = '0 ;
  assign vit_trb_ctrl__ieop            = '0 ;
  assign vit_trb_ctrl__iwtag           = '0 ;
  assign vit_trb_ctrl__istatem         = '0 ;
  assign vit_trb_ctrl__idecision       = '0 ;
  assign vit_trb_ctrl__itrb_engine_rdy = '0 ;



*/

//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_trb_ctrl.sv
// Description   : viterbi classic 2 traceback depth (2L) + up to 2L flush
//                 use previous traceback state logic to get traceback initial state immediate
//                 this module assume that encoder use trellis terminattion, that's why
//                 there is no any decision unit. It's not need at all
//

module vit_trb_ctrl
(
  iclk            ,
  ireset          ,
  iclkena         ,
  //
  isop            ,
  ival            ,
  ieop            ,
  itag            ,
  ihd             ,
  istatem         ,
  idecision       ,
  //
  owrite          ,
  owaddr          ,
  owsop           ,
  oweop           ,
  owhd            ,
  owdecision      ,
  //
  itrb_engine_rdy ,
  //
  otrb_tag        ,
  //
  otrb_flush      ,
  otrb_fraddr     ,
  otrb_fsize_m1   ,
  otrb_fterm_idx  ,
  otrb_fstate     ,
  otrb_fdecision  ,
  //
  otrb_start      ,
  otrb_raddr      ,
  otrb_size_m1    ,
  otrb_term_idx   ,
  otrb_state      ,
  otrb_decision
);

  `include "vit_trellis.svh"
  `include "vit_dec_types.svh"

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
  input  tag_t          itag            ;
  input  boutputs_t     ihd             ;
  input  statem_t       istatem         ;
  input  decision_t     idecision       ;
  // traceback ram write interface
  output logic          owrite          ;
  output trb_ram_addr_t owaddr          ;
  output logic          owsop           ;
  output logic          oweop           ;
  output boutputs_t     owhd            ;
  output decision_t     owdecision      ;
  // traceback engine interface
  input  logic          itrb_engine_rdy ;  // traceback engine ready
  //
  output tag_t          otrb_tag        ;
  //
  output logic          otrb_flush      ;  // flush immediatly
  output trb_ram_addr_t otrb_fraddr     ;
  output trb_ram_addr_t otrb_fsize_m1   ;
  output trb_ram_addr_t otrb_fterm_idx  ;  // termination index
  output stateb_t       otrb_fstate     ;
  output logic          otrb_fdecision  ;
  //
  output logic          otrb_start      ;  // start regular traceback
  output trb_ram_addr_t otrb_raddr      ;
  output trb_ram_addr_t otrb_size_m1    ;
  output trb_ram_addr_t otrb_term_idx   ;  // termination index
  output stateb_t       otrb_state      ;
  output logic          otrb_decision   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  stateb_t        pre_trb_state [cSTATE_NUM];
  decision_t      pre_trb_decision;

  logic           val;
  logic           do_start;
  logic           do_stop;
  logic           trb_offset;

  trb_ram_addr_t  term_idx;

  tag_t           tag;

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
        owhd        <= ihd;
        owdecision  <= idecision;
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
          tmp_pre_state = get_pre_state(state, idecision[state]);
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
  // traceback engine parameters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      otrb_start        <= 1'b0;
      otrb_flush        <= 1'b0;
    end
    else if (iclkena) begin
      if (!otrb_start & (trb_start | (trb_flush & trb_offset))) begin
        otrb_start <= 1'b1;
      end
      else if (otrb_start & itrb_engine_rdy & (trb_start | (trb_flush & trb_offset))) begin
        otrb_start <= 1'b1;
      end
      else if (otrb_start & itrb_engine_rdy) begin
        otrb_start <= 1'b0;
      end
      //
      if (!otrb_flush & (trb_s_flush | trb_flush)) begin
        otrb_flush <= 1'b1;
      end
      else if (otrb_flush & !otrb_start & itrb_engine_rdy) begin
        otrb_flush <= 1'b0;
      end
    end
  end

  assign term_idx = owaddr.addr - (pCONSTR_LENGTH-1);

  assign otrb_size_m1     = pTRB_LENGTH-1;
  assign otrb_raddr.addr  = pTRB_LENGTH-1;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (trb_decision) begin
        pre_trb_decision <= owdecision;
      end
      //
      if (ival & isop) begin
        tag <= itag;
      end
      //
      // traceback "full" buffer using pre_trb_state or flush "full buffer" at "full" + "not full" using the same
      if (trb_start | (trb_flush & trb_offset)) begin
        otrb_state      <= pre_trb_state[0];  // trellis merges or termination
        otrb_decision   <= pre_trb_decision[pre_trb_state[0]];
        //
        otrb_raddr.bidx <= owaddr.bidx - 1'b1;
        if (trb_flush & trb_offset) begin
          otrb_term_idx <= pTRB_LENGTH + term_idx;
        end
        else begin
          otrb_term_idx <= pTRB_LENGTH;
        end
      end
      //
      // flush "full" buffer
      if (trb_s_flush) begin
        otrb_fsize_m1     <= pTRB_LENGTH-1;
        otrb_fraddr.addr  <= pTRB_LENGTH-1;
        otrb_fraddr.bidx  <= owaddr.bidx;
        otrb_fterm_idx    <= pTRB_LENGTH-1-(pCONSTR_LENGTH-1);
        otrb_fdecision    <= owdecision[0];
      end
      else if (trb_flush) begin // flush "not full" buffer after "full"
        otrb_fsize_m1     <= owaddr.addr;
        otrb_fraddr       <= owaddr;
        otrb_fterm_idx    <= term_idx;  // less then zero
        otrb_fdecision    <= owdecision[0];
      end
      //
      if (trb_start | (trb_s_flush |trb_flush)) begin
        otrb_tag <= tag;
      end
    end
  end

  assign otrb_fstate = 0;  // trellis termination

endmodule
