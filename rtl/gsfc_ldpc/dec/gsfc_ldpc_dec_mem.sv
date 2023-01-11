/*



  parameter int pCODE          = 8 ;
  parameter int pN             = 1 ;
  parameter int pLLR_W         = 1 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_W        = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;
  parameter int pTAG_W         = 1 ;
  parameter int pUSE_SC_MODE   = 0 ;



  logic                     gsfc_ldpc_dec_mem__iclk                                                 ;
  logic                     gsfc_ldpc_dec_mem__ireset                                               ;
  logic                     gsfc_ldpc_dec_mem__iclkena                                              ;
  logic      [pTAG_W-1 : 0] gsfc_ldpc_dec_mem__irtag                                                ;
  mem_addr_t                gsfc_ldpc_dec_mem__iraddr       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                gsfc_ldpc_dec_mem__irsela       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     gsfc_ldpc_dec_mem__irmask       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic      [pTAG_W-1 : 0] gsfc_ldpc_dec_mem__ortag                                                ;
  logic                     gsfc_ldpc_dec_mem__ormask       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_t                    gsfc_ldpc_dec_mem__ordat        [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t              gsfc_ldpc_dec_mem__orstate      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     gsfc_ldpc_dec_mem__iwrite                                               ;
  mem_addr_t                gsfc_ldpc_dec_mem__iwaddr       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                gsfc_ldpc_dec_mem__iwsela       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     gsfc_ldpc_dec_mem__iwmask       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_t                    gsfc_ldpc_dec_mem__iwdat        [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     gsfc_ldpc_dec_mem__iwrite_state                                         ;
  node_state_t              gsfc_ldpc_dec_mem__iwstate      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;



  gsfc_ldpc_dec_mem
  #(
    .pCODE          ( pCODE          ) ,
    .pN             ( pN             ) ,
    .pLLR_W         ( pLLR_W         ) ,
    .pLLR_BY_CYCLE  ( pLLR_BY_CYCLE  ) ,
    .pNODE_W        ( pNODE_W        ) ,
    .pNODE_BY_CYCLE ( pNODE_BY_CYCLE ) ,
    .pTAG_W         ( pTAG_W         ) ,
    .pUSE_SC_MODE   ( pUSE_SC_MODE   )
  )
  gsfc_ldpc_dec_mem
  (
    .iclk         ( gsfc_ldpc_dec_mem__iclk         ) ,
    .ireset       ( gsfc_ldpc_dec_mem__ireset       ) ,
    .iclkena      ( gsfc_ldpc_dec_mem__iclkena      ) ,
    .irtag        ( gsfc_ldpc_dec_mem__irtag        ) ,
    .iraddr       ( gsfc_ldpc_dec_mem__iraddr       ) ,
    .irsela       ( gsfc_ldpc_dec_mem__irsela       ) ,
    .irmask       ( gsfc_ldpc_dec_mem__irmask       ) ,
    .ortag        ( gsfc_ldpc_dec_mem__ortag        ) ,
    .ormask       ( gsfc_ldpc_dec_mem__ormask       ) ,
    .ordat        ( gsfc_ldpc_dec_mem__ordat        ) ,
    .orstate      ( gsfc_ldpc_dec_mem__orstate      ) ,
    .iwrite       ( gsfc_ldpc_dec_mem__iwrite       ) ,
    .iwaddr       ( gsfc_ldpc_dec_mem__iwaddr       ) ,
    .iwsela       ( gsfc_ldpc_dec_mem__iwsela       ) ,
    .iwmask       ( gsfc_ldpc_dec_mem__iwmask       ) ,
    .iwdat        ( gsfc_ldpc_dec_mem__iwdat        ) ,
    .iwrite_state ( gsfc_ldpc_dec_mem__iwrite_state ) ,
    .iwstate      ( gsfc_ldpc_dec_mem__iwstate      )
  );


  assign gsfc_ldpc_dec_mem__iclk    = '0 ;
  assign gsfc_ldpc_dec_mem__ireset  = '0 ;
  assign gsfc_ldpc_dec_mem__iclkena = '0 ;
  assign gsfc_ldpc_dec_mem__irtag   = '0 ;
  assign gsfc_ldpc_dec_mem__iraddr  = '0 ;
  assign gsfc_ldpc_dec_mem__irsela  = '0 ;
  assign gsfc_ldpc_dec_mem__irmask  = '0 ;
  assign gsfc_ldpc_dec_mem__iwrite  = '0 ;
  assign gsfc_ldpc_dec_mem__iwaddr  = '0 ;
  assign gsfc_ldpc_dec_mem__iwsela  = '0 ;
  assign gsfc_ldpc_dec_mem__iwmask  = '0 ;
  assign gsfc_ldpc_dec_mem__iwdat   = '0 ;



*/

