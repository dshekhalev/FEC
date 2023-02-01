/*



  parameter int pLLR_W        = 4 ;
  parameter int pNODE_W       = 8 ;
  parameter int pNORM_FACTOR  = 6 ;
  parameter bit pUSE_SRL_FIFO = 1 ;



  logic       ldpc_dvb_dec_cnode__iclk        ;
  logic       ldpc_dvb_dec_cnode__ireset      ;
  logic       ldpc_dvb_dec_cnode__iclkena     ;
  //
  logic       ldpc_dvb_dec_cnode__istart      ;
  logic       ldpc_dvb_dec_cnode__iload_iter  ;
  //
  logic       ldpc_dvb_dec_cnode__ival        ;
  strb_t      ldpc_dvb_dec_cnode__istrb       ;
  cnode_ctx_t ldpc_dvb_dec_cnode__icnode_ctx  ;
  zllr_t      ldpc_dvb_dec_cnode__iLLR        ;
  znode_t     ldpc_dvb_dec_cnode__ivnode      ;
  zdat_t      ldpc_dvb_dec_cnode__ivnode_hd   ;
  //
  logic       ldpc_dvb_dec_cnode__ocnode_val  ;
  cycle_idx_t ldpc_dvb_dec_cnode__ocnode_addr ;
  znode_t     ldpc_dvb_dec_cnode__ocnode      ;
  //
  logic       ldpc_dvb_dec_cnode__odecfail    ;
  logic       ldpc_dvb_dec_cnode__obusy       ;



  ldpc_dvb_dec_cnode
  #(
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    .pNORM_FACTOR  ( pNORM_FACTOR  ) ,
    .pUSE_SRL_FIFO ( pUSE_SRL_FIFO )
  )
  ldpc_dvb_dec_cnode
  (
    .iclk        ( ldpc_dvb_dec_cnode__iclk        ) ,
    .ireset      ( ldpc_dvb_dec_cnode__ireset      ) ,
    .iclkena     ( ldpc_dvb_dec_cnode__iclkena     ) ,
    //
    .istart      ( ldpc_dvb_dec_cnode__istart      ) ,
    .iload_iter  ( ldpc_dvb_dec_cnode__iload_iter  ) ,
    //
    .ival        ( ldpc_dvb_dec_cnode__ival        ) ,
    .istrb       ( ldpc_dvb_dec_cnode__istrb       ) ,
    .icnode_ctx  ( ldpc_dvb_dec_cnode__icnode_ctx  ) ,
    .iLLR        ( ldpc_dvb_dec_cnode__iLLR        ) ,
    .ivnode      ( ldpc_dvb_dec_cnode__ivnode      ) ,
    .ivnode_hd   ( ldpc_dvb_dec_cnode__ivnode_hd   ) ,
    //
    .ocnode_val  ( ldpc_dvb_dec_cnode__ocnode_val  ) ,
    .ocnode_addr ( ldpc_dvb_dec_cnode__ocnode_addr ) ,
    .ocnode      ( ldpc_dvb_dec_cnode__ocnode      ) ,
    //
    .odecfail    ( ldpc_dvb_dec_cnode__odecfail    ) ,
    .obusy       ( ldpc_dvb_dec_cnode__obusy       )
  );


  assign ldpc_dvb_dec_cnode__iclk       = '0 ;
  assign ldpc_dvb_dec_cnode__ireset     = '0 ;
  assign ldpc_dvb_dec_cnode__iclkena    = '0 ;
  assign ldpc_dvb_dec_cnode__istart     = '0 ;
  assign ldpc_dvb_dec_cnode__iload_iter = '0 ;
  assign ldpc_dvb_dec_cnode__ival       = '0 ;
  assign ldpc_dvb_dec_cnode__istrb      = '0 ;
  assign ldpc_dvb_dec_cnode__icnode_ctx = '0 ;
  assign ldpc_dvb_dec_cnode__iLLR       = '0 ;
  assign ldpc_dvb_dec_cnode__ivnode     = '0 ;
  assign ldpc_dvb_dec_cnode__ivnode_hd  = '0 ;



*/

//
// Project       : ldpc DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_vnode.sv
// Description   : Min-sum horizontal step top-module
//


