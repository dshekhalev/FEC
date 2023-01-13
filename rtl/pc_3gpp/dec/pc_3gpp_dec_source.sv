/*



  parameter int pN_MAX    = 1024 ;
  parameter int pLLR_W    =    4 ;
  parameter bit pUSE_CRC  =    1 ;
  parameter int pTAG_W    =    4 ;



  logic      pc_3gpp_dec_source__iclk            ;
  logic      pc_3gpp_dec_source__ireset          ;
  logic      pc_3gpp_dec_source__iclkena         ;
  dlen_t     pc_3gpp_dec_source__idlen           ;
  logic      pc_3gpp_dec_source__isop            ;
  logic      pc_3gpp_dec_source__ival            ;
  logic      pc_3gpp_dec_source__ieop            ;
  llr_t      pc_3gpp_dec_source__iLLR            ;
  tag_t      pc_3gpp_dec_source__itag            ;
  logic      pc_3gpp_dec_source__ordy            ;
  logic      pc_3gpp_dec_source__obusy           ;
  logic      pc_3gpp_dec_source__ifulla          ;
  logic      pc_3gpp_dec_source__iemptya         ;
  logic      pc_3gpp_dec_source__owrite          ;
  logic      pc_3gpp_dec_source__owfull          ;
  bit_addr_t pc_3gpp_dec_source__owLLR_addr      ;
  bit_addr_t pc_3gpp_dec_source__owLLR_frzb_addr ;
  bit_addr_t pc_3gpp_dec_source__owfrzb_addr     ;
  llr_t      pc_3gpp_dec_source__owLLR           ;
  logic      pc_3gpp_dec_source__owfrzb          ;
  tag_t      pc_3gpp_dec_source__owtag           ;
  dlen_t     pc_3gpp_dec_source__odlen           ;



  pc_3gpp_dec_source
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pLLR_W   ( pLLR_W   ) ,
    .pUSE_CRC ( pUSE_CRC ) ,
    .pTAG_W   ( pTAG_W   )
  )
  pc_3gpp_dec_source
  (
    .iclk            ( pc_3gpp_dec_source__iclk            ) ,
    .ireset          ( pc_3gpp_dec_source__ireset          ) ,
    .iclkena         ( pc_3gpp_dec_source__iclkena         ) ,
    .idlen           ( pc_3gpp_dec_source__idlen           ) ,
    .isop            ( pc_3gpp_dec_source__isop            ) ,
    .ival            ( pc_3gpp_dec_source__ival            ) ,
    .ieop            ( pc_3gpp_dec_source__ieop            ) ,
    .iLLR            ( pc_3gpp_dec_source__iLLR            ) ,
    .itag            ( pc_3gpp_dec_source__itag            ) ,
    .ordy            ( pc_3gpp_dec_source__ordy            ) ,
    .obusy           ( pc_3gpp_dec_source__obusy           ) ,
    .ifulla          ( pc_3gpp_dec_source__ifulla          ) ,
    .iemptya         ( pc_3gpp_dec_source__iemptya         ) ,
    .owrite          ( pc_3gpp_dec_source__owrite          ) ,
    .owfull          ( pc_3gpp_dec_source__owfull          ) ,
    .owLLR_addr      ( pc_3gpp_dec_source__owLLR_addr      ) ,
    .owLLR_frzb_addr ( pc_3gpp_dec_source__owLLR_frzb_addr ) ,
    .owfrzb_addr     ( pc_3gpp_dec_source__owfrzb_addr     ) ,
    .owLLR           ( pc_3gpp_dec_source__owLLR           ) ,
    .owfrzb          ( pc_3gpp_dec_source__owfrzb          ) ,
    .owtag           ( pc_3gpp_dec_source__owtag           ) ,
    .odlen           ( pc_3gpp_dec_source__odlen           )
  );


  assign pc_3gpp_dec_source__iclk    = '0 ;
  assign pc_3gpp_dec_source__ireset  = '0 ;
  assign pc_3gpp_dec_source__iclkena = '0 ;
  assign pc_3gpp_dec_source__idlen   = '0 ;
  assign pc_3gpp_dec_source__isop    = '0 ;
  assign pc_3gpp_dec_source__ival    = '0 ;
  assign pc_3gpp_dec_source__ieop    = '0 ;
  assign pc_3gpp_dec_source__idat    = '0 ;
  assign pc_3gpp_dec_source__itag    = '0 ;
  assign pc_3gpp_dec_source__iemptya = '0 ;
  assign pc_3gpp_dec_source__ifulla  = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_source.sv
// Description   : Polar decoder source module: do reverse bit order frame conversion, frozen bit maps generation
//

`include "define.vh"

module pc_3gpp_dec_source
(
  iclk            ,
  ireset          ,
  iclkena         ,
  //
  idlen           ,
  //
  isop            ,
  ival            ,
  ieop            ,
  iLLR            ,
  itag            ,
  //
  ordy            ,
  obusy           ,
  //
  ifulla          ,
  iemptya         ,
  //
  owrite          ,
  owfull          ,
  owLLR_addr      ,
  owfrzb_addr     ,
  owLLR_frzb_addr ,
  owLLR           ,
  owfrzb          ,
  owtag           ,
  //
  odlen
);

  `include "pc_3gpp_dec_types.svh"

  parameter bit pUSE_CRC  = 0 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk            ;
  input  logic      ireset          ;
  input  logic      iclkena         ;
  //
  input  dlen_t     idlen           ;
  //
  input  logic      isop            ;
  input  logic      ival            ;
  input  logic      ieop            ;
  input  llr_t      iLLR            ;
  input  tag_t      itag            ;
  //
  output logic      ordy            ;
  output logic      obusy           ;
  // 2D buffer state
  input  logic      ifulla          ;
  input  logic      iemptya         ;
  //
  output logic      owrite          ;
  output logic      owfull          ;
  output bit_addr_t owLLR_addr      ;
  output bit_addr_t owfrzb_addr     ;
  output bit_addr_t owLLR_frzb_addr ;
  output llr_t      owLLR           ;
  output logic      owfrzb          ;
  output tag_t      owtag           ;
  //
  output dlen_t     odlen           ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../pc_3gpp_ts_38_212_tab.svh"

  bit_addr_t  waddr_la; // look ahead address

  bit_addr_t  wLLR_addr;
  bit_addr_t  wfrzb_addr;

  bit_addr_t  USED_DLEN;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  wire val = ival & ordy;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite  <= '0;
      owfull  <= '0;
    end
    else if (iclkena) begin
      owrite  <= val;
      owfull  <= val & ieop;
    end
  end

  assign USED_DLEN = pUSE_CRC ? (odlen + cCRC_W) : odlen;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val) begin
        if (&{iLLR[pLLR_W-1], ~iLLR[pLLR_W-2 : 0]}) begin // -2^(N-1)
          owLLR <= {1'b0, {(pLLR_W-2){1'b1}} ,1'b1};      // (2^(N-1) - 1)
        end
        else begin
          owLLR <= -iLLR;
        end
        //
        waddr_la    <= isop ?             1'b1 : (waddr_la + 1'b1);
        wLLR_addr   <= isop ?               '0 :  waddr_la;
        wfrzb_addr  <= isop ? bits_addr_tab[0] : bits_addr_tab[waddr_la];
        //
        owfrzb      <= isop ?             1'b0 : (waddr_la >= USED_DLEN);
        //
        if (isop) begin
          odlen <= idlen;
          owtag <= itag;
        end
      end
    end
  end

  assign owLLR_addr       = reverse_bit(wLLR_addr,  cNLOG2);  // chLLR addres
  assign owLLR_frzb_addr  = reverse_bit(wfrzb_addr, cNLOG2);  // frozen bit map for re encode
  assign owfrzb_addr      = wfrzb_addr;                       // frozen bit map for decoding

  assign ordy   = !owfull & !ifulla;  // not ready if all buffers is full
  assign obusy  =  owfull | !iemptya; // busy if any buffer is not empty

endmodule
