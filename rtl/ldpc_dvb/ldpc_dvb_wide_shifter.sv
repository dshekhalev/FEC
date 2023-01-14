/*



  parameter int pW         = 8 ;
  parameter int pSHIFT_W   = 8 ;
  parameter bit pR_SHIFT   = 0 ;
  parameter int pPIPE_LINE = 8 ;



  logic                  ldpc_dvb_wide_shifter__iclk    ;
  logic                  ldpc_dvb_wide_shifter__ireset  ;
  logic                  ldpc_dvb_wide_shifter__iclkena ;
  //
  logic                  ldpc_dvb_wide_shifter__ival    ;
  logic       [pW-1 : 0] ldpc_dvb_wide_shifter__idat    ;
  logic [pSHIFT_W-1 : 0] ldpc_dvb_wide_shifter__ishift  ;
  //
  logic                  ldpc_dvb_wide_shifter__oval    ;
  logic       [pW-1 : 0] ldpc_dvb_wide_shifter__odat    ;



  ldpc_dvb_wide_shifter
  #(
    .pW         ( pW         ) ,
    .pSHIFT_W   ( pSHIFT_W   ) ,
    .pR_SHIFT   ( pR_SHIFT   ) ,
    .pPIPE_LINE ( pPIPE_LINE )
  )
  ldpc_dvb_wide_shifter
  (
    .iclk    ( ldpc_dvb_wide_shifter__iclk    ) ,
    .ireset  ( ldpc_dvb_wide_shifter__ireset  ) ,
    .iclkena ( ldpc_dvb_wide_shifter__iclkena ) ,
    //
    .ival    ( ldpc_dvb_wide_shifter__ival    ) ,
    .idat    ( ldpc_dvb_wide_shifter__idat    ) ,
    .ishift  ( ldpc_dvb_wide_shifter__ishift  ) ,
    //
    .oval    ( ldpc_dvb_wide_shifter__oval    ) ,
    .odat    ( ldpc_dvb_wide_shifter__odat    )
  );


  assign ldpc_dvb_wide_shifter__iclk    = '0 ;
  assign ldpc_dvb_wide_shifter__ireset  = '0 ;
  assign ldpc_dvb_wide_shifter__iclkena = '0 ;
  assign ldpc_dvb_wide_shifter__ival    = '0 ;
  assign ldpc_dvb_wide_shifter__idat    = '0 ;
  assign ldpc_dvb_wide_shifter__ishift  = '0 ;



*/

//
// Project       : ldpc DVB-S
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_wide_shifter.sv
// Description   : wide bit vector shifter splited on small muxers and optional registers
//

module ldpc_dvb_wide_shifter
#(
  parameter int pW                          =            360 ,  // don't change
  parameter int pSHIFT_W                    = $clog2(pW + 1) ,
  //
  parameter bit pR_SHIFT                    =              0 ,  // shift direction
  //
  parameter bit [pSHIFT_W-1 : 0] pPIPE_LINE =              1    // shift edge pipeline
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  idat    ,
  ishift  ,
  //
  oval    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                  iclk    ;
  input  logic                  ireset  ;
  input  logic                  iclkena ;
  //
  input  logic                  ival    ;
  input  logic       [pW-1 : 0] idat    ;
  input  logic [pSHIFT_W-1 : 0] ishift  ;
  //
  output logic                  oval    ;
  output logic       [pW-1 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic [pSHIFT_W-1 : 0] val     ;
  logic [pSHIFT_W-1 : 0] val_reg ;

  logic       [pW-1 : 0] tmp       [pSHIFT_W];
  logic       [pW-1 : 0] tmp_reg   [pSHIFT_W];

  logic [pSHIFT_W-1 : 0] shift     [pSHIFT_W];
  logic [pSHIFT_W-1 : 0] shift_reg [pSHIFT_W];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      val_reg   <= val;
      tmp_reg   <= tmp;
      shift_reg <= shift;
    end
  end

  assign oval = pPIPE_LINE[0] ? val_reg[0] : val[0];
  assign odat = pPIPE_LINE[0] ? tmp_reg[0] : tmp[0];

  always_comb begin
    for (int i = pSHIFT_W-1; i >= 0; i--) begin
      if (i == (pSHIFT_W-1)) begin
        val  [i] = ival;
        shift[i] = ishift;
        tmp  [i] = do_shift(idat, 2**i, ishift[i], pR_SHIFT);
      end
      else begin
        if (pPIPE_LINE[i+1]) begin
          val  [i] = val_reg         [i+1];
          shift[i] = shift_reg       [i+1];
          tmp  [i] = do_shift(tmp_reg[i+1], 2**i, shift_reg[i+1][i], pR_SHIFT);
        end
        else begin
          val  [i] = val         [i+1];
          shift[i] = shift       [i+1];
          tmp  [i] = do_shift(tmp[i+1], 2**i, shift[i+1][i], pR_SHIFT);
        end // pPIPE_LINE[i+1]
      end // i == (pSHIFT_W-1)
    end // i
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function automatic logic [pW-1 : 0] do_shift (input logic [pW-1 : 0] dat, int shift, bit shift_sel, rshift);
  begin
    if (rshift) begin
      do_shift = shift_sel ? (dat >> shift) : dat;
    end
    else begin
      do_shift = shift_sel ? (dat << shift) : dat;
    end
  end
  endfunction

endmodule
