/*



  parameter int pWADDR_W = 8 ;
  parameter int pWDAT_W  = 8 ;
  //
  parameter int pRADDR_W = 8 ;
  parameter int pRDAT_W  = 8 ;
  //
  parameter int pTAG_W   = 8 ;
  parameter int pBNUM_W  = 1 ;
  //
  parameter bit pPIPE    = 1 ;



  logic                  ldpc_dvb_dec_ibuffer__iwclk    ;
  logic                  ldpc_dvb_dec_ibuffer__iwreset  ;
  //
  logic   [cBUF_N-1 : 0] ldpc_dvb_dec_ibuffer__iwrite   ;
  logic                  ldpc_dvb_dec_ibuffer__iwfull   ;
  logic [pWADDR_W-1 : 0] ldpc_dvb_dec_ibuffer__iwaddr   ;
  logic  [pWDAT_W-1 : 0] ldpc_dvb_dec_ibuffer__iwdat    ;
  logic   [pTAG_W-1 : 0] ldpc_dvb_dec_ibuffer__iwtag    ;
  //
  logic                  ldpc_dvb_dec_ibuffer__owempty  ;
  logic                  ldpc_dvb_dec_ibuffer__owemptya ;
  logic                  ldpc_dvb_dec_ibuffer__owfull   ;
  logic                  ldpc_dvb_dec_ibuffer__owfulla  ;
  //
  logic                  ldpc_dvb_dec_ibuffer__irclk    ;
  logic                  ldpc_dvb_dec_ibuffer__irreset  ;
  //
  logic                  ldpc_dvb_dec_ibuffer__irempty  ;
  logic [pRADDR_W-1 : 0] ldpc_dvb_dec_ibuffer__iraddr   ;
  logic  [pRDAT_W-1 : 0] ldpc_dvb_dec_ibuffer__ordat    ;
  logic   [pTAG_W-1 : 0] ldpc_dvb_dec_ibuffer__ortag    ;
  //
  logic                  ldpc_dvb_dec_ibuffer__orempty  ;
  logic                  ldpc_dvb_dec_ibuffer__oremptya ;
  logic                  ldpc_dvb_dec_ibuffer__orfull   ;
  logic                  ldpc_dvb_dec_ibuffer__orfulla  ;



  ldpc_dvb_dec_ibuffer
  #(
    .pWADDR_W ( pWADDR_W ) ,
    .pWDAT_W  ( pWDAT_W  ) ,
    //
    .pRADDR_W ( pRADDR_W ) ,
    .pRDAT_W  ( pRDAT_W  ) ,
    //
    .pTAG_W   ( pTAG_W   ) ,
    .pBNUM_W  ( pBNUM_W  ) ,
    //
    .pPIPE    ( pPIPE    )
  )
  ldpc_dvb_dec_ibuffer
  (
    .iwclk    ( ldpc_dvb_dec_ibuffer__iwclk    ) ,
    .iwreset  ( ldpc_dvb_dec_ibuffer__iwreset  ) ,
    //
    .iwrite   ( ldpc_dvb_dec_ibuffer__iwrite   ) ,
    .iwfull   ( ldpc_dvb_dec_ibuffer__iwfull   ) ,
    .iwaddr   ( ldpc_dvb_dec_ibuffer__iwaddr   ) ,
    .iwdat    ( ldpc_dvb_dec_ibuffer__iwdat    ) ,
    .iwtag    ( ldpc_dvb_dec_ibuffer__iwtag    ) ,
    //
    .owempty  ( ldpc_dvb_dec_ibuffer__owempty  ) ,
    .owemptya ( ldpc_dvb_dec_ibuffer__owemptya ) ,
    .owfull   ( ldpc_dvb_dec_ibuffer__owfull   ) ,
    .owfulla  ( ldpc_dvb_dec_ibuffer__owfulla  ) ,
    //
    .irclk    ( ldpc_dvb_dec_ibuffer__irclk    ) ,
    .irreset  ( ldpc_dvb_dec_ibuffer__irreset  ) ,
    //
    .irempty  ( ldpc_dvb_dec_ibuffer__irempty  ) ,
    .iraddr   ( ldpc_dvb_dec_ibuffer__iraddr   ) ,
    .ordat    ( ldpc_dvb_dec_ibuffer__ordat    ) ,
    .ortag    ( ldpc_dvb_dec_ibuffer__ortag    ) ,
    //
    .orempty  ( ldpc_dvb_dec_ibuffer__orempty  ) ,
    .oremptya ( ldpc_dvb_dec_ibuffer__oremptya ) ,
    .orfull   ( ldpc_dvb_dec_ibuffer__orfull   ) ,
    .orfulla  ( ldpc_dvb_dec_ibuffer__orfulla  )
  );


  assign ldpc_dvb_dec_ibuffer__iwclk    = '0 ;
  assign ldpc_dvb_dec_ibuffer__iwreset  = '0 ;
  //
  assign ldpc_dvb_dec_ibuffer__iwrite   = '0 ;
  assign ldpc_dvb_dec_ibuffer__iwfull   = '0 ;
  assign ldpc_dvb_dec_ibuffer__iwaddr   = '0 ;
  assign ldpc_dvb_dec_ibuffer__iwdat    = '0 ;
  assign ldpc_dvb_dec_ibuffer__iwtag    = '0 ;
  //
  assign ldpc_dvb_dec_ibuffer__irclk    = '0 ;
  assign ldpc_dvb_dec_ibuffer__irreset  = '0 ;
  //
  assign ldpc_dvb_dec_ibuffer__irempty  = '0 ;
  assign ldpc_dvb_dec_ibuffer__iraddr   = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_ibuffer.sv
// Description   : asynchronus xD ram buffer with 2D tag interface with DWC options. Ram read latency is 1/2 tick
//

module ldpc_dvb_dec_ibuffer
#(
  parameter int pWADDR_W = 8 ,
  parameter int pWDAT_W  = 8 ,
  //
  parameter int pRADDR_W = 8 ,
  parameter int pRDAT_W  = 8 ,
  //
  parameter int pTAG_W   = 8 ,
  parameter int pBNUM_W  = 1 , // 2D buffer
  //
  parameter int pPIPE    = 1
)
(
  iwclk    ,
  iwreset  ,
  //
  iwrite   ,
  iwfull   ,
  iwaddr   ,
  iwdat    ,
  iwtag    ,
  //
  owempty  ,
  owemptya ,
  owfull   ,
  owfulla  ,
  //
  irclk    ,
  irreset  ,
  //
  irempty  ,
  iraddr   ,
  ordat    ,
  ortag    ,
  //
  orempty   ,
  oremptya  ,
  orfull    ,
  orfulla
);

  localparam int cBUF_N  = pRDAT_W/pWDAT_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // write side
  input  logic                  iwclk    ;
  input  logic                  iwreset  ;
  //
  input  logic   [cBUF_N-1 : 0] iwrite   ;
  input  logic                  iwfull   ;
  input  logic [pWADDR_W-1 : 0] iwaddr   ;
  input  logic  [pWDAT_W-1 : 0] iwdat    ;
  input  logic   [pTAG_W-1 : 0] iwtag    ;
  //
  output logic                  owempty  ; // any buffer is empty
  output logic                  owemptya ; // all buffers is empty
  output logic                  owfull   ; // any buffer is full
  output logic                  owfulla  ; // all buffers is full
  // read side
  input  logic                  irclk    ;
  input  logic                  irreset  ;
  //
  input  logic                  irempty  ;
  input  logic [pRADDR_W-1 : 0] iraddr   ;
  output logic  [pRDAT_W-1 : 0] ordat    ;
  output logic   [pTAG_W-1 : 0] ortag    ;
  //
  output logic                  orempty  ; // any buffer is empty
  output logic                  oremptya ; // all buffers is empty
  output logic                  orfull   ; // any buffer is full
  output logic                  orfulla  ; // all buffers is full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cWADDR_W = pWADDR_W + pBNUM_W;
  localparam int cRADDR_W = pRADDR_W + pBNUM_W;

  logic [pBNUM_W-1 : 0] b_wused ; // bank write used
  logic [pBNUM_W-1 : 0] b_rused ; // bank read used

  logic [pWDAT_W-1 : 0] mem__ordat [cBUF_N];

  //------------------------------------------------------------------------------------------------------
  // buffer logic
  //------------------------------------------------------------------------------------------------------

  codec_buffer_nD_alogic
  #(
    .pBNUM_W ( pBNUM_W )
  )
  nD_logic
  (
    .iwclk      ( iwclk     ) ,
    .iwreset    ( iwreset   ) ,
    //
    .iwfull     ( iwfull    ) ,
    .ob_wused   ( b_wused   ) ,
    //
    .ob_wempty  ( owempty   ) ,
    .ob_wemptya ( owemptya  ) ,
    .ob_wfull   ( owfull    ) ,
    .ob_wfulla  ( owfulla   ) ,
    //
    .irclk      ( irclk     ) ,
    .irreset    ( irreset   ) ,
    //
    .irempty    ( irempty   ) ,
    .ob_rused   ( b_rused   ) ,
    //
    .ob_rempty  ( orempty   ) ,
    .ob_remptya ( oremptya  ) ,
    .ob_rfull   ( orfull    ) ,
    .ob_rfulla  ( orfulla   )
  );

  //------------------------------------------------------------------------------------------------------
  // ram
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < cBUF_N; g++) begin : mem_inst
      codec_mem_ablock
      #(
        .pADDR_W  ( cRADDR_W ) ,
        .pDAT_W   ( pWDAT_W  ) ,
        //
        .pPIPE    ( pPIPE    )
      )
      mem
      (
        .ireset   ( 1'b0              ) ,
        //
        .iwclk    ( iwclk             ) ,
        .iwclkena ( 1'b1              ) ,
        .iwrite   ( iwrite     [g]    ) ,
        .iwaddr   ( {b_wused, iwaddr} ) ,
        .iwdat    ( iwdat             ) ,
        //
        .irclk    ( irclk             ) ,
        .irclkena ( 1'b1              ) ,
        .iraddr   ( {b_rused, iraddr} ) ,
        .ordat    ( mem__ordat [g]    )
      );

      assign ordat[g*pWDAT_W +: pWDAT_W] = mem__ordat[g];
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // tag ram
  //------------------------------------------------------------------------------------------------------

  logic [pTAG_W-1 : 0] tram [2**pBNUM_W] /* synthesis ramstyle = "logic" */ = '{default : '0};

  always_ff @(posedge iwclk) begin
    if (iwfull) begin
      tram [b_wused] <= iwtag;
    end
  end

  assign ortag = tram[b_rused];

endmodule
