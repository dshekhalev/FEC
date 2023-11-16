/*



  parameter int pDAT_W  = 1 ;
  parameter int pADDR_W = 1 ;
  parameter int pTAG_W  = 8 ;



  logic                            btc_enc_engine__iclk        ;
  logic                            btc_enc_engine__ireset      ;
  logic                            btc_enc_engine__iclkena     ;
  //
  btc_code_mode_t                  btc_enc_engine__ixmode      ;
  btc_code_mode_t                  btc_enc_engine__iymode      ;
  btc_short_mode_t                 btc_enc_engine__ismode      ;
  //
  logic                            btc_enc_engine__irbuf_full  ;
  logic             [pDAT_W-1 : 0] btc_enc_engine__irdat       ;
  logic             [pTAG_W-1 : 0] btc_enc_engine__irtag       ;
  logic                            btc_enc_engine__oread       ;
  logic                            btc_enc_engine__orempty     ;
  logic            [pADDR_W-1 : 0] btc_enc_engine__oraddr      ;
  //
  logic                            btc_enc_engine__iwbuf_empty ;
  //
  logic                            btc_enc_engine__owrite      ;
  logic                            btc_enc_engine__owfull      ;
  logic            [pADDR_W-1 : 0] btc_enc_engine__owaddr      ;
  logic             [pDAT_W-1 : 0] btc_enc_engine__owdat       ;
  logic             [pTAG_W-1 : 0] btc_enc_engine__owtag       ;
  //
  btc_code_mode_t                  btc_enc_engine__oxmode      ;
  btc_code_mode_t                  btc_enc_engine__oymode      ;
  btc_short_mode_t                 btc_enc_engine__osmode      ;



  btc_enc_engine
  #(
    .pDAT_W  ( pDAT_W  ) ,
    .pADDR_W ( pADDR_W ) ,
    .pTAG_W  ( pTAG_W  )
  )
  btc_enc_engine
  (
    .iclk        ( btc_enc_engine__iclk        ) ,
    .ireset      ( btc_enc_engine__ireset      ) ,
    .iclkena     ( btc_enc_engine__iclkena     ) ,
    //
    .ixmode      ( btc_enc_engine__ixmode      ) ,
    .iymode      ( btc_enc_engine__iymode      ) ,
    .ismode      ( btc_enc_engine__ismode      ) ,
    //
    .irbuf_full  ( btc_enc_engine__irbuf_full  ) ,
    .irdat       ( btc_enc_engine__irdat       ) ,
    .irtag       ( btc_enc_engine__irtag       ) ,
    .oread       ( btc_enc_engine__oread       ) ,
    .orempty     ( btc_enc_engine__orempty     ) ,
    .oraddr      ( btc_enc_engine__oraddr      ) ,
    //
    .iwbuf_empty ( btc_enc_engine__iwbuf_empty ) ,
    //
    .owrite      ( btc_enc_engine__owrite      ) ,
    .owfull      ( btc_enc_engine__owfull      ) ,
    .owaddr      ( btc_enc_engine__owaddr      ) ,
    .owdat       ( btc_enc_engine__owdat       ) ,
    .owtag       ( btc_enc_engine__owtag       ) ,
    //
    .oxmode      ( btc_enc_engine__oxmode      ) ,
    .oymode      ( btc_enc_engine__oymode      ) ,
    .osmode      ( btc_enc_engine__osmode      )
  );


  assign btc_enc_engine__iclk        = '0 ;
  assign btc_enc_engine__ireset      = '0 ;
  assign btc_enc_engine__iclkena     = '0 ;
  assign btc_enc_engine__ixmode      = '0 ;
  assign btc_enc_engine__iymode      = '0 ;
  assign btc_enc_engine__ismode      = '0 ;
  assign btc_enc_engine__irbuf_full  = '0 ;
  assign btc_enc_engine__irdat       = '0 ;
  assign btc_enc_engine__irtag       = '0 ;
  assign btc_enc_engine__iwbuf_empty = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_enc_engine.sv
// Description   : BTC encoder engine top level
//

module btc_enc_engine
#(
  parameter int pDAT_W  = 8 , // fixed. don't change
  parameter int pADDR_W = 8 ,
  parameter int pTAG_W  = 8
)
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  ixmode      ,
  iymode      ,
  ismode      ,
  //
  irbuf_full  ,
  irdat       ,
  irtag       ,
  oread       ,
  orempty     ,
  oraddr      ,
  //
  iwbuf_empty ,
  //
  owrite      ,
  owfull      ,
  owaddr      ,
  owdat       ,
  owtag       ,
  //
  oxmode      ,
  oymode      ,
  osmode
);

  `include "../btc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                            iclk        ;
  input  logic                            ireset      ;
  input  logic                            iclkena     ;
  //
  input  btc_code_mode_t                  ixmode      ;
  input  btc_code_mode_t                  iymode      ;
  input  btc_short_mode_t                 ismode      ;
  //
  input  logic                            irbuf_full  ;
  input  logic             [pDAT_W-1 : 0] irdat       ;
  input  logic             [pTAG_W-1 : 0] irtag       ;
  output logic                            oread       ;
  output logic                            orempty     ;
  output logic            [pADDR_W-1 : 0] oraddr      ;
  //
  input  logic                            iwbuf_empty ;
  //
  output logic                            owrite      ;
  output logic                            owfull      ;
  output logic            [pADDR_W-1 : 0] owaddr      ;
  output logic             [pDAT_W-1 : 0] owdat       ;
  output logic             [pTAG_W-1 : 0] owtag       ;
  //
  output btc_code_mode_t                  oxmode      ;
  output btc_code_mode_t                  oymode      ;
  output btc_short_mode_t                 osmode      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cDAT_W   = 8;
  localparam int cADDR_W  = $clog2(cROW_MAX * cCOL_MAX/cDAT_W);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // ctrl
  logic [cADDR_W-1 : 0] ctrl__obuf_addr     ;
  //
  logic                 ctrl__orow_mode     ;
  //
  logic                 ctrl__irow_enc_busy ;
  logic                 ctrl__orow_enc_sop  ;
  logic                 ctrl__orow_enc_eop  ;
  logic                 ctrl__orow_enc_val  ;
  //
  logic                 ctrl__icol_enc_busy ;
  logic                 ctrl__ocol_enc_sop  ;
  logic                 ctrl__ocol_enc_eop  ;
  logic                 ctrl__ocol_enc_eof  ;
  logic                 ctrl__ocol_enc_val  ;
  //
  logic                 ctrl__iwrite_busy   ;
  logic                 ctrl__owrite        ;
  logic                 ctrl__owfull        ;

  //
  // 1 row code, bitwidth = cDATW
  logic                 row_code__isop    ;
  logic                 row_code__ieop    ;
  logic                 row_code__ival    ;
  logic  [cDAT_W-1 : 0] row_code__idat    ;
  //
  logic                 row_code__osop    ;
  logic                 row_code__oeop    ;
  logic                 row_code__oval    ;
  logic  [cDAT_W-1 : 0] row_code__odat    ;

  //
  // cDAT_W col code, bitwidth = 1
  logic                 col_code__isop    ;
  logic                 col_code__ieop    ;
  logic                 col_code__ieof    ;
  logic                 col_code__ival    ;
  logic  [cDAT_W-1 : 0] col_code__idat    ;
  //
  logic  [cDAT_W-1 : 0] col_code__osop    ;
  logic  [cDAT_W-1 : 0] col_code__oeop    ;
  logic  [cDAT_W-1 : 0] col_code__oval    ;
  logic  [cDAT_W-1 : 0] col_code__odat    ;

  //
  // mem block
  logic                 mem__iwrite   ;
  logic [cADDR_W-1 : 0] mem__iwaddr   ;
  logic  [cDAT_W-1 : 0] mem__iwdat    ;
  //
  logic [cADDR_W-1 : 0] mem__iraddr   ;
  logic  [cDAT_W-1 : 0] mem__ordat    ;

  //------------------------------------------------------------------------------------------------------
  // ctrl
  //------------------------------------------------------------------------------------------------------

  btc_enc_ctrl
  #(
    .pADDR_W ( cADDR_W )
  )
  ctrl
  (
    .iclk          ( iclk                ) ,
    .ireset        ( ireset              ) ,
    .iclkena       ( iclkena             ) ,
    //
    .ixmode        ( ixmode              ) ,
    .iymode        ( iymode              ) ,
    .ismode        ( ismode              ) ,
    //
    .irbuf_full    ( irbuf_full          ) ,
    .orempty       ( orempty             ) ,
    //
    .iwbuf_empty   ( iwbuf_empty         ) ,
    //
    .obuf_addr     ( ctrl__obuf_addr     ) ,
    //
    .orow_mode     ( ctrl__orow_mode     ) ,
    //
    .irow_enc_busy ( ctrl__irow_enc_busy ) ,
    .orow_enc_sop  ( ctrl__orow_enc_sop  ) ,
    .orow_enc_eop  ( ctrl__orow_enc_eop  ) ,
    .orow_enc_val  ( ctrl__orow_enc_val  ) ,
    //
    .icol_enc_busy ( ctrl__icol_enc_busy ) ,
    .ocol_enc_sop  ( ctrl__ocol_enc_sop  ) ,
    .ocol_enc_eop  ( ctrl__ocol_enc_eop  ) ,
    .ocol_enc_eof  ( ctrl__ocol_enc_eof  ) ,
    .ocol_enc_val  ( ctrl__ocol_enc_val  ) ,
    //
    .iwrite_busy   ( ctrl__iwrite_busy   ) ,
    .owrite        ( ctrl__owrite        ) ,
    .owfull        ( ctrl__owfull        )
  );

  assign ctrl__irow_enc_busy = row_code__oval;
  assign ctrl__icol_enc_busy = col_code__oval;
  assign ctrl__iwrite_busy   = owrite;

  //------------------------------------------------------------------------------------------------------
  // address/controls align line
  // ibuffer & internl ram read latency is 2 tick
  //------------------------------------------------------------------------------------------------------

  assign oraddr = ctrl__obuf_addr;

  logic         [1 : 0] val_line;
  logic         [1 : 0] sop_line;
  logic         [1 : 0] eop_line;
  logic         [1 : 0] eof_line;

  logic         [1 : 0] write_line;
  logic         [1 : 0] wfull_line;

  logic [cADDR_W-1 : 0] addr_line [3];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      val_line <= (val_line << 1) | (ctrl__orow_mode ? ctrl__orow_enc_val : ctrl__ocol_enc_val);
      sop_line <= (sop_line << 1) | (ctrl__orow_mode ? ctrl__orow_enc_sop : ctrl__ocol_enc_sop);
      eop_line <= (eop_line << 1) | (ctrl__orow_mode ? ctrl__orow_enc_eop : ctrl__ocol_enc_eop);
      eof_line <= (eof_line << 1) |  ctrl__ocol_enc_eof;
      //
      for (int i = 0; i < 3; i++) begin
        addr_line[i] <= (i == 0) ? ctrl__obuf_addr : addr_line[i-1];
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      write_line <= '0;
      wfull_line <= '0;
    end
    else if (iclkena) begin
      write_line <= (write_line << 1) | ctrl__owrite;
      wfull_line <= (wfull_line << 1) | ctrl__owfull;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // row encoder cDAT_W width
  //------------------------------------------------------------------------------------------------------

  btc_enc_row_code
  row_code
  (
    .iclk    ( iclk            ) ,
    .ireset  ( ireset          ) ,
    .iclkena ( iclkena         ) ,
    //
    .imode   ( ixmode          ) ,
    //
    .isop    ( row_code__isop  ) ,
    .ieop    ( row_code__ieop  ) ,
    .ival    ( row_code__ival  ) ,
    .idat    ( row_code__idat  ) ,
    //
    .osop    ( row_code__osop  ) ,
    .oeop    ( row_code__oeop  ) ,
    .oval    ( row_code__oval  ) ,
    .odat    ( row_code__odat  )
  );

  assign row_code__isop   = sop_line[1] ;
  assign row_code__ieop   = eop_line[1] ;
  assign row_code__ival   = val_line[1] & ctrl__orow_mode;

  assign row_code__idat   = irdat ;

  //------------------------------------------------------------------------------------------------------
  // array of column coders
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < cDAT_W; g++) begin : col_enc_inst_gen
      btc_enc_col_code
      col_code
      (
        .iclk    ( iclk                ) ,
        .ireset  ( ireset              ) ,
        .iclkena ( iclkena             ) ,
        //
        .imode   ( iymode              ) ,
        //
        .isop    ( col_code__isop      ) ,
        .ieop    ( col_code__ieop      ) ,
        .ieof    ( col_code__ieof      ) ,
        .ival    ( col_code__ival      ) ,
        .idat    ( col_code__idat  [g] ) ,
        //
        .osop    ( col_code__osop  [g] ) ,
        .oeop    ( col_code__oeop  [g] ) ,
        .oval    ( col_code__oval  [g] ) ,
        .odat    ( col_code__odat  [g] )
      );
    end
  endgenerate

  assign col_code__isop   = sop_line[1] ;
  assign col_code__ieop   = eop_line[1] ;
  assign col_code__ieof   = eof_line[1] ;
  assign col_code__ival   = val_line[1] & !ctrl__orow_mode;

  assign col_code__idat   = mem__ordat ;

  //------------------------------------------------------------------------------------------------------
  // internal ram buffer
  //------------------------------------------------------------------------------------------------------

  codec_mem_block
  #(
    .pADDR_W ( cADDR_W ) ,
    .pDAT_W  ( cDAT_W  ) ,
    .pPIPE   ( 1       )
  )
  mem
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .iwrite  ( mem__iwrite  ) ,
    .iwaddr  ( mem__iwaddr  ) ,
    .iwdat   ( mem__iwdat   ) ,
    //
    .iraddr  ( mem__iraddr  ) ,
    .ordat   ( mem__ordat   )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      mem__iwrite <= ctrl__orow_mode ? row_code__oval : col_code__oval[0];
      mem__iwdat  <= ctrl__orow_mode ? row_code__odat : col_code__odat;
      mem__iwaddr <= addr_line[2]; // row/col code delay is +1 tick
    end
  end

  assign mem__iraddr = ctrl__obuf_addr;

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite  <= 1'b0;
      owfull  <= 1'b0;
    end
    else if (iclkena) begin
      owrite  <= write_line[1];
      owfull  <= wfull_line[1];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owdat   <= mem__ordat;
      owaddr  <= addr_line[1];
      //
      if (write_line == 2'b01) begin // posedge
        owtag   <= irtag;
        oxmode  <= ixmode;
        oymode  <= iymode;
        osmode  <= ismode;
      end
    end
  end

endmodule

