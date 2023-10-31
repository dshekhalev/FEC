/*



  parameter int pADDR_W = 256 ;
  parameter int pDAT_W  =   8 ;
  parameter bit pNO_REG =   0 ;


  logic                 codec_mem__iclk     ;
  logic                 codec_mem__ireset   ;
  logic                 codec_mem__iclkena  ;
  //
  logic                 codec_mem__iwrite   ;
  logic [pADDR_W-1 : 0] codec_mem__iwaddr   ;
  logic  [pDAT_W-1 : 0] codec_mem__iwdat    ;
  //
  logic [pADDR_W-1 : 0] codec_mem__iraddr   ;
  logic  [pDAT_W-1 : 0] codec_mem__ordat    ;



  btc_dec_mem
  #(
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pNO_REG ( pNO_REG )
  )
  btc_dec_mem
  (
    .iclk    ( codec_mem__iclk    ) ,
    .ireset  ( codec_mem__ireset  ) ,
    .iclkena ( codec_mem__iclkena ) ,
    //
    .iwrite  ( codec_mem__iwrite  ) ,
    .iwaddr  ( codec_mem__iwaddr  ) ,
    .iwdat   ( codec_mem__iwdat   ) ,
    //
    .iraddr  ( codec_mem__iraddr  ) ,
    .ordat   ( codec_mem__ordat   )
  );


  assign codec_mem__iclk    = '0 ;
  assign codec_mem__ireset  = '0 ;
  assign codec_mem__iclkena = '0 ;
  //
  assign codec_mem__iwrite  = '0 ;
  assign codec_mem__iwaddr  = '0 ;
  assign codec_mem__iwdat   = '0 ;
  //
  assign codec_mem__iraddr  = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_mem.sv
// Description   : simple small sized ram with output delay 0/1 tick


module btc_dec_mem
#(
  parameter int pADDR_W = 8 ,
  parameter int pDAT_W  = 8 ,
  parameter bit pNO_REG = 0
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

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iwrite) begin
        mem[iwaddr] <= iwdat;
      end
    end
  end

  generate
    if (pNO_REG) begin
      assign ordat = mem[iraddr];
    end
    else begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          ordat <= mem[iraddr];
        end
      end
    end
  endgenerate

endmodule
