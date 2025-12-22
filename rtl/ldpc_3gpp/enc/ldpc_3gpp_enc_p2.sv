/*



  parameter int pADDR_W        = 8 ;
  parameter int pDAT_W         = 8 ;
  //
  parameter bit pPIPE          = 0 ;
  parameter bit pUSE_VAR_DAT_W = 0 ;



  logic         ldpc_3gpp_enc_p2__iclk              ;
  logic         ldpc_3gpp_enc_p2__ireset            ;
  logic         ldpc_3gpp_enc_p2__iclkena           ;
  //
  hb_zc_t       ldpc_3gpp_enc_p2__iused_zc          ;
  //
  logic         ldpc_3gpp_enc_p2__iwrite4au         ;
  logic         ldpc_3gpp_enc_p2__iwstart4au        ;
  dat_t         ldpc_3gpp_enc_p2__iwdat4au      [3] ;
  //
  logic         ldpc_3gpp_enc_p2__iwrite4p1         ;
  logic         ldpc_3gpp_enc_p2__iwstart4p1        ;
  dat_t         ldpc_3gpp_enc_p2__iwdat4p1          ;
  //
  logic         ldpc_3gpp_enc_p2__iread             ;
  logic         ldpc_3gpp_enc_p2__irstart           ;
  logic         ldpc_3gpp_enc_p2__irval             ;
  strb_t        ldpc_3gpp_enc_p2__irstrb            ;
  hb_row_t      ldpc_3gpp_enc_p2__irrow             ;
  mm_hb_value_t ldpc_3gpp_enc_p2__irHb          [3] ;
  //
  logic         ldpc_3gpp_enc_p2__oval              ;
  strb_t        ldpc_3gpp_enc_p2__ostrb             ;
  dat_t         ldpc_3gpp_enc_p2__odat              ;
  //
  dat_t         ldpc_3gpp_enc_p2__ordat2au          ;
  //
  logic         ldpc_3gpp_enc_p2__owrite2p3_p1      ;
  logic         ldpc_3gpp_enc_p2__owstart2p3_p1     ;
  dat_t         ldpc_3gpp_enc_p2__owdat2p3_p1       ;
  //
  logic         ldpc_3gpp_enc_p2__owrite2p3_p2      ;
  logic         ldpc_3gpp_enc_p2__owstart2p3_p2     ;
  dat_t         ldpc_3gpp_enc_p2__owdat2p3_p2   [3] ;



  ldpc_3gpp_enc_p2
  #(
    .pADDR_W        ( pADDR_W        ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pPIPE          ( pPIPE          ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  ldpc_3gpp_enc_p2
  (
    .iclk          ( ldpc_3gpp_enc_p2__iclk          ) ,
    .ireset        ( ldpc_3gpp_enc_p2__ireset        ) ,
    .iclkena       ( ldpc_3gpp_enc_p2__iclkena       ) ,
    //
    .iused_dat_w   ( ldpc_3gpp_enc_p2__iused_dat_w   ) ,
    .iused_zc      ( ldpc_3gpp_enc_p2__iused_zc      ) ,
    //
    .iwrite4au     ( ldpc_3gpp_enc_p2__iwrite4au     ) ,
    .iwstart4au    ( ldpc_3gpp_enc_p2__iwstart4au    ) ,
    .iwdat4au      ( ldpc_3gpp_enc_p2__iwdat4au      ) ,
    //
    .iwrite4p1     ( ldpc_3gpp_enc_p2__iwrite4p1     ) ,
    .iwstart4p1    ( ldpc_3gpp_enc_p2__iwstart4p1    ) ,
    .iwdat4p1      ( ldpc_3gpp_enc_p2__iwdat4p1      ) ,
    //
    .iread         ( ldpc_3gpp_enc_p2__iread         ) ,
    .irstart       ( ldpc_3gpp_enc_p2__irstart       ) ,
    .irval         ( ldpc_3gpp_enc_p2__irval         ) ,
    .irstrb        ( ldpc_3gpp_enc_p2__irstrb        ) ,
    .irrow         ( ldpc_3gpp_enc_p2__irrow         ) ,
    .irHb          ( ldpc_3gpp_enc_p2__irHb          ) ,
    //
    .oval          ( ldpc_3gpp_enc_p2__oval          ) ,
    .ostrb         ( ldpc_3gpp_enc_p2__ostrb         ) ,
    .odat          ( ldpc_3gpp_enc_p2__odat          ) ,
    //
    .ordat2au      ( ldpc_3gpp_enc_p2__ordat2au      ) ,
    //
    .owrite2p3_p1  ( ldpc_3gpp_enc_p2__owrite2p3_p1  ) ,
    .owstart2p3_p1 ( ldpc_3gpp_enc_p2__owstart2p3_p1 ) ,
    .owdat2p3_p1   ( ldpc_3gpp_enc_p2__owdat2p3_p1   ) ,
    //
    .owrite2p3_p2  ( ldpc_3gpp_enc_p2__owrite2p3_p2  ) ,
    .owstart2p3_p2 ( ldpc_3gpp_enc_p2__owstart2p3_p2 ) ,
    .owdat2p3_p2   ( ldpc_3gpp_enc_p2__owdat2p3_p2   )
  );


  assign ldpc_3gpp_enc_p2__iclk        = '0 ;
  assign ldpc_3gpp_enc_p2__ireset      = '0 ;
  assign ldpc_3gpp_enc_p2__iclkena     = '0 ;
  //
  assign ldpc_3gpp_enc_p2__iused_dat_w = '0 ;
  assign ldpc_3gpp_enc_p2__iused_zc    = '0 ;
  //
  assign ldpc_3gpp_enc_p2__iwrite4au   = '0 ;
  assign ldpc_3gpp_enc_p2__iwstart4au  = '0 ;
  assign ldpc_3gpp_enc_p2__iwdat4au    = '0 ;
  //
  assign ldpc_3gpp_enc_p2__iwrite4p1   = '0 ;
  assign ldpc_3gpp_enc_p2__iwstart4p1  = '0 ;
  assign ldpc_3gpp_enc_p2__iwdat4p1    = '0 ;
  //
  assign ldpc_3gpp_enc_p2__iread       = '0 ;
  assign ldpc_3gpp_enc_p2__irstart     = '0 ;
  assign ldpc_3gpp_enc_p2__irval       = '0 ;
  assign ldpc_3gpp_enc_p2__irstrb      = '0 ;
  assign ldpc_3gpp_enc_p2__irrow       = '0 ;
  assign ldpc_3gpp_enc_p2__irHb        = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_p2.sv
// Description   : p2 = (T^-1)*(A*u'+B*p1') matrix multiply.
//

module ldpc_3gpp_enc_p2
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  iused_dat_w   ,
  iused_zc      ,
  //
  iwrite4au     ,
  iwstart4au    ,
  iwdat4au      ,
  //
  iwrite4p1     ,
  iwstart4p1    ,
  iwdat4p1      ,
  //
  iread         ,
  irstart       ,
  irval         ,
  irstrb        ,
  irrow         ,
  irHb          ,
  //
  oval          ,
  ostrb         ,
  odat          ,
  //
  ordat2au      ,
  //
  owrite2p3_p1  ,
  owstart2p3_p1 ,
  owdat2p3_p1   ,
  //
  owrite2p3_p2  ,
  owstart2p3_p2 ,
  owdat2p3_p2
);

  parameter int pADDR_W        = 8 ;
  parameter bit pPIPE          = 0 ; // use matrix multiply pipeline or not
  parameter bit pUSE_VAR_DAT_W = 0 ; // used dat bitwidth is fixed pDAT_W or variable

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk              ;
  input  logic          ireset            ;
  input  logic          iclkena           ;
  //
  input  hb_zc_t        iused_dat_w       ;
  input  hb_zc_t        iused_zc          ;  // used expansion factor
  // A*u'
  input  logic  [2 : 0] iwrite4au         ;
  input  logic          iwstart4au        ;
  input  dat_t          iwdat4au      [3] ;
  // p1
  input  logic          iwrite4p1         ;
  input  logic          iwstart4p1        ;
  input  dat_t          iwdat4p1          ;
  //
  input  logic          iread             ;
  input  logic          irstart           ;
  input  logic          irval             ;
  input  strb_t         irstrb            ;
  input  hb_row_t       irrow             ;
  input  mm_hb_value_t  irHb          [3] ;
  // to output buffer
  output logic          oval              ;
  output strb_t         ostrb             ;
  output dat_t          odat              ;
  // to au summator
  output dat_t          ordat2au          ;
  // to p3 matrix multiply p1
  output logic          owrite2p3_p1      ;
  output logic          owstart2p3_p1     ;
  output dat_t          owdat2p3_p1       ;
  // to p3 matrix multiply p2
  output logic          owrite2p3_p2      ;
  output logic          owstart2p3_p2     ;
  output dat_t          owdat2p3_p2   [3] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // au register
  logic  au_reg__oval   [3] ;
  logic  au_reg__ostart [3] ;
  dat_t  au_reg__odat   [3] ;

  // matrix multiply
  logic  mm__oval       [3] ;
  strb_t mm__ostrb      [3] ;
  dat_t  mm__odat       [3] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  genvar i;

  generate
    for (i = 0; i < 3; i++) begin : mm_inst
      //
      // A*u' register
      //
      ldpc_3gpp_enc_reg_spram
      #(
        .pADDR_W ( pADDR_W ) ,
        .pDAT_W  ( pDAT_W  ) ,
        .pPIPE   ( pPIPE   )
      )
      au_reg
      (
        .iclk    ( iclk               ) ,
        .ireset  ( ireset             ) ,
        .iclkena ( iclkena            ) ,
        //
        .iwrite  ( iwrite4au      [i] ) ,
        .iwstart ( iwstart4au         ) ,
        .iwdat   ( iwdat4au       [i] ) ,
        //
        .iread   ( iread              ) ,
        .irstart ( irstart            ) ,
        //
        .oval    ( au_reg__oval   [i] ) ,
        .ostart  ( au_reg__ostart [i] ) ,
        .odat    ( au_reg__odat   [i] )
      );

      //
      // B*p1 mult
      //

      if (pUSE_VAR_DAT_W)  begin
        ldpc_3gpp_enc_mm_spram_var
        #(
          .pADDR_W  ( pADDR_W  ) ,
          .pDAT_W   ( pDAT_W   ) ,
          .pPIPE    ( pPIPE    )
        )
        mm
        (
          .iclk        ( iclk          ) ,
          .ireset      ( ireset        ) ,
          .iclkena     ( iclkena       ) ,
          //
          .iused_dat_w ( iused_dat_w   ) ,
          .iused_zc    ( iused_zc      ) ,
          //
          .iwrite      ( iwrite4p1     ) ,
          .iwstart     ( iwstart4p1    ) ,
          .iwdat       ( iwdat4p1      ) ,
          //
          .iread       ( iread         ) ,
          .irstart     ( irstart       ) ,
          .irHb        ( irHb      [i] ) ,
          .irval       ( irval         ) ,
          .irstrb      ( irstrb        ) ,
          //
          .oval        ( mm__oval  [i] ) ,
          .ostrb       ( mm__ostrb [i] ) ,
          .odat        ( mm__odat  [i] )
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
          .iclk     ( iclk          ) ,
          .ireset   ( ireset        ) ,
          .iclkena  ( iclkena       ) ,
          //
          .iused_zc ( iused_zc      ) ,
          //
          .iwrite   ( iwrite4p1     ) ,
          .iwstart  ( iwstart4p1    ) ,
          .iwdat    ( iwdat4p1      ) ,
          //
          .iread    ( iread         ) ,
          .irstart  ( irstart       ) ,
          .irHb     ( irHb      [i] ) ,
          .irval    ( irval         ) ,
          .irstrb   ( irstrb        ) ,
          //
          .oval     ( mm__oval  [i] ) ,
          .ostrb    ( mm__ostrb [i] ) ,
          .odat     ( mm__odat  [i] )
        );
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // align 3/4 cycle read delay
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] rrow_line [3+pPIPE];
  logic [1 : 0] rrow;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      for (int i = 0; i < $size(rrow_line); i++) begin
        rrow_line[i] <= (i == 0) ? irrow[1 : 0] : rrow_line[i-1];
      end
    end
  end

  assign rrow = rrow_line[$high(rrow_line)];

  //------------------------------------------------------------------------------------------------------
  // p2 "acc"
  //------------------------------------------------------------------------------------------------------

  dat_t p2 [3];

  always_comb begin
    for (int row = 0; row < 3; row++) begin
      if (row == 0) begin
        p2[row] =             au_reg__odat[row] ^ mm__odat[row];
      end
      else begin
        p2[row] = p2[row-1] ^ au_reg__odat[row] ^ mm__odat[row];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output mapping (2 register here)
  //------------------------------------------------------------------------------------------------------

  logic [1 : 0] val;
  strb_t        strb   [2];

  dat_t         p2_reg [3];
  logic [1 : 0] p2_rrow;

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
      p2_reg  <= p2;
      p2_rrow <= rrow;
      //
      odat    <= p2_reg[p2_rrow];
    end
  end

  assign oval   = val [1];
  assign ostrb  = strb[1];

  //------------------------------------------------------------------------------------------------------
  // au register to au interface (register here)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ordat2au <= au_reg__odat[0] ^ au_reg__odat[1] ^ au_reg__odat[2];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // p1 to p3 interface (no register here). write multi times
  //------------------------------------------------------------------------------------------------------

  assign owrite2p3_p1  = mm__oval [2];
  assign owstart2p3_p1 = mm__ostrb[2].sop;
  assign owdat2p3_p1   = mm__odat [2];

  //------------------------------------------------------------------------------------------------------
  // p2 to p3 interface (1 register here). write multi times
  //------------------------------------------------------------------------------------------------------

  assign owrite2p3_p2  = val [0];
  assign owstart2p3_p2 = strb[0].sop;
  assign owdat2p3_p2   = p2_reg;

endmodule
