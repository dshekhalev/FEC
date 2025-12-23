/*



  parameter bit pIDX_GR       =  0 ;
  parameter bit pCODE         =  0 ;
  //
  parameter int pADDR_W       =  8 ;
  //
  parameter int pLLR_W        =  8 ;
  parameter int pNODE_W       =  8 ;
  //
  parameter int pLLR_BY_CYCLE =  1 ;
  parameter int pROW_BY_CYCLE =  8 ;
  //
  parameter bit pUSE_SC_MODE  =  1 ;



  logic         ldpc_3gpp_dec_mem__iclk                                                         ;
  logic         ldpc_3gpp_dec_mem__ireset                                                       ;
  logic         ldpc_3gpp_dec_mem__iclkena                                                      ;
  //
  hb_zc_t       ldpc_3gpp_dec_mem__iused_zc                                                     ;
  logic         ldpc_3gpp_dec_mem__ic_nv_mode                                                   ;
  //
  logic         ldpc_3gpp_dec_mem__iwrite                                                       ;
  mm_hb_value_t ldpc_3gpp_dec_mem__iwHb           [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  strb_t        ldpc_3gpp_dec_mem__iwstrb                                                       ;
  node_t        ldpc_3gpp_dec_mem__iwdat          [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t  ldpc_3gpp_dec_mem__iwstate        [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic         ldpc_3gpp_dec_mem__iread                                                        ;
  logic         ldpc_3gpp_dec_mem__irstart                                                      ;
  mm_hb_value_t ldpc_3gpp_dec_mem__irHb           [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  logic         ldpc_3gpp_dec_mem__irval                                                        ;
  strb_t        ldpc_3gpp_dec_mem__irstrb                                                       ;
  //
  logic         ldpc_3gpp_dec_mem__ocnode_rval                                                  ;
  strb_t        ldpc_3gpp_dec_mem__ocnode_rstrb                                                 ;
  logic         ldpc_3gpp_dec_mem__ocnode_rmask   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t        ldpc_3gpp_dec_mem__ocnode_rdat    [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t  ldpc_3gpp_dec_mem__ocnode_rstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic         ldpc_3gpp_dec_mem__ovnode_rval                                                  ;
  strb_t        ldpc_3gpp_dec_mem__ovnode_rstrb                                                 ;
  logic         ldpc_3gpp_dec_mem__ovnode_rmask   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t        ldpc_3gpp_dec_mem__ovnode_rdat    [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t  ldpc_3gpp_dec_mem__ovnode_rstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;



  ldpc_3gpp_dec_mem
  #(
    .pIDX_GR       ( pIDX_GR       ) ,
    .pCODE         ( pCODE         ) ,
    //
    .pADDR_W       ( pADDR_W       ) ,
    //
    .pLLR_W        ( pLLR_W        ) ,
    .pNODE_W       ( pNODE_W       ) ,
    //
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE ) ,
    //
    .pUSE_SC_MODE  ( pUSE_SC_MODE  )
  )
  ldpc_3gpp_dec_mem
  (
    .iclk          ( ldpc_3gpp_dec_mem__iclk          ) ,
    .ireset        ( ldpc_3gpp_dec_mem__ireset        ) ,
    .iclkena       ( ldpc_3gpp_dec_mem__iclkena       ) ,
    //
    .iused_zc      ( ldpc_3gpp_dec_mem__iused_zc      ) ,
    .ic_nv_mode    ( ldpc_3gpp_dec_mem__ic_nv_mode    ) ,
    //
    .iwrite        ( ldpc_3gpp_dec_mem__iwrite        ) ,
    .iwHb          ( ldpc_3gpp_dec_mem__iwHb          ) ,
    .iwstrb        ( ldpc_3gpp_dec_mem__iwstrb        ) ,
    .iwdat         ( ldpc_3gpp_dec_mem__iwdat         ) ,
    .iwstate       ( ldpc_3gpp_dec_mem__iwstate       ) ,
    //
    .iread         ( ldpc_3gpp_dec_mem__iread         ) ,
    .irstart       ( ldpc_3gpp_dec_mem__irstart       ) ,
    .irHb          ( ldpc_3gpp_dec_mem__irHb          ) ,
    .irval         ( ldpc_3gpp_dec_mem__irval         ) ,
    .irstrb        ( ldpc_3gpp_dec_mem__irstrb        ) ,
    //
    .ocnode_rval   ( ldpc_3gpp_dec_mem__ocnode_rval   ) ,
    .ocnode_rstrb  ( ldpc_3gpp_dec_mem__ocnode_rstrb  ) ,
    .ocnode_rmask  ( ldpc_3gpp_dec_mem__ocnode_rmask  ) ,
    .ocnode_rdat   ( ldpc_3gpp_dec_mem__ocnode_rdat   ) ,
    .ocnode_rstate ( ldpc_3gpp_dec_mem__ocnode_rstate ) ,
    //
    .ovnode_rval   ( ldpc_3gpp_dec_mem__ovnode_rval   ) ,
    .ovnode_rstrb  ( ldpc_3gpp_dec_mem__ovnode_rstrb  ) ,
    .ovnode_rmask  ( ldpc_3gpp_dec_mem__ovnode_rmask  ) ,
    .ovnode_rdat   ( ldpc_3gpp_dec_mem__ovnode_rdat   ) ,
    .ovnode_rstate ( ldpc_3gpp_dec_mem__ovnode_rstate )
  );


  assign ldpc_3gpp_dec_mem__iclk       = '0 ;
  assign ldpc_3gpp_dec_mem__ireset     = '0 ;
  assign ldpc_3gpp_dec_mem__iclkena    = '0 ;
  //
  assign ldpc_3gpp_dec_mem__iused_zc   = '0 ;
  assign ldpc_3gpp_dec_mem__ic_nv_mode = '0 ;
  //
  assign ldpc_3gpp_dec_mem__iwrite     = '0 ;
  assign ldpc_3gpp_dec_mem__iwHb       = '0 ;
  assign ldpc_3gpp_dec_mem__iwstrb     = '0 ;
  assign ldpc_3gpp_dec_mem__iwdat      = '0 ;
  assign ldpc_3gpp_dec_mem__iwstate    = '0 ;
  //
  assign ldpc_3gpp_dec_mem__iread      = '0 ;
  assign ldpc_3gpp_dec_mem__irstart    = '0 ;
  assign ldpc_3gpp_dec_mem__irHb       = '0 ;
  assign ldpc_3gpp_dec_mem__irval      = '0 ;
  assign ldpc_3gpp_dec_mem__irstrb     = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_mem.sv
// Description   : node multidimentsion mem top level
//

module ldpc_3gpp_dec_mem
(
  iclk             ,
  ireset           ,
  iclkena          ,
  //
  iused_zc         ,
  ic_nv_mode       ,
  //
  iwrite           ,
  iwHb             ,
  iwstrb           ,
  iwdat            ,
  iwstate          ,
  //
  iread            ,
  irstart          ,
  irHb             ,
  irval            ,
  irstrb           ,
  //
  ocnode_rval      ,
  ocnode_rstrb     ,
  ocnode_rmask     ,
  ocnode_rdat      ,
  ocnode_rstate    ,
  //
  ovnode_rval      ,
  ovnode_rstrb     ,
  ovnode_rmask     ,
  ovnode_rdat      ,
  ovnode_rstate
);

  `include "../ldpc_3gpp_constants.svh"
  `include "../ldpc_3gpp_hc.svh"

  `include "ldpc_3gpp_dec_types.svh"
  `include "ldpc_3gpp_dec_hc.svh"

  parameter int pADDR_W = cMEM_ADDR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk                                                         ;
  input  logic         ireset                                                       ;
  input  logic         iclkena                                                      ;
  //
  input  hb_zc_t       iused_zc                                                     ;
  input  logic         ic_nv_mode                                                   ;
  //
  input  logic         iwrite                                                       ;
  input  mm_hb_value_t iwHb           [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  input  strb_t        iwstrb                                                       ;
  input  node_t        iwdat          [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  input  node_state_t  iwstate        [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  input  logic         iread                                                        ;
  input  logic         irstart                                                      ;
  input  mm_hb_value_t irHb           [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  input  logic         irval                                                        ;
  input  strb_t        irstrb                                                       ;
  //
  output logic         ocnode_rval                                                  ;
  output strb_t        ocnode_rstrb                                                 ;
  output logic         ocnode_rmask   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  output node_t        ocnode_rdat    [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  output node_state_t  ocnode_rstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  output logic         ovnode_rval                                                  ;
  output strb_t        ovnode_rstrb                                                 ;
  output logic         ovnode_rmask   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  output node_t        ovnode_rdat    [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  output node_state_t  ovnode_rstate  [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         memb__ovnode_rval   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  strb_t        memb__ovnode_rstrb  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  logic         memb__ovnode_rmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t        memb__ovnode_rdat   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t  memb__ovnode_rstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;

  logic         memb__ocnode_rval   [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  strb_t        memb__ocnode_rstrb  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  logic         memb__ocnode_rmask  [pROW_BY_CYCLE][cCOL_BY_CYCLE]                ;
  node_t        memb__ocnode_rdat   [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;
  node_state_t  memb__ocnode_rstate [pROW_BY_CYCLE][cCOL_BY_CYCLE][pLLR_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // synthesis translate_off
  localparam int cMEM_DATA_W = pLLR_BY_CYCLE * (pUSE_SC_MODE ? (pNODE_W + cNODE_STATE_W) : pNODE_W);

  bit [cMEM_DATA_W-1 : 0] mem_mirrow [pROW_BY_CYCLE][cCOL_BY_CYCLE][2**pADDR_W];
  // synthesis translate_on

  //------------------------------------------------------------------------------------------------------
  // node ram
  //------------------------------------------------------------------------------------------------------

  genvar grow, gcol;

  generate
    for (grow = 0; grow < pROW_BY_CYCLE; grow++) begin : node_mem_row_inst
      for (gcol = 0; gcol < cCOL_BY_CYCLE; gcol++) begin : node_mem_col_inst
        if ((gcol < cGR_MAJOR_BIT_COL[pIDX_GR]) & !cHC_MASK[grow][gcol]) begin : inst
          if (pLLR_BY_CYCLE == 1) begin
            (* ram_style = "block" *) ldpc_3gpp_dec_mms_dpram
            #(
              .pADDR_W       ( pADDR_W      ) ,
              //
              .pLLR_W        ( pLLR_W       ) ,
              .pNODE_W       ( pNODE_W      ) ,
              //
              .pLLR_BY_CYCLE ( 1            ) ,
              //
              .pUSE_SC_MODE  ( pUSE_SC_MODE )
            )
            memb
            (
              .iclk          ( iclk                             ) ,
              .ireset        ( ireset                           ) ,
              .iclkena       ( iclkena                          ) ,
              //
              .iused_zc      ( iused_zc                         ) ,
              .ic_nv_mode    ( ic_nv_mode                       ) ,
              //
              .iwrite        ( iwrite                           ) ,
              .iwHb          ( iwHb                [grow][gcol] ) ,
              .iwstrb        ( iwstrb                           ) ,
              .iwdat         ( iwdat               [grow][gcol] ) ,
              .iwstate       ( iwstate             [grow][gcol] ) ,
              //
              .iread         ( iread                            ) ,
              .irstart       ( irstart                          ) ,
              .irHb          ( irHb                [grow][gcol] ) ,
              .irval         ( irval                            ) ,
              .irstrb        ( irstrb                           ) ,
              //
              .ocnode_rval   ( memb__ocnode_rval   [grow][gcol] ) ,
              .ocnode_rstrb  ( memb__ocnode_rstrb  [grow][gcol] ) ,
              .ocnode_rmask  ( memb__ocnode_rmask  [grow][gcol] ) ,
              .ocnode_rdat   ( memb__ocnode_rdat   [grow][gcol] ) ,
              .ocnode_rstate ( memb__ocnode_rstate [grow][gcol] ) ,
              //
              .ovnode_rval   ( memb__ovnode_rval   [grow][gcol] ) ,
              .ovnode_rstrb  ( memb__ovnode_rstrb  [grow][gcol] ) ,
              .ovnode_rmask  ( memb__ovnode_rmask  [grow][gcol] ) ,
              .ovnode_rdat   ( memb__ovnode_rdat   [grow][gcol] ) ,
              .ovnode_rstate ( memb__ovnode_rstate [grow][gcol] )
            );
            // synthesis translate_off
            assign mem_mirrow[grow][gcol] = memb.memb.mem;
            // synthesis translate_on
          end
          else begin
            (* ram_style = "block" *) ldpc_3gpp_dec_mm_dpram
            #(
              .pADDR_W       ( pADDR_W       ) ,
              //
              .pLLR_W        ( pLLR_W        ) ,
              .pNODE_W       ( pNODE_W       ) ,
              //
              .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
              //
              .pUSE_SC_MODE  ( pUSE_SC_MODE  )
            )
            memb
            (
              .iclk          ( iclk                             ) ,
              .ireset        ( ireset                           ) ,
              .iclkena       ( iclkena                          ) ,
              //
              .iused_zc      ( iused_zc                         ) ,
              .ic_nv_mode    ( ic_nv_mode                       ) ,
              //
              .iwrite        ( iwrite                           ) ,
              .iwHb          ( iwHb                [grow][gcol] ) ,
              .iwstrb        ( iwstrb                           ) ,
              .iwdat         ( iwdat               [grow][gcol] ) ,
              .iwstate       ( iwstate             [grow][gcol] ) ,
              //
              .iread         ( iread                            ) ,
              .irstart       ( irstart                          ) ,
              .irHb          ( irHb                [grow][gcol] ) ,
              .irval         ( irval                            ) ,
              .irstrb        ( irstrb                           ) ,
              //
              .ocnode_rval   ( memb__ocnode_rval   [grow][gcol] ) ,
              .ocnode_rstrb  ( memb__ocnode_rstrb  [grow][gcol] ) ,
              .ocnode_rmask  ( memb__ocnode_rmask  [grow][gcol] ) ,
              .ocnode_rdat   ( memb__ocnode_rdat   [grow][gcol] ) ,
              .ocnode_rstate ( memb__ocnode_rstate [grow][gcol] ) ,
              //
              .ovnode_rval   ( memb__ovnode_rval   [grow][gcol] ) ,
              .ovnode_rstrb  ( memb__ovnode_rstrb  [grow][gcol] ) ,
              .ovnode_rmask  ( memb__ovnode_rmask  [grow][gcol] ) ,
              .ovnode_rdat   ( memb__ovnode_rdat   [grow][gcol] ) ,
              .ovnode_rstate ( memb__ovnode_rstate [grow][gcol] )
            );
            // synthesis translate_off
            assign mem_mirrow[grow][gcol] = memb.memb.mem;
            // synthesis translate_on
          end
        end
        else begin
          assign memb__ovnode_rval    [grow][gcol] = 1'b0;
          assign memb__ovnode_rstrb   [grow][gcol] = '0;
          assign memb__ovnode_rmask   [grow][gcol] = 1'b1;
          assign memb__ovnode_rdat    [grow][gcol] = '{default : '0};
          assign memb__ovnode_rstate  [grow][gcol] = '{default : '0};
          //
          assign memb__ocnode_rval    [grow][gcol] = 1'b0;
          assign memb__ocnode_rstrb   [grow][gcol] = '0;
          assign memb__ocnode_rmask   [grow][gcol] = 1'b1;
          assign memb__ocnode_rdat    [grow][gcol] = '{default : '0};
          assign memb__ocnode_rstate  [grow][gcol] = '{default : '0};
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // ouput mapping
  //------------------------------------------------------------------------------------------------------

  // + 2 tick delay for pLLR_BY_CYCLE > 1 else same as ovnode
  assign ocnode_rval    = memb__ocnode_rval [0][0];
  assign ocnode_rstrb   = memb__ocnode_rstrb[0][0];
  assign ocnode_rmask   = memb__ocnode_rmask;
  assign ocnode_rdat    = memb__ocnode_rdat;
  assign ocnode_rstate  = memb__ocnode_rstate;

  assign ovnode_rval    = memb__ovnode_rval [0][0];
  assign ovnode_rstrb   = memb__ovnode_rstrb[0][0];
  assign ovnode_rmask   = memb__ovnode_rmask;
  assign ovnode_rdat    = memb__ovnode_rdat;
  assign ovnode_rstate  = memb__ovnode_rstate;

endmodule
