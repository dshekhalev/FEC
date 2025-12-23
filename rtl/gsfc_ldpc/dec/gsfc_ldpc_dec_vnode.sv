/*



  parameter int pLLR_W         =  1 ;
  parameter int pLLR_BY_CYCLE  =  1 ;
  parameter int pNODE_W        =  1 ;
  parameter int pNODE_BY_CYCLE =  1 ;
  parameter bit pUSE_NORM      =  1 ;
  parameter bit pUSE_SC_MODE   =  0 ;



  logic                            gsfc_ldpc_dec_vnode__iclk                                            ;
  logic                            gsfc_ldpc_dec_vnode__ireset                                          ;
  logic                            gsfc_ldpc_dec_vnode__iclkena                                         ;
  logic                            gsfc_ldpc_dec_vnode__isop                                            ;
  logic                            gsfc_ldpc_dec_vnode__ival                                            ;
  logic                            gsfc_ldpc_dec_vnode__ieop                                            ;
  llr_t                            gsfc_ldpc_dec_vnode__iLLR            [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_t                           gsfc_ldpc_dec_vnode__icnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t                     gsfc_ldpc_dec_vnode__icstate [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            gsfc_ldpc_dec_vnode__iusop                                           ;
  logic                            gsfc_ldpc_dec_vnode__iuval                                           ;
  llr_t                            gsfc_ldpc_dec_vnode__iuLLR           [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            gsfc_ldpc_dec_vnode__oval                                            ;
  mem_addr_t                       gsfc_ldpc_dec_vnode__oaddr   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            gsfc_ldpc_dec_vnode__oamux   [pC][pW]                                ;
  mem_sela_t                       gsfc_ldpc_dec_vnode__osela   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            gsfc_ldpc_dec_vnode__omask   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_t                           gsfc_ldpc_dec_vnode__ovnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t                     gsfc_ldpc_dec_vnode__ovstate [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                            gsfc_ldpc_dec_vnode__obitsop                                         ;
  logic                            gsfc_ldpc_dec_vnode__obitval                                         ;
  logic                            gsfc_ldpc_dec_vnode__obiteop                                         ;
  logic      [pLLR_BY_CYCLE-1 : 0] gsfc_ldpc_dec_vnode__obitdat                        [pNODE_BY_CYCLE] ;
  logic         [cBIT_ERR_W-1 : 0] gsfc_ldpc_dec_vnode__obiterr                                         ;
  logic                            gsfc_ldpc_dec_vnode__obusy                                           ;



  gsfc_ldpc_dec_vnode
  #(
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pUSE_NORM      ( pUSE_NORM      ) ,
    .pUSE_SC_MODE   ( pUSE_SC_MODE   )
  )
  gsfc_ldpc_dec_vnode
  (
    .iclk    ( gsfc_ldpc_dec_vnode__iclk    ) ,
    .ireset  ( gsfc_ldpc_dec_vnode__ireset  ) ,
    .iclkena ( gsfc_ldpc_dec_vnode__iclkena ) ,
    .isop    ( gsfc_ldpc_dec_vnode__isop    ) ,
    .ival    ( gsfc_ldpc_dec_vnode__ival    ) ,
    .ieop    ( gsfc_ldpc_dec_vnode__ieop    ) ,
    .iLLR    ( gsfc_ldpc_dec_vnode__iLLR    ) ,
    .icnode  ( gsfc_ldpc_dec_vnode__icnode  ) ,
    .icstate ( gsfc_ldpc_dec_vnode__icstate ) ,
    .iusop   ( gsfc_ldpc_dec_vnode__iusop   ) ,
    .iuval   ( gsfc_ldpc_dec_vnode__iuval   ) ,
    .iuLLR   ( gsfc_ldpc_dec_vnode__iuLLR   ) ,
    .oval    ( gsfc_ldpc_dec_vnode__oval    ) ,
    .oaddr   ( gsfc_ldpc_dec_vnode__oaddr   ) ,
    .oamux   ( gsfc_ldpc_dec_vnode__oamux   ) ,
    .osela   ( gsfc_ldpc_dec_vnode__osela   ) ,
    .omask   ( gsfc_ldpc_dec_vnode__omask   ) ,
    .ovnode  ( gsfc_ldpc_dec_vnode__ovnode  ) ,
    .ovstate ( gsfc_ldpc_dec_vnode__ovstate ) ,
    .obitsop ( gsfc_ldpc_dec_vnode__obitsop ) ,
    .obitval ( gsfc_ldpc_dec_vnode__obitval ) ,
    .obiteop ( gsfc_ldpc_dec_vnode__obiteop ) ,
    .obitdat ( gsfc_ldpc_dec_vnode__obitdat ) ,
    .obiterr ( gsfc_ldpc_dec_vnode__obiterr ) ,
    .obusy   ( gsfc_ldpc_dec_vnode__obusy   )
  );


  assign gsfc_ldpc_dec_vnode__iclk    = '0 ;
  assign gsfc_ldpc_dec_vnode__ireset  = '0 ;
  assign gsfc_ldpc_dec_vnode__iclkena = '0 ;
  assign gsfc_ldpc_dec_vnode__isop    = '0 ;
  assign gsfc_ldpc_dec_vnode__ival    = '0 ;
  assign gsfc_ldpc_dec_vnode__ieop    = '0 ;
  assign gsfc_ldpc_dec_vnode__iLLR    = '0 ;
  assign gsfc_ldpc_dec_vnode__icnode  = '0 ;
  assign gsfc_ldpc_dec_vnode__icstate = '0 ;
  assign gsfc_ldpc_dec_vnode__iusop   = '0 ;
  assign gsfc_ldpc_dec_vnode__iuval   = '0 ;
  assign gsfc_ldpc_dec_vnode__iuLLR   = '0 ;



*/

