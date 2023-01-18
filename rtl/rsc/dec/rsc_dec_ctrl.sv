/*



  parameter int pW  = 13 ;



  logic            rsc_dec_ctrl__iclk             ;
  logic            rsc_dec_ctrl__ireset           ;
  logic            rsc_dec_ctrl__iclkena          ;
  logic [pW-1 : 0] rsc_dec_ctrl__iN               ;
  logic    [3 : 0] rsc_dec_ctrl__iNiter           ;
  logic            rsc_dec_ctrl__ibuf_full        ;
  logic            rsc_dec_ctrl__obuf_rempty      ;
  logic            rsc_dec_ctrl__iobuf_empty      ;
  logic            rsc_dec_ctrl__oaddr_pmode      ;
  logic            rsc_dec_ctrl__oaddr_clear      ;
  logic            rsc_dec_ctrl__oaddr_enable     ;
  logic            rsc_dec_ctrl__ofirst_sub_stage ;
  logic            rsc_dec_ctrl__olast_sub_stage  ;
  logic            rsc_dec_ctrl__oeven_sub_stage  ;
  logic            rsc_dec_ctrl__osub_stage_warm  ;
  logic            rsc_dec_ctrl__idec_eop         ;
  logic            rsc_dec_ctrl__odec_sop         ;
  logic            rsc_dec_ctrl__odec_val         ;
  logic            rsc_dec_ctrl__odec_eop         ;



  rsc_dec_ctrl
  #(
    .pW ( pW )
  )
  rsc_dec_ctrl
  (
    .iclk             ( rsc_dec_ctrl__iclk             ) ,
    .ireset           ( rsc_dec_ctrl__ireset           ) ,
    .iclkena          ( rsc_dec_ctrl__iclkena          ) ,
    .iN               ( rsc_dec_ctrl__iN               ) ,
    .iNiter           ( rsc_dec_ctrl__iNiter           ) ,
    .ibuf_full        ( rsc_dec_ctrl__ibuf_full        ) ,
    .obuf_rempty      ( rsc_dec_ctrl__obuf_rempty      ) ,
    .iobuf_empty      ( rsc_dec_ctrl__iobuf_empty      ) ,
    .oaddr_pmode      ( rsc_dec_ctrl__oaddr_pmode      ) ,
    .oaddr_clear      ( rsc_dec_ctrl__oaddr_clear      ) ,
    .oaddr_enable     ( rsc_dec_ctrl__oaddr_enable     ) ,
    .ofirst_sub_stage ( rsc_dec_ctrl__ofirst_sub_stage ) ,
    .olast_sub_stage  ( rsc_dec_ctrl__olast_sub_stage  ) ,
    .oeven_sub_stage  ( rsc_dec_ctrl__oeven_sub_stage  ) ,
    .osub_stage_warm  ( rsc_dec_ctrl__osub_stage_warm  ) ,
    .idec_eop         ( rsc_dec_ctrl__idec_eop         ) ,
    .odec_sop         ( rsc_dec_ctrl__odec_sop         ) ,
    .odec_val         ( rsc_dec_ctrl__odec_val         ) ,
    .odec_eop         ( rsc_dec_ctrl__odec_eop         )
  );


  assign rsc_dec_ctrl__iclk        = '0 ;
  assign rsc_dec_ctrl__ireset      = '0 ;
  assign rsc_dec_ctrl__iclkena     = '0 ;
  assign rsc_dec_ctrl__iN          = '0 ;
  assign rsc_dec_ctrl__iNiter      = '0 ;
  assign rsc_dec_ctrl__ibuf_full   = '0 ;
  assign rsc_dec_ctrl__iobuf_empty = '0 ;
  assign rsc_dec_ctrl__idec_eop    = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_ctrl.sv
// Description   : main decoder controller. Generate control signals for sequential decoding iterations
//

module rsc_dec_ctrl
#(
  parameter int pW  = 13  // don't change
)
(
  iclk              ,
  ireset            ,
  iclkena           ,
  //
  iN                ,
  iNiter            ,
  //
  ibuf_full         ,
  obuf_rempty       ,
  iobuf_empty       ,
  //
  oaddr_pmode       ,
  oaddr_clear       ,
  oaddr_enable      ,
  //
  ofirst_sub_stage  ,
  olast_sub_stage   ,
  oeven_sub_stage   ,
  osub_stage_warm   ,
  //
  idec_eop          ,
  odec_sop          ,
  odec_val          ,
  odec_eop
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk             ;
  input  logic            ireset           ;
  input  logic            iclkena          ;
  //
  input  logic [pW-1 : 0] iN               ;
  input  logic    [3 : 0] iNiter           ;
  //
  input  logic            ibuf_full        ;  // input buffer is full
  output logic            obuf_rempty      ;  // set input buffer empty
  input  logic            iobuf_empty      ;  // output buffer is empty
  //
  output logic            oaddr_pmode      ;
  output logic            oaddr_clear      ;
  output logic            oaddr_enable     ;
  //
  output logic            ofirst_sub_stage ;
  output logic            olast_sub_stage  ;
  output logic            oeven_sub_stage  ;
  output logic            osub_stage_warm  ;
  //
  input  logic            idec_eop         ;
  output logic            odec_sop         ;
  output logic            odec_val         ;
  output logic            odec_eop         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE        ,
    cWAIT_STATE         ,
    //
    cINIT_STAGE_STATE   ,
    //
    cINIT_STATE         ,
    cWARM_STATE         ,
    cHOT_STATE          ,
    cWAIT_RSLT_STATE    ,
    //
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  struct packed {
    logic [pW-1 : 0] cnt;
    logic            zero, done;
  } sub_stage;

  struct packed {
    logic [4 : 0] cnt;  // +1 bit for even/odd
    logic         done;
    logic         zero;
  } stage;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE      : state <= ibuf_full ? cWAIT_STATE : cRESET_STATE;  // wait 1 tick to implement new parameters
        cWAIT_STATE       : state <= cINIT_STAGE_STATE;                       // wait 1 tick to implement new parameters
        cINIT_STAGE_STATE : state <= cINIT_STATE;                             // wait 1 tick to implement paddr gen parameters
        //
        cINIT_STATE       : state <= (stage.done ? iobuf_empty : 1'b1) ? cWARM_STATE      : cINIT_STATE;
        cWARM_STATE       : state <= sub_stage.done                    ? cHOT_STATE       : cWARM_STATE;
        cHOT_STATE        : state <= sub_stage.done                    ? cWAIT_RSLT_STATE : cHOT_STATE;
        cWAIT_RSLT_STATE  : state <= idec_eop ? (stage.done ? cDONE_STATE : cINIT_STATE)  : cWAIT_RSLT_STATE;
        //
        cDONE_STATE       : state <= cRESET_STATE;
      endcase
    end
  end

  assign oaddr_pmode      = stage.cnt[0]; // permutate odd sub iterations

  assign oaddr_clear      = (state == cINIT_STATE);
  assign oaddr_enable     = (state == cWARM_STATE) | (state == cHOT_STATE);

  assign ofirst_sub_stage = stage.zero;
  assign olast_sub_stage  = stage.done;
  assign oeven_sub_stage  = !stage.cnt[0];
  assign osub_stage_warm  = (state == cWARM_STATE);

  assign odec_sop         = (state == cWARM_STATE) & sub_stage.zero;
  assign odec_val         = (state == cWARM_STATE) | (state == cHOT_STATE);
  assign odec_eop         = (state == cHOT_STATE)  & sub_stage.done;

  assign obuf_rempty      = (state == cDONE_STATE);

  //------------------------------------------------------------------------------------------------------
  // counters
  //------------------------------------------------------------------------------------------------------

  logic [pW-1 : 1] num_by2_m2 ;
  logic    [3 : 0] iter_m1 ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cINIT_STAGE_STATE) begin
        stage.cnt   <= '0;
        stage.zero  <= 1'b1;
        stage.done  <= 1'b0;
        //
        num_by2_m2  <= iN[pW-1 : 1] - 2'd2;
        iter_m1     <= iNiter - 1'b1;
      end
      else if (state == cWAIT_RSLT_STATE & idec_eop) begin
        stage.cnt   <= stage.cnt + 1'b1;
        stage.zero  <= &stage.cnt;
        stage.done  <= !stage.cnt[0] & (stage.cnt[4:1] == iter_m1);  // pipelned decision
      end
      //
      if (state == cINIT_STATE | sub_stage.done) begin
        sub_stage.cnt   <= '0;
        sub_stage.zero  <= 1'b1;
        sub_stage.done  <= 1'b0;
      end
      else if (state == cWARM_STATE | state == cHOT_STATE) begin
        sub_stage.cnt  <=  sub_stage.cnt + 1'b1;
        sub_stage.zero <= &sub_stage.cnt;
        sub_stage.done <= (sub_stage.cnt == num_by2_m2);
      end
    end
  end

endmodule
