//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_define.svh
// Description   : bch modules macros file
//

//`define __BCH_BERLEKAMP_DEBUG_LOG__ // uncomment to get log about berlekamp algorithm
//`define __BCH_CHIENY_DEBUG_LOG__

//`define __BCH_GEN_POLY_DEBUG_LOG__
  `define __BCH_GEN_POLY_CYCLE_SET_MAX_NUM__  1000  // maximum number of GF cycle sets
  `define __BCH_GEN_POLY_CYCLE_SET_MAX_SIZE__ 50    // maximum number of single cycle set entries
  `define __BCH_USING_GEN_POLY_TAB__                // uncomment to use bch generator poly from table
