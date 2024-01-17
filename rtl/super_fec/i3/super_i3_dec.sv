/*



  parameter int pITER     = 1 ;
  parameter bit pENDPOINT = 1 ;



  logic           super_i3_dec__iclk     ;
  logic           super_i3_dec__ireset   ;
  logic           super_i3_dec__iclkena  ;
  //
  logic           super_i3_dec__ival     ;
  logic           super_i3_dec__isop     ;
  logic [127 : 0] super_i3_dec__idat     ;
  //
  logic           super_i3_dec__oval     ;
  logic           super_i3_dec__osop     ;
  logic [127 : 0] super_i3_dec__odat     ;
  //
  logic           super_i3_dec__odecval0 ;
  logic   [7 : 0] super_i3_dec__odecerr0 ;
  //
  logic           super_i3_dec__odecval1 ;
  logic   [7 : 0] super_i3_dec__odecerr1 ;



  super_i3_dec
  #(
    .pITER     ( pITER     ) ,
    .pENDPOINT ( pENDPOINT )
  )
  super_i3_dec
  (
    .iclk     ( super_i3_dec__iclk     ) ,
    .ireset   ( super_i3_dec__ireset   ) ,
    .iclkena  ( super_i3_dec__iclkena  ) ,
    //
    .ival     ( super_i3_dec__ival     ) ,
    .isop     ( super_i3_dec__isop     ) ,
    .idat     ( super_i3_dec__idat     ) ,
    //
    .oval     ( super_i3_dec__oval     ) ,
    .osop     ( super_i3_dec__osop     ) ,
    .odat     ( super_i3_dec__odat     ) ,
    //
    .odecval0 ( super_i3_dec__odecval0 ) ,
    .odecerr0 ( super_i3_dec__odecerr0 ) ,
    //
    .odecval1 ( super_i3_dec__odecval1 ) ,
    .odecerr1 ( super_i3_dec__odecerr1 )
  );


  assign super_i3_dec__iclk    = '0 ;
  assign super_i3_dec__ireset  = '0 ;
  assign super_i3_dec__iclkena = '0 ;
  assign super_i3_dec__ival    = '0 ;
  assign super_i3_dec__isop    = '0 ;
  assign super_i3_dec__idat    = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_dec.sv
// Description   : I.3 Concatenated BCH super FEC codes decoder top level
//                 decoder iteration based upon discard correction if current frame decfail occured
//                 no correction discard beetwen iterations
//

module super_i3_dec
#(
  parameter int pITER     = 3 , // number of decoder interation >= 1
  parameter bit pENDPOINT = 1   // endpoint mode (data payload at output) or transit mode (corrected input frame at output)
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  ival     ,
  isop     ,
  idat     ,
  //
  oval     ,
  osop     ,
  odat     ,
  //
  odecval0 ,
  odecerr0 ,
  //
  odecval1 ,
  odecerr1
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk     ;
  input  logic           ireset   ;
  input  logic           iclkena  ;
  //
  input  logic           ival     ;
  input  logic           isop     ;
  input  logic [127 : 0] idat     ;
  //
  output logic           oval     ;
  output logic           osop     ;
  output logic [127 : 0] odat     ;
  //
  output logic           odecval0 ;
  output logic   [7 : 0] odecerr0 ;
  //
  output logic           odecval1 ;
  output logic   [7 : 0] odecerr1 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // inner decoder
  logic           inner_dec__ival    [pITER] ;
  logic           inner_dec__isop    [pITER] ;
  logic [127 : 0] inner_dec__idat    [pITER] ;
  //
  logic           inner_dec__oval    [pITER] ;
  logic           inner_dec__osop    [pITER] ;
  logic           inner_dec__oeop    [pITER] ;
  logic [127 : 0] inner_dec__odat    [pITER] ;
  //
  logic   [7 : 0] inner_dec__odecerr [pITER] ;

  // deinterleaver
  logic           deinterleave__ival [pITER] ;
  logic           deinterleave__isop [pITER] ;
  logic [127 : 0] deinterleave__idat [pITER] ;
  //
  logic           deinterleave__oval [pITER] ;
  logic           deinterleave__osop [pITER] ;
  logic [127 : 0] deinterleave__odat [pITER] ;

  // outer decoder
  logic           outer_dec__ival    [pITER] ;
  logic           outer_dec__isop    [pITER] ;
  logic [127 : 0] outer_dec__idat    [pITER] ;
  //
  logic           outer_dec__oval    [pITER] ;
  logic           outer_dec__osop    [pITER] ;
  logic           outer_dec__oeop    [pITER] ;
  logic [127 : 0] outer_dec__odat    [pITER] ;
  //
  logic   [7 : 0] outer_dec__odecerr [pITER] ;

  // interleaver (-1 to prevent synthesis warning)
  logic           interleave__ival   [pITER] ;
  logic           interleave__isop   [pITER] ;
  logic [127 : 0] interleave__idat   [pITER] ;
  //
  logic           interleave__oval   [pITER] ;
  logic           interleave__osop   [pITER] ;
  logic [127 : 0] interleave__odat   [pITER] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < pITER; g++) begin : dec_gen_inst

      //------------------------------------------------------------------------------------------------------
      // inner decoder
      //------------------------------------------------------------------------------------------------------

      super_i3_bch_inner_dec
      #(
        .pERR_W ( 8 )
      )
      inner_dec
      (
        .iclk     ( iclk                    ) ,
        .ireset   ( ireset                  ) ,
        .iclkena  ( iclkena                 ) ,
        //
        .ival     ( inner_dec__ival     [g] ) ,
        .isop     ( inner_dec__isop     [g] ) ,
        .idat     ( inner_dec__idat     [g] ) ,
        //
        .oval     ( inner_dec__oval     [g] ) ,
        .osop     ( inner_dec__osop     [g] ) ,
        .oeop     ( inner_dec__oeop     [g] ) ,
        .odat     ( inner_dec__odat     [g] ) ,
        //
        .odecerr  ( inner_dec__odecerr  [g] )
      );

      if (g == 0) begin
        assign inner_dec__ival[g] = ival;
        assign inner_dec__isop[g] = isop;
        assign inner_dec__idat[g] = idat;
      end
      else begin
        assign inner_dec__ival[g] = interleave__oval[g-1];
        assign inner_dec__isop[g] = interleave__osop[g-1];
        assign inner_dec__idat[g] = interleave__odat[g-1];
      end

      //------------------------------------------------------------------------------------------------------
      // deinterleaver
      //------------------------------------------------------------------------------------------------------

      super_i3_interleave
      #(
        .pDEINT_MODE ( 1 ) ,
        .pPIPE       ( 0 )
      )
      deinterleave
      (
        .iclk    ( iclk                   ) ,
        .ireset  ( ireset                 ) ,
        .iclkena ( iclkena                ) ,
        //
        .ival    ( deinterleave__ival [g] ) ,
        .isop    ( deinterleave__isop [g] ) ,
        .idat    ( deinterleave__idat [g] ) ,
        //
        .oval    ( deinterleave__oval [g] ) ,
        .osop    ( deinterleave__osop [g] ) ,
        .odat    ( deinterleave__odat [g] )
      );

      assign deinterleave__ival[g] = inner_dec__oval[g];
      assign deinterleave__isop[g] = inner_dec__osop[g];
      assign deinterleave__idat[g] = inner_dec__odat[g];

      //------------------------------------------------------------------------------------------------------
      // outer decoder
      //------------------------------------------------------------------------------------------------------

      super_i3_bch_outer_dec
      #(
        .pERR_W ( 8 )
      )
      outer_dec
      (
        .iclk     ( iclk                    ) ,
        .ireset   ( ireset                  ) ,
        .iclkena  ( iclkena                 ) ,
        //
        .ival     ( outer_dec__ival     [g] ) ,
        .isop     ( outer_dec__isop     [g] ) ,
        .idat     ( outer_dec__idat     [g] ) ,
        //
        .oval     ( outer_dec__oval     [g] ) ,
        .osop     ( outer_dec__osop     [g] ) ,
        .oeop     ( outer_dec__oeop     [g] ) ,
        .odat     ( outer_dec__odat     [g] ) ,
        //
        .odecerr  ( outer_dec__odecerr  [g] )
      );

      assign outer_dec__ival[g] = deinterleave__oval[g];
      assign outer_dec__isop[g] = deinterleave__osop[g];
      assign outer_dec__idat[g] = deinterleave__odat[g];

      //------------------------------------------------------------------------------------------------------
      // interleaver
      //------------------------------------------------------------------------------------------------------

      if (!pENDPOINT | (g < pITER-1)) begin
        super_i3_interleave
        #(
          .pDEINT_MODE ( 0 ) ,
          .pPIPE       ( 0 )
        )
        interleave
        (
          .iclk    ( iclk                 ) ,
          .ireset  ( ireset               ) ,
          .iclkena ( iclkena              ) ,
          //
          .ival    ( interleave__ival [g] ) ,
          .isop    ( interleave__isop [g] ) ,
          .idat    ( interleave__idat [g] ) ,
          //
          .oval    ( interleave__oval [g] ) ,
          .osop    ( interleave__osop [g] ) ,
          .odat    ( interleave__odat [g] )
        );
      end

      assign interleave__ival[g] = outer_dec__oval[g];
      assign interleave__isop[g] = outer_dec__osop[g];
      assign interleave__idat[g] = outer_dec__odat[g];

    end
  endgenerate

  assign oval = pENDPOINT ? outer_dec__oval[pITER-1] : interleave__oval[pITER-1];
  assign osop = pENDPOINT ? outer_dec__osop[pITER-1] : interleave__osop[pITER-1];
  assign odat = pENDPOINT ? outer_dec__odat[pITER-1] : interleave__odat[pITER-1];

  assign odecval0 = inner_dec__osop   [pITER-1];
  assign odecerr0 = inner_dec__odecerr[pITER-1];

  assign odecval1 = outer_dec__osop   [pITER-1];
  assign odecerr1 = outer_dec__odecerr[pITER-1];

endmodule
