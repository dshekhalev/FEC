/*



  parameter int pLENGTH = 4;



  logic  codec_reset_synchronizer__clk            ;
  logic  codec_reset_synchronizer__reset_carry_in ;
  logic  codec_reset_synchronizer__reset_in       ;
  logic  codec_reset_synchronizer__reset_out      ;



  codec_reset_synchronizer
  #(
    .pLENGTH ( pLENGTH )
  )
  codec_reset_synchronizer
  (
    .clk            ( codec_reset_synchronizer__clk            ) ,
    .reset_carry_in ( codec_reset_synchronizer__reset_carry_in ) ,
    .reset_in       ( codec_reset_synchronizer__reset_in       ) ,
    .reset_out      ( codec_reset_synchronizer__reset_out      )
  );


  assign codec_reset_synchronizer__clk            = '0 ;
  assign codec_reset_synchronizer__reset_carry_in = '0 ;
  assign codec_reset_synchronizer__reset_in       = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_reset_synchronizer.sv
// Description   : reset synchronizer with reset carry in to use in asynchronus codecs
//

module codec_reset_synchronizer
#(
  parameter int pLENGTH = 4
)
(
  clk             ,
  reset_carry_in  ,
  reset_in        ,
  reset_out
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  clk           ;
  input  logic  reset_in      ;
  input  logic  reset_carry_in;
  output logic  reset_out     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pLENGTH-1:0] reset_srl;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge clk or posedge reset_in) begin : reset_shift_register
    if (reset_in) begin
      reset_srl <= '1;
    end
    else begin
      reset_srl <= (reset_srl << 1) | reset_carry_in;
    end
  end

  assign reset_out = reset_srl[$high(reset_srl)];

endmodule
