/*






  logic           g709_enc__iclk    ;
  logic           g709_enc__ireset  ;
  logic           g709_enc__iclkena ;
  //
  logic           g709_enc__ival    ;
  logic           g709_enc__isop    ;
  logic [127 : 0] g709_enc__idat    ;
  //
  logic           g709_enc__oval    ;
  logic           g709_enc__osop    ;
  logic [127 : 0] g709_enc__odat    ;



  g709_enc
  g709_enc
  (
    .iclk    ( g709_enc__iclk    ) ,
    .ireset  ( g709_enc__ireset  ) ,
    .iclkena ( g709_enc__iclkena ) ,
    //
    .ival    ( g709_enc__ival    ) ,
    .isop    ( g709_enc__isop    ) ,
    .idat    ( g709_enc__idat    ) ,
    //
    .oval    ( g709_enc__oval    ) ,
    .osop    ( g709_enc__osop    ) ,
    .odat    ( g709_enc__odat    )
  );


  assign g709_enc__iclk    = '0 ;
  assign g709_enc__ireset  = '0 ;
  assign g709_enc__iclkena = '0 ;
  assign g709_enc__ival    = '0 ;
  assign g709_enc__isop    = '0 ;
  assign g709_enc__idat    = '0 ;



*/

//
// Project       : fec (G.709)
// Author        : Shekhalev Denis (des00)
// Workfile      : g709_enc.sv
// Description   : 16-byte interleaved RS(255,239) encoder top level
//

module g709_enc
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

  `include "g709_types.svh"

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

  localparam int cCNT_W = 8;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  struct packed {
    logic                eof;
    logic                eop;
    logic [cCNT_W-1 : 0] value;
  } cnt;

  // enc array
  logic         enc__isop [16] ;
  logic         enc__ival [16] ;
  logic         enc__ieop [16] ;
  logic         enc__ieof [16] ;
  logic [7 : 0] enc__idat [16] ;
  //
  logic         enc__osop [16] ;
  logic         enc__oval [16] ;
  logic         enc__oeop [16] ;
  logic [7 : 0] enc__odat [16] ;

  //------------------------------------------------------------------------------------------------------
  // input framer
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (isop) begin
          cnt <= 1'b1; // look forward
        end
        else begin
          cnt.value <= cnt.eof ? '0 : (cnt.value + 1'b1);
          cnt.eop   <= (cnt.value == cN-cCHECK-2);
          cnt.eof   <= (cnt.value == cN-2);
        end
      end
    end
  end

  always_comb begin
    for (int i = 0; i < 16; i++) begin
      enc__isop [i] = isop;
      enc__ival [i] = ival;
      enc__ieop [i] = cnt.eop & !isop;
      enc__ieof [i] = cnt.eof & !isop;
      enc__idat [i] = idat[8*i +: 8];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // encoder array
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < 16; g++) begin : enc_inst_gen
      rs_enc
      #(
        .n         ( cN         ) ,
        .check     ( cCHECK     ) ,
        .m         ( cM         ) ,
        .irrpol    ( cIRRPOL    ) ,
        .genstart  ( cGENSTART  ) ,
        .rootspace ( cROOTSPACE )
      )
      enc
      (
        .iclk    ( iclk          ) ,
        .ireset  ( ireset        ) ,
        .iclkena ( iclkena       ) ,
        //
        .isop    ( enc__isop [g] ) ,
        .ival    ( enc__ival [g] ) ,
        .ieop    ( enc__ieop [g] ) ,
        .ieof    ( enc__ieof [g] ) ,
        .idat    ( enc__idat [g] ) ,
        //
        .osop    ( enc__osop [g] ) ,
        .oval    ( enc__oval [g] ) ,
        .oeop    ( enc__oeop [g] ) ,
        .odat    ( enc__odat [g] )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    oval = enc__oval[0];
    osop = enc__osop[0];
    //
    for (int i = 0; i < 16; i++) begin
      odat[i*8 +: 8] = enc__odat[i];
    end
  end

endmodule
