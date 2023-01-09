/*


  parameter int pTRB_LENGTH = 64 ;



  logic               vit_3by4_dec_trb_engine__iclk       ;
  logic               vit_3by4_dec_trb_engine__ireset     ;
  logic               vit_3by4_dec_trb_engine__iclkena    ;
  logic               vit_3by4_dec_trb_engine__istart     ;
  trb_ram_addr_t      vit_3by4_dec_trb_engine__iraddr     ;
  trb_ram_addr_t      vit_3by4_dec_trb_engine__isize_m1   ;
  stateb_t            vit_3by4_dec_trb_engine__istate     ;
  logic               vit_3by4_dec_trb_engine__iflush     ;
  trb_ram_addr_t      vit_3by4_dec_trb_engine__ifraddr    ;
  trb_ram_addr_t      vit_3by4_dec_trb_engine__ifsize_m1  ;
  stateb_t            vit_3by4_dec_trb_engine__ifstate    ;
  logic               vit_3by4_dec_trb_engine__ordy       ;
  logic               vit_3by4_dec_trb_engine__irsop      ;
  logic               vit_3by4_dec_trb_engine__ireop      ;
  decision_t          vit_3by4_dec_trb_engine__irdecision ;
  boutputs_t          vit_3by4_dec_trb_engine__irhd       ;
  trb_ram_addr_t      vit_3by4_dec_trb_engine__oraddr     ;
  logic               vit_3by4_dec_trb_engine__owrite     ;
  logic               vit_3by4_dec_trb_engine__oflush     ;
  trb_lifo_addr_t     vit_3by4_dec_trb_engine__owaddr     ;
  logic               vit_3by4_dec_trb_engine__owsop      ;
  logic               vit_3by4_dec_trb_engine__oweop      ;
  trel_decision_t     vit_3by4_dec_trb_engine__owdat      ;
  boutputs_t          vit_3by4_dec_trb_engine__owbiterr   ;

  vit_3by4_dec_trb_engine
  #(
    .pTRB_LENGTH ( pTRB_LENGTH )
  )
  vit_3by4_dec_trb_engine
  (
    .iclk           ( vit_3by4_dec_trb_engine__iclk           ) ,
    .ireset         ( vit_3by4_dec_trb_engine__ireset         ) ,
    .iclkena        ( vit_3by4_dec_trb_engine__iclkena        ) ,
    .istart         ( vit_3by4_dec_trb_engine__istart         ) ,
    .iraddr         ( vit_3by4_dec_trb_engine__iraddr         ) ,
    .isize_m1       ( vit_3by4_dec_trb_engine__isize_m1       ) ,
    .istate         ( vit_3by4_dec_trb_engine__istate         ) ,
    .iflush         ( vit_3by4_dec_trb_engine__iflush         ) ,
    .ifraddr        ( vit_3by4_dec_trb_engine__ifraddr        ) ,
    .ifsize_m1      ( vit_3by4_dec_trb_engine__ifsize_m1      ) ,
    .ifstate        ( vit_3by4_dec_trb_engine__ifstate        ) ,
    .ordy           ( vit_3by4_dec_trb_engine__ordy           ) ,
    .irsop          ( vit_3by4_dec_trb_engine__irsop          ) ,
    .ireop          ( vit_3by4_dec_trb_engine__ireop          ) ,
    .irdecision     ( vit_3by4_dec_trb_engine__irdecision     ) ,
    .irhd           ( vit_3by4_dec_trb_engine__irhd           ) ,
    .oraddr         ( vit_3by4_dec_trb_engine__oraddr         ) ,
    .owrite         ( vit_3by4_dec_trb_engine__owrite         ) ,
    .oflush         ( vit_3by4_dec_trb_engine__oflush         ) ,
    .owaddr         ( vit_3by4_dec_trb_engine__owaddr         ) ,
    .owsop          ( vit_3by4_dec_trb_engine__owsop          ) ,
    .oweop          ( vit_3by4_dec_trb_engine__oweop          ) ,
    .owdat          ( vit_3by4_dec_trb_engine__owdat          ) ,
    .owbiterr       ( vit_3by4_dec_trb_engine__owbiterr       )
  );


  assign vit_3by4_dec_trb_engine__iclk          = '0 ;
  assign vit_3by4_dec_trb_engine__ireset        = '0 ;
  assign vit_3by4_dec_trb_engine__iclkena       = '0 ;
  assign vit_3by4_dec_trb_engine__istart        = '0 ;
  assign vit_3by4_dec_trb_engine__iraddr        = '0 ;
  assign vit_3by4_dec_trb_engine__isize_m1      = '0 ;
  assign vit_3by4_dec_trb_engine__istate        = '0 ;
  assign vit_3by4_dec_trb_engine__iflush        = '0 ;
  assign vit_3by4_dec_trb_engine__ifraddr       = '0 ;
  assign vit_3by4_dec_trb_engine__ifsize_m1     = '0 ;
  assign vit_3by4_dec_trb_engine__ifstate       = '0 ;
  assign vit_3by4_dec_trb_engine__irsop         = '0 ;
  assign vit_3by4_dec_trb_engine__ireop         = '0 ;
  assign vit_3by4_dec_trb_engine__irdecision    = '0 ;
  assign vit_3by4_dec_trb_engine__irhd          = '0 ;



*/

