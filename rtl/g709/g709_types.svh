//
// Project       : fec (G.709)
// Author        : Shekhalev Denis (des00)
// Workfile      : g709_enc.sv
// Description   : RS(255,239) parameters top level
//

  //------------------------------------------------------------------------------------------------------
  // GF parameters
  //------------------------------------------------------------------------------------------------------

  localparam int cM      = 8;    // GF (2^m)
  localparam int cIRRPOL = 285;  // irrectible poly

  //------------------------------------------------------------------------------------------------------
  // RS parameters
  //------------------------------------------------------------------------------------------------------

  localparam int cN         = 255;  // block size
  localparam int cCHECK     =  16;  // check symbols
  localparam int cGENSTART  =   0;  // first root index
  localparam int cROOTSPACE =   1;  // root space

  localparam int cERRS      = cCHECK/2;

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  typedef logic [cM-1 : 0] dat_t;
  typedef logic    [1 : 0] ptr_t ;     // used 4D buffer for data saving

  typedef logic    [4 : 0] symerr_t;   // 8 max
  typedef logic    [6 : 0] biterr_t;   // 64 max

  typedef logic    [7 : 0] ram_addr_t;
  typedef logic  [127 : 0] ram_dat_t;
