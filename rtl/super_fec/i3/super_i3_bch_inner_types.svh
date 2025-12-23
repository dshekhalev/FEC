//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_bch_inner_types.svh
// Description   : I.3 outer BCH (2040,1930) decoder parameters
//

  //------------------------------------------------------------------------------------------------------
  // GF
  //------------------------------------------------------------------------------------------------------

  localparam int cM       = 11;   // GF(2^11)
  localparam int cIRRPOL  = 2053; // D^11+D^2+1'1

  //------------------------------------------------------------------------------------------------------
  // BCH
  //------------------------------------------------------------------------------------------------------

  localparam int cT       = 10;
  localparam int cT2      = 2*cT;
  localparam int cD       = cT2 + 1;

  localparam int cK       = 1930 ;
  localparam int cN       = 2040 ;
  localparam int cK_MAX   = 2**cM - 1 - (cN - cK) ;

  //------------------------------------------------------------------------------------------------------
  // data bitwidth per engine
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W   =  8;
  localparam int cDEC_NUM = 16;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cEOP_EDGE   = 1930/8 + 1;  // 241.25 words
  localparam int cEOF_EDGE   = 2040/8;      // 255 words    (+110 pbits = 13.75 words)

  localparam int cFRAME_SIZE = 255;         // == cEOF_EDGE

  localparam int cRAM_ADDR_W =   8; // for full frame
  localparam int cRAM_DAT_W  = 128;

  //------------------------------------------------------------------------------------------------------
  // types
  //------------------------------------------------------------------------------------------------------

  typedef logic          [cM-1 : 0] gf_dat_t;
  typedef logic      [cDAT_W-1 : 0] dat_t;
  typedef logic [cRAM_ADDR_W-1 : 0] ram_addr_t;
  typedef logic  [cRAM_DAT_W-1 : 0] ram_dat_t;
