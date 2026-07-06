/*



  parameter int pDAT_W  = 6 ;
  parameter int pADDR_W = 8 ;
  parameter int pTAG_W  = 8 ;



  logic                      b_nb_ldpc_enc_source__iclk        ;
  logic                      b_nb_ldpc_enc_source__ireset      ;
  logic                      b_nb_ldpc_enc_source__iclkena     ;
  //
  code_idx_t                 b_nb_ldpc_enc_source__icode_idx   ;
  //
  logic                      b_nb_ldpc_enc_source__isop        ;
  logic                      b_nb_ldpc_enc_source__ival        ;
  logic                      b_nb_ldpc_enc_source__ieop        ;
  logic       [pDAT_W-1 : 0] b_nb_ldpc_enc_source__idat        ;
  logic       [pTAG_W-1 : 0] b_nb_ldpc_enc_source__itag        ;
  //
  logic                      b_nb_ldpc_enc_source__ifulla      ;
  logic                      b_nb_ldpc_enc_source__iemptya     ;
  //
  logic                      b_nb_ldpc_enc_source__ordy        ;
  logic                      b_nb_ldpc_enc_source__obusy       ;
  logic                      b_nb_ldpc_enc_source__osource_err ;
  //
  code_idx_t                 b_nb_ldpc_enc_source__ocode_idx   ;
  //
  logic                      b_nb_ldpc_enc_source__owrite      ;
  logic                      b_nb_ldpc_enc_source__owfull      ;
  logic      [pADDR_W-1 : 0] b_nb_ldpc_enc_source__owaddr      ;
  gf_data_t                  b_nb_ldpc_enc_source__owdat       ;
  logic       [pTAG_W-1 : 0] b_nb_ldpc_enc_source__owtag       ;



  b_nb_ldpc_enc_source
  #(
    .pDAT_W  ( pDAT_W  ) ,
    .pADDR_W ( pADDR_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  b_nb_ldpc_enc_source
  (
    .iclk        ( b_nb_ldpc_enc_source__iclk        ) ,
    .ireset      ( b_nb_ldpc_enc_source__ireset      ) ,
    .iclkena     ( b_nb_ldpc_enc_source__iclkena     ) ,
    //
    .icode_idx   ( b_nb_ldpc_enc_source__icode_idx   ) ,
    //
    .isop        ( b_nb_ldpc_enc_source__isop        ) ,
    .ival        ( b_nb_ldpc_enc_source__ival        ) ,
    .ieop        ( b_nb_ldpc_enc_source__ieop        ) ,
    .idat        ( b_nb_ldpc_enc_source__idat        ) ,
    .itag        ( b_nb_ldpc_enc_source__itag        ) ,
    //
    .ifulla      ( b_nb_ldpc_enc_source__ifulla      ) ,
    .iemptya     ( b_nb_ldpc_enc_source__iemptya     ) ,
    //
    .ordy        ( b_nb_ldpc_enc_source__ordy        ) ,
    .obusy       ( b_nb_ldpc_enc_source__obusy       ) ,
    .osource_err ( b_nb_ldpc_enc_source__osource_err ) ,
    //
    .ocode_idx   ( b_nb_ldpc_enc_source__ocode_idx   ) ,
    //
    .owrite      ( b_nb_ldpc_enc_source__owrite      ) ,
    .owfull      ( b_nb_ldpc_enc_source__owfull      ) ,
    .owaddr      ( b_nb_ldpc_enc_source__owaddr      ) ,
    .owdat       ( b_nb_ldpc_enc_source__owdat       ) ,
    .owtag       ( b_nb_ldpc_enc_source__owtag       )
  );


  assign b_nb_ldpc_enc_source__iclk      = '0 ;
  assign b_nb_ldpc_enc_source__ireset    = '0 ;
  assign b_nb_ldpc_enc_source__iclkena   = '0 ;
  assign b_nb_ldpc_enc_source__icode_idx = '0 ;
  assign b_nb_ldpc_enc_source__isop      = '0 ;
  assign b_nb_ldpc_enc_source__ival      = '0 ;
  assign b_nb_ldpc_enc_source__ieop      = '0 ;
  assign b_nb_ldpc_enc_source__idat      = '0 ;
  assign b_nb_ldpc_enc_source__itag      = '0 ;
  assign b_nb_ldpc_enc_source__ifulla    = '0 ;
  assign b_nb_ldpc_enc_source__iemptya   = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_enc_source.svh
// Description   : encoder source unit with DWC (1->6) option
//

module b_nb_ldpc_enc_source
#(
  parameter int pDAT_W  = 6 ,
  parameter int pADDR_W = 8 ,
  parameter int pTAG_W  = 8
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  icode_idx   ,
  //
  isop        ,
  ival        ,
  ieop        ,
  idat        ,
  itag        ,
  //
  ifulla      ,
  iemptya     ,
  //
  ordy        ,
  obusy       ,
  osource_err ,
  //
  ocode_idx   ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  owtag
);

  `include "b_nb_ldpc_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // synthesis translate_off
  initial begin
    assert (pDAT_W inside {1, 6}) else begin
      $fatal("unsupported data width = %0d", pDAT_W);
    end
  end
  // synthesis translate_on

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                      iclk        ;
  input  logic                      ireset      ;
  input  logic                      iclkena     ;
  //
  input  code_idx_t                 icode_idx   ;
  //
  input  logic                      isop        ;
  input  logic                      ival        ;
  input  logic                      ieop        ;
  input  logic       [pDAT_W-1 : 0] idat        ;
  input  logic       [pTAG_W-1 : 0] itag        ;
  //
  input  logic                      ifulla      ;
  input  logic                      iemptya     ;
  //
  output logic                      ordy        ;
  output logic                      obusy       ;
  output logic                      osource_err ;
  //
  output code_idx_t                 ocode_idx   ;
  //
  output logic                      owrite      ;
  output logic                      owfull      ;
  output logic      [pADDR_W-1 : 0] owaddr      ;
  output gf_data_t                  owdat       ;
  output logic       [pTAG_W-1 : 0] owtag       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_MAX = 6;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  struct packed {
    logic         done;
    logic [2 : 0] value;
  } cnt;

  logic sop;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owfull <= 1'b0;
    end
    else if (iclkena) begin
      owfull <= ival & ieop;
    end
  end

  generate
    if (pDAT_W == 6) begin : direct_logic
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          owrite <= 1'b0;
        end
        else if (iclkena) begin
          owrite <= ival;
        end
      end
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          owdat <= idat;
          if (ival) begin
            owaddr <= isop ? '0 : (owaddr + 1'b1);
          end
        end
      end
    end
    else begin : dwc_logic
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          owrite <= 1'b0;
        end
        else if (iclkena) begin
          owrite <= ival & !isop & cnt.done;
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (ival) begin
            if (isop) begin
              cnt <= 1'b1;  // look ahead
            end
            else begin
              cnt.value <=  cnt.done ? '0 : (cnt.value + 1'b1);
              cnt.done  <= (cnt.value == (cCNT_MAX-2));
            end
            //
            owdat <= (owdat << 1) | idat;  // msb first
            if (ival) begin
              owaddr <= isop ? '1 : (owaddr + cnt.done);  // look before
            end
          end
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // context hold & frame error detection
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival & isop) begin
        owtag     <= itag;
        ocode_idx <= icode_idx;
      end
      //
      sop         <= isop;
      osource_err <= owfull & !sop & (owaddr != (cROW_TAB[ocode_idx]-1));
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ordy  = !owfull & !ifulla;   // not ready if all buffers is full
  assign obusy =  owfull | !iemptya;  // busy if any buffer is not empty

endmodule
