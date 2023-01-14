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
    if (resetin) begin
      level <= 1'b0;
    end
    else if (sin) begin
      level <= 1'b1;
    end
    else if (level_clrin) begin
      level <= 1'b0;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Forward syncronizer level clkin -> edge clkout
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge clkout or posedge resetout) begin
    if (resetout) begin
      dffout <= '0;
    end
    else begin
      dffout <= {dffout[pLENGTH-2:0], level};
    end
  end

  assign sout           = ~dffout[pLENGTH-1] & dffout[pLENGTH-2]; // posedge
  assign level_clrout   =  dffout[pLENGTH-2];

  //------------------------------------------------------------------------------------------------------
  // Feedback syncronizer level clkout -> level clkin
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge clkin or posedge resetin) begin
    if (resetin) begin
      dffin <= '0;
    end
    else begin
      dffin <= {dffin[0], level_clrout};
    end
  end

  assign level_clrin = dffin[1];

endmodule
