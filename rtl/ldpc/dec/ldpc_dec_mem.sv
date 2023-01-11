/*



  parameter int pCODE          = 8 ;
  parameter int pN             = 1 ;
  parameter int pLLR_W         = 1 ;
  parameter int pLLR_BY_CYCLE  = 1 ;
  parameter int pNODE_W        = 1 ;
  parameter int pNODE_BY_CYCLE = 1 ;
  parameter int pTAG_W         = 1 ;
  parameter int pUSE_SC_MODE   = 0 ;



  logic                     ldpc_dec_mem__iclk                                              ;
  logic                     ldpc_dec_mem__ireset                                            ;
  logic                     ldpc_dec_mem__iclkena                                           ;
  logic      [pTAG_W-1 : 0] ldpc_dec_mem__irtag                                             ;
  mem_addr_t                ldpc_dec_mem__iraddr        [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                ldpc_dec_mem__irsela        [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     ldpc_dec_mem__irmask        [pC]               [pNODE_BY_CYCLE] ;
  logic      [pTAG_W-1 : 0] ldpc_dec_mem__ortag                                             ;
  logic                     ldpc_dec_mem__ormask        [pC]               [pNODE_BY_CYCLE] ;
  node_t                    ldpc_dec_mem__ordat         [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  node_state_t              ldpc_dec_mem__orstate       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     ldpc_dec_mem__iwrite                                            ;
  mem_addr_t                ldpc_dec_mem__iwaddr        [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  mem_sela_t                ldpc_dec_mem__iwsela        [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     ldpc_dec_mem__iwmask        [pC]               [pNODE_BY_CYCLE] ;
  node_t                    ldpc_dec_mem__iwdat         [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  logic                     ldpc_dec_mem__iwrite_state                                      ;
  node_state_t              ldpc_dec_mem__iwstate       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;



  ldpc_dec_mem
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
  ldpc_dec_mem
  (
    .iclk         ( ldpc_dec_mem__iclk         ) ,
    .ireset       ( ldpc_dec_mem__ireset       ) ,
    .iclkena      ( ldpc_dec_mem__iclkena      ) ,
    .irtag        ( ldpc_dec_mem__irtag        ) ,
    .iraddr       ( ldpc_dec_mem__iraddr       ) ,
    .irsela       ( ldpc_dec_mem__irsela       ) ,
    .irmask       ( ldpc_dec_mem__irmask       ) ,
    .ortag        ( ldpc_dec_mem__ortag        ) ,
    .ormask       ( ldpc_dec_mem__ormask       ) ,
    .ordat        ( ldpc_dec_mem__ordat        ) ,
    .orstate      ( ldpc_dec_mem__orstate      ) ,
    .iwrite       ( ldpc_dec_mem__iwrite       ) ,
    .iwaddr       ( ldpc_dec_mem__iwaddr       ) ,
    .iwsela       ( ldpc_dec_mem__iwsela       ) ,
    .iwmask       ( ldpc_dec_mem__iwmask       ) ,
    .iwdat        ( ldpc_dec_mem__iwdat        ) ,
    .iwrite_state ( ldpc_dec_mem__iwrite_state ) ,
    .iwstate      ( ldpc_dec_mem__iwstate      ) ,
  );


  assign ldpc_dec_mem__iclk    = '0 ;
  assign ldpc_dec_mem__ireset  = '0 ;
  assign ldpc_dec_mem__iclkena = '0 ;
  assign ldpc_dec_mem__irtag   = '0 ;
  assign ldpc_dec_mem__iraddr  = '0 ;
  assign ldpc_dec_mem__irsela  = '0 ;
  assign ldpc_dec_mem__irmask  = '0 ;
  assign ldpc_dec_mem__iwrite  = '0 ;
  assign ldpc_dec_mem__iwaddr  = '0 ;
  assign ldpc_dec_mem__iwsela  = '0 ;
  assign ldpc_dec_mem__iwmask  = '0 ;
  assign ldpc_dec_mem__iwdat   = '0 ;



*/

//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_mem.sv
// Description   : Special shift ram array for LDPC parallel decoding
//

`include "define.vh"

module ldpc_dec_mem
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

  `include "../ldpc_parameters.svh"
  `include "ldpc_dec_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                                             ;
  input  logic                       ireset                                           ;
  input  logic                       iclkena                                          ;
  //
  input  logic        [pTAG_W-1 : 0] irtag                                            ;
  input  mem_addr_t                  iraddr       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  mem_sela_t                  irsela       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  logic                       irmask       [pC]               [pNODE_BY_CYCLE] ;
  output logic        [pTAG_W-1 : 0] ortag                                            ;
  output logic                       ormask       [pC]               [pNODE_BY_CYCLE] ;
  output node_t                      ordat        [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  output node_state_t                orstate      [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  input  logic                       iwrite                                           ;
  input  mem_addr_t                  iwaddr       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  mem_sela_t                  iwsela       [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  input  logic                       iwmask       [pC]               [pNODE_BY_CYCLE] ;
  input  node_t                      iwdat        [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;
  //
  input  logic                       iwrite_state                                     ;
  input  node_state_t                iwstate      [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

`ifdef MODEL_TECH
  bit   [pNODE_W-1 : 0] mem [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE][2**cADDR_W];
