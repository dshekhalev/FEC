/*



  logic            ccsds_turbo_enc_ctrl__iclk         ;
  logic            ccsds_turbo_enc_ctrl__ireset       ;
  logic            ccsds_turbo_enc_ctrl__iclkena      ;
  logic    [1 : 0] ccsds_turbo_enc_ctrl__icode        ;
  ptab_dat_t       ccsds_turbo_enc_ctrl__iN           ;
  logic            ccsds_turbo_enc_ctrl__ifull        ;
  logic            ccsds_turbo_enc_ctrl__orempty      ;
  logic            ccsds_turbo_enc_ctrl__oaddr_clear  ;
  logic            ccsds_turbo_enc_ctrl__oaddr_enable ;
  logic            ccsds_turbo_enc_ctrl__osop         ;
  logic            ccsds_turbo_enc_ctrl__oeop         ;
  logic            ccsds_turbo_enc_ctrl__oval         ;
  logic            ccsds_turbo_enc_ctrl__oterm        ;



  ccsds_turbo_enc_ctrl
  ccsds_turbo_enc_ctrl
  (
    .iclk         ( ccsds_turbo_enc_ctrl__iclk         ) ,
    .ireset       ( ccsds_turbo_enc_ctrl__ireset       ) ,
    .iclkena      ( ccsds_turbo_enc_ctrl__iclkena      ) ,
    .icode        ( ccsds_turbo_enc_ctrl__icode        ) ,
    .iN           ( ccsds_turbo_enc_ctrl__iN           ) ,
    .ifull        ( ccsds_turbo_enc_ctrl__ifull        ) ,
    .orempty      ( ccsds_turbo_enc_ctrl__orempty      ) ,
    .oaddr_clear  ( ccsds_turbo_enc_ctrl__oaddr_clear  ) ,
    .oaddr_enable ( ccsds_turbo_enc_ctrl__oaddr_enable ) ,
    .osop         ( ccsds_turbo_enc_ctrl__osop         ) ,
    .oeop         ( ccsds_turbo_enc_ctrl__oeop         ) ,
    .oval         ( ccsds_turbo_enc_ctrl__oval         ) ,
    .oval         ( ccsds_turbo_enc_ctrl__oterm        )
  );


  assign ccsds_turbo_enc_ctrl__iclk    = '0 ;
  assign ccsds_turbo_enc_ctrl__ireset  = '0 ;
  assign ccsds_turbo_enc_ctrl__iclkena = '0 ;
  assign ccsds_turbo_enc_ctrl__icode   = '0 ;
  assign ccsds_turbo_enc_ctrl__iN      = '0 ;
  assign ccsds_turbo_enc_ctrl__ifull   = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_enc.sv
// Description   : ccsds_turbo encoder controller. Generate control signal sequence for encoding process
//

module ccsds_turbo_enc_ctrl
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  icode        ,
  iN           ,
  //
  ifull        ,
  orempty      ,
  //
  oaddr_clear  ,
  oaddr_enable ,
  //
  osop         ,
  oeop         ,
  oval         ,
  oterm
);

  `include "../ccsds_turbo_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk          ;
  input  logic            ireset        ;
  input  logic            iclkena       ;
  // code parameters
  input  logic    [1 : 0] icode         ;
  input  ptab_dat_t       iN            ;
  // input buffer control
  input  logic            ifull         ;
  output logic            orempty       ;
  // addr generator control
  output logic            oaddr_clear   ;
  output logic            oaddr_enable  ;
  // engine control
  output logic            osop          ;
  output logic            oeop          ;
  output logic            oval          ;
  output logic            oterm         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE     ,
    //
    cWAIT_STATE      ,
    //
    cWAIT_PTAB_STATE ,
    //
    cINIT_STATE      ,
    //
    cDO_DATA_STATE   ,
    //
    cDO_TERM_STATE   ,
    //
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  ptab_dat_t num_m2;

  struct packed {
    logic      zero;
    logic      done;
    ptab_dat_t val;
  } data_cnt;

  struct packed {
    logic [2 : 0] val;
    logic         zero;
    logic         done;
  } code_cnt;

  struct packed {
    logic [1 : 0] val;
    logic         zero;
    logic         done;
  } term_cnt;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE     : state <= cWAIT_STATE;
        //
        cWAIT_STATE      : state <= ifull ? cWAIT_PTAB_STATE : cWAIT_STATE;
        //
        cWAIT_PTAB_STATE : state <= cINIT_STATE;
        //
        cINIT_STATE      : state <= cDO_DATA_STATE;
        //
        cDO_DATA_STATE   : state <= (data_cnt.done & code_cnt.done) ? cDO_TERM_STATE : cDO_DATA_STATE;
        //
        cDO_TERM_STATE   : state <= (term_cnt.done & code_cnt.done) ? cDONE_STATE    : cDO_TERM_STATE;
        //
        cDONE_STATE      : state <= cWAIT_STATE;
      endcase
    end
  end

  assign orempty      = (state == cDONE_STATE);

  assign oaddr_clear  = (state == cINIT_STATE);
  assign oaddr_enable = ((state == cDO_DATA_STATE) | (state == cDO_TERM_STATE)) & code_cnt.zero ;

  assign osop         = oaddr_enable & data_cnt.zero;
  assign oval         = oaddr_enable;
  assign oeop         = oaddr_enable & term_cnt.done;
  assign oterm        = (state == cDO_TERM_STATE);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cINIT_STATE) begin
        data_cnt      <= '0;
        data_cnt.zero <= 1'b1;
        //
        code_cnt      <= '0;
        code_cnt.zero <= 1'b1;
        //
        term_cnt      <= '0;
        term_cnt.zero <= 1'b1;
        //
        num_m2        <= iN-2;
      end
      else if (state == cDO_DATA_STATE | state == cDO_TERM_STATE) begin
        code_cnt.val  <=  code_cnt.done ? '0 : (code_cnt.val + 1'b1);
        code_cnt.zero <=  code_cnt.done;
        code_cnt.done <= (code_cnt.val == get_code_cnt_max(icode));
        //
        if (state == cDO_DATA_STATE) begin
          if (code_cnt.done) begin
            data_cnt.val  <= data_cnt.done ? '0 : (data_cnt.val + 1'b1);
            data_cnt.zero <= &data_cnt.val;
            data_cnt.done <= (data_cnt.val == num_m2);
          end
        end
        //
        if (state == cDO_TERM_STATE) begin
          if (code_cnt.done) begin
            term_cnt.val  <= term_cnt.done ? '0 : (term_cnt.val + 1'b1);
            term_cnt.zero <= &term_cnt.val;
            term_cnt.done <= (term_cnt.val == 2);
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function int get_code_cnt_max (input bit [1 : 0] code);
    get_code_cnt_max = 0; // 2-2
    case (code)
       cCODE_1by2 : get_code_cnt_max = 0; // 2-2
       cCODE_1by3 : get_code_cnt_max = 1; // 3-2
       cCODE_1by4 : get_code_cnt_max = 2; // 4-2
       cCODE_1by6 : get_code_cnt_max = 4; // 6-2
    endcase
  endfunction

endmodule
