/*



  parameter int pCODE          = 1 ;
  parameter int pN             = 1 ;
  parameter int pLLR_W         = 4 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_W        = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;
  parameter bit pUSE_NORM      = 1 ;
  parameter bit pEBUSY_L       = 1 ;
  parameter bit pEBUSY_H       = 1 ;


  logic      ldpc_dec_cnode__iclk                                         ;
  logic      ldpc_dec_cnode__ireset                                       ;
  logic      ldpc_dec_cnode__iclkena                                      ;
  logic      ldpc_dec_cnode__isop                                         ;
  logic      ldpc_dec_cnode__ival                                         ;
  logic      ldpc_dec_cnode__ieop                                         ;
  zcnt_t     ldpc_dec_cnode__izcnt                                        ;
  logic      ldpc_dec_cnode__ivmask  [pC]               [pNODE_BY_CYCLE]  ;
  node_t     ldpc_dec_cnode__ivnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  ;
  logic      ldpc_dec_cnode__osop                                         ;
  logic      ldpc_dec_cnode__oval                                         ;
  mem_addr_t ldpc_dec_cnode__oaddr   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  ;
  mem_sela_t ldpc_dec_cnode__osela   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  ;
  logic      ldpc_dec_cnode__omask   [pC]               [pNODE_BY_CYCLE]  ;
  node_t     ldpc_dec_cnode__ocnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  ;
  logic      ldpc_dec_cnode__odecfail                                     ;
  logic      ldpc_dec_cnode__obusy                                        ;



  ldpc_dec_cnode
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pUSE_NORM      ( pUSE_NORM      ) ,
    .pEBUSY_L       ( pEBUSY_L       ) ,
    .pEBUSY_H       ( pEBUSY_H       )
  )
  ldpc_dec_cnode
  (
    .iclk     ( ldpc_dec_cnode__iclk     ) ,
    .ireset   ( ldpc_dec_cnode__ireset   ) ,
    .iclkena  ( ldpc_dec_cnode__iclkena  ) ,
    .isop     ( ldpc_dec_cnode__isop     ) ,
    .ival     ( ldpc_dec_cnode__ival     ) ,
    .ieop     ( ldpc_dec_cnode__ieop     ) ,
    .izcnt    ( ldpc_dec_cnode__izcnt    ) ,
    .ivmask   ( ldpc_dec_cnode__ivmask   ) ,
    .ivnode   ( ldpc_dec_cnode__ivnode   ) ,
    .osop     ( ldpc_dec_cnode__osop     ) ,
    .oval     ( ldpc_dec_cnode__oval     ) ,
    .oaddr    ( ldpc_dec_cnode__oaddr    ) ,
    .osela    ( ldpc_dec_cnode__osela    ) ,
    .omask    ( ldpc_dec_cnode__omask    ) ,
    .ocnode   ( ldpc_dec_cnode__ocnode   ) ,
    .odecfail ( ldpc_dec_cnode__odecfail )
    .obusy    ( ldpc_dec_cnode__obusy    )
  );


  assign ldpc_dec_cnode__iclk    = '0 ;
  assign ldpc_dec_cnode__ireset  = '0 ;
  assign ldpc_dec_cnode__iclkena = '0 ;
  assign ldpc_dec_cnode__isop    = '0 ;
  assign ldpc_dec_cnode__ival    = '0 ;
  assign ldpc_dec_cnode__ieop    = '0 ;
  assign ldpc_dec_cnode__izcnt   = '0 ;
  assign ldpc_dec_cnode__ivmask  = '0 ;
  assign ldpc_dec_cnode__ivnode  = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_cnode.sv
// Description   : LDPC decoder check node arithmetic top module: read vnode and count cnode. Consist of pC*pLLR_BY_CYCLE engines.
//

`include "define.vh"

module ldpc_dec_cnode
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  isop     ,
  ival     ,
  ieop     ,
  izcnt    ,
  ivmask   ,
  ivnode   ,
  //
  oval     ,
  oaddr    ,
  osela    ,
  omask    ,
  ocnode   ,
  //
  odecfail ,
  obusy
);

  parameter bit pUSE_NORM = 1;

  parameter int pEBUSY_L  = 0;  // start latency
  parameter int pEBUSY_H  = 9;  // end latency

  `include "../ldpc_parameters.svh"
  `include "ldpc_dec_parameters.svh"
  `include "ldpc_dec_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk                                        ;
  input  logic      ireset                                      ;
  input  logic      iclkena                                     ;
  //
  input  logic      isop                                        ;
  input  logic      ival                                        ;
  input  logic      ieop                                        ;
  input  zcnt_t     izcnt                                       ;
  input  logic      ivmask  [pC]               [pNODE_BY_CYCLE] ;
  input  node_t     ivnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic      oval                                        ;
  output mem_addr_t oaddr   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output mem_sela_t osela   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] /* synthesis keep */;
  output logic      omask   [pC]               [pNODE_BY_CYCLE] ;
  output node_t     ocnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic      odecfail                                    ;
  output logic      obusy                                       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic  engine__oval       [pC][pLLR_BY_CYCLE]                 ;
  tcnt_t engine__otcnt      [pC][pLLR_BY_CYCLE]                 ;
  logic  engine__otcnt_zero [pC][pLLR_BY_CYCLE]                 ;
  zcnt_t engine__ozcnt      [pC][pLLR_BY_CYCLE]                 ;
  node_t engine__ocnode     [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  logic  engine__obusy      [pC][pLLR_BY_CYCLE]                 ;
  logic  engine__odecfail   [pC][pLLR_BY_CYCLE]                 ;
  logic  engine__oebusy     [pC][pLLR_BY_CYCLE]                 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    genvar gc, gllra;
    for (gc = 0; gc < pC; gc++) begin : engine_inst_c_gen
      for (gllra = 0; gllra < pLLR_BY_CYCLE; gllra++) begin : engine_inst_llra_gen
        if (pT/pNODE_BY_CYCLE < pNODE_BY_CYCLE) begin
          // parallel pNODE_BY_CYCLE search :: each pLLR_BY_CYCLE use sequential partial search pT/pNODE_BY_CYCLE -> parallel search pNODE_BY_CYCLE
          ldpc_dec_cnode_pp_engine
          #(
            .pCODE          ( pCODE          ) ,
            .pN             ( pN             ) ,
            .pLLR_W         ( pLLR_W         ) ,
            .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
            .pNODE_W        ( pNODE_W        ) ,
            .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
            .pUSE_NORM      ( pUSE_NORM      ) ,
            .pEBUSY_L       ( pEBUSY_L       ) ,
            .pEBUSY_H       ( pEBUSY_H       )
          )
          engine
          (
            .iclk       ( iclk    ) ,
            .ireset     ( ireset  ) ,
            .iclkena    ( iclkena ) ,
            //
            .isop       ( isop                           ) ,
            .ival       ( ival                           ) ,
            .ieop       ( ieop                           ) ,
            .izcnt      ( izcnt                          ) ,
            .ivmask     ( ivmask             [gc]        ) ,
            .ivnode     ( ivnode             [gc][gllra] ) ,
            //
            .oval       ( engine__oval       [gc][gllra] ) ,
            .ocnode     ( engine__ocnode     [gc][gllra] ) ,
            //
            .obusy      ( engine__obusy      [gc][gllra] ) ,
            .otcnt      ( engine__otcnt      [gc][gllra] ) ,
            .otcnt_zero ( engine__otcnt_zero [gc][gllra] ) ,
            .ozcnt      ( engine__ozcnt      [gc][gllra] ) ,
            //
            .odecfail   ( engine__odecfail   [gc][gllra] ) ,
            .oebusy     ( engine__oebusy     [gc][gllra] )
          );
        end
        else if (pNODE_BY_CYCLE == 1) begin
          // parallel pLLR_BY_CYCLE full search :: each pLLR_BY_CYCLE use sequential search
          ldpc_dec_cnode_engine
          #(
            .pCODE          ( pCODE          ) ,
            .pN             ( pN             ) ,
            .pLLR_W         ( pLLR_W         ) ,
            .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
            .pNODE_W        ( pNODE_W        ) ,
            .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
            .pUSE_NORM      ( pUSE_NORM      ) ,
            .pEBUSY_L       ( pEBUSY_L       ) ,
            .pEBUSY_H       ( pEBUSY_H       )
          )
          engine
          (
            .iclk       ( iclk    ) ,
            .ireset     ( ireset  ) ,
            .iclkena    ( iclkena ) ,
            //
            .isop       ( isop                              ) ,
            .ival       ( ival                              ) ,
            .ieop       ( ieop                              ) ,
            .izcnt      ( izcnt                             ) ,
            .ivmask     ( ivmask             [gc]       [0] ) ,
            .ivnode     ( ivnode             [gc][gllra][0] ) ,
            //
            .oval       ( engine__oval       [gc][gllra]    ) ,
            .ocnode     ( engine__ocnode     [gc][gllra][0] ) ,
            //
            .obusy      ( engine__obusy      [gc][gllra]    ) ,
            .otcnt      ( engine__otcnt      [gc][gllra]    ) ,
            .otcnt_zero ( engine__otcnt_zero [gc][gllra]    ) ,
            .ozcnt      ( engine__ozcnt      [gc][gllra]    ) ,
            //
            .odecfail   ( engine__odecfail   [gc][gllra]    ) ,
            .oebusy     ( engine__oebusy     [gc][gllra]    )
          );
        end
        else begin
          // sequential pNODE_BY_CYCLE search :: each pLLR_BY_CYCLE use sequential partial search pT/pNODE_BY_CYCLE -> sequential search pNODE_BY_CYCLE
          ldpc_dec_cnode_ps_engine
          #(
            .pCODE          ( pCODE          ) ,
            .pN             ( pN             ) ,
            .pLLR_W         ( pLLR_W         ) ,
            .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
            .pNODE_W        ( pNODE_W        ) ,
            .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
            .pUSE_NORM      ( pUSE_NORM      ) ,
            .pEBUSY_L       ( pEBUSY_L       ) ,
            .pEBUSY_H       ( pEBUSY_H       )
          )
          engine
          (
            .iclk       ( iclk    ) ,
            .ireset     ( ireset  ) ,
            .iclkena    ( iclkena ) ,
            //
            .isop       ( isop                           ) ,
            .ival       ( ival                           ) ,
            .ieop       ( ieop                           ) ,
            .izcnt      ( izcnt                          ) ,
            .ivmask     ( ivmask             [gc]        ) ,
            .ivnode     ( ivnode             [gc][gllra] ) ,
            //
            .oval       ( engine__oval       [gc][gllra] ) ,
            .ocnode     ( engine__ocnode     [gc][gllra] ) ,
            //
            .obusy      ( engine__obusy      [gc][gllra] ) ,
            .otcnt      ( engine__otcnt      [gc][gllra] ) ,
            .otcnt_zero ( engine__otcnt_zero [gc][gllra] ) ,
            .ozcnt      ( engine__ozcnt      [gc][gllra] ) ,
            //
            .odecfail   ( engine__odecfail   [gc][gllra] ) ,
            .oebusy     ( engine__oebusy     [gc][gllra] )
          );
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // tables for address generation
  //------------------------------------------------------------------------------------------------------

  addr_tab_t    addr_tab;
  maddr_tab_s_t maddr_tab;

  always_comb begin
    int fp;
