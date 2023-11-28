/*



  parameter int pLLR_W   = 4 ;
  parameter int pEXTR_W  = 5 ;
  //
  parameter int pDEC_NUM = 8 ;



  logic                    btc_dec_comp_code_source__iclk                 ;
  logic                    btc_dec_comp_code_source__ireset               ;
  logic                    btc_dec_comp_code_source__iclkena              ;
  //
  logic                    btc_dec_comp_code_source__irow_mode            ;
  //
  logic   [pDEC_NUM-1 : 0] btc_dec_comp_code_source__ival                 ;
  strb_t                   btc_dec_comp_code_source__istrb                ;
  logic                    btc_dec_comp_code_source__ismask    [pDEC_NUM] ;
  llr_t                    btc_dec_comp_code_source__iLLR      [pDEC_NUM] ;
  extr_t                   btc_dec_comp_code_source__iLextr    [pDEC_NUM] ;
  alpha_t                  btc_dec_comp_code_source__ialpha               ;
  //
  logic                    btc_dec_comp_code_source__oval      [pDEC_NUM] ;
  strb_t                   btc_dec_comp_code_source__ostrb     [pDEC_NUM] ;
  logic                    btc_dec_comp_code_source__och_hd    [pDEC_NUM] ;
  extr_t                   btc_dec_comp_code_source__oLapri    [pDEC_NUM] ;



  btc_dec_comp_code_source
  #(
    .pLLR_W   ( pLLR_W   ) ,
    .pEXTR_W  ( pEXTR_W  ) ,
    //
    .pDEC_NUM ( pDEC_NUM )
  )
  btc_dec_comp_code_source
  (
    .iclk      ( btc_dec_comp_code_source__iclk      ) ,
    .ireset    ( btc_dec_comp_code_source__ireset    ) ,
    .iclkena   ( btc_dec_comp_code_source__iclkena   ) ,
    //
    .irow_mode ( btc_dec_comp_code_source__irow_mode ) ,
    //
    .ival      ( btc_dec_comp_code_source__ival      ) ,
    .istrb     ( btc_dec_comp_code_source__istrb     ) ,
    .ismask    ( btc_dec_comp_code_source__ismask    ) ,
    .iLLR      ( btc_dec_comp_code_source__iLLR      ) ,
    .iLextr    ( btc_dec_comp_code_source__iLextr    ) ,
    .ialpha    ( btc_dec_comp_code_source__ialpha    ) ,
    //
    .oval      ( btc_dec_comp_code_source__oval      ) ,
    .ostrb     ( btc_dec_comp_code_source__ostrb     ) ,
    .och_hd    ( btc_dec_comp_code_source__och_hd    ) ,
    .oLapri    ( btc_dec_comp_code_source__oLapri    )
  );


  assign btc_dec_comp_code_source__iclk      = '0 ;
  assign btc_dec_comp_code_source__ireset    = '0 ;
  assign btc_dec_comp_code_source__iclkena   = '0 ;
  assign btc_dec_comp_code_source__irow_mode = '0 ;
  assign btc_dec_comp_code_source__ival      = '0 ;
  assign btc_dec_comp_code_source__istrb     = '0 ;
  assign btc_dec_comp_code_source__ismask    = '0 ;
  assign btc_dec_comp_code_source__iLLR      = '0 ;
  assign btc_dec_comp_code_source__iLextr    = '0 ;
  assing btc_dec_comp_code_source__ialpha    = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code_source.sv
// Description   : component code source unit for row/col mode.
//                 col mode its simple register for single indexed metrics
//                 row mode its LLR/Lextr serializer from line
//

module btc_dec_comp_code_source
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  irow_mode ,
  //
  ival      ,
  istrb     ,
  ismask    ,
  iLLR      ,
  iLextr    ,
  ialpha    ,
  //
  oval      ,
  ostrb     ,
  och_hd    ,
  oLapri
);

  parameter int pDEC_NUM = 8 ;

  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                    iclk                 ;
  input  logic                    ireset               ;
  input  logic                    iclkena              ;
  //
  input  logic                    irow_mode            ;
  //
  input  logic   [pDEC_NUM-1 : 0] ival                 ;
  input  strb_t                   istrb                ;
  input  logic                    ismask    [pDEC_NUM] ;
  input  llr_t                    iLLR      [pDEC_NUM] ;
  input  extr_t                   iLextr    [pDEC_NUM] ;
  input  alpha_t                  ialpha               ;
  //
  output logic                    oval      [pDEC_NUM] ;
  output strb_t                   ostrb     [pDEC_NUM] ;
  output logic                    och_hd    [pDEC_NUM] ;
  output extr_t                   oLapri    [pDEC_NUM] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DEC_NUM = $clog2(pDEC_NUM);

  localparam int cSER_DAT_W = pEXTR_W + 1; // + hd

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic  [pDEC_NUM-1 : 0] val;
  strb_t                  strb;
  logic                   smask       [pDEC_NUM] ;

  logic                   ch_hd       [pDEC_NUM] ;
  extr_p1_t               Lapri       [pDEC_NUM] ;
  extr_t                  satLapri    [pDEC_NUM] ;

  //
  // serializers
  logic  [pDEC_NUM-1 : 0] ser__ival              ;
  strb_t                  ser__istrb             ;
  logic     [pEXTR_W : 0] ser__idat   [pDEC_NUM] ;
  //
  logic                   ser__oval   [pDEC_NUM] ;
  strb_t                  ser__ostrb  [pDEC_NUM] ;
  logic     [pEXTR_W : 0] ser__odat   [pDEC_NUM] ;


  //------------------------------------------------------------------------------------------------------
  // get Lapri
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      strb  <= istrb;
      smask <= ismask;
      for (int i = 0; i < pDEC_NUM; i++) begin
        if (ismask[i]) begin
          ch_hd[i] <= 1'b0;
          Lapri[i] <= -(2**(pLLR_W-1)-1); // strongest zero for shortened
        end
        else begin
          ch_hd[i] <= (iLLR[i] >= 0);
          Lapri[i] <=  iLLR[i] + do_scale(iLextr[i], ialpha);
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // saturate Lapri
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ser__ival <= '0;
    end
    else if (iclkena) begin
      ser__ival <= val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ser__istrb <= strb;
      for (int i = 0; i < pDEC_NUM; i++) begin
        ser__idat[i][pEXTR_W]       <= ch_hd[i];
        ser__idat[i][pEXTR_W-1 : 0] <= do_saturation(Lapri[i]);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // serializers
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < pDEC_NUM; g++) begin : ser_inst_gen
      btc_dec_comp_code_ser
      #(
        .pDAT_W   ( pEXTR_W + 1 ) ,
        .pDEC_NUM ( pDEC_NUM    ) ,
        .pDEC_IDX ( g           )
      )
      ser
      (
        .iclk      ( iclk           ) ,
        .ireset    ( ireset         ) ,
        .iclkena   ( iclkena        ) ,
        //
        .irow_mode ( irow_mode      ) ,
        //
        .ival      ( ser__ival  [g] ) ,
        .istrb     ( ser__istrb     ) ,
        .idat      ( ser__idat      ) ,
        //
        .oval      ( ser__oval  [g] ) ,
        .ostrb     ( ser__ostrb [g] ) ,
        .odat      ( ser__odat  [g] )
      );

      assign  oval   [g] = ser__oval  [g];
      assign  ostrb  [g] = ser__ostrb [g];
      assign {och_hd [g],
              oLapri [g]} = ser__odat [g];
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function extr_t do_saturation (input extr_p1_t data);
    logic poverflow;
    logic noverflow;
  begin
    poverflow     = (data >  (2**(pEXTR_W-1)-1));
    noverflow     = (data < -(2**(pEXTR_W-1)-1));
    do_saturation = data[pEXTR_W-1 : 0];
    //
    if (poverflow) begin
      do_saturation =  (2**(pEXTR_W-1)-1);
    end
    else if (noverflow) begin
      do_saturation = -(2**(pEXTR_W-1)-1);
    end
  end
  endfunction

endmodule