//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_dec_mem.sv
// Description   : Special shift ram array for LDPC parallel decoding
//


module gsfc_ldpc_dec_mem
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  irtag        ,
  iraddr       ,
  irsela       ,
  irmask       ,
  ortag        ,
  ormask       ,
  ordat        ,
  orstate      ,
  //
  iwrite       ,
  iwaddr       ,
  iwsela       ,
  iwmask       ,
  iwdat        ,
  //
  iwrite_state ,
  iwstate
);

  parameter int pTAG_W = 2;

  `include "../gsfc_ldpc_parameters.svh"
  `include "gsfc_ldpc_dec_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                                                 ;
  input  logic                       ireset                                               ;
  input  logic                       iclkena                                              ;
  //
  input  logic        [pTAG_W-1 : 0] irtag                                                ;
  input  mem_addr_t                  iraddr       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  mem_sela_t                  irsela       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  logic                       irmask       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;  // reserved
  output logic        [pTAG_W-1 : 0] ortag                                                ;
  output logic                       ormask       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;  // reserved
  output node_t                      ordat        [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output node_state_t                orstate      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  input  logic                       iwrite                                               ;
  input  mem_addr_t                  iwaddr       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  mem_sela_t                  iwsela       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  logic                       iwmask       [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;  // reserved
  input  node_t                      iwdat        [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  input  logic                       iwrite_state                                         ;
  input  node_state_t                iwstate      [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

`ifdef MODEL_TECH
  bit   [pNODE_W-1 : 0] mem [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE][2**cADDR_W];
`endif

  logic                 write;
  mem_addr_t            waddr    [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];
  node_t                wdat     [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];

  logic  [pTAG_W-1 : 0] rtag_r1                                         ;
  mem_sela_t            rsela_r1 [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];
  logic                 rmask_r1 [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];

  mem_addr_t            raddr    [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];

  logic  [pTAG_W-1 : 0] rtag_r0                                         ;
  mem_sela_t            rsela_r0 [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];
  logic                 rmask_r0 [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];

  logic  [pTAG_W-1 : 0] rtag                                            ;
  mem_sela_t            rsela    [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];
  logic                 rmask    [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];
  node_t                rdat     [pC][pW][pLLR_BY_CYCLE][pNODE_BY_CYCLE];

  // state bits packed to "single" ram
  logic                                                                  write_state;
  mem_addr_t                                                             waddr_state;
  node_state_t [pC-1:0][pW-1 : 0][pLLR_BY_CYCLE-1:0][pNODE_BY_CYCLE-1:0] wstate;

  mem_addr_t                                                             raddr_state;
  node_state_t [pC-1:0][pW-1 : 0][pLLR_BY_CYCLE-1:0][pNODE_BY_CYCLE-1:0] rstate;

  //------------------------------------------------------------------------------------------------------
  // write muxed data : take 2 cycle
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    mem_sela_t tsela;
    //
    if (iclkena) begin
      write       <= iwrite;
      waddr       <= iwaddr;
      write_state <= (pUSE_SC_MODE & iwrite_state);
      waddr_state <= iwaddr[0][0][0][0];
      for (int c = 0; c < pC; c++) begin
        for (int w = 0; w < pW; w++) begin
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
              tsela = iwsela[c][w][llra][n];
              //
              wdat[c][w][llra][n] <= iwdat[c][w][tsela][n];
              //
              if (pUSE_SC_MODE) begin
                wstate[c][w][llra][n]  <= iwstate[c][w][llra][n];
              end // sc_mode
            end // n
          end // llra
        end // w
      end // c
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // read masked data : take 4 cycles
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    mem_sela_t tsela;
    //
    if (iclkena) begin
      // + 1
       rtag_r1    <= irtag;
      rsela_r1    <= irsela;
      rmask_r1    <= irmask;
      raddr       <= iraddr;
      raddr_state <= iraddr[0][0][0][0];
      // + 2 : read ram
       rtag_r0    <=  rtag_r1;
      rsela_r0    <= rsela_r1;
      rmask_r0    <= rmask_r1;
      // + 3 : read ram
      rtag        <=  rtag_r0;
      rsela       <= rsela_r0;
      rmask       <= rmask_r0;
      // + 4
      ortag       <= rtag;
      ormask      <= rmask;
      for (int c = 0; c < pC; c++) begin
        for (int w = 0; w < pW; w++) begin
          for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              tsela = rsela[c][w][llra][n];
              //
              ordat[c][w][llra][n] <= rdat[c][w][tsela][n];
              //
              if (pUSE_SC_MODE) begin
                orstate[c][w][llra][n] <= rstate[c][w][llra][n];
              end // sc
            end // llra
          end // n
        end // w
      end // c
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    genvar gc, gw, gllra, gn;
    for (gc = 0; gc < pC; gc++) begin : mem_c_inst
      for (gw = 0; gw < pW; gw++) begin : mem_w_inst
        for (gllra = 0; gllra < pLLR_BY_CYCLE; gllra++) begin : mem_llra_inst
          for (gn = 0; gn < pNODE_BY_CYCLE; gn++) begin : mem_n_inst
            codec_mem_block
            #(
              .pADDR_W ( cADDR_W ) ,
              .pDAT_W  ( pNODE_W ) ,
              .pPIPE   ( 1       )
            )
            memb
            (
              .iclk    ( iclk    ) ,
              .ireset  ( ireset  ) ,
              .iclkena ( iclkena ) ,
              //
              .iwrite  ( write                     ) ,
              .iwaddr  ( waddr [gc][gw][gllra][gn] ) ,
              .iwdat   ( wdat  [gc][gw][gllra][gn] ) ,
              //
              .iraddr  ( raddr [gc][gw][gllra][gn] ) ,
              .ordat   ( rdat  [gc][gw][gllra][gn] )
            );
            //
`ifdef MODEL_TECH
            assign mem[gc][gw][gllra][gn] = memb.mem;
`endif
          end // n
        end // llra
      end // w
    end // c
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // for vnode states can use single ram, because it use on vertical step with linear access (!!!)
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_SC_MODE) begin : state_mem

      codec_mem_block
      #(
        .pADDR_W ( cADDR_W                                                ) ,
        .pDAT_W  ( pW*pC*pLLR_BY_CYCLE*pNODE_BY_CYCLE*$bits(node_state_t) ) ,
        .pPIPE   ( 1                                                      )
      )
      mem
      (
        .iclk    ( iclk    ) ,
        .ireset  ( ireset  ) ,
        .iclkena ( iclkena ) ,
        //
        .iwrite  ( write_state ) ,
        .iwaddr  ( waddr_state ) ,
        .iwdat   ( wstate      ) ,
        //
        .iraddr  ( raddr_state ) ,
        .ordat   ( rstate      )
      );

    end
    else begin

      assign rstate = '0;

    end
  endgenerate

endmodule
