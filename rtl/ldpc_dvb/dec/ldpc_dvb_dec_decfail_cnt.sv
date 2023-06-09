/*



  parameter int pERR_W = 16 ;



  logic  ldpc_dvb_dec_decfail_cnt__iclk         ;
  logic  ldpc_dvb_dec_decfail_cnt__ireset       ;
  logic  ldpc_dvb_dec_decfail_cnt__iclkena      ;
  //
  logic  ldpc_dvb_dec_decfail_cnt__istart       ;
  logic  ldpc_dvb_dec_decfail_cnt__iload_iter   ;
  //
  logic  ldpc_dvb_dec_decfail_cnt__ival         ;
  zdat_t ldpc_dvb_dec_decfail_cnt__irow_decfail ;
  zdat_t ldpc_dvb_dec_decfail_cnt__irow_minfail ;
  //
  logic  ldpc_dvb_dec_decfail_cnt__oval         ;
  logic  ldpc_dvb_dec_decfail_cnt__odecfail     ;



  ldpc_dvb_dec_decfail_cnt
  #(
    .pERR_W ( pERR_W )
  )
  ldpc_dvb_dec_decfail_cnt
  (
    .iclk         ( ldpc_dvb_dec_decfail_cnt__iclk         ) ,
    .ireset       ( ldpc_dvb_dec_decfail_cnt__ireset       ) ,
    .iclkena      ( ldpc_dvb_dec_decfail_cnt__iclkena      ) ,
    //
    .istart       ( ldpc_dvb_dec_decfail_cnt__istart       ) ,
    .iload_iter   ( ldpc_dvb_dec_decfail_cnt__iload_iter   ) ,
    //
    .ival         ( ldpc_dvb_dec_decfail_cnt__ival         ) ,
    .irow_decfail ( ldpc_dvb_dec_decfail_cnt__irow_decfail ) ,
    .irow_minfail ( ldpc_dvb_dec_decfail_cnt__irow_minfail ) ,
    //
    .oval         ( ldpc_dvb_dec_decfail_cnt__oval         ) ,
    .odecfail     ( ldpc_dvb_dec_decfail_cnt__odecfail     )
  );


  assign ldpc_dvb_dec_decfail_cnt__iclk         = '0 ;
  assign ldpc_dvb_dec_decfail_cnt__ireset       = '0 ;
  assign ldpc_dvb_dec_decfail_cnt__iclkena      = '0 ;
  assign ldpc_dvb_dec_decfail_cnt__istart       = '0 ;
  assign ldpc_dvb_dec_decfail_cnt__iload_iter   = '0 ;
  assign ldpc_dvb_dec_decfail_cnt__ival         = '0 ;
  assign ldpc_dvb_dec_decfail_cnt__irow_decfail = '0 ;
  assign ldpc_dvb_dec_decfail_cnt__irow_minfail = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dvb_dec_decfail_cnt.sv
// Description   : wide bit vector decfail row checks couner & decfail decision
//                 decfail = 0 if current and two previois checks is the same and current check > 4
//

module ldpc_dvb_dec_decfail_cnt
#(
  parameter int pERR_W = 16
)
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  istart       ,
  iload_iter   ,
  //
  ival         ,
  irow_decfail ,
  irow_minfail ,
  //
  oval         ,
  odecfail
);

  `include "../ldpc_dvb_constants.svh"
  `include "ldpc_dvb_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk         ;
  input  logic  ireset       ;
  input  logic  iclkena      ;
  //
  input  logic  istart       ;
  input  logic  iload_iter   ;
  //
  input  logic  ival         ;
  input  zdat_t irow_decfail ;
  input  zdat_t irow_minfail ;
  //
  output logic  oval         ;
  output logic  odecfail     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cSUM_36_NUM      = cZC_MAX/36;

  localparam int cADDER_TREE_NUM  = 2**$clog2(cSUM_36_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // 36 bits addres
  logic                sum__ival                 ;
  logic                sum__isop                 ;
  logic                sum__ieop                 ;
  logic       [35 : 0] sum__ibiterr [cSUM_36_NUM];
  //
  logic                sum__oval    [cSUM_36_NUM];
  logic                sum__osop    [cSUM_36_NUM];
  logic                sum__oeop    [cSUM_36_NUM];
  logic [pERR_W-1 : 0] sum__oerr    [cSUM_36_NUM];

  //
  // adder tree
  logic                adder__ival                    ;
  logic                adder__isop                    ;
  logic                adder__ieop                    ;
  logic [pERR_W-1 : 0] adder__ierr  [cADDER_TREE_NUM] ;
  //
  logic                adder__oval                    ;
  logic                adder__osop                    ;
  logic                adder__oeop                    ;
  logic [pERR_W-1 : 0] adder__oerr                    ;

  //
  // wide or
  logic       [35 : 0] mindecfail2wideor [cSUM_36_NUM];
  //
  // checks counter
  logic [pERR_W-1 : 0] checks;
  logic                checks_val;

  //------------------------------------------------------------------------------------------------------
  // data remap
  //------------------------------------------------------------------------------------------------------

  assign sum__ival = ival ;
  assign sum__isop = 1'b0 ;
  assign sum__ieop = 1'b0 ;

  always_comb begin
    for (int i = 0; i < cSUM_36_NUM; i++) begin
      sum__ibiterr      [i] = irow_decfail[i*36 +: 36];
      mindecfail2wideor [i] = irow_minfail[i*36 +: 36];
    end
  end

  //------------------------------------------------------------------------------------------------------
  // mindecfail wideor and accumulator
  //------------------------------------------------------------------------------------------------------

  logic                     mindecfail_wideor_val;
  logic [cSUM_36_NUM-1 : 0] mindecfail_wideor;
  logic                     min_decfail;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      mindecfail_wideor_val <= ival;
      for (int i = 0; i < cSUM_36_NUM; i++) begin
        mindecfail_wideor <= |mindecfail2wideor[i];
      end
      //
      if (istart) begin
        min_decfail <= 1'b0;
      end
      else if (mindecfail_wideor_val) begin
        min_decfail <= min_decfail | (|mindecfail_wideor);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // input 36 bits adders :: 1 tick delay
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < cSUM_36_NUM; g++) begin : gen_sum_36_inst
      codec_biterr_sum_36
      #(
        .pERR_W ( pERR_W )
      )
      sum
      (
        .iclk    ( iclk             ) ,
        .ireset  ( ireset           ) ,
        .iclkena ( iclkena          ) ,
        //
        .ival    ( sum__ival        ) ,
        .isop    ( sum__isop        ) ,
        .ieop    ( sum__ieop        ) ,
        .ibiterr ( sum__ibiterr [g] ) ,
        //
        .oval    ( sum__oval    [g] ) ,
        .osop    ( sum__osop    [g] ) ,
        .oeop    ( sum__oeop    [g] ) ,
        .oerr    ( sum__oerr    [g] )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // adder tree :: $clog2(cADDER_TREE_NUM) delay
  //------------------------------------------------------------------------------------------------------

  codec_biterr_adder
  #(
    .pERR_W ( pERR_W                  ) ,
    .pD_W   ( $clog2(cADDER_TREE_NUM) )
  )
  adder
  (
    .iclk    ( iclk        ) ,
    .ireset  ( ireset      ) ,
    .iclkena ( iclkena     ) ,
    //
    .ival    ( adder__ival ) ,
    .isop    ( adder__isop ) ,
    .ieop    ( adder__ieop ) ,
    .ierr    ( adder__ierr ) ,
    //
    .oval    ( adder__oval ) ,
    .osop    ( adder__osop ) ,
    .oeop    ( adder__oeop ) ,
    .oerr    ( adder__oerr )
  );

  assign adder__ival = sum__oval[0] ;
  assign adder__isop = 1'b0         ;
  assign adder__ieop = 1'b0         ;

  //
  // map 2^N adder tree
  always_comb begin
    for (int i = 0; i < cADDER_TREE_NUM; i++) begin
      adder__ierr[i] = '0;
      if (i < cSUM_36_NUM) begin
        adder__ierr[i] = sum__oerr[i];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // accumulators & decision
  //------------------------------------------------------------------------------------------------------

  logic [3 : 0] pre_checks; // more then enougth for used edge

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      checks_val <= adder__oval;
      if (istart) begin
        checks        <= '0;
        pre_checks[0] <= iload_iter ? '0 : checks;
        pre_checks[1] <= iload_iter ? '0 : pre_checks[0];
      end
      else if (adder__oval) begin
        checks <= checks + adder__oerr;
      end
      //
      oval <= checks_val;
      if (min_decfail) begin
        odecfail <= (checks != pre_checks[0]) | (checks > 2);
      end
      else begin
        odecfail <= (checks != 0);
      end
    end
  end

endmodule
