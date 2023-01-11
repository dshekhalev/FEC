/*



  parameter int pCODE          = 8 ;
  parameter int pN             = 1 ;
  parameter int pLLR_W         = 8 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_W        = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;



  logic      gsfc_ldpc_dec_addr_gen__iclk                                               ;
  logic      gsfc_ldpc_dec_addr_gen__ireset                                             ;
  logic      gsfc_ldpc_dec_addr_gen__iclkena                                            ;
  logic      gsfc_ldpc_dec_addr_gen__iclear                                             ;
  logic      gsfc_ldpc_dec_addr_gen__ienable                                            ;
  logic      gsfc_ldpc_dec_addr_gen__iload_mode                                         ;
  logic      gsfc_ldpc_dec_addr_gen__ic_nv_mode                                         ;
  mem_addr_t gsfc_ldpc_dec_addr_gen__obuf_addr                                          ;
  mem_addr_t gsfc_ldpc_dec_addr_gen__oaddr      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t gsfc_ldpc_dec_addr_gen__osela      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic      gsfc_ldpc_dec_addr_gen__omask      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  tcnt_t     gsfc_ldpc_dec_addr_gen__otcnt                                              ;
  zcnt_t     gsfc_ldpc_dec_addr_gen__ozcnt                                              ;




  gsfc_ldpc_dec_addr_gen
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE )
  )
  gsfc_ldpc_dec_addr_gen
  (
    .iclk       ( gsfc_ldpc_dec_addr_gen__iclk       ) ,
    .ireset     ( gsfc_ldpc_dec_addr_gen__ireset     ) ,
    .iclkena    ( gsfc_ldpc_dec_addr_gen__iclkena    ) ,
    .iclear     ( gsfc_ldpc_dec_addr_gen__iclear     ) ,
    .ienable    ( gsfc_ldpc_dec_addr_gen__ienable    ) ,
    .iload_mode ( gsfc_ldpc_dec_addr_gen__iload_mode ) ,
    .ic_nv_mode ( gsfc_ldpc_dec_addr_gen__ic_nv_mode ) ,
    .obuf_addr  ( gsfc_ldpc_dec_addr_gen__obuf_addr  ) ,
    .oaddr      ( gsfc_ldpc_dec_addr_gen__oaddr      ) ,
    .osela      ( gsfc_ldpc_dec_addr_gen__osela      ) ,
    .omask      ( gsfc_ldpc_dec_addr_gen__omask      ) ,
    .otcnt      ( gsfc_ldpc_dec_addr_gen__otcnt      ) ,
    .ozcnt      ( gsfc_ldpc_dec_addr_gen__ozcnt      )
  );


  assign gsfc_ldpc_dec_addr_gen__iclk       = '0 ;
  assign gsfc_ldpc_dec_addr_gen__ireset     = '0 ;
  assign gsfc_ldpc_dec_addr_gen__iclkena    = '0 ;
  assign gsfc_ldpc_dec_addr_gen__iclear     = '0 ;
  assign gsfc_ldpc_dec_addr_gen__ienable    = '0 ;
  assign gsfc_ldpc_dec_addr_gen__iload_mode = '0 ;
  assign gsfc_ldpc_dec_addr_gen__ic_nv_mode = '0 ;



*/

//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_dec_addr_gen.sv
// Description   : LDPC decoder shift ram read address generator
//


