/*



  parameter  pW  = 13 ;



  logic            rsc2_ptable__iclk        ;
  logic            rsc2_ptable__ireset      ;
  logic            rsc2_ptable__iclkena     ;
  logic    [5 : 0] rsc2_ptable__iptype      ;
  logic [pW-1 : 0] rsc2_ptable__oN          ;
  logic [pW-1 : 0] rsc2_ptable__oNm1        ;
  logic    [3 : 0] rsc2_ptable__oNmod15     ;
  logic [pW-1 : 0] rsc2_ptable__oP      [4] ;
  logic [pW-1 : 0] rsc2_ptable__oP0comp     ;
  logic [pW-1 : 0] rsc2_ptable__oPincr      ;




  rsc2_ptable
  #(
    .pW ( pW )
  )
  rsc2_ptable
  (
    .iclk    ( rsc2_ptable__iclk    ) ,
    .ireset  ( rsc2_ptable__ireset  ) ,
    .iclkena ( rsc2_ptable__iclkena ) ,
    .iptype  ( rsc2_ptable__iptype  ) ,
    .oN      ( rsc2_ptable__oN      ) ,
    .oNm1    ( rsc2_ptable__oNm1    ) ,
    .oNmod15 ( rsc2_ptable__oNmod15 ) ,
    .oP      ( rsc2_ptable__oP      ) ,
    .oP0comp ( rsc2_ptable__oP0comp ) ,
    .oPincr  ( rsc2_ptable__oPincr  )
  );


  assign rsc2_ptable__iclk    = '0 ;
  assign rsc2_ptable__ireset  = '0 ;
  assign rsc2_ptable__iclkena = '0 ;
  assign rsc2_ptable__iptype  = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_ptable.sv
// Description   : Permutation parameters table. There is static tables for DVB  permutation parameters,
//                 special parameters for decoder permutation, circulation state LUT selector.
//                 It takes 2 clock cycles to apply new parameters
//

module rsc2_ptable
#(
  parameter pW  = 13  // fixed, don't change
)
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  iptype     ,
  //
  oN         ,
  oNm1       ,
  oNmod15    ,
  //
  oP         ,
  oP0comp    ,
  oPincr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk        ;
  input  logic            ireset      ;
  input  logic            iclkena     ;
  //
  input  logic    [5 : 0] iptype      ; // permutation type [ 0: 33] - reordered Table A-1/2/4/5
  //
  output logic [pW-1 : 0] oN          ; // used data pair size
  output logic [pW-1 : 0] oNm1        ;
  output logic    [3 : 0] oNmod15     ;
  //
  output logic [pW-1 : 0] oP      [4] ;
  output logic [pW-1 : 0] oP0comp     ; // complement oP[0] for backward recursion address process
  output logic [pW-1 : 0] oPincr      ; // base increment for address counter at j = 0

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "rsc2_dvb_ptable.svh"

  typedef int        used_tab_t     [6];  // {P0, P1, P2, P3, N, Nmod15}
  typedef used_tab_t used_tab_dvb_t [cDVB_PTABLE_SIZE];

  localparam used_tab_dvb_t cUSED_DVB_PTABLE = get_dvb_ptable(0);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function used_tab_dvb_t get_dvb_ptable (input int pipa);
    for (int i = 0; i < cDVB_PTABLE_SIZE; i++) begin
      get_dvb_ptable[i][0] = cDVB_PTABLE[i][0];

      get_dvb_ptable[i][1] = (3 + 4 *  cDVB_PTABLE[i][2]                                         ) % cDVB_PTABLE[i][5];
      get_dvb_ptable[i][2] = (3 + 4 * (cDVB_PTABLE[i][1] * cDVB_PTABLE[i][0] + cDVB_PTABLE[i][3])) % cDVB_PTABLE[i][5];
      get_dvb_ptable[i][3] = (3 + 4 * (cDVB_PTABLE[i][1] * cDVB_PTABLE[i][0] + cDVB_PTABLE[i][4])) % cDVB_PTABLE[i][5];

      get_dvb_ptable[i][4] = cDVB_PTABLE[i][5];
      get_dvb_ptable[i][5] = cDVB_PTABLE[i][5] % 15;
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // 1 tick parameter decoding
  //------------------------------------------------------------------------------------------------------

  // increment for permutation address generator
  assign oPincr = 3;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // detect permutation paramters
      oP[0]   <= cUSED_DVB_PTABLE[iptype][0][pW-1 : 0];
      oP[1]   <= cUSED_DVB_PTABLE[iptype][1][pW-1 : 0];
      oP[2]   <= cUSED_DVB_PTABLE[iptype][2][pW-1 : 0];
      oP[3]   <= cUSED_DVB_PTABLE[iptype][3][pW-1 : 0];
      // detect length
      oN      <= cUSED_DVB_PTABLE[iptype][4][pW-1 : 0];
      // get circulation state LUT selector
      oNmod15 <= cUSED_DVB_PTABLE[iptype][5][3 : 0];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // 2 tick cycle parameter decoding
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // detect permutation complement for P[0]
      oP0comp <= oN - oP[0];
      oNm1    <= oN - 1'b1;
    end
  end

endmodule
