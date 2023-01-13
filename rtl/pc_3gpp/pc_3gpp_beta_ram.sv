/*



  parameter int pADDR_W = 8 ;
  parameter int pDAT_W  = 8 ;
  parameter bit pPIPE   = 0 ;



  logic                 pc_3gpp_beta_ram__iclk       ;
  logic                 pc_3gpp_beta_ram__ireset     ;
  logic                 pc_3gpp_beta_ram__iclkena    ;
  logic                 pc_3gpp_beta_ram__iwrite     ;
  logic [pADDR_W-1 : 0] pc_3gpp_beta_ram__iwaddr     ;
  logic                 pc_3gpp_beta_ram__iwsel      ;
  logic  [pDAT_W-1 : 0] pc_3gpp_beta_ram__iwdat      ;
  logic [pADDR_W-1 : 0] pc_3gpp_beta_ram__iraddr     ;
  logic  [pDAT_W-1 : 0] pc_3gpp_beta_ram__ordat  [2] ;



  pc_3gpp_beta_ram
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pPIPE   ( pPIPE   )
  )
  pc_3gpp_beta_ram
  (
    .iclk    ( pc_3gpp_beta_ram__iclk    ) ,
    .ireset  ( pc_3gpp_beta_ram__ireset  ) ,
    .iclkena ( pc_3gpp_beta_ram__iclkena ) ,
    .iwrite  ( pc_3gpp_beta_ram__iwrite  ) ,
    .iwaddr  ( pc_3gpp_beta_ram__iwaddr  ) ,
    .iwsel   ( pc_3gpp_beta_ram__iwsel   ) ,
    .iwdat   ( pc_3gpp_beta_ram__iwdat   ) ,
    .iraddr  ( pc_3gpp_beta_ram__iraddr  ) ,
    .ordat   ( pc_3gpp_beta_ram__ordat   )
  );


  assign pc_3gpp_beta_ram__iclk    = '0 ;
  assign pc_3gpp_beta_ram__ireset  = '0 ;
  assign pc_3gpp_beta_ram__iclkena = '0 ;
  assign pc_3gpp_beta_ram__iwrite  = '0 ;
  assign pc_3gpp_beta_ram__iwaddr  = '0 ;
  assign pc_3gpp_beta_ram__iwsel   = '0 ;
  assign pc_3gpp_beta_ram__iwdat   = '0 ;
  assign pc_3gpp_beta_ram__iraddr  = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_beta_ram.v
// Description   : Beta (bit) ram for intermediate layer bit data. Ram used in recursive encoder and decoder
//


module pc_3gpp_beta_ram
#(
  parameter int pADDR_W = 8 ,
  parameter int pDAT_W  = 8 ,
  parameter bit pPIPE   = 0
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwaddr  ,
  iwsel   ,
  iwdat   ,
  //
  iraddr  ,
  ordat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk       ;
  input  logic                 ireset     ;
  input  logic                 iclkena    ;
  //
  input  logic                 iwrite     ;
  input  logic [pADDR_W-1 : 0] iwaddr     ;
  input  logic                 iwsel      ;
  input  logic  [pDAT_W-1 : 0] iwdat      ;
  //
  input  logic [pADDR_W-1 : 0] iraddr     ;
  output logic  [pDAT_W-1 : 0] ordat  [2] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit [pDAT_W-1 : 0] ram0 [2**pADDR_W] /* synthesis ramstyle = "no_rw_check" */;
  bit [pDAT_W-1 : 0] ram1 [2**pADDR_W] /* synthesis ramstyle = "no_rw_check" */;

  logic [pDAT_W-1 : 0] rdat [2][2];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite) begin
        if (iwsel) begin
          ram1[iwaddr] <= iwdat;
        end
        else begin
          ram0[iwaddr] <= iwdat;
        end
      end
      rdat[0][0]  <= ram0[iraddr];
      rdat[0][1]  <= ram1[iraddr];
      //
      rdat[1]     <= rdat[0];
    end
  end

  assign ordat = rdat[pPIPE];

endmodule
