/*

  parameter int pCODE   =   1 ;
  parameter int pN      = 576 ;
  parameter int pDAT_W  =   4 ;


  logic                 ldpc_enc_addr_gen__iclk            ;
  logic                 ldpc_enc_addr_gen__ireset          ;
  logic                 ldpc_enc_addr_gen__iclkena         ;
  logic                 ldpc_enc_addr_gen__iclear          ;
  logic                 ldpc_enc_addr_gen__ienable         ;
  logic [cBASE_W-1 : 0] ldpc_enc_addr_gen__obitena    [pC] ;
  logic [cBASE_W-1 : 0] ldpc_enc_addr_gen__obitsel    [pC] ;
  logic   [cBS_W-1 : 0] ldpc_enc_addr_gen__obitshift  [pC] ;



  ldpc_enc_addr_gen
  #(
    .pCODE  ( pCODE  ) ,
    .pN     ( pN     ) ,
    .pDAT_W ( pDAT_W )
  )
  ldpc_enc_addr_gen
  (
    .iclk       ( ldpc_enc_addr_gen__iclk       ) ,
    .ireset     ( ldpc_enc_addr_gen__ireset     ) ,
    .iclkena    ( ldpc_enc_addr_gen__iclkena    ) ,
    .iclear     ( ldpc_enc_addr_gen__iclear     ) ,
    .ienable    ( ldpc_enc_addr_gen__ienable    ) ,
    .obitena    ( ldpc_enc_addr_gen__obitena    ) ,
    .obitsel    ( ldpc_enc_addr_gen__obitsel    ) ,
    .obitshift  ( ldpc_enc_addr_gen__obitshift  )
  );


  assign ldpc_enc_addr_gen__iclk    = '0 ;
  assign ldpc_enc_addr_gen__ireset  = '0 ;
  assign ldpc_enc_addr_gen__iclkena = '0 ;
  assign ldpc_enc_addr_gen__iclear  = '0 ;
  assign ldpc_enc_addr_gen__ienable = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_enc_addr_gen.sv
// Description   : LDPC encoder address generator. Generate control signal for special memory to do matrix multiplication.
//

`include "define.vh"

module ldpc_enc_addr_gen
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  iclear     ,
  ienable    ,
  //
  obitena    ,
  obitsel    ,
  obitshift
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../ldpc_parameters.svh"

  parameter int pDAT_W      = 4;                // 2^N bits granularity of encoder word

  localparam int cBS_W      = clogb2(pDAT_W);   // bitshift width

  localparam int cBASE      = pZF/pDAT_W;       // number of addresses inside acu ram
  localparam int cADDR_W    = clogb2(cBASE);    // circshift(Hb[i]) address

  localparam int cCADDR_W   = clogb2(pT-pC+1);  // Hb matrix column address

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic               iclk            ;
  input  logic               ireset          ;
  input  logic               iclkena         ;
  //
  input  logic               iclear          ;
  input  logic               ienable         ;
  //
  output logic [cBASE-1 : 0] obitena     [pC]; // disable word update
  output logic [cBASE-1 : 0] obitsel     [pC]; // select word source
  output logic [cBS_W-1 : 0] obitshift   [pC]; // value of offset reg

  //------------------------------------------------------------------------------------------------------
  // count base addreses table
  //------------------------------------------------------------------------------------------------------

  typedef logic [cADDR_W-1 : 0] dat_t;
  typedef logic   [cBS_W-1 : 0] shift_t;

  typedef struct packed {
    logic [2*cBASE-1 : 0] bitop;
    shift_t               shift;
  } bit_dat_t;

  typedef bit_dat_t bit_tab_t [pC][pT];

  bit_tab_t bit_tab;

  assign bit_tab  = get_bit_tab(pCODE);

  //------------------------------------------------------------------------------------------------------
  // functions to count tables
  //------------------------------------------------------------------------------------------------------

  function automatic bit_tab_t get_bit_tab (input int pCODE);
    H_t tHb;
    int addr;
    int shift;
  begin
    // get local table : fix quartus bug
    tHb = get_Hb (pCODE);
    //
    for (int c = 0; c < pC; c++) begin
      for (int t = 0; t < pT; t++) begin
        addr  = 0;
        shift = 0;
        //
        if (tHb[c][t] >= 0) begin
          shift = tHb[c][t] % pDAT_W;
          addr  = (cBASE - ((tHb[c][t]/pDAT_W) % cBASE)) % cBASE;
        end
        //
        get_bit_tab[c][t].bitop = get_bitmask(tHb[c][t][31], addr);
        get_bit_tab[c][t].shift = shift;
      end
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic  [cADDR_W-1 : 0] baddr;
  logic                  baddr_done;
  logic                  baddr_zero;
  logic [cCADDR_W-1 : 0] caddr;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iclear) begin
        baddr       <= 1'b1;
        baddr_done  <= '0;
        baddr_zero  <= '0;
        caddr       <= '0;
        //
        for (int c = 0; c < pC; c++) begin
          obitshift [c]             <= bit_tab[c][0].shift;
          {obitena[c], obitsel[c]}  <= bit_tab[c][0].bitop;
        end
      end
      else if (ienable) begin
        baddr       <= baddr_done ? '0 : (baddr + 1'b1);
        baddr_done  <= (baddr == cBASE-2);
        baddr_zero  <= baddr_done;
        caddr       <= caddr + baddr_done;
        //
        for (int c = 0; c < pC; c++) begin
          obitshift [c] <= bit_tab[c][caddr].shift;
          if (baddr_zero) begin
            {obitena[c], obitsel[c]} <= bit_tab[c][caddr].bitop;
          end
          else begin
            obitena[c] <= {obitena[c][cBASE-2 : 0], obitena[c][cBASE-1]};
            obitsel[c] <= {obitsel[c][cBASE-2 : 0], obitsel[c][cBASE-1]};
          end
        end // [pC]
      end // ienable
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // functions to get bitmask
  //------------------------------------------------------------------------------------------------------

  function logic [2*cBASE-1 : 0] get_bitmask (input logic sign, input dat_t addr_high);
    logic [cBASE-1 : 0] bitclr;
    logic [cBASE-1 : 0] bitsel;
  begin
    bitclr = '1;
    bitsel = '0;

    bitclr[addr_high] = sign;
    bitsel[addr_high] = 1'b1;

    bitclr[(addr_high == 0) ? (cBASE-1) : (addr_high-1)] = sign;
    //
    get_bitmask = {~bitclr, bitsel};
  end
  endfunction

endmodule
