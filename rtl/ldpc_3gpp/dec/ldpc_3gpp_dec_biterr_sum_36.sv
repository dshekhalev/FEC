/*



  parameter int pERR_W = 16 ;



  logic                ldpc_3gpp_dec_biterr_sum_36__iclk    ;
  logic                ldpc_3gpp_dec_biterr_sum_36__ireset  ;
  logic                ldpc_3gpp_dec_biterr_sum_36__iclkena ;
  //
  logic                ldpc_3gpp_dec_biterr_sum_36__ival    ;
  logic       [35 : 0] ldpc_3gpp_dec_biterr_sum_36__ibiterr ;
  //
  logic                ldpc_3gpp_dec_biterr_sum_36__oval    ;
  logic [pERR_W-1 : 0] ldpc_3gpp_dec_biterr_sum_36__oerr    ;



  ldpc_3gpp_dec_biterr_sum_36
  #(
    .pERR_W ( pERR_W )
  )
  ldpc_3gpp_dec_biterr_sum_36
  (
    .iclk    ( ldpc_3gpp_dec_biterr_sum_36__iclk    ) ,
    .ireset  ( ldpc_3gpp_dec_biterr_sum_36__ireset  ) ,
    .iclkena ( ldpc_3gpp_dec_biterr_sum_36__iclkena ) ,
    //
    .ival    ( ldpc_3gpp_dec_biterr_sum_36__ival    ) ,
    .ibiterr ( ldpc_3gpp_dec_biterr_sum_36__ibiterr ) ,
    //
    .oval    ( ldpc_3gpp_dec_biterr_sum_36__oval    ) ,
    .oerr    ( ldpc_3gpp_dec_biterr_sum_36__oerr    )
  );


  assign ldpc_3gpp_dec_biterr_sum_36__iclk    = '0 ;
  assign ldpc_3gpp_dec_biterr_sum_36__ireset  = '0 ;
  assign ldpc_3gpp_dec_biterr_sum_36__iclkena = '0 ;
  assign ldpc_3gpp_dec_biterr_sum_36__ival    = '0 ;
  assign ldpc_3gpp_dec_biterr_sum_36__ibiterr = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_biterr_sum_36.sv
// Description   : 36 bit vector ones bits sum with look like optimal architecure
//

module ldpc_3gpp_dec_biterr_sum_36
#(
  parameter int pERR_W = 16
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  ibiterr ,
  //
  oval    ,
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
  input  logic       [35 : 0] ibiterr ;
  //
  output logic                oval    ;
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
      oerr <= sum36;
    end
  end

endmodule

