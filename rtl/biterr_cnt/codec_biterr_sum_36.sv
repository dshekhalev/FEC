/*



  parameter int pERR_W = 16 ;



  logic                codec_biterr_sum_36__iclk    ;
  logic                codec_biterr_sum_36__ireset  ;
  logic                codec_biterr_sum_36__iclkena ;
  //
  logic                codec_biterr_sum_36__ival    ;
  logic                codec_biterr_sum_36__isop    ;
  logic                codec_biterr_sum_36__ieop    ;
  logic       [35 : 0] codec_biterr_sum_36__ibiterr ;
  //
  logic                codec_biterr_sum_36__oval    ;
  logic                codec_biterr_sum_36__osop    ;
  logic                codec_biterr_sum_36__oeop    ;
  logic [pERR_W-1 : 0] codec_biterr_sum_36__oerr    ;



  codec_biterr_sum_36
  #(
    .pERR_W ( pERR_W )
  )
  codec_biterr_sum_36
  (
    .iclk    ( codec_biterr_sum_36__iclk    ) ,
    .ireset  ( codec_biterr_sum_36__ireset  ) ,
    .iclkena ( codec_biterr_sum_36__iclkena ) ,
    //
    .ival    ( codec_biterr_sum_36__ival    ) ,
    .isop    ( codec_biterr_sum_36__isop    ) ,
    .ieop    ( codec_biterr_sum_36__ieop    ) ,
    .ibiterr ( codec_biterr_sum_36__ibiterr ) ,
    //
    .oval    ( codec_biterr_sum_36__oval    ) ,
    .osop    ( codec_biterr_sum_36__osop    ) ,
    .oeop    ( codec_biterr_sum_36__oeop    ) ,
    .oerr    ( codec_biterr_sum_36__oerr    )
  );


  assign codec_biterr_sum_36__iclk    = '0 ;
  assign codec_biterr_sum_36__ireset  = '0 ;
  assign codec_biterr_sum_36__iclkena = '0 ;
  assign codec_biterr_sum_36__ival    = '0 ;
  assign codec_biterr_sum_36__isop    = '0 ;
  assign codec_biterr_sum_36__ieop    = '0 ;
  assign codec_biterr_sum_36__ibiterr = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_biterr_sum_36.sv
// Description   : 36 bit vector ones bits sum with look like optimal architecure
//

module codec_biterr_sum_36
#(
  parameter int pERR_W = 16
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  ieop    ,
  ibiterr ,
  //
  oval    ,
  osop    ,
  oeop    ,
  oerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                ival    ;
  input  logic                isop    ;
  input  logic                ieop    ;
  input  logic       [35 : 0] ibiterr ;
  //
  output logic                oval    ;
  output logic                osop    ;
  output logic                oeop    ;
  output logic [pERR_W-1 : 0] oerr    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [2 : 0] sum6    [6];

  logic [5 : 0] sum36_b [3];
  logic [5 : 0] sum36;

  //------------------------------------------------------------------------------------------------------
  // adder "tree"
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    logic [5 : 0] tmp6;
    // get partial sums of 6 bits
    for (int layer = 0; layer < 6; layer++) begin
      sum6[layer] = '0;
      for (int b = 0; b < 6; b++) begin
        sum6[layer] += ibiterr[6*layer + b];
      end
    end
    // get partial sums of weigned bits
    for (int b = 0; b < 3; b++) begin
      tmp6 = '0;
      for (int layer = 0; layer < 6; layer++) begin
        tmp6 += sum6[layer][b];
      end
      sum36_b[b] = tmp6;
    end
    // get output sum
    sum36 = sum36_b[0] + (sum36_b[1] << 1) + (sum36_b[2] << 2);
  end

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
      osop <= isop;
      oeop <= ieop;
      oerr <= sum36;
    end
  end

endmodule

