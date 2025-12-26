/*



  parameter int pLLR_W            = 4 ;
  parameter int pNODE_W           = 8 ;
  //
  parameter int pUSE_SC_MODE      = 1 ;
  parameter bit pDO_LLR_INVERSION = 0 ;
  parameter bit pUSE_SRL_FIFO     = 0 ;


  logic         ldpc_dvb_dec_vnode__iclk         ;
  logic         ldpc_dvb_dec_vnode__ireset       ;
  logic         ldpc_dvb_dec_vnode__iclkena      ;
  //
  logic         ldpc_dvb_dec_vnode__istart       ;
  logic         ldpc_dvb_dec_vnode__iload_iter   ;
  //
  logic         ldpc_dvb_dec_vnode__ival         ;
  strb_t        ldpc_dvb_dec_vnode__istrb        ;
  vnode_ctx_t   ldpc_dvb_dec_vnode__ivnode_ctx   ;
  zllr_t        ldpc_dvb_dec_vnode__iLLR         ;
  znode_t       ldpc_dvb_dec_vnode__icnode       ;
  znode_state_t ldpc_dvb_dec_vnode__ivnode_state ;
  //
  logic         ldpc_dvb_dec_vnode__ovnode_val   ;
  cycle_idx_t   ldpc_dvb_dec_vnode__ovnode_addr  ;
  znode_t       ldpc_dvb_dec_vnode__ovnode       ;
  zdat_t        ldpc_dvb_dec_vnode__ovnode_hd    ;
  znode_state_t ldpc_dvb_dec_vnode__ovnode_state ;
  //
  logic         ldpc_dvb_dec_vnode__obitval      ;
  logic         ldpc_dvb_dec_vnode__obitsop      ;
  logic         ldpc_dvb_dec_vnode__obiteop      ;
  zdat_t        ldpc_dvb_dec_vnode__obitdat      ;
  zdat_t        ldpc_dvb_dec_vnode__obiterr      ;
  col_t         ldpc_dvb_dec_vnode__obitaddr     ;
  //
  logic         ldpc_dvb_dec_vnode__obusy        ;



  ldpc_dvb_dec_vnode
  #(
    .pLLR_W            ( pLLR_W            ) ,
    .pNODE_W           ( pNODE_W           ) ,
    //
    .pUSE_SC_MODE      ( pUSE_SC_MODE      ) ,
    .pDO_LLR_INVERSION ( pDO_LLR_INVERSION ) ,
    .pUSE_SRL_FIFO     ( pUSE_SRL_FIFO     )
  )
  ldpc_dvb_dec_vnode
  (
    .iclk         ( ldpc_dvb_dec_vnode__iclk         ) ,
    .ireset       ( ldpc_dvb_dec_vnode__ireset       ) ,
    .iclkena      ( ldpc_dvb_dec_vnode__iclkena      ) ,
    //
    .istart       ( ldpc_dvb_dec_vnode__istart       ) ,
    .iload_iter   ( ldpc_dvb_dec_vnode__iload_iter   ) ,
    //
    .ival         ( ldpc_dvb_dec_vnode__ival         ) ,
    .istrb        ( ldpc_dvb_dec_vnode__istrb        ) ,
    .ivnode_ctx   ( ldpc_dvb_dec_vnode__ivnode_ctx   ) ,
    .iLLR         ( ldpc_dvb_dec_vnode__iLLR         ) ,
    .icnode       ( ldpc_dvb_dec_vnode__icnode       ) ,
    .ivnode_state ( ldpc_dvb_dec_vnode__ivnode_state ) ,
    //
    .ovnode_val   ( ldpc_dvb_dec_vnode__ovnode_val   ) ,
    .ovnode_addr  ( ldpc_dvb_dec_vnode__ovnode_addr  ) ,
    .ovnode       ( ldpc_dvb_dec_vnode__ovnode       ) ,
    .ovnode_hd    ( ldpc_dvb_dec_vnode__ovnode_hd    ) ,
    .ovnode_state ( ldpc_dvb_dec_vnode__ovnode_state ) ,
    //
    .obitval      ( ldpc_dvb_dec_vnode__obitval      ) ,
    .obitsop      ( ldpc_dvb_dec_vnode__obitsop      ) ,
    .obiteop      ( ldpc_dvb_dec_vnode__obiteop      ) ,
    .obitdat      ( ldpc_dvb_dec_vnode__obitdat      ) ,
    .obiterr      ( ldpc_dvb_dec_vnode__obiterr      ) ,
    .obitaddr     ( ldpc_dvb_dec_vnode__obitaddr     ) ,
    //
    .obusy        ( ldpc_dvb_dec_vnode__obusy        )
  );


  assign ldpc_dvb_dec_vnode__iclk         = '0 ;
  assign ldpc_dvb_dec_vnode__ireset       = '0 ;
  assign ldpc_dvb_dec_vnode__iclkena      = '0 ;
  assign ldpc_dvb_dec_vnode__istart       = '0 ;
  assign ldpc_dvb_dec_vnode__iload_iter   = '0 ;
  assign ldpc_dvb_dec_vnode__ival         = '0 ;
  assign ldpc_dvb_dec_vnode__istrb        = '0 ;
  assign ldpc_dvb_dec_vnode__ivnode_ctx   = '0 ;
  assign ldpc_dvb_dec_vnode__iLLR         = '0 ;
  assign ldpc_dvb_dec_vnode__icnode       = '0 ;
  assign ldpc_dvb_dec_vnode__ivnode_state = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_vnode.sv
// Description   : Min-sum vertical step top-module
//

module ldpc_dvb_dec_vnode
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  istart       ,
  iload_iter   ,
  //
  ival         ,
  istrb        ,
  ivnode_ctx   ,
  iLLR         ,
  icnode       ,
  ivnode_state ,
  //
  ovnode_val   ,
  ovnode_addr  ,
  ovnode       ,
  ovnode_hd    ,
  ovnode_state ,
  //
  obitval      ,
  obitsop      ,
  obiteop      ,
  obitdat      ,
  obiterr      ,
  obitaddr     ,
  //
  obusy
);

  parameter bit pDO_LLR_INVERSION = 0;
  parameter bit pUSE_SRL_FIFO     = 1;  // use SRL based internal FIFO

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk         ;
  input  logic          ireset       ;
  input  logic          iclkena      ;
  //
  input  logic          istart       ;
  input  logic          iload_iter   ;
  //
  input  logic          ival         ;
  input  strb_t         istrb        ;
  input  vnode_ctx_t    ivnode_ctx   ;
  input  zllr_t         iLLR         ;
  input  znode_t        icnode       ;
  input  znode_state_t  ivnode_state ;
  //
  output logic          ovnode_val   ;
  output cycle_idx_t    ovnode_addr  ;
  output znode_t        ovnode       ;
  output zdat_t         ovnode_hd    ;
  output znode_state_t  ovnode_state ;
  //
  output logic          obitval      ;
  output logic          obitsop      ;
  output logic          obiteop      ;
  output zdat_t         obitdat      ;
  output zdat_t         obiterr      ;
  output col_t          obitaddr     ;
  //
  output logic          obusy        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cNODE_TAG_W          = $bits(cycle_idx_t);

  localparam int cCNODE_FIFO_DEPTH_W  = cNODE_PER_COL_NUM_W ;
  localparam int cCNODE_FIFO_DAT_W    = pNODE_W * cZC_MAX + cNODE_TAG_W + (pUSE_SC_MODE ? cNODE_STATE_W*cZC_MAX : 0);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // vnode sum
  zdat_t                          sum__ovnode_val                 ;
  node_sum_t                      sum__ovnode_sum        [cZC_MAX];
  node_num_t                      sum__ovnode_num_m1     [cZC_MAX];
  zdat_t                          sum__ovnode_hd                  ;
  //
  zdat_t                          sum__ovnode_pre_val             ;
  node_num_t                      sum__ovnode_pre_num_m1 [cZC_MAX];
  //
  zdat_t                          sum__obitval                    ;
  zdat_t                          sum__obitsop                    ;
  zdat_t                          sum__obiteop                    ;
  zdat_t                          sum__obitdat                    ;
  zdat_t                          sum__obiterr                    ;
  //
  col_t                           sum__obitaddr          [cZC_MAX];
  //
  // cnode fifo
  logic                           cnode_fifo__iclear  ;
  //
  logic                           cnode_fifo__iwrite  ;
  logic [cCNODE_FIFO_DAT_W-1 : 0] cnode_fifo__iwdat   ;
  //
  logic                           cnode_fifo__iread   ;
  logic                           cnode_fifo__orval   ;
  logic [cCNODE_FIFO_DAT_W-1 : 0] cnode_fifo__ordat   ;
  //
  logic                           cnode_fifo__oempty  ;
  logic                           cnode_fifo__ofull   ;
  //
  // ctrl
  logic                           ctrl__irdy       ;
  node_num_t                      ctrl__inum_m1    ;
  logic                           ctrl__oread      ;
  logic                           ctrl__orslt_read ;
  //
  // vnode restore
  logic                           restore__istate_init          ;
  zdat_t                          restore__ival                 ;
  cycle_idx_t                     restore__ivnode_addr [cZC_MAX];
  znode_state_t                   restore__ivnode_state         ;
  znode_t                         restore__icnode               ;
  node_sum_t                      restore__ivnode_sum  [cZC_MAX];
  zdat_t                          restore__ivnode_hd            ;
  //
  zdat_t                          restore__ovnode_val           ;
  cycle_idx_t                     restore__ovnode_addr [cZC_MAX];
  znode_t                         restore__ovnode               ;
  zdat_t                          restore__ovnode_hd            ;
  znode_state_t                   restore__ovnode_state         ;

  //------------------------------------------------------------------------------------------------------
  // vnode accumulator
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < cZC_MAX; g++) begin : vnode_sum_inst
      ldpc_dvb_dec_vnode_sum
      #(
        .pLLR_W            ( pLLR_W            ) ,
        .pNODE_W           ( pNODE_W           ) ,
        .pDO_LLR_INVERSION ( pDO_LLR_INVERSION )
      )
      sum
      (
        .iclk              ( iclk                       ) ,
        .ireset            ( ireset                     ) ,
        .iclkena           ( iclkena                    ) ,
        //
        .iload_iter        ( iload_iter                 ) ,
        //
        .ival              ( ival                       ) ,
        .istrb             ( istrb                      ) ,
        .iLLR              ( iLLR                   [g] ) ,
        .icnode            ( icnode                 [g] ) ,
        .icol_idx          ( ivnode_ctx.col_idx         ) ,
        //
        .ovnode_val        ( sum__ovnode_val        [g] ) ,
        .ovnode_sum        ( sum__ovnode_sum        [g] ) ,
        .ovnode_num_m1     ( sum__ovnode_num_m1     [g] ) ,
        .ovnode_hd         ( sum__ovnode_hd         [g] ) ,
        //
        .ovnode_pre_val    ( sum__ovnode_pre_val    [g] ) ,
        .ovnode_pre_num_m1 ( sum__ovnode_pre_num_m1 [g] ) ,
        //
        .obitval           ( sum__obitval           [g] ) ,
        .obitsop           ( sum__obitsop           [g] ) ,
        .obiteop           ( sum__obiteop           [g] ) ,
        .obitdat           ( sum__obitdat           [g] ) ,
        .obiterr           ( sum__obiterr           [g] ) ,
        .obitaddr          ( sum__obitaddr          [g] )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // cnode dynamic align line (1 tick delay)
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_SRL_FIFO) begin
      codec_srl_fifo
      #(
        .pDEPTH_W ( cCNODE_FIFO_DEPTH_W ) ,
        .pDAT_W   ( cCNODE_FIFO_DAT_W   )
      )
      cnode_fifo
      (
        .iclk    ( iclk               ) ,
        .ireset  ( 1'b0               ) , // don'n need because there is iclear used
        .iclkena ( iclkena            ) ,
        //
        .iclear  ( cnode_fifo__iclear ) ,
        //
        .iwrite  ( cnode_fifo__iwrite ) ,
        .iwdat   ( cnode_fifo__iwdat  ) ,
        //
        .iread   ( cnode_fifo__iread  ) ,
        .orval   ( cnode_fifo__orval  ) ,
        .ordat   ( cnode_fifo__ordat  ) ,
        //
        .oempty  ( cnode_fifo__oempty ) ,
        .ofull   ( cnode_fifo__ofull  ) ,
        .ohfull  (                    ) ,   // not used
        .ousedw  (                    )     // not used
      );
    end
    else begin
      codec_fifo
      #(
        .pDEPTH_W ( cCNODE_FIFO_DEPTH_W ) ,
        .pDAT_W   ( cCNODE_FIFO_DAT_W   )
      )
      cnode_fifo
      (
        .iclk    ( iclk               ) ,
        .ireset  ( 1'b0               ) , // don'n need because there is iclear used
        .iclkena ( iclkena            ) ,
        //
        .iclear  ( cnode_fifo__iclear ) ,
        //
        .iwrite  ( cnode_fifo__iwrite ) ,
        .iwdat   ( cnode_fifo__iwdat  ) ,
        //
        .iread   ( cnode_fifo__iread  ) ,
        .orval   ( cnode_fifo__orval  ) ,
        .ordat   ( cnode_fifo__ordat  ) ,
        //
        .oempty  ( cnode_fifo__oempty ) ,
        .ofull   ( cnode_fifo__ofull  ) ,
        .ohfull  (                    ) ,   // not used
        .ousedw  (                    )     // not used
      );
    end
  endgenerate

  assign cnode_fifo__iclear = istart;

  assign cnode_fifo__iwrite = ival;

  always_comb begin
    cnode_fifo__iwdat[cCNODE_FIFO_DAT_W-1 -: cNODE_TAG_W] = ivnode_ctx.paddr;
    //
    for (int i = 0; i < cZC_MAX; i++) begin
      cnode_fifo__iwdat[i*pNODE_W +: pNODE_W] = icnode[i];
    end
    //
    if (pUSE_SC_MODE) begin
      for (int i = 0; i < cZC_MAX; i++) begin
        cnode_fifo__iwdat[cZC_MAX*pNODE_W + i*cNODE_STATE_W +: cNODE_STATE_W] = ivnode_state[i];
      end
    end
  end

  //
  // only RAMB version use look ahead reading to get 2 cycle read latency
  //
  generate
    if (pUSE_SRL_FIFO) begin
      assign cnode_fifo__iread = ctrl__oread;
    end
    else begin
      assign cnode_fifo__iread = ctrl__oread | ctrl__irdy; // look ahead reading
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // vnode restore ctrl
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_node_restore_ctrl
  #(
    .pNUM_W ( cNODE_PER_COL_NUM_W )
  )
  ctrl
  (
    .iclk       ( iclk             ) ,
    .ireset     ( ireset           ) ,
    .iclkena    ( iclkena          ) ,
    //
    .irdy       ( ctrl__irdy       ) ,
    .inum_m1    ( ctrl__inum_m1    ) ,
    .oread      ( ctrl__oread      ) ,
    .orslt_read ( ctrl__orslt_read ) ,
    .oread_idx  (                  )
  );

  //
  // only RAMB version use look ahead reading to get 2 cycle read latency
  //
  generate
    if (pUSE_SRL_FIFO) begin
      assign ctrl__irdy    = sum__ovnode_pre_val    [0];
      assign ctrl__inum_m1 = sum__ovnode_pre_num_m1 [0];
    end
    else begin
      assign ctrl__irdy    = sum__ovnode_pre_val [0];
      assign ctrl__inum_m1 = sum__ovnode_num_m1  [0]; //use look ahead reading (-1):: see ldpc_dvb_dec_vnode_sum.ovnode_pre_num_m1 signal generation
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // vnode restore unit (2 tick delay)
  //------------------------------------------------------------------------------------------------------

  generate
    for (g = 0; g < cZC_MAX; g++) begin : vnode_restore_inst
      ldpc_dvb_dec_vnode_restore
      #(
        .pLLR_W       ( pLLR_W       ) ,
        .pNODE_W      ( pNODE_W      ) ,
        .pUSE_SC_MODE ( pUSE_SC_MODE )
      )
      restore
      (
        .iclk         ( iclk                      ) ,
        .ireset       ( ireset                    ) ,
        .iclkena      ( iclkena                   ) ,
        //
        .istate_init  ( restore__istate_init      ) ,
        //
        .ival         ( restore__ival         [g] ) ,
        .ivnode_addr  ( restore__ivnode_addr  [g] ) ,
        .ivnode_state ( restore__ivnode_state [g] ) ,
        .icnode       ( restore__icnode       [g] ) ,
        //
        .ivnode_sum   ( restore__ivnode_sum   [g] ) ,
        .ivnode_hd    ( restore__ivnode_hd    [g] ) ,
        //
        .ovnode_val   ( restore__ovnode_val   [g] ) ,
        .ovnode_addr  ( restore__ovnode_addr  [g] ) ,
        .ovnode       ( restore__ovnode       [g] ) ,
        .ovnode_hd    ( restore__ovnode_hd    [g] ) ,
        .ovnode_state ( restore__ovnode_state [g] )
      );

      //
      // only RAMB version use look ahead reading to get 2 cycle read latency
      //
      if (pUSE_SRL_FIFO) begin

        assign restore__ival [g] = cnode_fifo__orval ;

        always_ff @(posedge iclk) begin
          if (iclkena) begin
            // need hold decision for all cycle
            if (sum__ovnode_val [0]) begin
              restore__ivnode_sum [g] <= sum__ovnode_sum[g];
              restore__ivnode_hd  [g] <= sum__ovnode_hd [g];
            end
          end
        end
        //
        // srl fifo has 1 tick delay
        assign restore__ivnode_addr   [g] = cnode_fifo__ordat[cCNODE_FIFO_DAT_W-1 -: cNODE_TAG_W];
        assign restore__icnode        [g] = cnode_fifo__ordat[g*pNODE_W +: pNODE_W];

        if (pUSE_SC_MODE) begin
          assign restore__ivnode_state  [g] = cnode_fifo__ordat[cZC_MAX*pNODE_W + g*cNODE_STATE_W +: cNODE_STATE_W];
        end
        else begin
          assign restore__ivnode_state  [g] = '0;
        end

      end
      else begin

        always_ff @(posedge iclk) begin
          if (iclkena) begin
            restore__ival [g] <= cnode_fifo__orval;
            // need hold decision for all cycle
            if (sum__ovnode_val [0]) begin
              restore__ivnode_sum [g] <= sum__ovnode_sum[g];
              restore__ivnode_hd  [g] <= sum__ovnode_hd [g];
            end
            //
            // add + 1 tick delay to FIFO
            restore__ivnode_addr    [g] <= cnode_fifo__ordat[cCNODE_FIFO_DAT_W-1 -: cNODE_TAG_W];
            restore__icnode         [g] <= cnode_fifo__ordat[g*pNODE_W +: pNODE_W];
            if (pUSE_SC_MODE) begin
              restore__ivnode_state [g] <= cnode_fifo__ordat[cZC_MAX*pNODE_W + g*cNODE_STATE_W +: cNODE_STATE_W];
            end
            else begin
              restore__ivnode_state [g] <= '0;
            end
          end
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // init sc state at first iteration. Hold it in register
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (istart) begin
        restore__istate_init <= iload_iter;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ovnode_val   = restore__ovnode_val [0];
  assign ovnode_addr  = restore__ovnode_addr[0];
  assign ovnode       = restore__ovnode;
  assign ovnode_hd    = restore__ovnode_hd;
  assign ovnode_state = restore__ovnode_state;

  //------------------------------------------------------------------------------------------------------
  // obusy is look ahead signal for control
  // there is 4 tick betwen write/read to node ram this logic + matrix reorder save it for each iteration
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obusy <= 1'b0;
    end
    else if (iclkena) begin
      obusy <= !cnode_fifo__oempty; // fifo_empty use because there can be holes in oval flow (!!!)
    end
  end

  //------------------------------------------------------------------------------------------------------
  // bit interface output (register must be here)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obitval <= 1'b0;
    end
    else if (iclkena) begin
      obitval <= sum__obitval[0];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      obitsop   <= sum__obitsop[0];
      obiteop   <= sum__obiteop[0];
      //
      for (int i = 0; i < cZC_MAX; i++) begin
        obitdat[i] <= sum__obitdat[i];
        obiterr[i] <= sum__obiterr[i];
      end
      //
      obitaddr <= sum__obitaddr[0];
    end
  end

endmodule