module gsfc_ldpc_dec_addr_gen
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  iclear     ,
  ienable    ,
  iload_mode ,
  ic_nv_mode ,
  //
  obuf_addr  ,
  oaddr      ,
  osela      ,
  omask      ,
  otcnt      ,
  ozcnt
);

  `include "../gsfc_ldpc_parameters.svh"
  `include "gsfc_ldpc_dec_parameters.svh"
  `include "gsfc_ldpc_dec_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk                                               ;
  input  logic      ireset                                             ;
  input  logic      iclkena                                            ;
  //
  input  logic      iclear                                             ;
  input  logic      ienable                                            ;
  input  logic      iload_mode                                         ; // load mode (quazi vnode : linear access and mask all)
  input  logic      ic_nv_mode                                         ; // 1/0 :: cnode (permutated)/vnode (linear) access
  //
  output mem_addr_t obuf_addr                                          ; // input buffer address
  output mem_addr_t oaddr      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ; // mem[pC][pLLR_BY_CYCLE][cLDPC_NUM/pLLR_BY_CYCLE] ram array addresses
  output mem_sela_t osela      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ; // shift mux coordinates
  output logic      omask      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ; // used for pLLR_BY_CYCLE not mult by pT
  output tcnt_t     otcnt                                              ;
  output zcnt_t     ozcnt                                              ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic clear;

  struct packed {
    tcnt_t  val;
    logic   done;
    logic   zero;
  } tcnt;

  struct packed {
    zcnt_t  val;
    logic   done;
    logic   zero;
  } zcnt;

  mem_addr_t  zacc      [pC];

  tcnt_t      tcnt2tab  [pC]    [pNODE_BY_CYCLE];
  paddr_t     raddr     [pC][pW][pNODE_BY_CYCLE];

  tcnt_t      tcnt2out;
  zcnt_t      zcnt2out;

  paddr_t     raddr2out [pC][pW][pNODE_BY_CYCLE];
  logic       mask2out  [pC][pW][pNODE_BY_CYCLE];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  addr_tab_t    addr_tab;
  maddr_tab_s_t maddr_tab;  // Hb scaled by pNODE_BY_CYCLE

  //
  // write to file and reeadback at synthesis is true hack way (QUA don't sleep!!!)
  //

  always_comb begin
`ifdef MODEL_TECH
    addr_tab  = get_addr_tab(1, 1);  // print file short table
`else
    `include "gsfc_ldpc_dec_addr_gen_tab.svh"
