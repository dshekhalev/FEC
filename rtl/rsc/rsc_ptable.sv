/*



  parameter  pW  = 13 ;



  logic            rsc_ptable__iclk            ;
  logic            rsc_ptable__ireset          ;
  logic            rsc_ptable__iclkena         ;
  logic    [4 : 0] rsc_ptable__iptype          ;
  logic [pW-1 : 0] rsc_ptable__iN              ;
  logic [pW-1 : 0] rsc_ptable__oN              ;
  logic [pW-1 : 0] rsc_ptable__oNm1            ;
  logic    [2 : 0] rsc_ptable__oNmod7          ;
  logic [pW-1 : 0] rsc_ptable__oP      [0 : 3] ;
  logic [pW-1 : 0] rsc_ptable__oP0comp         ;
  logic [pW-1 : 0] rsc_ptable__oPincr          ;
  logic            rsc_ptable__oPdvbinv        ;
  logic [pW-1 : 0] rsc_ptable__oPAx2_comp      ;




  rsc_ptable ;
  #(
    .pW ( pW )
  )
  rsc_ptable
  (
    .iclk       ( rsc_ptable__iclk       ) ,
    .ireset     ( rsc_ptable__ireset     ) ,
    .iclkena    ( rsc_ptable__iclkena    ) ,
    .iptype     ( rsc_ptable__iptype     ) ,
    .iN         ( rsc_ptable__iN         ) ,
    .oN         ( rsc_ptable__oN         ) ,
    .oNm1       ( rsc_ptable__oNm1       ) ,
    .oNmod7     ( rsc_ptable__oNmod7     ) ,
    .oP         ( rsc_ptable__oP         ) ,
    .oP0comp    ( rsc_ptable__oP0comp    ) ,
    .oPincr     ( rsc_ptable__oPincr     ) ,
    .oPdvbinv   ( rsc_ptable__oPdvbinv   ) ,
    .oPAx2_comp ( rsc_ptable__oPAx2_comp )
  );


  assign rsc_ptable__iclk    = '0 ;
  assign rsc_ptable__ireset  = '0 ;
  assign rsc_ptable__iclkena = '0 ;
  assign rsc_ptable__iptype  = '0 ;
  assign rsc_ptable__iN      = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_ptable.sv
// Description   : Permutation parameters table. There is static tables for DVB/WimaxA permutation parameters,
//                 logic to count permutation parameters for Wimax, special parameters for decoder permutation,
//                 circulation state LUT selector.
//

module rsc_ptable
#(
  parameter pW  = 13  // fixed, don't change
)
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  iptype     ,
  iN         ,
  //
  oN         ,
  oNm1       ,
  oNmod7     ,
  //
  oP         ,
  oP0comp    ,
  oPincr     ,
  oPdvbinv   ,
  //
  oPAx2_comp
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk            ;
  input  logic            ireset          ;
  input  logic            iclkena         ;
  //
  input  logic    [4 : 0] iptype          ; // permutation type [ 0:11] - DVB     P0/P1/P2/P3,
                                            //                  [12:15] - WiMax   P0 = 7/11/13/17
                                            //                  [16:31] - WimaxA  P0/P1/P2/P3,
  input  logic [pW-1 : 0] iN              ; // data pair/byte size [32:4096]/[8:1024]
  //
  output logic [pW-1 : 0] oN              ; // used data pair size
  output logic [pW-1 : 0] oNm1            ;
  output logic    [2 : 0] oNmod7          ;
  //
  output logic [pW-1 : 0] oP      [0 : 3] ;
  output logic [pW-1 : 0] oP0comp         ; // complement oP[0] for backward recursion address process
  output logic [pW-1 : 0] oPincr          ; // base increment for address counter DVB/WimaxA == 1/Wimax == P0 + 1
  output logic            oPdvbinv        ; // DVB and Wimax use differ dbits inversion scheme
  //
  output logic [pW-1 : 0] oPAx2_comp      ; // complement permutation address offset for x2 decoder

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef int   tab_t   [ 0 :  4];
  typedef tab_t tabd_t  [ 0 : 11];
  typedef tab_t tabw_t  [12 : 15];
  typedef tab_t tabwa_t [ 0 : 15];

  //
  // {P0, P1, P2, P3, N}
  localparam tabd_t cDVB_PTABLE = '{
    '{ 11,  24,   0,  24,  48 } ,
    '{  7,  34,  32,   2,  64 } ,
    '{ 13, 106, 108,   2, 212 } ,
    '{ 23, 112,   4, 116, 220 } ,
    '{ 17, 116,  72, 188, 228 } ,
    '{ 11,   6,   8,   2, 424 } ,
    '{ 13,   0,   4,   8, 432 } ,
    '{ 13,  10,   4,   2, 440 } ,
    '{ 19,   2,  16,   6, 848 } ,
    '{ 19, 428, 224, 652, 856 } ,
    '{ 19,   2,  16,   6, 864 } ,
    '{ 19, 376, 224, 600, 752 }
  };

  localparam tabwa_t cWIMAXA_PTABLE = '{
    '{  5,   0,   0,   0,   24 } ,
    '{ 11,  18,   0,  18,   36 } ,
    '{ 13,  24,   0,  24,   48 } ,
    '{ 11,   6,   0,   6,   72 } ,
    '{  7,  48,  24,  72,   96 } ,
    '{ 11,  54,  56,   2,  108 } ,
    '{ 13,  60,   0,  60,  120 } ,
    '{ 17,  74,  72,   2,  144 } ,
    '{ 11,  90,   0,  90,  180 } ,
    '{ 11,  96,  48, 144,  192 } ,
    '{ 13, 108,   0, 108,  216 } ,
    '{ 13, 120,  60, 180,  240 } ,
    '{ 53,  62,  12,   2,  480 } ,
    '{ 43,  64, 300, 824,  960 } ,
    '{ 43, 720, 360, 540, 1440 } ,
    '{ 31,   8,  24,  16, 1920 }
//  '{ 53,  66,  24,   2, 2400 }
  };

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  tab_t  dvb;
  tab_t wimaxa;

  // for DVB/WimaxA  {P0, (N/2 + P1 + 1) % N,  P2 + 1, (N/2 + P3 + 1) % N}
  always_comb begin
    int dvb_sel;
    int wimaxa_sel;
    //
    dvb_sel    = (iptype[3:0] >= 12) ? '0 : iptype[3 : 0];
    wimaxa_sel = iptype[3:0];
    //
    dvb[0]    =  cDVB_PTABLE[dvb_sel][0];
    dvb[1]    = (cDVB_PTABLE[dvb_sel][4]/2 + cDVB_PTABLE[dvb_sel][1] + 1) % cDVB_PTABLE[dvb_sel][4];
    dvb[2]    =  cDVB_PTABLE[dvb_sel][2] + 1;
    dvb[3]    = (cDVB_PTABLE[dvb_sel][4]/2 + cDVB_PTABLE[dvb_sel][3] + 1) % cDVB_PTABLE[dvb_sel][4];
    dvb[4]    =  cDVB_PTABLE[dvb_sel][4];
    //
    wimaxa[0] =  cWIMAXA_PTABLE[wimaxa_sel][0];
    wimaxa[1] = (cWIMAXA_PTABLE[wimaxa_sel][4]/2 + cWIMAXA_PTABLE[wimaxa_sel][1] + 1) % cWIMAXA_PTABLE[wimaxa_sel][4];
    wimaxa[2] =  cWIMAXA_PTABLE[wimaxa_sel][2] + 1;
    wimaxa[3] = (cWIMAXA_PTABLE[wimaxa_sel][4]/2 + cWIMAXA_PTABLE[wimaxa_sel][3] + 1) % cWIMAXA_PTABLE[wimaxa_sel][4];
    wimaxa[4] =  cWIMAXA_PTABLE[wimaxa_sel][4];
  end

  tab_t wim;

  // for WiMax  {P0, N/4 + 1 + P0, (N/2 + P1 + 1 + P0) % N, 1 + P0}, P1 = 3*N/4
  always_comb begin
    int P0;
    //
    P0 = 7;
    //
    case (iptype[3:0])
      12 : P0 = 7;
      13 : P0 = 11;
      14 : P0 = 13;
      15 : P0 = 17;
    endcase
    //
    wim[0] = P0;
    wim[1] = (iN/4 + 1) + P0;
    wim[2] = (iN/4 + 1) + P0;
    wim[3] = 1 + P0;
  end

  //------------------------------------------------------------------------------------------------------
  // 1 tick parameter decoding
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    if (iptype[4]) begin // wimaxa
      // detect permutation paramters
      oP[0] = wimaxa[0][pW-1 : 0];
      oP[1] = wimaxa[1][pW-1 : 0];
      oP[2] = wimaxa[2][pW-1 : 0];
      oP[3] = wimaxa[3][pW-1 : 0];
      // detect wimaxa length
      oN    = wimaxa[4][pW-1 : 0];
    end
    else begin // dbm/wimax
      // detect permutation paramters
      oP[0] = (iptype[3:0] >= 12) ? wim[0][pW-1 : 0]  : dvb[0][pW-1 : 0];
      oP[1] = (iptype[3:0] >= 12) ? wim[1][pW-1 : 0]  : dvb[1][pW-1 : 0];
      oP[2] = (iptype[3:0] >= 12) ? wim[2][pW-1 : 0]  : dvb[2][pW-1 : 0];
      oP[3] = (iptype[3:0] >= 12) ? wim[3][pW-1 : 0]  : dvb[3][pW-1 : 0];
      // detect dvb/wimax length
      oN    = (iptype[3:0] >= 12) ? iN                : dvb[4][pW-1 : 0];
    end
    // increment for permutation address generator
    oPincr      = (!iptype[4] & (iptype[3 : 0] >= 12)) ? (oP[0] + 1'b1) : 1'b1;
    oPdvbinv    = (iptype < 12);
    // detect permutation complement for P[0]
    oP0comp     = oN - oP[0];
    oPAx2_comp  = oN[pW-1 : 1] - oP[0]; // (N/2 + iP0comp) % N
    oNm1        = oN - 1;
    // get circulation state LUT selector
    oNmod7      = oN % 7;
  end

endmodule
