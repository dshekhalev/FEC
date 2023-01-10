/*


  parameter int pTRB_LENGTH = 64 ;



  logic               tcm_dec_trb_engine__iclk                       ;
  logic               tcm_dec_trb_engine__ireset                     ;
  logic               tcm_dec_trb_engine__iclkena                    ;
  logic               tcm_dec_trb_engine__istart                     ;
  trb_ram_addr_t      tcm_dec_trb_engine__iraddr                     ;
  trb_ram_addr_t      tcm_dec_trb_engine__isize_m1                   ;
  stateb_t            tcm_dec_trb_engine__istate                     ;
  logic               tcm_dec_trb_engine__iflush                     ;
  trb_ram_addr_t      tcm_dec_trb_engine__ifraddr                    ;
  trb_ram_addr_t      tcm_dec_trb_engine__ifsize_m1                  ;
  stateb_t            tcm_dec_trb_engine__ifstate                    ;
  logic               tcm_dec_trb_engine__ordy                       ;
  logic               tcm_dec_trb_engine__irsop                      ;
  logic               tcm_dec_trb_engine__ireop                      ;
  decision_t          tcm_dec_trb_engine__irdecision                 ;
  symb_m_idx_t        tcm_dec_trb_engine__irsymb_m_idx  [16]         ;
  symb_m_sign_t       tcm_dec_trb_engine__irsymb_m_sign [4]          ;
  symb_hd_t           tcm_dec_trb_engine__irsymb_hd                  ;
  trb_ram_addr_t      tcm_dec_trb_engine__oraddr                     ;
  logic               tcm_dec_trb_engine__owrite                     ;
  logic               tcm_dec_trb_engine__oflush                     ;
  trb_lifo_addr_t     tcm_dec_trb_engine__owaddr                     ;
  logic               tcm_dec_trb_engine__owsop                      ;
  logic               tcm_dec_trb_engine__oweop                      ;
  trel_bm_idx_t       tcm_dec_trb_engine__owbm_idx                   ;
  symb_m_idx_t        tcm_dec_trb_engine__owsymb_m_idx               ;
  symb_m_sign_t       tcm_dec_trb_engine__owsymb_m_sign [4]          ;
  symb_hd_t           tcm_dec_trb_engine__owsymb_hd                  ;

  tcm_dec_trb_engine
  #(
    .pTRB_LENGTH ( pTRB_LENGTH )
  )
  tcm_dec_trb_engine
  (
    .iclk           ( tcm_dec_trb_engine__iclk           ) ,
    .ireset         ( tcm_dec_trb_engine__ireset         ) ,
    .iclkena        ( tcm_dec_trb_engine__iclkena        ) ,
    .istart         ( tcm_dec_trb_engine__istart         ) ,
    .iraddr         ( tcm_dec_trb_engine__iraddr         ) ,
    .isize_m1       ( tcm_dec_trb_engine__isize_m1       ) ,
    .istate         ( tcm_dec_trb_engine__istate         ) ,
    .iflush         ( tcm_dec_trb_engine__iflush         ) ,
    .ifraddr        ( tcm_dec_trb_engine__ifraddr        ) ,
    .ifsize_m1      ( tcm_dec_trb_engine__ifsize_m1      ) ,
    .ifstate        ( tcm_dec_trb_engine__ifstate        ) ,
    .ordy           ( tcm_dec_trb_engine__ordy           ) ,
    .irsop          ( tcm_dec_trb_engine__irsop          ) ,
    .ireop          ( tcm_dec_trb_engine__ireop          ) ,
    .irdecision     ( tcm_dec_trb_engine__irdecision     ) ,
    .irsymb_m_idx   ( tcm_dec_trb_engine__irsymb_m_idx   ) ,
    .irsymb_m_sign  ( tcm_dec_trb_engine__irsymb_m_sign  ) ,
    .irsymb_hd      ( tcm_dec_trb_engine__irsymb_hd      ) ,
    .oraddr         ( tcm_dec_trb_engine__oraddr         ) ,
    .owrite         ( tcm_dec_trb_engine__owrite         ) ,
    .oflush         ( tcm_dec_trb_engine__oflush         ) ,
    .owaddr         ( tcm_dec_trb_engine__owaddr         ) ,
    .owsop          ( tcm_dec_trb_engine__owsop          ) ,
    .oweop          ( tcm_dec_trb_engine__oweop          ) ,
    .owbm_idx       ( tcm_dec_trb_engine__owbm_idx       ) ,
    .owsymb_m_idx   ( tcm_dec_trb_engine__owsymb_m_idx   ) ,
    .owsymb_m_sign  ( tcm_dec_trb_engine__owsymb_m_sign  ) ,
    .owsymb_hd      ( tcm_dec_trb_engine__owsymb_hd      )
  );


  assign tcm_dec_trb_engine__iclk          = '0 ;
  assign tcm_dec_trb_engine__ireset        = '0 ;
  assign tcm_dec_trb_engine__iclkena       = '0 ;
  assign tcm_dec_trb_engine__istart        = '0 ;
  assign tcm_dec_trb_engine__iraddr        = '0 ;
  assign tcm_dec_trb_engine__isize_m1      = '0 ;
  assign tcm_dec_trb_engine__istate        = '0 ;
  assign tcm_dec_trb_engine__idecision     = '0 ;
  assign tcm_dec_trb_engine__iflush        = '0 ;
  assign tcm_dec_trb_engine__ifraddr       = '0 ;
  assign tcm_dec_trb_engine__ifsize_m1     = '0 ;
  assign tcm_dec_trb_engine__ifstate       = '0 ;
  assign tcm_dec_trb_engine__ifdecision    = '0 ;
  assign tcm_dec_trb_engine__irsop         = '0 ;
  assign tcm_dec_trb_engine__ireop         = '0 ;
  assign tcm_dec_trb_engine__irdecision    = '0 ;
  assign tcm_dec_trb_engine__irsymb_m_idx  = '0 ;
  assign tcm_dec_trb_engine__irsymb_m_sign = '0 ;
  assign tcm_dec_trb_engine__irsymb_hd     = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_trb_engine.sv
// Description   : viterbi traceback engine. Engine can work in 2 modes: full traceback(L) or flush buffer ( <= L).
//                 up to 2 commnad in command queue support
//

`include "define.vh"

module tcm_dec_trb_engine
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  istart        ,
  iraddr        ,
  isize_m1      ,
  istate        ,
  //
  iflush        ,
  ifraddr       ,
  ifsize_m1     ,
  ifstate       ,
  //
  ordy          ,
  //
  irsop         ,
  ireop         ,
  irdecision    ,
  irsymb_m_idx  ,
  irsymb_m_sign ,
  irsymb_hd     ,
  oraddr        ,
  //
  owrite        ,
  oflush        ,
  owaddr        ,
  owsop         ,
  oweop         ,
  owbm_idx      ,
  owsymb_m_idx  ,
  owsymb_m_sign ,
  owsymb_hd
);

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk               ;
  input  logic            ireset             ;
  input  logic            iclkena            ;
  // traceback buffer interface
  input  logic            istart             ;
  input  trb_ram_addr_t   iraddr             ;
  input  trb_ram_addr_t   isize_m1           ;
  input  stateb_t         istate             ;
  // flush buffer interface
  input  logic            iflush             ;
  input  trb_ram_addr_t   ifraddr            ;
  input  trb_ram_addr_t   ifsize_m1          ;
  input  stateb_t         ifstate            ;
  //
  output logic            ordy               ;
  // traceback ram interface
  input  logic            irsop              ;
  input  logic            ireop              ;
  input  decision_t       irdecision         ;
  input  symb_m_idx_t     irsymb_m_idx  [16] ;
  input  symb_m_sign_t    irsymb_m_sign [4]  ;
  input  symb_hd_t        irsymb_hd          ;
  output trb_ram_addr_t   oraddr             ;
  // output interface
  output logic            owrite             ;
  output logic            oflush             ;
  output trb_lifo_addr_t  owaddr             ;
  output logic            owsop              ;
  output logic            oweop              ;
  output trel_bm_idx_t    owbm_idx           ;
  output symb_m_idx_t     owsymb_m_idx       ;
  output symb_m_sign_t    owsymb_m_sign  [4] ;
  output symb_hd_t        owsymb_hd          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic           do_work;
  logic           start_work;
  logic           end_work;

  trb_ram_addr_t  cnt;

  logic   [2 : 0] rdata_val;
  logic   [2 : 0] rdata_sop;
  logic   [2 : 0] rdata_eop;

  stateb_t        start_state;
  stateb_t        pre_state;
  stateb_t        state;

  trel_bm_idx_t   bm_idx;

  //------------------------------------------------------------------------------------------------------
  // traceback engine "FSM"
  //------------------------------------------------------------------------------------------------------

  wire do_start = ordy & (istart | iflush);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      do_work <= 1'b0;
    end
    else if (iclkena) begin
      if (do_start) begin
        do_work <= 1'b1;
      end
      else if (end_work & !do_start) begin
        do_work <= 1'b0;
      end
    end
  end

  assign ordy = !(do_work & !end_work);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      start_work  <= 1'b0;
      end_work    <= 1'b0;
      cnt         <= '0;
    end
    else if (iclkena) begin
      start_work <= do_start;
      if (do_start) begin
        cnt      <=  istart ? isize_m1 : ifsize_m1;
        end_work <= (istart ? isize_m1 : ifsize_m1) == 0;
      end
      else if (do_work) begin
        cnt       <= cnt - 1'b1;
        end_work  <= (cnt == 1);
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (do_start) begin
        oraddr      <= istart ? iraddr    : ifraddr;
        start_state <= istart ? istate    : ifstate;
      end
      else if (do_work) begin
        oraddr.addr <= oraddr.addr - 1'b1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // read ram latency is 2 tick + 1 tick reclock for mathematic
  //------------------------------------------------------------------------------------------------------

  stateb_t start_state_used;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      start_state_used <= start_state;
      //
      rdata_val <= (rdata_val << 1) | do_work;
      rdata_sop <= (rdata_sop << 1) | start_work;
      rdata_eop <= (rdata_eop << 1) | end_work;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // reconstruct data (traceback itself)
  //------------------------------------------------------------------------------------------------------

  // trace back
  assign pre_state  = rdata_sop[1] ? trel.preStates[start_state_used][irdecision[start_state_used]] : trel.preStates[state][irdecision[state]];
  // branch metric index
  assign bm_idx     = rdata_sop[1] ? {irdecision[start_state_used], pre_state[0]}                   : {irdecision[state], pre_state[0]};

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (rdata_val[1]) begin
        state <= pre_state;
      end
      //
      if (rdata_val[1]) begin
        owsop         <= irsop;
        oweop         <= ireop;
        owbm_idx      <= bm_idx;
        owsymb_m_idx  <= irsymb_m_idx[bm_idx];
        owsymb_m_sign <= irsymb_m_sign;
        owsymb_hd     <= irsymb_hd;
        owaddr        <= rdata_sop[1] ? '0 : (owaddr + 1'b1);
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
      oflush <= 1'b0;
    end
    else if (iclkena) begin
      owrite <= rdata_val[1];
      oflush <= rdata_eop[1];
    end
  end

endmodule
