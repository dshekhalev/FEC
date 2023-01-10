/*




  logic      ccsds_turbo_enc_paddr_gen__iclk        ;
  logic      ccsds_turbo_enc_paddr_gen__ireset      ;
  logic      ccsds_turbo_enc_paddr_gen__iclkena     ;
  logic      ccsds_turbo_enc_paddr_gen__iclear      ;
  logic      ccsds_turbo_enc_paddr_gen__ienable     ;
  ptab_dat_t ccsds_turbo_enc_paddr_gen__iP      [4] ;
  ptab_dat_t ccsds_turbo_enc_paddr_gen__iK2         ;
  ptab_dat_t ccsds_turbo_enc_paddr_gen__oaddr       ;
  ptab_dat_t ccsds_turbo_enc_paddr_gen__opaddr      ;



  ccsds_turbo_enc_paddr_gen
  ccsds_turbo_enc_paddr_gen
  (
    .iclk     ( ccsds_turbo_enc_paddr_gen__iclk     ) ,
    .ireset   ( ccsds_turbo_enc_paddr_gen__ireset   ) ,
    .iclkena  ( ccsds_turbo_enc_paddr_gen__iclkena  ) ,
    .iclear   ( ccsds_turbo_enc_paddr_gen__iclear   ) ,
    .ienable  ( ccsds_turbo_enc_paddr_gen__ienable  ) ,
    .iP       ( ccsds_turbo_enc_paddr_gen__iP       ) ,
    .iK2      ( ccsds_turbo_enc_paddr_gen__iK2      ) ,
    .oaddr    ( ccsds_turbo_enc_paddr_gen__oaddr    ) ,
    .opaddr   ( ccsds_turbo_enc_paddr_gen__opaddr   )
  );


  assign ccsds_turbo_enc_paddr_gen__iclk     = '0 ;
  assign ccsds_turbo_enc_paddr_gen__ireset   = '0 ;
  assign ccsds_turbo_enc_paddr_gen__iclkena  = '0 ;
  assign ccsds_turbo_enc_paddr_gen__iclear   = '0 ;
  assign ccsds_turbo_enc_paddr_gen__ienable  = '0 ;
  assign ccsds_turbo_enc_paddr_gen__iP       = '0 ;
  assign ccsds_turbo_enc_paddr_gen__iK2      = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_enc_paddr_gen.v
// Description   : permutation and direct ram address generator for encoding process
//

module ccsds_turbo_enc_paddr_gen
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  iclear  ,
  ienable ,
  //
  iP      ,
  iK2     ,
  //
  oaddr   ,
  opaddr
);

  `include "../ccsds_turbo_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk        ;
  input  logic      ireset      ;
  input  logic      iclkena     ;
  //
  input  logic      iclear      ;
  input  logic      ienable     ;
  //
  input  ptab_dat_t iP      [4] ;
  input  ptab_dat_t iK2         ;
  //
  output ptab_dat_t oaddr       ; // linear address
  output ptab_dat_t opaddr      ; // permutated addr

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [cW-1 : 0] dat_t;
  typedef logic [cW   : 0] dat_p1_t;

  dat_t         K2m2;

  dat_t         addr;
  dat_t         paddr;

  dat_t         jacc;
  logic         jacc_done;

  logic [1 : 0] tacc;

  dat_t         jmult_acc;
  dat_t         jmult_acc_incr;

  logic [1 : 0] t2;
  dat_t         c2;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign t2 = tacc + 1'b1;

  assign c2 = get_mod(jmult_acc, addr[0] ? 0 : 21, iK2);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iclear) begin
        K2m2            <= iK2 - 2;
        //
        tacc            <= '0;
        //
        jacc            <= '0;
        jacc_done       <= 1'b0;
        //
        jmult_acc       <= '0;
        jmult_acc_incr  <= iP[1];
        //
        addr            <= '0;
        paddr           <= (1'b1 << 1); // (t2 << 1) + (c2 << 3)
      end
      else if (ienable) begin
        if (!addr[0]) begin
          jacc      <=  jacc_done ? '0 : (jacc + 1'b1);
          jacc_done <= (jacc == K2m2);
          //
          if (jacc_done) begin
            tacc           <= tacc + 2'b11;
            jmult_acc      <= '0;
            jmult_acc_incr <= get_pincr(tacc);
          end
          else begin
            jmult_acc      <= get_mod(jmult_acc, jmult_acc_incr, iK2);
          end
        end
        //
        addr  <= addr + 1'b1;
        paddr <= (t2 << 1) + (c2 << 3); // (t2 << 1) + (c2 << 3)
      end
    end
  end

  assign oaddr  = addr;
  assign opaddr = {paddr[cW-1 : 1], !addr[0]};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function dat_t get_mod (input dat_t acc, incr, mod);
    dat_p1_t  acc_next;
    dat_p1_t  acc_next_mod;
  begin
    acc_next     = acc + incr;
    acc_next_mod = acc_next - mod;
    get_mod      = acc_next_mod[cW] ? acc_next[cW-1 : 0] : acc_next_mod[cW-1 : 0];
  end
  endfunction

  //
  // take into account
  //  tacc[1 : 0]     += 3;
  //  jmult_acc_incr  += p_tab_zero[(tacc + 1) % 4];
  //
  function dat_t get_pincr (input logic [1 : 0] tacc);
    case (tacc)
      2'd0 : get_pincr = iP[0];
      2'd1 : get_pincr = iP[1];
      2'd2 : get_pincr = iP[2];
      2'd3 : get_pincr = iP[3];
    endcase
  endfunction

endmodule


