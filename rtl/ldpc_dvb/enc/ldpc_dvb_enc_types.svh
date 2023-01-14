//
// Project       : ldpc DVB-S
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
  // function to get maximum input buffer ram address
  //
  function automatic int get_ibuff_max_addr (input int gr);
    code_ctx_t ctx;
  begin
    // can use any coderate
    if (gr == cCODEGR_LARGE) begin
      ctx = '{gr : cCODEGR_LARGE, coderate : cCODERATE_9by10};
    end
    else begin
      ctx = '{gr : cCODEGR_SHORT, coderate : cCODERATE_8by9};
    end
    //
    get_ibuff_max_addr = get_used_data_col(ctx);
  end
  endfunction

  //
  // function to get maximum output buffer ram address
  //
  function automatic int get_obuff_max_addr (input int gr);
    code_ctx_t ctx;
  begin
    // can use any coderare
    ctx = '{gr : gr, coderate : cCODERATE_1by4};
    //
    get_obuff_max_addr = get_used_col(ctx);
  end
  endfunction

  //
  // function to get input buffer ram address
  //
  function automatic int get_ibuff_addr (input int gr, coderate);
    code_ctx_t ctx;
  begin
    // can use any coderate
    ctx = '{gr : gr, coderate : coderate};
    //
    get_ibuff_addr = get_used_data_col(ctx);
  end
  endfunction
