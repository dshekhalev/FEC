/*






  logic           vit_trb_engine__iclk       ;
  logic           vit_trb_engine__ireset     ;
  logic           vit_trb_engine__iclkena    ;
  logic           vit_trb_engine__istart     ;
  trb_ram_addr_t  vit_trb_engine__iraddr     ;
  trb_ram_addr_t  vit_trb_engine__isize_m1   ;
  trb_ram_addr_t  vit_trb_engine__iterm_idx  ;
  stateb_t        vit_trb_engine__istate     ;
  logic           vit_trb_engine__idecision  ;
  logic           vit_trb_engine__iflush     ;
  trb_ram_addr_t  vit_trb_engine__ifraddr    ;
  trb_ram_addr_t  vit_trb_engine__ifsize_m1  ;
  trb_ram_addr_t  vit_trb_engine__ifterm_idx ;
  stateb_t        vit_trb_engine__ifstate    ;
  logic           vit_trb_engine__ifdecision ;
  tag_t           vit_trb_engine__itag       ;
  logic           vit_trb_engine__ordy       ;
  logic           vit_trb_engine__irsop      ;
  logic           vit_trb_engine__ireop      ;
  boutputs_t      vit_trb_engine__irhd       ;
  decision_t      vit_trb_engine__irdecision ;
  trb_ram_addr_t  vit_trb_engine__oraddr     ;
  logic           vit_trb_engine__owrite     ;
  logic           vit_trb_engine__oflush     ;
  trb_lifo_addr_t vit_trb_engine__owaddr     ;
  logic           vit_trb_engine__owsop      ;
  logic           vit_trb_engine__oweop      ;
  tag_t           vit_trb_engine__owtag      ;
  logic           vit_trb_engine__owdat      ;
  boutputs_t      vit_trb_engine__owbiterr   ;

  vit_trb_engine
  vit_trb_engine
  (
    .iclk           ( vit_trb_engine__iclk           ) ,
    .ireset         ( vit_trb_engine__ireset         ) ,
    .iclkena        ( vit_trb_engine__iclkena        ) ,
    .istart         ( vit_trb_engine__istart         ) ,
    .iraddr         ( vit_trb_engine__iraddr         ) ,
    .isize_m1       ( vit_trb_engine__isize_m1       ) ,
    .iterm_idx      ( vit_trb_engine__iterm_idx      ) ,
    .istate         ( vit_trb_engine__istate         ) ,
    .idecision      ( vit_trb_engine__idecision      ) ,
    .iflush         ( vit_trb_engine__iflush         ) ,
    .ifraddr        ( vit_trb_engine__ifraddr        ) ,
    .ifsize_m1      ( vit_trb_engine__ifsize_m1      ) ,
    .ifterm_idx     ( vit_trb_engine__ifterm_idx     ) ,
    .ifstate        ( vit_trb_engine__ifstate        ) ,
    .ifdecision     ( vit_trb_engine__ifdecision     ) ,
    .itag           ( vit_trb_engine__itag           ) ,
    .ordy           ( vit_trb_engine__ordy           ) ,
    .irsop          ( vit_trb_engine__irsop          ) ,
    .ireop          ( vit_trb_engine__ireop          ) ,
    .irhd           ( vit_trb_engine__irhd           ) ,
    .irdecision     ( vit_trb_engine__irdecision     ) ,
    .oraddr         ( vit_trb_engine__oraddr         ) ,
    .owrite         ( vit_trb_engine__owrite         ) ,
    .oflush         ( vit_trb_engine__oflush         ) ,
    .owaddr         ( vit_trb_engine__owaddr         ) ,
    .owsop          ( vit_trb_engine__owsop          ) ,
    .oweop          ( vit_trb_engine__oweop          ) ,
    .owtag          ( vit_trb_engine__owtag          ) ,
    .owdat          ( vit_trb_engine__owdat          ) ,
    .owbiterr       ( vit_trb_engine__owbiterr       )
  );


  assign vit_trb_engine__iclk        = '0 ;
  assign vit_trb_engine__ireset      = '0 ;
  assign vit_trb_engine__iclkena     = '0 ;
  assign vit_trb_engine__istart      = '0 ;
  assign vit_trb_engine__iraddr      = '0 ;
  assign vit_trb_engine__isize_m1    = '0 ;
  assign vit_trb_engine__iterm_idx   = '0 ;
  assign vit_trb_engine__istate      = '0 ;
  assign vit_trb_engine__idecision   = '0 ;
  assign vit_trb_engine__iflush      = '0 ;
  assign vit_trb_engine__ifraddr     = '0 ;
  assign vit_trb_engine__ifterm_idx  = '0 ;
  assign vit_trb_engine__ifsize_m1   = '0 ;
  assign vit_trb_engine__ifstate     = '0 ;
  assign vit_trb_engine__ifdecision  = '0 ;
  assign vit_trb_engine__itag        = '0 ;
  assign vit_trb_engine__irsop       = '0 ;
  assign vit_trb_engine__ireop       = '0 ;
  assign vit_trb_engine__irhd        = '0 ;
  assign vit_trb_engine__irdecision  = '0 ;



*/

