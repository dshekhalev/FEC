/*



  parameter int pWADDR_W  = 8 ;
  parameter int pRADDR_W  = 8 ;
  parameter int pLLR_W    = 4 ;
  parameter int pWORD_W   = 8 ;
  parameter int pTAG_W    = 4 ;
  parameter int pBNUM_W   = 2 ;



  logic                  pc_3gpp_dec_ibuf__iclk               ;
  logic                  pc_3gpp_dec_ibuf__ireset             ;
  logic                  pc_3gpp_dec_ibuf__iclkena            ;
  logic                  pc_3gpp_dec_ibuf__iwrite             ;
  logic                  pc_3gpp_dec_ibuf__iwfull             ;
  logic [pWADDR_W-1 : 0] pc_3gpp_dec_ibuf__iwLLR_addr         ;
  logic [pWADDR_W-1 : 0] pc_3gpp_dec_ibuf__iwLLR_frzb_addr    ;
  logic [pWADDR_W-1 : 0] pc_3gpp_dec_ibuf__ifrzb_addr         ;
  logic  [ pLLR_W-1 : 0] pc_3gpp_dec_ibuf__iwLLR              ;
  logic                  pc_3gpp_dec_ibuf__iwfrzb             ;
  logic   [pTAG_W-1 : 0] pc_3gpp_dec_ibuf__iwtag              ;
  logic                  pc_3gpp_dec_ibuf__irempty            ;
  logic [pRADDR_W-1 : 0] pc_3gpp_dec_ibuf__irLLR_addr         ;
  logic [pRADDR_W-1 : 0] pc_3gpp_dec_ibuf__irfrzb_addr        ;
  logic   [pLLR_W-1 : 0] pc_3gpp_dec_ibuf__orLLR    [pWORD_W] ;
  logic  [pWORD_W-1 : 0] pc_3gpp_dec_ibuf__orLLR_frzb         ;
  logic  [pWORD_W-1 : 0] pc_3gpp_dec_ibuf__orfrzb             ;
  logic   [pTAG_W-1 : 0] pc_3gpp_dec_ibuf__ortag              ;
  logic                  pc_3gpp_dec_ibuf__oempty             ;
  logic                  pc_3gpp_dec_ibuf__oemptya            ;
  logic                  pc_3gpp_dec_ibuf__ofull              ;
  logic                  pc_3gpp_dec_ibuf__ofulla             ;



  pc_3gpp_dec_ibuf
  #(
    .pWADDR_W ( pWADDR_W ) ,
    .pRADDR_W ( pRADDR_W ) ,
    .pLLR_W   ( pLLR_W   ) ,
    .pWORD_W  ( pWORD_W  ) ,
    .pTAG_W   ( pTAG_W   ) ,
    .pBNUM_W  ( pBNUM_W  )
  )
  pc_3gpp_dec_ibuf
  (
    .iclk            ( pc_3gpp_dec_ibuf__iclk            ) ,
    .ireset          ( pc_3gpp_dec_ibuf__ireset          ) ,
    .iclkena         ( pc_3gpp_dec_ibuf__iclkena         ) ,
    .iwrite          ( pc_3gpp_dec_ibuf__iwrite          ) ,
    .iwfull          ( pc_3gpp_dec_ibuf__iwfull          ) ,
    .iwLLR_addr      ( pc_3gpp_dec_ibuf__iwLLR_addr      ) ,
    .iwLLR_frzb_addr ( pc_3gpp_dec_ibuf__iwLLR_frzb_addr ) ,
    .iwfrzb_addr     ( pc_3gpp_dec_ibuf__iwfrzb_addr     ) ,
    .iwLLR           ( pc_3gpp_dec_ibuf__iwLLR           ) ,
    .iwfrzb          ( pc_3gpp_dec_ibuf__iwfrzb          ) ,
    .iwtag           ( pc_3gpp_dec_ibuf__iwtag           ) ,
    .irempty         ( pc_3gpp_dec_ibuf__irempty         ) ,
    .irLLR_addr      ( pc_3gpp_dec_ibuf__irLLR_addr      ) ,
    .irfrzb_addr     ( pc_3gpp_dec_ibuf__irfrzb_addr     ) ,
    .orLLR           ( pc_3gpp_dec_ibuf__orLLR           ) ,
    .orLLR_frzb      ( pc_3gpp_dec_ibuf__orLLR_frzb      ) ,
    .orfrzb          ( pc_3gpp_dec_ibuf__orfrzb          ) ,
    .ortag           ( pc_3gpp_dec_ibuf__ortag           ) ,
    .oempty          ( pc_3gpp_dec_ibuf__oempty          ) ,
    .oemptya         ( pc_3gpp_dec_ibuf__oemptya         ) ,
    .ofull           ( pc_3gpp_dec_ibuf__ofull           ) ,
    .ofulla          ( pc_3gpp_dec_ibuf__ofulla          )
  );


  assign pc_3gpp_dec_ibuf__iclk             = '0 ;
  assign pc_3gpp_dec_ibuf__ireset           = '0 ;
  assign pc_3gpp_dec_ibuf__iclkena          = '0 ;
  assign pc_3gpp_dec_ibuf__iwrite           = '0 ;
  assign pc_3gpp_dec_ibuf__iwfull           = '0 ;
  assign pc_3gpp_dec_ibuf__iwLLR_addr       = '0 ;
  assign pc_3gpp_dec_ibuf__iwLLR_frzb_addr  = '0 ;
  assign pc_3gpp_dec_ibuf__iwfrzb_addr      = '0 ;
  assign pc_3gpp_dec_ibuf__iwLLR            = '0 ;
  assign pc_3gpp_dec_ibuf__iwfrzb           = '0 ;
  assign pc_3gpp_dec_ibuf__iwtag            = '0 ;
  assign pc_3gpp_dec_ibuf__irempty          = '0 ;
  assign pc_3gpp_dec_ibuf__irLLR_addr       = '0 ;
  assign pc_3gpp_dec_ibuf__irfrzb_addr      = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_ibuf.sv
// Description   : Polar decoder input nD buffer for channel LLR, channel frozen bits for reencode and frozen bits for decoding
//                 The buffer has manual DWC at writing
//


module pc_3gpp_dec_ibuf
#(
  parameter int pWADDR_W  = 8 ,
  parameter int pRADDR_W  = 4 ,
  parameter int pLLR_W    = 4 ,
  parameter int pWORD_W   = 8 , // engine word width
  parameter int pTAG_W    = 4 ,
  parameter int pBNUM_W   = 2
)
(
  iclk            ,
  ireset          ,
  iclkena         ,
  //
  iwrite          ,
  iwfull          ,
  iwLLR_addr      ,
  iwLLR_frzb_addr ,
  iwfrzb_addr     ,
  iwLLR           ,
  iwfrzb          ,
  iwtag           ,
  //
  irempty         ,
  irLLR_addr      ,
  irfrzb_addr     ,
  orLLR           ,
  orLLR_frzb      ,
  orfrzb          ,
  ortag           ,
  //
  oempty          ,
  oemptya         ,
  ofull           ,
  ofulla
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk                      ;
  input  logic                  ireset                    ;
  input  logic                  iclkena                   ;
  //
  input  logic                  iwrite                    ;
  input  logic                  iwfull                    ;
  input  logic [pWADDR_W-1 : 0] iwLLR_addr                ;
  input  logic [pWADDR_W-1 : 0] iwLLR_frzb_addr           ;
  input  logic [pWADDR_W-1 : 0] iwfrzb_addr               ;
  input  logic   [pLLR_W-1 : 0] iwLLR                     ;
  input  logic                  iwfrzb                    ;
  input  logic   [pTAG_W-1 : 0] iwtag                     ;
  //
  input  logic                  irempty                   ;
  input  logic [pRADDR_W-1 : 0] irLLR_addr                ;
  input  logic [pRADDR_W-1 : 0] irfrzb_addr               ;
  output logic   [pLLR_W-1 : 0] orLLR           [pWORD_W] ;
  output logic  [pWORD_W-1 : 0] orLLR_frzb                ;
  output logic  [pWORD_W-1 : 0] orfrzb                    ;
  output logic   [pTAG_W-1 : 0] ortag                     ;
  //
  output logic                  oempty                    ;
  output logic                  oemptya                   ;
  output logic                  ofull                     ;
  output logic                  ofulla                    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cRAM_WADDR_W = pWADDR_W + pBNUM_W;
  localparam int cRAM_RADDR_W = pRADDR_W + pBNUM_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

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
  // LLR for decode
  //------------------------------------------------------------------------------------------------------

  logic [pWORD_W*pLLR_W-1 : 0] mem_LLR__ordat;

  codec_mem_dwc_block
  #(
    .pWADDR_W ( cRAM_WADDR_W   ) ,
    .pWDAT_W  ( pLLR_W         ) ,
    //
    .pRADDR_W ( cRAM_RADDR_W   ) ,
    .pRDAT_W  ( pWORD_W*pLLR_W ) ,
    //
    .pPIPE    ( 0              )
  )
  mem_LLR
  (
    .iclk    ( iclk                  ) ,
    .ireset  ( ireset                ) ,
    .iclkena ( iclkena               ) ,
    //
    .iwrite  ( iwrite                ) ,
    .iwaddr  ( {b_wused, iwLLR_addr} ) ,
    .iwdat   ( iwLLR                 ) ,
    //
    .iraddr  ( {b_rused, irLLR_addr} ) ,
    .ordat   ( mem_LLR__ordat        )
  );

  always_comb begin
    for (int i = 0; i < pWORD_W; i++) begin
      orLLR[i] = mem_LLR__ordat[i*pLLR_W +: pLLR_W];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // frozen bits mask address for re ecnode
  //------------------------------------------------------------------------------------------------------

  codec_mem_dwc_block
  #(
    .pWADDR_W ( cRAM_WADDR_W ) ,
    .pWDAT_W  ( 1            ) ,
    //
    .pRADDR_W ( cRAM_RADDR_W ) ,
    .pRDAT_W  ( pWORD_W      ) ,
    //
    .pPIPE    ( 0            )
  )
  mem_LLR_frzb
  (
    .iclk    ( iclk                       ) ,
    .ireset  ( ireset                     ) ,
    .iclkena ( iclkena                    ) ,
    //
    .iwrite  ( iwrite                     ) ,
    .iwaddr  ( {b_wused, iwLLR_frzb_addr} ) ,
    .iwdat   ( iwfrzb                     ) ,
    //
    .iraddr  ( {b_rused, irLLR_addr}      ) ,
    .ordat   ( orLLR_frzb                 )
  );

  //------------------------------------------------------------------------------------------------------
  // frozen bits mask address for decode
  //------------------------------------------------------------------------------------------------------

  codec_mem_dwc_block
  #(
    .pWADDR_W ( cRAM_WADDR_W ) ,
    .pWDAT_W  ( 1            ) ,
    //
    .pRADDR_W ( cRAM_RADDR_W ) ,
    .pRDAT_W  ( pWORD_W      ) ,
    //
    .pPIPE    ( 0            )
  )
  mem_frzb
  (
    .iclk    ( iclk                   ) ,
    .ireset  ( ireset                 ) ,
    .iclkena ( iclkena                ) ,
    //
    .iwrite  ( iwrite                 ) ,
    .iwaddr  ( {b_wused, iwfrzb_addr} ) ,
    .iwdat   ( iwfrzb                 ) ,
    //
    .iraddr  ( {b_rused, irfrzb_addr} ) ,
    .ordat   ( orfrzb                 )
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
