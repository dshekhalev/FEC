/*




  logic         ccsds_turbo_ptable__iclk
  logic         ccsds_turbo_ptable__ireset      ;
  logic         ccsds_turbo_ptable__iclkena     ;
  logic [1 : 0] ccsds_turbo_ptable__icode       ;
  logic [1 : 0] ccsds_turbo_ptable__inidx       ;
  ptab_dat_t    ccsds_turbo_ptable__oN          ;
  ptab_dat_t    ccsds_turbo_ptable__oNp3        ;
  ptab_dat_t    ccsds_turbo_ptable__oK2         ;
  ptab_dat_t    ccsds_turbo_ptable__oP      [4] ;
  ptab_dat_t    ccsds_turbo_ptable__oPcomp  [4] ;




  ccsds_turbo_ptable
  ccsds_turbo_ptable
  (
    .iclk     ( ccsds_turbo_ptable__iclk    ) ,
    .ireset   ( ccsds_turbo_ptable__ireset  ) ,
    .iclkena  ( ccsds_turbo_ptable__iclkena ) ,
    .icode    ( ccsds_turbo_ptable__icode   ) ,
    .inidx    ( ccsds_turbo_ptable__inidx   ) ,
    .oN       ( ccsds_turbo_ptable__oN      ) ,
    .oNp3     ( ccsds_turbo_ptable__oNp3    ) ,
    .oK2      ( ccsds_turbo_ptable__oK2     ) ,
    .oP       ( ccsds_turbo_ptable__oP      ) ,
    .oPcomp   ( ccsds_turbo_ptable__oPcomp  )
  );


  assign ccsds_turbo_ptable__iclk    = '0 ;
  assign ccsds_turbo_ptable__ireset  = '0 ;
  assign ccsds_turbo_ptable__iclkena = '0 ;
  assign ccsds_turbo_ptable__icode   = '0 ;
  assign ccsds_turbo_ptable__inidx   = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_ptable.sv
// Description   : Permutation parameters table. It takes 1 clock cycles to apply new parameters
//

module ccsds_turbo_ptable
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  inidx   ,
  //
  oN      ,
  oNp3    ,
  //
  oK2     ,
  oP      ,
  oPcomp
);

  `include "ccsds_turbo_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic            iclk        ;
  input  logic            ireset      ;
  input  logic            iclkena     ;
  //
  input  logic    [1 : 0] icode       ;
  input  logic    [1 : 0] inidx       ;
  //
  output ptab_dat_t       oN          ;
  output ptab_dat_t       oNp3        ;
  output ptab_dat_t       oK2         ;
  //
  output ptab_dat_t       oP      [4] ;
  output ptab_dat_t       oPcomp  [4] ; // complement oP for backward recursion address process

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cK2_TAB    [4] = '{223*1, 223*2, 223*4, 223*5};

  localparam int cP_TAB     [4] = '{31, 37, 43, 47};

  localparam int cPCOMP_TAB [4][4] = '{
                                      '{ 192,  186,  180,  176} ,
                                      '{ 415,  409,  403,  399} ,
                                      '{ 861,  855,  849,  845} ,
                                      '{1084, 1078, 1072, 1068}};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oN    <= cN_TAB [inidx];
      oNp3  <= cN_TAB [inidx] + 4 - 1;
      oK2   <= cK2_TAB[inidx];
      //
      for (int i = 0; i < 4; i++) begin
        oP    [i] <= cP_TAB            [i];
        oPcomp[i] <= cPCOMP_TAB [inidx][i];
      end
    end
  end

endmodule
