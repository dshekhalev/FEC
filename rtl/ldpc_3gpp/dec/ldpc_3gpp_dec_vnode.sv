/*


  parameter bit pIDX_GR       =  0 ;
  parameter int pCODE         = 46 ;
  parameter bit pDO_PUNCT     =  0 ;
  //
  parameter int pLLR_W        =  4 ;
  parameter int pNODE_W       =  4 ;
  //
  parameter int pROW_BY_CYCLE =  8 ;
  parameter int pLLR_BY_CYCLE =  1 ;
  //
  parameter int pNORM_FACTOR  =  7 ;
  parameter bit pUSE_SC_MODE  =  1 ;




  logic                            ldpc_3gpp_dec_vnode__iclk                                                  ;
  logic                            ldpc_3gpp_dec_vnode__ireset                                                ;
  logic                            ldpc_3gpp_dec_vnode__iclkena                                               ;
  //
  logic                            ldpc_3gpp_dec_vnode__iidxGr                                                ;
  logic                            ldpc_3gpp_dec_vnode__ido_punct                                             ;
  hb_row_t                         ldpc_3gpp_dec_vnode__iused_row                                             ;
  //
  logic                            ldpc_3gpp_dec_vnode__iload_mode                                            ;
  logic                            ldpc_3gpp_dec_vnode__ibypass                                               ;
  //
  logic                            ldpc_3gpp_dec_vnode__ival                                                  ;
  strb_t                           ldpc_3gpp_dec_vnode__istrb                                                 ;
  llr_t                            ldpc_3gpp_dec_vnode__iLLR                   [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_t                           ldpc_3gpp_dec_vnode__icnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic                            ldpc_3gpp_dec_vnode__icmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_state_t                     ldpc_3gpp_dec_vnode__icstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic                            ldpc_3gpp_dec_vnode__oval                                                  ;
  strb_t                           ldpc_3gpp_dec_vnode__ostrb                                                 ;
  node_t                           ldpc_3gpp_dec_vnode__ovnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t                     ldpc_3gpp_dec_vnode__ovstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic                            ldpc_3gpp_dec_vnode__obitval                                               ;
  logic                            ldpc_3gpp_dec_vnode__obitsop                                               ;
  logic                            ldpc_3gpp_dec_vnode__obiteop                                               ;
  logic      [pLLR_BY_CYCLE-1 : 0] ldpc_3gpp_dec_vnode__obitdat                [cCOL_BY_CYCLE]                ;
  logic      [pLLR_BY_CYCLE-1 : 0] ldpc_3gpp_dec_vnode__obiterr                [cCOL_BY_CYCLE]                ;
  //
  logic                            ldpc_3gpp_dec_vnode__obusy                                                 ;



  ldpc_3gpp_dec_vnode
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pCODE         ( pCODE         ) ,
    .pDO_PUNCT     ( pDO_PUNCT     ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pNORM_FACTOR  ( pNORM_FACTOR  ) ,
    .pUSE_SC_MODE  ( pUSE_SC_MODE  ) ,
    .pUSE_DBYPASS  ( pUSE_DBYPASS  )
  )
  ldpc_3gpp_dec_vnode
  (
    .iclk       ( ldpc_3gpp_dec_vnode__iclk       ) ,
    .ireset     ( ldpc_3gpp_dec_vnode__ireset     ) ,
    .iclkena    ( ldpc_3gpp_dec_vnode__iclkena    ) ,
    //
    .iidxGr     ( ldpc_3gpp_dec_vnode__iidxGr     ) ,
    .ido_punct  ( ldpc_3gpp_dec_vnode__ido_punct  ) ,
    .iused_row  ( ldpc_3gpp_dec_vnode__iused_row  ) ,
    //
    .iload_mode ( ldpc_3gpp_dec_vnode__iload_mode ) ,
    .ibypass    ( ldpc_3gpp_dec_vnode__ibypass    ) ,
    //
    .ival       ( ldpc_3gpp_dec_vnode__ival       ) ,
    .istrb      ( ldpc_3gpp_dec_vnode__istrb      ) ,
    .iLLR       ( ldpc_3gpp_dec_vnode__iLLR       ) ,
    .icnode     ( ldpc_3gpp_dec_vnode__icnode     ) ,
    .icmask     ( ldpc_3gpp_dec_vnode__icmask     ) ,
    .icstate    ( ldpc_3gpp_dec_vnode__icstate    ) ,
    //
    .oval       ( ldpc_3gpp_dec_vnode__oval       ) ,
    .ostrb      ( ldpc_3gpp_dec_vnode__ostrb      ) ,
    .ovnode     ( ldpc_3gpp_dec_vnode__ovnode     ) ,
    .ovstate    ( ldpc_3gpp_dec_vnode__ovstate    ) ,
    //
    .obitsop    ( ldpc_3gpp_dec_vnode__obitsop    ) ,
    .obitval    ( ldpc_3gpp_dec_vnode__obitval    ) ,
    .obiteop    ( ldpc_3gpp_dec_vnode__obiteop    ) ,
    .obitdat    ( ldpc_3gpp_dec_vnode__obitdat    ) ,
    .obiterr    ( ldpc_3gpp_dec_vnode__obiterr    ) ,
    //
    .obusy      ( ldpc_3gpp_dec_vnode__obusy      )
  );


  assign ldpc_3gpp_dec_vnode__iclk       = '0 ;
  assign ldpc_3gpp_dec_vnode__ireset     = '0 ;
  assign ldpc_3gpp_dec_vnode__iclkena    = '0 ;
  //
  assign ldpc_3gpp_dec_vnode__iidxGr     = '0 ;
  assign ldpc_3gpp_dec_vnode__ido_punct  = '0 ;
  assign ldpc_3gpp_dec_vnode__iused_row  = '0 ;
  //
  assign ldpc_3gpp_dec_vnode__iload_mode = '0 ;
  assign ldpc_3gpp_dec_vnode__ibypass    = '0 ;
  //
  assign ldpc_3gpp_dec_vnode__ival       = '0 ;
  assign ldpc_3gpp_dec_vnode__istrb      = '0 ;
  assign ldpc_3gpp_dec_vnode__iLLR       = '0 ;
  assign ldpc_3gpp_dec_vnode__icnode     = '0 ;
  assign ldpc_3gpp_dec_vnode__icmask     = '0 ;
  assign ldpc_3gpp_dec_vnode__icstate    = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_vnode.sv
// Description   : LDPC decoder variable node arithmetic top module: read cnode and count vnode and output bits.
//                 Consist of pLLR_BY_CYCLE*cCOL_BY_CYCLE engines by pROW_BY_CYCLE nodes
//

module ldpc_3gpp_dec_vnode
(
  iclk       ,
  ireset     ,
  iclkena    ,
  //
  iidxGr     ,
  ido_punct  ,
  iused_row  ,
  //
  iload_mode ,
  ibypass    ,
  //
  ival       ,
  istrb      ,
  iLLR       ,
  icnode     ,
  icmask     ,
  icstate    ,
  //
  oval       ,
  ostrb      ,
  ovnode     ,
  ovstate    ,
  //
  obitval    ,
  obitsop    ,
  obiteop    ,
  obitdat    ,
  obiterr    ,
  //
  obusy
);

  parameter int pNORM_FACTOR  = 7;  // pNORM_FACTOR/8 - normalization factor

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                        iclk                                                  ;
  input  logic                        ireset                                                ;
  input  logic                        iclkena                                               ;
  //
  input  logic                        iidxGr                                                ;
  input  logic                        ido_punct                                             ;
  input  hb_row_t                     iused_row                                             ;
  //
  input  logic                        iload_mode                                            ; // upload vnode mem
  input  logic                        ibypass                                               ; // bypass at load to output mem
  // cycle work interface
  input  logic                        ival                                                  ;
  input  strb_t                       istrb                                                 ;
  input  llr_t                        iLLR                   [cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  input  node_t                       icnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  input  logic                        icmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  input  node_state_t                 icstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  // vnode interface
  output logic                        oval                                                  ;
  output strb_t                       ostrb                                                 ;
  output node_t                       ovnode  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  output node_state_t                 ovstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  output logic                        obitval                                               ;
  output logic                        obitsop                                               ;
  output logic                        obiteop                                               ;
  output logic  [pLLR_BY_CYCLE-1 : 0] obitdat                [cCOL_BY_CYCLE]                ;
  output logic  [pLLR_BY_CYCLE-1 : 0] obiterr                [cCOL_BY_CYCLE]                ;
  //
  output logic                        obusy                                                 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                          engine__ival                                                  ;
  strb_t                         engine__istrb                                                 ;
  llr_t                          engine__iLLR    [cCOL_BY_CYCLE][pLLR_BY_CYCLE]                ;
  node_t                         engine__icnode  [cCOL_BY_CYCLE][pLLR_BY_CYCLE][pROW_BY_CYCLE] ;
  logic                          engine__icmask  [cCOL_BY_CYCLE][pLLR_BY_CYCLE][pROW_BY_CYCLE] ;
  node_state_t                   engine__icstate [cCOL_BY_CYCLE][pLLR_BY_CYCLE][pROW_BY_CYCLE] ;

  logic                          engine__oval    [cCOL_BY_CYCLE][pLLR_BY_CYCLE]                ;
  strb_t                         engine__ostrb   [cCOL_BY_CYCLE][pLLR_BY_CYCLE]                ;
  node_t                         engine__ovnode  [cCOL_BY_CYCLE][pLLR_BY_CYCLE][pROW_BY_CYCLE] ;
  node_state_t                   engine__ovstate [cCOL_BY_CYCLE][pLLR_BY_CYCLE][pROW_BY_CYCLE] ;

  logic    [pLLR_BY_CYCLE-1 : 0] engine__obitsop [cCOL_BY_CYCLE]                               ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obitval [cCOL_BY_CYCLE]                               ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obiteop [cCOL_BY_CYCLE]                               ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obitdat [cCOL_BY_CYCLE]                               ;
  logic    [pLLR_BY_CYCLE-1 : 0] engine__obiterr [cCOL_BY_CYCLE]                               ;

  logic    [pLLR_BY_CYCLE-1 : 0] biterr  [cCOL_BY_CYCLE]  ;

  logic                          ubitsop                 ;
  logic                          ubitval                 ;
  logic                          ubiteop                 ;
  logic    [pLLR_BY_CYCLE-1 : 0] ubitdat [cCOL_BY_CYCLE] ;
  logic    [pLLR_BY_CYCLE-1 : 0] ubiterr [cCOL_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign engine__ival  = ival;
  assign engine__istrb = istrb;
  assign engine__iLLR  = iLLR;

  always_comb begin
    for (int col = 0; col < cCOL_BY_CYCLE; col++) begin
      for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
        for (int row = 0; row < pROW_BY_CYCLE; row++) begin
          engine__icnode  [col][llra][row] = icnode  [row][col][llra];
          engine__icmask  [col][llra][row] = icmask  [row][col];
          engine__icstate [col][llra][row] = icstate [row][col][llra];
        end // row
      end // llra
    end // col
  end

  genvar gcol, gllr;

  generate
    for (gcol = 0; gcol < cCOL_BY_CYCLE; gcol++) begin : v_engine_col_inst
      for (gllr = 0; gllr < pLLR_BY_CYCLE; gllr++) begin : v_engine_llr_inst
        if (gcol < cGR_MAJOR_BIT_COL[pIDX_GR]) begin
          ldpc_3gpp_dec_vnode_engine
          #(
            .pIDX_GR       ( pIDX_GR       ) ,
            .pCODE         ( pCODE         ) ,
            //
            .pLLR_W        ( pLLR_W        ) ,
            .pNODE_W       ( pNODE_W       ) ,
            .pNODE_SCALE_W ( pNODE_SCALE_W ) ,
            //
            .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
            //
            .pNORM_FACTOR  ( pNORM_FACTOR  ) ,
            .pUSE_SC_MODE  ( pUSE_SC_MODE  )
          )
          engine
          (
            .iclk      ( iclk                        ) ,
            .ireset    ( ireset                      ) ,
            .iclkena   ( iclkena                     ) ,
            //
            .iused_row ( iused_row                   ) ,
            //
            .ival      ( engine__ival                ) ,
            .istrb     ( engine__istrb               ) ,
            .iLLR      ( engine__iLLR    [gcol][gllr] ) ,
            .icnode    ( engine__icnode  [gcol][gllr] ) ,
            .icmask    ( engine__icmask  [gcol][gllr] ) ,
            .icstate   ( engine__icstate [gcol][gllr] ) ,
            //
            .oval      ( engine__oval    [gcol][gllr] ) ,
            .ostrb     ( engine__ostrb   [gcol][gllr] ) ,
            .ovnode    ( engine__ovnode  [gcol][gllr] ) ,
            .ovstate   ( engine__ovstate [gcol][gllr] ) ,
            //
            .obitsop   ( engine__obitsop [gcol][gllr] ) ,
            .obitval   ( engine__obitval [gcol][gllr] ) ,
            .obiteop   ( engine__obiteop [gcol][gllr] ) ,
            .obitdat   ( engine__obitdat [gcol][gllr] ) ,
            .obiterr   ( engine__obiterr [gcol][gllr] )
          );
        end
        else begin
          assign engine__oval    [gcol][gllr] = '0;
          assign engine__ostrb   [gcol][gllr] = '0;
          assign engine__ovnode  [gcol][gllr] = '{default : '0};
          assign engine__ovstate [gcol][gllr] = '{default : '0};

          assign engine__obitsop [gcol][gllr] = '0;
          assign engine__obitval [gcol][gllr] = '0;
          assign engine__obiteop [gcol][gllr] = '0;
          assign engine__obitdat [gcol][gllr] = '0;
          assign engine__obiterr [gcol][gllr] = '0;
        end
      end // gllr
    end // gcol
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // vnode interface
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
      oval <= iload_mode ? ival : used_val;
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
      ostrb <= iload_mode ? istrb : used_strb;
      //
      for (int row = 0; row < pROW_BY_CYCLE; row++) begin
        for (int col = 0; col < cCOL_BY_CYCLE; col++) begin
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            ovstate[row][col][llra].pre_sign  <= iload_mode ? 1'b0                                : engine__ovstate[col][llra][row].pre_sign;
            ovstate[row][col][llra].pre_zero  <= iload_mode ? 1'b1                                : engine__ovstate[col][llra][row].pre_zero;
            ovnode [row][col][llra]           <= iload_mode ? (iLLR[col][llra] <<< pNODE_SCALE_W) : engine__ovnode [col][llra][row];
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // bit interface
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ubitval <= 1'b0;
      //
      obitval <= 1'b0;
    end
    else if (iclkena) begin
      ubitval <= ival & istrb.eop;
      //
      obitval <= ibypass ? ubitval : engine__obitval[0][0];
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int col = 0; col < cCOL_BY_CYCLE; col++) begin
      if ((pDO_PUNCT | ido_punct) & (col < 2)) begin
        biterr[col] = '0;
      end
      else if (col >= cGR_MAJOR_BIT_COL[iidxGr]) begin
        biterr[col] = '0;
      end
      else begin
        biterr[col] = engine__obiterr[col];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  assign ubiterr = '{default : '0};

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // upload data at bypass
      ubitsop <= istrb.eop & istrb.sof;
      ubiteop <= istrb.eop & istrb.eof;
      for (int col = 0; col < cCOL_BY_CYCLE; col++) begin
        for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
          ubitdat[col][llra] <= (iLLR[col][llra] <= 0); // metric is inverted (minus zero occured) -> 0 metric is 1'b1
        end
      end
      // final sum
      obitsop <= ibypass ? ubitsop : engine__obitsop[0][0];
      obiteop <= ibypass ? ubiteop : engine__obiteop[0][0];
      obitdat <= ibypass ? ubitdat : engine__obitdat;
      obiterr <= ibypass ? ubiterr : biterr;
    end
  end

endmodule
