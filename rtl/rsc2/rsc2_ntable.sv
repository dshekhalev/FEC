/*



  parameter pW = 13 ;



  logic    [5 : 0] rsc2_ntable__iptype ;
  logic [pW-1 : 0] rsc2_ntable__oN     ;
  logic [pW-1 : 0] rsc2_ntable__oNm1   ;




  rsc2_ntable
  #(
    .pW ( pW )
  )
  rsc2_ntable
  (
    .iptype ( rsc2_ntable__iptype ) ,
    .oN     ( rsc2_ntable__oN     ) ,
    .oNm1   ( rsc2_ntable__oNm1   )
  );


  assign rsc2_ntable__iptype  = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_ntable.sv
// Description   : Packet length in duobits parameters table.
//

module rsc2_ntable
#(
  parameter pW  = 13  // fixed, don't change
)
(
  iptype ,
  //
  oN     ,
  oNm1
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic    [5 : 0] iptype ; // permutation type [ 0: 33] - reordered Table A-1/2/4/5
  //
  output logic [pW-1 : 0] oN     ; // used data pair size
  output logic [pW-1 : 0] oNm1   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "rsc2_dvb_ptable.svh"

  typedef int        used_tab_t     [2];  // {N, Nm1}
  typedef used_tab_t used_tab_dvb_t [cDVB_PTABLE_SIZE];

  localparam used_tab_dvb_t cUSED_DVB_NTABLE = get_dvb_ntable(0);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function used_tab_dvb_t get_dvb_ntable (input int pipa);
    for (int i = 0; i < cDVB_PTABLE_SIZE; i++) begin
      get_dvb_ntable[i][0] = cDVB_PTABLE[i][5];
      get_dvb_ntable[i][1] = cDVB_PTABLE[i][5] - 1;
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // length decoding
  //------------------------------------------------------------------------------------------------------

  assign oN   = cUSED_DVB_NTABLE[iptype][0][pW-1 : 0];
  assign oNm1 = cUSED_DVB_NTABLE[iptype][1][pW-1 : 0];

endmodule
