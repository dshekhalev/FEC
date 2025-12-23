/*



  parameter int pCODE         = 46 ;
  parameter int pLLR_BY_CYCLE =  4 ;
  parameter int pROW_BY_CYCLE =  4 ;



  logic  ldpc_3gpp_dec_decfail_cnt__iclk                                        ;
  logic  ldpc_3gpp_dec_decfail_cnt__ireset                                      ;
  logic  ldpc_3gpp_dec_decfail_cnt__iclkena                                     ;
  //
  logic  ldpc_3gpp_dec_decfail_cnt__istart                                      ;
  logic  ldpc_3gpp_dec_decfail_cnt__iload_mode                                  ;
  //
  logic  ldpc_3gpp_dec_decfail_cnt__ival                                        ;
  strb_t ldpc_3gpp_dec_decfail_cnt__istrb                                       ;
  logic  ldpc_3gpp_dec_decfail_cnt__ipmask       [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic  ldpc_3gpp_dec_decfail_cnt__irow_decfail [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;
  logic  ldpc_3gpp_dec_decfail_cnt__irow_minfail [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  logic  ldpc_3gpp_dec_decfail_cnt__oval                                        ;
  logic  ldpc_3gpp_dec_decfail_cnt__opre_val                                    ;
  logic  ldpc_3gpp_dec_decfail_cnt__odecfail                                    ;
  logic  ldpc_3gpp_dec_decfail_cnt__odecfail_est                                ;



  ldpc_3gpp_dec_decfail_cnt
  #(
    .pCODE         ( pCODE         ) ,
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pROW_BY_CYCLE ( pROW_BY_CYCLE )
  )
  ldpc_3gpp_dec_decfail_cnt
  (
    .iclk         ( ldpc_3gpp_dec_decfail_cnt__iclk         ) ,
    .ireset       ( ldpc_3gpp_dec_decfail_cnt__ireset       ) ,
    .iclkena      ( ldpc_3gpp_dec_decfail_cnt__iclkena      ) ,
    //
    .istart       ( ldpc_3gpp_dec_decfail_cnt__istart       ) ,
    .iload_mode   ( ldpc_3gpp_dec_decfail_cnt__iload_mode   ) ,
    //
    .ival         ( ldpc_3gpp_dec_decfail_cnt__ival         ) ,
    .istrb        ( ldpc_3gpp_dec_decfail_cnt__istrb        ) ,
    .ipmask       ( ldpc_3gpp_dec_decfail_cnt__ipmask       ) ,
    .irow_decfail ( ldpc_3gpp_dec_decfail_cnt__irow_decfail ) ,
    .irow_minfail ( ldpc_3gpp_dec_decfail_cnt__irow_minfail ) ,
    //
    .oval         ( ldpc_3gpp_dec_decfail_cnt__oval         ) ,
    .opre_val     ( ldpc_3gpp_dec_decfail_cnt__opre_val     ) ,
    .odecfail     ( ldpc_3gpp_dec_decfail_cnt__odecfail     ) ,
    .odecfail_est ( ldpc_3gpp_dec_decfail_cnt__odecfail_est )
  );


  assign ldpc_3gpp_dec_decfail_cnt__iclk         = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__ireset       = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__iclkena      = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__istart       = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__iload_mode   = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__ival         = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__istrb        = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__ipmask       = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__irow_decfail = '0 ;
  assign ldpc_3gpp_dec_decfail_cnt__irow_minfail = '0 ;



*/


//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_decfail_cnt.sv
// Description   : unit to detect output block decfail & iteration stop decision
//                 odecfail == 0      if major matrix syndrome == 0 & minimal elementh of row > 1
//                 odecfail_est == 0  if all_checks == 0 & minimal elementh of row > 1 or
//                                    if current and two previous checks is the same
//