module ldpc_dvb_dec_cnode
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  istart      ,
  iload_iter  ,
  //
  ival        ,
  istrb       ,
  icnode_ctx  ,
  iLLR        ,
  ivnode      ,
  ivnode_hd   ,
  //
  ocnode_val  ,
  ocnode_addr ,
  ocnode      ,
  //
  odecfail    ,
  obusy
);

  parameter int pNORM_FACTOR  = 7;
  parameter bit pUSE_SRL_FIFO = 1;  // use SRL based internal FIFO

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic       iclk        ;
  input  logic       ireset      ;
  input  logic       iclkena     ;
  //
  input  logic       istart      ;
  input  logic       iload_iter  ;
  //
  input  logic       ival        ;
  input  strb_t      istrb       ;
  input  cnode_ctx_t icnode_ctx  ;
  input  zllr_t      iLLR        ;
  input  znode_t     ivnode      ;
  input  zdat_t      ivnode_hd   ;
  //
  output logic       ocnode_val  ;
  output cycle_idx_t ocnode_addr ;
  output znode_t     ocnode      ;
  //
  output logic       odecfail    ;
  output logic       obusy       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam  [cLOG2_ZC_MAX-1 : 0] cBS_PIPE_LINE = 9'b1_0010_0100;   // 3 pipeline stage
  localparam                   int cBS_DELAY     = 3;                // barrel shifter delay

  localparam                   int cIBS_NODE_W   = pNODE_W + 1;     // + 1 for syndrome hd

  localparam int cNODE_TAG_W         = $bits(cnode_ctx_t);

  localparam int cVNODE_FIFO_DEPTH_W = cNODE_PER_ROW_NUM_W + 1; // +1 bit to compensate at high coderates
  localparam int cVNODE_FIFO_DAT_W   = cZC_MAX + cNODE_TAG_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // input barrel shifter
  logic                            ibs__ival            ;
  logic signed [cIBS_NODE_W-1 : 0] ibs__idat   [cZC_MAX];
  shift_t                          ibs__ishift          ;
  //
  logic                            ibs__oval            ;
  logic signed [cIBS_NODE_W-1 : 0] ibs__odat   [cZC_MAX];
  //
  // sort unit
  zdat_t                          sort__istart                       ;
  //
  zdat_t                          sort__ival                         ;
  strb_t                          sort__istrb               [cZC_MAX];
  node_t                          sort__ivnode              [cZC_MAX];
  zdat_t                          sort__ivmask                       ;
  //
  zdat_t                          sort__osort_val                    ;
  vn_min_t                        sort__osort_rslt          [cZC_MAX];
  vn_min_col_t                    sort__osort_num_m1        [cZC_MAX];
  //
  zdat_t                          sort__osort_b1_pre_val             ;
  vn_min_col_t                    sort__osort_b1_pre_num_m1 [cZC_MAX];
  //
  zdat_t                          sort__osort_b2_pre_val             ;
  vn_min_col_t                    sort__osort_b2_pre_num_m1 [cZC_MAX];
  //
  zdat_t                          sort__odecfail                     ;
  //
  // syndrome counter
  logic                           syndrome__istart    ;
  //
  logic                           syndrome__ival      ;
  strb_t                          syndrome__istrb     ;
  zdat_t                          syndrome__ivnode_hd ;
  //
  logic                           syndrome__oval      ;
  logic                           syndrome__odat      ;
  //
  // vnode contex fifo
  logic                           vnode_fifo__iclear  ;
  //
  logic                           vnode_fifo__iwrite  ;
  logic [cVNODE_FIFO_DAT_W-1 : 0] vnode_fifo__iwdat   ;
  //
  logic                           vnode_fifo__iread   ;
  logic                           vnode_fifo__orval   ;
  logic [cVNODE_FIFO_DAT_W-1 : 0] vnode_fifo__ordat   ;
  //
  logic                           vnode_fifo__oempty  ;
  logic                           vnode_fifo__ofull   ;
  //
  // restore ctrl
  logic                          ctrl__irdy       ;
  vn_min_col_t                   ctrl__inum_m1    ;
  logic                          ctrl__oread      ;
  logic                          ctrl__orslt_read ;
  vn_min_col_t                   ctrl__oread_idx  ;
  //
  // restore unit
  zdat_t                         restore__istart               ;
  //
  zdat_t                         restore__ival                 ;
  vn_min_col_t                   restore__ivnode_idx  [cZC_MAX];
  zdat_t                         restore__ivnode_sign          ;
  zdat_t                         restore__ivnode_mask          ;
  vn_min_t                       restore__ivn_min     [cZC_MAX];
  cnode_ctx_t                    restore__icnode_ctx  [cZC_MAX];
  //
  zdat_t                         restore__ocnode_val           ;
  cnode_ctx_t                    restore__ocnode_ctx  [cZC_MAX];
  znode_t                        restore__ocnode               ;
  //
  // output barrel shifter
  logic                          obs__ival    ;
  znode_t                        obs__idat    ;
  shift_t                        obs__ishift  ;
  //
  logic                          obs__oval    ;
  znode_t                        obs__odat    ;

  //------------------------------------------------------------------------------------------------------
  // input barrel shifter
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_barrel_shifter
  #(
    .pNODE_W    ( cIBS_NODE_W   ) ,
    .pR_SHIFT   ( 0             ) ,
    .pPIPE_LINE ( cBS_PIPE_LINE )
  )
  ibs
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .ival    ( ibs__ival    ) ,
    .idat    ( ibs__idat    ) ,
    .ishift  ( ibs__ishift  ) ,
    //
    .oval    ( ibs__oval    ) ,
    .odat    ( ibs__odat    )
  );

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ibs__ival   <= ival;
      ibs__ishift <= icnode_ctx.shift;
      for (int i = 0; i < cZC_MAX; i++) begin
        if (iload_iter) begin
          ibs__idat[i] <= iLLR[i]; // hd is signed extensions
        end
        else begin
          ibs__idat[i] <= {ivnode_hd[i], ivnode[i]};
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // align input bs delay
  //------------------------------------------------------------------------------------------------------

  strb_t      ibs_strb  [cBS_DELAY + 1];  // + 1 for input mux
  cnode_ctx_t ibs_ctx   [cBS_DELAY + 1];

  strb_t      used_ibs_strb;
  cnode_ctx_t used_ibs_ctx;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < $size(ibs_strb); i++) begin
        ibs_strb[i] <= (i == 0) ? istrb       : ibs_strb[i-1];
        ibs_ctx [i] <= (i == 0) ? icnode_ctx  : ibs_ctx [i-1];
      end
    end
  end

  assign used_ibs_strb = ibs_strb[cBS_DELAY];
  assign used_ibs_ctx  = ibs_ctx [cBS_DELAY];

  //------------------------------------------------------------------------------------------------------
  // sort engine
  //------------------------------------------------------------------------------------------------------

  genvar g;

  generate
    for (g = 0; g < cZC_MAX; g++) begin : sort_inst
      ldpc_dvb_dec_sort_engine
      #(
        .pLLR_W       ( pLLR_W       ) ,
        .pNODE_W      ( pNODE_W      ) ,
        .pNORM_FACTOR ( pNORM_FACTOR )
      )
      sort
      (
        .iclk                ( iclk                          ) ,
        .ireset              ( ireset                        ) ,
        .iclkena             ( iclkena                       ) ,
        //
        .istart              ( sort__istart              [g] ) ,
        //
        .ival                ( sort__ival                [g] ) ,
        .istrb               ( sort__istrb               [g] ) ,
        .ivnode              ( sort__ivnode              [g] ) ,
        .ivmask              ( sort__ivmask              [g] ) ,
        //
        .osort_val           ( sort__osort_val           [g] ) ,
        .osort_rslt          ( sort__osort_rslt          [g] ) ,
        .osort_num_m1        ( sort__osort_num_m1        [g] ) ,
        //
        .osort_b1_pre_val    ( sort__osort_b1_pre_val    [g] ) ,
        .osort_b1_pre_num_m1 ( sort__osort_b1_pre_num_m1 [g] ) ,
        //
        .osort_b2_pre_val    ( sort__osort_b2_pre_val    [g] ) ,
        .osort_b2_pre_num_m1 ( sort__osort_b2_pre_num_m1 [g] ) ,
        //
        .odecfail            ( sort__odecfail            [g] )
      );

      assign sort__istart [g] = istart;

      assign sort__ival   [g] = ibs__oval ;

      assign sort__istrb  [g] = used_ibs_strb ;

      assign sort__ivnode [g] = ibs__odat [g][pNODE_W-1 : 0];

      assign sort__ivmask [g] = (g == 0) & used_ibs_ctx.mask_0_bit;

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // syndrome check == decfail detection logic
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_syndrome_count
  syndrome
  (
    .iclk      ( iclk                ) ,
    .ireset    ( ireset              ) ,
    .iclkena   ( iclkena             ) ,
    //
    .istart    ( syndrome__istart    ) ,
    //
    .ival      ( syndrome__ival      ) ,
    .istrb     ( syndrome__istrb     ) ,
    .ivnode_hd ( syndrome__ivnode_hd ) ,
    //
    .oval      ( syndrome__oval      ) ,
    .odat      ( syndrome__odat      )
  );

  assign odecfail         = syndrome__odat;

  assign syndrome__istart = istart ;

  assign syndrome__ival   = ibs__oval ;
  assign syndrome__istrb  = used_ibs_strb ;

  always_comb begin
    for (int i = 0; i < cZC_MAX; i++) begin
      if (i == 0) begin
        syndrome__ivnode_hd[i] = used_ibs_ctx.mask_0_bit ? 1'b0 : ibs__odat[i][pNODE_W];
      end
      else begin
        syndrome__ivnode_hd[i] = ibs__odat[i][pNODE_W];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // vnode dynamic align line : save vnode sign and vnode context (1 tick delay)
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_SRL_FIFO) begin
      ldpc_dvb_dec_srl_fifo
      #(
        .pDEPTH_W ( cVNODE_FIFO_DEPTH_W ) ,
        .pDAT_W   ( cVNODE_FIFO_DAT_W   )
      )
      vnode_fifo
      (
        .iclk    ( iclk               ) ,
        .ireset  ( 1'b0               ) , // don'n need because there is iclear used
        .iclkena ( iclkena            ) ,
        //
        .iclear  ( vnode_fifo__iclear ) ,
        //
        .iwrite  ( vnode_fifo__iwrite ) ,
        .iwdat   ( vnode_fifo__iwdat  ) ,
        //
        .iread   ( vnode_fifo__iread  ) ,
        .orval   ( vnode_fifo__orval  ) ,
        .ordat   ( vnode_fifo__ordat  ) ,
        //
        .oempty  ( vnode_fifo__oempty ) ,
        .ofull   ( vnode_fifo__ofull  )
      );
    end
    else begin
      ldpc_dvb_dec_fifo
      #(
        .pDEPTH_W ( cVNODE_FIFO_DEPTH_W ) ,
        .pDAT_W   ( cVNODE_FIFO_DAT_W   )
      )
      vnode_fifo
      (
        .iclk    ( iclk               ) ,
        .ireset  ( 1'b0               ) , // don'n need because there is iclear used
        .iclkena ( iclkena            ) ,
        //
        .iclear  ( vnode_fifo__iclear ) ,
        //
        .iwrite  ( vnode_fifo__iwrite ) ,
        .iwdat   ( vnode_fifo__iwdat  ) ,
        //
        .iread   ( vnode_fifo__iread  ) ,
        .orval   ( vnode_fifo__orval  ) ,
        .ordat   ( vnode_fifo__ordat  ) ,
        //
        .oempty  ( vnode_fifo__oempty ) ,
        .ofull   ( vnode_fifo__ofull  )
      );
    end
  endgenerate

  assign vnode_fifo__iclear = istart;

  assign vnode_fifo__iwrite = ibs__oval;

  always_comb begin
    vnode_fifo__iwdat[cVNODE_FIFO_DAT_W-1 -: cNODE_TAG_W] = used_ibs_ctx;
    //
    for (int i = 0; i < cZC_MAX; i++) begin
      vnode_fifo__iwdat[i] = ibs__odat[i][pNODE_W-1]; // get sign only
    end
  end

  //
  // any FIFO version use look ahead reading but with different tick offset
  //
  assign vnode_fifo__iread = ctrl__oread | ctrl__irdy; // look ahead reading

  //------------------------------------------------------------------------------------------------------
  // cnode generator ctrl
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_node_restore_ctrl
  #(
    .pNUM_W ( cNODE_PER_ROW_NUM_W )
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
    .oread_idx  ( ctrl__oread_idx  )
  );

  //
  // RAMB fifo read 2 tick before result, SRL fifo read 1 tick before result
  //
  generate
    if (pUSE_SRL_FIFO) begin
      assign ctrl__irdy    = sort__osort_b1_pre_val    [0] ;
      assign ctrl__inum_m1 = sort__osort_b1_pre_num_m1 [0] - 1'b1; // do -1 offset because use look ahead reading
    end
    else begin
      assign ctrl__irdy    = sort__osort_b2_pre_val    [0] ;
      assign ctrl__inum_m1 = sort__osort_b2_pre_num_m1 [0] - 1'b1; // do -1 offset because use look ahead reading
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // cnode generator
  //------------------------------------------------------------------------------------------------------

  generate
    for (g = 0; g < cZC_MAX; g++) begin : restore_inst
      ldpc_dvb_dec_cnode_restore
      #(
        .pLLR_W        ( pLLR_W        ) ,
        .pNODE_W       ( pNODE_W       ) ,
        .pNORM_FACTOR  ( pNORM_FACTOR  )
      )
      restore
      (
        .iclk        ( iclk                 ) ,
        .ireset      ( ireset               ) ,
        .iclkena     ( iclkena              ) ,
        //
        .istart      ( restore__istart      [g] ) ,
        //
        .ival        ( restore__ival        [g] ) ,
        .ivnode_idx  ( restore__ivnode_idx  [g] ) ,
        .ivnode_sign ( restore__ivnode_sign [g] ) ,
        .ivnode_mask ( restore__ivnode_mask [g] ) ,
        .ivn_min     ( restore__ivn_min     [g] ) ,
        .icnode_ctx  ( restore__icnode_ctx  [g] ) ,
        //
        .ocnode_val  ( restore__ocnode_val  [g] ) ,
        .ocnode_ctx  ( restore__ocnode_ctx  [g] ) ,
        .ocnode      ( restore__ocnode      [g] )
      );

      assign restore__ivnode_mask [g] = (g == 0); // mask_0_bit is inside restore unit

      if (pUSE_SRL_FIFO) begin

        assign restore__ival        [g] = vnode_fifo__orval ;

        assign restore__ivnode_idx  [g] = ctrl__oread_idx ;

        assign restore__ivn_min     [g] = sort__osort_rslt[g]; // decision holded for all cycle

        //
        // srl fifo has 1 tick delay
        assign restore__icnode_ctx  [g] = vnode_fifo__ordat[cVNODE_FIFO_DAT_W-1 -: cNODE_TAG_W];
        assign restore__ivnode_sign [g] = vnode_fifo__ordat[g];

      end
      else begin

        always_ff @(posedge iclk) begin
          if (iclkena) begin
            restore__ival        [g] <= vnode_fifo__orval ;

            restore__ivnode_idx  [g] <= ctrl__oread_idx ;
          end
        end

        assign restore__ivn_min  [g] = sort__osort_rslt[g]; // decision holded for all cycle

        //
        // add + 1 tick delay to FIFO
        always_ff @(posedge iclk) begin
          if (iclkena) begin
            restore__icnode_ctx  [g] <= vnode_fifo__ordat[cVNODE_FIFO_DAT_W-1 -: cNODE_TAG_W];
            restore__ivnode_sign [g] <= vnode_fifo__ordat[g];
          end
        end

      end

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // output barrel shifter
  //------------------------------------------------------------------------------------------------------

  ldpc_dvb_dec_barrel_shifter
  #(
    .pNODE_W    ( pNODE_W       ) ,
    .pR_SHIFT   ( 1             ) ,
    .pPIPE_LINE ( cBS_PIPE_LINE )
  )
  obs
  (
    .iclk    ( iclk         ) ,
    .ireset  ( ireset       ) ,
    .iclkena ( iclkena      ) ,
    //
    .ival    ( obs__ival    ) ,
    .idat    ( obs__idat    ) ,
    .ishift  ( obs__ishift  ) ,
    //
    .oval    ( obs__oval    ) ,
    .odat    ( obs__odat    )
  );

  assign obs__ival   = restore__ocnode_val [0];
  assign obs__ishift = restore__ocnode_ctx [0].shift;
  assign obs__idat   = restore__ocnode;

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  assign ocnode_val = obs__oval;
  assign ocnode     = obs__odat;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ocnode_addr <= istart ? '0 : (ocnode_addr + ocnode_val);
    end
  end

  //------------------------------------------------------------------------------------------------------
  // obusy is look ahead signal for control
  //  there is 4 tick betwen write/read to node ram
  //  this logic save 2 tick for cBS_DELAY == 3 (!!!) for each iteration
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      obusy <= 1'b0;
    end
    else if (iclkena) begin
      obusy <= obs__ival | !vnode_fifo__oempty; // fifo_empty use because there can be holes in oval flow (!!!)
    end
  end

endmodule