`endif
    // split by pNODE_BY_CYCLE
    for (int c = 0; c < pC; c++) begin
      for (int w = 0; w < pW; w++) begin
        for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
          for (int t = 0; t < cT_MAX; t++) begin
            maddr_tab[c][w][n][t] = addr_tab[c][w][n*cT_MAX + t][0];
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // main counters
      if (iclear) begin
        clear <= 1'b1;
        tcnt  <= '{val : '0, done : (cT_MAX == 1),  zero : 1'b1};
        zcnt  <= '{val : '0, done : 1'b0,           zero : 1'b1};
        //
        for (int c = 0; c < pC; c++) begin
          for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
            tcnt2tab[c][n] <= '0;
          end
        end
      end
      else if (ienable) begin
        clear <= 1'b0;
        if (ic_nv_mode) begin  // cnode
          //  for (int z = 0; z < pZF; z += pLLR_BY_CYCLE) begin
          //    for (int t = 0; t < pT; t += pNODE_BY_CYCLE) begin
          if (tcnt.done) begin
            tcnt  <= '{val : '0, done : (cT_MAX == 1), zero : 1'b1};
            //
            for (int c = 0; c < pC; c++) begin
              for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
                tcnt2tab[c][n] <= '0;
              end
            end
            //
            zcnt.val  <=  zcnt.val + 1'b1;
            zcnt.done <= (zcnt.val == cZ_MAX-2);
            zcnt.zero <= &zcnt.val;
          end
          else begin
            tcnt.val  <=  tcnt.val + 1'b1;
            tcnt.done <= (tcnt.val == cT_MAX-2);
            tcnt.zero <= &tcnt.val;
            //
            for (int c = 0; c < pC; c++) begin
              for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
                tcnt2tab[c][n] <= tcnt.val + 1'b1;
              end
            end
          end
        end
        else begin
          //  for (int t = 0; t < pT; t += pNODE_BY_CYCLE) begin
          //    for (int z = 0; z < pZF; z += pLLR_BY_CYCLE) begin
          if (zcnt.done) begin
            zcnt      <= '{val : '0, done : 1'b0, zero : 1'b1};
            //
            tcnt.val  <=  tcnt.val + 1'b1;
            tcnt.done <= (tcnt.val == cT_MAX-2);
            tcnt.zero <= &tcnt.val;
            //
            for (int c = 0; c < pC; c++) begin
              for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
                tcnt2tab[c][n] <= tcnt.val + 1'b1;
              end
            end
          end
          else begin
            zcnt.val  <=  zcnt.val + 1'b1;
            zcnt.done <= (zcnt.val == cZ_MAX-2);
            zcnt.zero <= &zcnt.val;
          end
        end
      end
      //
      // address generation
      if (ienable) begin
        tcnt2out <= tcnt.val;
        zcnt2out <= zcnt.val;
        //
        if (ic_nv_mode) begin
          // permutated access
          // mux data and shift address
          for (int c = 0; c < pC; c++) begin
            zacc[c] <= tcnt.zero ? '0 : (zacc[c] + cZ_MAX[cADDR_W-1 : 0]);
            for (int w = 0; w < pW; w++) begin
              for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
                raddr[c][w][n].baddr <= maddr_tab[c][w][n][tcnt2tab[c][n]].baddr + zcnt.val;
                for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
                  raddr[c][w][n].sela   [llra] <= maddr_tab[c][w][n][tcnt2tab[c][n]].sela     [llra]; // addr gen use for read address -> use sela
                  raddr[c][w][n].offset [llra] <= maddr_tab[c][w][n][tcnt2tab[c][n]].offsetm  [llra]; // it's mask, for overlap logic  (!!!)
                end
              end
            end
          end
        end
        else begin
          // linear access
          // don't mux data and no address shift
          for (int c = 0; c < pC; c++) begin
            zacc[c] <= clear ? '0 : (zacc[c] + 1'b1);
            for (int w = 0; w < pW; w++) begin
              for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
                raddr[c][w][n].baddr <= '0;
                for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
                  raddr[c][w][n].offset[llra] <= '0;
                  raddr[c][w][n].sela  [llra] <= llra[cSELA_W-1 : 0];
                end
              end
            end
          end
        end
      end
    end // iclkena
  end // iclk

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      obuf_addr <= zacc[0];
      //
      otcnt     <= tcnt2out;
      ozcnt     <= zcnt2out;
      //
      for (int c = 0; c < pC; c++) begin
        for (int w = 0; w < pW; w++) begin
          for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
            raddr2out[c][w][n].baddr <= zacc[c] + get_mod(raddr[c][w][n].baddr, cZ_MAX);
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              raddr2out[c][w][n].sela [llra] <= raddr[c][w][n].sela [llra];
              // overlap logic for masked generation
              if ((raddr[c][w][n].baddr == 0 | raddr[c][w][n].baddr == cZ_MAX) & raddr[c][w][n].offset[llra][0]) begin // overlap case
                raddr2out[c][w][n].offset[llra] <= raddr[c][w][n].offset [llra] + cZ_MAX[cZCNT_W-1 : 0];
              end
              else begin
                raddr2out[c][w][n].offset[llra] <= raddr[c][w][n].offset [llra];
              end
            end // llra
          end // n
        end // w
      end // c
    end // iclkena
  end

  // register is inside mem block !!!
  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int w = 0; w < pW; w++) begin
        for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            omask[c][w][llra][n] = 1'b0; // mask for future
            oaddr[c][w][llra][n] = raddr2out[c][w][n].baddr + raddr2out[c][w][n].offset[llra];
            osela[c][w][llra][n] = raddr2out[c][w][n].sela[llra];
          end // llra
        end // n
      end // w
    end // c
  end

  //------------------------------------------------------------------------------------------------------
  // used function
  //------------------------------------------------------------------------------------------------------

  typedef logic [cZCNT_W-1 : 0] dat_t;
  typedef logic [cZCNT_W   : 0] dat_p1_t;

  function dat_t get_mod (input dat_p1_t acc_next, mod);
    dat_p1_t  acc_next_mod;
  begin
    acc_next_mod = acc_next - mod;
    get_mod      = acc_next_mod[cZCNT_W] ? acc_next[cZCNT_W-1 : 0] : acc_next_mod[cZCNT_W-1 : 0];
  end
  endfunction

endmodule
