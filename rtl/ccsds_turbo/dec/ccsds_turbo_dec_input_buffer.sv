/*



  parameter int pLLR_W  =  5 ;
  parameter int pLLR_FP =  3 ;
  parameter int pADDR_W =  8 ;
  parameter int pTAG_W  =  8 ;
  parameter int pBNUM_W =  1 ;
  parameter bit pAPIPE  =  0 ;
  parameter bit pDPIPE  =  0 ;



  logic                        ccsds_turbo_dec_input_buffer__iclk         ;
  logic                        ccsds_turbo_dec_input_buffer__ireset       ;
  logic                        ccsds_turbo_dec_input_buffer__iclkena      ;
  logic                        ccsds_turbo_dec_input_buffer__iwrite       ;
  logic                        ccsds_turbo_dec_input_buffer__iwfull       ;
  logic        [pADDR_W-1 : 0] ccsds_turbo_dec_input_buffer__iwaddr       ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__isLLR        ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__ia0LLR   [3] ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__ia1LLR   [3] ;
  logic         [pTAG_W-1 : 0] ccsds_turbo_dec_input_buffer__iwtag        ;
  logic                        ccsds_turbo_dec_input_buffer__irempty      ;
  logic        [pADDR_W-1 : 0] ccsds_turbo_dec_input_buffer__ifsaddr      ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__ofsLLR       ;
  logic        [pADDR_W-1 : 0] ccsds_turbo_dec_input_buffer__ifpaddr      ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__ofa0LLR  [3] ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__ofa1LLR  [3] ;
  logic        [pADDR_W-1 : 0] ccsds_turbo_dec_input_buffer__ibsaddr      ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__obsLLR       ;
  logic        [pADDR_W-1 : 0] ccsds_turbo_dec_input_buffer__ibpaddr      ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__oba0LLR  [3] ;
  logic signed  [pLLR_W-1 : 0] ccsds_turbo_dec_input_buffer__oba1LLR  [3] ;
  logic         [pTAG_W-1 : 0] ccsds_turbo_dec_input_buffer__ortag        ;
  logic                        ccsds_turbo_dec_input_buffer__oempty       ;
  logic                        ccsds_turbo_dec_input_buffer__oemptya      ;
  logic                        ccsds_turbo_dec_input_buffer__ofull        ;
  logic                        ccsds_turbo_dec_input_buffer__ofulla       ;



  ccsds_turbo_dec_input_buffer
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pLLR_FP ( pLLR_FP ) ,
    .pADDR_W ( pADDR_W ) ,
    .pTAG_W  ( pTAG_W  ) ,
    .pBNUM_W ( pBNUM_W ) ,
    .pAPIPE  ( pAPIPE  ) ,
    .pDPIPE  ( pDPIPE  )
  )
  ccsds_turbo_dec_input_buffer
  (
    .iclk    ( ccsds_turbo_dec_input_buffer__iclk    ) ,
    .ireset  ( ccsds_turbo_dec_input_buffer__ireset  ) ,
    .iclkena ( ccsds_turbo_dec_input_buffer__iclkena ) ,
    .iwrite  ( ccsds_turbo_dec_input_buffer__iwrite  ) ,
    .iwfull  ( ccsds_turbo_dec_input_buffer__iwfull  ) ,
    .iwaddr  ( ccsds_turbo_dec_input_buffer__iwaddr  ) ,
    .isLLR   ( ccsds_turbo_dec_input_buffer__isLLR   ) ,
    .ia0LLR   ( ccsds_turbo_dec_input_buffer__ia0LLR   ) ,
    .ia1LLR   ( ccsds_turbo_dec_input_buffer__ia1LLR   ) ,
    .iwtag   ( ccsds_turbo_dec_input_buffer__iwtag   ) ,
    .irempty ( ccsds_turbo_dec_input_buffer__irempty ) ,
    .ifsaddr ( ccsds_turbo_dec_input_buffer__ifsaddr ) ,
    .ofsLLR  ( ccsds_turbo_dec_input_buffer__ofsLLR  ) ,
    .ifpaddr ( ccsds_turbo_dec_input_buffer__ifpaddr ) ,
    .ofa0LLR  ( ccsds_turbo_dec_input_buffer__ofa0LLR  ) ,
    .ofa1LLR  ( ccsds_turbo_dec_input_buffer__ofa1LLR  ) ,
    .ibsaddr ( ccsds_turbo_dec_input_buffer__ibsaddr ) ,
    .obsLLR  ( ccsds_turbo_dec_input_buffer__obsLLR  ) ,
    .ibpaddr ( ccsds_turbo_dec_input_buffer__ibpaddr ) ,
    .oba0LLR  ( ccsds_turbo_dec_input_buffer__oba0LLR  ) ,
    .oba1LLR  ( ccsds_turbo_dec_input_buffer__oba1LLR  ) ,
    .ortag   ( ccsds_turbo_dec_input_buffer__ortag   ) ,
    .oempty  ( ccsds_turbo_dec_input_buffer__oempty  ) ,
    .oemptya ( ccsds_turbo_dec_input_buffer__oemptya ) ,
    .ofull   ( ccsds_turbo_dec_input_buffer__ofull   ) ,
    .ofulla  ( ccsds_turbo_dec_input_buffer__ofulla  )
  );


  assign ccsds_turbo_dec_input_buffer__iclk    = '0 ;
  assign ccsds_turbo_dec_input_buffer__ireset  = '0 ;
  assign ccsds_turbo_dec_input_buffer__iclkena = '0 ;
  assign ccsds_turbo_dec_input_buffer__iwrite  = '0 ;
  assign ccsds_turbo_dec_input_buffer__iwfull  = '0 ;
  assign ccsds_turbo_dec_input_buffer__iwaddr  = '0 ;
  assign ccsds_turbo_dec_input_buffer__isLLR   = '0 ;
  assign ccsds_turbo_dec_input_buffer__ia0LLR   = '0 ;
  assign ccsds_turbo_dec_input_buffer__ia1LLR   = '0 ;
  assign ccsds_turbo_dec_input_buffer__iwtag   = '0 ;
  assign ccsds_turbo_dec_input_buffer__irempty = '0 ;
  assign ccsds_turbo_dec_input_buffer__ifsaddr = '0 ;
  assign ccsds_turbo_dec_input_buffer__ifpaddr = '0 ;
  assign ccsds_turbo_dec_input_buffer__ibsaddr = '0 ;
  assign ccsds_turbo_dec_input_buffer__ibpaddr = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_input_buffer.sv
// Description   : input nD ram buffer for S/Y/W duobits LLR
//

module ccsds_turbo_dec_input_buffer
#(
  parameter int pLLR_W  =  5 ,
  parameter int pLLR_FP =  3 ,
  parameter int pADDR_W =  8 ,
  parameter int pTAG_W  =  8 ,
  parameter int pBNUM_W =  1 ,
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
  iwaddr  ,
  isLLR   ,
  ia0LLR  ,
  ia1LLR  ,
  iwtag   ,
  //
  irempty ,
  //
  ifsaddr ,
  ofsLLR  ,
  ifpaddr ,
  ofa0LLR ,
  ofa1LLR ,
  //
  ibsaddr ,
  obsLLR  ,
  ibpaddr ,
  oba0LLR ,
  oba1LLR ,
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

  input  logic                        iclk        ;
  input  logic                        ireset      ;
  input  logic                        iclkena     ;
  //
  input  logic                        iwrite      ;
  input  logic                        iwfull      ;
  input  logic        [pADDR_W-1 : 0] iwaddr      ;
  input  logic signed  [pLLR_W-1 : 0] isLLR       ;
  input  logic signed  [pLLR_W-1 : 0] ia0LLR  [3] ;
  input  logic signed  [pLLR_W-1 : 0] ia1LLR  [3] ;
  input  logic         [pTAG_W-1 : 0] iwtag       ;
  //
  input  logic                        irempty     ;
  //
  input  logic        [pADDR_W-1 : 0] ifsaddr     ;
  output logic signed  [pLLR_W-1 : 0] ofsLLR      ;
  input  logic        [pADDR_W-1 : 0] ifpaddr     ;
  output logic signed  [pLLR_W-1 : 0] ofa0LLR [3] ;
  output logic signed  [pLLR_W-1 : 0] ofa1LLR [3] ;
  //
  input  logic        [pADDR_W-1 : 0] ibsaddr     ;
  output logic signed  [pLLR_W-1 : 0] obsLLR      ;
  input  logic        [pADDR_W-1 : 0] ibpaddr     ;
  output logic signed  [pLLR_W-1 : 0] oba0LLR [3] ;
  output logic signed  [pLLR_W-1 : 0] oba1LLR [3] ;
  //
  output logic         [pTAG_W-1 : 0] ortag        ;
  //
  output logic                        oempty       ; // any buffer is empty
  output logic                        oemptya      ; // all buffers is empty
  output logic                        ofull        ; // any buffer is full
  output logic                        ofulla       ; // all buffers is full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cADDR_W  = pADDR_W + pBNUM_W;
  localparam int cDATA_W  = pLLR_W;
  localparam int cPDATA_W = pLLR_W*3;

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
    .ireset   ( ireset  ) ,
    //
    .iwclk    ( iclk    ) ,
    .iwclkena ( iclkena ) ,
    //
    .iwrite   ( iwrite             ) ,
    .iwaddr   ( {b_wused, iwaddr}  ) ,
    .iwdata   ( isLLR              ) ,
    //
    .irclk    ( iclk    ) ,
    .irclkena ( iclkena ) ,
    .iread    ( 1'b1    ) ,
    //
    .iraddr0  ( {b_rused, ifsaddr} ) ,
    .ordata0  ( ofsLLR             ) ,
    .iraddr1  ( {b_rused, ibsaddr} ) ,
    .ordata1  ( obsLLR             )
  );

  codec_map_dec_input_ram
  #(
    .pDATA_W ( cPDATA_W ) ,
    .pADDR_W ( cADDR_W  ) ,
    .pAPIPE  ( pAPIPE   ) ,
    .pDPIPE  ( pDPIPE   )
  )
  a01ram
  (
    .ireset   ( ireset  ) ,
    //
    .iwclk    ( iclk    ) ,
    .iwclkena ( iclkena ) ,
    //
    .iwrite  ( iwrite                               ) ,
    .iwaddr  ( {b_wused, iwaddr}                    ) ,
    .iwdata  ( {ia0LLR[2], ia0LLR[1], ia0LLR[0]}    ) ,
    //
    .irclk    ( iclk    ) ,
    .irclkena ( iclkena ) ,
    .iread    ( 1'b1    ) ,
    //
    .iraddr0 ( {b_rused, ifpaddr}                   ) ,
    .ordata0 ( {ofa0LLR[2], ofa0LLR[1], ofa0LLR[0]} ) ,
    .iraddr1 ( {b_rused, ibpaddr}                   ) ,
    .ordata1 ( {oba0LLR[2], oba0LLR[1], oba0LLR[0]} )
  );

  codec_map_dec_input_ram
  #(
    .pDATA_W ( cPDATA_W ) ,
    .pADDR_W ( cADDR_W  ) ,
    .pAPIPE  ( pAPIPE   ) ,
    .pDPIPE  ( pDPIPE   )
  )
  a1ram
  (
    .ireset   ( ireset  ) ,
    //
    .iwclk    ( iclk    ) ,
    .iwclkena ( iclkena ) ,
    //
    .iwrite  ( iwrite                               ) ,
    .iwaddr  ( {b_wused, iwaddr}                    ) ,
    .iwdata  ( {ia1LLR[2], ia1LLR[1], ia1LLR[0]}    ) ,
    //
    .irclk    ( iclk    ) ,
    .irclkena ( iclkena ) ,
    .iread    ( 1'b1    ) ,
    //
    .iraddr0 ( {b_rused, ifpaddr}                   ) ,
    .ordata0 ( {ofa1LLR[2], ofa1LLR[1], ofa1LLR[0]} ) ,
    .iraddr1 ( {b_rused, ibpaddr}                   ) ,
    .ordata1 ( {oba1LLR[2], oba1LLR[1], oba1LLR[0]} )
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
