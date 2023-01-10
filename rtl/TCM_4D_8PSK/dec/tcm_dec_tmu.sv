/*


  parameter int pSYMB_M_W = 8;


  logic         tcm_dec_tmu__iclk              ;
  logic         tcm_dec_tmu__ireset            ;
  logic         tcm_dec_tmu__iclkena           ;
  logic [1 : 0] tcm_dec_tmu__icode             ;
  logic         tcm_dec_tmu__isop              ;
  logic         tcm_dec_tmu__ival              ;
  logic         tcm_dec_tmu__ieop              ;
  symb_m_t      tcm_dec_tmu__isymb_m       [4] ;
  symb_m_sign_t tcm_dec_tmu__isymb_m_sign  [4] ;
  logic         tcm_dec_tmu__osop              ;
  logic         tcm_dec_tmu__oval              ;
  logic         tcm_dec_tmu__oeop              ;
  bm_t          tcm_dec_tmu__obm               ;
  symb_m_idx_t  tcm_dec_tmu__osymb_m_idx  [16] ;
  symb_m_sign_t tcm_dec_tmu__osymb_m_sign  [4] ;
  symb_hd_t     tcm_dec_tmu__osymb_hd          ;



  tcm_dec_tmu
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  tcm_dec_tmu
  (
    .iclk         ( tcm_dec_tmu__iclk         ) ,
    .ireset       ( tcm_dec_tmu__ireset       ) ,
    .iclkena      ( tcm_dec_tmu__iclkena      ) ,
    .icode        ( tcm_dec_tmu__icode        ) ,
    .isop         ( tcm_dec_tmu__isop         ) ,
    .ival         ( tcm_dec_tmu__ival         ) ,
    .ieop         ( tcm_dec_tmu__ieop         ) ,
    .isymb_m      ( tcm_dec_tmu__isymb_m      ) ,
    .isymb_m_sign ( tcm_dec_tmu__isymb_m_sign ) ,
    .osop         ( tcm_dec_tmu__osop         ) ,
    .oval         ( tcm_dec_tmu__oval         ) ,
    .oeop         ( tcm_dec_tmu__oeop         ) ,
    .obm          ( tcm_dec_tmu__obm          ) ,
    .osymb_m_idx  ( tcm_dec_tmu__osymb_m_idx  ) ,
    .osymb_m_sign ( tcm_dec_tmu__osymb_m_sign ) ,
    .osymb_hd     ( tcm_dec_tmu__osymb_hd     )
  );


  assign tcm_dec_tmu__iclk         = '0 ;
  assign tcm_dec_tmu__ireset       = '0 ;
  assign tcm_dec_tmu__iclkena      = '0 ;
  assign tcm_dec_tmu__icode        = '0 ;
  assign tcm_dec_tmu__isop         = '0 ;
  assign tcm_dec_tmu__ival         = '0 ;
  assign tcm_dec_tmu__ieop         = '0 ;
  assign tcm_dec_tmu__isymb_m      = '0 ;
  assign tcm_dec_tmu__isymb_m_sign = '0 ;



*/

//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_dec_tmu.sv
// Description   : trellis metric unit add-compare-select unit for preliminary search of maxumum
//                  likehood 4D symbol inside each symbol group
//

