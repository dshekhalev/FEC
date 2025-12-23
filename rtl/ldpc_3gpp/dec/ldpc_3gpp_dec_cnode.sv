/*


  parameter int pCODE         = 46 ;
  //
  parameter int pLLR_W        =  4 ;
  parameter int pNODE_W       =  4 ;
  //
  parameter int pLLR_BY_CYCLE =  1 ;
  parameter int pROW_BY_CYCLE =  8 ;
  //
  parameter bit pNORM_FACTOR  =  7 ;


  logic        ldpc_3gpp_dec_cnode__iclk                                                   ;
  logic        ldpc_3gpp_dec_cnode__ireset                                                 ;
  logic        ldpc_3gpp_dec_cnode__iclkena                                                ;
  //
  logic        ldpc_3gpp_dec_cnode__istart                                                 ;
  logic        ldpc_3gpp_dec_cnode__iload_mode                                             ;
  //
  logic        ldpc_3gpp_dec_cnode__ival                                                   ;
  strb_t       ldpc_3gpp_dec_cnode__istrb                                                  ;
  logic        ldpc_3gpp_dec_cnode__ivmask   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t       ldpc_3gpp_dec_cnode__ivnode   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t ldpc_3gpp_dec_cnode__ivstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic        ldpc_3gpp_dec_cnode__ipmask   [pROW_BY_CYCLE]                               ;
  llr_t        ldpc_3gpp_dec_cnode__ipLLR    [pROW_BY_CYCLE]               [pLLR_BY_CYCLE] ;
  //
  logic        ldpc_3gpp_dec_cnode__oval                                                   ;
  strb_t       ldpc_3gpp_dec_cnode__ostrb                                                  ;
  node_t       ldpc_3gpp_dec_cnode__ocnode   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t ldpc_3gpp_dec_cnode__icstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic        ldpc_3gpp_dec_cnode__odecfail_val                                           ;
  logic        ldpc_3gpp_dec_cnode__odecfail_pre_val                                       ;
  logic        ldpc_3gpp_dec_cnode__odecfail                                               ;
  logic        ldpc_3gpp_dec_cnode__odecfail_est                                           ;
  //
  logic        ldpc_3gpp_dec_cnode__obusy                                                  ;



  ldpc_3gpp_dec_cnode
  #(
    .pCODE         ( pCODE         ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pNORM_FACTOR  ( pNORM_FACTOR  )
  )
  ldpc_3gpp_dec_cnode
  (
    .iclk             ( ldpc_3gpp_dec_cnode__iclk             ) ,
    .ireset           ( ldpc_3gpp_dec_cnode__ireset           ) ,
    .iclkena          ( ldpc_3gpp_dec_cnode__iclkena          ) ,
    //
    .istart           ( ldpc_3gpp_dec_cnode__istart           ) ,
    .iload_mode       ( ldpc_3gpp_dec_cnode__iload_mode       ) ,
    //
    .ival             ( ldpc_3gpp_dec_cnode__ival             ) ,
    .istrb            ( ldpc_3gpp_dec_cnode__istrb            ) ,
    .ivmask           ( ldpc_3gpp_dec_cnode__ivmask           ) ,
    .ivnode           ( ldpc_3gpp_dec_cnode__ivnode           ) ,
    .ivstate          ( ldpc_3gpp_dec_cnode__ivstate          ) ,
    .ipmask           ( ldpc_3gpp_dec_cnode__ipmask           ) ,
    .ipLLR            ( ldpc_3gpp_dec_cnode__ipLLR            ) ,
    //
    .oval             ( ldpc_3gpp_dec_cnode__oval             ) ,
    .ostrb            ( ldpc_3gpp_dec_cnode__ostrb            ) ,
    .ocnode           ( ldpc_3gpp_dec_cnode__ocnode           ) ,
    .ocstate          ( ldpc_3gpp_dec_cnode__ocstate          ) ,
    //
    .odecfail_val     ( ldpc_3gpp_dec_cnode__odecfail_val     ) ,
    .odecfail_pre_val ( ldpc_3gpp_dec_cnode__odecfail_pre_val ) ,
    .odecfail         ( ldpc_3gpp_dec_cnode__odecfail         ) ,
    .odecfail_est     ( ldpc_3gpp_dec_cnode__odecfail_est     ) ,
    //
    .obusy            ( ldpc_3gpp_dec_cnode__obusy            )
  );


  assign ldpc_3gpp_dec_cnode__iclk       = '0 ;
  assign ldpc_3gpp_dec_cnode__ireset     = '0 ;
  assign ldpc_3gpp_dec_cnode__iclkena    = '0 ;
  //
  assign ldpc_3gpp_dec_cnode__istart     = '0 ;
  assign ldpc_3gpp_dec_cnode__iload_mode = '0 ;
  //
  assign ldpc_3gpp_dec_cnode__ival       = '0 ;
  assign ldpc_3gpp_dec_cnode__istrb      = '0 ;
  assign ldpc_3gpp_dec_cnode__ivmask     = '0 ;
  assign ldpc_3gpp_dec_cnode__ivnode     = '0 ;
  assign ldpc_3gpp_dec_cnode__ivstate    = '0 ;
  assign ldpc_3gpp_dec_cnode__ipmask     = '0 ;
  assign ldpc_3gpp_dec_cnode__ipLLR      = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_cnode.sv
// Description   : LDPC decoder check node arithmetic top module: read vnode and count cnode.
//                 Consist of pROW_BY_CYCLE*pLLR_BY_CYCLE engines with cCOL_BY_CYCLE + 1 vnodes
//

module ldpc_3gpp_dec_cnode
(
  iclk             ,
  ireset           ,
  iclkena          ,
  //
  istart           ,
  iload_mode       ,
  //
  ival             ,
  istrb            ,
  ivmask           ,
  ivnode           ,
  ivstate          ,
  ipmask           ,
  ipLLR            ,
  //
  oval             ,
  ostrb            ,
  orow             ,
  ocnode           ,
  ocstate          ,
  //
  odecfail_val     ,
  odecfail_pre_val ,
  odecfail         ,
  odecfail_est     ,
  //
  obusy
);

  parameter int pNORM_FACTOR  = 7;  // pNORM_FACTOR/8 - normalization factor

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic        iclk                                                  ;
  input  logic        ireset                                                ;
  input  logic        iclkena                                               ;
  //
  input  logic        istart                                                ;
  input  logic        iload_mode                                            ;
  //
  input  logic        ival                                                  ;
  input  strb_t       istrb                                                 ;
  input  logic        ivmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  input  node_t       ivnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  input  node_state_t ivstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  input  logic        ipmask  [pROW_BY_CYCLE]                               ;
  input  llr_t        ipLLR   [pROW_BY_CYCLE]               [pLLR_BY_CYCLE] ;
  //
  output logic        oval                                                  ;
  output strb_t       ostrb                                                 ;
  output hb_row_t     orow                                                  ;
  output node_t       ocnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  output node_state_t ocstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  output logic        odecfail_val                                          ;
  output logic        odecfail_pre_val                                      ;
  output logic        odecfail                                              ;
  output logic        odecfail_est                                          ;
  //
  output logic        obusy                                                 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic        engine__ival                                                       ;
  strb_t       engine__istrb                                                      ;
  logic        engine__ivmask       [pROW_BY_CYCLE]               [cCOL_BY_CYCLE] ;
  node_t       engine__ivnode       [pROW_BY_CYCLE][pLLR_BY_CYCLE][cCOL_BY_CYCLE] ;
  node_state_t engine__ivstate      [pROW_BY_CYCLE][pLLR_BY_CYCLE][cCOL_BY_CYCLE] ;

  logic        engine__ipmask       [pROW_BY_CYCLE]                               ;
  node_t       engine__ipnode       [pROW_BY_CYCLE][pLLR_BY_CYCLE]                ;
  //
  logic        engine__oval         [pROW_BY_CYCLE][pLLR_BY_CYCLE]                ;
  strb_t       engine__ostrb        [pROW_BY_CYCLE][pLLR_BY_CYCLE]                ;
  node_t       engine__ocnode       [pROW_BY_CYCLE][pLLR_BY_CYCLE][cCOL_BY_CYCLE] ;
  node_state_t engine__ocstate      [pROW_BY_CYCLE][pLLR_BY_CYCLE][cCOL_BY_CYCLE] ;
  logic        engine__opmask       [pROW_BY_CYCLE][pLLR_BY_CYCLE]                ;
  logic        engine__orow_decfail [pROW_BY_CYCLE][pLLR_BY_CYCLE]                ;
  logic        engine__orow_minfail [pROW_BY_CYCLE][pLLR_BY_CYCLE]                ;

  // decfail estimator
  logic        decfail_cnt__ival                                        ;
  strb_t       decfail_cnt__istrb                                       ;
  logic        decfail_cnt__ipmask       [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic        decfail_cnt__irow_decfail [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic        decfail_cnt__irow_minfail [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign engine__ival  = ival;
  assign engine__istrb = istrb;

  always_comb begin
    for (int row = 0; row < pROW_BY_CYCLE; row++) begin
      engine__ipmask[row] = ipmask[row];
      for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
        engine__ipnode[row][llra] = (ipLLR[row][llra] <<< pNODE_SCALE_W);  // align fixed point
        for (int col = 0; col < cCOL_BY_CYCLE; col++) begin
          if (col < cGR_MAJOR_BIT_COL[pIDX_GR]) begin
            engine__ivmask  [row]      [col] = ivmask [row][col];
            engine__ivnode  [row][llra][col] = ivnode [row][col][llra];
            engine__ivstate [row][llra][col] = ivstate[row][col][llra];
          end
          else begin
            engine__ivmask  [row]      [col] = 1'b1;
            engine__ivnode  [row][llra][col] = '0;
            engine__ivstate [row][llra][col] = '0;
          end
        end // col
      end // llra
    end // row
  end

  genvar grow, gllr;

  generate
    for (grow = 0; grow < pROW_BY_CYCLE; grow++) begin : engine_inst_row_gen
      for (gllr = 0; gllr < pLLR_BY_CYCLE; gllr++) begin : engine_inst_llr_gen
        ldpc_3gpp_dec_cnode_p_engine
        #(
          .pLLR_W        ( pLLR_W        ) ,
          .pNODE_W       ( pNODE_W       ) ,
          .pNODE_SCALE_W ( pNODE_SCALE_W ) ,
          .pNORM_FACTOR  ( pNORM_FACTOR  )
        )
        engine
        (
          .iclk         ( iclk                             ) ,
          .ireset       ( ireset                           ) ,
          .iclkena      ( iclkena                          ) ,
          //
          .ival         ( engine__ival                     ) ,
          .istrb        ( engine__istrb                    ) ,
          .ivmask       ( engine__ivmask      [grow]       ) ,
          .ivnode       ( engine__ivnode      [grow][gllr] ) ,
          .ivstate      ( engine__ivstate     [grow][gllr] ) ,
          .ipmask       ( engine__ipmask      [grow]       ) ,
          .ipnode       ( engine__ipnode      [grow][gllr] ) ,
          //
          .oval         ( engine__oval        [grow][gllr] ) ,
          .ostrb        ( engine__ostrb       [grow][gllr] ) ,
          .ocnode       ( engine__ocnode      [grow][gllr] ) ,
          .ocstate      ( engine__ocstate     [grow][gllr] ) ,
          //
          .opmask       ( engine__opmask      [grow][gllr] ) ,
          .orow_decfail ( engine__orow_decfail[grow][gllr] ) ,
          .orow_minfail ( engine__orow_minfail[grow][gllr] )
        );
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic   used_val;
  strb_t  used_strb;

  assign used_val   = engine__oval [0][0];
  assign used_strb  = engine__ostrb[0][0];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval  <= 1'b0;
      obusy <= 1'b0;
    end
    else if (iclkena) begin
      oval <= used_val;
      //
      if (!obusy & ival & istrb.sof & istrb.sop) begin
        obusy <= 1'b1;
      end
      else if (oval & ostrb.eof & ostrb.eop) begin
        obusy <= 1'b0;
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostrb <= used_strb;
      //
      for (int row = 0; row < pROW_BY_CYCLE; row++) begin
        for (int col = 0; col < cCOL_BY_CYCLE; col++) begin
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            ocnode [row][col][llra] <= engine__ocnode [row][llra][col];
            ocstate[row][col][llra] <= engine__ocstate[row][llra][col];
          end
        end
      end
      //
      if (used_val & used_strb.sop) begin
        orow <= (used_strb.sof & used_strb.sop) ? '0 : (orow + 1'b1);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decfail estimator
  //------------------------------------------------------------------------------------------------------

  ldpc_3gpp_dec_decfail_cnt
  #(
    .pCODE         ( pCODE         ) ,
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE )
  )
  decfail_cnt
  (
    .iclk         ( iclk                      ) ,
    .ireset       ( ireset                    ) ,
    .iclkena      ( iclkena                   ) ,
    //
    .istart       ( istart                    ) ,
    .iload_mode   ( iload_mode                ) ,
    //
    .ival         ( decfail_cnt__ival         ) ,
    .istrb        ( decfail_cnt__istrb        ) ,
    .ipmask       ( decfail_cnt__ipmask       ) ,
    .irow_decfail ( decfail_cnt__irow_decfail ) ,
    .irow_minfail ( decfail_cnt__irow_minfail ) ,
    //
    .oval         ( odecfail_val              ) ,
    .opre_val     ( odecfail_pre_val          ) ,
    .odecfail     ( odecfail                  ) ,
    .odecfail_est ( odecfail_est              )
  );

  assign decfail_cnt__ival         = engine__oval  [0][0] ;
  assign decfail_cnt__istrb        = engine__ostrb [0][0] ;
  assign decfail_cnt__ipmask       = engine__opmask       ;
  assign decfail_cnt__irow_decfail = engine__orow_decfail ;
  assign decfail_cnt__irow_minfail = engine__orow_minfail ;

endmodule
