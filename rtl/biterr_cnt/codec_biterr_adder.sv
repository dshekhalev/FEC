/*



  parameter int pERR_W = 16 ;
  parameter int pD_W   =  4 ;



  logic                codec_biterr_adder__iclk              ;
  logic                codec_biterr_adder__ireset            ;
  logic                codec_biterr_adder__iclkena           ;
  //
  logic                codec_biterr_adder__ival              ;
  logic                codec_biterr_adder__isop              ;
  logic                codec_biterr_adder__ieop              ;
  logic [pERR_W-1 : 0] codec_biterr_adder__ierr    [2**pD_W] ;
  //
  logic                codec_biterr_adder__oval              ;
  logic                codec_biterr_adder__osop              ;
  logic                codec_biterr_adder__oeop              ;
  logic [pERR_W-1 : 0] codec_biterr_adder__oerr              ;



  codec_biterr_adder
  #(
    .pERR_W ( pERR_W ) ,
    .pD_W   ( pD_W   )
  )
  codec_biterr_adder
  (
    .iclk    ( codec_biterr_adder__iclk    ) ,
    .ireset  ( codec_biterr_adder__ireset  ) ,
    .iclkena ( codec_biterr_adder__iclkena ) ,
    //
    .ival    ( codec_biterr_adder__ival    ) ,
    .isop    ( codec_biterr_adder__isop    ) ,
    .ieop    ( codec_biterr_adder__ieop    ) ,
    .ierr    ( codec_biterr_adder__ierr    ) ,
    //
    .oval    ( codec_biterr_adder__oval    ) ,
    .osop    ( codec_biterr_adder__osop    ) ,
    .oeop    ( codec_biterr_adder__oeop    ) ,
    .oerr    ( codec_biterr_adder__oerr    )
  );


  assign codec_biterr_adder__iclk    = '0 ;
  assign codec_biterr_adder__ireset  = '0 ;
  assign codec_biterr_adder__iclkena = '0 ;
  assign codec_biterr_adder__ival    = '0 ;
  assign codec_biterr_adder__isop    = '0 ;
  assign codec_biterr_adder__ieop    = '0 ;
  assign codec_biterr_adder__ierr    = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_biterr_adder.sv
// Description   : adder tree for bit error counting
//

module codec_biterr_adder
#(
  parameter int pERR_W = 16 ,
  parameter int pD_W   =  4
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  ieop    ,
  ierr    ,
  //
  oval    ,
  osop    ,
  oeop    ,
  oerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk              ;
  input  logic                ireset            ;
  input  logic                iclkena           ;
  //
  input  logic                ival              ;
  input  logic                isop              ;
  input  logic                ieop              ;
  input  logic [pERR_W-1 : 0] ierr    [2**pD_W] ;
  //
  output logic                oval              ;
  output logic                osop              ;
  output logic                oeop              ;
  output logic [pERR_W-1 : 0] oerr              ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                adder__ival      ;
  logic                adder__isop      ;
  logic                adder__ieop      ;
  logic [pERR_W-1 : 0] adder__ierr  [2] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pD_W == 1) begin
      always_ff @(posedge iclk or posedge ireset) begin
        if (ireset) begin
          oval <= 1'b0;
        end
        else if (iclkena) begin
          oval <= ival;
        end
      end
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          osop <= isop;
          oeop <= ieop;
          oerr <= ierr[0] + ierr[1];
        end
      end
    end
    else if (pD_W == 0) begin
      assign oval = ival;
      assign osop = isop;
      assign oeop = ieop;
      assign oerr = ierr[0];
    end
    else begin
      logic [pERR_W-1 : 0] adder0__ierr [2**(pD_W-1)];
      logic [pERR_W-1 : 0] adder1__ierr [2**(pD_W-1)];
      //
      assign adder0__ierr = ierr[0           +: 2**(pD_W-1)] ;
      assign adder1__ierr = ierr[2**(pD_W-1) +: 2**(pD_W-1)] ;
      //
      codec_biterr_adder
      #(
        .pERR_W ( pERR_W ) ,
        .pD_W   ( pD_W-1 )
      )
      adder0
      (
        .iclk    ( iclk             ) ,
        .ireset  ( ireset           ) ,
        .iclkena ( iclkena          ) ,
        //
        .ival    ( ival             ) ,
        .isop    ( isop             ) ,
        .ieop    ( ieop             ) ,
        .ierr    ( adder0__ierr     ) ,
        //
        .oval    ( adder__ival      ) ,
        .osop    ( adder__isop      ) ,
        .oeop    ( adder__ieop      ) ,
        .oerr    ( adder__ierr  [0] )
      );
      //
      codec_biterr_adder
      #(
        .pERR_W ( pERR_W ) ,
        .pD_W   ( pD_W-1 )
      )
      adder1
      (
        .iclk    ( iclk             ) ,
        .ireset  ( ireset           ) ,
        .iclkena ( iclkena          ) ,
        //
        .ival    ( ival             ) ,
        .isop    ( isop             ) ,
        .ieop    ( ieop             ) ,
        .ierr    ( adder1__ierr     ) ,
        //
        .oval    (                  ) ,
        .osop    (                  ) ,
        .oeop    (                  ) ,
        .oerr    ( adder__ierr [1]  )
      );
      //
      codec_biterr_adder
      #(
        .pERR_W ( pERR_W ) ,
        .pD_W   ( 1      )
      )
      adder
      (
        .iclk    ( iclk        ) ,
        .ireset  ( ireset      ) ,
        .iclkena ( iclkena     ) ,
        //
        .ival    ( adder__ival ) ,
        .isop    ( adder__isop ) ,
        .ieop    ( adder__ieop ) ,
        .ierr    ( adder__ierr ) ,
        //
        .oval    ( oval        ) ,
        .osop    ( osop        ) ,
        .oeop    ( oeop        ) ,
        .oerr    ( oerr        )
      );
    end
  endgenerate

endmodule
