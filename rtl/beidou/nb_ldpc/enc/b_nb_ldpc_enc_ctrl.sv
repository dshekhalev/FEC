/*






  logic       b_nb_ldpc_enc_ctrl__iclk           ;
  logic       b_nb_ldpc_enc_ctrl__ireset         ;
  logic       b_nb_ldpc_enc_ctrl__iclkena        ;
  //
  logic       b_nb_ldpc_enc_ctrl__ibuf_full      ;
  logic       b_nb_ldpc_enc_ctrl__obuf_rempty    ;
  logic       b_nb_ldpc_enc_ctrl__iobuf_empty    ;
  //
  code_idx_t  b_nb_ldpc_enc_ctrl__icode_idx      ;
  //
  row_t       b_nb_ldpc_enc_ctrl__iused_row      ;
  cycle_idx_t b_nb_ldpc_enc_ctrl__icycle_max_num ;
  //
  logic       b_nb_ldpc_enc_ctrl__imac_busy      ;
  logic       b_nb_ldpc_enc_ctrl__imac_done      ;
  //
  code_idx_t  b_nb_ldpc_enc_ctrl__ocode_idx      ;
  logic       b_nb_ldpc_enc_ctrl__odat_n_parity  ;
  //
  logic       b_nb_ldpc_enc_ctrl__ocycle_read    ;
  cycle_idx_t b_nb_ldpc_enc_ctrl__ocycle_idx     ;
  //
  logic       b_nb_ldpc_enc_ctrl__obusy          ;



  b_nb_ldpc_enc_ctrl
  b_nb_ldpc_enc_ctrl
  (
    .iclk           ( b_nb_ldpc_enc_ctrl__iclk           ) ,
    .ireset         ( b_nb_ldpc_enc_ctrl__ireset         ) ,
    .iclkena        ( b_nb_ldpc_enc_ctrl__iclkena        ) ,
    //
    .ibuf_full      ( b_nb_ldpc_enc_ctrl__ibuf_full      ) ,
    .obuf_rempty    ( b_nb_ldpc_enc_ctrl__obuf_rempty    ) ,
    .iobuf_empty    ( b_nb_ldpc_enc_ctrl__iobuf_empty    ) ,
    //
    .icode_idx      ( b_nb_ldpc_enc_ctrl__icode_idx      ) ,
    //
    .iused_row      ( b_nb_ldpc_enc_ctrl__iused_row      ) ,
    .icycle_max_num ( b_nb_ldpc_enc_ctrl__icycle_max_num ) ,
    //
    .imac_busy      ( b_nb_ldpc_enc_ctrl__imac_busy      ) ,
    .imac_done      ( b_nb_ldpc_enc_ctrl__imac_done      ) ,
    //
    .ocode_idx      ( b_nb_ldpc_enc_ctrl__ocode_idx      ) ,
    .odat_n_parity  ( b_nb_ldpc_enc_ctrl__odat_n_parity  ) ,
    //
    .ocycle_read    ( b_nb_ldpc_enc_ctrl__ocycle_read    ) ,
    .ocycle_idx     ( b_nb_ldpc_enc_ctrl__ocycle_idx     ) ,
    //
    .obusy          ( b_nb_ldpc_enc_ctrl__obusy          )
  );


  assign b_nb_ldpc_enc_ctrl__iclk           = '0 ;
  assign b_nb_ldpc_enc_ctrl__ireset         = '0 ;
  assign b_nb_ldpc_enc_ctrl__iclkena        = '0 ;
  assign b_nb_ldpc_enc_ctrl__ibuf_full      = '0 ;
  assign b_nb_ldpc_enc_ctrl__iobuf_empty    = '0 ;
  assign b_nb_ldpc_enc_ctrl__icode_idx      = '0 ;
  assign b_nb_ldpc_enc_ctrl__iused_row      = '0 ;
  assign b_nb_ldpc_enc_ctrl__icycle_max_num = '0 ;
  assign b_nb_ldpc_enc_ctrl__imac_busy      = '0 ;
  assign b_nb_ldpc_enc_ctrl__imac_done      = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_enc_ctrl.svh
// Description   : encoder ctrl
//

module b_nb_ldpc_enc_ctrl
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  ibuf_full      ,
  obuf_rempty    ,
  iobuf_empty    ,
  //
  icode_idx      ,
  //
  iused_row      ,
  icycle_max_num ,
  //
  imac_busy      ,
  imac_done      ,
  //
  ocode_idx      ,
  odat_n_parity  ,
  //
  ocycle_read    ,
  ocycle_idx     ,
  //
  obusy
);

  `include "b_nb_ldpc_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic       iclk           ;
  input  logic       ireset         ;
  input  logic       iclkena        ;
  //
  input  logic       ibuf_full      ;
  output logic       obuf_rempty    ;
  input  logic       iobuf_empty    ;
  //
  input  code_idx_t  icode_idx      ;
  //
  input  row_t       iused_row      ;
  input  cycle_idx_t icycle_max_num ;
  //
  input  logic       imac_busy      ;
  input  logic       imac_done      ;
  //
  output code_idx_t  ocode_idx      ;
  output logic       odat_n_parity  ;
  //
  output logic       ocycle_read    ;
  output cycle_idx_t ocycle_idx     ;
  //
  output logic       obusy          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [2 : 0] {
    cRESET_STATE       ,
    //
    cWAIT_STATE        ,
    cINIT_STATE        ,
    //
    cDATA_STATE        ,
    cWAIT_DATA_STATE   ,
    //
    cPARITY_STATE      ,
    //
    cWAIT_DONE_STATE   ,
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential", fsm_encoding = "sequential" */;

  struct packed {
    logic       done;
    cycle_idx_t value;
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
        cRESET_STATE        : state <= cWAIT_STATE;
        //
        cWAIT_STATE         : state <= (ibuf_full & iobuf_empty)  ? cINIT_STATE       : cWAIT_STATE;
        // decode worked parameters
        cINIT_STATE         : state <= cDATA_STATE;
        // upload data
        cDATA_STATE         : state <= cnt.done                   ? cWAIT_DATA_STATE  : cDATA_STATE;
        cWAIT_DATA_STATE    : state <= imac_busy                  ? cWAIT_DATA_STATE  : cPARITY_STATE;
        // do matrix mult
        cPARITY_STATE       : state <= cnt.done                   ? cWAIT_DONE_STATE  : cPARITY_STATE;
        //
        cWAIT_DONE_STATE    : state <= imac_done                  ? cDONE_STATE       : cWAIT_DONE_STATE;
        //
        cDONE_STATE         : state <= cWAIT_STATE;
      endcase
    end
  end

  assign obusy = (state != cWAIT_STATE);

  //------------------------------------------------------------------------------------------------------
  // FSM counters & decoding
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cWAIT_STATE : begin
          ocode_idx <= icode_idx; // can hold all time
          cnt       <= '0;
        end
        //
        cDATA_STATE : begin
          cnt.value <=  cnt.value + 1'b1;
          cnt.done  <= (cnt.value == (iused_row-2));
        end
        //
        cWAIT_DATA_STATE : begin
          cnt <= '0;
        end
        //
        cPARITY_STATE : begin
          cnt.value <=  cnt.value + 1'b1;
          cnt.done  <= (cnt.value == (icycle_max_num-2));
        end
      endcase
    end
  end

  assign odat_n_parity = (state == cDATA_STATE) | (state == cWAIT_DATA_STATE);
  assign ocycle_read   = (state == cDATA_STATE) | (state == cPARITY_STATE);

  assign ocycle_idx    = cnt.value;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obuf_rempty <= 1'b0;
    end
    else if (iclkena) begin
      obuf_rempty <= (state == cWAIT_DONE_STATE) & imac_done;
    end
  end


endmodule
