/*


  parameter int pLLR_W            =   4 ;
  parameter int pLLR_NUM          =   8 ;
  //
  parameter int pWADDR_W          =   8 ;
  parameter int pWNUM             = 360 ;
  //
  parameter int pZC_FACTOR        =   1 ;
  parameter bit pDO_LLR_INVERSION =   1 ;



  logic                       ldpc_dvb_dec_source__iclk                   ;
  logic                       ldpc_dvb_dec_source__ireset                 ;
  logic                       ldpc_dvb_dec_source__iclkena                ;
  //
  code_ctx_t                  ldpc_dvb_dec_source__icode_ctx              ;
  //
  logic                       ldpc_dvb_dec_source__isop                   ;
  logic                       ldpc_dvb_dec_source__ieop                   ;
  logic                       ldpc_dvb_dec_source__ival                   ;
  llr_t                       ldpc_dvb_dec_source__iLLR        [pLLR_NUM] ;
  //
  logic                       ldpc_dvb_dec_source__obusy                  ;
  logic                       ldpc_dvb_dec_source__ordy                   ;
  //
  logic                       ldpc_dvb_dec_source__iemptya                ;
  logic                       ldpc_dvb_dec_source__ifulla                 ;
  //
  logic    [pZC_FACTOR-1 : 0] ldpc_dvb_dec_source__owrite                 ;
  logic                       ldpc_dvb_dec_source__owfull                 ;
  logic       [pADDR_W-1 : 0] ldpc_dvb_dec_source__owaddr                 ;
  llr_t                       ldpc_dvb_dec_source__owLLR       [pWNUM]    ;



  ldpc_dvb_dec_source
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pLLR_NUM          ( pLLR_NUM          ) ,
    //
    .pWADDR_W          ( pWADDR_W          ) ,
    .pWNUM             ( pWNUM             ) ,
    //
    .pZC_FACTOR        ( pZC_FACTOR        ) ,
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
  )
  ldpc_dvb_dec_source
  (
    .iclk       ( ldpc_dvb_dec_source__iclk      ) ,
    .ireset     ( ldpc_dvb_dec_source__ireset    ) ,
    .iclkena    ( ldpc_dvb_dec_source__iclkena   ) ,
    //
    .icode_ctx  ( ldpc_dvb_dec_source__icode_ctx ) ,
    //
    .isop       ( ldpc_dvb_dec_source__isop      ) ,
    .ieop       ( ldpc_dvb_dec_source__ieop      ) ,
    .ival       ( ldpc_dvb_dec_source__ival      ) ,
    .iLLR       ( ldpc_dvb_dec_source__iLLR      ) ,
    //
    .obusy      ( ldpc_dvb_dec_source__obusy     ) ,
    .ordy       ( ldpc_dvb_dec_source__ordy      ) ,
    //
    .iemptya    ( ldpc_dvb_dec_source__iemptya   ) ,
    .ifulla     ( ldpc_dvb_dec_source__ifulla    ) ,
    //
    .owrite     ( ldpc_dvb_dec_source__owrite    ) ,
    .owfull     ( ldpc_dvb_dec_source__owfull    ) ,
    .owaddr     ( ldpc_dvb_dec_source__owaddr    ) ,
    .owLLR      ( ldpc_dvb_dec_source__owLLR     )
  );


  assign ldpc_dvb_dec_source__iclk      = '0 ;
  assign ldpc_dvb_dec_source__ireset    = '0 ;
  assign ldpc_dvb_dec_source__iclkena   = '0 ;
  //
  assign ldpc_dvb_dec_source__isop      = '0 ;
  assign ldpc_dvb_dec_source__ieop      = '0 ;
  assign ldpc_dvb_dec_source__ival      = '0 ;
  assign ldpc_dvb_dec_source__iLLR      = '0 ;
  //
  assign ldpc_dvb_dec_source__icode_ctx = '0 ;
  //
  assign ldpc_dvb_dec_source__iemptya   = '0 ;
  assign ldpc_dvb_dec_source__ifulla    = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_source.sv
// Description   : Input LLR saturaion and input buffer address generation module
//

module ldpc_dvb_dec_source
#(
  parameter int pLLR_W            =   4 ,
  parameter int pLLR_NUM          =   8 ,
  //
  parameter int pWADDR_W          =  10 , // used to optimize ram resources
  parameter int pWNUM             = 360 ,
  //
  parameter int pZC_FACTOR        =   1 ,
  parameter bit pDO_LLR_INVERSION =   1
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  isop      ,
  ieop      ,
  ival      ,
  iLLR      ,
  //
  obusy     ,
  ordy      ,
  //
  iemptya   ,
  ifulla    ,
  //
  owrite    ,
  owfull    ,
  owaddr    ,
  owLLR
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                         iclk                  ;
  input  logic                         ireset                ;
  input  logic                         iclkena               ;
  //
  input  logic                         isop                  ;
  input  logic                         ieop                  ;
  input  logic                         ival                  ;
  input  logic signed   [pLLR_W-1 : 0] iLLR       [pLLR_NUM] ;
  //
  output logic                         obusy                 ;
  output logic                         ordy                  ;
  // 2D buffer state
  input  logic                         iemptya               ;
  input  logic                         ifulla                ;
  //
  output logic      [pZC_FACTOR-1 : 0] owrite                ;
  output logic                         owfull                ;
  output logic        [pWADDR_W-1 : 0] owaddr                ;
  output logic signed   [pLLR_W-1 : 0] owLLR      [pWNUM]    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDWC_FACTOR = pWNUM/pLLR_NUM;
  localparam int cDWC_CNT_W  = $clog2(cDWC_FACTOR);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  struct packed {
    logic                    done;
    logic [cDWC_CNT_W-1 : 0] value;
  } dwc_cnt;

  logic                    write;
  logic [pZC_FACTOR-1 : 0] wmask;
  logic                    bwrite;

  logic signed [pLLR_W-1 : 0] wLLR [pLLR_NUM] ;

  //------------------------------------------------------------------------------------------------------
  // LLR saturation and invertion
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int llra = 0; llra < pLLR_NUM; llra++) begin
      if (pDO_LLR_INVERSION) begin
        if (&{iLLR[llra][pLLR_W-1], ~iLLR[llra][pLLR_W-2 : 0]}) begin // -2^(N-1)
          wLLR[llra] = {1'b0, {(pLLR_W-2){1'b1}} ,1'b1};   // -(2^(N-1) - 1)
        end
        else begin
          wLLR[llra] = -iLLR[llra];
        end
      end
      else begin
        if (&{iLLR[llra][pLLR_W-1], ~iLLR[llra][pLLR_W-2 : 0]}) begin // -2^(N-1)
          wLLR[llra] = {1'b1, {(pLLR_W-2){1'b0}} ,1'b1};   // -(2^(N-1) - 1)
        end
        else begin
          wLLR[llra] = iLLR[llra];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // DWC logic
  //------------------------------------------------------------------------------------------------------

  generate
    if (cDWC_FACTOR == 1) begin
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          write  <= 1'b0;
          owfull <= 1'b0;
        end
        else if (iclkena) begin
          write  <= ival;
          owfull <= ival & ieop;
        end
      end

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          owLLR  <= wLLR;
          owaddr <= (ival & isop) ? '0 : (owaddr + bwrite);
        end
      end

      if (pZC_FACTOR == 1) begin
        assign owrite = write;
        assign bwrite = write;
      end
      else begin
        assign owrite = {pZC_FACTOR{write}} & wmask;
        assign bwrite = write & wmask[pZC_FACTOR-1];
        //
        always_ff @(posedge iclk) begin
          if (iclkena) begin
            if (ival & isop) begin
              wmask <= 1'b1;
            end
            else if (write) begin
              wmask <= {wmask[pZC_FACTOR-2 : 0], wmask[pZC_FACTOR-1]};
            end
          end // iclkena
        end // iclk
      end // cZC_FACTOR
    end // cDWC_FACTOR
    else begin  // DWC mode. LSB first
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          write  <= 1'b0;
          owfull <= 1'b0;
        end
        else if (iclkena) begin
          write  <= ival & (!isop & dwc_cnt.done);
          owfull <= ival &   ieop;
        end
      end

      assign owrite = {pZC_FACTOR{write}} & wmask;
      assign bwrite = write & wmask[pZC_FACTOR-1];

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (ival) begin
            if (isop) begin
              dwc_cnt.value <= 1'b1;
              dwc_cnt.done  <= (cDWC_FACTOR <= 2);
            end
            else begin
              dwc_cnt.value <= dwc_cnt.done ? '0 : (dwc_cnt.value + 1'b1);
              dwc_cnt.done  <= (dwc_cnt.value == (cDWC_FACTOR-2));
            end
          end
          //
          if (ival & isop) begin
            wmask <= 1'b1;
          end
          else if (write) begin
            wmask <= {wmask[pZC_FACTOR-2 : 0], wmask[pZC_FACTOR-1]};
          end
          //
          if (ival) begin
            for (int llra = 0; llra < pWNUM; llra++) begin
              if (llra >= (pWNUM - pLLR_NUM)) begin
                owLLR[llra] <= wLLR[llra - (pWNUM - pLLR_NUM)];
              end
              else begin
                owLLR[llra] <= owLLR[llra + pLLR_NUM];
              end
            end
          end
          //
          owaddr <= (ival & isop) ? '0 : (owaddr + bwrite);
        end
      end
    end
  endgenerate

  assign ordy  = !owfull & !ifulla;   // not ready if all buffers is full
  assign obusy =  owfull | !iemptya;  // busy if any buffer is not empty

endmodule
