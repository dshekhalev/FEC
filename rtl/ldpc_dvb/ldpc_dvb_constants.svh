//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_constants.svh
// Description   : DVB LDPC codec constants, types, functions
//

  //------------------------------------------------------------------------------------------------------
  // DVB code types & code context
  //------------------------------------------------------------------------------------------------------

  // DVB-S2 code hierarhy
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

  // DVB-S2X code hierarhy
  typedef enum bit [2 : 0] {
    cXCODERATE_S_11by45 = 0 ,
    cXCODERATE_S_4by15  = 1 ,
    cXCODERATE_S_14by45 = 2 ,
    cXCODERATE_S_7by15  = 3 ,
    cXCODERATE_S_8by15  = 4 ,
    cXCODERATE_S_26by45 = 5 ,
    cXCODERATE_S_32by45 = 6
  } xcoderate_short_t;

  typedef enum bit [2 : 0] {
    cXCODERATE_M_1by5    = 0  ,
    cXCODERATE_M_11by45  = 1  ,
    cXCODERATE_M_1by3    = 2
  } xcoderate_med_t;

  typedef enum bit [4 : 0] {
    cXCODERATE_L_2by9     = 0  ,
    cXCODERATE_L_13by45   = 1  ,
    cXCODERATE_L_9by20    = 2  ,
    cXCODERATE_L_90by180  = 3  ,
    cXCODERATE_L_96by180  = 4  ,
    cXCODERATE_L_11by20   = 5  ,
    cXCODERATE_L_100by180 = 6  ,
    cXCODERATE_L_26by45   = 7  ,
    cXCODERATE_L_104by180 = 8  ,
    cXCODERATE_L_18by30   = 9  ,
    cXCODERATE_L_28by45   = 10 ,
    cXCODERATE_L_23by36   = 11 ,
    cXCODERATE_L_116by180 = 12 ,
    cXCODERATE_L_20by30   = 13 ,
    cXCODERATE_L_124by180 = 14 ,
    cXCODERATE_L_25by36   = 15 ,
    cXCODERATE_L_128by180 = 16 ,
    cXCODERATE_L_13by18   = 17 ,
    cXCODERATE_L_132by180 = 18 ,
    cXCODERATE_L_22by30   = 19 ,
    cXCODERATE_L_135by180 = 20 ,
    cXCODERATE_L_140by180 = 21 ,
    cXCODERATE_L_7by9     = 22 ,
    cXCODERATE_L_154by180 = 23
  } xcoderate_large_t;

  typedef enum bit [1 : 0] {
    cCODEGR_SHORT  = 0,
    cCODEGR_LARGE  = 1,
    cCODEGR_MEDIUM = 2
  } code_gr_t;

  typedef struct packed {
    logic         xmode;
    logic [1 : 0] gr;
    logic [4 : 0] coderate; // up to 32 codes for one codegraph
  } code_ctx_t;

  //------------------------------------------------------------------------------------------------------
  // Matrix settings
  //------------------------------------------------------------------------------------------------------

  localparam int cCOL_MAX                     = 180;
  localparam int cLOG2_COL_MAX                = $clog2(cCOL_MAX);

  localparam int cDATA_COL_MAX                = cCOL_MAX * 9/10;
  localparam int cDATA_COL_MIN                = cCOL_MAX * 1/4;

  localparam int cLOG2_DATA_COL_MAX           = $clog2(cDATA_COL_MAX);

  localparam int cROW_MAX                     = 140; // DVB-S2X 2/9
  localparam int cLOG2_ROW_MAX                = $clog2(cROW_MAX);

  localparam int cZC_MAX                      = 360;
  localparam int cLOG2_ZC_MAX                 = $clog2(cZC_MAX);

  localparam int cHS_NON_ZERO_MAX             = 1024; // maximimum non zero coe in large Hs matrix
  localparam int cHS_CYCLE_W                  = $clog2(cHS_NON_ZERO_MAX);

  localparam int cHS_NON_ZERO_ROW_PER_COL_MAX = 32; // maximim non zero coe in HS col + LLR 16/32 for DVB-S2/DVB-S2X
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
  // settings to save resourses for medium codeword
  //------------------------------------------------------------------------------------------------------

  localparam int cCOL_MEDIUM_MAX              = 90;
  localparam int cLOG2_COL_MEDIUM_MAX         = $clog2(cCOL_MEDIUM_MAX);

  localparam int cLOG2_ROW_MEDIUM_MAX         = cLOG2_COL_MEDIUM_MAX; //~can make so, its near the same

  localparam int cHS_MEDIUM_NON_ZERO_MAX      = 512; // maximimum non zero coe in medium Hs matrix
  localparam int cHS_MEDIUM_CYCLE_W           = $clog2(cHS_MEDIUM_NON_ZERO_MAX);

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
  // usefull functions and constants tables
  //------------------------------------------------------------------------------------------------------

  localparam int cGET_USED_COL_TAB [3] = '{45, 180, 90};
  localparam int cGET_CYCLE_W      [3] = '{ cHS_SHORT_CYCLE_W,
                                            cHS_CYCLE_W,
                                            cHS_MEDIUM_CYCLE_W};

  function automatic int get_used_col (input code_ctx_t code_ctx);
  begin
    get_used_col = 180;
    case (code_ctx.gr)
      cCODEGR_SHORT   : get_used_col = 45;
      cCODEGR_LARGE   : get_used_col = 180;
      cCODEGR_MEDIUM  : get_used_col = 90;
    endcase
  end
  endfunction

  function automatic int get_used_row (input code_ctx_t code_ctx, bit xmode = 0);
  begin
    if (xmode) begin  // DVB-S2X used row
      get_used_row = 140;
      case (code_ctx.gr)
        cCODEGR_SHORT : begin
          case (code_ctx.coderate)
            cXCODERATE_S_11by45  : get_used_row = 34;
            cXCODERATE_S_4by15   : get_used_row = 33;
            cXCODERATE_S_14by45  : get_used_row = 31;
            cXCODERATE_S_7by15   : get_used_row = 24;
            cXCODERATE_S_8by15   : get_used_row = 21;
            cXCODERATE_S_26by45  : get_used_row = 19;
            cXCODERATE_S_32by45  : get_used_row = 13;
          endcase
        end
        //
        cCODEGR_MEDIUM : begin
          case (code_ctx.coderate)
            cXCODERATE_M_1by5    : get_used_row = 72;
            cXCODERATE_M_11by45  : get_used_row = 68;
            cXCODERATE_M_1by3    : get_used_row = 60;
          endcase
        end
        //
        cCODEGR_LARGE : begin
          case (code_ctx.coderate)
            cXCODERATE_L_2by9     : get_used_row = 140;
            cXCODERATE_L_13by45   : get_used_row = 128;
            cXCODERATE_L_9by20    : get_used_row = 99 ;
            cXCODERATE_L_90by180  : get_used_row = 90 ;
            cXCODERATE_L_96by180  : get_used_row = 84 ;
            cXCODERATE_L_11by20   : get_used_row = 81 ;
            cXCODERATE_L_100by180 : get_used_row = 80 ;
            cXCODERATE_L_26by45   : get_used_row = 76 ;
            cXCODERATE_L_104by180 : get_used_row = 76 ;
            cXCODERATE_L_18by30   : get_used_row = 72 ;
            cXCODERATE_L_28by45   : get_used_row = 68 ;
            cXCODERATE_L_23by36   : get_used_row = 65 ;
            cXCODERATE_L_116by180 : get_used_row = 64 ;
            cXCODERATE_L_20by30   : get_used_row = 60 ;
            cXCODERATE_L_124by180 : get_used_row = 56 ;
            cXCODERATE_L_25by36   : get_used_row = 55 ;
            cXCODERATE_L_128by180 : get_used_row = 52 ;
            cXCODERATE_L_13by18   : get_used_row = 50 ;
            cXCODERATE_L_132by180 : get_used_row = 48 ;
            cXCODERATE_L_22by30   : get_used_row = 48 ;
            cXCODERATE_L_135by180 : get_used_row = 45 ;
            cXCODERATE_L_140by180 : get_used_row = 40 ;
            cXCODERATE_L_7by9     : get_used_row = 40 ;
            cXCODERATE_L_154by180 : get_used_row = 26 ;
          endcase
        end
      endcase
    end
    else begin  // DVB-S2 used row
      get_used_row = 135;
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
  end
  endfunction

  // get used data column
  function automatic int get_used_data_col (input code_ctx_t code_ctx, bit xmode = 0);
  begin
    get_used_data_col = get_used_col(code_ctx) - get_used_row(code_ctx, xmode);
  end
  endfunction

  // synthesis translate_off
  function automatic real get_used_coderate (input code_ctx_t code_ctx, bit xmode = 0);
    int used_col;
    int used_data_col;
  begin
    used_col      = get_used_col(code_ctx);
    used_data_col = get_used_data_col(code_ctx, xmode);
    //
    get_used_coderate = 1.0*used_data_col/used_col;
  end
  endfunction
  // synthesis translate_on

