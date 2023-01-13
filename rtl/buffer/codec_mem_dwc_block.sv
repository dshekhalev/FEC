/*



  parameter int pWADDR_W =  8 ;
  parameter int pWDAT_W  =  8 ;
  //
  parameter int pRADDR_W =  8 ;
  parameter int pRDAT_W  =  8 ;
  //
  parameter bit pPIPE    =  1 ;



  logic                  codec_mem_dwc_block__iclk    ;
  logic                  codec_mem_dwc_block__ireset  ;
  logic                  codec_mem_dwc_block__iclkena ;
  //
  logic                  codec_mem_dwc_block__iwrite  ;
  logic [pWADDR_W-1 : 0] codec_mem_dwc_block__iwaddr  ;
  logic  [pWDAT_W-1 : 0] codec_mem_dwc_block__iwdat   ;
  //
  logic [pRADDR_W-1 : 0] codec_mem_dwc_block__iraddr  ;
  logic  [pRDAT_W-1 : 0] codec_mem_dwc_block__ordat   ;



  codec_mem_dwc_block
  #(
    .pWADDR_W ( pWADDR_W ) ,
    .pWDAT_W  ( pWDAT_W  ) ,
    //
    .pRADDR_W ( pRADDR_W ) ,
    .pRDAT_W  ( pRDAT_W  ) ,
    //
    .pPIPE    ( pPIPE    )
  )
  codec_mem_dwc_block
  (
    .iclk    ( codec_mem_dwc_block__iclk    ) ,
    .ireset  ( codec_mem_dwc_block__ireset  ) ,
    .iclkena ( codec_mem_dwc_block__iclkena ) ,
    //
    .iwrite  ( codec_mem_dwc_block__iwrite  ) ,
    .iwaddr  ( codec_mem_dwc_block__iwaddr  ) ,
    .iwdat   ( codec_mem_dwc_block__iwdat   ) ,
    //
    .iraddr  ( codec_mem_dwc_block__iraddr  ) ,
    .ordat   ( codec_mem_dwc_block__ordat   )
  );


  assign codec_mem_dwc_block__iclk    = '0 ;
  assign codec_mem_dwc_block__ireset  = '0 ;
  assign codec_mem_dwc_block__iclkena = '0 ;
  //
  assign codec_mem_dwc_block__iwrite  = '0 ;
  assign codec_mem_dwc_block__iwaddr  = '0 ;
  assign codec_mem_dwc_block__iwdat   = '0 ;
  //
  assign codec_mem_dwc_block__iraddr  = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_mem_dwc_block.sv
// Description   : Simple dual port ram with optional pipeline register & DWC support
//                 Write data width >= read data width
//

`include "define.vh"

module codec_mem_dwc_block
#(
  parameter int pWADDR_W  = 8 ,
  parameter int pWDAT_W   = 32 , // == N*pRDAT_W, N = 1/2/4/8
  //
  parameter int pRADDR_W  = 8+2 ,
  parameter int pRDAT_W   = 8 ,
  //
  parameter bit pPIPE     = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwaddr  ,
  iwdat   ,
  //
  iraddr  ,
  ordat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk     ;
  input  logic                  ireset   ;
  input  logic                  iclkena  ;
  //
  input  logic                  iwrite   ;
  input  logic [pWADDR_W-1 : 0] iwaddr   ;
  input  logic  [pWDAT_W-1 : 0] iwdat    ;
  //
  input  logic [pRADDR_W-1 : 0] iraddr   ;
  output logic  [pRDAT_W-1 : 0] ordat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDWC_FACTOR      = (pWDAT_W >= pRDAT_W) ? pWDAT_W/pRDAT_W : pRDAT_W/pWDAT_W;
  localparam int cLOG_DWC_FACTOR  = clogb2(cDWC_FACTOR);

  localparam int cRAM_DAT_W       = (pWDAT_W >= pRDAT_W) ? pRDAT_W  : pWDAT_W;
  localparam int cRAM_ADDR_W      = (pWDAT_W >= pRDAT_W) ? pRADDR_W : pWADDR_W;

  bit   [cRAM_DAT_W-1 : 0] mem  [2**cRAM_ADDR_W] /* synthesis ramstyle = "no_rw_check", ram_style = "block" */;
  logic    [pRDAT_W-1 : 0] rdat [2];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pWDAT_W == pRDAT_W) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          rdat[0] <= mem[iraddr];
          rdat[1] <= rdat[0];
          //
          if (iwrite) begin
            mem[iwaddr] <= iwdat;
          end
        end
      end
    end
    else if (pWDAT_W > pRDAT_W) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          rdat[0] <= mem[iraddr];
          rdat[1] <= rdat[0];
          //
          if (iwrite) begin
            for (int d = 0; d < cDWC_FACTOR; d++) begin
              mem[{iwaddr, d[cLOG_DWC_FACTOR-1 : 0]}] <= iwdat[d*pRDAT_W +: pRDAT_W];
            end
          end // iwrite
        end // iclkena
      end // iclk
    end
    else begin // // (pWDAT_W < pRDAT_W)
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          for (int d = 0; d < cDWC_FACTOR; d++) begin
            rdat[0][d*pWDAT_W +: pWDAT_W] <= mem[{iraddr, d[cLOG_DWC_FACTOR-1 : 0]}];
          end
          rdat[1] <= rdat[0];
          //
          if (iwrite) begin
            mem[iwaddr] <= iwdat;
          end // iwrite
        end // iclkena
      end // iclk
    end
  endgenerate

  assign ordat = rdat[pPIPE];

endmodule
