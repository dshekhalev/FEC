/*



  parameter int pWADDR_W  = 8 ;
  parameter int pWDAT_W   = 8 ;
  //
  parameter int pRADDR_W  = 8 ;
  parameter int pRDAT_W   = 8 ;
  //
  parameter int pDATA_NUM = 8 ;
  //
  parameter int pTAG_W    = 1 ;



  logic                  ldpc_3gpp_dec_obuffer__iclk               ;
  logic                  ldpc_3gpp_dec_obuffer__ireset             ;
  logic                  ldpc_3gpp_dec_obuffer__iclkena            ;
  //
  logic                  ldpc_3gpp_dec_obuffer__iwrite             ;
  logic                  ldpc_3gpp_dec_obuffer__iwfull             ;
  logic [pWADDR_W-1 : 0] ldpc_3gpp_dec_obuffer__iwaddr             ;
  logic [ pWDAT_W-1 : 0] ldpc_3gpp_dec_obuffer__iwdat   [pDAT_NUM] ;
  logic   [pTAG_W-1 : 0] ldpc_3gpp_dec_obuffer__iwtag              ;
  //
  logic                  ldpc_3gpp_dec_obuffer__irempty            ;
  logic [pRADDR_W-1 : 0] ldpc_3gpp_dec_obuffer__iraddr             ;
  logic  [pRDAT_W-1 : 0] ldpc_3gpp_dec_obuffer__ordat   [pDAT_NUM] ;
  logic   [pTAG_W-1 : 0] ldpc_3gpp_dec_obuffer__ortag              ;
  //
  logic                  ldpc_3gpp_dec_obuffer__oempty             ;
  logic                  ldpc_3gpp_dec_obuffer__oemptya            ;
  logic                  ldpc_3gpp_dec_obuffer__ofull              ;
  logic                  ldpc_3gpp_dec_obuffer__ofulla             ;



  ldpc_3gpp_dec_obuffer
  #(
    .pWADDR_W  ( pWADDR_W  ) ,
    .pWDAT_W   ( pWDAT_W   ) ,
    //
    .pRADDR_W  ( pRADDR_W  ) ,
    .pRDAT_W   ( pRDAT_W   ) ,
    //
    .pDATA_NUM ( pDATA_NUM ) ,
    //
    .pTAG_W    ( pTAG_W    )
  )
  ldpc_3gpp_dec_obuffer
  (
    .iclk    ( ldpc_3gpp_dec_obuffer__iclk    ) ,
    .ireset  ( ldpc_3gpp_dec_obuffer__ireset  ) ,
    .iclkena ( ldpc_3gpp_dec_obuffer__iclkena ) ,
    //
    .iwrite  ( ldpc_3gpp_dec_obuffer__iwrite  ) ,
    .iwfull  ( ldpc_3gpp_dec_obuffer__iwfull  ) ,
    .iwaddr  ( ldpc_3gpp_dec_obuffer__iwaddr  ) ,
    .iwdat   ( ldpc_3gpp_dec_obuffer__iwdat   ) ,
    .iwtag   ( ldpc_3gpp_dec_obuffer__iwtag   ) ,
    //
    .irempty ( ldpc_3gpp_dec_obuffer__irempty ) ,
    .iraddr  ( ldpc_3gpp_dec_obuffer__iraddr  ) ,
    .ordat   ( ldpc_3gpp_dec_obuffer__ordat   ) ,
    .ortag   ( ldpc_3gpp_dec_obuffer__ortag   ) ,
    //
    .oempty  ( ldpc_3gpp_dec_obuffer__oempty  ) ,
    .oemptya ( ldpc_3gpp_dec_obuffer__oemptya ) ,
    .ofull   ( ldpc_3gpp_dec_obuffer__ofull   ) ,
    .ofulla  ( ldpc_3gpp_dec_obuffer__ofulla  )
  );


  assign ldpc_3gpp_dec_obuffer__iclk    = '0 ;
  assign ldpc_3gpp_dec_obuffer__ireset  = '0 ;
  assign ldpc_3gpp_dec_obuffer__iclkena = '0 ;
  //
  assign ldpc_3gpp_dec_obuffer__iwrite  = '0 ;
  assign ldpc_3gpp_dec_obuffer__iwfull  = '0 ;
  assign ldpc_3gpp_dec_obuffer__iwaddr  = '0 ;
  assign ldpc_3gpp_dec_obuffer__iwdat   = '0 ;
  assign ldpc_3gpp_dec_obuffer__iwtag   = '0 ;
  //
  assign ldpc_3gpp_dec_obuffer__irempty = '0 ;
  assign ldpc_3gpp_dec_obuffer__iraddr  = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_obuffer.sv
// Description   : output 2D ram buffer with 2D tag interface. Ram read latency is 2 tick
//
//

module ldpc_3gpp_dec_obuffer
#(
  parameter int pWADDR_W = 8 ,
  parameter int pWDAT_W  = 8 ,
  //
  parameter int pRADDR_W = 8 ,
  parameter int pRDAT_W  = 8 ,
  //
  parameter int pDAT_NUM  = 8 ,
  //
  parameter int pTAG_W    = 4
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwfull  ,
  iwaddr  ,
  iwdat   ,
  iwtag   ,
  //
  irempty ,
  iraddr  ,
  ordat   ,
  ortag   ,
  //
  oempty  ,
  oemptya ,
  ofull   ,
  ofulla
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk               ;
  input  logic                  ireset             ;
  input  logic                  iclkena            ;
  //
  input  logic                  iwrite             ;
  input  logic                  iwfull             ;
  input  logic [pWADDR_W-1 : 0] iwaddr             ;
  input  logic [ pWDAT_W-1 : 0] iwdat   [pDAT_NUM] ;
  input  logic   [pTAG_W-1 : 0] iwtag              ;
  //
  input  logic                  irempty            ;
  input  logic [pRADDR_W-1 : 0] iraddr             ;
  output logic  [pRDAT_W-1 : 0] ordat   [pDAT_NUM] ;
  output logic   [pTAG_W-1 : 0] ortag              ;
  //
  output logic                  oempty             ;
  output logic                  oemptya            ;
  output logic                  ofull              ;
  output logic                  ofulla             ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cWADDR_W = pWADDR_W + 1;
  localparam int cRADDR_W = pRADDR_W + 1;

  logic b_wused ; // bank write used
  logic b_rused ; // bank read  used

  //------------------------------------------------------------------------------------------------------
  // buffer logic
  //------------------------------------------------------------------------------------------------------

  codec_buffer_nD_slogic
  #(
    .pBNUM_W ( 1 )  // 2D buffer
  )
  nD_slogic
  (
    .iclk     ( iclk    ) ,
    .ireset   ( ireset  ) ,
    .iclkena  ( iclkena ) ,
    //
    .iwfull   ( iwfull  ) ,
    .ob_wused ( b_wused ) ,
    .irempty  ( irempty ) ,
    .ob_rused ( b_rused ) ,
    //
    .oempty   ( oempty  ) ,
    .oemptya  ( oemptya ) ,
    .ofull    ( ofull   ) ,
    .ofulla   ( ofulla  )
  );

  //------------------------------------------------------------------------------------------------------
  // ram block inst
  //------------------------------------------------------------------------------------------------------

  generate
    genvar gn;
    for (gn = 0; gn < pDAT_NUM; gn++) begin : ram_inst
      codec_mem_dwc_block
      #(
        .pWADDR_W ( cWADDR_W ) ,
        .pWDAT_W  ( pWDAT_W  ) ,
        //
        .pRADDR_W ( cRADDR_W ) ,
        .pRDAT_W  ( pRDAT_W  ) ,
        //
        .pPIPE    ( 1        )
      )
      mem
      (
        .iclk    ( iclk              ) ,
        .ireset  ( ireset            ) ,
        .iclkena ( iclkena           ) ,
        //
        .iwrite  ( iwrite            ) ,
        .iwaddr  ( {b_wused, iwaddr} ) ,
        .iwdat   ( iwdat[gn]         ) ,
        //
        .iraddr  ( {b_rused, iraddr} ) ,
        .ordat   ( ordat[gn]         )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // tag ram
  //------------------------------------------------------------------------------------------------------

  logic [pTAG_W-1 : 0] tram [2] /* synthesis ramstyle = "logic" */;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwfull) begin
        tram [b_wused] <= iwtag;
      end
    end
  end

  assign ortag = tram[b_rused];

endmodule