`endif

  logic                 write;
  mem_addr_t            waddr    [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE];
  node_t                wdat     [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE];

  logic  [pTAG_W-1 : 0] rtag_r1                                       /* synthesis keep */;
  mem_sela_t            rsela_r1 [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  /* synthesis keep */;
  logic                 rmask_r1 [pC]               [pNODE_BY_CYCLE]  /* synthesis keep */;

  mem_addr_t            raddr    [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  /* synthesis keep */;

  logic  [pTAG_W-1 : 0] rtag_r0                                       /* synthesis keep */;
  mem_sela_t            rsela_r0 [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  /* synthesis keep */;
  logic                 rmask_r0 [pC]               [pNODE_BY_CYCLE]  /* synthesis keep */;

  logic  [pTAG_W-1 : 0] rtag                                          /* synthesis keep */;
  mem_sela_t            rsela    [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  /* synthesis keep */;
  logic                 rmask    [pC]               [pNODE_BY_CYCLE]  /* synthesis keep */;
  node_t                rdat     [pC][pLLR_BY_CYCLE][pNODE_BY_CYCLE]  /* synthesis keep */;

  // state bits packed to "single" ram
  logic                                                        write_state;
  mem_addr_t                                                   waddr_state /* synthesis keep */;
  node_state_t [pC-1:0][pLLR_BY_CYCLE-1:0][pNODE_BY_CYCLE-1:0] wstate;

  mem_addr_t                                                   raddr_state /* synthesis keep */;
  node_state_t [pC-1:0][pLLR_BY_CYCLE-1:0][pNODE_BY_CYCLE-1:0] rstate;

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
      waddr_state <= iwaddr[0][0][0];
      for (int c = 0; c < pC; c++) begin
        for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
          for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
            tsela = iwsela[c][llra][n];
            //
            wdat[c][llra][n] <= iwmask[c][n] ? {1'b1, {(pNODE_W-1){1'b0}}} : iwdat[c][tsela][n];
            //
            if (pUSE_SC_MODE) begin
              wstate[c][llra][n]  <= iwstate[c][llra][n];
            end
          end
        end
      end
    end
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
      raddr_state <= iraddr[0][0][0];
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
        for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            tsela = rsela[c][llra][n];
            //
            ordat[c][llra][n] <= rmask[c][n] ? '0 : rdat[c][tsela][n];
            //
            if (pUSE_SC_MODE) begin
              orstate[c][llra][n] <= rstate[c][llra][n];
            end
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  generate
    genvar gc, gllra, gn;
    for (gc = 0; gc < pC; gc++) begin : mem_c_inst
      if (cH_IS_EVEN & !pLLR_BY_CYCLE[0]) begin  // H matrix is even and pLLR_BY_CYCLE is even too
        for (gllra = 0; gllra < pLLR_BY_CYCLE/2; gllra++) begin : mem_llra_inst
          for (gn = 0; gn < pNODE_BY_CYCLE; gn++) begin : mem_n_inst
            codec_mem_block
            #(
              .pADDR_W (   cADDR_W ) ,
              .pDAT_W  ( 2*pNODE_W ) ,
              .pPIPE   ( 1         )
            )
            memb
            (
              .iclk    ( iclk    ) ,
              .ireset  ( ireset  ) ,
              .iclkena ( iclkena ) ,
              //
              .iwrite  ( write                                              ) ,
              .iwaddr  ( waddr [gc][2*gllra][gn]                            ) ,
              .iwdat   ( {wdat [gc][2*gllra+1][gn], wdat [gc][2*gllra][gn]} ) ,
              //
              .iraddr  ( raddr [gc][2*gllra][gn]                            ) ,
              .ordat   ( {rdat [gc][2*gllra+1][gn], rdat [gc][2*gllra][gn]} )
            );
            //
`ifdef MODEL_TECH
            always_comb begin
              for (int addr = 0; addr < 2**cADDR_W; addr++) begin
                {mem[gc][2*gllra+1][gn][addr], mem[gc][2*gllra][gn][addr]} = memb.mem[addr];
              end
            end
`endif
          end
        end
      end
      else begin
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
              .iwrite  ( write                 ) ,
              .iwaddr  ( waddr [gc][gllra][gn] ) ,
              .iwdat   ( wdat  [gc][gllra][gn] ) ,
              //
              .iraddr  ( raddr [gc][gllra][gn] ) ,
              .ordat   ( rdat  [gc][gllra][gn] )
            );
            //
`ifdef MODEL_TECH
            assign mem[gc][gllra][gn] = memb.mem;
`endif
          end
        end
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // for vnode states can use single ram, because it use on vertical step with linear access (!!!)
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_SC_MODE) begin : state_mem

      codec_mem_block
      #(
        .pADDR_W ( cADDR_W                                             ) ,
        .pDAT_W  ( pC*pLLR_BY_CYCLE*pNODE_BY_CYCLE*$bits(node_state_t) ) ,
        .pPIPE   ( 1                                                   )
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
  endgenerate

endmodule
