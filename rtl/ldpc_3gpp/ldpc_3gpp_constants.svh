//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_constants.svh
// Description   : 3GPP LDPC codec constants, types, functions
//

  typedef logic [2 : 0] idxLs_t;  // 0...7
  typedef logic [2 : 0] idxZc_t;  // 0...7
  typedef logic [5 : 0] code_t;   // graph1/graph2 [4:46]/[4:42]

  //------------------------------------------------------------------------------------------------------
  // code context for variable decoder
  //------------------------------------------------------------------------------------------------------

  typedef struct packed {
    logic   idxGr;       // graph 1/2
    idxLs_t idxLs;       // 0...7
    idxZc_t idxZc;       // 0...7 use only Zc multiply by pDAT_W
    code_t  code;        // graph1/graph2 [4:46]/[4:42]
    logic   do_punct;    // do 3GPP puncture (1)
  } code_ctx_t;

  //------------------------------------------------------------------------------------------------------
  // Zc[idxLs][idxZc]
  //------------------------------------------------------------------------------------------------------

  localparam int cZC_TAB [8][8]= '{
    // pDAT_W        == 1 pDAT_W        == 1/2  pDAT_W        == 1/2/4  pDAT_W        == 1/2/4/8  -- encoder support
    // pLLR_BY_CYCLE == 1 pLLR_BY_CYCLE == 1/2  pLLR_BY_CYCLE == 1/2/4  pLLR_BY_CYCLE == 1/2/4/8  -- decoder support
    //          0           |          1          |           2          |  3 |  4 |  5 |  6 |   7 |
    '{                    2,                    4,                      8,  16,  32,  64, 128, 256},
    '{ 3,                      6,                    12,                    24,  48,  96, 192, 384}, // | extended |
    '{ 5,                     10,                    20,                    40,  80, 160, 320,              320},
    '{ 7,                     14,                    28,                    56, 112, 224,                   448, 448},
    '{ 9,                     18,                    36,                    72, 144, 288,                   288, 288},
    '{11,                     22,                    44,                    88, 176, 352,                   352, 352},
    '{13,                     26,                    52,                   104, 208,                        416, 416, 416},
    '{15,                     30,                    60,                   120, 240,                        480, 480, 480}
    };

  localparam int cZC_MAX        = 480; // 384;
  localparam int cLOG2_ZC_MAX   = 9;

  typedef logic [cLOG2_ZC_MAX-1 : 0] hb_zc_t;

  function automatic int get_data_bit_length (input logic idxGr, idxLs_t idxLs, idxZc_t idxZc);
    if (idxGr) begin
      get_data_bit_length = 10*cZC_TAB[idxLs][idxZc];
    end
    else begin
      get_data_bit_length = 22*cZC_TAB[idxLs][idxZc];
    end
  endfunction

  function automatic int get_code_bit_length (input logic idxGr, idxLs_t idxLs, idxZc_t idxZc, code_t code, logic punct);
    if (code < 4) code = 4;
    //
    if (idxGr) begin
      if (punct) begin
        get_code_bit_length = ( 8 + code)*cZC_TAB[idxLs][idxZc];
      end
      else begin
        get_code_bit_length = (10 + code)*cZC_TAB[idxLs][idxZc];
      end
    end
    else begin
      if (punct) begin
        get_code_bit_length = (20 + code)*cZC_TAB[idxLs][idxZc];
      end
      else begin
        get_code_bit_length = (22 + code)*cZC_TAB[idxLs][idxZc];
      end
    end
  endfunction

  // index of columns for systematic channel LLRs
  localparam int cGR_SYST_BIT_COL   [2] = '{22, 10};

  // index of columns for systematic and major parity channel LLRs
  localparam int cGR_MAJOR_BIT_COL  [2] = '{26, 14};

  // index of maximim rows for whole matix
  localparam int cGR_MAX_ROW        [2] = '{46, 42};

  // index of maximum columns for whole matrix
  localparam int cGR_MAX_COL        [2] = '{68, 52};

  //------------------------------------------------------------------------------------------------------
  // inv(-E*T^-1*B+D) for major check matrix decoder
  //  cINV_PSI[idxGr][idxLs][idxZc]
  //------------------------------------------------------------------------------------------------------

  localparam int cINV_PSI [2][8][8] = '{
    // graph 1
    '{
      '{0, 0, 0, 0,   0, 0, 0, 0},
      '{0, 0, 0, 0,   0, 0, 0, 0},  // | extended |
      '{0, 0, 0, 0,   0, 0, 0,              0},
      '{0, 0, 0, 0,   0, 0,                 0,   0},
      '{0, 0, 0, 0,   0, 0,                 0,   0},
      '{0, 0, 0, 0,   0, 0,                 0,   0},
      '{1, 1, 1, 1, 105,                  105, 105, 105},
      '{0, 0, 0, 0,   0,                    0,   0,   0}
     },
    // graph 2
    '{
      '{1, 1, 1, 1, 1, 1, 1, 1},
      '{1, 1, 1, 1, 1, 1, 1, 1},    // | extended |
      '{1, 1, 1, 1, 1, 1, 1,              1},
      '{0, 0, 0, 0, 0, 0,                 0, 0},
      '{1, 1, 1, 1, 1, 1,                 1, 1},
      '{1, 1, 1, 1, 1, 1,                 1, 1},
      '{1, 1, 1, 1, 1,                    1, 1, 1},
      '{0, 0, 0, 0, 0,                    0, 0, 0}
     }
  };

  //------------------------------------------------------------------------------------------------------
  // check matrix based types
  //------------------------------------------------------------------------------------------------------

  typedef int baseHc_t [46][68];

  typedef logic            [5 : 0] hb_row_t;
  typedef logic            [6 : 0] hb_col_t;
  typedef logic [cLOG2_ZC_MAX : 0] hb_value_t; // {sign, hb_zc_t}

