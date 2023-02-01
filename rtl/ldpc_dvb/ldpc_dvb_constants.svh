//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_constants.svh
// Description   : DVB LDPC codec constants, types, functions
//

  //------------------------------------------------------------------------------------------------------
  // DVB code types & code context
  //------------------------------------------------------------------------------------------------------

  typedef enum bit [3 : 0] {
    cCODERATE_1by4  = 0  ,
    cCODERATE_1by3  = 1  ,
    cCODERATE_2by5  = 2  ,
    cCODERATE_1by2  = 3  ,
    cCODERATE_3by5  = 4  ,
    cCODERATE_2by3  = 5  ,
    cCODERATE_3by4  = 6  ,
    cCODERATE_4by5  = 7  ,
    cCODERATE_5by6  = 8  ,
    cCODERATE_8by9  = 9  ,
    cCODERATE_9by10 = 10
  } coderate_t;

  typedef enum bit [1 : 0] {
    cCODEGR_SHORT = 0,
    cCODEGR_LARGE = 1
  } code_gr_t;

  typedef struct packed {
    logic [1 : 0] gr;
    logic [3 : 0] coderate;
  } code_ctx_t;

  //------------------------------------------------------------------------------------------------------
  // Matrix settings
  //------------------------------------------------------------------------------------------------------

  localparam int cCOL_MAX                     = 180;
  localparam int cLOG2_COL_MAX                = $clog2(cCOL_MAX);

  localparam int cDATA_COL_MAX                = cCOL_MAX * 9/10;
  localparam int cDATA_COL_MIN                = cCOL_MAX * 1/4;

  localparam int cLOG2_DATA_COL_MAX           = $clog2(cDATA_COL_MAX);

  localparam int cROW_MAX                     = cCOL_MAX - cDATA_COL_MIN;
  localparam int cLOG2_ROW_MAX                = $clog2(cROW_MAX);

  localparam int cZC_MAX                      = 360;
  localparam int cLOG2_ZC_MAX                 = $clog2(cZC_MAX);

  localparam int cHS_NON_ZERO_MAX             = 1024; // maximimum non zero coe in large Hs matrix
  localparam int cHS_CYCLE_W                  = $clog2(cHS_NON_ZERO_MAX);

  localparam int cHS_NON_ZERO_ROW_PER_COL_MAX = 16; // maximim non zero coe in HS col + LLR
  localparam int cHS_NON_ZERO_COL_PER_ROW_MAX = 32; // maximim non zero coe in HS row

  //------------------------------------------------------------------------------------------------------
  // settings to save resourses for short codeword
  //------------------------------------------------------------------------------------------------------

  localparam int cCOL_SHORT_MAX               = 45;
  localparam int cLOG2_COL_SHORT_MAX          = $clog2(cCOL_SHORT_MAX);

  localparam int cLOG2_ROW_SHORT_MAX          = cLOG2_COL_SHORT_MAX; //~can make so, its near the same

  localparam int cHS_SHORT_NON_ZERO_MAX       = 256; // maximimum non zero coe in short Hs matrix
  localparam int cHS_SHORT_CYCLE_W            = $clog2(cHS_SHORT_NON_ZERO_MAX);

  //------------------------------------------------------------------------------------------------------
  // matrix based types
  //------------------------------------------------------------------------------------------------------

  typedef logic       [cZC_MAX-1 : 0] zdat_t;
  typedef logic [cLOG2_COL_MAX-1 : 0] col_t;
  typedef logic [cLOG2_ROW_MAX-1 : 0] row_t;

  typedef logic  [cLOG2_ZC_MAX-1 : 0] shift_t;

  typedef logic   [cHS_CYCLE_W-1 : 0] cycle_idx_t;

  typedef int                         Hs_t [cROW_MAX][cCOL_MAX][2];

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  function automatic int get_used_col (input code_ctx_t code_ctx);
  begin
    get_used_col = 180;
    case (code_ctx.gr)
      cCODEGR_SHORT : get_used_col = 45;
      cCODEGR_LARGE : get_used_col = 180;
    endcase
  end
  endfunction

  function automatic int get_used_row (input code_ctx_t code_ctx);
  begin
    get_used_row = cROW_MAX;
    case (code_ctx.gr)
      cCODEGR_SHORT : begin
        case (code_ctx.coderate)
          cCODERATE_1by4  : get_used_row = 36;
          cCODERATE_1by3  : get_used_row = 30;
          cCODERATE_2by5  : get_used_row = 27;
          cCODERATE_1by2  : get_used_row = 25;
          cCODERATE_3by5  : get_used_row = 18;
          cCODERATE_2by3  : get_used_row = 15;
          cCODERATE_3by4  : get_used_row = 12;
          cCODERATE_4by5  : get_used_row = 10;
          cCODERATE_5by6  : get_used_row = 8 ;
          cCODERATE_8by9  : get_used_row = 5 ;
        endcase
      end
      //
      cCODEGR_LARGE : begin
        case (code_ctx.coderate)
          cCODERATE_1by4  : get_used_row = 135 ;
          cCODERATE_1by3  : get_used_row = 120 ;
          cCODERATE_2by5  : get_used_row = 108 ;
          cCODERATE_1by2  : get_used_row = 90  ;
          cCODERATE_3by5  : get_used_row = 72  ;
          cCODERATE_2by3  : get_used_row = 60  ;
          cCODERATE_3by4  : get_used_row = 45  ;
          cCODERATE_4by5  : get_used_row = 36  ;
          cCODERATE_5by6  : get_used_row = 30  ;
          cCODERATE_8by9  : get_used_row = 20  ;
          cCODERATE_9by10 : get_used_row = 18  ;
        endcase
      end
    endcase
  end
  endfunction

  // get used data column
  function automatic int get_used_data_col (input code_ctx_t code_ctx);
  begin
    get_used_data_col = get_used_col(code_ctx) - get_used_row(code_ctx);
  end
  endfunction

  // synthesis translate_off
  function automatic real get_used_coderate (input code_ctx_t code_ctx);
    int used_col;
    int used_data_col;
  begin
    used_col      = get_used_col(code_ctx);
    used_data_col = get_used_data_col(code_ctx);
    //
    get_used_coderate = 1.0*used_data_col/used_col;
  end
  endfunction
  // synthesis translate_on

