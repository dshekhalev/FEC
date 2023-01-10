/*



  parameter int pADDR_W  = 8 ;
  parameter int pDATA_W  = 8 ;
  parameter int pBNUM_W  = 1 ;
  parameter bit pPIPE    = 0 ;



  logic                 bch_buffer__iclk    ;
  logic                 bch_buffer__ireset  ;
  logic                 bch_buffer__iclkena ;
  logic                 bch_buffer__iwrite  ;
  logic [pADDR_W-1 : 0] bch_buffer__iwaddr  ;
  logic [pBNUM_W-1 : 0] bch_buffer__iwptr   ;
  logic [pDATA_W-1 : 0] bch_buffer__iwdata  ;
  logic                 bch_buffer__iread   ;
  logic [pADDR_W-1 : 0] bch_buffer__iraddr  ;
  logic [pBNUM_W-1 : 0] bch_buffer__irptr   ;
  logic [pDATA_W-1 : 0] bch_buffer__ordata  ;



  bch_buffer
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDATA_W ( pDATA_W ) ,
    .pBNUM_W ( pBNUM_W ) ,
    .pPIPE   ( pPIPE   )
  )
  bch_buffer
  (
    .iclk    ( bch_buffer__iclk    ) ,
    .ireset  ( bch_buffer__ireset  ) ,
    .iclkena ( bch_buffer__iclkena ) ,
    .iwrite  ( bch_buffer__iwrite  ) ,
    .iwaddr  ( bch_buffer__iwaddr  ) ,
    .iwptr   ( bch_buffer__iwptr   ) ,
    .iwdata  ( bch_buffer__iwdata  ) ,
    .iread   ( bch_buffer__iread   ) ,
    .iraddr  ( bch_buffer__iraddr  ) ,
    .irptr   ( bch_buffer__irptr   ) ,
    .ordata  ( bch_buffer__ordata  )
  );


  assign bch_buffer__iclk     = '0 ;
  assign bch_buffer__ireset   = '0 ;
  assign bch_buffer__iclkena  = '0 ;
  assign bch_buffer__iwrite   = '0 ;
  assign bch_buffer__iwaddr   = '0 ;
  assign bch_buffer__iwptr    = '0 ;
  assign bch_buffer__iwdata   = '0 ;
  assign bch_buffer__iread    = '0 ;
  assign bch_buffer__iraddr   = '0 ;
  assign bch_buffer__irptr    = '0 ;



*/

//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_buffer.sv
// Description   : BCH decoder ram buffer with external sub buffer controls
//


module bch_buffer
#(
  parameter int pADDR_W  = 8 ,
  parameter int pDATA_W  = 8 ,
  parameter int pBNUM_W  = 1 ,
  parameter bit pPIPE    = 0
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  iwrite  ,
  iwaddr  ,
  iwptr   ,
  iwdata  ,
  iread   ,
  iraddr  ,
  irptr   ,
  ordata
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk    ;
  input  logic                 ireset  ;
  input  logic                 iclkena ;
  input  logic                 iwrite  ;
  input  logic [pADDR_W-1 : 0] iwaddr  ;
  input  logic [pBNUM_W-1 : 0] iwptr   ;
  input  logic [pDATA_W-1 : 0] iwdata  ;
  input  logic                 iread   ;
  input  logic [pADDR_W-1 : 0] iraddr  ;
  input  logic [pBNUM_W-1 : 0] irptr   ;
  output logic [pDATA_W-1 : 0] ordata  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cRAM_ADDR_W  = pADDR_W + pBNUM_W;
  localparam int cRAM_DATA_W  = pDATA_W;

  bit   [cRAM_DATA_W-1 : 0] ram      [2**cRAM_ADDR_W] /* synthesis ramstyle = "no_rw_check" */;
  bit   [cRAM_DATA_W-1 : 0] ram_pipe [2];

  logic [cRAM_ADDR_W-1 : 0] ram_waddr;
  logic [cRAM_ADDR_W-1 : 0] ram_raddr;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ram_waddr = {iwptr, iwaddr};
  assign ram_raddr = {irptr, iraddr};

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite) begin
        ram[ram_waddr] <= iwdata;
      end
      ram_pipe[0] <= ram[ram_raddr];
      ram_pipe[1] <= ram_pipe[0];
    end
  end

  assign ordata = ram_pipe[pPIPE];

endmodule
