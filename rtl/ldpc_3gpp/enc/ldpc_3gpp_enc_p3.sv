/*



  parameter int pADDR_W        = 8 ;
  parameter int pDAT_W         = 8 ;
  //
  parameter bit pPIPE          = 0 ;
  parameter bit pUSE_VAR_DAT_W = 0 ;



  logic         ldpc_3gpp_enc_p3__iclk           ;
  logic         ldpc_3gpp_enc_p3__ireset         ;
  logic         ldpc_3gpp_enc_p3__iclkena        ;
  //
  hb_zc_t       ldpc_3gpp_enc_p3__iused_dat_w    ;
  hb_zc_t       ldpc_3gpp_enc_p3__iused_zc       ;
  //
  logic         ldpc_3gpp_enc_p3__iwrite4p2      ;
  logic         ldpc_3gpp_enc_p3__iwstart4p2     ;
  dat_t         ldpc_3gpp_enc_p3__iwdat4p2   [3] ;
  //
  logic         ldpc_3gpp_enc_p3__iread          ;
  logic         ldpc_3gpp_enc_p3__irstart        ;
  logic         ldpc_3gpp_enc_p3__irval          ;
  strb_t        ldpc_3gpp_enc_p3__irstrb         ;
  mm_hb_value_t ldpc_3gpp_enc_p3__irHb       [3] ;
  //
  dat_t         ldpc_3gpp_enc_p3__irdat4acu      ;
  dat_t         ldpc_3gpp_enc_p3__irdat4p1       ;
  //
  logic         ldpc_3gpp_enc_p3__oval           ;
  strb_t        ldpc_3gpp_enc_p3__ostrb          ;
  dat_t         ldpc_3gpp_enc_p3__odat           ;



  ldpc_3gpp_enc_p3
  #(
    .pADDR_W        ( pADDR_W        ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pPIPE          ( pPIPE          ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  ldpc_3gpp_enc_p3
  (
    .iclk        ( ldpc_3gpp_enc_p3__iclk        ) ,
    .ireset      ( ldpc_3gpp_enc_p3__ireset      ) ,
    .iclkena     ( ldpc_3gpp_enc_p3__iclkena     ) ,
    //
    .iused_dat_w ( ldpc_3gpp_enc_p3__iused_dat_w ) ,
    .iused_zc    ( ldpc_3gpp_enc_p3__iused_zc    ) ,
    //
    .iwrite4p2   ( ldpc_3gpp_enc_p3__iwrite4p2   ) ,
    .iwstart4p2  ( ldpc_3gpp_enc_p3__iwstart4p2  ) ,
    .iwdat4p2    ( ldpc_3gpp_enc_p3__iwdat4p2    ) ,
    //
    .iread       ( ldpc_3gpp_enc_p3__iread       ) ,
    .irstart     ( ldpc_3gpp_enc_p3__irstart     ) ,
    .irval       ( ldpc_3gpp_enc_p3__irval       ) ,
    .irstrb      ( ldpc_3gpp_enc_p3__irstrb      ) ,
    .irHb        ( ldpc_3gpp_enc_p3__irHb        ) ,
    //
    .irdat4acu   ( ldpc_3gpp_enc_p3__irdat4acu   ) ,
    .irdat4p1    ( ldpc_3gpp_enc_p3__irdat4p1    ) ,
    //
    .oval        ( ldpc_3gpp_enc_p3__oval        ) ,
    .ostrb       ( ldpc_3gpp_enc_p3__ostrb       ) ,
    .odat        ( ldpc_3gpp_enc_p3__odat        )
  );


  assign ldpc_3gpp_enc_p3__iclk        = '0 ;
  assign ldpc_3gpp_enc_p3__ireset      = '0 ;
  assign ldpc_3gpp_enc_p3__iclkena     = '0 ;
  //
  assign ldpc_3gpp_enc_p3__iused_dat_w = '0 ;
  assign ldpc_3gpp_enc_p3__iused_zc    = '0 ;
  //
  assign ldpc_3gpp_enc_p3__iwrite4p2   = '0 ;
  assign ldpc_3gpp_enc_p3__iwstart4p2  = '0 ;
  assign ldpc_3gpp_enc_p3__iwdat4p2    = '0 ;
  //
  assign ldpc_3gpp_enc_p3__iread       = '0 ;
  assign ldpc_3gpp_enc_p3__irstart     = '0 ;
  assign ldpc_3gpp_enc_p3__irval       = '0 ;
  assign ldpc_3gpp_enc_p3__irstrb      = '0 ;
  assign ldpc_3gpp_enc_p3__irHb        = '0 ;
  //
  assign ldpc_3gpp_enc_p3__irdat4acu   = '0 ;
  assign ldpc_3gpp_enc_p3__irdat4p1    = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_p3.sv
// Description   : parity matrix coding
//

module ldpc_3gpp_enc_p3
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  iused_dat_w ,
  iused_zc    ,
  //
  iwrite4p2   ,
  iwstart4p2  ,
  iwdat4p2    ,
  //
  iread       ,
  irstart     ,
  irval       ,
  irstrb      ,
  irHb        ,
  //
  irdat4acu   ,
  irdat4p1    ,
  //
  oval        ,
  ostrb       ,
  odat
);

  parameter int pADDR_W        = 8 ;
  parameter bit pPIPE          = 0 ; // use matrix multiply pipeline or not
  parameter bit pUSE_VAR_DAT_W = 0 ; // used dat bitwidth is fixed pDAT_W or variable

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk            ;
  input  logic          ireset          ;
  input  logic          iclkena         ;
  //
  input  hb_zc_t        iused_dat_w     ;
  input  hb_zc_t        iused_zc        ;  // used expansion factor
  // p2
  input  logic          iwrite4p2       ;
  input  logic          iwstart4p2      ;
  input  dat_t          iwdat4p2   [3]  ;
  //
  input  logic          iread           ;
  input  logic          irstart         ;
  input  logic          irval           ;
  input  strb_t         irstrb          ;
  input  mm_hb_value_t  irHb       [3]  ;
  // T*u
  input  dat_t          irdat4acu       ; // 1 tick offset
  // T*p1
  input  dat_t          irdat4p1        ;
  // to output buffer
  output logic          oval            ;
  output strb_t         ostrb           ;
  output dat_t          odat            ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // matrix multiply
  logic  mm__oval  [3] ;
  strb_t mm__ostrb [3] ;
  dat_t  mm__odat  [3] ;

  //------------------------------------------------------------------------------------------------------
  // T*p2
  //------------------------------------------------------------------------------------------------------

  genvar i;

  generate
    for (i = 0; i < 3; i++) begin : mm_inst
      if (pUSE_VAR_DAT_W) begin
        ldpc_3gpp_enc_mm_spram_var
        #(
          .pADDR_W  ( pADDR_W  ) ,
          .pDAT_W   ( pDAT_W   ) ,
          .pPIPE    ( pPIPE    )
        )
        mm
        (
          .iclk        ( iclk           ) ,
          .ireset      ( ireset         ) ,
          .iclkena     ( iclkena        ) ,
          //
          .iused_dat_w ( iused_dat_w    ) ,
          .iused_zc    ( iused_zc       ) ,
          //
          .iwrite      ( iwrite4p2      ) ,
          .iwstart     ( iwstart4p2     ) ,
          .iwdat       ( iwdat4p2   [i] ) ,
          //
          .iread       ( iread          ) ,
          .irstart     ( irstart        ) ,
          .irHb        ( irHb       [i] ) ,
          .irval       ( irval          ) ,
          .irstrb      ( irstrb         ) ,
          //
          .oval        ( mm__oval   [i] ) ,
          .ostrb       ( mm__ostrb  [i] ) ,
          .odat        ( mm__odat   [i] )
        );
      end
      else begin
        ldpc_3gpp_enc_mm_spram
        #(
          .pADDR_W  ( pADDR_W  ) ,
          .pDAT_W   ( pDAT_W   ) ,
          .pPIPE    ( pPIPE    )
        )
        mm
        (
          .iclk     ( iclk           ) ,
          .ireset   ( ireset         ) ,
          .iclkena  ( iclkena        ) ,
          //
          .iused_zc ( iused_zc       ) ,
          //
          .iwrite   ( iwrite4p2      ) ,
          .iwstart  ( iwstart4p2     ) ,
          .iwdat    ( iwdat4p2   [i] ) ,
          //
          .iread    ( iread          ) ,
          .irstart  ( irstart        ) ,
          .irHb     ( irHb       [i] ) ,
          .irval    ( irval          ) ,
          .irstrb   ( irstrb         ) ,
          //
          .oval     ( mm__oval   [i] ) ,
          .ostrb    ( mm__ostrb  [i] ) ,
          .odat     ( mm__odat   [i] )
        );
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // {p1, p2}*T
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] val;
  strb_t        strb [2];

  dat_t         sum_p1_p2;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | mm__oval[0];
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < $size(strb); i++) begin
        strb[i] <= (i == 0) ? mm__ostrb[0] : strb[i-1];
      end
      //
      sum_p1_p2 <= irdat4p1 ^ mm__odat[0] ^ mm__odat[1] ^ mm__odat[2];
      odat      <= irdat4acu ^ sum_p1_p2;
    end
  end

  assign oval   = val [1];
  assign ostrb  = strb[1];

endmodule
