/*



  parameter int pCODE          =  1 ;
  parameter int pN             =  1 ;
  parameter int pLLR_W         =  1 ;
  parameter int pLLR_BY_CYCLE  =  1 ;
  parameter int pNODE_W        =  1 ;
  parameter int pNODE_BY_CYCLE =  1 ;
  parameter bit pUSE_NORM      =  1 ;
  parameter bit pUSE_SC_MODE   =  0 ;



  logic                            ldpc_dec_vnode__iclk                                        ;
  logic                            ldpc_dec_vnode__ireset                                      ;
  logic                            ldpc_dec_vnode__iclkena                                     ;
  logic                            ldpc_dec_vnode__isop                                        ;
  logic                            ldpc_dec_vnode__ival                                        ;
  logic                            ldpc_dec_vnode__ieop                                        ;
  llr_t                            ldpc_dec_vnode__iLLR        [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_t                           ldpc_dec_vnode__icnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t                     ldpc_dec_vnode__icstate [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            ldpc_dec_vnode__iusop                                       ;
  logic                            ldpc_dec_vnode__iuval                                       ;
  llr_t                            ldpc_dec_vnode__iuLLR       [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            ldpc_dec_vnode__oval                                        ;
  mem_addr_t                       ldpc_dec_vnode__oaddr   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            ldpc_dec_vnode__oamux   [pC]                                ;
  mem_sela_t                       ldpc_dec_vnode__osela   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            ldpc_dec_vnode__omask   [pC]               [pNODE_BY_CYCLE] ;
  node_t                           ldpc_dec_vnode__ovnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t                     ldpc_dec_vnode__ovstate [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            ldpc_dec_vnode__obitsop                                     ;
  logic                            ldpc_dec_vnode__obitval                                     ;
  logic                            ldpc_dec_vnode__obiteop                                     ;
  logic      [pLLR_BY_CYCLE-1 : 0] ldpc_dec_vnode__obitdat                    [pNODE_BY_CYCLE] ;
  logic         [cBIT_ERR_W-1 : 0] ldpc_dec_vnode__obiterr                                     ;
  logic                            ldpc_dec_vnode__obusy                                       ;



  ldpc_dec_vnode
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pUSE_NORM      ( pUSE_NORM      ) ,
    .pUSE_SC_MODE   ( pUSE_SC_MODE   )
  )
  ldpc_dec_vnode
  (
    .iclk    ( ldpc_dec_vnode__iclk    ) ,
    .ireset  ( ldpc_dec_vnode__ireset  ) ,
    .iclkena ( ldpc_dec_vnode__iclkena ) ,
    .isop    ( ldpc_dec_vnode__isop    ) ,
    .ival    ( ldpc_dec_vnode__ival    ) ,
    .ieop    ( ldpc_dec_vnode__ieop    ) ,
    .iLLR    ( ldpc_dec_vnode__iLLR    ) ,
    .icnode  ( ldpc_dec_vnode__icnode  ) ,
    .icstate ( ldpc_dec_vnode__icstate ) ,
    .iusop   ( ldpc_dec_vnode__iusop   ) ,
    .iuval   ( ldpc_dec_vnode__iuval   ) ,
    .iuLLR   ( ldpc_dec_vnode__iuLLR   ) ,
    .oval    ( ldpc_dec_vnode__oval    ) ,
    .oaddr   ( ldpc_dec_vnode__oaddr   ) ,
    .oamux   ( ldpc_dec_vnode__oamux   ) ,
    .osela   ( ldpc_dec_vnode__osela   ) ,
    .omask   ( ldpc_dec_vnode__omask   ) ,
    .ovnode  ( ldpc_dec_vnode__ovnode  ) ,
    .ovstate ( ldpc_dec_vnode__ovstate ) ,
    .obitsop ( ldpc_dec_vnode__obitsop ) ,
    .obitval ( ldpc_dec_vnode__obitval ) ,
    .obiteop ( ldpc_dec_vnode__obiteop ) ,
    .obitdat ( ldpc_dec_vnode__obitdat ) ,
    .obiterr ( ldpc_dec_vnode__obiterr ) ,
    .obusy   ( ldpc_dec_vnode__obusy   )
  );


  assign ldpc_dec_vnode__iclk    = '0 ;
  assign ldpc_dec_vnode__ireset  = '0 ;
  assign ldpc_dec_vnode__iclkena = '0 ;
  assign ldpc_dec_vnode__isop    = '0 ;
  assign ldpc_dec_vnode__ival    = '0 ;
  assign ldpc_dec_vnode__ieop    = '0 ;
  assign ldpc_dec_vnode__iLLR    = '0 ;
  assign ldpc_dec_vnode__icnode  = '0 ;
  assign ldpc_dec_vnode__icstate = '0 ;
  assign ldpc_dec_vnode__iusop   = '0 ;
  assign ldpc_dec_vnode__iuval   = '0 ;
  assign ldpc_dec_vnode__iuLLR   = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_vnode.sv
// Description   : LDPC decoder variable node arithmetic top module: read cnode and count vnode. Consist of pLLR_BY_CYCLE*pNODE_BY_CYCLE engines.
//

`include "define.vh"

module ldpc_dec_vnode
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  iLLR    ,
  icnode  ,
  icstate ,
  //
  iusop   ,
  iuval   ,
  iuLLR   ,
  //
  oval    ,
  oaddr   ,
  oamux   ,
  osela   ,
  omask   ,
  ovnode  ,
  ovstate ,
  //
  obitsop ,
  obitval ,
  obiteop ,
  obitdat ,
  obiterr ,
  //
  obusy
);

  parameter bit pUSE_NORM             = 1; // use normalization

  `include "../ldpc_parameters.svh"
  `include "ldpc_dec_parameters.svh"

  parameter int pBIT_ERR_SPLIT_FACTOR = pNODE_BY_CYCLE; // parameter used to split pLLR_BY_CYCLE * pNODE_BY_CYCLE bit errors on 2 stage adder to increase speed of counter

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                        iclk                                        ;
  input  logic                        ireset                                      ;
  input  logic                        iclkena                                     ;
  // cycle work interface
  input  logic                        isop                                        ;
  input  logic                        ival                                        ;
  input  logic                        ieop                                        ;
  input  llr_t                        iLLR        [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  node_t                       icnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  node_state_t                 icstate [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  // initial upload interface
  input  logic                        iusop                                       ;
  input  logic                        iuval                                       ;
  input  llr_t                        iuLLR       [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic                        oval                                        ;
  output mem_addr_t                   oaddr   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output logic                        oamux   [pC]                                ;
  output mem_sela_t                   osela   [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output logic                        omask   [pC]               [pNODE_BY_CYCLE] ;
  output node_t                       ovnode  [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output node_state_t                 ovstate [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic                        obitsop                                     ;
  output logic                        obitval                                     ;
  output logic                        obiteop                                     ;
  output logic  [pLLR_BY_CYCLE-1 : 0] obitdat                    [pNODE_BY_CYCLE] ;
  output logic     [cBIT_ERR_W-1 : 0] obiterr                                     ;
  //
  output logic                        obusy                                       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBIT_ERR_STAGE   = cBIT_ERR_MAX/pBIT_ERR_SPLIT_FACTOR;
  localparam int cBIT_ERR_STAGE_W = clogb2(cBIT_ERR_STAGE) + 1 ; // +1 to prevent overflow if cBIT_ERR_MAX = 2^N

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                          engine__isop                                        ;
  logic                          engine__ival                                        ;
  logic                          engine__ieop                                        ;
  llr_t                          engine__iLLR    [pLLR_BY_CYCLE][pNODE_BY_CYCLE]     ;
  node_t                         engine__icnode  [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC] ;
  node_state_t                   engine__icstate [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC] ;

  logic    [pLLR_BY_CYCLE-1 : 0] engine__osop                   [pNODE_BY_CYCLE]     ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__oval                   [pNODE_BY_CYCLE]     ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__oeop                   [pNODE_BY_CYCLE]     ;
  node_t                         engine__ovnode  [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC] ;
  node_state_t                   engine__ovstate [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC] ;

  logic    [pLLR_BY_CYCLE-1 : 0] engine__obitsop                [pNODE_BY_CYCLE]     ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obitval                [pNODE_BY_CYCLE]     ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obiteop                [pNODE_BY_CYCLE]     ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obitdat                [pNODE_BY_CYCLE]     ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obiterr                [pNODE_BY_CYCLE]     ;

  logic                          bitsop                             ;
  logic                          bitval                             ;
  logic                          biteop                             ;
  logic    [pLLR_BY_CYCLE-1 : 0] bitdat [pNODE_BY_CYCLE]            ;
  logic [cBIT_ERR_STAGE_W-1 : 0] biterr [0 : pBIT_ERR_SPLIT_FACTOR] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      engine__ival <= 1'b0 ;
    end
    else if (iclkena) begin
      engine__ival <= ival ;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      engine__isop <= isop ;
      engine__ieop <= ieop ;
      engine__iLLR <= iLLR ;
    end
  end

  generate
    genvar gllra, gn;
    for (gllra = 0; gllra < pLLR_BY_CYCLE; gllra++) begin : v_engine_llra_inst
      for (gn = 0; gn < pNODE_BY_CYCLE; gn++) begin : v_engine_n_inst
        ldpc_dec_vnode_engine
        #(
          .pCODE        ( pCODE        ) ,
          .pN           ( pN           ) ,
          .pLLR_W       ( pLLR_W       ) ,
          .pNODE_W      ( pNODE_W      ) ,
          .pUSE_NORM    ( pUSE_NORM    ) ,
          .pUSE_SC_MODE ( pUSE_SC_MODE )
        )
        engine
        (
          .iclk    ( iclk    ) ,
          .ireset  ( ireset  ) ,
          .iclkena ( iclkena ) ,
          //
          .isop    ( engine__isop                ) ,
          .ival    ( engine__ival                ) ,
          .ieop    ( engine__ieop                ) ,
          .iLLR    ( engine__iLLR    [gllra][gn] ) ,
          .icnode  ( engine__icnode  [gllra][gn] ) ,
          .icstate ( engine__icstate [gllra][gn] ) ,
          //
          .osop    ( engine__osop    [gn][gllra] ) ,
          .oval    ( engine__oval    [gn][gllra] ) ,
          .oeop    ( engine__oeop    [gn][gllra] ) ,
          .ovnode  ( engine__ovnode  [gllra][gn] ) ,
          .ovstate ( engine__ovstate [gllra][gn] ) ,
          //
          .obitsop ( engine__obitsop [gn][gllra] ) ,
          .obitval ( engine__obitval [gn][gllra] ) ,
          .obiteop ( engine__obiteop [gn][gllra] ) ,
          .obitdat ( engine__obitdat [gn][gllra] ) ,
          .obiterr ( engine__obiterr [gn][gllra] )
        );

        always_ff @(posedge iclk) begin
          if (iclkena) begin
            for (int c = 0; c < pC; c++) begin
              engine__icnode  [gllra][gn][c] <= icnode [c][gllra][gn];
              engine__icstate [gllra][gn][c] <= icstate[c][gllra][gn];
            end
          end
        end

      end
    end
  endgenerate

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      bitval  <= 1'b0;
      //
      obitval <= 1'b0;
    end
    else if (iclkena) begin
      bitval  <= engine__obitval[0][0];
      //
      obitval <= bitval;
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic     [cBIT_ERR_MAX-1 : 0] biterr_vector; // {tail, {pBIT_ERR_SPLIT_FACTOR{cBIT_ERR_STAGE}}}
  logic   [cBIT_ERR_STAGE-1 : 0] biterr_vector_tail;

  always_comb begin
    for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
      biterr_vector[n*pLLR_BY_CYCLE +: pLLR_BY_CYCLE] <= engine__obiterr[n];
    end
  end

  generate // fix bug of questa
    if ((cBIT_ERR_MAX % pBIT_ERR_SPLIT_FACTOR) != 0) begin
      assign biterr_vector_tail = biterr_vector[cBIT_ERR_MAX-1 : pBIT_ERR_SPLIT_FACTOR*cBIT_ERR_STAGE];
    end
    else begin
      assign biterr_vector_tail = '0;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // local sum
      bitsop  <= engine__obitsop[0][0];
      biteop  <= engine__obiteop[0][0];
      bitdat  <= engine__obitdat;
      for (int i = 0; i <= pBIT_ERR_SPLIT_FACTOR; i++) begin
        if (i == pBIT_ERR_SPLIT_FACTOR) begin
          biterr[i] <= erracc_stage0(biterr_vector_tail);
        end
        else begin
          biterr[i] <= erracc_stage0(biterr_vector[i*cBIT_ERR_STAGE +: cBIT_ERR_STAGE]);
        end
      end
      // final sum
      obitsop <= bitsop;
      obiteop <= biteop;
      obitdat <= bitdat;
      obiterr <= erracc_stage1(biterr);
    end
  end

  // need wait for small cT_MAX to prevent to overrun the mem address.
  always_comb begin
    if (cT_MAX > 6) begin
      obusy = 1'b0;
    end
    else if (cT_MAX > 3) begin
      obusy = engine__ival;
    end
    else begin
      obusy = oval;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output data and address generation
  //------------------------------------------------------------------------------------------------------

  mem_addr_t waddr [pC];

  wire used_val = engine__oval[0][0];
  wire used_sop = engine__osop[0][0];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= iuval | used_val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int c = 0; c < pC; c++) begin
        oamux[c] <= iuval | used_val;
      end
      if (iuval | used_val) begin
        for (int c = 0; c < pC; c++) begin
          waddr[c] <= (iusop | used_sop) ? '0 : (waddr[c] + 1'b1);
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
              ovstate[c][llra][n].pre_sign  <= iuval ? 1'b0                                    : engine__ovstate[llra][n][c].pre_sign;
              ovstate[c][llra][n].pre_zero  <= iuval ? 1'b1                                    : engine__ovstate[llra][n][c].pre_zero;
              ovnode [c][llra][n]           <= iuval ? (iuLLR[llra][n] <<< (pNODE_W - pLLR_W)) : engine__ovnode [llra][n][c];
            end
          end
        end
      end
    end
  end

  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        omask[c][n] = 1'b0; // not need, this mask moved to cnode input
        for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
          osela[c][llra][n] = llra[cSELA_W-1 : 0];
          oaddr[c][llra][n] = waddr[c];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // used function
  //------------------------------------------------------------------------------------------------------

  function logic [cBIT_ERR_STAGE_W-1 : 0] erracc_stage0 (input logic [cBIT_ERR_STAGE-1 : 0] err);
    erracc_stage0 = '0;
    for (int n = 0; n < cBIT_ERR_STAGE; n++) begin
      erracc_stage0 = erracc_stage0 + err[n];
    end
  endfunction

  function logic [cBIT_ERR_W-1 : 0] erracc_stage1 (input logic [cBIT_ERR_STAGE_W-1 : 0] err [0 : pBIT_ERR_SPLIT_FACTOR]);
    erracc_stage1 = '0;
    for (int n = 0; n <= pBIT_ERR_SPLIT_FACTOR; n++) begin
      erracc_stage1 = erracc_stage1 + err[n];
    end
  endfunction

endmodule
