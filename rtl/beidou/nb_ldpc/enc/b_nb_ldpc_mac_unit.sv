/*



  parameter int pADDR_W = 8 ;



  logic                    b_nb_ldpc_mac_unit__iclk          ;
  logic                    b_nb_ldpc_mac_unit__ireset        ;
  logic                    b_nb_ldpc_mac_unit__iclkena       ;
  //
  logic                    b_nb_ldpc_mac_unit__idat_n_parity ;
  //
  logic                    b_nb_ldpc_mac_unit__ival          ;
  gf_dat_t                 b_nb_ldpc_mac_unit__idat          ;
  gf_dat_t                 b_nb_ldpc_mac_unit__igdat         ;
  strb_t                   b_nb_ldpc_mac_unit__istrb         ;
  //
  logic                    b_nb_ldpc_mac_unit__owrite        ;
  logic                    b_nb_ldpc_mac_unit__owfull        ;
  gf_dat_t                 b_nb_ldpc_mac_unit__owdat         ;
  logic    [pADDR_W-1 : 0] b_nb_ldpc_mac_unit__owaddr        ;



  b_nb_ldpc_mac_unit
  #(
    .pADDR_W ( pADDR_W )
  )
  b_nb_ldpc_mac_unit
  (
    .iclk          ( b_nb_ldpc_mac_unit__iclk          ) ,
    .ireset        ( b_nb_ldpc_mac_unit__ireset        ) ,
    .iclkena       ( b_nb_ldpc_mac_unit__iclkena       ) ,
    //
    .idat_n_parity ( b_nb_ldpc_mac_unit__idat_n_parity ) ,
    //
    .ival          ( b_nb_ldpc_mac_unit__ival          ) ,
    .idat          ( b_nb_ldpc_mac_unit__idat          ) ,
    .igdat         ( b_nb_ldpc_mac_unit__igdat         ) ,
    .istrb         ( b_nb_ldpc_mac_unit__istrb         ) ,
    //
    .owrite        ( b_nb_ldpc_mac_unit__owrite        ) ,
    .owfull        ( b_nb_ldpc_mac_unit__owfull        ) ,
    .owdat         ( b_nb_ldpc_mac_unit__owdat         ) ,
    .owaddr        ( b_nb_ldpc_mac_unit__owaddr        )
  );


  assign b_nb_ldpc_mac_unit__iclk          = '0 ;
  assign b_nb_ldpc_mac_unit__ireset        = '0 ;
  assign b_nb_ldpc_mac_unit__iclkena       = '0 ;
  assign b_nb_ldpc_mac_unit__idat_n_parity = '0 ;
  assign b_nb_ldpc_mac_unit__ival          = '0 ;
  assign b_nb_ldpc_mac_unit__idat          = '0 ;
  assign b_nb_ldpc_mac_unit__igdat         = '0 ;
  assign b_nb_ldpc_mac_unit__istrb         = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_mac_unit.svh
// Description   : encoder galua field MAC unit
//

module b_nb_ldpc_mac_unit
#(
  parameter int pADDR_W = 8
)
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  idat_n_parity ,
  //
  ival          ,
  idat          ,
  igdat         ,
  istrb         ,
  //
  owrite        ,
  owfull        ,
  owdat         ,
  owaddr
);

  `include "b_nb_ldpc_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                     iclk          ;
  input  logic                     ireset        ;
  input  logic                     iclkena       ;
  //
  input  logic                     idat_n_parity ;
  //
  input  logic                     ival          ;
  input  gf_data_t                 idat          ;
  input  gf_data_t                 igdat         ;
  input  strb_t                    istrb         ;
  //
  output logic                     owrite        ;
  output logic                     owfull        ;
  output gf_data_t                 owdat         ;
  output logic     [pADDR_W-1 : 0] owaddr        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic     gf_acc_val;
  strb_t    gf_acc_strb;
  gf_data_t gf_acc;

  // gf mult
  gf_data_t gf_mult__idat_a ;
  gf_data_t gf_mult__idat_b ;
  //
  gf_data_t gf_mult__odat   ;

  //------------------------------------------------------------------------------------------------------
  // GF mult
  //------------------------------------------------------------------------------------------------------

  gf_mult
  #(
    .m ( cGF_M )
  )
  gf_mult
  (
    .idat_a ( gf_mult__idat_a ) ,
    .idat_b ( gf_mult__idat_b ) ,
    //
    .odat   ( gf_mult__odat   )
  );

  assign gf_mult__idat_a = idat;
  assign gf_mult__idat_b = igdat;

  //------------------------------------------------------------------------------------------------------
  // gf acc
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      gf_acc_val <= 1'b0;
    end
    else if (iclkena) begin
      gf_acc_val <= !idat_n_parity & ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      gf_acc_strb <= istrb;
      if (!idat_n_parity & ival) begin
        gf_acc <= istrb.sop ? gf_mult__odat : (gf_acc ^ gf_mult__odat);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // output ram write logic
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      owrite <= 1'b0;
      owfull <= 1'b0;
    end
    else if (iclkena) begin
      owrite <=  idat_n_parity ? ival : (gf_acc_val & gf_acc_strb.eop);
      owfull <= !idat_n_parity &        (gf_acc_val & gf_acc_strb.eof);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (idat_n_parity) begin
        if (ival) begin
          owaddr <= istrb.sof ? 1'b0 : (owaddr + 1'b1);
        end
        owdat <= idat;
      end
      else begin
        if (gf_acc_val & gf_acc_strb.eop) begin
          owaddr <= owaddr + 1'b1;
        end
        owdat <= gf_acc;
      end
    end
  end

endmodule
