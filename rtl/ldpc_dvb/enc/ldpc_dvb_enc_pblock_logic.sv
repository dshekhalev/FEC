/*



  parameter int pPACC_SPLIT = 1;



  logic  ldpc_dvb_enc_pblock_logic__iclk          ;
  logic  ldpc_dvb_enc_pblock_logic__ireset        ;
  logic  ldpc_dvb_enc_pblock_logic__iclkena       ;
  //
  logic  ldpc_dvb_enc_pblock_logic__istart        ;
  //
  logic  ldpc_dvb_enc_pblock_logic__ival          ;
  strb_t ldpc_dvb_enc_pblock_logic__istrb         ;
  zdat_t ldpc_dvb_enc_pblock_logic__idat          ;
  //
  logic  ldpc_dvb_enc_pblock_logic__oval          ;
  row_t  ldpc_dvb_enc_pblock_logic__opacc_row_idx ;
  zdat_t ldpc_dvb_enc_pblock_logic__opacc_word    ;
  zdat_t ldpc_dvb_enc_pblock_logic__opacc         ;



  ldpc_dvb_enc_pblock_logic
  #(
    .pPACC_SPLIT ( pPACC_SPLIT )
  )
  ldpc_dvb_enc_pblock_logic
  (
    .iclk          ( ldpc_dvb_enc_pblock_logic__iclk          ) ,
    .ireset        ( ldpc_dvb_enc_pblock_logic__ireset        ) ,
    .iclkena       ( ldpc_dvb_enc_pblock_logic__iclkena       ) ,
    //
    .istart        ( ldpc_dvb_enc_pblock_logic__istart        ) ,
    //
    .ival          ( ldpc_dvb_enc_pblock_logic__ival          ) ,
    .istrb         ( ldpc_dvb_enc_pblock_logic__istrb         ) ,
    .idat          ( ldpc_dvb_enc_pblock_logic__idat          ) ,
    //
    .oval          ( ldpc_dvb_enc_pblock_logic__oval          ) ,
    .opacc_row_idx ( ldpc_dvb_enc_pblock_logic__opacc_row_idx ) ,
    .opacc_word    ( ldpc_dvb_enc_pblock_logic__opacc_word    ) ,
    .opacc         ( ldpc_dvb_enc_pblock_logic__opacc         )
  );


  assign ldpc_dvb_enc_pblock_logic__iclk    = '0 ;
  assign ldpc_dvb_enc_pblock_logic__ireset  = '0 ;
  assign ldpc_dvb_enc_pblock_logic__iclkena = '0 ;
  assign ldpc_dvb_enc_pblock_logic__istart  = '0 ;
  assign ldpc_dvb_enc_pblock_logic__ival    = '0 ;
  assign ldpc_dvb_enc_pblock_logic__istrb   = '0 ;
  assign ldpc_dvb_enc_pblock_logic__idat    = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_enc_pblock_logic.sv
// Description   : encoder parity bit counter logic
//

module ldpc_dvb_enc_pblock_logic
#(
  parameter int pPACC_SPLIT = 1 // 1/2/4 support - paramter to split IRA logic
)
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  istart        ,
  //
  ival          ,
  istrb         ,
  idat          ,
  //
  oval          ,
  opacc_row_idx ,
  opacc_word    ,
  opacc
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk          ;
  input  logic  ireset        ;
  input  logic  iclkena       ;
  //
  input  logic  istart        ;
  //
  input  logic  ival          ;
  input  strb_t istrb         ;
  input  zdat_t idat          ;
  //
  output logic  oval          ;
  output row_t  opacc_row_idx ;
  output zdat_t opacc_word    ;
  output zdat_t opacc         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  zdat_t pacc;
  zdat_t pacc_int;

  logic  emul_sop;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval  <= 1'b0;
    end
    else if (iclkena) begin
      oval  <= ival & istrb.eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (istart) begin
        pacc          <= '0;
        opacc_word    <= '0;
        opacc_row_idx <= '0;
        emul_sop      <= 1'b0;
      end
      else if (ival) begin
        pacc          <= pacc ^ idat;
        opacc_word    <= emul_sop ? idat : (opacc_word ^ idat);
        opacc_row_idx <= opacc_row_idx + emul_sop;
        emul_sop      <= istrb.eop; // remember, there is no first sop (see enc_hs_gen)
      end
      //
      // can do IRA all time, because pacc fixed after end
//    opacc <= get_pline(pacc);
      pacc_int <= get_int_pline(pacc, pPACC_SPLIT);
    end
  end

  // there is register outside inside the mux
  assign opacc = get_final_pline(pacc_int, pPACC_SPLIT);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function automatic zdat_t get_pline (input zdat_t pacc);
  begin
    get_pline[0] = 1'b0;
    for (int i = 1; i < cZC_MAX; i++) begin
      get_pline[i] = get_pline[i-1] ^ pacc[i-1];
    end
  end
  endfunction

  function automatic zdat_t get_int_pline (input zdat_t pacc, int stage_num = 1);
    int zc_edge;
  begin
    zc_edge = cZC_MAX/stage_num;
    //
    for (int s = stage_num-1; s >= 0; s--) begin // high bits must be first
      if (s == 0) begin
        get_int_pline[0] = 1'b0;
        for (int i = 1; i < zc_edge; i++) begin
          get_int_pline[i] = get_int_pline[i-1] ^ pacc[i-1];
        end
      end
      else begin
        get_int_pline[s*zc_edge-1] = 1'b0; // must be first
        for (int i = s*zc_edge; i < (s+1)*zc_edge; i++) begin
          get_int_pline[i] = get_int_pline[i-1] ^ pacc[i-1];
        end
      end
    end
  end
  endfunction

  function automatic zdat_t get_final_pline (input zdat_t pacc, int stage_num = 1);
    int zc_edge;
  begin
    zc_edge = cZC_MAX/stage_num;
    //
    get_final_pline = pacc;
    //
    for (int s = 1; s < stage_num; s++) begin
      for (int i = 0; i < zc_edge; i++) begin
        get_final_pline[s*zc_edge + i] ^= get_final_pline[s*zc_edge-1];
      end
    end
  end
  endfunction

endmodule
