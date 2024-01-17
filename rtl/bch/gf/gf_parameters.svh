//
// Project       : galua fields
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_parameters.svh
// Description   : Galua field parameters to use inside special units
//

  //------------------------------------------------------------------------------------------------------
  // base irrectible polynomes table (base polynomes from matlab)
  //------------------------------------------------------------------------------------------------------

  localparam int IRRPOL_TABLE [1 : 20] = '{3,  7,  11,  19,  37,  67,  131,  369,  529,  1033,
    2053,  4249,  8219,  16427/*17475*/,  32771,  65581,  131081,  262273,  524387,  1048585};

  //------------------------------------------------------------------------------------------------------
  // GF parameters
  //------------------------------------------------------------------------------------------------------

  parameter   int m         = 4;                // GF (2^m)
  parameter   int irrpol    = IRRPOL_TABLE[m];  // GF (2^m) irrectible poly

  localparam  int gf_n_max  = 2**m - 1; // GF maximum size

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  typedef int unsigned    uint_t;

  typedef logic [m-1 : 0] data_t;

  typedef                 data_t rom_t [0 : gf_n_max];

