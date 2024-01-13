/*






  logic           super_i3_enc__iclk    ;
  logic           super_i3_enc__ireset  ;
  logic           super_i3_enc__iclkena ;
  //
  logic           super_i3_enc__ival    ;
  logic           super_i3_enc__isop    ;
  logic [127 : 0] super_i3_enc__idat    ;
  //
  logic           super_i3_enc__oval    ;
  logic           super_i3_enc__osop    ;
  logic [127 : 0] super_i3_enc__odat    ;



  super_i3_enc
  super_i3_enc
  (
    .iclk    ( super_i3_enc__iclk    ) ,
    .ireset  ( super_i3_enc__ireset  ) ,
    .iclkena ( super_i3_enc__iclkena ) ,
    //
    .ival    ( super_i3_enc__ival    ) ,
    .isop    ( super_i3_enc__isop    ) ,
    .idat    ( super_i3_enc__idat    ) ,
    //
    .oval    ( super_i3_enc__oval    ) ,
    .osop    ( super_i3_enc__osop    ) ,
    .odat    ( super_i3_enc__odat    )
  );


  assign super_i3_enc__iclk    = '0 ;
  assign super_i3_enc__ireset  = '0 ;
  assign super_i3_enc__iclkena = '0 ;
  assign super_i3_enc__ival    = '0 ;
  assign super_i3_enc__isop    = '0 ;
  assign super_i3_enc__idat    = '0 ;



*/

//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_enc.sv
// Description   : I.3 Concatenated BCH super FEC codes encoder top level
//

module super_i3_enc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  idat    ,
  //
  oval    ,
  osop    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk    ;
  input  logic           ireset  ;
  input  logic           iclkena ;
  //
  input  logic           ival    ;
  input  logic           isop    ;
  input  logic [127 : 0] idat    ;
  //
  output logic           oval    ;
  output logic           osop    ;
  output logic [127 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // outer encoder
  logic           outer_enc__ival [8] ;
  logic           outer_enc__isop [8] ;
  logic  [15 : 0] outer_enc__idat [8] ;
  //
  logic           outer_enc__oval [8] ;
  logic           outer_enc__osop [8] ;
  logic           outer_enc__oeop [8] ;
  logic  [15 : 0] outer_enc__odat [8] ;

  // interleaver
  logic           interleave__ival    ;
  logic           interleave__isop    ;
  logic [127 : 0] interleave__idat    ;
  //
  logic           interleave__oval    ;
  logic           interleave__osop    ;
  logic [127 : 0] interleave__odat    ;

  // inner encoder
  logic           inner_enc__ival [16] ;
  logic           inner_enc__isop [16] ;
  logic   [7 : 0] inner_enc__idat [16] ;
  //
  logic           inner_enc__oval [16] ;
  logic           inner_enc__osop [16] ;
  logic   [7 : 0] inner_enc__odat [16] ;

  //------------------------------------------------------------------------------------------------------
  // outer encoder array 8x255*16
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < 8; g++) begin
      super_i3_bch_outer_enc
      outer_enc
      (
        .iclk    ( iclk                ) ,
        .ireset  ( ireset              ) ,
        .iclkena ( iclkena             ) ,
        //
        .ival    ( outer_enc__ival [g] ) ,
        .isop    ( outer_enc__isop [g] ) ,
        .idat    ( outer_enc__idat [g] ) ,
        //
        .oval    ( outer_enc__oval [g] ) ,
        .osop    ( outer_enc__osop [g] ) ,
        .oeop    ( outer_enc__oeop [g] ) ,
        .odat    ( outer_enc__odat [g] )
      );

      assign outer_enc__ival[g] = ival;
      assign outer_enc__isop[g] = isop;

      always_comb begin
        for (int i = 0; i < 16; i++) begin
          outer_enc__idat[g][i] = idat[i*8 + g];
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // interleave
  //------------------------------------------------------------------------------------------------------

  super_i3_interleave
  #(
    .pDEINT_MODE ( 0 ) ,
    .pPIPE       ( 0 )
  )
  interleave
  (
    .iclk    ( iclk             ) ,
    .ireset  ( ireset           ) ,
    .iclkena ( iclkena          ) ,
    //
    .ival    ( interleave__ival ) ,
    .isop    ( interleave__isop ) ,
    .idat    ( interleave__idat ) ,
    //
    .oval    ( interleave__oval ) ,
    .osop    ( interleave__osop ) ,
    .odat    ( interleave__odat )
  );

  always_comb begin
    interleave__ival = outer_enc__oval[0];
    interleave__isop = outer_enc__osop[0];
    for (int i = 0; i < 128; i++) begin
      interleave__idat[i] = outer_enc__odat[i % 8][i / 8];
    end
    // last word (128bit) differ
    if (outer_enc__oeop[0]) begin
      for (int i = 0; i < 8; i++) begin
        interleave__idat[i*16 +: 16] = outer_enc__odat[i];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // inner encoder array 16x255*8
  //------------------------------------------------------------------------------------------------------

  generate
    for (g = 0; g < 16; g++) begin
      super_i3_bch_inner_enc
      inner_enc
      (
        .iclk    ( iclk                ) ,
        .ireset  ( ireset              ) ,
        .iclkena ( iclkena             ) ,
        //
        .ival    ( inner_enc__ival [g] ) ,
        .isop    ( inner_enc__isop [g] ) ,
        .idat    ( inner_enc__idat [g] ) ,
        //
        .oval    ( inner_enc__oval [g] ) ,
        .osop    ( inner_enc__osop [g] ) ,
        .odat    ( inner_enc__odat [g] )
      );

      assign inner_enc__ival[g] = interleave__oval;
      assign inner_enc__isop[g] = interleave__osop;

      assign inner_enc__idat[g] = interleave__odat[g*8 +: 8];
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // output mappig
  //------------------------------------------------------------------------------------------------------

  assign oval = inner_enc__oval[0];
  assign osop = inner_enc__osop[0];

  always_comb begin
    for (int i = 0; i < 16; i++) begin
      odat[i*8 +: 8] = inner_enc__odat[i];
    end
  end

endmodule