`ifdef MODEL_TECH
    addr_tab = get_addr_tab(0); // no print file, gen short table
`else
    `include "ldpc_dec_addr_gen_tab.svh"
`endif
    // split by pNODE_BY_CYCLE
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        for (int t = 0; t < cT_MAX; t++) begin
          maddr_tab[c][n][t] = addr_tab[c][n*cT_MAX + t][0];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic       used_busy       [pC];
  logic       used_val        [pC];
  tcnt_t      used_tcnt       [pC];
  logic       used_tcnt_zero  [pC];
  zcnt_t      used_zcnt       [pC];

  mem_addr_t  zacc            [pC];
  paddr_t     raddr           [pC][pNODE_BY_CYCLE];

  paddr_t     raddr2out       [pC][pNODE_BY_CYCLE];

  //------------------------------------------------------------------------------------------------------
  // output data and address generation
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int c = 0; c < pC; c++) begin
      used_val      [c] = engine__oval        [c][0];
      used_busy     [c] = engine__obusy       [c][0];
      used_tcnt     [c] = engine__otcnt       [c][0];
      used_tcnt_zero[c] = engine__otcnt_zero  [c][0];
      used_zcnt     [c] = engine__ozcnt       [c][0];
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obusy <= 1'b0;
    end
    else if (iclkena) begin
      if (ival & isop) begin
        obusy <= 1'b1;
      end
      else if (oval & !engine__oebusy [0][0]) begin // have at least 2 ticks for end writing
        obusy <= 1'b0;
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= used_val[0];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // address generation (start at 1 tick early)
      for (int c = 0; c < pC; c++) begin
        if (used_busy[c]) begin
          zacc[c] <= used_tcnt_zero[c] ? '0 : (zacc[c] + cZ_MAX[cADDR_W-1 : 0]);
          // mux and shift address
          for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
            raddr[c][n].baddr <= maddr_tab[c][n][used_tcnt[c]].baddr + used_zcnt[c];
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              raddr[c][n].sela  [llra] <= maddr_tab[c][n][used_tcnt[c]].invsela [llra]; // addr gen use for write address -> use invsela
              raddr[c][n].offset[llra] <= maddr_tab[c][n][used_tcnt[c]].offsetm [llra]; // it's mask, for overlap logic  (!!!)
            end
          end
        end
      end
      // data output
      for (int c = 0; c < pC; c++) begin
        if (used_val[c]) begin
          ocnode[c] <= engine__ocnode[c];
          // mux and shift address delay
          for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
            raddr2out[c][n].baddr <= zacc[c] + get_mod(raddr[c][n].baddr, cZ_MAX);
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              raddr2out[c][n].sela [llra] <= raddr[c][n].sela [llra];
              // overlap logic for masked generation
              if ((raddr[c][n].baddr == 0 | raddr[c][n].baddr == cZ_MAX) & raddr[c][n].offset[llra][0]) begin// overlap case
                raddr2out[c][n].offset[llra] <= raddr[c][n].offset[llra] + cZ_MAX[cZCNT_W-1 : 0];
              end
              else begin
                raddr2out[c][n].offset [llra] <= raddr[c][n].offset [llra];
              end
            end // llra
          end // n
        end //used_val
      end // c
      // decfail output
      if (used_val[0]) begin
        odecfail <= get_decfail(engine__odecfail);
      end
    end
  end

  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        omask[c][n] = 1'b0; // no write mask
        for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
          oaddr[c][llra][n] = raddr2out[c][n].baddr + raddr2out[c][n].offset[llra];
          osela[c][llra][n] = raddr2out[c][n].sela[llra];
        end
      end
    end
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

  function logic get_decfail (input logic decfail [pC][pLLR_BY_CYCLE]);
    get_decfail = '0;
    for (int c = 0; c < pC; c++) begin
      for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
        get_decfail |= decfail[c][llra];
      end
    end
  endfunction

endmodule
