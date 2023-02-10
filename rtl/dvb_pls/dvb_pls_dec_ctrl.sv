/*






  logic dvb_pls_dec_ctrl__iclk           ;
  logic dvb_pls_dec_ctrl__ireset         ;
  logic dvb_pls_dec_ctrl__iclkena        ;
  //
  logic dvb_pls_dec_ctrl__isop           ;
  logic dvb_pls_dec_ctrl__ival           ;
  logic dvb_pls_dec_ctrl__ieop           ;
  logic dvb_pls_dec_ctrl__ordy           ;
  //
  logic dvb_pls_dec_ctrl__ihadamard_done ;
  logic dvb_pls_dec_ctrl__osort_sop      ;
  logic dvb_pls_dec_ctrl__osort_val      ;
  logic dvb_pls_dec_ctrl__osort_eop      ;



  dvb_pls_dec_ctrl
  dvb_pls_dec_ctrl
  (
    .iclk           ( dvb_pls_dec_ctrl__iclk           ) ,
    .ireset         ( dvb_pls_dec_ctrl__ireset         ) ,
    .iclkena        ( dvb_pls_dec_ctrl__iclkena        ) ,
    //
    .isop           ( dvb_pls_dec_ctrl__isop           ) ,
    .ival           ( dvb_pls_dec_ctrl__ival           ) ,
    .ieop           ( dvb_pls_dec_ctrl__ieop           ) ,
    .ordy           ( dvb_pls_dec_ctrl__ordy           ) ,
    //
    .ihadamard_done ( dvb_pls_dec_ctrl__ihadamard_done ) ,
    .osort_sop      ( dvb_pls_dec_ctrl__osort_sop      ) ,
    .osort_val      ( dvb_pls_dec_ctrl__osort_val      ) ,
    .osort_eop      ( dvb_pls_dec_ctrl__osort_eop      )
  );


  assign dvb_pls_dec_ctrl__iclk           = '0 ;
  assign dvb_pls_dec_ctrl__ireset         = '0 ;
  assign dvb_pls_dec_ctrl__iclkena        = '0 ;
  assign dvb_pls_dec_ctrl__isop           = '0 ;
  assign dvb_pls_dec_ctrl__ival           = '0 ;
  assign dvb_pls_dec_ctrl__ieop           = '0 ;
  assign dvb_pls_dec_ctrl__ihadamard_done = '0 ;



*/

//
// Project       : PLS DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_pls_dec_ctrl.sv
// Description   : DVB PLS decoder controler: do input flow control and generate conrol sequences
//


module dvb_pls_dec_ctrl
(
  iclk             ,
  ireset           ,
  iclkena          ,
  //
  isop             ,
  ival             ,
  ieop             ,
  ordy             ,
  //
  ihadamard_done   ,
  osort_sop        ,
  osort_val        ,
  osort_eop
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic iclk           ;
  input  logic ireset         ;
  input  logic iclkena        ;
  //
  input  logic isop           ;
  input  logic ival           ;
  input  logic ieop           ;
  output logic ordy           ;
  //
  input  logic ihadamard_done ;
  output logic osort_sop      ;
  output logic osort_val      ;
  output logic osort_eop      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_MAX       = 32;
  localparam int cLOG2_CNT_MAX  = $clog2(cCNT_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [1 : 0] {
    cRESET_STATE     ,
    //
    cWAIT_STATE      ,
    cWAIT_MULT_STATE ,
    //
    cDO_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  struct packed {
    logic                       zero;
    logic                       done;
    logic [cLOG2_CNT_MAX-1 : 0] value;
  } cnt;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE      : state <= cWAIT_STATE;
        //
        cWAIT_STATE       : state <= (ival & ieop)  ? cWAIT_MULT_STATE  : cWAIT_STATE;
        cWAIT_MULT_STATE  : state <= ihadamard_done ? cDO_STATE         : cWAIT_MULT_STATE;
        //
        cDO_STATE         : state <=  cnt.done      ? cWAIT_STATE       : cDO_STATE;
      endcase
    end
  end

  assign ordy = (state == cWAIT_STATE);

  //------------------------------------------------------------------------------------------------------
  // FSM cnt
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      cnt      <= '0;
      cnt.zero <= 1'b1;
      //
      if (state == cDO_STATE) begin
        cnt.value <=  cnt.value + 1'b1;
        cnt.done  <= (cnt.value == (cCNT_MAX-2));
        cnt.zero  <=  1'b0;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  assign osort_sop = cnt.zero;
  assign osort_val = (state == cDO_STATE);
  assign osort_eop = cnt.done;

endmodule
