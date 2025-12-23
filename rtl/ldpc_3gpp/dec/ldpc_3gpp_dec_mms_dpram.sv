/*


  parameter int pADDR_W       = 8 ;
  //
  parameter int pLLR_W        = 8 ;
  parameter int pNODE_W       = 8 ;
  //
  parameter int pLLR_BY_CYCLE = 1 ;
  parameter bit pUSE_SC_MODE  = 1 ;



  logic         ldpc_3gpp_dec_mms_dpram__iclk                          ;
  logic         ldpc_3gpp_dec_mms_dpram__ireset                        ;
  logic         ldpc_3gpp_dec_mms_dpram__iclkena                       ;
  //
  hb_zc_t       ldpc_3gpp_dec_mms_dpram__iused_zc                      ;
  logic         ldpc_3gpp_dec_mms_dpram__ic_nv_mode                    ;
  //
  logic         ldpc_3gpp_dec_mms_dpram__iwrite                        ;
  mm_hb_value_t ldpc_3gpp_dec_mms_dpram__iwHb                          ;
  strb_t        ldpc_3gpp_dec_mms_dpram__iwstrb                        ;
  node_t        ldpc_3gpp_dec_mms_dpram__iwdat         [pLLR_BY_CYCLE] ;
  node_state_t  ldpc_3gpp_dec_mms_dpram__iwstate       [pLLR_BY_CYCLE] ;
  //
  logic         ldpc_3gpp_dec_mms_dpram__iread                         ;
  logic         ldpc_3gpp_dec_mms_dpram__irstart                       ;
  mm_hb_value_t ldpc_3gpp_dec_mms_dpram__irHb                          ;
  logic         ldpc_3gpp_dec_mms_dpram__irval                         ;
  strb_t        ldpc_3gpp_dec_mms_dpram__irstrb                        ;
  //
  logic         ldpc_3gpp_dec_mms_dpram__ocnode_rval                   ;
  strb_t        ldpc_3gpp_dec_mms_dpram__ocnode_rstrb                  ;
  logic         ldpc_3gpp_dec_mms_dpram__ocnode_rmask                  ;
  node_t        ldpc_3gpp_dec_mms_dpram__ocnode_rdat   [pLLR_BY_CYCLE] ;
  node_state_t  ldpc_3gpp_dec_mms_dpram__ocnode_rstate [pLLR_BY_CYCLE] ;
  //
  logic         ldpc_3gpp_dec_mms_dpram__ovnode_rval                   ;
  strb_t        ldpc_3gpp_dec_mms_dpram__ovnode_rstrb                  ;
  logic         ldpc_3gpp_dec_mms_dpram__ovnode_rmask                  ;
  node_t        ldpc_3gpp_dec_mms_dpram__ovnode_rdat   [pLLR_BY_CYCLE] ;
  node_state_t  ldpc_3gpp_dec_mms_dpram__ovnode_rstate [pLLR_BY_CYCLE] ;



  ldpc_3gpp_dec_mms_dpram
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
  ldpc_3gpp_dec_mms_dpram
  (
    .iclk          ( ldpc_3gpp_dec_mms_dpram__iclk          ) ,
    .ireset        ( ldpc_3gpp_dec_mms_dpram__ireset        ) ,
    .iclkena       ( ldpc_3gpp_dec_mms_dpram__iclkena       ) ,
    //
    .iused_zc      ( ldpc_3gpp_dec_mms_dpram__iused_zc      ) ,
    .ic_nv_mode    ( ldpc_3gpp_dec_mms_dpram__ic_nv_mode    ) ,
    //
    .iwrite        ( ldpc_3gpp_dec_mms_dpram__iwrite        ) ,
    .iwHb          ( ldpc_3gpp_dec_mms_dpram__iwHb          ) ,
    .iwstrb        ( ldpc_3gpp_dec_mms_dpram__iwstrb        ) ,
    .iwdat         ( ldpc_3gpp_dec_mms_dpram__iwdat         ) ,
    .iwstate       ( ldpc_3gpp_dec_mms_dpram__iwstate       ) ,
    //
    .iread         ( ldpc_3gpp_dec_mms_dpram__iread         ) ,
    .irstart       ( ldpc_3gpp_dec_mms_dpram__irstart       ) ,
    .irHb          ( ldpc_3gpp_dec_mms_dpram__irHb          ) ,
    .irval         ( ldpc_3gpp_dec_mms_dpram__irval         ) ,
    .irstrb        ( ldpc_3gpp_dec_mms_dpram__irstrb        ) ,
    //
    .ocnode_rval   ( ldpc_3gpp_dec_mms_dpram__ocnode_rval   ) ,
    .ocnode_rstrb  ( ldpc_3gpp_dec_mms_dpram__ocnode_rstrb  ) ,
    .ocnode_rmask  ( ldpc_3gpp_dec_mms_dpram__ocnode_rmask  ) ,
    .ocnode_rdat   ( ldpc_3gpp_dec_mms_dpram__ocnode_rdat   ) ,
    .ocnode_rstate ( ldpc_3gpp_dec_mms_dpram__ocnode_rstate ) ,
    //
    .ovnode_rval   ( ldpc_3gpp_dec_mms_dpram__ovnode_rval   ) ,
    .ovnode_rstrb  ( ldpc_3gpp_dec_mms_dpram__ovnode_rstrb  ) ,
    .ovnode_rmask  ( ldpc_3gpp_dec_mms_dpram__ovnode_rmask  ) ,
    .ovnode_rdat   ( ldpc_3gpp_dec_mms_dpram__ovnode_rdat   ) ,
    .ovnode_rstate ( ldpc_3gpp_dec_mms_dpram__ovnode_rstate )
  );


  assign ldpc_3gpp_dec_mms_dpram__iclk       = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__ireset     = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__iclkena    = '0 ;
  //
  assign ldpc_3gpp_dec_mms_dpram__iused_zc   = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__ic_nv_mode = '0 ;
  //
  assign ldpc_3gpp_dec_mms_dpram__iwrite     = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__iwHb       = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__iwstrb     = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__iwdat      = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__iwstate    = '0 ;
  //
  assign ldpc_3gpp_dec_mms_dpram__iread      = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__irstart    = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__irHb       = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__irval      = '0 ;
  assign ldpc_3gpp_dec_mms_dpram__irstrb     = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_mms_dpram.sv
// Description   : Simple matrix multiplier based upon dual port ram. shift left only. pLLR_BY_CYCLE = 1 only
//                 Ram write delay 3 tick (2 address generator + 1 ram).
//                 Ram read delay 4 tick (2 address generator + 2 ram)
//                 Ram write cycle == used_zc
//                 Ram read  cycle == used_zc
//

module ldpc_3gpp_dec_mms_dpram
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  iused_zc      ,
  ic_nv_mode    ,
  //
  iwrite        ,
  iwHb          ,
  iwstrb        ,
  iwdat         ,
  iwstate       ,
  //
  iread         ,
  irstart       ,
  irHb          ,
  irval         ,
  irstrb        ,
  //
  ocnode_rval   ,
  ocnode_rstrb  ,
  ocnode_rmask  ,
  ocnode_rdat   ,
  ocnode_rstate ,
  //
  ovnode_rval   ,
  ovnode_rstrb  ,
  ovnode_rmask  ,
  ovnode_rdat   ,
  ovnode_rstate
);

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  parameter int pADDR_W = cMEM_ADDR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk                           ;
  input  logic         ireset                         ;
  input  logic         iclkena                        ;
  //
  input  hb_zc_t       iused_zc                       ;
  input  logic         ic_nv_mode                     ;
  //
  input  logic         iwrite                         ;
  input  mm_hb_value_t iwHb                           ;
  input  strb_t        iwstrb                         ;
  input  node_t        iwdat          [pLLR_BY_CYCLE] ;
  input  node_state_t  iwstate        [pLLR_BY_CYCLE] ;
  //
  input  logic         iread                          ;
  input  logic         irstart                        ;
  input  mm_hb_value_t irHb                           ;
  input  logic         irval                          ;
  input  strb_t        irstrb                         ;
  //
  output logic         ocnode_rval                    ;
  output strb_t        ocnode_rstrb                   ;
  output logic         ocnode_rmask                   ;
  output node_t        ocnode_rdat    [pLLR_BY_CYCLE] ;
  output node_state_t  ocnode_rstate  [pLLR_BY_CYCLE] ;
  //
  output logic         ovnode_rval                    ;
  output strb_t        ovnode_rstrb                   ;
  output logic         ovnode_rmask                   ;
  output node_t        ovnode_rdat    [pLLR_BY_CYCLE] ;
  output node_state_t  ovnode_rstate  [pLLR_BY_CYCLE] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cMEM_DAT_W = pLLR_BY_CYCLE * (pUSE_SC_MODE ? (pNODE_W + cNODE_STATE_W) : pNODE_W);

  typedef logic    [pADDR_W-1 : 0] mem_addr_t;

  typedef struct packed {
    logic [pLLR_BY_CYCLE*cNODE_STATE_W-1 : 0] state;
    logic [pLLR_BY_CYCLE*pNODE_W-1       : 0] data;
  } mem_data_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         write;

  logic [3 : 0] rval;
  strb_t        rstrb [4]; // ram (2) + address (2)
  logic [3 : 0] rmask;

  hb_zc_t       used_zc;
  hb_zc_t       used_zc_m1;
  hb_zc_t       used_zc_m2;
  logic         used_zc_less2;

  mem_addr_t  row_raddr;
  mem_addr_t  row_waddr;

  struct packed {
    logic   done;
    hb_zc_t value;
  } zc_rcnt, zc_wcnt;

  node_t        wdat   [pLLR_BY_CYCLE] ;
  node_state_t  wstate [pLLR_BY_CYCLE] ;

  logic         memb__iwrite ;
  mem_addr_t    memb__iwaddr ;
  mem_data_t    memb__iwdat  ;

  mem_addr_t    memb__iraddr ;
  mem_data_t    memb__ordat  ;

  //------------------------------------------------------------------------------------------------------
  // write address
  //  cnode : zc  -> row (get full horizontal line in one row)
  //  vnode : row ->  zc (get full vertical   line in some rows)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      write <= 1'b0;
    end
    else if (iclkena) begin
      write <= iwrite & (ic_nv_mode ? !iwHb.is_masked : 1'b1);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // can do so, because iused_zc set at write phase
      used_zc       <= iused_zc;
      used_zc_m1    <= iused_zc-1;
      used_zc_m2    <= iused_zc-2;
      used_zc_less2 <= (iused_zc < 2);
      //
      wdat    <= iwdat;
      wstate  <= iwstate;
      //
      if (iwrite) begin
        if (ic_nv_mode) begin // cnode mode
          if (iwstrb.sof & iwstrb.sop) begin
            zc_wcnt.value <=  iwHb.wshift;
//          zc_wcnt.done  <= (iwHb.wshift == used_zc_m1);
            zc_wcnt.done  <=  iwHb.is_max;
            //
            row_waddr     <= '0;
          end
          else if (iwstrb.sop) begin
            zc_wcnt.value <=  iwHb.wshift;
//          zc_wcnt.done  <= (iwHb.wshift == used_zc_m1);
            zc_wcnt.done  <=  iwHb.is_max;
            //
            row_waddr     <= row_waddr + used_zc;
          end
          else begin
            zc_wcnt.value <= zc_wcnt.done  ? '0   : (zc_wcnt.value + 1'b1);
            zc_wcnt.done  <= used_zc_less2 ? 1'b1 : (zc_wcnt.value == used_zc_m2);
          end
        end
        else begin // vnode mode
          if (iwstrb.sof & iwstrb.sop) begin
            row_waddr     <= '0;
            zc_wcnt       <= '0;
          end
          else if (iwstrb.sop) begin
            row_waddr     <= '0;
            zc_wcnt.value <= zc_wcnt.value + 1'b1;
          end
          else begin
            row_waddr     <= row_waddr + used_zc;
          end
        end // ic_nv_mode
      end // iwrite
    end // iclkena
  end // iclk

  //------------------------------------------------------------------------------------------------------
  // read addres
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      rval  <= '0;
    end
    else if (iclkena) begin
      rval <= (rval << 1) | iread;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      rmask <= (rmask << 1) | irHb.is_masked;
      for (int i = 0; i < $size(rstrb); i++) begin
        rstrb[i] <= (i == 0) ? irstrb : rstrb[i-1];
      end
      //
      if (iread) begin
        if (ic_nv_mode) begin // cnode mode
          if (irstrb.sof & irstrb.sop) begin
            zc_rcnt.value <=  irHb.wshift;
//          zc_rcnt.done  <= (irHb.wshift == used_zc_m1);
            zc_rcnt.done  <=  irHb.is_max;
            //
            row_raddr     <= '0;
          end
          else if (irstrb.sop) begin
            zc_rcnt.value <=  irHb.wshift;
//          zc_rcnt.done  <= (irHb.wshift == used_zc_m1);
            zc_rcnt.done  <=  irHb.is_max;
            //
            row_raddr     <= row_raddr + used_zc;
          end
          else begin  // multi row pass
            zc_rcnt.value <= zc_rcnt.done  ? '0   : (zc_rcnt.value + 1'b1);
            zc_rcnt.done  <= used_zc_less2 ? 1'b1 : (zc_rcnt.value == used_zc_m2);
          end
        end
        else begin  // vnode mode
          if (irstrb.sof & irstrb.sop) begin
            row_raddr     <= '0;
            zc_rcnt       <= '0;
          end
          else if (irstrb.sop) begin
            row_raddr     <= '0;
            zc_rcnt.value <= zc_rcnt.value + 1'b1;
          end
          else begin
            row_raddr     <= row_raddr + used_zc;
          end
        end // ic_nv_mode
      end // iread
    end // iclkena
  end // iclk

  //------------------------------------------------------------------------------------------------------
  // ram itself
  //------------------------------------------------------------------------------------------------------

  mem_data_t memb__itwdat ;
  mem_data_t memb__otrdat ;

  codec_mem_block
  #(
    .pADDR_W ( pADDR_W    ) ,
    .pDAT_W  ( cMEM_DAT_W ) ,
    .pPIPE   ( 1          )
  )
  memb
  (
    .iclk    ( iclk                           ) ,
    .ireset  ( ireset                         ) ,
    .iclkena ( iclkena                        ) ,
    //
    .iwrite  ( memb__iwrite                   ) ,
    .iwaddr  ( memb__iwaddr                   ) ,
    .iwdat   ( memb__itwdat[cMEM_DAT_W-1 : 0] ) ,
    //
    .iraddr  ( memb__iraddr                   ) ,
    .ordat   ( memb__otrdat[cMEM_DAT_W-1 : 0] )
  );

  assign memb__itwdat.data  =                memb__iwdat.data;
  assign memb__itwdat.state = pUSE_SC_MODE ? memb__iwdat.state  : '0;

  assign memb__ordat.data   =                memb__otrdat.data;
  assign memb__ordat.state  = pUSE_SC_MODE ? memb__otrdat.state : '0;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      memb__iwrite <= write;
      memb__iwaddr <= row_waddr + zc_wcnt.value;
      memb__iraddr <= row_raddr + zc_rcnt.value;
      //
      for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
        memb__iwdat.data [llra*pNODE_W       +: pNODE_W]       <= wdat   [llra];
        memb__iwdat.state[llra*cNODE_STATE_W +: cNODE_STATE_W] <= wstate [llra];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping
  //------------------------------------------------------------------------------------------------------

  //
  // cnode
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ocnode_rval <= 1'b0;
    end
    else if (iclkena) begin
      ocnode_rval <= rval[2] &  ic_nv_mode; // 2 + 2 tick
    end
  end

//assign ocnode_rval  = rval [3] &  ic_nv_mode; // 2 + 2 tick
  assign ocnode_rstrb = rstrb[3];

  always_comb begin
    for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
      ocnode_rdat  [llra] = memb__ordat.data [llra*pNODE_W       +: pNODE_W];
      ocnode_rstate[llra] = memb__ordat.state[llra*cNODE_STATE_W +: cNODE_STATE_W];
    end
  end

  assign ocnode_rmask = rmask[3];

  //
  // vnode
  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      ovnode_rval <= 1'b0;
    end
    else if (iclkena) begin
      ovnode_rval <= rval[2] & !ic_nv_mode; // 2 + 2 tick
    end
  end

//assign ovnode_rval  = rval [3] & !ic_nv_mode; // 2 + 2 tick
  assign ovnode_rstrb = rstrb[3];

  always_comb begin
    for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
      ovnode_rdat  [llra] = memb__ordat.data [llra*pNODE_W       +: pNODE_W];
      ovnode_rstate[llra] = memb__ordat.state[llra*cNODE_STATE_W +: cNODE_STATE_W];
    end
  end

  assign ovnode_rmask = rmask[3];

endmodule
