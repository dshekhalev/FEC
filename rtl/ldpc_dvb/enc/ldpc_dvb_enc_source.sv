/*



  parameter int pDAT_W     =   8 ;
  //
  parameter int pWADDR_W   =   8 ;
  parameter int pWDAT_W    = 360 ;
  //
  parameter int pZC_FACTOR =   1 ;


  logic                    ldpc_dvb_enc_source__iclk    ;
  logic                    ldpc_dvb_enc_source__ireset  ;
  logic                    ldpc_dvb_enc_source__iclkena ;
  //
  logic                    ldpc_dvb_enc_source__isop    ;
  logic                    ldpc_dvb_enc_source__ieop    ;
  logic                    ldpc_dvb_enc_source__ival    ;
  logic     [pDAT_W-1 : 0] ldpc_dvb_enc_source__idat    ;
  //
  logic                    ldpc_dvb_enc_source__ifulla  ;
  logic                    ldpc_dvb_enc_source__iemptya ;
  //
  logic                    ldpc_dvb_enc_source__ordy    ;
  logic                    ldpc_dvb_enc_source__obusy   ;
  //
  logic [pZC_FACTOR-1 : 0] ldpc_dvb_enc_source__owrite  ;
  logic                    ldpc_dvb_enc_source__owfull  ;
  logic   [pWADDR_W-1 : 0] ldpc_dvb_enc_source__owaddr  ;
  logic    [pWDAT_W-1 : 0] ldpc_dvb_enc_source__owdat   ;



  ldpc_dvb_enc_source
  #(
    .pDAT_W     ( pDAT_W     ) ,
    //
    .pWADDR_W   ( pWADDR_W   ) ,
    .pWDAT_W    ( pWDAT_W    ) ,
    //
    .pZC_FACTOR ( pZC_FACTOR )
  )
  ldpc_dvb_enc_source
  (
    .iclk    ( ldpc_dvb_enc_source__iclk    ) ,
    .ireset  ( ldpc_dvb_enc_source__ireset  ) ,
    .iclkena ( ldpc_dvb_enc_source__iclkena ) ,
    //
    .isop    ( ldpc_dvb_enc_source__isop    ) ,
    .ieop    ( ldpc_dvb_enc_source__ieop    ) ,
    .ival    ( ldpc_dvb_enc_source__ival    ) ,
    .idat    ( ldpc_dvb_enc_source__idat    ) ,
    //
    .ifulla  ( ldpc_dvb_enc_source__ifulla  ) ,
    .iemptya ( ldpc_dvb_enc_source__iemptya ) ,
    //
    .ordy    ( ldpc_dvb_enc_source__ordy    ) ,
    .obusy   ( ldpc_dvb_enc_source__obusy   ) ,
    //
    .owrite  ( ldpc_dvb_enc_source__owrite  ) ,
    .owfull  ( ldpc_dvb_enc_source__owfull  ) ,
    .owaddr  ( ldpc_dvb_enc_source__owaddr  ) ,
    .owdat   ( ldpc_dvb_enc_source__owdat   )
  );


  assign ldpc_dvb_enc_source__iclk    = '0 ;
  assign ldpc_dvb_enc_source__ireset  = '0 ;
  assign ldpc_dvb_enc_source__iclkena = '0 ;
  assign ldpc_dvb_enc_source__isop    = '0 ;
  assign ldpc_dvb_enc_source__ieop    = '0 ;
  assign ldpc_dvb_enc_source__ival    = '0 ;
  assign ldpc_dvb_enc_source__idat    = '0 ;
  assign ldpc_dvb_enc_source__ifulla  = '0 ;
  assign ldpc_dvb_enc_source__iemptya = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_source.sv
// Description   : input encoder interface module with DWC
//

module ldpc_dvb_enc_source
#(
  parameter int pDAT_W     = 8 ,
  //
  parameter int pWADDR_W   = 8 ,
  parameter int pWDAT_W    = 8 ,
  //
  parameter int pZC_FACTOR = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ieop    ,
  ival    ,
  idat    ,
  //
  ifulla  ,
  iemptya ,
  //
  ordy    ,
  obusy   ,
  //
  owrite  ,
  owfull  ,
  owaddr  ,
  owdat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                    iclk    ;
  input  logic                    ireset  ;
  input  logic                    iclkena ;
  //
  input  logic                    isop    ;
  input  logic                    ieop    ;
  input  logic                    ival    ;
  input  logic     [pDAT_W-1 : 0] idat    ;
  //
  input  logic                    ifulla  ;
  input  logic                    iemptya ;
  //
  output logic                    ordy    ;
  output logic                    obusy   ;
  //
  output logic [pZC_FACTOR-1 : 0] owrite  ;
  output logic                    owfull  ;
  output logic   [pWADDR_W-1 : 0] owaddr  ;
  output logic    [pWDAT_W-1 : 0] owdat   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDWC_FACTOR = pWDAT_W/pDAT_W;
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
          owdat  <= idat;
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
            owdat <= {idat, owdat[pWDAT_W-1 : pDAT_W]}; // lsb first
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
