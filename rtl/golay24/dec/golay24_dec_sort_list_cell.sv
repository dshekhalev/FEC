/*



  parameter int pDAT_W      = 4 ;
  parameter int pIDX_W      = 5 ;
  parameter bit pUP_NDOWN   = 0 ;
  parameter bit pINIT_NLOAD = 1 ;



  logic                golay24_dec_sort_list_cell__iclk         ;
  logic                golay24_dec_sort_list_cell__ireset       ;
  logic                golay24_dec_sort_list_cell__iclkena      ;
  logic                golay24_dec_sort_list_cell__iload        ;
  logic                golay24_dec_sort_list_cell__ival         ;
  logic [pDAT_W-1 : 0] golay24_dec_sort_list_cell__idat         ;
  logic [pIDX_W-1 : 0] golay24_dec_sort_list_cell__iidx         ;
  logic                golay24_dec_sort_list_cell__icarry_prev  ;
  logic [pDAT_W-1 : 0] golay24_dec_sort_list_cell__idat_prev    ;
  logic [pIDX_W-1 : 0] golay24_dec_sort_list_cell__iidx_prev    ;
  logic                golay24_dec_sort_list_cell__ocarry       ;
  logic [pDAT_W-1 : 0] golay24_dec_sort_list_cell__odat         ;
  logic [pIDX_W-1 : 0] golay24_dec_sort_list_cell__oidx         ;



  golay24_dec_sort_list_cell
  #(
    .pDAT_W      ( pDAT_W      ) ,
    .pIDX_W      ( pIDX_W      ) ,
    .pUP_NDOWN   ( pUP_NDOWN   ) ,
    .pINIT_NLOAD ( pINIT_NLOAD )
  )
  golay24_dec_sort_list_cell
  (
    .iclk        ( golay24_dec_sort_list_cell__iclk        ) ,
    .ireset      ( golay24_dec_sort_list_cell__ireset      ) ,
    .iclkena     ( golay24_dec_sort_list_cell__iclkena     ) ,
    .iload       ( golay24_dec_sort_list_cell__iload       ) ,
    .ival        ( golay24_dec_sort_list_cell__ival        ) ,
    .idat        ( golay24_dec_sort_list_cell__idat        ) ,
    .iidx        ( golay24_dec_sort_list_cell__iidx        ) ,
    .icarry_prev ( golay24_dec_sort_list_cell__icarry_prev ) ,
    .idat_prev   ( golay24_dec_sort_list_cell__idat_prev   ) ,
    .iidx_prev   ( golay24_dec_sort_list_cell__iidx prev   ) ,
    .ocarry      ( golay24_dec_sort_list_cell__ocarry      ) ,
    .odat        ( golay24_dec_sort_list_cell__odat        ) ,
    .oidx        ( golay24_dec_sort_list_cell__oidx        )
  );


  assign golay24_dec_sort_list_cell__iclk        = '0 ;
  assign golay24_dec_sort_list_cell__ireset      = '0 ;
  assign golay24_dec_sort_list_cell__iclkena     = '0 ;
  assign golay24_dec_sort_list_cell__iload       = '0 ;
  assign golay24_dec_sort_list_cell__ival        = '0 ;
  assign golay24_dec_sort_list_cell__idat        = '0 ;
  assign golay24_dec_sort_list_cell__iidx        = '0 ;
  assign golay24_dec_sort_list_cell__icarry_prev = '0 ;
  assign golay24_dec_sort_list_cell__idat_prev   = '0 ;
  assign golay24_dec_sort_list_cell__iidx_prev   = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Workfile      : golay24_dec_sort_list_cell.sv
// Description   : unsigned data sequential sort module engine. take 1 cycle to make decision
//

module golay24_dec_sort_list_cell
#(
  parameter int pDAT_W      = 1 ,
  parameter int pIDX_W      = 1 ,
  parameter bit pUP_NDOWN   = 0 , // sort direction up(0)/down(1)
  parameter bit pINIT_NLOAD = 1   // init (min/max) or data load (0)
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  iload       ,
  ival        ,
  idat        ,
  iidx        ,
  //
  icarry_prev ,
  idat_prev   ,
  iidx_prev   ,
  //
  ocarry      ,
  odat        ,
  oidx
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk         ;
  input  logic                ireset       ;
  input  logic                iclkena      ;
  //
  input  logic                iload        ;
  input  logic                ival         ;
  input  logic [pDAT_W-1 : 0] idat         ;  // unsigned value
  input  logic [pIDX_W-1 : 0] iidx         ;
  //
  input  logic                icarry_prev  ;
  input  logic [pDAT_W-1 : 0] idat_prev    ;  // unsigned value
  input  logic [pIDX_W-1 : 0] iidx_prev    ;
  //
  output logic                ocarry       ;
  output logic [pDAT_W-1 : 0] odat         ;  // unsigned value
  output logic [pIDX_W-1 : 0] oidx         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ocarry = pUP_NDOWN ? (idat > odat) : (idat < odat);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      odat <= '0;
      oidx <= '0;
    end
    else if (iclkena) begin
      if (iload) begin
        oidx <= pINIT_NLOAD ? '0 : iidx;
        odat <= pINIT_NLOAD ? ~{pDAT_W{pUP_NDOWN}} : idat;
      end
      else if (ival & ocarry) begin
        odat <= icarry_prev ? idat_prev : idat;
        oidx <= icarry_prev ? iidx_prev : iidx;
      end
    end
  end

endmodule
