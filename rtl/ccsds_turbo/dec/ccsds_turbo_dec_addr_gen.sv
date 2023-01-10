/*



  parameter bit pB_nF = 0 ;



  logic      ccsds_turbo_dec_addr_gen__iclk        ;
  logic      ccsds_turbo_dec_addr_gen__ireset      ;
  logic      ccsds_turbo_dec_addr_gen__iclkena     ;
  logic      ccsds_turbo_dec_addr_gen__ipmode      ;
  logic      ccsds_turbo_dec_addr_gen__itmode      ;
  logic      ccsds_turbo_dec_addr_gen__iclear      ;
  logic      ccsds_turbo_dec_addr_gen__ienable     ;
  ptab_dat_t ccsds_turbo_dec_addr_gen__iNp3        ;
  ptab_dat_t ccsds_turbo_dec_addr_gen__iK2         ;
  ptab_dat_t ccsds_turbo_dec_addr_gen__iP      [4] ;
  ptab_dat_t ccsds_turbo_dec_addr_gen__iPcomp  [4] ;
  ptab_dat_t ccsds_turbo_dec_addr_gen__osaddr      ;
  ptab_dat_t ccsds_turbo_dec_addr_gen__opaddr      ;



  ccsds_turbo_dec_addr_gen
  #(
    .pB_nF ( pB_nF )
  )
  ccsds_turbo_dec_addr_gen
  (
    .iclk     ( ccsds_turbo_dec_addr_gen__iclk     ) ,
    .ireset   ( ccsds_turbo_dec_addr_gen__ireset   ) ,
    .iclkena  ( ccsds_turbo_dec_addr_gen__iclkena  ) ,
    .ipmode   ( ccsds_turbo_dec_addr_gen__ipmode   ) ,
    .itmode   ( ccsds_turbo_dec_addr_gen__itmode   ) ,
    .iclear   ( ccsds_turbo_dec_addr_gen__iclear   ) ,
    .ienable  ( ccsds_turbo_dec_addr_gen__ienable  ) ,
    .iNp3     ( ccsds_turbo_dec_addr_gen__iNp3     ) ,
    .iK2      ( ccsds_turbo_dec_addr_gen__iK2      ) ,
    .iP       ( ccsds_turbo_dec_addr_gen__iP       ) ,
    .iPcomp   ( ccsds_turbo_dec_addr_gen__iPcomp   ) ,
    .osaddr   ( ccsds_turbo_dec_addr_gen__osaddr   ) ,
    .opaddr   ( ccsds_turbo_dec_addr_gen__opaddr   )
  );


  assign ccsds_turbo_dec_addr_gen__iclk     = '0 ;
  assign ccsds_turbo_dec_addr_gen__ireset   = '0 ;
  assign ccsds_turbo_dec_addr_gen__iclkena  = '0 ;
  assign ccsds_turbo_dec_addr_gen__ipmode   = '0 ;
  assign ccsds_turbo_dec_addr_gen__itmode   = '0 ;
  assign ccsds_turbo_dec_addr_gen__iclear   = '0 ;
  assign ccsds_turbo_dec_addr_gen__ienable  = '0 ;
  assign ccsds_turbo_dec_addr_gen__iP       = '0 ;
  assign ccsds_turbo_dec_addr_gen__iNp3     = '0 ;
  assign ccsds_turbo_dec_addr_gen__iK2      = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_dec_addr_gen.sv
// Description   : direct and permutation address generator for forward and backward recursion
//

module ccsds_turbo_dec_addr_gen
#(
  parameter bit pB_nF = 1
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  ipmode   ,
  itmode   ,
  iclear   ,
  ienable  ,
  //
  iNp3     ,
  iK2      ,
  iP       ,
  //
  iPcomp   ,
  //
  osaddr   ,
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
  input  logic      ipmode      ; // 1/0 - permutation/no permutation mode
  input  logic      itmode      ; // 1/0 - termination/no termination phase
  input  logic      iclear      ;
  input  logic      ienable     ;
  //
  input  ptab_dat_t iNp3        ; // N + 4 - 1
  input  ptab_dat_t iK2         ;
  input  ptab_dat_t iP      [4] ;

  input  ptab_dat_t iPcomp  [4] ;
  //
  output ptab_dat_t osaddr      ; // systematic bit address
  output ptab_dat_t opaddr      ; // parity bit address

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef logic [cW-1 : 0] dat_t;
  typedef logic [cW   : 0] dat_p1_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         pmode;

  dat_t         K2m2;

  dat_t         addr  = '0;
  dat_t         paddr = '0;

  dat_t         jacc;
  logic         jacc_done;

  logic [1 : 0] tacc;

  dat_t         jmult_acc;
  dat_t         jmult_acc_incr;

  logic [1 : 0] t2;
  dat_t         c2;
  dat_t         c2comp;

  dat_t         paddr_init;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    if (pB_nF) begin // backward data path

      assign t2     = tacc + 1'b1;

      assign c2     = get_mod(jmult_acc, addr[0] ? 0 : 21, iK2);

      assign c2comp = get_mod(iPcomp[2], 21, iK2);

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          paddr_init  <= (2'b10 << 1) + (c2comp << 3); // (t2 << 1) + (c2 << 3);
          //
          if (iclear) begin
            pmode           <= ipmode;
            //
            K2m2            <= iK2 - 2;
            //
            tacc            <= 2'b01;
            //
            jacc            <= '0;
            jacc_done       <= 1'b0;
            //
            jmult_acc       <= get_bkwd_init (0);
            jmult_acc_incr  <= get_bkwd_pincr(0);
            //
            addr            <= iNp3;
            paddr           <= paddr_init;
          end
          else if (ienable) begin
            if (addr[0] & !itmode) begin
              jacc      <=  jacc_done ? '0 : (jacc + 1'b1);
              jacc_done <= (jacc == K2m2);
              //
              if (jacc_done) begin
                tacc           <= tacc + 1'b1;
                //
                jmult_acc      <= get_bkwd_init (tacc);
                jmult_acc_incr <= get_bkwd_pincr(tacc);
              end
              else begin
                jmult_acc      <= get_zero(jmult_acc, jmult_acc_incr, iK2);
              end
            end
            //
            addr  <= addr - 1'b1;
            paddr <= (t2 << 1) + (c2 << 3); // (t2 << 1) + (c2 << 3)
          end
        end
      end

    end
    else begin  // forward data path

      assign t2 = tacc + 1'b1;

      assign c2 = get_mod(jmult_acc, addr[0] ? 0 : 21, iK2);

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (iclear) begin
            pmode           <= ipmode;
            //
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
            if (!addr[0] & !itmode) begin
              jacc      <=  jacc_done ? '0 : (jacc + 1'b1);
              jacc_done <= (jacc == K2m2);
              //
              if (jacc_done) begin
                tacc            <= tacc + 2'b11;
                jmult_acc       <= '0;
                jmult_acc_incr  <= get_frwd_pincr(tacc);
              end
              else begin
                jmult_acc       <= get_mod(jmult_acc, jmult_acc_incr, iK2);
              end
            end
            //
            addr  <= addr + 1'b1;
            paddr <= (t2 << 1) + (c2 << 3); // (t2 << 1) + (c2 << 3)
          end
        end
      end

    end
  endgenerate

  // do hack to prevent even/even or odd/odd address pair in permutated (odd) phase of iteration
  assign osaddr  = pmode ? {itmode ? addr[cW-1 : 1] : paddr[cW-1 : 1], !addr[0]} : addr;;
  assign opaddr  = addr;

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

  function dat_t get_zero (input dat_t acc, incr, mod);
    dat_p1_t  acc_next;
    dat_p1_t  acc_next_mod;
  begin
    acc_next     = acc - incr;
    acc_next_mod = acc_next + mod;
    get_zero     = acc_next[cW] ? acc_next_mod[cW-1 : 0] : acc_next[cW-1 : 0];
  end
  endfunction

  //
  // take into account
  //  tacc[1 : 0]     += 1;
  //  jmult_acc_incr  += p_tab_zero[(tacc + 1) % 4];
  //
  function dat_t get_bkwd_pincr (input logic [1 : 0] tacc);
    case (tacc)
      2'd0 : get_bkwd_pincr = iP[2];
      2'd1 : get_bkwd_pincr = iP[3];
      2'd2 : get_bkwd_pincr = iP[0];
      2'd3 : get_bkwd_pincr = iP[1];
    endcase
  endfunction

  //
  // take into account
  // jmult_acc = iPcomp[(tacc + 2) % 4];
  //
  function dat_t get_bkwd_init (input logic [1 : 0] tacc);
  begin
    case (tacc)
      2'd0 : get_bkwd_init = iPcomp[2];
      2'd1 : get_bkwd_init = iPcomp[3];
      2'd2 : get_bkwd_init = iPcomp[0];
      2'd3 : get_bkwd_init = iPcomp[1];
    endcase
  end
  endfunction

  //
  // take into account
  //  tacc[1 : 0]     += 3;
  //  jmult_acc_incr  += p_tab_zero[(tacc + 1) % 4];
  //
  function dat_t get_frwd_pincr (input logic [1 : 0] tacc);
    case (tacc)
      2'd0 : get_frwd_pincr = iP[0];
      2'd1 : get_frwd_pincr = iP[1];
      2'd2 : get_frwd_pincr = iP[2];
      2'd3 : get_frwd_pincr = iP[3];
    endcase
  endfunction



endmodule

