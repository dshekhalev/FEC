/*



  parameter int pADDR_W     =  8 ;
  parameter int pHD_ADDR_W  =  8 ;
  //
  parameter int pDAT_W      =  2 ;
  parameter int pDAT_NUM    =  1 ;
  //
  parameter int pERR_W      = 16 ;
  parameter int pTAG_W      =  4 ;



  logic                    ldpc_3gpp_dec_sink__iclk                 ;
  logic                    ldpc_3gpp_dec_sink__ireset               ;
  logic                    ldpc_3gpp_dec_sink__iclkena              ;
  //
  code_ctx_t               ldpc_3gpp_dec_sink__icode_ctx            ;
  //
  logic                    ldpc_3gpp_dec_sink__irfull               ;
  logic     [pDAT_W-1 : 0] ldpc_3gpp_dec_sink__irdat     [pDAT_NUM] ;
  logic     [pTAG_W-1 : 0] ldpc_3gpp_dec_sink__irtag                ;
  //
  logic                    ldpc_3gpp_dec_sink__irdecfail            ;
  logic     [pERR_W-1 : 0] ldpc_3gpp_dec_sink__irerr                ;
  //
  logic                    ldpc_3gpp_dec_sink__orempty              ;
  logic    [pADDR_W-1 : 0] ldpc_3gpp_dec_sink__oraddr               ;
  //
  logic                    ldpc_3gpp_dec_sink__ireq                 ;
  logic                    ldpc_3gpp_dec_sink__ofull                ;
  //
  logic                    ldpc_3gpp_dec_sink__osop                 ;
  logic                    ldpc_3gpp_dec_sink__oeop                 ;
  logic                    ldpc_3gpp_dec_sink__oval                 ;
  logic     [pDAT_W-1 : 0] ldpc_3gpp_dec_sink__odat                 ;
  logic     [pTAG_W-1 : 0] ldpc_3gpp_dec_sink__otag                 ;
  //
  logic                    ldpc_3gpp_dec_sink__odecfail             ;
  logic     [pERR_W-1 : 0] ldpc_3gpp_dec_sink__oerr                 ;
  //
  logic                    ldpc_3gpp_dec_sink__ohd_start            ;
  logic                    ldpc_3gpp_dec_sink__ohd_punct            ;
  logic [pHD_ADDR_W-1 : 0] ldpc_3gpp_dec_sink__ohd_raddr            ;




  ldpc_3gpp_dec_sink
  #(
    .pIDX_GR    ( pIDX_GR    ) ,
    //
    .pADDR_W    ( pADDR_W    ) ,
    .pHD_ADDR_W ( pHD_ADDR_W ) ,
    //
    .pDAT_W     ( pDAT_W     ) ,
    .pDAT_NUM   ( pDAT_NUM   ) ,
    //
    .pERR_W     ( pERR_W     ) ,
    .pTAG_W     ( pTAG_W     )
  )
  ldpc_3gpp_dec_sink
  (
    .iclk      ( ldpc_3gpp_dec_sink__iclk      ) ,
    .ireset    ( ldpc_3gpp_dec_sink__ireset    ) ,
    .iclkena   ( ldpc_3gpp_dec_sink__iclkena   ) ,
    //
    .icode_ctx ( ldpc_3gpp_dec_sink__icode_ctx ) ,
    //
    .irfull    ( ldpc_3gpp_dec_sink__irfull    ) ,
    .irdat     ( ldpc_3gpp_dec_sink__irdat     ) ,
    .irtag     ( ldpc_3gpp_dec_sink__irtag     ) ,
    //
    .irdecfail ( ldpc_3gpp_dec_sink__irdecfail ) ,
    .irerr     ( ldpc_3gpp_dec_sink__irerr     ) ,
    //
    .orempty   ( ldpc_3gpp_dec_sink__orempty   ) ,
    .oraddr    ( ldpc_3gpp_dec_sink__oraddr    ) ,
    //
    .ireq      ( ldpc_3gpp_dec_sink__ireq      ) ,
    .ofull     ( ldpc_3gpp_dec_sink__ofull     ) ,
    //
    .osop      ( ldpc_3gpp_dec_sink__osop      ) ,
    .oeop      ( ldpc_3gpp_dec_sink__oeop      ) ,
    .oval      ( ldpc_3gpp_dec_sink__oval      ) ,
    .odat      ( ldpc_3gpp_dec_sink__odat      ) ,
    .otag      ( ldpc_3gpp_dec_sink__otag      ) ,
    //
    .odecfail  ( ldpc_3gpp_dec_sink__odecfail  ) ,
    .oerr      ( ldpc_3gpp_dec_sink__oerr      ) ,
    //
    .ohd_start ( ldpc_3gpp_dec_sink__ohd_start ) ,
    .ohd_punct ( ldpc_3gpp_dec_sink__ohd_punct ) ,
    .ohd_raddr ( ldpc_3gpp_dec_sink__ohd_raddr )
  );


  assign ldpc_3gpp_dec_sink__iclk       = '0 ;
  assign ldpc_3gpp_dec_sink__ireset     = '0 ;
  assign ldpc_3gpp_dec_sink__iclkena    = '0 ;
  assign ldpc_3gpp_dec_sink__icode_ctx  = '0 ;
  assign ldpc_3gpp_dec_sink__irfull     = '0 ;
  assign ldpc_3gpp_dec_sink__irdat      = '0 ;
  assign ldpc_3gpp_dec_sink__irtag      = '0 ;
  assign ldpc_3gpp_dec_sink__irdecfail  = '0 ;
  assign ldpc_3gpp_dec_sink__irerr      = '0 ;
  assign ldpc_3gpp_dec_sink__ireq       = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_sink.sv
// Description   : Ouput decoder interface module for decoders which using output memory.
//

`include "define.vh"

module ldpc_3gpp_dec_sink
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  icode_ctx ,
  //
  irfull    ,
  irdat     ,
  irtag     ,
  //
  irerr     ,
  irdecfail ,
  //
  orempty   ,
  oraddr    ,
  //
  ireq      ,
  ofull     ,
  //
  osop      ,
  oeop      ,
  oval      ,
  odat      ,
  otag      ,
  //
  odecfail  ,
  oerr      ,
  //
  ohd_start ,
  ohd_punct ,
  ohd_raddr
);

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  parameter int pADDR_W     =  8 ;
  parameter int pHD_ADDR_W  =  8 ;
  //
  parameter int pDAT_W      =  8 ;
  parameter int pDAT_NUM    = cCOL_BY_CYCLE ;
  //
  parameter int pERR_W      = 16 ;
  parameter int pTAG_W      =  4 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                    iclk                ;
  input  logic                    ireset              ;
  input  logic                    iclkena             ;
  //
  input  code_ctx_t               icode_ctx           ;
  //
  input  logic                    irfull              ;
  input  logic     [pDAT_W-1 : 0] irdat    [pDAT_NUM] ;
  input  logic     [pTAG_W-1 : 0] irtag               ;
  //
  input  logic                    irdecfail           ;
  input  logic     [pERR_W-1 : 0] irerr               ;
  //
  output logic                    orempty             ;
  output logic    [pADDR_W-1 : 0] oraddr              ;
  //
  input  logic                    ireq                ;
  output logic                    ofull               ;
  //
  output logic                    osop                ;
  output logic                    oeop                ;
  output logic                    oval                ;
  output logic     [pDAT_W-1 : 0] odat                ;
  output logic     [pTAG_W-1 : 0] otag                ;
  //
  output logic                    odecfail            ;
  output logic     [pERR_W-1 : 0] oerr                ;
  //
  output logic                    ohd_start           ;
  output logic                    ohd_punct           ;
  output logic [pHD_ADDR_W-1 : 0] ohd_raddr           ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cSEL_W         = clogb2(pDAT_NUM);

  localparam int cCOL_IN_BLOCK  = ceil(cGR_SYST_BIT_COL[pIDX_GR], pDAT_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  hb_zc_t               used_zc;
  hb_zc_t               used_zc_m2;
  logic                 used_zc_less2;

  hb_col_t              used_col;
  hb_col_t              used_col_m2;

  logic                 used_punct;

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic   done;
    hb_zc_t value;
  } zc_cnt;

  struct packed {
    logic    done;
    hb_col_t value;
  } col_cnt, bcol_cnt;


  logic [cSEL_W-1 : 0] bsel;
  logic [cSEL_W-1 : 0] rsel [2];

  logic        [2 : 0] val;
  logic        [2 : 0] eop;

  logic        [2 : 0] punct;

  logic        [1 : 0] set_sf; // set sop/full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign used_zc    = cZC_TAB[icode_ctx.idxLs][icode_ctx.idxZc] / pDAT_W;
  assign used_col   = cGR_SYST_BIT_COL[icode_ctx.idxGr];
  assign used_punct = icode_ctx.do_punct;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire work_done = zc_cnt.done & col_cnt.done;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=  irfull            ? cDO_STATE    : cRESET_STATE;
        cDO_STATE    : state <= (ireq & work_done) ? cRESET_STATE : cDO_STATE;
      endcase
    end
  end

  assign orempty = (state == cDO_STATE & ireq & work_done);

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        zc_cnt        <= '0;
        zc_cnt.done   <= (used_zc < 2);
        //
        col_cnt       <= '0;
        //
        bcol_cnt      <= '0;
        bcol_cnt.done <= (cCOL_IN_BLOCK < 2);
        //
        used_zc_m2    <= (used_zc - 2);
        used_zc_less2 <= (used_zc < 2);
        //
        used_col_m2   <= (used_col - 2);
      end
      else if (state == cDO_STATE & ireq) begin
        zc_cnt.value <= zc_cnt.done   ? '0    : (zc_cnt.value + 1'b1);
        zc_cnt.done  <= used_zc_less2 ? 1'b1  : (zc_cnt.value == used_zc_m2);
        //
        if (zc_cnt.done) begin
          col_cnt.value   <= col_cnt.value + 1'b1;
          col_cnt.done    <= (col_cnt.value == used_col_m2);
          //
          bcol_cnt.value  <= bcol_cnt.done       ? '0   : (bcol_cnt.value + 1'b1);
          bcol_cnt.done   <= (cCOL_IN_BLOCK < 2) ? 1'b1 : (bcol_cnt.value == cCOL_IN_BLOCK-2);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // read ram side
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        oraddr    <= '0;
        bsel      <= '0;
        //
        ohd_raddr <= '0;
      end
      else if (state == cDO_STATE & ireq) begin
        oraddr    <= (zc_cnt.done & bcol_cnt.done) ? '0 : (oraddr + 1'b1);
        bsel      <= bsel + (zc_cnt.done & bcol_cnt.done);
        //
        ohd_raddr <= (used_punct & (col_cnt.value < 2)) ? '0 : (ohd_raddr + 1'b1);
      end
    end
  end

  wire start = (state == cRESET_STATE & irfull);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val     <= '0;
      set_sf  <= '0;
      ofull   <= 1'b0;
    end
    else if (iclkena) begin
      val <= (val << 1) | (state == cDO_STATE & ireq);
      //
      set_sf <= (set_sf << 1) | start;
      //
      if (set_sf[1]) begin
        ofull <= 1'b1;
      end
      else if (orempty) begin
        ofull <= 1'b0;
      end
    end
  end

  assign oval = val[2];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (set_sf[1]) begin
        osop <= 1'b1;
      end
      else if (oval) begin
        osop <= 1'b0;
      end
      //
      eop <= (eop << 1) | (state == cDO_STATE & work_done);
      //
      if (start) begin
        otag      <= irtag;
        odecfail  <= irdecfail;
        oerr      <= irerr;
      end
      // 2 tick output ram read latency
      rsel[0] <= bsel;
      rsel[1] <= rsel[0];
      odat    <= irdat[rsel[1]];
      //
      ohd_start <= set_sf[1]; // used as group clear
      punct     <= (punct << 1) | (used_punct & (col_cnt.value < 2));
    end
  end

  assign oeop      = eop[2];
  assign ohd_punct = punct[2];

endmodule
