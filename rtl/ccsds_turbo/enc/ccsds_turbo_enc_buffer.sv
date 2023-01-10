/*



  parameter int pADDR_W  = 8 ;
  parameter int pDATA_W  = 8 ;
  parameter int pTAG_W   = 8 ;
  parameter int pBNUM_W  = 1 ;
  parameter bit pPIPE    = 0 ;



  logic                 ccsds_turbo_enc_buffer__iclk    ;
  logic                 ccsds_turbo_enc_buffer__ireset  ;
  logic                 ccsds_turbo_enc_buffer__iclkena ;
  logic                 ccsds_turbo_enc_buffer__iwrite  ;
  logic                 ccsds_turbo_enc_buffer__iwfull  ;
  logic [pADDR_W-1 : 0] ccsds_turbo_enc_buffer__iwaddr  ;
  logic [pDATA_W-1 : 0] ccsds_turbo_enc_buffer__iwdata  ;
  logic  [pTAG_W-1 : 0] ccsds_turbo_enc_buffer__iwtag   ;
  logic                 ccsds_turbo_enc_buffer__iread   ;
  logic                 ccsds_turbo_enc_buffer__irempty ;
  logic [pADDR_W-1 : 0] ccsds_turbo_enc_buffer__iraddr0 ;
  logic [pDATA_W-1 : 0] ccsds_turbo_enc_buffer__ordata0 ;
  logic [pADDR_W-1 : 0] ccsds_turbo_enc_buffer__iraddr1 ;
  logic [pDATA_W-1 : 0] ccsds_turbo_enc_buffer__ordata1 ;
  logic  [pTAG_W-1 : 0] ccsds_turbo_enc_buffer__ortag   ;
  logic                 ccsds_turbo_enc_buffer__oempty  ;
  logic                 ccsds_turbo_enc_buffer__oemptya ;
  logic                 ccsds_turbo_enc_buffer__ofull   ;
  logic                 ccsds_turbo_enc_buffer__ofulla  ;



  ccsds_turbo_enc_buffer
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDATA_W ( pDATA_W ) ,
    .pTAG_W  ( pTAG_W  ) ,
    .pBNUM_W ( pBNUM_W ) ,
    .pPIPE   ( pPIPE   )
  )
  ccsds_turbo_enc_buffer
  (
    .iclk    ( ccsds_turbo_enc_buffer__iclk    ) ,
    .ireset  ( ccsds_turbo_enc_buffer__ireset  ) ,
    .iclkena ( ccsds_turbo_enc_buffer__iclkena ) ,
    .iwrite  ( ccsds_turbo_enc_buffer__iwrite  ) ,
    .iwfull  ( ccsds_turbo_enc_buffer__iwfull  ) ,
    .iwaddr  ( ccsds_turbo_enc_buffer__iwaddr  ) ,
    .iwdata  ( ccsds_turbo_enc_buffer__iwdata  ) ,
    .iwtag   ( ccsds_turbo_enc_buffer__iwtag   ) ,
    .iread   ( ccsds_turbo_enc_buffer__iread   ) ,
    .irempty ( ccsds_turbo_enc_buffer__irempty ) ,
    .iraddr0 ( ccsds_turbo_enc_buffer__iraddr0 ) ,
    .ordata0 ( ccsds_turbo_enc_buffer__ordata0 ) ,
    .iraddr1 ( ccsds_turbo_enc_buffer__iraddr1 ) ,
    .ordata1 ( ccsds_turbo_enc_buffer__ordata1 ) ,
    .ortag   ( ccsds_turbo_enc_buffer__ortag   ) ,
    .oempty  ( ccsds_turbo_enc_buffer__oempty  ) ,
    .oemptya ( ccsds_turbo_enc_buffer__oemptya ) ,
    .ofull   ( ccsds_turbo_enc_buffer__ofull   ) ,
    .ofulla  ( ccsds_turbo_enc_buffer__ofulla  )
  );


  assign ccsds_turbo_enc_buffer__iclk    = '0 ;
  assign ccsds_turbo_enc_buffer__ireset  = '0 ;
  assign ccsds_turbo_enc_buffer__iclkena = '0 ;
  assign ccsds_turbo_enc_buffer__iwrite  = '0 ;
  assign ccsds_turbo_enc_buffer__iwfull  = '0 ;
  assign ccsds_turbo_enc_buffer__iwaddr  = '0 ;
  assign ccsds_turbo_enc_buffer__iwdata  = '0 ;
  assign ccsds_turbo_enc_buffer__iwtag   = '0 ;
  assign ccsds_turbo_enc_buffer__iread   = '0 ;
  assign ccsds_turbo_enc_buffer__irempty = '0 ;
  assign ccsds_turbo_enc_buffer__iraddr  = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_enc_buffer.sv
// Description   : encoder nD ram buffer with single write port and two concurrent read ports
//


module ccsds_turbo_enc_buffer
#(
  parameter int pADDR_W  = 8 ,
  parameter int pDATA_W  = 8 ,
  parameter int pTAG_W   = 8 ,
  parameter int pBNUM_W  = 1 ,  // 2**pBNUM_W is amount of bufers
  parameter bit pPIPE    = 0
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwfull  ,
  iwaddr  ,
  iwdata  ,
  iwtag   ,
  //
  iread   ,
  irempty ,
  iraddr0 ,
  ordata0 ,
  iraddr1 ,
  ordata1 ,
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
  input  logic [pADDR_W-1 : 0] iwaddr   ;
  input  logic [pDATA_W-1 : 0] iwdata   ;
  input  logic  [pTAG_W-1 : 0] iwtag    ;
  //
  input  logic                 iread    ;
  input  logic                 irempty  ;
  input  logic [pADDR_W-1 : 0] iraddr0  ;
  output logic [pDATA_W-1 : 0] ordata0  ;
  input  logic [pADDR_W-1 : 0] iraddr1  ;
  output logic [pDATA_W-1 : 0] ordata1  ;
  output logic  [pTAG_W-1 : 0] ortag    ;
  //
  output logic                 oempty   ; // any buffer is empty
  output logic                 oemptya  ; // all buffers is empty
  output logic                 ofull    ; // any buffer is full
  output logic                 ofulla   ; // all buffers is full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cRAM_ADDR_W  = pADDR_W + pBNUM_W;
  localparam int cRAM_DATA_W  = pDATA_W;

  logic [pBNUM_W-1 : 0] b_wused ; // bank write used
  logic [pBNUM_W-1 : 0] b_rused ; // bank read used

  logic [cRAM_ADDR_W-1 : 0] ram_waddr;
  logic [cRAM_ADDR_W-1 : 0] ram_raddr0;
  logic [cRAM_ADDR_W-1 : 0] ram_raddr1;

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

  assign ram_waddr  = {b_wused, iwaddr};
  assign ram_raddr0 = {b_rused, iraddr0};
  assign ram_raddr1 = {b_rused, iraddr1};

  //------------------------------------------------------------------------------------------------------
  // ram0
  //------------------------------------------------------------------------------------------------------

  logic [cRAM_DATA_W-1 : 0] ram0 [0 : (2**cRAM_ADDR_W)-1] /* synthesis ramstyle = "no_rw_check" */;
  logic [cRAM_DATA_W-1 : 0] ram_pipe0 [0 : 1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite) begin
        ram0[ram_waddr] <= iwdata;
      end
      ram_pipe0[0] <= ram0[ram_raddr0];
      ram_pipe0[1] <= ram_pipe0[0];
    end
  end

  assign ordata0 = ram_pipe0[pPIPE];

  //------------------------------------------------------------------------------------------------------
  // ram1
  //------------------------------------------------------------------------------------------------------

  logic [cRAM_DATA_W-1 : 0] ram1 [0 : (2**cRAM_ADDR_W)-1] /* synthesis ramstyle = "no_rw_check" */;
  logic [cRAM_DATA_W-1 : 0] ram_pipe1 [0 : 1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite) begin
        ram1[ram_waddr] <= iwdata;
      end
      ram_pipe1[0] <= ram1[ram_raddr1];
      ram_pipe1[1] <= ram_pipe1[0];
    end
  end

  assign ordata1 = ram_pipe1[pPIPE];

  //------------------------------------------------------------------------------------------------------
  // tag ram
  //------------------------------------------------------------------------------------------------------

  logic [pTAG_W-1 : 0] tram [0 : (2**pBNUM_W)-1] /*synthesis ramstyle = "logic"*/;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwfull)
        tram [b_wused] <= iwtag;
    end
  end

  assign ortag = tram[b_rused];

endmodule
