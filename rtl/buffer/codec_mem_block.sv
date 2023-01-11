/*



  parameter int pADDR_W = 256 ;
  parameter int pDAT_W  =   8 ;
  parameter bit pPIPE   =   1 ;



  logic                 codec_mem_block__iclk     ;
  logic                 codec_mem_block__ireset   ;
  logic                 codec_mem_block__iclkena  ;
  //
  logic                 codec_mem_block__iwrite   ;
  logic [pADDR_W-1 : 0] codec_mem_block__iwaddr   ;
  logic  [pDAT_W-1 : 0] codec_mem_block__iwdat    ;
  //
  logic [pADDR_W-1 : 0] codec_mem_block__iraddr   ;
  logic  [pDAT_W-1 : 0] codec_mem_block__ordat    ;



  codec_mem_block
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pPIPE   ( pPIPE   )
  )
  codec_mem_block
  (
    .iclk    ( codec_mem_block__iclk    ) ,
    .ireset  ( codec_mem_block__ireset  ) ,
    .iclkena ( codec_mem_block__iclkena ) ,
    //
    .iwrite  ( codec_mem_block__iwrite  ) ,
    .iwaddr  ( codec_mem_block__iwaddr  ) ,
    .iwdat   ( codec_mem_block__iwdat   ) ,
    //
    .iraddr  ( codec_mem_block__iraddr  ) ,
    .ordat   ( codec_mem_block__ordat   )
  );


  assign codec_mem_block__iclk    = '0 ;
  assign codec_mem_block__ireset  = '0 ;
  assign codec_mem_block__iclkena = '0 ;
  //
  assign codec_mem_block__iwrite  = '0 ;
  assign codec_mem_block__iwaddr  = '0 ;
  assign codec_mem_block__iwdat   = '0 ;
  //
  assign codec_mem_block__iraddr  = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_mem_block.sv
// Description   : Simple dual port ram with optional pipeline register
//


module codec_mem_block
#(
  parameter int pADDR_W = 8 ,
  parameter int pDAT_W  = 8 ,
  parameter bit pPIPE   = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iwrite  ,
  iwaddr  ,
  iwdat   ,
  //
  iraddr  ,
  ordat
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
  input  logic  [pDAT_W-1 : 0] iwdat    ;
  //
  input  logic [pADDR_W-1 : 0] iraddr   ;
  output logic  [pDAT_W-1 : 0] ordat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit   [pDAT_W-1 : 0] mem  [2**pADDR_W] /* synthesis ramstyle = "no_rw_check" */;
  logic [pDAT_W-1 : 0] rdat [2];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      rdat[0] <= mem[iraddr];
      rdat[1] <= rdat[0];
      //
      if (iwrite) begin
        mem[iwaddr] <= iwdat;
      end
    end
  end

  assign ordat = rdat[pPIPE];

endmodule
