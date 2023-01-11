/*



  parameter int pADDR_W        = 8 ;
  parameter int pLLR_W         = 5 ;
  parameter int pLDPC_NUM      = 1 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;



  logic                        ldpc_dec_source__iclk                    ;
  logic                        ldpc_dec_source__ireset                  ;
  logic                        ldpc_dec_source__iclkena                 ;
  logic                        ldpc_dec_source__isop                    ;
  logic                        ldpc_dec_source__ieop                    ;
  logic                        ldpc_dec_source__ival                    ;
  logic signed  [pLLR_W-1 : 0] ldpc_dec_source__iLLR    [pLLR_BY_CYCLE] ;
  logic                        ldpc_dec_source__obusy                   ;
  logic                        ldpc_dec_source__ordy                    ;
  logic                        ldpc_dec_source__iempty                  ;
  logic                        ldpc_dec_source__iemptya                 ;
  logic                        ldpc_dec_source__ifull                   ;
  logic                        ldpc_dec_source__ifulla                  ;
  logic [pNODE_BY_CYCLE-1 : 0] ldpc_dec_source__owrite                  ;
  logic                        ldpc_dec_source__owfull                  ;
  logic        [pADDR_W-1 : 0] ldpc_dec_source__owaddr                  ;
  logic signed  [pLLR_W-1 : 0] ldpc_dec_source__owLLR   [pLLR_BY_CYCLE] ;



  ldpc_dec_source
  #(
    .pADDR_W        ( pADDR_W        ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLDPC_NUM      ( pLDPC_NUM      ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE )
  )
  ldpc_dec_source
  (
    .iclk    ( ldpc_dec_source__iclk    ) ,
    .ireset  ( ldpc_dec_source__ireset  ) ,
    .iclkena ( ldpc_dec_source__iclkena ) ,
    .isop    ( ldpc_dec_source__isop    ) ,
    .ieop    ( ldpc_dec_source__ieop    ) ,
    .ival    ( ldpc_dec_source__ival    ) ,
    .iLLR    ( ldpc_dec_source__iLLR    ) ,
    .obusy   ( ldpc_dec_source__obusy   ) ,
    .ordy    ( ldpc_dec_source__ordy    ) ,
    .iempty  ( ldpc_dec_source__iempty  ) ,
    .iemptya ( ldpc_dec_source__iemptya ) ,
    .ifull   ( ldpc_dec_source__ifull   ) ,
    .ifulla  ( ldpc_dec_source__ifulla  ) ,
    .owrite  ( ldpc_dec_source__owrite  ) ,
    .owfull  ( ldpc_dec_source__owfull  ) ,
    .owaddr  ( ldpc_dec_source__owaddr  ) ,
    .owLLR   ( ldpc_dec_source__owLLR   )
  );


  assign ldpc_dec_source__iclk    = '0 ;
  assign ldpc_dec_source__ireset  = '0 ;
  assign ldpc_dec_source__iclkena = '0 ;
  assign ldpc_dec_source__isop    = '0 ;
  assign ldpc_dec_source__ieop    = '0 ;
  assign ldpc_dec_source__ival    = '0 ;
  assign ldpc_dec_source__iLLR    = '0 ;
  assign ldpc_dec_source__iempty  = '0 ;
  assign ldpc_dec_source__iemptya = '0 ;
  assign ldpc_dec_source__ifull   = '0 ;
  assign ldpc_dec_source__ifulla  = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_source.sv
// Description   : Input LLR saturaion and input buffer address generation module
//


module ldpc_dec_source
#(
  parameter int pADDR_W        = 8 ,
  parameter int pLDPC_NUM      = 8 ,
  parameter int pLLR_W         = 5 ,
  parameter int pLLR_BY_CYCLE  = 1 ,
  parameter int pNODE_BY_CYCLE = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ieop    ,
  ival    ,
  iLLR    ,
  //
  obusy   ,
  ordy    ,
  //
  iempty  ,
  iemptya ,
  ifull   ,
  ifulla  ,
  //
  owrite  ,
  owfull  ,
  owaddr  ,
  owLLR
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                        iclk                    ;
  input  logic                        ireset                  ;
  input  logic                        iclkena                 ;
  //
  input  logic                        isop                    ;
  input  logic                        ieop                    ;
  input  logic                        ival                    ;
  input  logic signed  [pLLR_W-1 : 0] iLLR    [pLLR_BY_CYCLE] ;
  //
  output logic                        obusy                   ;
  output logic                        ordy                    ;
  // 2D buffer state
  input  logic                        iempty                  ;
  input  logic                        iemptya                 ;
  input  logic                        ifull                   ;
  input  logic                        ifulla                  ;
  //
  output logic [pNODE_BY_CYCLE-1 : 0] owrite                  ;
  output logic                        owfull                  ;
  output logic        [pADDR_W-1 : 0] owaddr                  ;
  output logic signed  [pLLR_W-1 : 0] owLLR   [pLLR_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBLOCK_SIZE  = pLDPC_NUM/(pLLR_BY_CYCLE * pNODE_BY_CYCLE);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                        write;
  logic [pNODE_BY_CYCLE-1 : 0] write_mask;
  logic                        bwrite_done; // bank wrtie done

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      write  <= '0;
      owfull <= '0;
    end
    else if (iclkena) begin
      write  <= ival;
      owfull <= ival & ieop;
    end
  end

  assign owrite = {pNODE_BY_CYCLE{write}} & write_mask;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        for (int i = 0; i < pLLR_BY_CYCLE; i++) begin
          if (&{iLLR[i][pLLR_W-1], ~iLLR[i][pLLR_W-2 : 0]}) begin // -2^(N-1)
            owLLR[i] <= {1'b0, {(pLLR_W-2){1'b1}} ,1'b1};         // -(2^(N-1) - 1)
          end
          else begin
            owLLR[i] <= -iLLR[i];
          end
        end
        //
        owaddr      <= (isop | bwrite_done) ? '0   : (owaddr + 1'b1);
        bwrite_done <=  isop                ? 1'b0 : (owaddr == cBLOCK_SIZE-2);
        //
        if (isop) begin
          write_mask <= 1'b1;
        end
        else if (bwrite_done) begin
          write_mask <= (write_mask << 1);
        end
      end
    end
  end

  assign ordy   = !owfull & !ifulla;  // not ready if all buffers is full
  assign obusy  =  owfull | !iemptya; // busy if any buffer is not empty

endmodule
