//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_parameters.svh
// Description   : BCH module parameters & types
//

  //------------------------------------------------------------------------------------------------------
  // base irrectible polynomes table (base polynomes from matlab)
  //------------------------------------------------------------------------------------------------------

  localparam int IRRPOL_TABLE [1 : 20] = '{3,  7,  11,  19,  37,  67,  131,  369,  529,  1033,
    2053,  4249,  8219,  16427/*17475*/, 32813/*32771*/,  65581,  131081,  262273,  524387,  1048585};

  //------------------------------------------------------------------------------------------------------
  // BCH parameters
  //------------------------------------------------------------------------------------------------------
/*
  //
  // define BCH code (15, 5, 3/7) for GF (2^4)
  //
  parameter   int m         = 4;                      // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 5;                      // maximum user payload size
  parameter   int d         = 7;                      // codespace

  // maximum length BCH code (15, 5, 3/7)
  parameter   int n         = gf_n_max;               // used block size
  // shorten BCH code (14, 4, 3/7)
//parameter   int n         = 14;
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (127, 64, 10/21)
  //
  parameter   int m         = 7;                      // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 64;                     // maximum user payload size
  parameter   int d         = 21;                     // codespace

  // maximum length BCH code (127, 64, 10/21)
  parameter   int n         = gf_n_max;               // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (127, 43, 14/29)
  //
  parameter   int m         = 7;                      // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 43;                     // maximum user payload size
  parameter   int d         = 29;                     // codespace

  // maximum length BCH code (127, 43, 14/29)
  parameter   int n         = gf_n_max;               // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (255, 239, 2/5)
  //
  parameter   int m         = 8;                      // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 239;                    // maximum user payload size
  parameter   int d         = 5;                      // codespace

  // maximum length BCH code (255, 239, 2/5)
  parameter   int n         = gf_n_max;               // used block size
  // shorten BCH code (238, 222, 2/5)
//parameter   int n         = 238;
  // shorten BCH code (230, 214, 2/5)
//parameter   int n         = 230;
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/

  //
  // define BCH code (255, 223, 4/9)
  //
  parameter   int m         = 8;                      // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 223;                    // maximum user payload size
  parameter   int d         = 9;                      // codespace

  // maximum length BCH code (255, 223, 4/9)
  parameter   int n         = gf_n_max;               // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size

/*
  //
  // define BCH code (255, 179, 10/21)
  //
  parameter   int m         = 8;                      // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 179;                    // maximum user payload size
  parameter   int d         = 21;                     // codespace

  // maximum length code (255, 179, 10/21)
  parameter   int n         = gf_n_max;               // used block size
  // shorten BCH code (180, 104, 10/21)
//parameter   int n         = 180;
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (1023, 1003, 2/5)
  //
  parameter   int m         = 10;                     // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 1003;                   // maximum user payload size
  parameter   int d         = 5;                      // codespace

  // shorten BCH code (1000, 980, 2/5)
  parameter   int n         = 1000;
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (2047, 1959, 8/17) for GF (2^11)
  //
  parameter   int m         = 11;                     // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 1959;                   // maximum user payload size
  parameter   int d         = 17;                      // codespace

  // maximum length BCH code (2047, 1959, 8/17)
//parameter   int n         = gf_n_max;               // used block size
  // shorten BCH code (2040, 1952, 8/17)
  parameter   int n         = 2040;                   // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (8191, 8152, 3/7) for GF (2^13)
  //
  parameter   int m         = 13;                     // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 8152;                   // maximum user payload size
  parameter   int d         = 7;                      // codespace

  // maximum length BCH code (8191, 8152, 3/7)
  parameter   int n         = gf_n_max;               // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
  // shorten BCH code (6759, 6720, 3/7)
  parameter   int n         = 6759;                   // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (8191, 8087, 8/17) for GF (2^13)
  //
  parameter   int m         = 13;                     // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 8087;                   // maximum user payload size
  parameter   int d         = 17;                     // codespace

  // maximum length BCH code (8191, 8087, 8/17)
//parameter   int n         = gf_n_max;               // used block size

  // shorten BCH code (6760, 6656, 8/17)
  parameter   int n         = 6760;                   // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (16383, 16215, 12/25) for GF (2^14)
  //
  parameter   int m         = 14;                     // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 16215;                  // maximum user payload size
  parameter   int d         = 25;                     // codespace

  // maximum length BCH code (16383, 16215, 12/25)
//parameter   int n         = gf_n_max;               // used block size
  // shorten BCH code (3240, 3072, 12/25)
  parameter   int n         = 3240;                   // used block size

  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
/*
  //
  // define BCH code (16383, 16341, 3/7) for GF (2^14)
  //
  parameter   int m         = 14;                     // GF (2^m)
  localparam  int gf_n_max  = 2**m - 1;               // maximum block size
  parameter   int k_max     = 16341;                  // maximum user payload size
  parameter   int d         = 7;                      // codespace

  // maximum length BCH code (16383, 16215, 12/25)
  parameter   int n         = gf_n_max;               // used block size
  localparam  int k         = k_max -(gf_n_max - n);  // used user payload size
*/
  //------------------------------------------------------------------------------------------------------
  // optionaly change parameters
  //------------------------------------------------------------------------------------------------------

  parameter   int irrpol    = IRRPOL_TABLE[m];  // irrectible poly

  //------------------------------------------------------------------------------------------------------
  // unchanged parameter
  //------------------------------------------------------------------------------------------------------

  localparam int t          = (d-1)/2;    // number of corrected error
  localparam int t2         = 2*t;        // width of syndromes vector

  //------------------------------------------------------------------------------------------------------
  // used types
  //------------------------------------------------------------------------------------------------------

  typedef int unsigned uint_t;

  typedef logic            [m-1 : 0] data_t;
  typedef logic              [1 : 0] ptr_t ;      // used 4D buffer for data saving
  typedef logic [gf_n_max-k_max : 0] gpoly_t ;    // generator poly type

  typedef data_t rom_t [0 : gf_n_max];  // alpha_to/index_of table type

  typedef logic [m-1 : 0] eras_num_t;