//
// Project       : viterbi 3by4
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_3by4_dec_trb_engine.sv
// Description   : viterbi traceback engine. Engine can work in 2 modes: full traceback(L) or flush buffer ( <= L).
//                 up to 2 commnad in command queue support
//


module vit_3by4_dec_trb_engine
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
  irhd          ,
  oraddr        ,
  //
  owrite        ,
  oflush        ,
  owaddr        ,
  owsop         ,
  oweop         ,
  owdat         ,
  owbiterr
);

  `include "vit_3by4_trellis.svh"
  `include "vit_3by4_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk                      ;
  input  logic            ireset                    ;
  input  logic            iclkena                   ;
  // traceback buffer interface
  input  logic            istart                    ;
  input  trb_ram_addr_t   iraddr                    ;
  input  trb_ram_addr_t   isize_m1                  ;
  input  stateb_t         istate                    ;
  // flush buffer interface
  input  logic            iflush                    ;
  input  trb_ram_addr_t   ifraddr                   ;
  input  trb_ram_addr_t   ifsize_m1                 ;
  input  stateb_t         ifstate                   ;
  //
  output logic            ordy                      ;
  // traceback ram interface
  input  logic            irsop                     ;
  input  logic            ireop                     ;
  input  decision_t       irdecision                ;
  input  boutputs_t       irhd                      ;
  output trb_ram_addr_t   oraddr                    ;
  // output interface
  output logic            owrite                    ;
  output logic            oflush                    ;
  output trb_lifo_addr_t  owaddr                    ;
  output logic            owsop                     ;
  output logic            oweop                     ;
  output trel_decision_t  owdat                     ;
  output boutputs_t       owbiterr                  ;

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

  trel_decision_t data_bits;
  boutputs_t      cdata;

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
        cnt      <=   istart ? isize_m1 : ifsize_m1;
        end_work <= ((istart ? isize_m1 : ifsize_m1) == 0);
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
  // decoded data
  assign data_bits  = rdata_sop[1] ? irdecision[start_state_used] : irdecision[state];

  // branch metric index
  assign cdata     = rdata_sop[1] ? {data_bits, pre_state[0]}     : {data_bits, pre_state[0]};

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (rdata_val[1]) begin
        state <= pre_state;
      end
      //
      if (rdata_val[1]) begin
        owsop     <= irsop;
        oweop     <= ireop;
        owdat     <= data_bits;
        owbiterr  <= irhd ^ cdata;
        owaddr    <= rdata_sop[1] ? '0 : (owaddr + 1'b1);
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
