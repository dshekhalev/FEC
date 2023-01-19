/*



  parameter int pLLR_W            =  8 ;
  parameter int pLLR_FP           =  8 ;
  parameter int pADDR_W           =  8 ;
  parameter bit pUSE_W_BIT        =  1 ;
  parameter bit pUSE_EOP_VAL_MASK =  1 ;



  logic                     rsc2_dec_source__iclk            ;
  logic                     rsc2_dec_source__ireset          ;
  logic                     rsc2_dec_source__iclkena         ;
  logic             [3 : 0] rsc2_dec_source__icode           ;
  logic             [5 : 0] rsc2_dec_source__iptype           ;
  logic                     rsc2_dec_source__isop            ;
  logic                     rsc2_dec_source__ieop            ;
  logic                     rsc2_dec_source__ival            ;
  bit_llr_t                 rsc2_dec_source__iLLR    [0 : 1] ;
  logic                     rsc2_dec_source__ifulla          ;
  logic                     rsc2_dec_source__iemptya         ;
  logic                     rsc2_dec_source__obusy           ;
  logic                     rsc2_dec_source__ordy            ;
  logic                     rsc2_dec_source__owrite          ;
  logic                     rsc2_dec_source__owfull          ;
  logic             [1 : 0] rsc2_dec_source__owsel           ;
  logic     [pADDR_W-1 : 0] rsc2_dec_source__owaddr          ;
  bit_llr_t                 rsc2_dec_source__osLLR   [0 : 1] ;
  bit_llr_t                 rsc2_dec_source__oyLLR   [0 : 1] ;
  bit_llr_t                 rsc2_dec_source__owLLR   [0 : 1] ;



  rsc2_dec_source
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pLLR_FP           ( pLLR_FP           ) ,
    .pADDR_W           ( pADDR_W           ) ,
    .pUSE_W_BIT        ( pUSE_W_BIT        ) ,
    .pUSE_EOP_VAL_MASK ( pUSE_EOP_VAL_MASK )
  )
  rsc2_dec_source
  (
    .iclk    ( rsc2_dec_source__iclk    ) ,
    .ireset  ( rsc2_dec_source__ireset  ) ,
    .iclkena ( rsc2_dec_source__iclkena ) ,
    .icode   ( rsc2_dec_source__icode   ) ,
    .iN      ( rsc2_dec_source__iN      ) ,
    .isop    ( rsc2_dec_source__isop    ) ,
    .ieop    ( rsc2_dec_source__ieop    ) ,
    .ival    ( rsc2_dec_source__ival    ) ,
    .iLLR    ( rsc2_dec_source__iLLR    ) ,
    .ifulla  ( rsc2_dec_source__ifulla  ) ,
    .iemptya ( rsc2_dec_source__iemptya ) ,
    .obusy   ( rsc2_dec_source__obusy   ) ,
    .ordy    ( rsc2_dec_source__ordy    ) ,
    .owrite  ( rsc2_dec_source__owrite  ) ,
    .owfull  ( rsc2_dec_source__owfull  ) ,
    .owsel   ( rsc2_dec_source__owsel   ) ,
    .owaddr  ( rsc2_dec_source__owaddr  ) ,
    .osLLR   ( rsc2_dec_source__osLLR   ) ,
    .oyLLR   ( rsc2_dec_source__oyLLR   ) ,
    .owLLR   ( rsc2_dec_source__owLLR   )
  );


  assign rsc2_dec_source__iclk    = '0 ;
  assign rsc2_dec_source__ireset  = '0 ;
  assign rsc2_dec_source__iclkena = '0 ;
  assign rsc2_dec_source__icode   = '0 ;
  assign rsc2_dec_source__iN      = '0 ;
  assign rsc2_dec_source__isop    = '0 ;
  assign rsc2_dec_source__ieop    = '0 ;
  assign rsc2_dec_source__ival    = '0 ;
  assign rsc2_dec_source__iLLR    = '0 ;
  assign rsc2_dec_source__ifulla  = '0 ;
  assign rsc2_dec_source__iemptya = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_dec_source.sv
// Description   : Input interface of decoder. Prepare S/Y/W duobits using puncture pattern in input ram buffer
//


module rsc2_dec_source
#(
  parameter int pLLR_W            =  5 ,
  parameter int pLLR_FP           =  2 ,
  parameter int pADDR_W           =  8 ,
  //
  parameter bit pUSE_W_BIT        =  1 ,  // 0/1 - not use/use coderate with W bits (icode == 0)
  parameter bit pUSE_EOP_VAL_MASK =  1    // use ieop with ival ANDED, else use single ieop
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  iptype  ,
  //
  isop    ,
  ieop    ,
  ival    ,
  iLLR    ,
  //
  ifulla  ,
  iemptya ,
  obusy   ,
  ordy    ,
  //
  owrite  ,
  owfull  ,
  owsel   ,
  owaddr  ,
  osLLR   ,
  oyLLR   ,
  owLLR
);

  `include "rsc2_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                     iclk            ;
  input  logic                     ireset          ;
  input  logic                     iclkena         ;
  //
  input  logic             [3 : 0] icode           ;
  input  logic             [5 : 0] iptype          ;
  //
  input  logic                     isop            ;
  input  logic                     ieop            ;
  input  logic                     ival            ;
  input  bit_llr_t                 iLLR    [0 : 1] ;
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

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef struct {
    bit [3 : 0] y[4], w[4];
  } punct_t;

  localparam punct_t cP_PATTERN [8] = '{
    '{y : '{1, 1, 1, 1}, w : '{1, 1, 1, 1}} , // 1/3
    '{y : '{1, 1, 1, 1}, w : '{0, 0, 0, 0}} , // 1/2
    '{y : '{2, 2, 2, 2}, w : '{0, 0, 0, 0}} , // 2/3
    '{y : '{2, 4, 2, 4}, w : '{0, 0, 0, 0}} , // 3/4
    '{y : '{4, 4, 4, 4}, w : '{0, 0, 0, 0}} , // 4/5
    '{y : '{4, 4, 4, 8}, w : '{0, 0, 0, 0}} , // 5/6
    '{y : '{4, 8, 4, 8}, w : '{0, 0, 0, 0}} , // 6/7
    '{y : '{4, 8, 8, 8}, w : '{0, 0, 0, 0}}   // 7/8
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

  logic  [3 : 0] code;

  logic [12 : 0] ntable__oN;
  logic [12 : 0] ntable__oNm1;

  logic [pADDR_W   : 0] addr;
  logic         [1 : 0] addr_sel;
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
  // decode packet length
  //------------------------------------------------------------------------------------------------------

  rsc2_ntable
  ntable
  (
    .iptype ( iptype       ) ,
    .oN     ( ntable__oN   ) ,
    .oNm1   ( ntable__oNm1 )
  );

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

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
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
          edgeS     <= ntable__oNm1[pADDR_W-1 : 0];
          edgeW     <= ntable__oNm1[pADDR_W-1 : 0];
          //
          addr      <= '0;
          addr_incr <= 1'b1;
        end
        else if ((state == cSTATE_DATA) & is_edgeS) begin
          addr      <= '0;
          addr_incr <= cP_PATTERN[code].y[0];
          addr_sel  <= 1'b1;
        end
        else if ((state == cSTATE_PARITY_Y) & is_edgeW) begin
          addr      <= '0;
          addr_incr <= cP_PATTERN[code].w[0];
          addr_sel  <= 1'b1;
        end
        else begin
          addr      <= addr + addr_incr;
          addr_sel  <= addr_sel + 1'b1;
          if (state == cSTATE_PARITY_Y || state == cSTATE_PARITY_W) begin
            addr_incr <= (state == cSTATE_PARITY_Y) ? cP_PATTERN[code].y[addr_sel] : cP_PATTERN[code].w[addr_sel];
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
