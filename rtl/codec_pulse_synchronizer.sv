/*



  parameter int pLENGTH = 4;



  logic codec_pulse_synchronizer__clkin    ;
  logic codec_pulse_synchronizer__resetin  ;
  logic codec_pulse_synchronizer__sin      ;
  //
  logic codec_pulse_synchronizer__clkout   ;
  logic codec_pulse_synchronizer__resetout ;
  logic codec_pulse_synchronizer__sout     ;



  codec_pulse_synchronizer
  #(
    .pLENGTH ( pLENGTH )
  )
  codec_pulse_synchronizer
  (
    .clkin    ( codec_pulse_synchronizer__clkin    ) ,
    .resetin  ( codec_pulse_synchronizer__resetin  ) ,
    .sin      ( codec_pulse_synchronizer__sin      ) ,
    //
    .clkout   ( codec_pulse_synchronizer__clkout   ) ,
    .resetout ( codec_pulse_synchronizer__resetout ) ,
    .sout     ( codec_pulse_synchronizer__sout     )
  );


  assign codec_pulse_synchronizer__clkin    = '0 ;
  assign codec_pulse_synchronizer__resetin  = '0 ;
  assign codec_pulse_synchronizer__sin      = '0 ;
  //
  assign codec_pulse_synchronizer__clkout   = '0 ;
  assign codec_pulse_synchronizer__resetout = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_pulse_synchronizer.sv
// Description   : Pulse synchronizer with loop back
//

module codec_pulse_synchronizer
#(
  parameter int pLENGTH = 4
)
(
  clkin    ,
  resetin  ,
  sin      ,
  //
  clkout   ,
  resetout ,
  sout
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic clkin    ;
  input  logic resetin  ;
  input  logic sin      ;
  //
  input  logic clkout   ;
  input  logic resetout ;
  output logic sout     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic level         ; // RS level triger for input pulses
  logic level_clrin   ;
  logic level_clrout  ;

  logic         [1:0] dffin;  // clkout -> clk_in synronizer for level clear feedback
  logic [pLENGTH-1:0] dffout; // clkin -> clkout syncronizer for level

  //------------------------------------------------------------------------------------------------------
  // Input converter edge/level clkin -> level clkin
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge clkin or posedge resetin) begin
    if (resetin)
      level <= 1'b0;
    else if (sin)
      level <= 1'b1;
    else if (level_clrin)
      level <= 1'b0;
  end

  //------------------------------------------------------------------------------------------------------
  // Forward syncronizer level clkin -> edge clkout
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge clkout or posedge resetout) begin
    if (resetout)
      dffout <=0;
    else
      dffout <= {dffout[pLENGTH-2:0], level};
  end

  assign sout           = ~dffout[pLENGTH-1] & dffout[pLENGTH-2]; // posedge
  assign level_clrout   =  dffout[pLENGTH-2];

  //------------------------------------------------------------------------------------------------------
  // Feedback syncronizer level clkout -> level clkin
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge clkin or posedge resetin) begin
    if (resetin)
      dffin <= 0;
    else
      dffin <= {dffin[0], level_clrout};
  end

  assign level_clrin = dffin[1];

endmodule
