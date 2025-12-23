/*



  parameter int pDAT_W    = 360 ;
  parameter int pTR_DAT_W =   8 ;
  //
  parameter int pROW_W    =   8 ;
  parameter int pSEL_W    =   9 ;
  parameter int pSHIFT_W  =   8 ;



  logic                  ldpc_dvb_enc_transponse_ctrl__iclk    ;
  logic                  ldpc_dvb_enc_transponse_ctrl__ireset  ;
  logic                  ldpc_dvb_enc_transponse_ctrl__iclkena ;
  //
  logic   [pROW_W-1 : 0] ldpc_dvb_enc_transponse_ctrl__iwrow   ;
  logic                  ldpc_dvb_enc_transponse_ctrl__iwfull  ;
  logic                  ldpc_dvb_enc_transponse_ctrl__ordy    ;
  //
  logic                  ldpc_dvb_enc_transponse_ctrl__ibusy   ;
  logic                  ldpc_dvb_enc_transponse_ctrl__odone   ;
  //
  logic   [pROW_W-1 : 0] ldpc_dvb_enc_transponse_ctrl__otrow   ;
  logic   [pSEL_W-1 : 0] ldpc_dvb_enc_transponse_ctrl__otsel   ;
  //
  logic                  ldpc_dvb_enc_transponse_ctrl__oval    ;
  logic                  ldpc_dvb_enc_transponse_ctrl__oload   ;
  logic                  ldpc_dvb_enc_transponse_ctrl__owrite  ;
  logic [pSHIFT_W-1 : 0] ldpc_dvb_enc_transponse_ctrl__oashift ;
  logic [pSHIFT_W-1 : 0] ldpc_dvb_enc_transponse_ctrl__otshift ;



  ldpc_dvb_enc_transponse_ctrl
  #(
    .pDAT_W    ( pDAT_W    ) ,
    .pTR_DAT_W ( pTR_DAT_W ) ,
    //
    .pROW_W    ( pROW_W    ) ,
    .pSEL_W    ( pSEL_W    ) ,
    .pSHIFT_W  ( pSHIFT_W  )
  )
  ldpc_dvb_enc_transponse_ctrl
  (
    .iclk    ( ldpc_dvb_enc_transponse_ctrl__iclk    ) ,
    .ireset  ( ldpc_dvb_enc_transponse_ctrl__ireset  ) ,
    .iclkena ( ldpc_dvb_enc_transponse_ctrl__iclkena ) ,
    //
    .iwrow   ( ldpc_dvb_enc_transponse_ctrl__iwrow   ) ,
    .iwfull  ( ldpc_dvb_enc_transponse_ctrl__iwfull  ) ,
    .ordy    ( ldpc_dvb_enc_transponse_ctrl__ordy    ) ,
    //
    .ibusy   ( ldpc_dvb_enc_transponse_ctrl__ibusy   ) ,
    .odone   ( ldpc_dvb_enc_transponse_ctrl__odone   ) ,
    //
    .otrow   ( ldpc_dvb_enc_transponse_ctrl__otrow   ) ,
    .otsel   ( ldpc_dvb_enc_transponse_ctrl__otsel   ) ,
    //
    .oval    ( ldpc_dvb_enc_transponse_ctrl__oval    ) ,
    .oload   ( ldpc_dvb_enc_transponse_ctrl__oload   ) ,
    .owrite  ( ldpc_dvb_enc_transponse_ctrl__owrite  ) ,
    .oashift ( ldpc_dvb_enc_transponse_ctrl__oashift ) ,
    .otshift ( ldpc_dvb_enc_transponse_ctrl__otshift )
  );


  assign ldpc_dvb_enc_transponse_ctrl__iclk    = '0 ;
  assign ldpc_dvb_enc_transponse_ctrl__ireset  = '0 ;
  assign ldpc_dvb_enc_transponse_ctrl__iclkena = '0 ;
  assign ldpc_dvb_enc_transponse_ctrl__iwrow   = '0 ;
  assign ldpc_dvb_enc_transponse_ctrl__iwfull  = '0 ;
  assign ldpc_dvb_enc_transponse_ctrl__ibusy   = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_transponse_ctrl.sv
// Description   : transponse {row x pDAT_W} parity bits matrix controller
//

module ldpc_dvb_enc_transponse_ctrl
#(
  parameter int pDAT_W    = 360 ,
  parameter int pTR_DAT_W =   8 , // transponse dat_w, only 2^N (N = [1:6]) support
  //
  parameter int pROW_W    =   8 ,
  parameter int pSEL_W    =   9 ,
  parameter int pSHIFT_W  =   8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrow   ,
  iwfull  ,
  ordy    ,
  //
  ibusy   ,
  odone   ,
  //
  otrow   ,
  otsel   ,
  //
  oval    ,
  oload   ,
  owrite  ,
  oashift ,
  otshift
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk    ;
  input  logic                  ireset  ;
  input  logic                  iclkena ;
  // context
  input  logic   [pROW_W-1 : 0] iwrow   ;
  input  logic                  iwfull  ;
  output logic                  ordy    ;
  // system control
  input  logic                  ibusy   ;
  output logic                  odone   ;
  // ram read control
  output logic   [pROW_W-1 : 0] otrow   ;
  output logic   [pSEL_W-1 : 0] otsel   ;
  // accumulator control
  output logic                  oval    ;
  output logic                  oload   ;
  output logic                  owrite  ;
  output logic [pSHIFT_W-1 : 0] oashift ;
  output logic [pSHIFT_W-1 : 0] otshift ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_TR_DAT_W = $clog2(pTR_DAT_W);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE      ,
    //
    cWAIT_STATE       ,
    //
    cINIT_STATE       ,
    cDO_STATE         ,
    //
    cWAIT_NBUSY_STATE ,
    cDONE_STATE       ,
    //
    cRES0_STATE       ,
    cRES1_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  logic [pROW_W-1 : 0] max_row_m2;
  logic                single_row;
  logic                last_row_unfull;

  struct packed {
    logic                done;
    logic [pSEL_W-1 : 0] value;
  } tsel_cnt;

  struct packed {
    logic                done;
    logic [pSEL_W-1 : 0] value;
  } trow_cnt;

  logic [pSHIFT_W-1 : 0] bitnum;
  logic [pSHIFT_W-1 : 0] bitnum_last;

  logic                  do_twice_shift;
  logic                  do_tshift;
  logic                  do_write;

  logic     [pSEL_W : 0] new_sel;   // + 1 bit for signum
  logic     [pSEL_W : 0] new_sel_m1;

  logic [pSHIFT_W-1 : 0] ashift;
  logic [pSHIFT_W-1 : 0] tshift;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire work_done = tsel_cnt.done & trow_cnt.done;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE      : state <= cWAIT_STATE;
        //
        cWAIT_STATE       : state <= iwfull     ? cINIT_STATE       : cWAIT_STATE;
        //
        cINIT_STATE       : state <= cDO_STATE;
        //
        cDO_STATE         : state <= work_done  ? cWAIT_NBUSY_STATE : cDO_STATE;
        //
        cWAIT_NBUSY_STATE : state <= ibusy      ? cWAIT_NBUSY_STATE : cDONE_STATE;
        //
        cDONE_STATE       : state <= cWAIT_STATE;
        //
        cRES0_STATE       : state <= cRESET_STATE;
        cRES1_STATE       : state <= cRESET_STATE;
        default           : state <= cRESET_STATE;
      endcase
    end
  end

  assign ordy  = (state == cWAIT_STATE);
//assign odone = (state == cDONE_STATE);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      odone <= 1'b0;
    end
    else if (iclkena) begin
      odone <= (state == cWAIT_NBUSY_STATE) & !ibusy;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cRESET_STATE : begin
          tsel_cnt <= '0;
          trow_cnt <= '0;
        end
        //
        cWAIT_STATE : begin
          max_row_m2      <= (iwrow >> cLOG2_TR_DAT_W) + (iwrow[cLOG2_TR_DAT_W-1 : 0] != 0) - 2;
          single_row      <= (iwrow <= pTR_DAT_W);
          last_row_unfull <= (iwrow[cLOG2_TR_DAT_W-1 : 0] != 0);
          //
          bitnum_last     <=  iwrow[cLOG2_TR_DAT_W-1 : 0];
        end
        //
        cINIT_STATE : begin
          tsel_cnt      <= '0;
          trow_cnt      <= '0;
          trow_cnt.done <= single_row;
        end
        //
        cDO_STATE : begin
          if (!do_twice_shift) begin
            trow_cnt.value <= trow_cnt.done ? '0 : (trow_cnt.value + 1'b1);
            trow_cnt.done  <= single_row | (trow_cnt.value == max_row_m2);
            //
            if (trow_cnt.done) begin
              tsel_cnt.value <= tsel_cnt.value + 1'b1;
              tsel_cnt.done  <= (tsel_cnt.value == (pDAT_W-2));
            end
          end
        end
        //
        default : begin end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM decode transponse
  //------------------------------------------------------------------------------------------------------

  assign bitnum         = (trow_cnt.done & last_row_unfull) ? bitnum_last : pTR_DAT_W;

  assign do_twice_shift = new_sel[$high(new_sel)];
  assign do_write       = new_sel[$high(new_sel)] | new_sel_m1[$high(new_sel_m1)];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cINIT_STATE : begin
          new_sel    <= pDAT_W;
          new_sel_m1 <= pDAT_W-1;
        end
        cDO_STATE : begin
          if (do_twice_shift) begin // do pause
            new_sel    <= pDAT_W + new_sel;
            new_sel_m1 <= pDAT_W + new_sel_m1;
          end
          else if (do_write) begin
            new_sel    <= pDAT_W + new_sel    - bitnum;
            new_sel_m1 <= pDAT_W + new_sel_m1 - bitnum;
          end
          else begin
            new_sel    <= new_sel     - bitnum;
            new_sel_m1 <= new_sel_m1  - bitnum;
          end
        end
        default : begin
          new_sel    <= pDAT_W;
          new_sel_m1 <= pDAT_W-1;
        end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  logic val;

  // tick before val
  assign otrow = trow_cnt.value;
  assign otsel = tsel_cnt.value;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val    <= 1'b0;
      oval   <= 1'b0;
      owrite <= 1'b0;
    end
    else if (iclkena) begin
      val    <= (state == cDO_STATE);
      oval   <= val;
      owrite <= val & do_write;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // align do_write offset
      ashift    <= bitnum;
      // delay second phase of do_twice_shift
      do_tshift <= do_twice_shift;
      tshift    <= 0 - new_sel;
      //
      oload     <= !do_tshift;
      oashift   <= !do_twice_shift ? ashift : (ashift + new_sel);
      otshift   <= !do_tshift      ? '0     : tshift;
    end
  end

endmodule
