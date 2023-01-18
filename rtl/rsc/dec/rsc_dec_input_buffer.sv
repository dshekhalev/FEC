/*



  parameter int pLLR_W  =  5 ;
  parameter int pLLR_FP =  3 ;
  parameter int pADDR_W =  8 ;
  parameter int pTAG_W  =  8 ;
  parameter int pBNUM_W =  1 ;
  parameter bit pAPIPE  =  0 ;
  parameter bit pDPIPE  =  0 ;



  logic                        rsc_dec_input_buffer__iclk            ;
  logic                        rsc_dec_input_buffer__ireset          ;
  logic                        rsc_dec_input_buffer__iclkena         ;
  logic                        rsc_dec_input_buffer__iwrite          ;
  logic                        rsc_dec_input_buffer__iwfull          ;
  logic                [1 : 0] rsc_dec_input_buffer__iwsel           ;
  logic        [pADDR_W-1 : 0] rsc_dec_input_buffer__iwaddr          ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__isLLR   [0 : 1] ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__iyLLR   [0 : 1] ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__iwLLR   [0 : 1] ;
  logic         [pTAG_W-1 : 0] rsc_dec_input_buffer__iwtag           ;
  logic                        rsc_dec_input_buffer__irempty         ;
  logic        [pADDR_W-1 : 0] rsc_dec_input_buffer__ifsaddr         ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__ofsLLR  [0 : 1] ;
  logic        [pADDR_W-1 : 0] rsc_dec_input_buffer__ifpaddr         ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__ofyLLR  [0 : 1] ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__ofwLLR  [0 : 1] ;
  logic        [pADDR_W-1 : 0] rsc_dec_input_buffer__ibsaddr         ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__obsLLR  [0 : 1] ;
  logic        [pADDR_W-1 : 0] rsc_dec_input_buffer__ibpaddr         ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__obyLLR  [0 : 1] ;
  logic signed  [pLLR_W-1 : 0] rsc_dec_input_buffer__obwLLR  [0 : 1] ;
  logic         [pTAG_W-1 : 0] rsc_dec_input_buffer__ortag           ;
  logic                        rsc_dec_input_buffer__oempty          ;
  logic                        rsc_dec_input_buffer__oemptya         ;
  logic                        rsc_dec_input_buffer__ofull           ;
  logic                        rsc_dec_input_buffer__ofulla          ;



  rsc_dec_input_buffer
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pLLR_FP ( pLLR_FP ) ,
    .pADDR_W ( pADDR_W ) ,
    .pTAG_W  ( pTAG_W  ) ,
    .pBNUM_W ( pBNUM_W ) ,
    .pAPIPE  ( pAPIPE  ) ,
    .pDPIPE  ( pDPIPE  )
  )
  rsc_dec_input_buffer
  (
    .iclk    ( rsc_dec_input_buffer__iclk    ) ,
    .ireset  ( rsc_dec_input_buffer__ireset  ) ,
    .iclkena ( rsc_dec_input_buffer__iclkena ) ,
    .iwrite  ( rsc_dec_input_buffer__iwrite  ) ,
    .iwfull  ( rsc_dec_input_buffer__iwfull  ) ,
    .iwsel   ( rsc_dec_input_buffer__iwsel   ) ,
    .iwaddr  ( rsc_dec_input_buffer__iwaddr  ) ,
    .isLLR   ( rsc_dec_input_buffer__isLLR   ) ,
    .iyLLR   ( rsc_dec_input_buffer__iyLLR   ) ,
    .iwLLR   ( rsc_dec_input_buffer__iwLLR   ) ,
    .iwtag   ( rsc_dec_input_buffer__iwtag   ) ,
    .irempty ( rsc_dec_input_buffer__irempty ) ,
    .ifsaddr ( rsc_dec_input_buffer__ifsaddr ) ,
    .ofsLLR  ( rsc_dec_input_buffer__ofsLLR  ) ,
    .ifpaddr ( rsc_dec_input_buffer__ifpaddr ) ,
    .ofyLLR  ( rsc_dec_input_buffer__ofyLLR  ) ,
    .ofwLLR  ( rsc_dec_input_buffer__ofwLLR  ) ,
    .ibsaddr ( rsc_dec_input_buffer__ibsaddr ) ,
    .obsLLR  ( rsc_dec_input_buffer__obsLLR  ) ,
    .ibpaddr ( rsc_dec_input_buffer__ibpaddr ) ,
    .obyLLR  ( rsc_dec_input_buffer__obyLLR  ) ,
    .obwLLR  ( rsc_dec_input_buffer__obwLLR  ) ,
    .ortag   ( rsc_dec_input_buffer__ortag   ) ,
    .oempty  ( rsc_dec_input_buffer__oempty  ) ,
    .oemptya ( rsc_dec_input_buffer__oemptya ) ,
    .ofull   ( rsc_dec_input_buffer__ofull   ) ,
    .ofulla  ( rsc_dec_input_buffer__ofulla  )
  );


  assign rsc_dec_input_buffer__iclk    = '0 ;
  assign rsc_dec_input_buffer__ireset  = '0 ;
  assign rsc_dec_input_buffer__iclkena = '0 ;
  assign rsc_dec_input_buffer__iwrite  = '0 ;
  assign rsc_dec_input_buffer__iwfull  = '0 ;
  assign rsc_dec_input_buffer__iwsel   = '0 ;
  assign rsc_dec_input_buffer__iwaddr  = '0 ;
  assign rsc_dec_input_buffer__isLLR   = '0 ;
  assign rsc_dec_input_buffer__iyLLR   = '0 ;
  assign rsc_dec_input_buffer__iwLLR   = '0 ;
  assign rsc_dec_input_buffer__iwtag   = '0 ;
  assign rsc_dec_input_buffer__irempty = '0 ;
  assign rsc_dec_input_buffer__ifsaddr = '0 ;
  assign rsc_dec_input_buffer__ifpaddr = '0 ;
  assign rsc_dec_input_buffer__ibsaddr = '0 ;
  assign rsc_dec_input_buffer__ibpaddr = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_input_buffer.sv
// Description   : input nD ram buffer for S/Y/W duobits LLR
//

module rsc_dec_input_buffer
#(
  parameter int pLLR_W  =  5 ,
  parameter int pADDR_W =  8 ,
  //
  parameter int pTAG_W  =  8 ,
  //
  parameter int pBNUM_W =  1 ,
  //
  parameter bit pAPIPE  =  0 ,  // read address pipeline register
  parameter bit pDPIPE  =  0    // read data    pipeline register
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwfull  ,
  iwsel   ,
  iwaddr  ,
  isLLR   ,
  iyLLR   ,
  iwLLR   ,
  iwtag   ,
  //
  irempty ,
  //
  ifsaddr ,
  ofsLLR  ,
  ifpaddr ,
  ofyLLR  ,
  ofwLLR  ,
  //
  ibsaddr ,
  obsLLR  ,
  ibpaddr ,
  obyLLR  ,
  obwLLR  ,
  //
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

  input  logic                        iclk            ;
  input  logic                        ireset          ;
  input  logic                        iclkena         ;
  //
  input  logic                        iwrite          ;
  input  logic                        iwfull          ;
  input  logic                [1 : 0] iwsel           ;
  input  logic        [pADDR_W-1 : 0] iwaddr          ;
  input  logic signed  [pLLR_W-1 : 0] isLLR   [0 : 1] ;
  input  logic signed  [pLLR_W-1 : 0] iyLLR   [0 : 1] ;
  input  logic signed  [pLLR_W-1 : 0] iwLLR   [0 : 1] ;
  input  logic         [pTAG_W-1 : 0] iwtag           ;
  //
  input  logic                        irempty         ;
  //
  input  logic        [pADDR_W-1 : 0] ifsaddr         ;
  output logic signed  [pLLR_W-1 : 0] ofsLLR  [0 : 1] ;
  input  logic        [pADDR_W-1 : 0] ifpaddr         ;
  output logic signed  [pLLR_W-1 : 0] ofyLLR  [0 : 1] ;
  output logic signed  [pLLR_W-1 : 0] ofwLLR  [0 : 1] ;
  //
  input  logic        [pADDR_W-1 : 0] ibsaddr         ;
  output logic signed  [pLLR_W-1 : 0] obsLLR  [0 : 1] ;
  input  logic        [pADDR_W-1 : 0] ibpaddr         ;
  output logic signed  [pLLR_W-1 : 0] obyLLR  [0 : 1] ;
  output logic signed  [pLLR_W-1 : 0] obwLLR  [0 : 1] ;
  //
  output logic         [pTAG_W-1 : 0] ortag           ;
  //
  output logic                        oempty          ; // any buffer is empty
  output logic                        oemptya         ; // all buffers is empty
  output logic                        ofull           ; // any buffer is full
  output logic                        ofulla          ; // all buffers is full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W = pADDR_W + pBNUM_W;
  localparam int cDATA_W = pLLR_W*2;

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
  // rams instantce
  //------------------------------------------------------------------------------------------------------

  codec_map_dec_input_ram
  #(
    .pDATA_W ( cDATA_W ) ,
    .pADDR_W ( cADDR_W ) ,
    .pAPIPE  ( pAPIPE  ) ,
    .pDPIPE  ( pDPIPE  )
  )
  sram
  (
    .ireset   ( ireset                 ) ,
    //
    .iwclk    ( iclk                   ) ,
    .iwclkena ( iclkena                ) ,
    //
    .iwrite   ( iwrite & &iwsel        ) ,
    .iwaddr   ( {b_wused, iwaddr}      ) ,
    .iwdata   ( {isLLR[1], isLLR[0]}   ) ,
    //
    .irclk    ( iclk                   ) ,
    .irclkena ( iclkena                ) ,
    .iread    ( 1'b1                   ) ,
    //
    .iraddr0  ( {b_rused, ifsaddr}     ) ,
    .ordata0  ( {ofsLLR[1], ofsLLR[0]} ) ,
    .iraddr1  ( {b_rused, ibsaddr}     ) ,
    .ordata1  ( {obsLLR[1], obsLLR[0]} )
  );

  codec_map_dec_input_ram
  #(
    .pDATA_W ( cDATA_W ) ,
    .pADDR_W ( cADDR_W ) ,
    .pAPIPE  ( pAPIPE  ) ,
    .pDPIPE  ( pDPIPE  )
  )
  yram
  (
    .ireset   ( ireset                ) ,
    //
    .iwclk    ( iclk                  ) ,
    .iwclkena ( iclkena               ) ,
    //
    .iwrite  ( iwrite & iwsel[0]      ) ,
    .iwaddr  ( {b_wused, iwaddr}      ) ,
    .iwdata  ( {iyLLR[1], iyLLR[0]}   ) ,
    //
    .irclk    ( iclk                  ) ,
    .irclkena ( iclkena               ) ,
    .iread    ( 1'b1                  ) ,
    //
    .iraddr0 ( {b_rused, ifpaddr}     ) ,
    .ordata0 ( {ofyLLR[1], ofyLLR[0]} ) ,
    .iraddr1 ( {b_rused, ibpaddr}     ) ,
    .ordata1 ( {obyLLR[1], obyLLR[0]} )
  );

  codec_map_dec_input_ram
  #(
    .pDATA_W ( cDATA_W ) ,
    .pADDR_W ( cADDR_W ) ,
    .pAPIPE  ( pAPIPE  ) ,
    .pDPIPE  ( pDPIPE  )
  )
  wram
  (
    .ireset   ( ireset                ) ,
    //
    .iwclk    ( iclk                  ) ,
    .iwclkena ( iclkena               ) ,
    //
    .iwrite  ( iwrite & iwsel[1]      ) ,
    .iwaddr  ( {b_wused, iwaddr}      ) ,
    .iwdata  ( {iwLLR[1], iwLLR[0]}   ) ,
    //
    .irclk    ( iclk                  ) ,
    .irclkena ( iclkena               ) ,
    .iread    ( 1'b1                  ) ,
    //
    .iraddr0 ( {b_rused, ifpaddr}     ) ,
    .ordata0 ( {ofwLLR[1], ofwLLR[0]} ) ,
    .iraddr1 ( {b_rused, ibpaddr}     ) ,
    .ordata1 ( {obwLLR[1], obwLLR[0]} )
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
