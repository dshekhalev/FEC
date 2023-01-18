/*



  parameter int pW  = 13 ;



  logic            rsc_enc_paddr_gen__iclk            ;
  logic            rsc_enc_paddr_gen__ireset          ;
  logic            rsc_enc_paddr_gen__iclkena         ;
  logic            rsc_enc_paddr_gen__iclear          ;
  logic            rsc_enc_paddr_gen__ienable         ;
  logic [pW-1 : 0] rsc_enc_paddr_gen__iP      [0 : 3] ;
  logic [pW-1 : 0] rsc_enc_paddr_gen__iN              ;
  logic [pW-1 : 0] rsc_enc_paddr_gen__iPincr          ;
  logic            rsc_enc_paddr_gen__iPdvbinv        ;
  logic [pW-1 : 0] rsc_enc_paddr_gen__oaddr           ;
  logic [pW-1 : 0] rsc_enc_paddr_gen__opaddr          ;
  logic            rsc_enc_paddr_gen__obitinv         ;



  rsc_enc_paddr_gen
  #(
    .pW ( pW )
  )
  rsc_enc_paddr_gen
  (
    .iclk     ( rsc_enc_paddr_gen__iclk     ) ,
    .ireset   ( rsc_enc_paddr_gen__ireset   ) ,
    .iclkena  ( rsc_enc_paddr_gen__iclkena  ) ,
    .iclear   ( rsc_enc_paddr_gen__iclear   ) ,
    .ienable  ( rsc_enc_paddr_gen__ienable  ) ,
    .iP       ( rsc_enc_paddr_gen__iP       ) ,
    .iN       ( rsc_enc_paddr_gen__iN       ) ,
    .iPincr   ( rsc_enc_paddr_gen__iPincr   ) ,
    .iPdvbinv ( rsc_enc_paddr_gen__iPdvbinv ) ,
    .oaddr    ( rsc_enc_paddr_gen__oaddr    ) ,
    .opaddr   ( rsc_enc_paddr_gen__opaddr   ) ,
    .obitinv  ( rsc_enc_paddr_gen__obitinv  )
  );


  assign rsc_enc_paddr_gen__iclk     = '0 ;
  assign rsc_enc_paddr_gen__ireset   = '0 ;
  assign rsc_enc_paddr_gen__iclkena  = '0 ;
  assign rsc_enc_paddr_gen__iclear   = '0 ;
  assign rsc_enc_paddr_gen__ienable  = '0 ;
  assign rsc_enc_paddr_gen__iP       = '0 ;
  assign rsc_enc_paddr_gen__iN       = '0 ;
  assign rsc_enc_paddr_gen__iPincr   = '0 ;
  assign rsc_enc_paddr_gen__iPdvbinv = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_enc_paddr_gen.sv
// Description   : permutation and direct ram address generator for 2 pass encoding process
//

module rsc_enc_paddr_gen
#(
  parameter int pW  = 13
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  iclear   ,
  ienable  ,
  iP       ,
  iN       ,
  iPincr   ,
  iPdvbinv ,
  //
  oaddr    ,
  opaddr   ,
  obitinv
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk            ;
  input  logic            ireset          ;
  input  logic            iclkena         ;
  //
  input  logic            iclear          ;
  input  logic            ienable         ;
  input  logic [pW-1 : 0] iP      [0 : 3] ; // for DVB    {P0, (N/2 + P1 + 1) % N,               P2 + 1,  (N/2 + P3 + 1) % N}
                                            // for WiMax  {P0,                  1,              N/4 + 1,  (N/2 + P1 + 1) % N} / P1 = 3*N/4
                                            // for DVB2   { P,         (4*Q1) % N,  (4*Q0*P + 4*Q2) % N, (4*Q0*P + 4*Q3) % N)
  input  logic [pW-1 : 0] iN              ; // block size in duobit
  input  logic [pW-1 : 0] iPincr          ;
  input  logic            iPdvbinv        ;
  //
  output logic [pW-1 : 0] oaddr           ;
  output logic [pW-1 : 0] opaddr          ;
  output logic            obitinv         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [pW-1 : 0] dat_t;
  typedef logic [pW   : 0] dat_p1_t;

  dat_t pacc;
  dat_t pincr;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iclear) begin
        oaddr   <= '0;
        pincr   <= get_pincr(1);
        opaddr  <= get_pincr(0);
        pacc    <= iP[0];
      end
      else if (ienable) begin
        oaddr   <= oaddr + 1'b1;
        pincr   <= get_pincr(oaddr[1 : 0] + 2);
        opaddr  <= get_mod(pacc, pincr, iN);
        pacc    <= get_mod(pacc, iP[0], iN);
      end
    end
  end

  assign obitinv = iPdvbinv ? !oaddr[0] : oaddr[0];

  function dat_t get_mod (input dat_t acc, incr, mod);
    dat_p1_t  acc_next;
    dat_p1_t  acc_next_mod;
  begin
    acc_next     = acc + incr;
    acc_next_mod = acc_next - mod;
    get_mod      = acc_next_mod[pW] ? acc_next[pW-1 : 0] : acc_next_mod[pW-1 : 0];
  end
  endfunction

  function dat_t get_pincr (input logic [1 : 0] cnt);
    case (cnt)
      2'd0 : get_pincr = iPincr;
      2'd1 : get_pincr = iP[1]; // +1/3 is inside constant iP[1]
      2'd2 : get_pincr = iP[2]; // +1/3 is inside constant iP[2]
      2'd3 : get_pincr = iP[3]; // +1/3 is inside constant iP[3]
    endcase
  endfunction

endmodule


