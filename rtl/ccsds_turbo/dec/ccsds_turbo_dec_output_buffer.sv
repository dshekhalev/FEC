/*



  parameter int pADDR_W = 8 ;
  parameter int pWDAT_W = 2 ;
  parameter int pRDAT_W = 2 ;
  parameter int pTAG_W  = 8 ;
  parameter int pBNUM_W = 1 ;
  parameter bit pWPIPE  = 0 ;



  logic                 ccsds_turbo_dec_output_buffer__iclk     ;
  logic                 ccsds_turbo_dec_output_buffer__ireset   ;
  logic                 ccsds_turbo_dec_output_buffer__iclkena  ;
  logic                 ccsds_turbo_dec_output_buffer__iwrite   ;
  logic                 ccsds_turbo_dec_output_buffer__iwfull   ;
  logic [pADDR_W-1 : 0] ccsds_turbo_dec_output_buffer__ifwaddr  ;
  logic [pWDAT_W-1 : 0] ccsds_turbo_dec_output_buffer__ifwdat   ;
  logic [pADDR_W-1 : 0] ccsds_turbo_dec_output_buffer__ibwaddr  ;
  logic [pWDAT_W-1 : 0] ccsds_turbo_dec_output_buffer__ibwdat   ;
  logic  [pTAG_W-1 : 0] ccsds_turbo_dec_output_buffer__iwtag    ;
  logic                 ccsds_turbo_dec_output_buffer__irempty  ;
  logic [pADDR_W-1 : 0] ccsds_turbo_dec_output_buffer__iraddr   ;
  logic [pRDAT_W-1 : 0] ccsds_turbo_dec_output_buffer__ordata   ;
  logic  [pTAG_W-1 : 0] ccsds_turbo_dec_output_buffer__ortag    ;
  logic                 ccsds_turbo_dec_output_buffer__oempty   ;
  logic                 ccsds_turbo_dec_output_buffer__oemptya  ;
  logic                 ccsds_turbo_dec_output_buffer__ofull    ;
  logic                 ccsds_turbo_dec_output_buffer__ofulla   ;



  ccsds_turbo_dec_output_buffer
  #(
    .pADDR_W ( pADDR_W ) ,
    .pWDAT_W ( pWDAT_W ) ,
    .pRDAT_W ( pRDAT_W ) ,
    .pTAG_W  ( pTAG_W  ) ,
    .pBNUM_W ( pBNUM_W ) ,
    .pWPIPE  ( pWPIPE  )
  )
  ccsds_turbo_dec_output_buffer
  (
    .iclk    ( ccsds_turbo_dec_output_buffer__iclk    ) ,
    .ireset  ( ccsds_turbo_dec_output_buffer__ireset  ) ,
    .iclkena ( ccsds_turbo_dec_output_buffer__iclkena ) ,
    .iwrite  ( ccsds_turbo_dec_output_buffer__iwrite  ) ,
    .iwfull  ( ccsds_turbo_dec_output_buffer__iwfull  ) ,
    .ifwaddr ( ccsds_turbo_dec_output_buffer__ifwaddr ) ,
    .ifwdat  ( ccsds_turbo_dec_output_buffer__ifwdat  ) ,
    .ibwaddr ( ccsds_turbo_dec_output_buffer__ibwaddr ) ,
    .ibwdat  ( ccsds_turbo_dec_output_buffer__ibwdat  ) ,
    .iwtag   ( ccsds_turbo_dec_output_buffer__iwtag   ) ,
    .irempty ( ccsds_turbo_dec_output_buffer__irempty ) ,
    .iraddr  ( ccsds_turbo_dec_output_buffer__iraddr  ) ,
    .ordata  ( ccsds_turbo_dec_output_buffer__ordata  ) ,
    .ortag   ( ccsds_turbo_dec_output_buffer__ortag   ) ,
    .oempty  ( ccsds_turbo_dec_output_buffer__oempty  ) ,
    .oemptya ( ccsds_turbo_dec_output_buffer__oemptya ) ,
    .ofull   ( ccsds_turbo_dec_output_buffer__ofull   ) ,
    .ofulla  ( ccsds_turbo_dec_output_buffer__ofulla  )
  );


  assign ccsds_turbo_dec_output_buffer__iclk    = '0 ;
  assign ccsds_turbo_dec_output_buffer__ireset  = '0 ;
  assign ccsds_turbo_dec_output_buffer__iclkena = '0 ;
  assign ccsds_turbo_dec_output_buffer__iwrite  = '0 ;
  assign ccsds_turbo_dec_output_buffer__iwfull  = '0 ;
  assign ccsds_turbo_dec_output_buffer__ifwaddr = '0 ;
  assign ccsds_turbo_dec_output_buffer__ifwdat  = '0 ;
  assign ccsds_turbo_dec_output_buffer__ibwaddr = '0 ;
  assign ccsds_turbo_dec_output_buffer__ibwdat  = '0 ;
  assign ccsds_turbo_dec_output_buffer__iwtag   = '0 ;
  assign ccsds_turbo_dec_output_buffer__irempty = '0 ;
  assign ccsds_turbo_dec_output_buffer__iraddr  = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_output_buffer.sv
// Description   : output nD ram buffer for decoded bit pairs and data tags
//


module ccsds_turbo_dec_output_buffer
#(
  parameter int pADDR_W = 8 ,
  parameter int pWDAT_W = 1 , // 1 fixed. don't change
  parameter int pRDAT_W = 2 , // 1/2/4
  parameter int pTAG_W  = 8 ,
  parameter int pBNUM_W = 1 ,
  parameter bit pWPIPE  = 0   // write path pipeline register
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwfull  ,
  ifwaddr ,
  ifwdat  ,
  ibwaddr ,
  ibwdat  ,
  iwtag   ,
  //
  irempty ,
  iraddr  ,
  ordata  ,
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

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  logic                 iwrite   ;
  input  logic                 iwfull   ;
  input  logic [pADDR_W-1 : 0] ifwaddr  ;
  input  logic [pWDAT_W-1 : 0] ifwdat   ;
  input  logic [pADDR_W-1 : 0] ibwaddr  ;
  input  logic [pWDAT_W-1 : 0] ibwdat   ;
  input  logic  [pTAG_W-1 : 0] iwtag    ;
  //
  input  logic                 irempty  ;
  input  logic [pADDR_W-1 : 0] iraddr   ;
  output logic [pRDAT_W-1 : 0] ordata   ;
  output logic  [pTAG_W-1 : 0] ortag    ;
  //
  output logic                 oempty   ;
  output logic                 oemptya  ;
  output logic                 ofull    ;
  output logic                 ofulla   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W  = pADDR_W + pBNUM_W;
  localparam int cDWC_W   = $clog2(pRDAT_W/pWDAT_W);

  logic [pBNUM_W-1 : 0] b_wused ; // bank write used
  logic [pBNUM_W-1 : 0] b_rused ; // bank read used

  //------------------------------------------------------------------------------------------------------
  // buffer logic
  //------------------------------------------------------------------------------------------------------

  codec_buffer_nD_slogic
  #(
    .pBNUM_W ( pBNUM_W )
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
  // data ram
  //------------------------------------------------------------------------------------------------------

  wire [cADDR_W-1 : 0] ram__iraddr = (cDWC_W == 0) ? {b_rused, iraddr} : {{cDWC_W{1'b0}}, b_rused, iraddr[pADDR_W-cDWC_W-1 : 0]};

  codec_map_dec_output_ram
  #(
    .pWDAT_W ( pWDAT_W ) ,
    .pRDAT_W ( pRDAT_W ) ,
    .pADDR_W ( cADDR_W ) ,
    .pWPIPE  ( pWPIPE  )
  )
  ram
  (
    .ireset   ( ireset  ) ,
    //
    .iwclk    ( iclk    ) ,
    .iwclkena ( iclkena ) ,
    //
    .iwrite   ( iwrite             ) ,
    .iwaddr0  ( {b_wused, ifwaddr} ) ,
    .iwdata0  ( ifwdat             ) ,
    .iwaddr1  ( {b_wused, ibwaddr} ) ,
    .iwdata1  ( ibwdat             ) ,
    //
    .irclk    ( iclk               ) ,
    .irclkena ( iclkena            ) ,
    //
    .iread    ( 1'b1               ) ,
    .iraddr   ( ram__iraddr        ) ,
    .ordata   ( ordata             )
  );

  //------------------------------------------------------------------------------------------------------
  // tag ram
  //------------------------------------------------------------------------------------------------------

  logic [pTAG_W-1 : 0] tram [0 : (2**pBNUM_W)-1] /*synthesis ramstyle = "logic"*/;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwfull) begin
        tram [b_wused] <= iwtag;
      end
    end
  end

  assign ortag = tram[b_rused];

endmodule
