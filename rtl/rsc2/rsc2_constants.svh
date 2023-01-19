//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_constants.svh
// Description   : DVB RSC2 constants and constant types
//

  typedef logic  [3 : 0] code_t;      // coderate [0 : 7] - [1/3; 1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8]

  typedef logic  [5 : 0] ptype_t;     // permutation type [0: 33] - reordered Table A-1/2/4/5

  typedef logic [12 : 0] dbits_num_t; // number of data duobits/byte size [32:4096]/[8:1024]

  typedef struct packed {
    code_t  code;  // coderate [0 : 7] - [1/3; 1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8]
    ptype_t ptype; // permutation type [0: 33] - reordered Table A-1/2/4/5
  } code_ctx_t;

