/*



  parameter int pN_MAX    = 1024 ;
  parameter int pTAG_W    =    4 ;
  parameter bit pUSE_CRC  =    1 ;



  logic      pc_3gpp_enc_source__iclk     ;
  logic      pc_3gpp_enc_source__ireset   ;
  logic      pc_3gpp_enc_source__iclkena  ;
  logic      pc_3gpp_enc_source__isop     ;
  logic      pc_3gpp_enc_source__ival     ;
  logic      pc_3gpp_enc_source__ieop     ;
  logic      pc_3gpp_enc_source__idat     ;
  logic      pc_3gpp_enc_source__itag     ;
  logic      pc_3gpp_enc_source__ordy     ;
  logic      pc_3gpp_enc_source__obusy    ;
  logic      pc_3gpp_enc_source__ifulla   ;
  logic      pc_3gpp_enc_source__iemptya  ;
  logic      pc_3gpp_enc_source__owrite   ;
  logic      pc_3gpp_enc_source__owfull   ;
  bit_addr_t pc_3gpp_enc_source__owaddr   ;
  logic      pc_3gpp_enc_source__owdat    ;
  tag_t      pc_3gpp_enc_source__owtag    ;



  pc_3gpp_enc_source
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pTAG_W   ( pTAG_W   ) ,
    .pUSE_CRC ( pUSE_CRC )
  )
  pc_3gpp_enc_source
  (
    .iclk    ( pc_3gpp_enc_source__iclk    ) ,
    .ireset  ( pc_3gpp_enc_source__ireset  ) ,
    .iclkena ( pc_3gpp_enc_source__iclkena ) ,
    .idlen   ( pc_3gpp_enc_source__idlen   ) ,
    .isop    ( pc_3gpp_enc_source__isop    ) ,
    .ival    ( pc_3gpp_enc_source__ival    ) ,
    .ieop    ( pc_3gpp_enc_source__ieop    ) ,
    .idat    ( pc_3gpp_enc_source__idat    ) ,
    .itag    ( pc_3gpp_enc_source__itag    ) ,
    .ordy    ( pc_3gpp_enc_source__ordy    ) ,
    .obusy   ( pc_3gpp_enc_source__obusy   ) ,
    .ifulla  ( pc_3gpp_enc_source__ifulla  ) ,
    .iemptya ( pc_3gpp_enc_source__iemptya ) ,
    .owrite  ( pc_3gpp_enc_source__owrite  ) ,
    .owfull  ( pc_3gpp_enc_source__owfull  ) ,
    .owaddr  ( pc_3gpp_enc_source__owaddr  ) ,
    .owdat   ( pc_3gpp_enc_source__owdat   ) ,
    .owtag   ( pc_3gpp_enc_source__owtag   )
  );


  assign pc_3gpp_enc_source__iclk    = '0 ;
  assign pc_3gpp_enc_source__ireset  = '0 ;
  assign pc_3gpp_enc_source__iclkena = '0 ;
  assign pc_3gpp_enc_source__idlen   = '0 ;
  assign pc_3gpp_enc_source__isop    = '0 ;
  assign pc_3gpp_enc_source__ival    = '0 ;
  assign pc_3gpp_enc_source__ieop    = '0 ;
  assign pc_3gpp_enc_source__idat    = '0 ;
  assign pc_3gpp_enc_source__itag    = '0 ;
  assign pc_3gpp_enc_source__iempty  = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_enc_source.v
// Description   : Encoder source unit. Assemble bit channels frame using table & count CRC if needed
//


module pc_3gpp_enc_source
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat    ,
  itag    ,
  //
  ordy    ,
  obusy   ,
  //
  ifulla  ,
  iemptya ,
  //
  owrite  ,
  owfull  ,
  owaddr  ,
  owdat   ,
  owtag
);

  `include "pc_3gpp_enc_types.svh"

  parameter bit pUSE_CRC  = 0 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk     ;
  input  logic      ireset   ;
  input  logic      iclkena  ;
  //
  input  logic      isop     ;
  input  logic      ival     ;
  input  logic      ieop     ;
  input  logic      idat     ;
  input  tag_t      itag     ;
  //
  output logic      ordy     ;
  output logic      obusy    ;
  //
  input  logic      ifulla   ;
  input  logic      iemptya  ;
  //
  output logic      owrite   ;
  output logic      owfull   ;
  output bit_addr_t owaddr   ;
  output logic      owdat    ;
  output tag_t      owtag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../pc_3gpp_ts_38_212_tab.svh"

  localparam int cCNT_W = cNLOG2;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [1 : 0] {
    cRESET_STATE  ,
    //
    cDATA_STATE   ,
    cCRC_STATE    ,
    cFREEZE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  logic busy;

  struct packed {
    logic                 done;
    logic [cCNT_W-1 : 0]  val;
  } cnt;

  struct packed {
    logic         done;
    logic [2 : 0] val;
  } crc_cnt;

  logic val;
  logic eop;
  logic dat;

  crc_t crc;

  //------------------------------------------------------------------------------------------------------
  // reclock input data to align
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= 1'b0;
      eop <= 1'b0;
    end
    else if (iclkena) begin
      val <= ival;
      eop <= ival & ieop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dat <= idat;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // control FSM
  //------------------------------------------------------------------------------------------------------

  wire start = ordy & ival & isop;  // start before

  wire stop  = eop;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
      busy  <= 1'b0;
    end
    else if (iclkena) begin
      if (start) begin
        state <= cDATA_STATE;
      end
      else begin
        case (state)
          cRESET_STATE  : state <= cRESET_STATE;
          //
          cDATA_STATE   : state <= stop         ? (pUSE_CRC ? cCRC_STATE : cFREEZE_STATE) : cDATA_STATE;
          //
          cCRC_STATE    : state <= crc_cnt.done ? cFREEZE_STATE                           : cCRC_STATE;
          //
          cFREEZE_STATE : state <= cnt.done     ? cRESET_STATE                            : cFREEZE_STATE;
        endcase
      end
      //
      if (state == cDATA_STATE & ival & ieop) begin
        busy <= 1'b1;
      end
      else if (owfull) begin
        busy <= 1'b0;
      end
    end
  end

  assign ordy   = !busy & !ifulla;  // not ready if all buffers is full
  assign obusy  =  busy | !iemptya; // busy if any buffer is not empty

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        cnt <= '0;
      end
      else if ((val & state == cDATA_STATE) | (state == cCRC_STATE | state == cFREEZE_STATE)) begin
        cnt.val   <=  cnt.val + 1'b1;
        cnt.done  <= (cnt.val == pN_MAX-2);
      end
      //
      if (state == cCRC_STATE) begin
        crc_cnt.val   <=  crc_cnt.val + 1'b1;
        crc_cnt.done  <= (crc_cnt.val == cCRC_W-2);
      end
      else begin
        crc_cnt <= '0;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite  <= 1'b0;
      owfull  <= 1'b0;
    end
    else if (iclkena) begin
      owrite  <= (val & (state == cDATA_STATE)) | (state == cCRC_STATE) | (state == cFREEZE_STATE);
      owfull  <= (state == cFREEZE_STATE) & cnt.done;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owaddr <= reverse_bit(bits_addr_tab[cnt.val], cNLOG2);
      //
      owdat  <= (state != cFREEZE_STATE) & ((state == cCRC_STATE) ? crc[0] : dat);
      //
      if (start) begin
        owtag <= itag;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // CRC counter
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cDATA_STATE & val) begin
        crc <= get_crc(crc, dat);
      end
      else if (state == cCRC_STATE) begin
        crc <= crc >> 1;
      end
      else begin
        crc <= '0;
      end
    end
  end

endmodule
