/*




  logic            ccsds_turbo_dec_ctrl__iclk             ;
  logic            ccsds_turbo_dec_ctrl__ireset           ;
  logic            ccsds_turbo_dec_ctrl__iclkena          ;
  ptab_dat_t       ccsds_turbo_dec_ctrl__iN               ;
  logic    [7 : 0] ccsds_turbo_dec_ctrl__iNiter           ;
  logic            ccsds_turbo_dec_ctrl__ibuf_full        ;
  logic            ccsds_turbo_dec_ctrl__obuf_rempty      ;
  logic            ccsds_turbo_dec_ctrl__iobuf_empty      ;
  logic            ccsds_turbo_dec_ctrl__oaddr_pmode      ;
  logic            ccsds_turbo_dec_ctrl__oaddr_ftmode     ;
  logic            ccsds_turbo_dec_ctrl__oaddr_btmode     ;
  logic            ccsds_turbo_dec_ctrl__oaddr_clear      ;
  logic            ccsds_turbo_dec_ctrl__oaddr_enable     ;
  logic            ccsds_turbo_dec_ctrl__ofirst_sub_stage ;
  logic            ccsds_turbo_dec_ctrl__olast_sub_stage  ;
  logic            ccsds_turbo_dec_ctrl__oeven_sub_stage  ;
  logic            ccsds_turbo_dec_ctrl__osub_stage_warm  ;
  logic            ccsds_turbo_dec_ctrl__idec_eop         ;
  logic            ccsds_turbo_dec_ctrl__odec_sop         ;
  logic            ccsds_turbo_dec_ctrl__odec_val         ;
  logic            ccsds_turbo_dec_ctrl__odec_eop         ;



  ccsds_turbo_dec_ctrl
  ccsds_turbo_dec_ctrl
  (
    .iclk             ( ccsds_turbo_dec_ctrl__iclk             ) ,
    .ireset           ( ccsds_turbo_dec_ctrl__ireset           ) ,
    .iclkena          ( ccsds_turbo_dec_ctrl__iclkena          ) ,
    .iN               ( ccsds_turbo_dec_ctrl__iN               ) ,
    .iNiter           ( ccsds_turbo_dec_ctrl__iNiter           ) ,
    .ibuf_full        ( ccsds_turbo_dec_ctrl__ibuf_full        ) ,
    .obuf_rempty      ( ccsds_turbo_dec_ctrl__obuf_rempty      ) ,
    .iobuf_empty      ( ccsds_turbo_dec_ctrl__iobuf_empty      ) ,
    .oaddr_pmode      ( ccsds_turbo_dec_ctrl__oaddr_pmode      ) ,
    .oaddr_ftmode     ( ccsds_turbo_dec_ctrl__oaddr_ftmode     ) ,
    .oaddr_btmode     ( ccsds_turbo_dec_ctrl__oaddr_btmode     ) ,
    .oaddr_clear      ( ccsds_turbo_dec_ctrl__oaddr_clear      ) ,
    .oaddr_enable     ( ccsds_turbo_dec_ctrl__oaddr_enable     ) ,
    .ofirst_sub_stage ( ccsds_turbo_dec_ctrl__ofirst_sub_stage ) ,
    .olast_sub_stage  ( ccsds_turbo_dec_ctrl__olast_sub_stage  ) ,
    .oeven_sub_stage  ( ccsds_turbo_dec_ctrl__oeven_sub_stage  ) ,
    .osub_stage_warm  ( ccsds_turbo_dec_ctrl__osub_stage_warm  ) ,
    .idec_eop         ( ccsds_turbo_dec_ctrl__idec_eop         ) ,
    .odec_sop         ( ccsds_turbo_dec_ctrl__odec_sop         ) ,
    .odec_val         ( ccsds_turbo_dec_ctrl__odec_val         ) ,
    .odec_eop         ( ccsds_turbo_dec_ctrl__odec_eop         )
  );


  assign ccsds_turbo_dec_ctrl__iclk        = '0 ;
  assign ccsds_turbo_dec_ctrl__ireset      = '0 ;
  assign ccsds_turbo_dec_ctrl__iclkena     = '0 ;
  assign ccsds_turbo_dec_ctrl__iN          = '0 ;
  assign ccsds_turbo_dec_ctrl__iNiter      = '0 ;
  assign ccsds_turbo_dec_ctrl__ibuf_full   = '0 ;
  assign ccsds_turbo_dec_ctrl__iobuf_empty = '0 ;
  assign ccsds_turbo_dec_ctrl__idec_eop    = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_ctrl.sv
// Description   : main decoder controller. Generate control signals for sequential decoding iterations
//

module ccsds_turbo_dec_ctrl
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
  oaddr_ftmode      ,
  oaddr_btmode      ,
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

  `include "../ccsds_turbo_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk             ;
  input  logic            ireset           ;
  input  logic            iclkena          ;
  //
  input  ptab_dat_t       iN               ;
  input  logic    [7 : 0] iNiter           ;
  //
  input  logic            ibuf_full        ;  // input buffer is full
  output logic            obuf_rempty      ;  // set input buffer empty
  input  logic            iobuf_empty      ;  // output buffer is empty
  //
  output logic            oaddr_pmode      ;
  output logic            oaddr_ftmode     ;  // fowrard pass trellis termination
  output logic            oaddr_btmode     ;  // backward pass trellis termination
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

    cINIT_STAGE_STATE   ,

    cINIT_STATE         ,
    cWARM_STATE         ,
    cHOT_STATE          ,
    cWAIT_RSLT_STATE    ,

    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  struct packed {
    ptab_dat_t cnt;
    logic      moreNby2;
    logic      less4;
    logic      done;
    logic      zero;
  } sub_stage;

  struct packed {
    logic [8 : 0] cnt;  // +1 bit for even/odd
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

  assign oaddr_ftmode     = (state == cHOT_STATE ) & sub_stage.moreNby2;  // do at end of trellis (end of forward)
  assign oaddr_btmode     = (state == cWARM_STATE) & sub_stage.less4;     // do at end of trellis (start of back)

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

  logic [cW-1 : 1] num_p4_by2_m2 ;
  logic [cW-1 : 1] num_by2_m4 ;
  logic    [7 : 0] iter_m1 ;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cINIT_STAGE_STATE) begin
        stage.cnt   <= '0;
        stage.zero  <= 1'b1;
        stage.done  <= 1'b0;
        //
        num_by2_m4    <= iN[cW-1 : 1] - 4; //       N/2 - 4
        num_p4_by2_m2 <= iN[cW-1 : 1];     // (N + 4)/2 - 2
        iter_m1       <= iNiter - 1'b1;
      end
      else if (state == cWAIT_RSLT_STATE & idec_eop) begin
        stage.cnt   <= stage.cnt + 1'b1;
        stage.zero  <= &stage.cnt;
        stage.done  <= !stage.cnt[0] & (stage.cnt[8:1] == iter_m1);  // pipelned decision
      end
      //
      if (state == cINIT_STATE | sub_stage.done) begin
        sub_stage.cnt      <= '0;
        sub_stage.zero     <= 1'b1;
        sub_stage.done     <= 1'b0;
        sub_stage.less4    <= 1'b1;
        sub_stage.moreNby2 <= 1'b0;
      end
      else if (state == cWARM_STATE | state == cHOT_STATE) begin
        sub_stage.cnt      <=  sub_stage.cnt + 1'b1;
        sub_stage.zero     <= &sub_stage.cnt;
        sub_stage.done     <= (sub_stage.cnt == num_p4_by2_m2);
        sub_stage.less4    <= (sub_stage.cnt < 3);
        sub_stage.moreNby2 <= (sub_stage.cnt > num_by2_m4);
      end
    end
  end

endmodule
