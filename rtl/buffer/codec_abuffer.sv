/*



  parameter int pADDR_W = 8 ;
  parameter int pDAT_W  = 5 ;
  parameter int pTAG_W  = 8 ;
  parameter int pBNUM_W = 1 ;
  parameter int pPIPE   = 1 ;



  logic                 codec_abuffer__iwclk    ;
  logic                 codec_abuffer__iwreset  ;
  //
  logic                 codec_abuffer__iwrite   ;
  logic                 codec_abuffer__iwfull   ;
  logic [pADDR_W-1 : 0] codec_abuffer__iwaddr   ;
  logic  [pDAT_W-1 : 0] codec_abuffer__iwdat    ;
  logic  [pTAG_W-1 : 0] codec_abuffer__iwtag    ;
  //
  logic                 codec_abuffer__owempty  ;
  logic                 codec_abuffer__owemptya ;
  logic                 codec_abuffer__owfull   ;
  logic                 codec_abuffer__owfulla  ;
  //
  logic                 codec_abuffer__irclk    ;
  logic                 codec_abuffer__irreset  ;
  //
  logic                 codec_abuffer__irempty  ;
  logic [pADDR_W-1 : 0] codec_abuffer__iraddr   ;
  logic  [pDAT_W-1 : 0] codec_abuffer__ordat    ;
  logic  [pTAG_W-1 : 0] codec_abuffer__ortag    ;
  //
  logic                 codec_abuffer__orempty  ;
  logic                 codec_abuffer__oremptya ;
  logic                 codec_abuffer__orfull   ;
  logic                 codec_abuffer__orfulla  ;



  codec_abuffer
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pTAG_W  ( pTAG_W  ) ,
    .pBNUM_W ( pBNUM_W ) ,
    .pPIPE   ( pPIPE   )
  )
  codec_abuffer
  (
    .iwclk    ( codec_abuffer__iwclk    ) ,
    .iwreset  ( codec_abuffer__iwreset  ) ,
    //
    .iwrite   ( codec_abuffer__iwrite   ) ,
    .iwfull   ( codec_abuffer__iwfull   ) ,
    .iwaddr   ( codec_abuffer__iwaddr   ) ,
    .iwdat    ( codec_abuffer__iwdat    ) ,
    .iwtag    ( codec_abuffer__iwtag    ) ,
    //
    .owempty  ( codec_abuffer__owempty  ) ,
    .owemptya ( codec_abuffer__owemptya ) ,
    .owfull   ( codec_abuffer__owfull   ) ,
    .owfulla  ( codec_abuffer__owfulla  ) ,
    //
    .irclk    ( codec_abuffer__irclk    ) ,
    .irreset  ( codec_abuffer__irreset  ) ,
    //
    .irempty  ( codec_abuffer__irempty  ) ,
    .iraddr   ( codec_abuffer__iraddr   ) ,
    .ordat    ( codec_abuffer__ordat    ) ,
    .ortag    ( codec_abuffer__ortag    ) ,
    //
    .orempty  ( codec_abuffer__orempty  ) ,
    .oremptya ( codec_abuffer__oremptya ) ,
    .orfull   ( codec_abuffer__orfull   ) ,
    .orfulla  ( codec_abuffer__orfulla  )
  );


  assign codec_abuffer__iwclk    = '0 ;
  assign codec_abuffer__iwreset  = '0 ;
  //
  assign codec_abuffer__iwrite   = '0 ;
  assign codec_abuffer__iwfull   = '0 ;
  assign codec_abuffer__iwaddr   = '0 ;
  assign codec_abuffer__iwdat    = '0 ;
  assign codec_abuffer__iwtag    = '0 ;
  //
  assign codec_abuffer__irclk    = '0 ;
  assign codec_abuffer__irreset  = '0 ;
  //
  assign codec_abuffer__irempty  = '0 ;
  assign codec_abuffer__iraddr   = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_abuffer.sv
// Description   : asynchronus xD ram buffer with 2D tag interface. Ram read latency is 1/2 tick
//

module codec_abuffer
#(
  parameter int pADDR_W = 8 ,
  parameter int pDAT_W  = 8 ,
  parameter int pTAG_W  = 8 ,
  parameter int pBNUM_W = 1 , // 2D buffer
  parameter int pPIPE   = 1
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

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // write side
  input  logic                 iwclk    ;
  input  logic                 iwreset  ;
  //
  input  logic                 iwrite   ;
  input  logic                 iwfull   ;
  input  logic [pADDR_W-1 : 0] iwaddr   ;
  input  logic  [pDAT_W-1 : 0] iwdat    ;
  input  logic  [pTAG_W-1 : 0] iwtag    ;
  //
  output logic                 owempty  ; // any buffer is empty
  output logic                 owemptya ; // all buffers is empty
  output logic                 owfull   ; // any buffer is full
  output logic                 owfulla  ; // all buffers is full
  // read side
  input  logic                 irclk    ;
  input  logic                 irreset  ;
  //
  input  logic                 irempty  ;
  input  logic [pADDR_W-1 : 0] iraddr   ;
  output logic  [pDAT_W-1 : 0] ordat    ;
  output logic  [pTAG_W-1 : 0] ortag    ;
  //
  output logic                 orempty  ; // any buffer is empty
  output logic                 oremptya ; // all buffers is empty
  output logic                 orfull   ; // any buffer is full
  output logic                 orfulla  ; // all buffers is full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W  = pADDR_W + pBNUM_W;

  logic [pBNUM_W-1 : 0] b_wused ; // bank write used
  logic [pBNUM_W-1 : 0] b_rused ; // bank read used

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

  codec_mem_ablock
  #(
    .pADDR_W ( cADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pPIPE   ( pPIPE   )
  )
  mem
  (
    .ireset   ( 1'b0              ) ,
    //
    .iwclk    ( iwclk             ) ,
    .iwclkena ( 1'b1              ) ,
    .iwrite   ( iwrite            ) ,
    .iwaddr   ( {b_wused, iwaddr} ) ,
    .iwdat    ( iwdat             ) ,
    //
    .irclk    ( irclk             ) ,
    .irclkena ( 1'b1              ) ,
    .iraddr   ( {b_rused, iraddr} ) ,
    .ordat    ( ordat             )
  );

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
