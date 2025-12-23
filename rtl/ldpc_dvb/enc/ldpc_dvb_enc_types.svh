//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_types.svh
// Description   : encoder parameters/types & etc
//

  //------------------------------------------------------------------------------------------------------
  // used data types
  //------------------------------------------------------------------------------------------------------

  // control strobes type
  typedef struct packed {
    logic sof;
    logic sop;
    logic eop;
    logic eof;
  } strb_t;

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  //
  // function to get optimal input buffer width to save resources of source unit
  //
  function automatic int get_buffer_dat_w (input int dat_w);
  begin
    get_buffer_dat_w = cZC_MAX;
    case (dat_w)
       1,   2,   3,  4,  6,  9, 12, 18, 36  : get_buffer_dat_w = 36;
       8,  24,  72                          : get_buffer_dat_w = 72;
       5,  10,  15, 30, 45, 90              : get_buffer_dat_w = 90;
      20,  60, 180                          : get_buffer_dat_w = 180;
      40, 120, 360                          : get_buffer_dat_w = 360;
    endcase
  end
  endfunction

  //
  // function to get maximum input buffer ram address. maximum data rows:
  // dvb-s2
  //    short   =  45 -  5  = 40
  //    normal  = 180 - 18  = 162
  // dvb-s2x (support dvb-s2 any case)
  //    short   =  45 - 13  = 32
  //    normal  = 180 - 26  = 154
  //    medium  =  90 - 60  = 30
  //
  function automatic int get_ibuff_max_addr (input int gr, bit xmode = 0);
    code_ctx_t ctx;
  begin
    ctx = '0;
    //
    case (gr)
      cCODEGR_LARGE : begin
        ctx.gr        = cCODEGR_LARGE;
        ctx.coderate  = cCODERATE_9by10;
      end
      default : begin
        ctx.gr        = cCODEGR_SHORT;
        ctx.coderate  = cCODERATE_8by9;
      end
    endcase
    //
    get_ibuff_max_addr = get_used_data_col(ctx);
  end
  endfunction

  //
  // function to get maximum output buffer ram address
  //
  function automatic int get_obuff_max_addr (input int gr);
  begin
    get_obuff_max_addr = cGET_USED_COL_TAB[cCODEGR_LARGE];
    if (gr <= 2) begin
      get_obuff_max_addr = cGET_USED_COL_TAB[gr];
    end
  end
  endfunction

  //
  // function to get input buffer ram address for fix encoder
  //
  function automatic int get_ibuff_addr (input int gr, coderate, bit xmode = 0);
    code_ctx_t ctx;
  begin
    ctx = '0;
    // can use any coderate
    ctx.xmode     = xmode;
    ctx.gr        = gr;
    ctx.coderate  = coderate;
    //
    get_ibuff_addr = get_used_data_col(ctx);
  end
  endfunction
