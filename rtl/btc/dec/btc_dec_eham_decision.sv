/*



  parameter int pLLR_W  = 5 ;
  parameter int pEXTR_W = 5 ;



  logic                   btc_dec_eham_decision__iclk              ;
  logic                   btc_dec_eham_decision__ireset            ;
  logic                   btc_dec_eham_decision__iclkena           ;
  //
  btc_code_mode_t         btc_dec_eham_decision__imode             ;
  logic                   btc_dec_eham_decision__ival              ;
  strb_t                  btc_dec_eham_decision__istrb             ;
  metric_t                btc_dec_eham_decision__imin0             ;
  metric_t                btc_dec_eham_decision__imin1             ;
  logic           [4 : 0] btc_dec_eham_decision__ierr_bit_mask     ;
  bit_idx_t               btc_dec_eham_decision__ierr_bit_idx  [5] ;
  logic                   btc_dec_eham_decision__idecfail          ;
  //
  logic                   btc_dec_eham_decision__ihd               ;
  logic                   btc_dec_eham_decision__ohd_read          ;
  //
  logic                   btc_dec_eham_decision__oval              ;
  strb_t                  btc_dec_eham_decision__ostrb             ;
  extr_t                  btc_dec_eham_decision__oLextr            ;
  logic                   btc_dec_eham_decision__obitdat           ;
  //
  logic                   btc_dec_eham_decision__odecfail          ;



  btc_dec_eham_decision
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  btc_dec_eham_decision
  (
    .iclk          ( btc_dec_eham_decision__iclk          ) ,
    .ireset        ( btc_dec_eham_decision__ireset        ) ,
    .iclkena       ( btc_dec_eham_decision__iclkena       ) ,
    //
    .imode         ( btc_dec_eham_decision__imode         ) ,
    .ival          ( btc_dec_eham_decision__ival          ) ,
    .istrb         ( btc_dec_eham_decision__istrb         ) ,
    .imin0         ( btc_dec_eham_decision__imin0         ) ,
    .imin1         ( btc_dec_eham_decision__imin1         ) ,
    .ierr_bit_mask ( btc_dec_eham_decision__ierr_bit_mask ) ,
    .ierr_bit_idx  ( btc_dec_eham_decision__ierr_bit_idx  ) ,
    .idecfail      ( btc_dec_eham_decision__idecfail      )
    //
    .ihd           ( btc_dec_eham_decision__ihd           ) ,
    .ohd_read      ( btc_dec_eham_decision__ohd_read      ) ,
    //
    .oval          ( btc_dec_eham_decision__oval          ) ,
    .ostrb         ( btc_dec_eham_decision__ostrb         ) ,
    .oLextr        ( btc_dec_eham_decision__oLextr        ) ,
    .obitdat       ( btc_dec_eham_decision__obitdat       ) ,
    //
    .odecfail      ( btc_dec_eham_decision__odecfail      )
  );


  assign btc_dec_eham_decision__iclk          = '0 ;
  assign btc_dec_eham_decision__ireset        = '0 ;
  assign btc_dec_eham_decision__iclkena       = '0 ;
  assign btc_dec_eham_decision__imode         = '0 ;
  assign btc_dec_eham_decision__ival          = '0 ;
  assign btc_dec_eham_decision__istrb         = '0 ;
  assign btc_dec_eham_decision__imin0         = '0 ;
  assign btc_dec_eham_decision__imin1         = '0 ;
  assign btc_dec_eham_decision__ierr_bit_mask = '0 ;
  assign btc_dec_eham_decision__ierr_bit_idx  = '0 ;
  assign btc_dec_eham_decision__idecfail      = '0 ;
  assign btc_dec_eham_decision__ihd           = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_eham_decision.sv
// Description   : extended hamming code fast chase decision
//

module btc_dec_eham_decision
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  imode         ,
  //
  ival          ,
  istrb         ,
  imin0         ,
  imin1         ,
  ierr_bit_mask ,
  ierr_bit_idx  ,
  idecfail      ,
  //
  ihd           ,
  ohd_read      ,
  //
  oval          ,
  ostrb         ,
  oLextr        ,
  obitdat       ,
  //
  odecfail
);

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk              ;
  input  logic                   ireset            ;
  input  logic                   iclkena           ;
  //
  input  btc_code_mode_t         imode             ;
  //
  input  logic                   ival              ;
  input  strb_t                  istrb             ;
  input  metric_t                imin0             ;
  input  metric_t                imin1             ;
  input  logic           [4 : 0] ierr_bit_mask     ;
  input  bit_idx_t               ierr_bit_idx  [5] ;
  input  logic                   idecfail          ;
  //
  input  logic                   ihd               ;
  output logic                   ohd_read          ;
  //
  output logic                   oval              ;
  output strb_t                  ostrb             ;
  output extr_t                  oLextr            ;
  output logic                   obitdat           ;
  //
  output logic                   odecfail          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic     zero;
    logic     done;
    bit_idx_t value;
  } cnt;

  bit_idx_t     length_m2 ;

  strb_t        strb      ;

  metric_t      Lextr;

  logic [4 : 0] err_bit_mask    ;
  bit_idx_t     err_bit_idx  [5];

  logic         bitdat     ;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state  <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE  : state <= ival               ? cDO_STATE     : cRESET_STATE;
        cDO_STATE     : state <= (cnt.done & !ival) ? cRESET_STATE  : cDO_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  // fixed for decode cycle
  assign length_m2 = get_code_bits(imode) - 2;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cRESET_STATE : begin
          if (ival) begin // hold new results
            cnt           <= '0;
            cnt.zero      <= 1'b1;
            //
            strb          <= istrb;
            //
            Lextr         <= imin1 - imin0;
            //
            err_bit_mask  <= ierr_bit_mask;
            err_bit_idx   <= ierr_bit_idx;
          end
        end
        //
        cDO_STATE : begin
          if (ival) begin
            cnt           <= '0;
            cnt.zero      <= 1'b1;
            //
            strb          <= istrb;
            //
            Lextr         <= imin1 - imin0;
            //
            err_bit_mask  <= ierr_bit_mask;
            err_bit_idx   <= ierr_bit_idx;
          end
          else begin
            cnt.value <=  cnt.done ? '0 : (cnt.value + 1'b1);
            cnt.done  <= (cnt.value == length_m2);
            cnt.zero  <=  cnt.done;
          end
        end
      endcase
    end
  end

  assign ohd_read  = (state == cDO_STATE);

  //------------------------------------------------------------------------------------------------------
  // Do decision and gent Lextr. Ram read latency is 0 tick (!!!)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= (state == cDO_STATE);
    end
  end

  always_comb begin
    bitdat = ihd;
    for (int i = 0; i < 5; i++) begin
      if (cnt.value == err_bit_idx[i]) begin
        bitdat ^= err_bit_mask[i];
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // regenerate strobes
      ostrb.sof   <= strb.sof & cnt.zero;
      ostrb.sop   <= cnt.zero;
      ostrb.eop   <= cnt.done;
      ostrb.eof   <= strb.eof & cnt.done;
      // save mask
      ostrb.mask  <= strb.mask;
      //
      oLextr      <= bitdat ? do_saturation(Lextr) : -do_saturation(Lextr);
      obitdat     <= bitdat;
      //
      if (cnt.zero) begin
        odecfail <= idecfail; // hold ~ 5 ticks
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function extr_t do_saturation (input metric_t data);
    logic poverflow;
    logic noverflow;
  begin
    poverflow     = (data >  (2**(pEXTR_W-1)-1));
    noverflow     = (data < -(2**(pEXTR_W-1)-1));
    do_saturation = data[pEXTR_W-1 : 0];
    //
    if (poverflow) begin
      do_saturation =  (2**(pEXTR_W-1)-1);
    end
    else if (noverflow) begin
      do_saturation = -(2**(pEXTR_W-1)-1);
    end
  end
  endfunction

endmodule
