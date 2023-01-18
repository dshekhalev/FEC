/*



  parameter int pLLR_W            =  8 ;
  parameter int pLLR_FP           =  8 ;
  parameter int pDTAG_W           =  8 ;
  parameter int pADDR_W           =  8 ;
  parameter bit pUSE_W_BIT        =  1 ;
  parameter bit pUSE_EOP_VAL_MASK =  1 ;



  logic                     rsc_dec_source__iclk            ;
  logic                     rsc_dec_source__ireset          ;
  logic                     rsc_dec_source__iclkena         ;
  code_t                    rsc_dec_source__icode           ;
  dbits_num_t               rsc_dec_source__iN              ;
  logic                     rsc_dec_source__isop            ;
  logic                     rsc_dec_source__ieop            ;
  logic                     rsc_dec_source__ival            ;
  bit_llr_t                 rsc_dec_source__iLLR    [0 : 1] ;
  logic     [pDTAG_W-1 : 0] rsc_dec_source__iLLRtag         ;
  logic                     rsc_dec_source__ifulla          ;
  logic                     rsc_dec_source__iemptya         ;
  logic                     rsc_dec_source__obusy           ;
  logic                     rsc_dec_source__ordy            ;
  logic                     rsc_dec_source__owrite          ;
  logic                     rsc_dec_source__owfull          ;
  logic             [1 : 0] rsc_dec_source__owsel           ;
  logic     [pADDR_W-1 : 0] rsc_dec_source__owaddr          ;
  bit_llr_t                 rsc_dec_source__osLLR   [0 : 1] ;
  bit_llr_t                 rsc_dec_source__oyLLR   [0 : 1] ;
  bit_llr_t                 rsc_dec_source__owLLR   [0 : 1] ;
  logic     [pDTAG_W-1 : 0] rsc_dec_source__osLLRtag        ;


  rsc_dec_source
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pLLR_FP           ( pLLR_FP           ) ,
    .pDTAG_W           ( pDTAG_W           ) ,
    .pADDR_W           ( pADDR_W           ) ,
    .pUSE_W_BIT        ( pUSE_W_BIT        ) ,
    .pUSE_EOP_VAL_MASK ( pUSE_EOP_VAL_MASK )
  )
  rsc_dec_source
  (
    .iclk     ( rsc_dec_source__iclk     ) ,
    .ireset   ( rsc_dec_source__ireset   ) ,
    .iclkena  ( rsc_dec_source__iclkena  ) ,
    .icode    ( rsc_dec_source__icode    ) ,
    .iN       ( rsc_dec_source__iN       ) ,
    .isop     ( rsc_dec_source__isop     ) ,
    .ieop     ( rsc_dec_source__ieop     ) ,
    .ival     ( rsc_dec_source__ival     ) ,
    .iLLR     ( rsc_dec_source__iLLR     ) ,
    .iLLRtag  ( rsc_dec_source__iLLRtag  ) ,
    .ifulla   ( rsc_dec_source__ifulla   ) ,
    .iemptya  ( rsc_dec_source__iemptya  ) ,
    .obusy    ( rsc_dec_source__obusy    ) ,
    .ordy     ( rsc_dec_source__ordy     ) ,
    .owrite   ( rsc_dec_source__owrite   ) ,
    .owfull   ( rsc_dec_source__owfull   ) ,
    .owsel    ( rsc_dec_source__owsel    ) ,
    .owaddr   ( rsc_dec_source__owaddr   ) ,
    .osLLR    ( rsc_dec_source__osLLR    ) ,
    .oyLLR    ( rsc_dec_source__oyLLR    ) ,
    .owLLR    ( rsc_dec_source__owLLR    ) ,
    .osLLRtag ( rsc_dec_source__osLLRtag )
  );


  assign rsc_dec_source__iclk    = '0 ;
  assign rsc_dec_source__ireset  = '0 ;
  assign rsc_dec_source__iclkena = '0 ;
  assign rsc_dec_source__icode   = '0 ;
  assign rsc_dec_source__iN      = '0 ;
  assign rsc_dec_source__isop    = '0 ;
  assign rsc_dec_source__ieop    = '0 ;
  assign rsc_dec_source__ival    = '0 ;
  assign rsc_dec_source__iLLR    = '0 ;
  assign rsc_dec_source__iLLRtag = '0 ;
  assign rsc_dec_source__ifulla  = '0 ;
  assign rsc_dec_source__iemptya = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_source.sv
// Description   : Input interface of decoder. Prepare S/Y/W duobits using puncture pattern in input ram buffer
//


module rsc_dec_source
#(
  parameter int pLLR_W            =  5 ,
  parameter int pLLR_FP           =  2 ,
  parameter int pDTAG_W           =  8 ,
  parameter int pADDR_W           =  8 ,
  //
  parameter bit pUSE_W_BIT        =  1 ,  // 0/1 - not use/use coderate with W bits (icode == 0 or icode == 10/11)
  parameter bit pUSE_EOP_VAL_MASK =  1    // use ieop with ival ANDED, else use single ieop
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  icode    ,
  iN       ,
  //
  isop     ,
  ieop     ,
  ival     ,
  iLLR     ,
  iLLRtag  ,
  //
  ifulla   ,
  iemptya  ,
  obusy    ,
  ordy     ,
  //
  owrite   ,
  owfull   ,
  owsel    ,
  owaddr   ,
  osLLR    ,
  oyLLR    ,
  owLLR    ,
  //
  osLLRtag
);

  `include "../rsc_constants.svh"
  `include "rsc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                     iclk            ;
  input  logic                     ireset          ;
  input  logic                     iclkena         ;
  //
  input  code_t                    icode           ;
  input  dbits_num_t               iN              ;
  //
  input  logic                     isop            ;
  input  logic                     ieop            ;
  input  logic                     ival            ;
  input  bit_llr_t                 iLLR    [0 : 1] ;
  input  logic     [pDTAG_W-1 : 0] iLLRtag         ;
  //
  input  logic                     ifulla          ;
  input  logic                     iemptya         ;
  output logic                     obusy           ;
  output logic                     ordy            ;
  //
  output logic                     owrite          ;
  output logic                     owfull          ;
  output logic             [1 : 0] owsel           ;
  output logic     [pADDR_W-1 : 0] owaddr          ;
  output bit_llr_t                 osLLR   [0 : 1] ;
  output bit_llr_t                 oyLLR   [0 : 1] ;
  output bit_llr_t                 owLLR   [0 : 1] ;
  //
  output logic     [pDTAG_W-1 : 0] osLLRtag        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef struct {
    bit [3 : 0] y[2], w[2];
  } punct_t;

  localparam punct_t cP_PATTERN [0 : 12] = '{
    '{y : '{1, 1}, w : '{1, 1}} , // 1/3
    '{y : '{1, 1}, w : '{0, 0}} , // 1/2
    '{y : '{2, 2}, w : '{0, 0}} , // 2/3
    '{y : '{3, 3}, w : '{0, 0}} , // 3/4
    '{y : '{4, 4}, w : '{0, 0}} , // 4/5
    '{y : '{5, 5}, w : '{0, 0}} , // 5/6
    '{y : '{6, 6}, w : '{0, 0}} , // 6/7
    '{y : '{8, 8}, w : '{0, 0}} , // 7/8  special code rate !!!
    '{y : '{8, 8}, w : '{0, 0}} , // 8/9
    '{y : '{9, 9}, w : '{0, 0}} , // 9/10
    '{y : '{1, 1}, w : '{2, 2}} , // 2/5
    '{y : '{2, 1}, w : '{0, 0}} , // 3/5
    '{y : '{2, 1}, w : '{2, 1}}   // 3/7
  };

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [1:0] {
    cSTATE_ERR      = 2'b00,
    cSTATE_PARITY_Y = 2'b01,
    cSTATE_PARITY_W = 2'b10,
    cSTATE_DATA     = 2'b11
  } state /* synthesis syn_encoding = "sequential" */;

  logic [3 : 0] code;

  logic [pADDR_W   : 0] addr;
  logic                 addr_sel;
  logic         [3 : 0] addr_incr;

  logic [pADDR_W-1 : 0] edgeS;
  logic [pADDR_W-1 : 0] edgeW;

  logic is_edgeS;
  logic is_edgeW;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin
    addr      <= '0;
    addr_incr <= '0;
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  // data preapare & write FSM
  //------------------------------------------------------------------------------------------------------

  assign is_edgeS = (addr >= edgeS);
  assign is_edgeW = ((addr + addr_incr) > edgeW); // (addr >= edgeW);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
      owfull <= 1'b0;
      state  <= cSTATE_ERR;
    end
    else if (iclkena) begin
      owrite <= ival;
      owfull <= ieop & (pUSE_EOP_VAL_MASK ? ival : 1'b1); // sometimes ieop can be used without ival becouse nonintegral puncture is present and direct connection to encoder is possible
      if (ival) begin
        if (isop) begin
          state <= cSTATE_DATA;
        end
        else if ((state == cSTATE_DATA) & is_edgeS) begin
          state <= cSTATE_PARITY_Y;
        end
        else if ((state == cSTATE_PARITY_Y) & is_edgeW) begin
          state <= (cP_PATTERN[code].w[0] == 0 | pUSE_W_BIT == 0) ? cSTATE_ERR : cSTATE_PARITY_W;
        end
      end
    end
  end

  logic [2 : 0] cnt7;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        osLLRtag <= iLLRtag;
        for (int i = 0; i < 2; i++) begin
          if (&{iLLR[i][pLLR_W-1], ~iLLR[i][pLLR_W-2 : 0]}) begin // -2^(N-1)
            osLLR[i] <= {1'b1, {(pLLR_W-2){1'b0}}, 1'b1};         // -(2^(N-1) - 1)
          end
          else begin
            osLLR[i] <= iLLR[i];
          end
        end
        //
        if (isop) begin
          code      <= icode;
          edgeS     <= iN[pADDR_W-1 : 0] - 1'b1;
          edgeW     <= iN[pADDR_W-1 : 0] - 1'b1;  // iN[pADDR_W-1 : 0] - cP_PATTERN[icode].y[1];
          //
          addr      <= '0;
          addr_incr <= 1'b1;
        end
        else if ((state == cSTATE_DATA) & is_edgeS) begin
          addr      <= '0;
          addr_incr <= cP_PATTERN[code].y[0];
          addr_sel  <= 1'b1;
          //
          cnt7      <= 3'b001;
        end
        else if ((state == cSTATE_PARITY_Y) & is_edgeW) begin
          addr      <= '0;
          addr_incr <= cP_PATTERN[code].w[0];
          addr_sel  <= 1'b1;
        end
        else begin
          addr      <= addr + addr_incr;
          addr_sel  <= !addr_sel;
          if (state == cSTATE_PARITY_Y || state == cSTATE_PARITY_W) begin
            addr_incr <= (state == cSTATE_PARITY_Y) ? cP_PATTERN[code].y[addr_sel] : cP_PATTERN[code].w[addr_sel];
            //
            if (code == 7) begin
              if (cnt7 == 6) begin
                addr_incr <= 1'b1;
                cnt7      <= '0;
              end
              else begin
                cnt7 <= cnt7 + 1'b1;
              end
            end // icode == 7 use special puncture pattern
          end
        end // addr_incr
      end // ival
    end // iclkena
  end // iclk

  assign owaddr = addr[pADDR_W-1 : 0];

  always_comb begin
    oyLLR = osLLR;
    owLLR = osLLR;
    if (state == cSTATE_DATA) begin
      oyLLR = '{default : '0};
      owLLR = '{default : '0};
    end
  end

  always_comb begin
    owsel = 2'b00;
    case (state)
      cSTATE_DATA     : owsel = 2'b11;
      cSTATE_PARITY_Y : owsel = 2'b01;
      cSTATE_PARITY_W : owsel = 2'b10;
      default         : owsel = 2'b00;
    endcase
  end

  assign ordy  = !owfull & !ifulla;   // not ready if all buffers is full
  assign obusy =  owfull | !iemptya;  // busy if any buffer is not empty

endmodule
