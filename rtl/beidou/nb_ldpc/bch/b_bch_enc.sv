/*



  parameter int pTAG_W          = 8 ;
  parameter bit pUSE_LARGE_POLY = 0 ;



  logic                b_bch_enc__iclk    ;
  logic                b_bch_enc__ireset  ;
  logic                b_bch_enc__iclkena ;
  //
  logic                b_bch_enc__isop    ;
  logic                b_bch_enc__ival    ;
  logic                b_bch_enc__ieop    ;
  logic                b_bch_enc__idat    ;
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
    .pTAG_W          ( pTAG_W          ) ,
    .pUSE_LARGE_POLY ( pUSE_LARGE_POLY )
  )
  b_bch_enc
  (
    .iclk    ( b_bch_enc__iclk    ) ,
    .ireset  ( b_bch_enc__ireset  ) ,
    .iclkena ( b_bch_enc__iclkena ) ,
    //
    .isop    ( b_bch_enc__isop    ) ,
    .ival    ( b_bch_enc__ival    ) ,
    .ieop    ( b_bch_enc__ieop    ) ,
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
  assign b_bch_enc__isop    = '0 ;
  assign b_bch_enc__ival    = '0 ;
  assign b_bch_enc__ieop    = '0 ;
  assign b_bch_enc__idat    = '0 ;
  assign b_bch_enc__itag    = '0 ;
  assign b_bch_enc__irdy    = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_enc.svh
// Description   : encoder for binary data
//

module b_bch_enc
#(
  parameter int pTAG_W          = 8 ,
  parameter bit pUSE_LARGE_POLY = 0   // use {21,6}/{51, 8} mode (0)
)
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
  ordy    ,
  //
  irdy    ,
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  otag
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                isop    ;
  input  logic                ival    ;
  input  logic                ieop    ;
  input  logic                idat    ;
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

  localparam int cCNT_W = 6; // up to 63

  localparam int cDBIT_NUM  [2] = '{6,  8};
  localparam int cBIT_NUM   [2] = '{21, 51};

  localparam bit [8 : 0] cGPOLY [2] = '{
                                      9'b0_0101_0111, // x^6 +       x^4 +       x^2 + x + 1
                                      9'b1_1001_1111  // x^8 + x^7 + x^4 + x^3 + x^2 + x + 1
                                      };

  typedef logic [cDBIT_NUM[pUSE_LARGE_POLY]-1 : 0] this_t;

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

  this_t dat_buffer;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire used_rdy = oval ? irdy : 1'b1;

  wire start    = ival & !isop & ieop;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE  : state <= (ival & !isop & ieop) ? cDO_STATE    : cRESET_STATE;
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
          if (ival) begin // data move to lsb
            dat_buffer                    <= (dat_buffer >> 1);
            dat_buffer[$high(dat_buffer)] <= idat;
          end
        end
        //
        cDO_STATE  : begin
          if (used_rdy) begin
            cnt.value   <= (cnt.value + 1'b1);
            cnt.done    <= (cnt.value == (cBIT_NUM[pUSE_LARGE_POLY]-2));
            cnt.zero    <= 1'b0;
            //
            dat_buffer                    <=  (dat_buffer >> 1);
            dat_buffer[$high(dat_buffer)] <= ^(dat_buffer & cGPOLY[pUSE_LARGE_POLY]);
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
          if (ival & isop) begin
            otag <= itag;
          end
        end
        //
        cDO_STATE : begin
          if (!oval | (oval & irdy)) begin
            osop <= cnt.zero;
            oeop <= cnt.done;
            odat <= dat_buffer[0];
          end
        end
      endcase
    end
  end

endmodule
