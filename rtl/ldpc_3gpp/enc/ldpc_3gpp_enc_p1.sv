/*



  parameter int pADDR_W        = 8 ;
  parameter int pDAT_W         = 8 ;
  //
  parameter bit pPIPE          = 0 ;
  parameter bit pUSE_VAR_DAT_W = 0 ;



  logic         ldpc_3gpp_enc_p1__iclk        ;
  logic         ldpc_3gpp_enc_p1__ireset      ;
  logic         ldpc_3gpp_enc_p1__iclkena     ;
  //
  hb_zc_t       ldpc_3gpp_enc_p1__iused_dat_w ;
  hb_zc_t       ldpc_3gpp_enc_p1__iused_zc    ;
  logic         ldpc_3gpp_enc_p1__ibypass     ;
  //
  logic         ldpc_3gpp_enc_p1__iwrite      ;
  logic         ldpc_3gpp_enc_p1__iwstart     ;
  dat_t         ldpc_3gpp_enc_p1__iwdat       ;
  //
  logic         ldpc_3gpp_enc_p1__iread       ;
  logic         ldpc_3gpp_enc_p1__irstart     ;
  logic         ldpc_3gpp_enc_p1__irval       ;
  strb_t        ldpc_3gpp_enc_p1__irstrb      ;
  mm_hb_value_t ldpc_3gpp_enc_p1__iinvPsi     ;
  //
  logic         ldpc_3gpp_enc_p1__oval        ;
  ostrb_t       ldpc_3gpp_enc_p1__ostrb       ;
  dat_t         ldpc_3gpp_enc_p1__odat        ;
  //
  logic         ldpc_3gpp_enc_p1__owrite2p2   ;
  logic         ldpc_3gpp_enc_p1__owstart2p2  ;
  dat_t         ldpc_3gpp_enc_p1__owdat2p2    ;



  ldpc_3gpp_enc_p1
  #(
    .pADDR_W        ( pADDR_W        ) ,
    .pDAT_W         ( pDAT_W         ) ,
    //
    .pPIPE          ( pPIPE          ) ,
    .pUSE_VAR_DAT_W ( pUSE_VAR_DAT_W )
  )
  ldpc_3gpp_enc_p1
  (
    .iclk        ( ldpc_3gpp_enc_p1__iclk        ) ,
    .ireset      ( ldpc_3gpp_enc_p1__ireset      ) ,
    .iclkena     ( ldpc_3gpp_enc_p1__iclkena     ) ,
    //
    .iused_dat_w ( ldpc_3gpp_enc_p1__iused_dat_w ) ,
    .iused_zc    ( ldpc_3gpp_enc_p1__iused_zc    ) ,
    .ibypass     ( ldpc_3gpp_enc_p1__ibypass     ) ,
    //
    .iwrite      ( ldpc_3gpp_enc_p1__iwrite      ) ,
    .iwstart     ( ldpc_3gpp_enc_p1__iwstart     ) ,
    .iwdat       ( ldpc_3gpp_enc_p1__iwdat       ) ,
    //
    .iread       ( ldpc_3gpp_enc_p1__iread       ) ,
    .irstart     ( ldpc_3gpp_enc_p1__irstart     ) ,
    .irval       ( ldpc_3gpp_enc_p1__irval       ) ,
    .irstrb      ( ldpc_3gpp_enc_p1__irstrb      ) ,
    .iinvPsi     ( ldpc_3gpp_enc_p1__iinvPsi     ) ,
    //
    .oval        ( ldpc_3gpp_enc_p1__oval        ) ,
    .ostrb       ( ldpc_3gpp_enc_p1__ostrb       ) ,
    .odat        ( ldpc_3gpp_enc_p1__odat        ) ,
    //
    .owrite2p2   ( ldpc_3gpp_enc_p1__owrite2p2   ) ,
    .owstart2p2  ( ldpc_3gpp_enc_p1__owstart2p2  ) ,
    .owdat2p2    ( ldpc_3gpp_enc_p1__owdat2p2    )
  );


  assign ldpc_3gpp_enc_p1__iclk        = '0 ;
  assign ldpc_3gpp_enc_p1__ireset      = '0 ;
  assign ldpc_3gpp_enc_p1__iclkena     = '0 ;
  //
  assign ldpc_3gpp_enc_p1__iused_dat_w = '0 ;
  assign ldpc_3gpp_enc_p1__iused_zc    = '0 ;
  assign ldpc_3gpp_enc_p1__ibypass     = '0 ;
  //
  assign ldpc_3gpp_enc_p1__iwrite      = '0 ;
  assign ldpc_3gpp_enc_p1__iwstart     = '0 ;
  assign ldpc_3gpp_enc_p1__iwdat       = '0 ;
  //
  assign ldpc_3gpp_enc_p1__iread       = '0 ;
  assign ldpc_3gpp_enc_p1__irstart     = '0 ;
  assign ldpc_3gpp_enc_p1__irval       = '0 ;
  assign ldpc_3gpp_enc_p1__irstrb      = '0 ;
  assign ldpc_3gpp_enc_p1__iinvPsi     = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_enc_p1.sv
// Description   : inv(-E*T^-1*B+D) matrix multiply of (E*(T^-1)*A*u' + C*u') matrix multiply.
//

`include "define.vh"

module ldpc_3gpp_enc_p1
(
  iclk        ,
  ireset      ,
  iclkena     ,
  //
  iused_dat_w ,
  iused_zc    ,
  ibypass     ,
  //
  iwrite      ,
  iwstart     ,
  iwdat       ,
  //
  iread       ,
  irstart     ,
  irval       ,
  irstrb     ,
  iinvPsi     ,
  //
  oval        ,
  ostrb       ,
  odat        ,
  //
  owrite2p2   ,
  owstart2p2  ,
  owdat2p2
);

  parameter int pADDR_W        = 8 ;
  parameter bit pPIPE          = 0 ;  // use matrix multiply pipeline or not
  parameter bit pUSE_VAR_DAT_W = 0 ;  // used dat bitwidth is fixed pDAT_W or variable

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk        ;
  input  logic          ireset      ;
  input  logic          iclkena     ;
  //
  input  hb_zc_t        iused_dat_w ;
  input  hb_zc_t        iused_zc    ; // used expansion factor
  input  logic          ibypass     ; // bypass matrix multiply because only some codes has inv(-E*T^-1*B+D) != eye(1)
  // E*(T^-1)*(A*u' + C*u')
  input  logic          iwrite      ;
  input  logic          iwstart     ; // initialize write counters
  input  dat_t          iwdat       ;
  // p1
  input  logic          iread       ;
  input  logic          irstart     ;
  input  logic          irval       ;
  input  strb_t         irstrb      ;
  input  mm_hb_value_t  iinvPsi     ; // inverted psi matrix
  // to output buffer
  output logic          oval        ;
  output strb_t         ostrb       ;
  output dat_t          odat        ;
  // to p2 matrix multiply A*u'
  output logic          owrite2p2   ;
  output logic          owstart2p2  ;
  output dat_t          owdat2p2    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic   mm__oval  ;
  strb_t  mm__ostrb ;
  dat_t   mm__odat  ;

  //------------------------------------------------------------------------------------------------------
  // inv(-E*T^-1*B+D) == invPsi multiply
  //------------------------------------------------------------------------------------------------------

  generate
    if (pUSE_VAR_DAT_W) begin
      ldpc_3gpp_enc_mm_spram_var
      #(
        .pADDR_W  ( pADDR_W  ) ,
        .pDAT_W   ( pDAT_W   ) ,
        .pSHIFT_R ( 1        ) ,  // shift right
        .pPIPE    ( pPIPE    )
      )
      mm
      (
        .iclk        ( iclk        ) ,
        .ireset      ( ireset      ) ,
        .iclkena     ( iclkena     ) ,
        //
        .iused_dat_w ( iused_dat_w ) ,
        .iused_zc    ( iused_zc    ) ,
        //
        .iwrite      ( iwrite      ) ,
        .iwstart     ( iwstart     ) ,
        .iwdat       ( iwdat       ) ,
        //
        .iread       ( iread       ) ,
        .irstart     ( irstart     ) ,
        .irHb        ( iinvPsi     ) ,
        .irval       ( irval       ) ,
        .irstrb      ( irstrb      ) ,
        //
        .oval        ( mm__oval    ) ,
        .ostrb       ( mm__ostrb   ),
        .odat        ( mm__odat    )
      );
    end
    else begin
      ldpc_3gpp_enc_mm_spram
      #(
        .pADDR_W  ( pADDR_W  ) ,
        .pDAT_W   ( pDAT_W   ) ,
        .pSHIFT_R ( 1        ) ,  // shift right
        .pPIPE    ( pPIPE    )
      )
      mm
      (
        .iclk     ( iclk      ) ,
        .ireset   ( ireset    ) ,
        .iclkena  ( iclkena   ) ,
        //
        .iused_zc ( iused_zc  ) ,
        //
        .iwrite   ( iwrite    ) ,
        .iwstart  ( iwstart   ) ,
        .iwdat    ( iwdat     ) ,
        //
        .iread    ( iread     ) ,
        .irstart  ( irstart   ) ,
        .irHb     ( iinvPsi   ) ,
        .irval    ( irval     ) ,
        .irstrb   ( irstrb    ) ,
        //
        .oval     ( mm__oval  ) ,
        .ostrb    ( mm__ostrb ),
        .odat     ( mm__odat  )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // pipeline data
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ibypass ? iwrite : mm__oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ibypass) begin
        ostrb     <= '0; // n.u.
        ostrb.sof <= iwstart;
        odat      <= iwdat;
      end
      else begin
        ostrb <= mm__ostrb;
        odat  <= mm__odat;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // write once
  //------------------------------------------------------------------------------------------------------

  assign owrite2p2  = oval;
  assign owstart2p2 = ostrb.sof;
  assign owdat2p2   = odat;

endmodule
