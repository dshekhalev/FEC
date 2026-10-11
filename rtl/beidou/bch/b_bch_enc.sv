/*



  parameter bit pUSE_L_POLY = 0 ;
  parameter int pTAG_W      = 8 ;



  logic                b_bch_enc__iclk    ;
  logic                b_bch_enc__ireset  ;
  logic                b_bch_enc__iclkena ;
  //
  logic                b_bch_enc__ival    ;
  logic [cDAT_W-1 : 0] b_bch_enc__idat    ;
  logic [pTAG_W-1 : 0] b_bch_enc__itag    ;
  logic                b_bch_enc__ordy    ;
  //
  logic                b_bch_enc__irdy    ;
  logic                b_bch_enc__osop    ;
  logic                b_bch_enc__oval    ;
  logic                b_bch_enc__oeop    ;
  logic                b_bch_enc__odat    ;
  logic [pTAG_W-1 : 0] b_bch_enc__otag    ;



  b_bch_enc
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pTAG_W      ( pTAG_W      )
  )
  b_bch_enc
  (
    .iclk    ( b_bch_enc__iclk    ) ,
    .ireset  ( b_bch_enc__ireset  ) ,
    .iclkena ( b_bch_enc__iclkena ) ,
    //
    .ival    ( b_bch_enc__ival    ) ,
    .idat    ( b_bch_enc__idat    ) ,
    .itag    ( b_bch_enc__itag    ) ,
    .ordy    ( b_bch_enc__ordy    ) ,
    //
    .irdy    ( b_bch_enc__irdy    ) ,
    .osop    ( b_bch_enc__osop    ) ,
    .oval    ( b_bch_enc__oval    ) ,
    .oeop    ( b_bch_enc__oeop    ) ,
    .odat    ( b_bch_enc__odat    ) ,
    .otag    ( b_bch_enc__otag    )
  );


  assign b_bch_enc__iclk    = '0 ;
  assign b_bch_enc__ireset  = '0 ;
  assign b_bch_enc__iclkena = '0 ;
  assign b_bch_enc__ival    = '0 ;
  assign b_bch_enc__idat    = '0 ;
  assign b_bch_enc__itag    = '0 ;
  assign b_bch_enc__irdy    = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_enc.svh
// Description   : encoder for data word, used bits iLcode ? data[7 : 0] : data[5 : 0]
//                 send to output serial stream, MSB first (!!!)
//


module b_bch_enc
#(
  parameter bit pUSE_L_POLY = 0 ,
  parameter int pTAG_W      = 8
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
  irdy    ,
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  otag
);

  `include "b_bch_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = cDBIT_NUM[pUSE_L_POLY] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                ival    ;
  input  logic [cDAT_W-1 : 0] idat    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  output logic                ordy    ;
  //
  input  logic                irdy    ;
  output logic                osop    ;
  output logic                oval    ;
  output logic                oeop    ;
  output logic                odat    ;
  output logic [pTAG_W-1 : 0] otag    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_MAX = cBIT_NUM[pUSE_L_POLY];
  localparam int cCNT_W   = $clog2(cCNT_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE ,
    cDO_STATE
  } state;

  struct packed {
    logic                zero;
    logic                done;
    logic [cCNT_W-1 : 0] value;
  } cnt;

  logic [cDAT_W-1 : 0] dat;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire used_rdy = oval ? irdy : 1'b1;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE  : state <= ival                  ? cDO_STATE    : cRESET_STATE;
        cDO_STATE     : state <= (cnt.done & used_rdy) ? cRESET_STATE : cDO_STATE ;
      endcase
    end
  end

  assign ordy = (state == cRESET_STATE);

  //------------------------------------------------------------------------------------------------------
  // counters & coding
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cRESET_STATE : begin
          cnt       <= '0;
          cnt.zero  <= 1'b1;
          //
          for (int i = 0; i < cDAT_W; i++) begin
            dat[i] <= idat[cDAT_W-1-i];     // msb first (!!!)
          end
        end
        //
        cDO_STATE  : begin
          if (used_rdy) begin
            cnt.value   <= (cnt.value + 1'b1);
            cnt.done    <= (cnt.value == (cCNT_MAX-2));
            cnt.zero    <= 1'b0;
            //
            dat           <= (dat >> 1);
            dat[cDAT_W-1] <= encode_bit(dat, pUSE_L_POLY);
          end
        end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output logic
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      if (!oval | (oval & irdy)) begin
        oval <= (state == cDO_STATE);
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cRESET_STATE : begin
          if (ival) begin
            otag <= itag;
          end
        end
        //
        cDO_STATE : begin
          if (!oval | (oval & irdy)) begin
            osop <= cnt.zero;
            oeop <= cnt.done;
            odat <= dat[0];
          end
        end
      endcase
    end
  end

endmodule
