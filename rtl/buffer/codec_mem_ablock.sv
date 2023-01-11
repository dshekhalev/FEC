/*



  parameter int pADDR_W = 256 ;
  parameter int pDAT_W  =   8 ;
  parameter bit pPIPE   =   1 ;



  logic                 codec_mem_ablock__ireset   ;
  //
  logic                 codec_mem_ablock__iwclk    ;
  logic                 codec_mem_ablock__iwclkena ;
  logic                 codec_mem_ablock__iwrite   ;
  logic [pADDR_W-1 : 0] codec_mem_ablock__iwaddr   ;
  logic  [pDAT_W-1 : 0] codec_mem_ablock__iwdat    ;
  //
  logic                 codec_mem_ablock__irclk    ;
  logic                 codec_mem_ablock__irclkena ;
  logic [pADDR_W-1 : 0] codec_mem_ablock__iraddr   ;
  logic  [pDAT_W-1 : 0] codec_mem_ablock__ordat    ;



  codec_mem_ablock
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pPIPE   ( pPIPE   )
  )
  codec_mem_ablock
  (
    .ireset   ( codec_mem_ablock__ireset   ) ,
    //
    .iwclk    ( codec_mem_ablock__iwclk    ) ,
    .iwclkena ( codec_mem_ablock__iwclkena ) ,
    .iwrite   ( codec_mem_ablock__iwrite   ) ,
    .iwaddr   ( codec_mem_ablock__iwaddr   ) ,
    .iwdat    ( codec_mem_ablock__iwdat    ) ,
    //
    .irclk    ( codec_mem_ablock__irclk    ) ,
    .irclkena ( codec_mem_ablock__irclkena ) ,
    .iraddr   ( codec_mem_ablock__iraddr   ) ,
    .ordat    ( codec_mem_ablock__ordat    )
  );


  assign codec_mem_ablock__ireset   = '0 ;
  //
  assign codec_mem_ablock__iwclk    = '0 ;
  assign codec_mem_ablock__iwclkena = '0 ;
  assign codec_mem_ablock__iwrite   = '0 ;
  assign codec_mem_ablock__iwaddr   = '0 ;
  assign codec_mem_ablock__iwdat    = '0 ;
  //
  assign codec_mem_ablock__irclk    = '0 ;
  assign codec_mem_ablock__irclkena = '0 ;
  assign codec_mem_ablock__iraddr   = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_mem_ablock.sv
// Description   : Simple dual clock (asynchronus) dual port ram with optional pipeline register
//


module codec_mem_ablock
#(
  parameter int pADDR_W = 256 ,
  parameter int pDAT_W  =   8 ,
  parameter bit pPIPE   =   1
)
(
  ireset    ,
  //
  iwclk     ,
  iwclkena  ,
  iwrite    ,
  iwaddr    ,
  iwdat     ,
  //
  irclk     ,
  irclkena  ,
  iraddr    ,
  ordat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 ireset   ;
  //
  input  logic                 iwclk    ;
  input  logic                 iwclkena ;
  input  logic                 iwrite   ;
  input  logic [pADDR_W-1 : 0] iwaddr   ;
  input  logic  [pDAT_W-1 : 0] iwdat    ;
  //
  input  logic                 irclk    ;
  input  logic                 irclkena ;
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

  always_ff @(posedge irclk) begin
    if (irclkena) begin
      rdat[0] <= mem[iraddr];
      rdat[1] <= rdat[0];
    end
  end

  assign ordat = rdat[pPIPE];

  always_ff @(posedge iwclk) begin
    if (iwclkena) begin
      if (iwrite) begin
        mem[iwaddr] <= iwdat;
      end
    end
  end

endmodule
