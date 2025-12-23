/*



  parameter int pDAT_W    = 1 ;
  parameter int pIDX_W    = 1 ;
  parameter int pIDX_NUM  = 1 ;



  logic                golay24_dec_sort_list__iclk               ;
  logic                golay24_dec_sort_list__ireset             ;
  logic                golay24_dec_sort_list__iclkena            ;
  logic                golay24_dec_sort_list__iload              ;
  logic                golay24_dec_sort_list__ival               ;
  logic [pDAT_W-1 : 0] golay24_dec_sort_list__idat               ;
  logic [pIDX_W-1 : 0] golay24_dec_sort_list__iidx               ;
  logic [pDAT_W-1 : 0] golay24_dec_sort_list__pdat    [pIDX_NUM] ;
  logic [pIDX_W-1 : 0] golay24_dec_sort_list__oidx    [pIDX_NUM] ;



  golay24_dec_sort_list
  #(
    .pDAT_W   ( pDAT_W   ) ,
    .pIDX_W   ( pIDX_W   ) ,
    .pIDX_NUM ( pIDX_NUM )
  )
  golay24_dec_sort_list
  (
    .iclk    ( golay24_dec_sort_list__iclk    ) ,
    .ireset  ( golay24_dec_sort_list__ireset  ) ,
    .iclkena ( golay24_dec_sort_list__iclkena ) ,
    .iload   ( golay24_dec_sort_list__iload   ) ,
    .ival    ( golay24_dec_sort_list__ival    ) ,
    .idat    ( golay24_dec_sort_list__idat    ) ,
    .iidx    ( golay24_dec_sort_list__iidx    ) ,
    .odat    ( golay24_dec_sort_list__odat    ) ,
    .oidx    ( golay24_dec_sort_list__oidx    )
  );


  assign golay24_dec_sort_list__iclk    = '0 ;
  assign golay24_dec_sort_list__ireset  = '0 ;
  assign golay24_dec_sort_list__iclkena = '0 ;
  assign golay24_dec_sort_list__iload   = '0 ;
  assign golay24_dec_sort_list__ival    = '0 ;
  assign golay24_dec_sort_list__idat    = '0 ;
  assign golay24_dec_sort_list__iidx    = '0 ;



*/

//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Workfile      : golay24_dec_sort_list.sv
// Description   : unsigned data sequential ascending sort top module. take 1 cycle to make decision
//

module golay24_dec_sort_list
#(
  parameter int pDAT_W    = 1 ,
  parameter int pIDX_W    = 1 ,
  parameter int pIDX_NUM  = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iload   ,
  ival    ,
  idat    ,
  iidx    ,
  //
  odat    ,
  oidx
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk               ;
  input  logic                ireset             ;
  input  logic                iclkena            ;
  //
  input  logic                iload              ;
  input  logic                ival               ;
  input  logic [pDAT_W-1 : 0] idat               ;
  input  logic [pIDX_W-1 : 0] iidx               ;
  //
  output logic [pDAT_W-1 : 0] odat    [pIDX_NUM] ;
  output logic [pIDX_W-1 : 0] oidx    [pIDX_NUM] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                sort__icarry_prev [pIDX_NUM] ;
  logic [pDAT_W-1 : 0] sort__idat_prev   [pIDX_NUM] ;
  logic [pIDX_W-1 : 0] sort__iidx_prev   [pIDX_NUM] ;

  logic                sort__ocarry      [pIDX_NUM] ;
  logic [pDAT_W-1 : 0] sort__odat        [pIDX_NUM] ;
  logic [pIDX_W-1 : 0] sort__oidx        [pIDX_NUM] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    genvar i;
    for (i = 0; i < pIDX_NUM; i++) begin : sort_unit_gen
      golay24_dec_sort_list_cell
      #(
        .pDAT_W      ( pDAT_W   ) ,
        .pIDX_W      ( pIDX_W   ) ,
        .pUP_NDOWN   ( 0        ) , // minimum -> [0]
        .pINIT_NLOAD ( (i != 0) )
      )
      sort
      (
        .iclk        ( iclk                  ) ,
        .ireset      ( ireset                ) ,
        .iclkena     ( iclkena               ) ,
        //
        .iload       ( iload                 ) ,
        .ival        ( ival                  ) ,
        .idat        ( idat                  ) ,
        .iidx        ( iidx                  ) ,
        //
        .icarry_prev ( sort__icarry_prev [i] ) ,
        .idat_prev   ( sort__idat_prev   [i] ) ,
        .iidx_prev   ( sort__iidx_prev   [i] ) ,
        //
        .ocarry      ( sort__ocarry      [i] ) ,
        .odat        ( sort__odat        [i] ) ,
        .oidx        ( sort__oidx        [i] )
      );

      if (i == 0) begin
        assign sort__icarry_prev[i] = 1'b0;
        assign sort__idat_prev  [i] = '0  ;
        assign sort__iidx_prev  [i] = '0  ;
      end
      else begin
        assign sort__icarry_prev[i] = sort__ocarry[i-1];
        assign sort__idat_prev  [i] = sort__odat  [i-1];
        assign sort__iidx_prev  [i] = sort__oidx  [i-1];
      end
    end
  endgenerate

  assign odat = sort__odat;
  assign oidx = sort__oidx;

endmodule
