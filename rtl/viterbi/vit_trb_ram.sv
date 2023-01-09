/*



  parameter int pDATA_W  = 32 ;
  parameter int pADDR_W  =  8 ;



  logic                 vit_trb_ram__iclk    ;
  logic                 vit_trb_ram__ireset  ;
  logic                 vit_trb_ram__iclkena ;
  logic                 vit_trb_ram__iwrite  ;
  logic [pADDR_W-1 : 0] vit_trb_ram__iwaddr  ;
  logic [pDATA_W-1 : 0] vit_trb_ram__iwdata  ;
  logic [pADDR_W-1 : 0] vit_trb_ram__iraddr  ;
  logic [pDATA_W-1 : 0] vit_trb_ram__ordata  ;



  vit_trb_ram
  #(
    .pDATA_W ( pDATA_W ) ,
    .pADDR_W ( pADDR_W )
  )
  vit_trb_ram
  (
    .iclk    ( vit_trb_ram__iclk    ) ,
    .ireset  ( vit_trb_ram__ireset  ) ,
    .iclkena ( vit_trb_ram__iclkena ) ,
    .iwrite  ( vit_trb_ram__iwrite  ) ,
    .iwaddr  ( vit_trb_ram__iwaddr  ) ,
    .iwdata  ( vit_trb_ram__iwdata  ) ,
    .iraddr  ( vit_trb_ram__iraddr  ) ,
    .ordata  ( vit_trb_ram__ordata  )
  );


  assign vit_trb_ram__iclk    = '0 ;
  assign vit_trb_ram__ireset  = '0 ;
  assign vit_trb_ram__iclkena = '0 ;
  assign vit_trb_ram__iwrite  = '0 ;
  assign vit_trb_ram__iwaddr  = '0 ;
  assign vit_trb_ram__iwdata  = '0 ;
  assign vit_trb_ram__iraddr  = '0 ;



*/

//
// Project       : viterbi
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_trb_ram.sv
// Description   : Viterbi decoder ram for trellis state decisions (traceback).
//                 No any xD buffer control inside
//

module vit_trb_ram
#(
  parameter int pDATA_W  = 32 ,
  parameter int pADDR_W  =  8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwaddr  ,
  iwdata  ,
  //
  iraddr  ,
  ordata
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  logic                 iwrite   ;
  input  logic [pADDR_W-1 : 0] iwaddr   ;
  input  logic [pDATA_W-1 : 0] iwdata   ;
  //
  input  logic [pADDR_W-1 : 0] iraddr   ;
  output logic [pDATA_W-1 : 0] ordata   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pDATA_W-1 : 0] ram [2**pADDR_W] /*synthesis syn_ramstyle = "no_rw_check"*/;
  logic [pDATA_W-1 : 0] rdata;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite) begin
        ram[iwaddr] <= iwdata;
      end
      rdata   <= ram[iraddr];
      ordata  <= rdata;
    end
  end


endmodule
