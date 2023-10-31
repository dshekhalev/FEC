/*



  parameter int pLLR_W  = 5 ;
  parameter int pEXTR_W = 5 ;



  logic           btc_dec_spc_decode__iclk         ;
  logic           btc_dec_spc_decode__ireset       ;
  logic           btc_dec_spc_decode__iclkena      ;
  //
  btc_code_mode_t btc_dec_spc_decode__imode        ;
  //
  logic           btc_dec_spc_decode__ival         ;
  strb_t          btc_dec_spc_decode__istrb        ;
  logic           btc_dec_spc_decode__iLapri_ptr   ;
  logic           btc_dec_spc_decode__iprod_sign   ;
  extr_t          btc_dec_spc_decode__imin0        ;
  bit_idx_t       btc_dec_spc_decode__imin0_idx    ;
  extr_t          btc_dec_spc_decode__imin1        ;
  //
  extr_t          btc_dec_spc_decode__iLapri       ;
  logic           btc_dec_spc_decode__oLapri_read  ;
  logic           btc_dec_spc_decode__oLapri_rptr  ;
  bit_idx_t       btc_dec_spc_decode__oLapri_raddr ;
  //
  logic           btc_dec_spc_decode__opre_val     ;
  //
  logic           btc_dec_spc_decode__oval         ;
  strb_t          btc_dec_spc_decode__ostrb        ;
  extr_t          btc_dec_spc_decode__oLextr       ;
  logic           btc_dec_spc_decode__obitdat      ;
  //
  logic           btc_dec_spc_decode__odecfail     ;



  btc_dec_spc_decode
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  btc_dec_spc_decode
  (
    .iclk         ( btc_dec_spc_decode__iclk         ) ,
    .ireset       ( btc_dec_spc_decode__ireset       ) ,
    .iclkena      ( btc_dec_spc_decode__iclkena      ) ,
    //
    .imode        ( btc_dec_spc_decode__imode        ) ,
    //
    .ival         ( btc_dec_spc_decode__ival         ) ,
    .istrb        ( btc_dec_spc_decode__istrb        ) ,
    .iLapri_ptr   ( btc_dec_spc_decode__iLapri_ptr   ) ,
    .iprod_sign   ( btc_dec_spc_decode__iprod_sign   ) ,
    .imin0        ( btc_dec_spc_decode__imin0        ) ,
    .imin0_idx    ( btc_dec_spc_decode__imin0_idx    ) ,
    .imin1        ( btc_dec_spc_decode__imin1        ) ,
    //
    .iLapri       ( btc_dec_spc_decode__iLapri       ) ,
    .oLapri_read  ( btc_dec_spc_decode__oLapri_read  ) ,
    .oLapri_rptr  ( btc_dec_spc_decode__oLapri_rptr  ) ,
    .oLapri_raddr ( btc_dec_spc_decode__oLapri_raddr ) ,
    //
    .opre_val     ( btc_dec_spc_decode__opre_val     ) ,
    //
    .oval         ( btc_dec_spc_decode__oval         ) ,
    .ostrb        ( btc_dec_spc_decode__ostrb        ) ,
    .oLextr       ( btc_dec_spc_decode__oLextr       ) ,
    .obitdat      ( btc_dec_spc_decode__obitdat      ) ,
    //
    .odecfail     ( btc_dec_spc_decode__odecfail     )
  );


  assign btc_dec_spc_decode__iclk       = '0 ;
  assign btc_dec_spc_decode__ireset     = '0 ;
  assign btc_dec_spc_decode__iclkena    = '0 ;
  assign btc_dec_spc_decode__imode      = '0 ;
  assign btc_dec_spc_decode__ival       = '0 ;
  assign btc_dec_spc_decode__istrb      = '0 ;
  assign btc_dec_spc_decode__iLapri_ptr = '0 ;
  assign btc_dec_spc_decode__iprod_sign = '0 ;
  assign btc_dec_spc_decode__imin0      = '0 ;
  assign btc_dec_spc_decode__imin0_idx  = '0 ;
  assign btc_dec_spc_decode__imin1      = '0 ;
  assign btc_dec_spc_decode__iLapri     = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_spc_decode.sv
// Description   : single bit in/out SPC soft decoder
//

module btc_dec_spc_decode
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  imode        ,
  //
  ival         ,
  istrb        ,
  iLapri_ptr   ,
  iprod_sign   ,
  imin0        ,
  imin0_idx    ,
  imin1        ,
  //
  iLapri       ,
  oLapri_read  ,
  oLapri_rptr  ,
  oLapri_raddr ,
  //
  opre_val     ,
  //
  oval         ,
  ostrb        ,
  oLextr       ,
  obitdat      ,
  //
  odecfail
);

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk         ;
  input  logic           ireset       ;
  input  logic           iclkena      ;
  //
  input  btc_code_mode_t imode        ;
  // sort init interface
  input  logic           ival         ;
  input  strb_t          istrb        ;
  input  logic           iLapri_ptr   ;
  input  logic           iprod_sign   ;
  input  extr_t          imin0        ;
  input  bit_idx_t       imin0_idx    ;
  input  extr_t          imin1        ;
  // Lapri ram reading interface
  input  extr_t          iLapri       ;
  output logic           oLapri_read  ;
  output logic           oLapri_rptr  ;
  output bit_idx_t       oLapri_raddr ;
  // look ahead oval
  output logic           opre_val     ;
  // output interface
  output logic           oval         ;
  output strb_t          ostrb        ;
  output extr_t          oLextr       ;
  output logic           obitdat      ;
  //
  output logic           odecfail     ;

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

  bit_idx_t length_m2 ;

  strb_t    strb      ;

  logic     Lapri_ptr ;

  logic     prod_sign ;
  extr_t    min0      ;
  bit_idx_t min0_idx  ;
  extr_t    min1      ;

  extr_t    absLapri   ;
  logic     signLapri  ;
  extr_t    Lapri      ;

  logic     Lextr_val  ;
  strb_t    Lextr_strb ;
  logic     Lextr_prod_sign;
  logic     signLextr  ;
  extr_t    absLextr   ;
  extr_t    Lextr      ;

  extr_p1_t Lapo       ; // + 1 for prevent overflow

  logic     bitdat     ;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
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

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // fixed for decode cycle
      length_m2 <= get_code_bits(imode) - 2;
      //
      case (state)
        cRESET_STATE : begin
          if (ival) begin // hold new results
            cnt       <= '0;
            cnt.zero  <= 1'b1;
            //
            strb      <= istrb;
            //
            Lapri_ptr <= iLapri_ptr;
            //
            prod_sign <= iprod_sign;
            min0      <= imin0;
            min0_idx  <= imin0_idx;
            min1      <= imin1;
          end
        end
        //
        cDO_STATE : begin
          if (ival) begin
            cnt       <= '0;
            cnt.zero  <= 1'b1;
            //
            strb      <= istrb;
            //
            Lapri_ptr <= iLapri_ptr;
            //
            prod_sign <= iprod_sign;
            min0      <= imin0;
            min0_idx  <= imin0_idx;
            min1      <= imin1;
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

  assign oLapri_read  = (state == cDO_STATE);
  assign oLapri_rptr  = Lapri_ptr;
  assign oLapri_raddr = cnt.value;

  //------------------------------------------------------------------------------------------------------
  // count Lextr. Ram read latency is 0 tick (!!!)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      Lextr_val <= 1'b0;
    end
    else if (iclkena) begin
      Lextr_val <= (state == cDO_STATE);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // regenerate strobes
      Lextr_strb.sof  <= strb.sof & cnt.zero;
      Lextr_strb.sop  <= cnt.zero;
      Lextr_strb.eop  <= cnt.done;
      Lextr_strb.eof  <= strb.eof & cnt.done;
      // save mask
      Lextr_strb.mask <= strb.mask;
      //
      signLapri       <= iLapri[$high(iLapri)];  // Lapri < 0
      absLapri        <= {1'b0, iLapri[$high(Lapri)-1 : 0]};
      //
      Lextr_prod_sign <= prod_sign;
      absLextr        <= (cnt.value == min0_idx) ? min1 : min0;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // do decision
  //------------------------------------------------------------------------------------------------------

  assign opre_val = Lextr_val; // look ahead oval

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= Lextr_val;
    end
  end

  assign signLextr  = Lextr_prod_sign ^ signLapri;

  assign Lapri      = signLapri ? -absLapri : absLapri;
  assign Lextr      = signLextr ? -absLextr : absLextr;

  assign Lapo       = Lapri + Lextr;

  assign bitdat     = !Lapo[$high(Lapo)]; // Lapo >= 0

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostrb   <= Lextr_strb;
      oLextr  <= Lextr;
      obitdat <= bitdat;
      // decfail if parity fail occured
      if (Lextr_val) begin
        odecfail <= Lextr_strb.sop ? bitdat : (odecfail ^ bitdat);
      end
    end
  end

endmodule