module ldpc_3gpp_dec_decfail_cnt
(
  iclk         ,
  ireset       ,
  iclkena      ,
  //
  istart       ,
  iload_mode   ,
  //
  ival         ,
  istrb        ,
  ipmask       ,
  irow_decfail ,
  irow_minfail ,
  //
  oval         ,
  opre_val     ,
  odecfail     ,
  odecfail_est
);

  `include "../ldpc_3gpp_constants.svh"
  `include "ldpc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic  iclk                                        ;
  input  logic  ireset                                      ;
  input  logic  iclkena                                     ;
  //
  input  logic  istart                                      ;
  input  logic  iload_mode                                  ;
  //
  input  logic  ival                                        ;
  input  strb_t istrb                                       ;
  input  logic  ipmask       [pROW_BY_CYCLE][pLLR_BY_CYCLE] ; // row parity mask (1 for major matrix)
  input  logic  irow_decfail [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;
  input  logic  irow_minfail [pROW_BY_CYCLE][pLLR_BY_CYCLE] ;
  //
  output logic  oval                                        ;
  output logic  opre_val                                    ; // look ahead oval
  output logic  odecfail                                    ;
  output logic  odecfail_est                                ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cROW_LINE_ERR_MAX  = pROW_BY_CYCLE * pLLR_BY_CYCLE;

  localparam int cROW_ERR_MAX       = pCODE * cZC_MAX;
  localparam int cROW_ERR_W         = $clog2(cROW_ERR_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // major matrix
  logic                           decfail [pROW_BY_CYCLE] ;

  // all matrix count
  logic                           rowerr_cnt__ival    ;
  logic                           rowerr_cnt__isop    ;
  logic                           rowerr_cnt__ieop    ;
  logic [cROW_LINE_ERR_MAX-1 : 0] rowerr_cnt__ibiterr ;
  //
  logic                           rowerr_cnt__oval    ;
  logic        [cROW_ERR_W-1 : 0] rowerr_cnt__oerr    ;

  //
  logic [cROW_ERR_W-1 : 0] checks;
  logic                    checks_val;

  //------------------------------------------------------------------------------------------------------
  // major matrix decfail counting. parity mask is inverted & same for all row(!!!)
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int row = 0; row < pROW_BY_CYCLE; row++) begin
      decfail[row] = ipmask[row][0] & get_row_decfail(irow_decfail[row], irow_minfail[row]);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        if (istrb.sof & istrb.sop) begin
          odecfail <= get_decfail(decfail);
        end
        else begin
          odecfail <= odecfail | get_decfail(decfail);
        end
      end
    end
  end

  function logic get_row_decfail (input logic decfail [pLLR_BY_CYCLE], minfail [pLLR_BY_CYCLE]);
    get_row_decfail = '0;
    for (int llr = 0; llr < pLLR_BY_CYCLE; llr++) begin
      get_row_decfail |= decfail[llr] | minfail[llr];
    end
  endfunction

  function logic get_decfail (input logic decfail [pROW_BY_CYCLE]);
    get_decfail = '0;
    for (int row = 0; row < pROW_BY_CYCLE; row++) begin
      get_decfail |= decfail[row];
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // row decfail -> check failed number counting
  //------------------------------------------------------------------------------------------------------

  codec_biterr_cnt
  #(
    .pBIT_ERR_W ( cROW_LINE_ERR_MAX ) ,
    .pERR_W     ( cROW_ERR_W        )
  )
  rowerr_cnt
  (
    .iclk    ( iclk                ) ,
    .ireset  ( ireset              ) ,
    .iclkena ( iclkena             ) ,
    //
    .ival    ( rowerr_cnt__ival    ) ,
    .isop    ( rowerr_cnt__isop    ) ,
    .ieop    ( rowerr_cnt__ieop    ) ,
    .ibiterr ( rowerr_cnt__ibiterr ) ,
    //
    .oval    ( rowerr_cnt__oval    ) ,
    .oerr    ( rowerr_cnt__oerr    )
  );

  assign rowerr_cnt__ival = ival ;
  assign rowerr_cnt__isop = istrb.sof & istrb.sop ;
  assign rowerr_cnt__ieop = istrb.eof & istrb.eop ;

  always_comb begin
    rowerr_cnt__ibiterr = '0;
    //
    for (int row = 0; row < pROW_BY_CYCLE; row++) begin
      for (int llr = 0; llr < pLLR_BY_CYCLE; llr++) begin
        rowerr_cnt__ibiterr[row*pLLR_BY_CYCLE + llr] = irow_decfail[row][llr];
      end
    end
  end

  assign checks     = rowerr_cnt__oerr;
  assign checks_val = rowerr_cnt__oval;

  //------------------------------------------------------------------------------------------------------
  // decision
  //------------------------------------------------------------------------------------------------------

  // checks
  logic            [1 : 0] pre_checks_val;
  logic [cROW_ERR_W-1 : 0] pre_checks [2];

  wire pre_checks_sames = (checks == pre_checks[0]) & (pre_checks[0] == pre_checks[1]);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (istart) begin
        if (iload_mode) begin
          pre_checks_val  <= '0;
          pre_checks      <= '{default : '0};
        end
        else begin
          pre_checks_val  <= (pre_checks_val << 1) | 1'b1;
          pre_checks[0]   <= checks;
          pre_checks[1]   <= pre_checks[0];
        end
      end
      //
      oval <= checks_val;
      // estimated decfail
      case (pre_checks_val)
        2'b11 : begin
          odecfail_est <= odecfail | ((checks != 0) & !pre_checks_sames);
        end
        default : begin
          odecfail_est <= odecfail | (checks != 0);
        end
      endcase
    end
  end

  assign opre_val = checks_val;

endmodule
