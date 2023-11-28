/*



  parameter int pLLR_W   =  4 ;
  parameter int pEXTR_W  =  5 ;
  //
  parameter int pERR_W   = 16 ;
  //
  parameter int pDEC_NUM =  8 ;



  logic                   btc_dec_comp_code_sink__iclk                 ;
  logic                   btc_dec_comp_code_sink__ireset               ;
  logic                   btc_dec_comp_code_sink__iclkena              ;
  //
  logic                   btc_dec_comp_code_sink__irow_mode            ;
  //
  logic  [pDEC_NUM-1 : 0] btc_dec_comp_code_sink__ival                 ;
  strb_t                  btc_dec_comp_code_sink__istrb     [pDEC_NUM] ;
  extr_t                  btc_dec_comp_code_sink__iLextr    [pDEC_NUM] ;
  logic  [pDEC_NUM-1 : 0] btc_dec_comp_code_sink__ibitdat              ;
  logic  [pDEC_NUM-1 : 0] btc_dec_comp_code_sink__ibiterr              ;
  //
  logic                   btc_dec_comp_code_sink__oval                 ;
  strb_t                  btc_dec_comp_code_sink__ostrb                ;
  extr_t                  btc_dec_comp_code_sink__oLextr    [pDEC_NUM] ;
  logic  [pDEC_NUM-1 : 0] btc_dec_comp_code_sink__obitdat              ;
  logic  [pDEC_NUM-1 : 0] btc_dec_comp_code_sink__obiterr              ;



  btc_dec_comp_code_sink
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pEXTR_W  ( pEXTR_W  ) ,
    //
    .pERR_W   ( pERR_W   ) ,
    //
    .pDEC_NUM ( pDEC_NUM )
  )
  btc_dec_comp_code_sink
  (
    .iclk      ( btc_dec_comp_code_sink__iclk      ) ,
    .ireset    ( btc_dec_comp_code_sink__ireset    ) ,
    .iclkena   ( btc_dec_comp_code_sink__iclkena   ) ,
    //
    .irow_mode ( btc_dec_comp_code_sink__irow_mode ) ,
    //
    .ival      ( btc_dec_comp_code_sink__ival      ) ,
    .istrb     ( btc_dec_comp_code_sink__istrb     ) ,
    .iLextr    ( btc_dec_comp_code_sink__iLextr    ) ,
    .ibitdat   ( btc_dec_comp_code_sink__ibitdat   ) ,
    .ibiterr   ( btc_dec_comp_code_sink__ibiterr   ) ,
    //
    .oval      ( btc_dec_comp_code_sink__oval      ) ,
    .ostrb     ( btc_dec_comp_code_sink__ostrb     ) ,
    .oLextr    ( btc_dec_comp_code_sink__oLextr    ) ,
    .obitdat   ( btc_dec_comp_code_sink__obitdat   ) ,
    .obiterr   ( btc_dec_comp_code_sink__obiterr   )
  );


  assign btc_dec_comp_code_sink__iclk      = '0 ;
  assign btc_dec_comp_code_sink__ireset    = '0 ;
  assign btc_dec_comp_code_sink__iclkena   = '0 ;
  assign btc_dec_comp_code_sink__irow_mode = '0 ;
  assign btc_dec_comp_code_sink__ival      = '0 ;
  assign btc_dec_comp_code_sink__istrb     = '0 ;
  assign btc_dec_comp_code_sink__iLextr    = '0 ;
  assign btc_dec_comp_code_sink__ibitdat   = '0 ;
  assign btc_dec_comp_code_sink__ibiterr   = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code_sink.sv
// Description   : component code array output sink unit
//                 column mode bypass data as is
//                 row mode assemble data to vectors and write to memory
//

module btc_dec_comp_code_sink
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  irow_mode ,
  //
  ival      ,
  istrb     ,
  iLextr    ,
  ibitdat   ,
  ibiterr   ,
  //
  oval      ,
  ostrb     ,
  oLextr    ,
  obitdat   ,
  obiterr
);

  parameter int pERR_W   = 16 ;
  parameter int pDEC_NUM =  8 ;

  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk                 ;
  input  logic                   ireset               ;
  input  logic                   iclkena              ;
  //
  input  logic                   irow_mode            ;
  //
  input  logic  [pDEC_NUM-1 : 0] ival                 ;
  input  strb_t                  istrb     [pDEC_NUM] ;
  input  extr_t                  iLextr    [pDEC_NUM] ;
  input  logic  [pDEC_NUM-1 : 0] ibitdat              ;
  input  logic  [pDEC_NUM-1 : 0] ibiterr              ;
  //
  output logic                   oval                 ;
  output strb_t                  ostrb                ;
  output extr_t                  oLextr    [pDEC_NUM] ;
  output logic  [pDEC_NUM-1 : 0] obitdat              ;
  output logic  [pDEC_NUM-1 : 0] obiterr              ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cASM_DAT_W = pEXTR_W + 2; // + bitdat + biterr

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // vector assembler
  logic                     asm__ival  [pDEC_NUM]           ;
  strb_t                    asm__istrb [pDEC_NUM]           ;
  logic  [cASM_DAT_W-1 : 0] asm__idat  [pDEC_NUM]           ;
  //
  logic                     asm__oval  [pDEC_NUM]           ;
  strb_t                    asm__ostrb [pDEC_NUM]           ;
  logic  [cASM_DAT_W-1 : 0] asm__odat  [pDEC_NUM][pDEC_NUM] ;

  //
  //
  logic    [pDEC_NUM-1 : 0] vect_val;
  strb_t                    vect_strb   [pDEC_NUM];
  extr_t                    vect_Lextr  [pDEC_NUM][pDEC_NUM];
  logic    [pDEC_NUM-1 : 0] vect_bitdat [pDEC_NUM];
  logic    [pDEC_NUM-1 : 0] vect_biterr [pDEC_NUM];

  //------------------------------------------------------------------------------------------------------
  // serial - parralel assembler's
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < pDEC_NUM; g++) begin : asm_inst_gen
      btc_dec_comp_code_asm
      #(
        .pDAT_W   ( cASM_DAT_W ) ,
        .pDEC_NUM ( pDEC_NUM   )
      )
      asm
      (
        .iclk    ( iclk           ) ,
        .ireset  ( ireset         ) ,
        .iclkena ( iclkena        ) ,
        //
        .ival    ( asm__ival  [g] ) ,
        .istrb   ( asm__istrb [g] ) ,
        .idat    ( asm__idat  [g] ) ,
        //
        .oval    ( asm__oval  [g] ) ,
        .ostrb   ( asm__ostrb [g] ) ,
        .odat    ( asm__odat  [g] )
      );

      assign asm__ival  [g] =  ival    [g];
      assign asm__istrb [g] =  istrb   [g];
      assign asm__idat  [g] = {ibiterr [g], ibitdat [g], iLextr[g]};
    end
  endgenerate

  always_comb begin
    for (int i = 0; i < pDEC_NUM; i++) begin
      vect_val  [i] = asm__oval [i];
      vect_strb [i] = asm__ostrb[i];
      for (int b = 0; b < pDEC_NUM; b++) begin
        {vect_biterr[i][b], vect_bitdat[i][b], vect_Lextr[i][b]} = asm__odat[i][b];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mux
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      if (irow_mode) begin // work quasi parallel
        oval <= |vect_val;
      end
      else begin // work parallel
        oval <= ival[0];
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // Lextr use in col/row stages
      if (irow_mode) begin
        ostrb   <= vect_strb   [0];
        oLextr  <= vect_Lextr  [0];
        obitdat <= vect_bitdat [0];
        obiterr <= vect_biterr [0];
        //
        for (int i = 1; i < pDEC_NUM; i++) begin
          if (vect_val[i]) begin
            ostrb   <= vect_strb   [i];
            oLextr  <= vect_Lextr  [i];
            obitdat <= vect_bitdat [i];
            obiterr <= vect_biterr [i];
          end
        end
      end
      else begin
        ostrb   <= istrb[0];
        oLextr  <= iLextr;
        obitdat <= ibitdat;
        obiterr <= ibiterr;
      end
    end
  end

endmodule

