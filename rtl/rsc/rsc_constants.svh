//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_constants.svh
// Description   : DVB/Wimax constants and constant types
//

  typedef logic  [3 : 0] code_t;      // code rate  0       - 1/3,
                                      //            [1 : 9] - [1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8; 8/9; 9/10]
                                      //            [10:11] - [2:3]/5
                                      //            12      - 3/7

  typedef logic  [4 : 0] ptype_t;     // permutation type [ 0:11] - DVB     P0/P1/P2/P3,
                                      //                  [12:15] - WiMax   P0 = 7/11/13/17
                                      //                  [16:31] - WimaxA  P0/P1/P2/P3,

  typedef logic [12 : 0] dbits_num_t; // number of data duobits/byte size [32:4096]/[8:1024]

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef struct packed {
    code_t      code;
    ptype_t     ptype;
    dbits_num_t Ndbits;
  } code_ctx_t;

