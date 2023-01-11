/*



  parameter int pLLR_W         = 4 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_W        = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;
  parameter bit pUSE_NORM      = 1 ;


  logic      gsfc_ldpc_dec_cnode__iclk                                            ;
  logic      gsfc_ldpc_dec_cnode__ireset                                          ;
  logic      gsfc_ldpc_dec_cnode__iclkena                                         ;
  logic      gsfc_ldpc_dec_cnode__isop                                            ;
  logic      gsfc_ldpc_dec_cnode__ival                                            ;
  logic      gsfc_ldpc_dec_cnode__ieop                                            ;
  zcnt_t     gsfc_ldpc_dec_cnode__izcnt                                           ;
  logic      gsfc_ldpc_dec_cnode__ivmask  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_t     gsfc_ldpc_dec_cnode__ivnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic      gsfc_ldpc_dec_cnode__osop                                            ;
  logic      gsfc_ldpc_dec_cnode__oval                                            ;
  mem_addr_t gsfc_ldpc_dec_cnode__oaddr   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t gsfc_ldpc_dec_cnode__osela   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic      gsfc_ldpc_dec_cnode__omask   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_t     gsfc_ldpc_dec_cnode__ocnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic      gsfc_ldpc_dec_cnode__odecfail                                        ;
  logic      gsfc_ldpc_dec_cnode__obusy                                           ;



  gsfc_ldpc_dec_cnode
  #(
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pUSE_NORM      ( pUSE_NORM      )
  )
  gsfc_ldpc_dec_cnode
  (
    .iclk     ( gsfc_ldpc_dec_cnode__iclk     ) ,
    .ireset   ( gsfc_ldpc_dec_cnode__ireset   ) ,
    .iclkena  ( gsfc_ldpc_dec_cnode__iclkena  ) ,
    .isop     ( gsfc_ldpc_dec_cnode__isop     ) ,
    .ival     ( gsfc_ldpc_dec_cnode__ival     ) ,
    .ieop     ( gsfc_ldpc_dec_cnode__ieop     ) ,
    .izcnt    ( gsfc_ldpc_dec_cnode__izcnt    ) ,
    .ivmask   ( gsfc_ldpc_dec_cnode__ivmask   ) ,
    .ivnode   ( gsfc_ldpc_dec_cnode__ivnode   ) ,
    .osop     ( gsfc_ldpc_dec_cnode__osop     ) ,
    .oval     ( gsfc_ldpc_dec_cnode__oval     ) ,
    .oaddr    ( gsfc_ldpc_dec_cnode__oaddr    ) ,
    .osela    ( gsfc_ldpc_dec_cnode__osela    ) ,
    .omask    ( gsfc_ldpc_dec_cnode__omask    ) ,
    .ocnode   ( gsfc_ldpc_dec_cnode__ocnode   ) ,
    .odecfail ( gsfc_ldpc_dec_cnode__odecfail ) ,
    .obusy    ( gsfc_ldpc_dec_cnode__obusy    )
  );


  assign gsfc_ldpc_dec_cnode__iclk    = '0 ;
  assign gsfc_ldpc_dec_cnode__ireset  = '0 ;
  assign gsfc_ldpc_dec_cnode__iclkena = '0 ;
  assign gsfc_ldpc_dec_cnode__isop    = '0 ;
  assign gsfc_ldpc_dec_cnode__ival    = '0 ;
  assign gsfc_ldpc_dec_cnode__ieop    = '0 ;
  assign gsfc_ldpc_dec_cnode__izcnt   = '0 ;
  assign gsfc_ldpc_dec_cnode__ivmask  = '0 ;
  assign gsfc_ldpc_dec_cnode__ivnode  = '0 ;



*/

//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_dec_cnode.sv
// Description   : LDPC decoder check node arithmetic top module: read vnode and count cnode. Consist of pC*pLLR_BY_CYCLE engines.
//