//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_trb_engine.sv
// Description   : viterbi traceback engine. Engine can work in 2 modes: full traceback(L) or flush buffer ( <= L).
//                 up to 2 commnad in command queue support
//


module vit_trb_engine
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  istart      ,
  iraddr      ,
  isize_m1    ,
  iterm_idx   ,
  istate      ,
  idecision   ,
  //
  iflush      ,
  ifraddr     ,
  ifsize_m1   ,
  ifterm_idx  ,
  ifstate     ,
  ifdecision  ,
  //
  itag        ,
  ordy        ,
  //
  irsop       ,
  ireop       ,
  irhd        ,
  irdecision  ,
  oraddr      ,
  //
  owrite      ,
  oflush      ,
  owaddr      ,
  owsop       ,
  oweop       ,
  owtag       ,
  owdat       ,
  owbiterr
);

  `include "vit_trellis.svh"
  `include "vit_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk        ;
  input  logic            ireset      ;
  input  logic            iclkena     ;
  // traceback buffer interface
  input  logic            istart      ;
  input  trb_ram_addr_t   iraddr      ;
  input  trb_ram_addr_t   isize_m1    ;
  input  trb_ram_addr_t   iterm_idx   ;
  input  stateb_t         istate      ;
  input  logic            idecision   ;
  // flush buffer interface
  input  logic            iflush      ;
  input  trb_ram_addr_t   ifraddr     ;
  input  trb_ram_addr_t   ifsize_m1   ;
  input  trb_ram_addr_t   ifterm_idx  ;
  input  stateb_t         ifstate     ;
  input  logic            ifdecision  ;
  //
  input  tag_t            itag        ;
  output logic            ordy        ;
  // traceback ram interface
  input  logic            irsop       ;
  input  logic            ireop       ;
  input  boutputs_t       irhd        ;
  input  decision_t       irdecision  ;
  output trb_ram_addr_t   oraddr      ;
  // output interface
  output logic            owrite      ;
  output logic            oflush      ;
  output trb_lifo_addr_t  owaddr      ;
  output logic            owsop       ;
  output logic            oweop       ;
  output tag_t            owtag       ;
  output logic            owdat       ;
  output boutputs_t       owbiterr    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic           do_work;
  logic           start_work;
  logic           end_work;

  trb_ram_addr_t  cnt;

  trb_ram_addr_t  term_idx;

  logic   [2 : 0] rdata_val;
  logic   [2 : 0] rdata_sop;
  logic   [2 : 0] rdata_eop;

  logic   [1 : 0] rdata_mask;
  logic   [1 : 0] rdata_eop_mask;

  stateb_t        start_state;
  stateb_t        pre_state;
  stateb_t        state;

  logic           data_bit;
  boutputs_t      cdata;

  tag_t           tag;

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

  logic decision;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (do_start) begin
        oraddr      <= istart ? iraddr    : ifraddr;
        start_state <= istart ? istate    : ifstate;
        decision    <= istart ? idecision : ifdecision;
        term_idx    <= istart ? iterm_idx : ifterm_idx;
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
  stateb_t start_pre_state_used;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      start_state_used      <= start_state;
      start_pre_state_used  <= get_pre_state(start_state, decision);
      //
      rdata_val <= (rdata_val << 1) | do_work;
      rdata_sop <= (rdata_sop << 1) | start_work;
      rdata_eop <= (rdata_eop << 1) | end_work;
      //
      rdata_mask      <= (rdata_mask << 1)     | (({1'b0, oraddr.addr} >  {term_idx.bidx[0], term_idx.addr}) | term_idx.bidx[1]);
      rdata_eop_mask  <= (rdata_eop_mask << 1) | (({1'b0, oraddr.addr} == {term_idx.bidx[0], term_idx.addr}));
      //
      if (do_start) begin
        tag <= itag;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // reconstruct data (traceback itself)
  //------------------------------------------------------------------------------------------------------

  // trace back
//assign pre_state  = rdata_sop[1] ? get_pre_state(start_state_used, irdecision[start_state_used]) : get_pre_state(state, irdecision[state]);
  assign pre_state  = rdata_sop[1] ? start_pre_state_used : get_pre_state(state, irdecision[state]);
  // data itself
  assign data_bit   = rdata_sop[1] ? get_binput(start_state_used) : get_binput(state);
  // reconstructed coded data
  assign cdata      = trel.outputs[pre_state][data_bit];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (rdata_val[1]) begin
        state <= pre_state;
      end
      //
      if (rdata_val[1]) begin
        owsop     <= irsop;
        oweop     <= /*ireop |*/ rdata_eop_mask[1];
        owdat     <= data_bit;
        owbiterr  <= irhd ^ cdata;
        owaddr    <= rdata_sop[1] ? {cTRB_LIFO_ADDR_W{rdata_mask[1]}} : (owaddr + !rdata_mask[1]);
        if (rdata_sop[1]) begin
          owtag <= tag;
        end
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
      oflush <= 1'b0;
    end
    else if (iclkena) begin
      owrite <= rdata_val[1] & !rdata_mask[1];
      oflush <= rdata_eop[1];
    end
  end

endmodule