`include "define.vh"

module tcm_dec_tmu
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  icode        ,
  //
  isop         ,
  ival         ,
  ieop         ,
  isymb_m      ,
  isymb_m_sign ,
  //
  osop         ,
  oval         ,
  oeop         ,
  //
  obm          ,
  //
  osymb_m_idx  ,
  osymb_m_sign ,
  osymb_hd
);

  `include "tcm_trellis.svh"
  `include "tcm_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk                ;
  input  logic            ireset              ;
  input  logic            iclkena             ;
  //
  input  logic    [1 : 0] icode               ;
  //
  input  logic            isop                ;
  input  logic            ival                ;
  input  logic            ieop                ;
  // 4D symbol
  input  symb_m_t         isymb_m       [4]   ; // symbol abs metric {Z0, Z1, Z2, Z3}
  input  symb_m_sign_t    isymb_m_sign  [4]   ; // signums
  //
  output logic            osop                ;
  output logic            oval                ;
  output logic            oeop                ;
  //
  output bm_t             obm                 ; // selected branch metric from 4D symbol for trellis
  //
  output symb_m_idx_t     osymb_m_idx   [16]  ; // index of selected per group 4D symbol for trellis
  output symb_m_sign_t    osymb_m_sign  [4]   ; // signums of 4D symbols
  output symb_hd_t        osymb_hd            ; // 4D symbol hard decision

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "tcm_symb_m_group_tab.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         bm_tree2__ival                 ;
  symb_m_t      bm_tree2__isymb_m     [16][2]  ;
  trel_bm_t     bm_tree2__obm         [16]     ;
  symb_m_idx_t  bm_tree2__osymb_m_idx [16]     ;

  logic         bm_tree4__ival                 ;
  symb_m_t      bm_tree4__isymb_m     [16][4]  ;
  trel_bm_t     bm_tree4__obm         [16]     ;
  symb_m_idx_t  bm_tree4__osymb_m_idx [16]     ;

  logic         bm_tree8__ival                 ;
  symb_m_t      bm_tree8__isymb_m     [16][8]  ;
  trel_bm_t     bm_tree8__obm         [16]     ;
  symb_m_idx_t  bm_tree8__osymb_m_idx [16]     ;

  logic         bm_tree__ival                  ;
  symb_m_t      bm_tree__isymb_m      [16][16] ;
  trel_bm_t     bm_tree__obm          [16]     ;
  symb_m_idx_t  bm_tree__osymb_m_idx  [16]     ;

  symb_hd_t     hd__ohd ;

  //------------------------------------------------------------------------------------------------------
  // split data to BM groups and sub-groups
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    bm_tree__ival  = ival;
    bm_tree8__ival = ival;
    bm_tree4__ival = ival;
    bm_tree2__ival = ival;
    for (int bm = 0; bm < 16; bm++) begin
      for (int z = 0; z < 4; z++) begin
        for (int idx = 0; idx < 16; idx++) begin
          bm_tree__isymb_m    [bm][idx][z] = isymb_m[z][cSM_IDX_275_TAB[bm][idx][z]];
          if (idx < 8)
            bm_tree8__isymb_m [bm][idx][z] = isymb_m[z][cSM_IDX_250_TAB[bm][idx][z]];
          if (idx < 4)
            bm_tree4__isymb_m [bm][idx][z] = isymb_m[z][cSM_IDX_225_TAB[bm][idx][z]];
          if (idx < 2)
            bm_tree2__isymb_m [bm][idx][z] = isymb_m[z][cSM_IDX_200_TAB[bm][idx][z]];
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // branch metric tree : 3/4 tick
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < 16; g++) begin : bm_tree_gen_inst
      tcm_dec_tmu_tree2
      #(
        .pSYMB_M_W ( pSYMB_M_W )
      )
      bm_tree2
      (
        .iclk        ( iclk                      ) ,
        .ireset      ( ireset                    ) ,
        .iclkena     ( iclkena                   ) ,
        //
        .ival        ( bm_tree2__ival            ) ,
        .isymb_m     ( bm_tree2__isymb_m     [g] ) ,
        //
        .oval        (                           ) ,
        .obm         ( bm_tree2__obm         [g] ) ,
        .osymb_m_idx ( bm_tree2__osymb_m_idx [g] )
      );

      tcm_dec_tmu_tree4
      #(
        .pSYMB_M_W ( pSYMB_M_W )
      )
      bm_tree4
      (
        .iclk        ( iclk                      ) ,
        .ireset      ( ireset                    ) ,
        .iclkena     ( iclkena                   ) ,
        //
        .ival        ( bm_tree4__ival            ) ,
        .isymb_m     ( bm_tree4__isymb_m     [g] ) ,
        //
        .oval        (                           ) ,
        .obm         ( bm_tree4__obm         [g] ) ,
        .osymb_m_idx ( bm_tree4__osymb_m_idx [g] )
      );

      tcm_dec_tmu_tree8
      #(
        .pSYMB_M_W ( pSYMB_M_W )
      )
      bm_tree8
      (
        .iclk        ( iclk                      ) ,
        .ireset      ( ireset                    ) ,
        .iclkena     ( iclkena                   ) ,
        //
        .ival        ( bm_tree8__ival            ) ,
        .isymb_m     ( bm_tree8__isymb_m     [g] ) ,
        //
        .oval        (                           ) ,
        .obm         ( bm_tree8__obm         [g] ) ,
        .osymb_m_idx ( bm_tree8__osymb_m_idx [g] )
      );

      tcm_dec_tmu_tree16
      #(
        .pSYMB_M_W ( pSYMB_M_W )
      )
      bm_tree
      (
        .iclk        ( iclk                     ) ,
        .ireset      ( ireset                   ) ,
        .iclkena     ( iclkena                  ) ,
        //
        .ival        ( bm_tree__ival            ) ,
        .isymb_m     ( bm_tree__isymb_m     [g] ) ,
        //
        .oval        (                          ) ,
        .obm         ( bm_tree__obm         [g] ) ,
        .osymb_m_idx ( bm_tree__osymb_m_idx [g] )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // 4D symbol hard decsion : 2 tick
  //------------------------------------------------------------------------------------------------------

  tcm_dec_tmu_hd
  #(
    .pSYMB_M_W ( pSYMB_M_W )
  )
  hd
  (
    .iclk    ( iclk     ) ,
    .ireset  ( ireset   ) ,
    .iclkena ( iclkena  ) ,
    //
    .ival    ( ival     ) ,
    .isymb_m ( isymb_m  ) ,
    //
    .oval    (          ) ,
    .ohd     ( hd__ohd  )
  );

  //------------------------------------------------------------------------------------------------------
  // assemble ouptus
  //------------------------------------------------------------------------------------------------------

  logic [3 : 0] val;
  logic [3 : 0] sop;
  logic [3 : 0] eop;
  symb_m_sign_t symb_m_sign[4][4];
  symb_hd_t     symb_hd    [2:3];

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val   <= '0;
      oval  <= 1'b0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
      case (icode)
        2'h0,2'h1 : oval <= val[2];
        2'h2,2'h3 : oval <= val[3];
      endcase
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | (isop & ival);
      eop <= (eop << 1) | (ieop & ival);
      //
      for (int i = 0; i < 4; i++) begin
        symb_m_sign[i] <= (i == 0) ? isymb_m_sign : symb_m_sign[i-1];
      end
      symb_hd[2] <= hd__ohd;
      symb_hd[3] <= symb_hd[2];
      //
      case (icode)
        2'h0,2'h1 : begin
          if (val[2]) begin
            obm          <= (icode == 0) ? bm_tree2__obm          : bm_tree4__obm;
            osymb_m_idx  <= (icode == 0) ? bm_tree2__osymb_m_idx  : bm_tree4__osymb_m_idx;
            //
            osop         <= sop[2];
            oeop         <= eop[2];
            osymb_m_sign <= symb_m_sign[2];
            osymb_hd     <= symb_hd[2];
          end
        end
        2'h2,2'h3 : begin
          if (val[3]) begin
            obm          <= (icode == 2) ? bm_tree8__obm          : bm_tree__obm         ;
            osymb_m_idx  <= (icode == 2) ? bm_tree8__osymb_m_idx  : bm_tree__osymb_m_idx ;
            //
            osop         <= sop[3];
            oeop         <= eop[3];
            osymb_m_sign <= symb_m_sign[3];
            osymb_hd     <= symb_hd[3];
          end
        end
      endcase
    end
  end

endmodule
