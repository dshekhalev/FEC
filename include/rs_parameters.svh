//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_parameters.svh
// Description   : RS parameters
//

  //------------------------------------------------------------------------------------------------------
  // GF parameters
  //------------------------------------------------------------------------------------------------------

  parameter   int m         =   8;      // GF (2^m)
  parameter   int irrpol    = 285;      // irrectible poly

  localparam  int gf_n_max  = 2**m - 1; // maximum block size

  //------------------------------------------------------------------------------------------------------
  // RS parameters
  //------------------------------------------------------------------------------------------------------

  parameter int n           = 240;  // block size
  parameter int check       =  30;  // check symbols
  parameter int genstart    =   0;  // first root index
  parameter int rootspace   =   1;  // root space

  parameter int sym_err_w   =  m ;  // clogb2(check/2 + 1);
  parameter int bit_err_w   =  m ;  // clogb2((check/2 + 1)*m);

  localparam int errs       = check/2;

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  typedef int unsigned uint_t;

  typedef logic [m-1 : 0] data_t;
  typedef logic   [1 : 0] ptr_t ;     // used 4D buffer for data saving

  typedef data_t rom_t    [0 : gf_n_max];   // alpha_to/index_of/inv_alpha_to table type
  typedef data_t gpoly_t  [0 : check];      // generator poly type

  typedef logic [sym_err_w-1 : 0] sym_err_t;
  typedef logic [bit_err_w-1 : 0] bit_err_t;