//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_dec_vnode.v
// Description   : LDPC decoder variable node arithmetic top module: read cnode and count vnode. Consist of pLLR_BY_CYCLE*pNODE_BY_CYCLE engines.
//

module gsfc_ldpc_dec_vnode
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

  `include "../gsfc_ldpc_parameters.svh"
  `include "gsfc_ldpc_dec_parameters.svh"

  parameter int pBIT_ERR_SPLIT_FACTOR = pLLR_BY_CYCLE; // parameter used to split pLLR_BY_CYCLE * pNODE_BY_CYCLE bit errors on 2 stage adder to increase speed of counter

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                        iclk                                            ;
  input  logic                        ireset                                          ;
  input  logic                        iclkena                                         ;
  // cycle work interface
  input  logic                        isop                                            ;
  input  logic                        ival                                            ;
  input  logic                        ieop                                            ;
  input  llr_t                        iLLR            [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  node_t                       icnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  node_state_t                 icstate [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  // initial upload interface
  input  logic                        iusop                                           ;
  input  logic                        iuval                                           ;
  input  llr_t                        iuLLR           [pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic                        oval                                            ;
  output mem_addr_t                   oaddr   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output logic                        oamux   [pC][pW]                                ;
  output mem_sela_t                   osela   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output logic                        omask   [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output node_t                       ovnode  [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output node_state_t                 ovstate [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  output logic                        obitsop                                         ;
  output logic                        obitval                                         ;
  output logic                        obiteop                                         ;
  output logic  [pLLR_BY_CYCLE-1 : 0] obitdat                        [pNODE_BY_CYCLE] ;
  output logic     [cBIT_ERR_W-1 : 0] obiterr                                         ;
  //
  output logic                        obusy                                           ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBIT_ERR_STAGE   = cBIT_ERR_MAX/pBIT_ERR_SPLIT_FACTOR;
  localparam int cBIT_ERR_STAGE_W = $clog2(cBIT_ERR_STAGE) + 1 ; // +1 to prevent overflow if cBIT_ERR_MAX = 2^N

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                        engine__isop                                            ;
  logic                        engine__ival                                            ;
  logic                        engine__ieop                                            ;
  llr_t                        engine__iLLR    [pLLR_BY_CYCLE][pNODE_BY_CYCLE]         ;
  node_t                       engine__icnode  [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC][pW] ;
  node_state_t                 engine__icstate [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC][pW] ;

  logic  [pLLR_BY_CYCLE-1 : 0] engine__osop                   [pNODE_BY_CYCLE]         ;
  logic  [pLLR_BY_CYCLE-1 : 0] engine__oval                   [pNODE_BY_CYCLE]         ;
  logic  [pLLR_BY_CYCLE-1 : 0] engine__oeop                   [pNODE_BY_CYCLE]         ;
  node_t                       engine__ovnode  [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC][pW] ;
  node_state_t                 engine__ovstate [pLLR_BY_CYCLE][pNODE_BY_CYCLE][pC][pW] ;

  logic  [pLLR_BY_CYCLE-1 : 0] engine__obitsop                [pNODE_BY_CYCLE]         ;
  logic  [pLLR_BY_CYCLE-1 : 0] engine__obitval                [pNODE_BY_CYCLE]         ;
  logic  [pLLR_BY_CYCLE-1 : 0] engine__obiteop                [pNODE_BY_CYCLE]         ;
  logic  [pLLR_BY_CYCLE-1 : 0] engine__obitdat                [pNODE_BY_CYCLE]         ;
  logic  [pLLR_BY_CYCLE-1 : 0] engine__obiterr                [pNODE_BY_CYCLE]         ;

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
        gsfc_ldpc_dec_vnode_engine
        #(
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
              for (int w = 0; w < pW; w++) begin
                engine__icnode  [gllra][gn][c][w] <= icnode [c][w][gllra][gn];
                engine__icstate [gllra][gn][c][w] <= icstate[c][w][gllra][gn];
              end
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

  assign obusy = (pLLR_BY_CYCLE == 1) ? 1'b0 : oval;

  //------------------------------------------------------------------------------------------------------
  // output data and address generation
  //------------------------------------------------------------------------------------------------------

  mem_addr_t waddr [pC][pW];

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
        for (int w = 0; w < pW; w++) begin
          oamux[c][w] <= iuval | used_val;
        end
      end
      if (iuval | used_val) begin
        for (int c = 0; c < pC; c++) begin
          for (int w = 0; w < pW; w++) begin
            waddr[c][w] <= (iusop | used_sop) ? '0 : (waddr[c][w] + 1'b1);
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
                ovstate[c][w][llra][n].pre_sign  <= iuval ? 1'b0                                    : engine__ovstate[llra][n][c][w].pre_sign;
                ovstate[c][w][llra][n].pre_zero  <= iuval ? 1'b1                                    : engine__ovstate[llra][n][c][w].pre_zero;
                ovnode [c][w][llra][n]           <= iuval ? (iuLLR[llra][n] <<< (pNODE_W - pLLR_W)) : engine__ovnode [llra][n][c][w];
              end // n
            end // llra
          end //w
        end // c
      end // used_Val
    end // iclkena
  end // iclk

  always_comb begin
    for (int c = 0; c < pC; c++) begin
      for (int w = 0; w < pW; w++) begin
        for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            omask[c][w][llra][n] = 1'b0;
            osela[c][w][llra][n] = llra[cSELA_W-1 : 0];
            oaddr[c][w][llra][n] = waddr[c][w];
          end // llra
        end // n
      end // w
    end // c
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
