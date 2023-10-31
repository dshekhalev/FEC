//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_parameters.sv
// Description   : wimax 802.16-2012 BTC encoder constants/types and etc.
//

  //------------------------------------------------------------------------------------------------------
  // component coders types 802.16-2012
  //------------------------------------------------------------------------------------------------------

  typedef enum bit {
    cSPC_CODE   = 1'b0 ,  // spc code
    cE_HAM_CODE = 1'b1    // extended hamming code
  } btc_code_t;

  typedef enum bit [1 : 0] {
    cBSIZE_8  = 2'b00,  // 8 bits   ( 8,  7} or ( 8,  4}
    cBSIZE_16 = 2'b01,  // 16 bits  {16, 15} or {16, 11}
    cBSIZE_32 = 2'b10,  // 32 bits  {32, 31} or {32, 26}
    cBSIZE_64 = 2'b11   // 64 bits  {64, 63} or {64, 57}
  } btc_code_bitsize_t;

  typedef struct packed {
    btc_code_t          code_type;
    btc_code_bitsize_t  size;
  } btc_code_mode_t;

  //------------------------------------------------------------------------------------------------------
  // shortening types
  //------------------------------------------------------------------------------------------------------

  typedef struct packed {
    logic [7 : 0] Ix; // row shortening - remove Ix columns
    logic [7 : 0] Iy; // col shortening - remove Iy row
    logic [7 : 0] B;  // remove bits from first data row
    logic [7 : 0] Q;  // zero-filled bits to allign size to byte at output
  } btc_short_mode_t;

  //------------------------------------------------------------------------------------------------------
  // row/col address generator constants & types
  //------------------------------------------------------------------------------------------------------

  localparam int cROW_MAX       = 64;
  localparam int cLOG2_ROW_MAX  = $clog2(cROW_MAX);

  localparam int cCOL_MAX       = 64;
  localparam int cLOG2_COL_MAX  = $clog2(cCOL_MAX);

  typedef logic [cLOG2_ROW_MAX-1 : 0] bit_idx_t;  // use maximum of cLOG2_ROW_MAX/cLOG2_COL_MAX

  //------------------------------------------------------------------------------------------------------
  // functions to get size
  //------------------------------------------------------------------------------------------------------

  typedef int bit_size_tab_t [64];

  // max size for ram allocation

  localparam bit_size_tab_t cDATA_BIT_SIZE      = gen_data_bit_size_tab();

  localparam bit_size_tab_t cCODE_BIT_SIZE      = gen_code_bit_size_tab();

  localparam bit_size_tab_t cDATA_ERR_BIT_SIZE  = gen_data_err_bit_size_tab();

  //
  // get number of coded bits row/col
  function automatic int get_code_bits (input btc_code_mode_t code_mode);
    case (code_mode.size)
      cBSIZE_8  : get_code_bits =  8;
      cBSIZE_16 : get_code_bits = 16;
      cBSIZE_32 : get_code_bits = 32;
      default   : get_code_bits = 64;
    endcase
  endfunction

  //
  // get number of maximum data bits row/col
  function automatic int get_data_bits (input btc_code_mode_t code_mode);
    case (code_mode.size)
      cBSIZE_8  : get_data_bits = (code_mode.code_type == cSPC_CODE) ?  7 :  4;
      cBSIZE_16 : get_data_bits = (code_mode.code_type == cSPC_CODE) ? 15 : 11;
      cBSIZE_32 : get_data_bits = (code_mode.code_type == cSPC_CODE) ? 31 : 26;
      default   : get_data_bits = (code_mode.code_type == cSPC_CODE) ? 63 : 57;
    endcase
  endfunction

  //
  // function to gen table with all possible code bits
  //
  function bit_size_tab_t gen_code_bit_size_tab ();
    btc_code_mode_t xmode;
    btc_code_mode_t ymode;
  begin
    gen_code_bit_size_tab = '{default : '0};
    //
    for (int ixmode = 0; ixmode < 8; ixmode++) begin
      for (int iymode = 0; iymode < 8; iymode++) begin
        xmode = btc_code_mode_t'(ixmode);
        ymode = btc_code_mode_t'(iymode);
        gen_code_bit_size_tab[iymode*8 + ixmode] = get_code_bits(xmode) * get_code_bits(ymode);
      end
    end
  end
  endfunction

  //
  // function to gen table with all possible data bits
  //
  function bit_size_tab_t gen_data_bit_size_tab ();
    btc_code_mode_t xmode;
    btc_code_mode_t ymode;
  begin
    gen_data_bit_size_tab = '{default : '0};
    //
    for (int ixmode = 0; ixmode < 8; ixmode++) begin
      for (int iymode = 0; iymode < 8; iymode++) begin
        xmode = btc_code_mode_t'(ixmode);
        ymode = btc_code_mode_t'(iymode);
        gen_data_bit_size_tab[iymode*8 + ixmode] = get_data_bits(xmode) * get_data_bits(ymode);
      end
    end
  end
  endfunction

  //
  // function to gen table with all possible bits used to count channel bit errors (row last)
  //
  function bit_size_tab_t gen_data_err_bit_size_tab ();
    btc_code_mode_t xmode;
    btc_code_mode_t ymode;
  begin
    gen_data_err_bit_size_tab = '{default : '0};
    //
    for (int ixmode = 0; ixmode < 8; ixmode++) begin
      for (int iymode = 0; iymode < 8; iymode++) begin
        xmode = btc_code_mode_t'(ixmode);
        ymode = btc_code_mode_t'(iymode);
        gen_data_err_bit_size_tab[iymode*8 + ixmode] = get_code_bits(xmode) * get_data_bits(ymode);
      end
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // hamming code functions
  //------------------------------------------------------------------------------------------------------

  typedef logic [5 : 0] state_t;  // convolution state/syndrome type

  //
  // used primpoly (msb_first)
  localparam bit [3 : 0] cPRIM_POLY_8  = 4'b1011;     // '1+D+D^3'
  localparam bit [4 : 0] cPRIM_POLY_16 = 5'b10011;    // '1+D+D^4'
  localparam bit [5 : 0] cPRIM_POLY_32 = 6'b100101;   // '1+D^2+D^5'
  localparam bit [6 : 0] cPRIM_POLY_64 = 7'b1000011;  // '1+D+D^6'

  //
  // check matrix and error index tables
  localparam int cH_7_TAB           [8] = '{5, 7, 6, 3, 4, 2, 1,      0};
  localparam int cH_7_ERR_IDX_TAB   [8] = '{7, 6, 5, 3, 4, 0, 2, 1};

  localparam int cH_15_TAB          [16] = '{9, 13, 15, 14, 7, 10, 5, 11, 12, 6, 3, 8, 4, 2, 1,       0};
  localparam int cH_15_ERR_IDX_TAB  [16] = '{15, 14, 13, 10, 12, 6, 9, 4, 11, 0, 5, 7, 8, 1, 3, 2};

  localparam int cH_31_TAB          [32] = '{18, 9, 22, 11, 23, 25, 30, 15, 21, 24, 12, 6, 3, 19, 27, 31, 29, 28, 14, 7, 17, 26, 13, 20, 10, 5, 16, 8, 4, 2, 1,         0};
  localparam int cH_31_ERR_IDX_TAB  [32] = '{31, 30, 29, 12, 28, 25, 11, 19, 27, 1, 24, 3, 10, 22, 18, 7, 26, 20, 0, 13, 23, 8, 2, 4, 9, 5, 21, 14, 17, 16, 6, 15};

  localparam int cH_63_TAB          [64] = '{33, 49, 57, 61, 63, 62, 31, 46, 23, 42, 21, 43, 52, 26, 13, 39, 50, 25, 45, 55, 58, 29, 47, 54, 27, 44, 22, 11, 36, 18, 9, 37, 51, 56, 28, 14, 7, 34, 17, 41, 53, 59, 60, 30, 15, 38, 19, 40, 20, 10, 5, 35, 48, 24, 12, 6, 3, 32, 16, 8, 4, 2, 1,       0};
  localparam int cH_63_ERR_IDX_TAB  [64] = '{63, 62, 61, 56, 60, 50, 55, 36, 59, 30, 49, 27, 54, 14, 35, 44, 58, 38, 29, 46, 48, 10, 26, 8, 53, 17, 13, 24, 34, 21, 43, 6, 57, 0, 37, 51, 28, 31, 45, 15, 47, 39, 9, 11, 25, 18, 7, 22, 52, 1, 16, 32, 12, 40, 23, 19, 33, 2, 20, 41, 42, 3, 5, 4};

