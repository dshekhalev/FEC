/*



  parameter int pDAT_W   = 8 ;
  parameter int pDEC_NUM = 8 ;
  parameter int pDEC_IDX = 0 ;



  logic                 btc_dec_comp_code_ser__iclk                 ;
  logic                 btc_dec_comp_code_ser__ireset               ;
  logic                 btc_dec_comp_code_ser__iclkena              ;
  //
  logic                 btc_dec_comp_code_ser__irow_mode            ;
  //
  logic                 btc_dec_comp_code_ser__ival                 ;
  strb_t                btc_dec_comp_code_ser__istrb                ;
  logic  [pDAT_W-1 : 0] btc_dec_comp_code_ser__idat      [pDEC_NUM] ;
  //
  logic                 btc_dec_comp_code_ser__oval                 ;
  strb_t                btc_dec_comp_code_ser__ostrb                ;
  logic  [pDAT_W-1 : 0] btc_dec_comp_code_ser__odat                 ;



  btc_dec_comp_code_ser
  #(
    .pDAT_W   ( pDAT_W   ) ,
    .pDEC_NUM ( pDEC_NUM ) ,
    .pDEC_IDX ( pDEC_IDX )
  )
  btc_dec_comp_code_ser
  (
    .iclk      ( btc_dec_comp_code_ser__iclk      ) ,
    .ireset    ( btc_dec_comp_code_ser__ireset    ) ,
    .iclkena   ( btc_dec_comp_code_ser__iclkena   ) ,
    //
    .irow_mode ( btc_dec_comp_code_ser__irow_mode ) ,
    //
    .ival      ( btc_dec_comp_code_ser__ival      ) ,
    .istrb     ( btc_dec_comp_code_ser__istrb     ) ,
    .idat      ( btc_dec_comp_code_ser__idat      ) ,
    //
    .oval      ( btc_dec_comp_code_ser__oval      ) ,
    .ostrb     ( btc_dec_comp_code_ser__ostrb     ) ,
    .odat      ( btc_dec_comp_code_ser__odat      )
  );


  assign btc_dec_comp_code_ser__iclk      = '0 ;
  assign btc_dec_comp_code_ser__ireset    = '0 ;
  assign btc_dec_comp_code_ser__iclkena   = '0 ;
  assign btc_dec_comp_code_ser__irow_mode = '0 ;
  assign btc_dec_comp_code_ser__ival      = '0 ;
  assign btc_dec_comp_code_ser__istrb     = '0 ;
  assign btc_dec_comp_code_ser__idat      = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_comp_code_ser.sv
// Description   : component code serializer unit for row mode
//                 generate serial stream from pDEC_NUM vector
//


module btc_dec_comp_code_ser
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  irow_mode ,
  //
  ival      ,
  istrb     ,
  idat      ,
  //
  oval      ,
  ostrb     ,
  odat
);

  parameter int pDAT_W   = 4 ;
  parameter int pDEC_NUM = 8 ;
  parameter int pDEC_IDX = 0 ;

  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk                 ;
  input  logic                 ireset               ;
  input  logic                 iclkena              ;
  //
  input  logic                 irow_mode            ;
  //
  input  logic                 ival                 ;
  input  strb_t                istrb                ;
  input  logic  [pDAT_W-1 : 0] idat      [pDEC_NUM] ;
  //
  output logic                 oval                 ;
  output strb_t                ostrb                ;
  output logic  [pDAT_W-1 : 0] odat                 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLOG2_DEC_NUM = $clog2(pDEC_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [cLOG2_DEC_NUM : 0] val_cnt;

  strb_t                    strb;
  logic      [pDAT_W-1 : 0] dat_line [pDEC_NUM];

  //------------------------------------------------------------------------------------------------------
  // val generator
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val_cnt <= '0;
    end
    else if (iclkena) begin
      if (ival) begin
        if (irow_mode) begin
          val_cnt <= '0;
          val_cnt[cLOG2_DEC_NUM] <= 1'b1;
        end
        else begin
          val_cnt <= '1; // single pulse
        end
      end
      else begin
        val_cnt <= val_cnt + val_cnt[cLOG2_DEC_NUM];
      end
    end
  end

  assign oval = val_cnt[cLOG2_DEC_NUM];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // latch strobe for regeneration
      if (ival) begin
        strb <= istrb;
      end
      //
      if (irow_mode) begin
        // regenerate strobes
        ostrb.sof <= istrb.sof & ival;
        ostrb.sop <= istrb.sop & ival;
        ostrb.eop <=  strb.eop & (val_cnt[cLOG2_DEC_NUM-1 : 0] == (pDEC_NUM-2));
        ostrb.eof <=  strb.eof & (val_cnt[cLOG2_DEC_NUM-1 : 0] == (pDEC_NUM-2));
      end
      else begin
        ostrb <= istrb;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // data shift register : lsb first
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (irow_mode) begin
        if (ival) begin
          dat_line <= idat;
        end
        else begin
          for (int i = 0; i < pDEC_NUM-1; i++) begin
            dat_line [i] <= dat_line [i+1];
          end
        end
      end
      else begin
        if (ival) begin // short mask set m
          dat_line [0] <= idat [pDEC_IDX];
        end
      end
    end
  end

  assign odat = dat_line[0];

endmodule
