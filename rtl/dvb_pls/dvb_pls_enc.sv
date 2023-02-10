/*



  parameter int pTAG_W = 4 ;



  logic                dvb_pls_enc__iclk    ;
  logic                dvb_pls_enc__ireset  ;
  logic                dvb_pls_enc__iclkena ;
  //
  logic                dvb_pls_enc__ival    ;
  logic        [6 : 0] dvb_pls_enc__idat    ;
  logic [pTAG_W-1 : 0] dvb_pls_enc__itag    ;
  logic                dvb_pls_enc__ordy    ;
  //
  logic                dvb_pls_enc__ireq    ;
  //
  logic                dvb_pls_enc__osop    ;
  logic                dvb_pls_enc__oval    ;
  logic                dvb_pls_enc__oeop    ;
  logic                dvb_pls_enc__odat    ;
  logic [pTAG_W-1 : 0] dvb_pls_enc__otag    ;
  //
  logic                dvb_pls_enc__owval   ;
  logic       [63 : 0] dvb_pls_enc__owdat   ;



  dvb_pls_enc
  #(
    .pTAG_W ( pTAG_W )
  )
  dvb_pls_enc
  (
    .iclk    ( dvb_pls_enc__iclk    ) ,
    .ireset  ( dvb_pls_enc__ireset  ) ,
    .iclkena ( dvb_pls_enc__iclkena ) ,
    //
    .ival    ( dvb_pls_enc__ival    ) ,
    .idat    ( dvb_pls_enc__idat    ) ,
    .itag    ( dvb_pls_enc__itag    ) ,
    .ordy    ( dvb_pls_enc__ordy    ) ,
    //
    .ireq    ( dvb_pls_enc__ireq    ) ,
    //
    .osop    ( dvb_pls_enc__osop    ) ,
    .oval    ( dvb_pls_enc__oval    ) ,
    .oeop    ( dvb_pls_enc__oeop    ) ,
    .odat    ( dvb_pls_enc__odat    ) ,
    .otag    ( dvb_pls_enc__otag    ) ,
    //
    .owval   ( dvb_pls_enc__owval   ) ,
    .owdat   ( dvb_pls_enc__owdat   )
  );


  assign dvb_pls_enc__iclk    = '0 ;
  assign dvb_pls_enc__ireset  = '0 ;
  assign dvb_pls_enc__iclkena = '0 ;
  assign dvb_pls_enc__ival    = '0 ;
  assign dvb_pls_enc__idat    = '0 ;
  assign dvb_pls_enc__itag    = '0 ;
  assign dvb_pls_enc__ireq    = '0 ;



*/

//
// Project       : PLS DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pls_enc.sv
// Description   : DVB PLS non-systematic code encoder with scrambler with bit (LSB first) or word output
//


module dvb_pls_enc
#(
  parameter int pTAG_W = 4
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  idat    ,
  itag    ,
  ordy    ,
  //
  ireq    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  otag    ,
  //
  owval   ,
  owdat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                ival    ;
  input  logic        [6 : 0] idat    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  output logic                ordy    ;
  //
  input  logic                ireq    ; // used only for bit output
  //
  output logic                osop    ;
  output logic                oval    ;
  output logic                oeop    ;
  output logic                odat    ;
  output logic [pTAG_W-1 : 0] otag    ;
  //
  output logic                owval   ;
  output logic       [63 : 0] owdat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "dvb_pls_constants.svh"

  typedef bit [63 : 0] dat_t;

  localparam int cCNT_MAX       = $bits(dat_t);
  localparam int cLOG2_CNT_MAX  = $clog2(cCNT_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE ,
    cDO_STATE
  } state;

  struct packed {
    logic                       zero;
    logic                       done;
    logic [cLOG2_CNT_MAX-1 : 0] value;  // 64 bits
  } cnt;

  dat_t coded_data;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <= ival      ? cDO_STATE     : cRESET_STATE;
        cDO_STATE    : state <= ireq & cnt.done  ? cRESET_STATE  : cDO_STATE;
      endcase
    end
  end

  assign ordy = (state == cRESET_STATE);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cRESET_STATE : begin
          cnt      <= '0;
          cnt.zero <= 1'b1;
          //
          if (ival) begin
            otag       <= itag;
            //
            coded_data <= do_encode(idat);
          end
        end
        cDO_STATE : begin
          if (ireq) begin
            cnt.value  <=  cnt.value + 1'b1;
            cnt.done   <= (cnt.value == (cCNT_MAX-2));
            cnt.zero   <= 1'b0;
            //
            coded_data <= (coded_data >> 1);
          end
        end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // word intefrace
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owval <= 1'b0;
    end
    else if (iclkena) begin
      owval <= ival & (state == cRESET_STATE);
    end
  end

  assign owdat = coded_data;

  //------------------------------------------------------------------------------------------------------
  // bit interface :: do register outside if needed
  //------------------------------------------------------------------------------------------------------

  assign osop = cnt.zero;
  assign oval = (state == cDO_STATE) & ireq;
  assign oeop = cnt.done;
  assign odat = coded_data[0];

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  function dat_t do_encode (input bit [6 : 0] dat);
    bit [31 : 0] rm_code;
  begin
    rm_code = '0;
    for (int i = 0; i < 32; i++) begin
      for (int b = 0; b < 6; b++) begin
        rm_code[i] ^= dat[b] & cGMATRIX[b][i];
      end
    end
    //
    for (int i = 0; i < 32; i++) begin
      do_encode[2*i + 0] = rm_code[i];
      do_encode[2*i + 1] = rm_code[i] ^ dat[6];
    end
    //
    for (int i = 0; i < 64; i++) begin
      do_encode[i] ^= cSCRAMBLE_WORD[i];
    end
  end
  endfunction

endmodule