module gsfc_ldpc_dec_cnode
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  isop      ,
  ival      ,
  ieop      ,
  izcnt     ,
  ivmask    ,
  ivnode    ,
  //
  oval      ,
  oaddr     ,
  osela     ,
  omask     ,
  ocnode    ,
  //
  odecfail  ,
  obusy
);

  parameter bit pUSE_NORM = 1;

  `include "../gsfc_ldpc_parameters.svh"
  `include "gsfc_ldpc_dec_parameters.svh"
  `include "gsfc_ldpc_dec_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk                                            ;
  input  logic      ireset                                          ;
  input  logic      iclkena                                         ;
  //
  input  logic      isop                                            ;
  input  logic      ival                                            ;
  input  logic      ieop                                            ;
  input  zcnt_t     izcnt                                           ;
  input  logic      ivmask  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  node_t     ivnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic      oval                                            ;
  output mem_addr_t oaddr   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output mem_sela_t osela   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output logic      omask   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output node_t     ocnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic      odecfail                                        ;
  output logic      obusy                                           ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // preliminary engine
  logic     pre_engine__ivmask  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE][pW] ;
  node_t    pre_engine__ivnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE][pW] ;

  logic     pre_engine__osop    [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]     ;
  logic     pre_engine__oval    [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]     ;
  logic     pre_engine__oeop    [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]     ;
  vn_min_t  pre_engine__ovn     [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]     ;

  // main engine
  logic     engine__oval        [pC][pLLR_BY_CYCLE]                     ;
  tcnt_t    engine__otcnt       [pC][pLLR_BY_CYCLE]                     ;
  logic     engine__otcnt_zero  [pC][pLLR_BY_CYCLE]                     ;
  zcnt_t    engine__ozcnt       [pC][pLLR_BY_CYCLE]                     ;
  node_t    engine__ocnode      [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE][pW] ;

  logic     engine__obusy       [pC][pLLR_BY_CYCLE]                     ;
  logic     engine__odecfail    [pC][pLLR_BY_CYCLE]                     ;
  logic     engine__oebusy      [pC][pLLR_BY_CYCLE]                     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    genvar gc, gw, gllra, gn;
    for (gc = 0; gc < pC; gc++) begin : engine_inst_c_gen
      for (gllra = 0; gllra < pLLR_BY_CYCLE; gllra++) begin : engine_inst_llra_gen
        //
        // preliminary search. decrease pW -> 1
        for (gn = 0; gn < pNODE_BY_CYCLE; gn++) begin : engine_inst_n_gen
          gsfc_ldpc_dec_cnode_pre_engine
          #(
            .pLLR_W         ( pLLR_W         ) ,
            .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
            .pNODE_W        ( pNODE_W        ) ,
            .pNODE_BY_CYCLE ( pNODE_BY_CYCLE )
          )
          pre_engine
          (
            .iclk    ( iclk    ) ,
            .ireset  ( ireset  ) ,
            .iclkena ( iclkena ) ,
            //
            .isop    ( isop    ) ,
            .ival    ( ival    ) ,
            .ieop    ( ieop    ) ,
            .izcnt   ( izcnt   ) ,
            .ivmask  ( pre_engine__ivmask [gc][gllra][gn] ) ,
            .ivnode  ( pre_engine__ivnode [gc][gllra][gn] ) ,
            //
            .osop    ( pre_engine__osop   [gc][gllra][gn] ) ,
            .oval    ( pre_engine__oval   [gc][gllra][gn] ) ,
            .oeop    ( pre_engine__oeop   [gc][gllra][gn] ) ,
            .ovn     ( pre_engine__ovn    [gc][gllra][gn] )
          );

          always_comb begin
            for (int w = 0; w < pW; w++) begin
              pre_engine__ivmask[gc][gllra][gn][w] = ivmask[gc][w][gllra][gn];
              pre_engine__ivnode[gc][gllra][gn][w] = ivnode[gc][w][gllra][gn];
            end
          end
        end
        //
        // main search
        if (pNODE_BY_CYCLE == 1) begin  // parallel pLLR_BY_CYCLE sequential pNODE_BY_CYCLE full search
          gsfc_ldpc_dec_cnode_engine
          #(
            .pLLR_W         ( pLLR_W        ) ,
            .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE ) ,
            .pNODE_W        ( pNODE_W       ) ,
            .pNODE_BY_CYCLE ( 1             ) ,
            .pUSE_NORM      ( pUSE_NORM     )
          )
          engine
          (
            .iclk       ( iclk    ) ,
            .ireset     ( ireset  ) ,
            .iclkena    ( iclkena ) ,
            //
            .isop       ( pre_engine__osop   [gc][gllra][0] ) ,
            .ival       ( pre_engine__oval   [gc][gllra][0] ) ,
            .ieop       ( pre_engine__oeop   [gc][gllra][0] ) ,
            .ivn        ( pre_engine__ovn    [gc][gllra][0] ) ,
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
        else begin // parallel pLLR_BY_CYCLE & semi/full parallel pNODE_BY_CYCLE full search
          gsfc_ldpc_dec_cnode_pp_engine
          #(
            .pLLR_W         ( pLLR_W         ) ,
            .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
            .pNODE_W        ( pNODE_W        ) ,
            .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
            .pUSE_NORM      ( pUSE_NORM      )
          )
          engine
          (
            .iclk       ( iclk    ) ,
            .ireset     ( ireset  ) ,
            .iclkena    ( iclkena ) ,
            //
            .isop       ( pre_engine__osop   [gc][gllra][0] ) ,
            .ival       ( pre_engine__oval   [gc][gllra][0] ) ,
            .ieop       ( pre_engine__oeop   [gc][gllra][0] ) ,
            .ivn        ( pre_engine__ovn    [gc][gllra]    ) ,
            //
            .oval       ( engine__oval       [gc][gllra]    ) ,
            .ocnode     ( engine__ocnode     [gc][gllra]    ) ,
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
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // tables for address generation
  //------------------------------------------------------------------------------------------------------

  addr_tab_t    addr_tab;
  maddr_tab_s_t maddr_tab;

  always_comb begin
`ifdef MODEL_TECH
    addr_tab = get_addr_tab(0); // no print file, gen short table
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

  logic       used_busy       [pC];
  logic       used_val        [pC];
  tcnt_t      used_tcnt       [pC];
  logic       used_tcnt_zero  [pC];
  zcnt_t      used_zcnt       [pC];

  mem_addr_t  zacc            [pC];
  paddr_t     raddr           [pC][pW][pNODE_BY_CYCLE];

  paddr_t     raddr2out       [pC][pW][pNODE_BY_CYCLE];

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

  assign obusy = engine__oebusy[0][0];  // there is large block, not need to synchronize obusy at input

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
          for (int w = 0; w < pW; w++) begin
            for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
              raddr[c][w][n].baddr <= maddr_tab[c][w][n][used_tcnt[c]].baddr + used_zcnt[c];
              for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
                raddr[c][w][n].sela  [llra] <= maddr_tab[c][w][n][used_tcnt[c]].invsela [llra]; // addr gen use for write address -> use invsela
                raddr[c][w][n].offset[llra] <= maddr_tab[c][w][n][used_tcnt[c]].offsetm [llra]; // it's mask, for overlap logic  (!!!)
              end // llra
            end // n
          end // w
        end // used_busy
      end // c
      // data output
      for (int c = 0; c < pC; c++) begin
        if (used_val[c]) begin
          for (int w = 0; w < pW; w++) begin
            // mux and shift address delay
            for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
              raddr2out[c][w][n].baddr <= zacc[c] + get_mod(raddr[c][w][n].baddr, cZ_MAX);
              for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
                ocnode[c][w][llra][n] <= engine__ocnode[c][llra][n][w];
                //
                raddr2out[c][w][n].sela [llra] <= raddr[c][w][n].sela [llra];
                // overlap logic for masked generation
                if ((raddr[c][w][n].baddr == 0 | raddr[c][w][n].baddr == cZ_MAX) & raddr[c][w][n].offset[llra][0]) begin // overlap case
                  raddr2out[c][w][n].offset[llra] <= raddr[c][w][n].offset[llra] + cZ_MAX[cZCNT_W-1 : 0];
                end
                else begin
                  raddr2out[c][w][n].offset[llra] <= raddr[c][w][n].offset [llra];
                end
              end // llra
            end // n
          end // w
        end // used_val
      end // c
      // decfail output
      if (used_val[0]) begin
        odecfail <= get_decfail(engine__odecfail);
      end
    end
  end

  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int w = 0; w < pW; w++) begin
        for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            omask[c][w][llra][n] = 1'b0; // mask for future
            oaddr[c][w][llra][n] = raddr2out[c][w][n].baddr + raddr2out[c][w][n].offset[llra];
            osela[c][w][llra][n] = raddr2out[c][w][n].sela[llra];
          end
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
