//
// Project       : super fec (G.975.1)
// Author        : Shekhalev Denis (des00)
// Workfile      : super_i3_bch_inner_types.svh
// Description   : I.3 outer BCH (3860,3824) decoder parameters
//

  //------------------------------------------------------------------------------------------------------
  // GF
  //------------------------------------------------------------------------------------------------------

  localparam int cM       = 12;   // GF(2^12)
  localparam int cIRRPOL  = 6465; // D^12+D^11+D^8+D^6+1

  //------------------------------------------------------------------------------------------------------
  // BCH
  //------------------------------------------------------------------------------------------------------

  localparam int cT       = 3;
  localparam int cT2      = 2*cT;
  localparam int cD       = cT2 + 1;

  localparam int cK       = 3824 ;
  localparam int cN       = 3860 ;
  localparam int cK_MAX   = 2**cM - 1 - (cN - cK) ;

  //------------------------------------------------------------------------------------------------------
  // data bitwidth per engine
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W   = 16;
  localparam int cDEC_NUM =  8;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cEOP_EDGE   = 3824/16;     // 239 words
  localparam int cEOF_EDGE   = 3860/16 + 1; // 241.25 words (+36 pbits  = 2.25 words)

  localparam int cFRAME_SIZE = 255;         // 255 words for bypass inner check bits

  localparam int cRAM_ADDR_W =   8; // for full frame
  localparam int cRAM_DAT_W  = 128;

  //------------------------------------------------------------------------------------------------------
  // types
  //------------------------------------------------------------------------------------------------------

  typedef logic          [cM-1 : 0] gf_dat_t;
  typedef logic      [cDAT_W-1 : 0] dat_t;
  typedef logic [cRAM_ADDR_W-1 : 0] ram_addr_t;
  typedef logic  [cRAM_DAT_W-1 : 0] ram_dat_t;
