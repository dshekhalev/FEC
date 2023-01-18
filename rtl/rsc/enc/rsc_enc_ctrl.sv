/*



  parameter int pW  = 13 ;



  logic            rsc_enc_ctrl__iclk         ;
  logic            rsc_enc_ctrl__ireset       ;
  logic            rsc_enc_ctrl__iclkena      ;
  logic            rsc_enc_ctrl__idbsclk      ;
  logic    [3 : 0] rsc_enc_ctrl__icode        ;
  logic [pW-1 : 0] rsc_enc_ctrl__iN           ;
  logic            rsc_enc_ctrl__ibuf_full    ;
  logic            rsc_enc_ctrl__obuf_empty   ;
  logic            rsc_enc_ctrl__iobuf_empty  ;
  logic            rsc_enc_ctrl__oaddr_clear  ;
  logic            rsc_enc_ctrl__oaddr_enable ;
  logic            rsc_enc_ctrl__ostate_clear ;
  logic            rsc_enc_ctrl__ostate_load  ;
  logic            rsc_enc_ctrl__osop         ;
  logic            rsc_enc_ctrl__oeop         ;
  logic            rsc_enc_ctrl__oval         ;
  logic            rsc_enc_ctrl__olast        ;
  logic    [1 : 0] rsc_enc_ctrl__ostage       ;



  rsc_enc_ctrl
  #(
    .pW ( pW )
  )
  rsc_enc_ctrl
  (
    .iclk         ( rsc_enc_ctrl__iclk         ) ,
    .ireset       ( rsc_enc_ctrl__ireset       ) ,
    .iclkena      ( rsc_enc_ctrl__iclkena      ) ,
    .idbsclk      ( rsc_enc_ctrl__idbsclk      ) ,
    .icode        ( rsc_enc_ctrl__icode        ) ,
    .iN           ( rsc_enc_ctrl__iN           ) ,
    .ibuf_full    ( rsc_enc_ctrl__ibuf_full    ) ,
    .obuf_empty   ( rsc_enc_ctrl__obuf_empty   ) ,
    ,iobuf_empty  ( rsc_enc_ctrl__iobuf_empty  ) ,
    .oaddr_clear  ( rsc_enc_ctrl__oaddr_clear  ) ,
    .oaddr_enable ( rsc_enc_ctrl__oaddr_enable ) ,
    .ostate_clear ( rsc_enc_ctrl__ostate_clear ) ,
    .ostate_load  ( rsc_enc_ctrl__ostate_load  ) ,
    .osop         ( rsc_enc_ctrl__osop         ) ,
    .oeop         ( rsc_enc_ctrl__oeop         ) ,
    .oval         ( rsc_enc_ctrl__oval         ) ,
    .olast        ( rsc_enc_ctrl__olast        ) ,
    .ostage       ( rsc_enc_ctrl__ostage       )
  );


  assign rsc_enc_ctrl__iclk        = '0 ;
  assign rsc_enc_ctrl__ireset      = '0 ;
  assign rsc_enc_ctrl__iclkena     = '0 ;
  assign rsc_enc_ctrl__idbsclk     = '0 ;
  assign rsc_enc_ctrl__icode       = '0 ;
  assign rsc_enc_ctrl__iN          = '0 ;
  assign rsc_enc_ctrl__ibuf_full   = '0 ;
  assign rsc_enc_ctrl__iobuf_empty = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_enc_ctrl.sv
// Description   : RSC encoder controller. Generate control signal sequence for two pass encoding process
//

module rsc_enc_ctrl
#(
  parameter int pW  = 13  // don't change
)
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  idbsclk      ,
  //
  icode        ,
  iN           ,
  //
  ibuf_full    ,
  obuf_empty   ,
  iobuf_empty  ,
  //
  oaddr_clear  ,
  oaddr_enable ,
  //
  ostate_clear ,
  ostate_load  ,
  //
  osop         ,
  oeop         ,
  oval         ,
  olast        ,
  ostage
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk          ;
  input  logic            ireset        ;
  input  logic            iclkena       ;
  //
  input  logic            idbsclk       ; // dbit symbol clock
  // code parameters
  input  logic    [3 : 0] icode         ;   // code rate  0       - 1/3,
                                            //            [1 : 9] - [1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8; 8/9; 9/10]
                                            //            [10:11] - [2:3]/5
                                            //            12      - 3/7
  input  logic [pW-1 : 0] iN            ;
  // input buffer control
  input  logic            ibuf_full     ;
  output logic            obuf_empty    ;
  //
  input  logic            iobuf_empty   ;
  // addr generator control
  output logic            oaddr_clear   ;
  output logic            oaddr_enable  ;
  // engine state control
  output logic            ostate_clear  ;
  output logic            ostate_load   ;
  // engine control
  output logic            osop          ;
  output logic            oeop          ;
  output logic            oval          ;
  output logic            olast         ;
  output logic    [1 : 0] ostage        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE     ,
    cWAIT_STATE      ,
    //
    cINIT_SC_STATE   ,
    cDATA_STATE      ,
    //
    cLOAD_SC_STATE   ,
    cPY_STATE        ,
    //
    cINIT_ADDR_STATE ,
    cPW_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  logic            nopw;
  logic [pW-1 : 0] num_m2;

  struct packed {
    logic [pW-1 : 0] value;
    logic zero;
    logic done;
  } cnt;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  wire buf_rdy = ibuf_full & iobuf_empty;  // encoder write data to output buffer imediately

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena & idbsclk) begin
      case (state)
        cRESET_STATE      : state <= buf_rdy  ? cWAIT_STATE     : cRESET_STATE;
        cWAIT_STATE       : state <= cINIT_SC_STATE;
        //
        cINIT_SC_STATE    : state <= cDATA_STATE;
        cDATA_STATE       : state <= cnt.done ? cLOAD_SC_STATE  : cDATA_STATE;
        //
        cLOAD_SC_STATE    : state <= cPY_STATE;
        cPY_STATE         : state <= cnt.done ? (nopw ? cRESET_STATE : cINIT_ADDR_STATE) : cPY_STATE;
        //
        cINIT_ADDR_STATE  : state <= cPW_STATE;
        cPW_STATE         : state <= cnt.done ? cRESET_STATE    : cPW_STATE;
      endcase
    end
  end

  assign obuf_empty   = idbsclk & cnt.done & (state == (nopw ? cPY_STATE : cPW_STATE));

  assign oaddr_clear  = idbsclk & ((state == cINIT_SC_STATE) | (state == cLOAD_SC_STATE) | (state == cINIT_ADDR_STATE));
  assign oaddr_enable = idbsclk & ((state == cDATA_STATE   ) | (state == cPY_STATE     ) | (state == cPW_STATE       ));

  assign ostate_clear = idbsclk & (state == cINIT_SC_STATE);
  assign ostate_load  = idbsclk & (state == cLOAD_SC_STATE);

  assign osop         = idbsclk & oaddr_enable & cnt.zero;
  assign oval         = idbsclk & oaddr_enable;
  assign oeop         = idbsclk & oaddr_enable & cnt.done;
  assign olast        = (state == (nopw ? cPY_STATE : cPW_STATE));

  assign ostage       = (state == cPW_STATE) ? 2'b10 : ((state == cPY_STATE) ? 2'b01 : 2'b00);

  always_ff @(posedge iclk) begin
    if (iclkena & idbsclk) begin
      if (state == cINIT_SC_STATE) begin  // take 2 tick to change encoder parameters
        nopw    <= (icode != 0) && (icode != 10) && (icode != 12); // only 1/3 and 2/5 and 3/7 code use w bits
        num_m2  <= iN - 3'd2;
      end
      if (oaddr_clear) begin
        cnt.value <= '0;
        cnt.zero  <= 1'b1;
        cnt.done  <= 1'b0;
      end
      else begin
        cnt.value <= cnt.value + 1'b1;
        cnt.zero  <= &cnt.value;
        cnt.done  <= (cnt.value == num_m2);
      end
    end
  end

endmodule
