/*



  parameter bit pB_nF =  0 ;
  parameter int pW    = 13 ;



  logic            rsc_dec_addr_gen__iclk            ;
  logic            rsc_dec_addr_gen__ireset          ;
  logic            rsc_dec_addr_gen__iclkena         ;
  logic            rsc_dec_addr_gen__ipmode          ;
  logic            rsc_dec_addr_gen__iclear          ;
  logic            rsc_dec_addr_gen__ienable         ;
  logic [pW-1 : 0] rsc_dec_addr_gen__iN              ;
  logic [pW-1 : 0] rsc_dec_addr_gen__iNm1            ;
  logic [pW-1 : 0] rsc_dec_addr_gen__iP      [0 : 3] ;
  logic [pW-1 : 0] rsc_dec_addr_gen__iP0comp         ;
  logic [pW-1 : 0] rsc_dec_addr_gen__iPincr          ;
  logic            rsc_dec_addr_gen__iPdvbinv        ;
  logic [pW-1 : 0] rsc_dec_addr_gen__osaddr          ;
  logic [pW-1 : 0] rsc_dec_addr_gen__opaddr          ;
  logic            rsc_dec_addr_gen__obitinv         ;



  rsc_dec_addr_gen
  #(
    .pB_nF ( pB_nF ) ,
    .pW    ( pW    )
  )
  rsc_dec_addr_gen
  (
    .iclk     ( rsc_dec_addr_gen__iclk     ) ,
    .ireset   ( rsc_dec_addr_gen__ireset   ) ,
    .iclkena  ( rsc_dec_addr_gen__iclkena  ) ,
    .ipmode   ( rsc_dec_addr_gen__ipmode   ) ,
    .iclear   ( rsc_dec_addr_gen__iclear   ) ,
    .ienable  ( rsc_dec_addr_gen__ienable  ) ,
    .iN       ( rsc_dec_addr_gen__iN       ) ,
    .iNm1     ( rsc_dec_addr_gen__iNm1     ) ,
    .iP       ( rsc_dec_addr_gen__iP       ) ,
    .iP0comp  ( rsc_dec_addr_gen__iP0comp  ) ,
    .iPincr   ( rsc_dec_addr_gen__iPincr   ) ,
    .iPdvbinv ( rsc_dec_addr_gen__iPdvbinv ) ,
    .osaddr   ( rsc_dec_addr_gen__osaddr   ) ,
    .opaddr   ( rsc_dec_addr_gen__opaddr   ) ,
    .obitinv  ( rsc_dec_addr_gen__obitinv  )
  );


  assign rsc_dec_addr_gen__iclk     = '0 ;
  assign rsc_dec_addr_gen__ireset   = '0 ;
  assign rsc_dec_addr_gen__iclkena  = '0 ;
  assign rsc_dec_addr_gen__ipmode   = '0 ;
  assign rsc_dec_addr_gen__iclear   = '0 ;
  assign rsc_dec_addr_gen__ienable  = '0 ;
  assign rsc_dec_addr_gen__iP       = '0 ;
  assign rsc_dec_addr_gen__iN       = '0 ;
  assign rsc_dec_addr_gen__iPincr   = '0 ;
  assign rsc_dec_addr_gen__iPdvbinv = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_dec_addr_gen.sv
// Description   : direct and permutation address generator for forward and backward recursion
//

module rsc_dec_addr_gen
#(
  parameter bit pB_nF = 0 ,
  parameter int pW    = 13  // don't change
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  ipmode   ,
  iclear   ,
  ienable  ,
  iN       ,
  iNm1     ,
  iP       ,
  iP0comp  ,
  iPincr   ,
  iPdvbinv ,
  //
  osaddr   ,
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
  input  logic            ipmode          ; // 1/0 - permutation/no permutation mode
  input  logic            iclear          ;
  input  logic            ienable         ;
  input  logic [pW-1 : 0] iN              ; // block size in duobit
  input  logic [pW-1 : 0] iNm1            ;
  input  logic [pW-1 : 0] iP      [0 : 3] ; // for DVB    {P0, (N/2 + P1 + 1) % N,              P2 + 1,  (N/2 + P3 + 1) % N}
                                            // for WiMax  {P0,                  1,             N/4 + 1,  (N/2 + P1 + 1) % N} / P1 = 3*N/4
                                            // for DVB    { P,         (4*Q1) % N, (4*Q0*P + 4*Q2) % N, (4*Q0*P + 4*Q3) % N)
  input  logic [pW-1 : 0] iP0comp         ;
  input  logic [pW-1 : 0] iPincr          ; // for DVB/WimaxA == 1, for Wimax = P0 + 1
  input  logic            iPdvbinv        ; // DVB/Wimax(a) dbit swap
  //
  output logic [pW-1 : 0] osaddr          ; // systematic pair address
  output logic [pW-1 : 0] opaddr          ; // parity pair address
  output logic            obitinv         ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [pW-1 : 0] dat_t;
  typedef logic [pW   : 0] dat_p1_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  dat_t pincr;

  logic pmode;

  dat_t saddr;
  dat_t saddr_init;

  dat_t acc;
  dat_t acc_init;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  initial begin
    saddr  <= '0;
    opaddr <= '0;
  end
  // synthesis translate_on
  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pB_nF) begin // backward data path

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          saddr_init <= get_mod(iP0comp, get_pincr(3), iN); // for dynamic change
          acc_init   <= get_mod(iP0comp, iP0comp, iN);
          //
          if (iclear) begin
            opaddr <= iNm1;
            //
            pmode  <= ipmode;
            //
            pincr  <= get_pincr(2);
            saddr  <= saddr_init;
            acc    <= acc_init;
          end
          else if (ienable) begin
            opaddr <= opaddr - 1'b1;
            //
            pincr  <= get_pincr(opaddr[1:0] + 2); // module arithmetic
            saddr  <= get_mod(acc, pincr, iN);
            acc    <= get_mod(acc, iP0comp, iN);
          end
        end
      end

    end
    else begin  // forward data path

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (iclear) begin
            opaddr <= '0;
            //
            pmode  <= ipmode;
            //
            pincr  <= get_pincr(1);
            saddr  <= get_pincr(0);
            acc    <= iP[0];
          end
          else if (ienable) begin
            opaddr <= opaddr + 1'b1;
            //
            pincr  <= get_pincr(opaddr[1:0] + 2);
            saddr  <= get_mod(acc, pincr, iN);
            acc    <= get_mod(acc, iP[0], iN);
          end
        end
      end

    end
  endgenerate

  assign osaddr  = pmode ? saddr : opaddr;
  assign obitinv = iPdvbinv ? !opaddr[0] : opaddr[0];

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

