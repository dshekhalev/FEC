/*



  parameter bit pUSE_L_POLY = 0 ;
  parameter int pTAG_W      = 8 ;



  logic                b_bch_dec_cand_gen__iclk    ;
  logic                b_bch_dec_cand_gen__ireset  ;
  logic                b_bch_dec_cand_gen__iclkena ;
  //
  logic                b_bch_dec_cand_gen__isop    ;
  logic                b_bch_dec_cand_gen__isof    ;
  logic                b_bch_dec_cand_gen__ival    ;
  logic                b_bch_dec_cand_gen__ieop    ;
  logic                b_bch_dec_cand_gen__ieof    ;
  logic [cDAT_W-1 : 0] b_bch_dec_cand_gen__idat    ;
  //
  logic                b_bch_dec_cand_gen__osop    ;
  logic                b_bch_dec_cand_gen__osof    ;
  logic                b_bch_dec_cand_gen__oval    ;
  logic                b_bch_dec_cand_gen__oeop    ;
  logic                b_bch_dec_cand_gen__oeof    ;
  logic                b_bch_dec_cand_gen__odat    ;



  b_bch_dec_cand_gen
  #(
    .pUSE_L_POLY ( pUSE_L_POLY ) ,
    .pTAG_W      ( pTAG_W      )
  )
  b_bch_dec_cand_gen
  (
    .iclk    ( b_bch_dec_cand_gen__iclk    ) ,
    .ireset  ( b_bch_dec_cand_gen__ireset  ) ,
    .iclkena ( b_bch_dec_cand_gen__iclkena ) ,
    //
    .isop    ( b_bch_dec_cand_gen__isop    ) ,
    .isof    ( b_bch_dec_cand_gen__isof    ) ,
    .ival    ( b_bch_dec_cand_gen__ival    ) ,
    .ieop    ( b_bch_dec_cand_gen__ieop    ) ,
    .ieof    ( b_bch_dec_cand_gen__ieof    ) ,
    .idat    ( b_bch_dec_cand_gen__idat    ) ,
    //
    .osop    ( b_bch_dec_cand_gen__osop    ) ,
    .osof    ( b_bch_dec_cand_gen__osof    ) ,
    .oval    ( b_bch_dec_cand_gen__oval    ) ,
    .oeop    ( b_bch_dec_cand_gen__oeop    ) ,
    .oeof    ( b_bch_dec_cand_gen__oeof    ) ,
    .odat    ( b_bch_dec_cand_gen__odat    )
  );


  assign b_bch_dec_cand_gen__iclk    = '0 ;
  assign b_bch_dec_cand_gen__ireset  = '0 ;
  assign b_bch_dec_cand_gen__iclkena = '0 ;
  assign b_bch_dec_cand_gen__isop    = '0 ;
  assign b_bch_dec_cand_gen__isof    = '0 ;
  assign b_bch_dec_cand_gen__ival    = '0 ;
  assign b_bch_dec_cand_gen__ieop    = '0 ;
  assign b_bch_dec_cand_gen__ieof    = '0 ;
  assign b_bch_dec_cand_gen__idat    = '0 ;



*/

//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_dec_cand_gen.svh
// Description   : candidate codeword generator for decoder
//

module b_bch_dec_cand_gen
#(
  parameter bit pUSE_L_POLY = 0 ,
  parameter int pTAG_W      = 8
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  isof    ,
  ival    ,
  ieop    ,
  ieof    ,
  idat    ,
  //
  osop    ,
  osof    ,
  oval    ,
  oeop    ,
  oeof    ,
  odat
);

  `include "b_bch_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W = cDBIT_NUM[pUSE_L_POLY];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                isop    ;
  input  logic                isof    ;
  input  logic                ival    ;
  input  logic                ieop    ;
  input  logic                ieof    ;
  input  logic [cDAT_W-1 : 0] idat    ;
  //
  output logic                osop    ;
  output logic                osof    ;
  output logic                oval    ;
  output logic                oeop    ;
  output logic                oeof    ;
  output logic                odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [cDAT_W-1 : 0] dat;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        osop <= isop;
        osof <= isof;
        oeop <= ieop;
        oeof <= ieof;
        //
        if (isop) begin
          for (int i = 0; i < cDAT_W; i++) begin
            dat[i] <= idat[cDAT_W-1-i];     // msb first (!!!)
          end
        end
        else begin
          dat           <= (dat >> 1);
          dat[cDAT_W-1] <= encode_bit(dat, pUSE_L_POLY);
        end
      end
    end
  end

  assign odat = dat[0];

endmodule
