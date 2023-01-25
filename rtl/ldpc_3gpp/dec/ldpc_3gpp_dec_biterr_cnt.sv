/*



  parameter int pLLR_BY_CYCLE =  1 ;
  parameter int pCOL_BY_CYCLE =  1 ;
  parameter int pERR_W        = 16 ;



  logic                       ldpc_3gpp_dec_biterr_cnt__iclk                    ;
  logic                       ldpc_3gpp_dec_biterr_cnt__ireset                  ;
  logic                       ldpc_3gpp_dec_biterr_cnt__iclkena                 ;
  //
  logic                       ldpc_3gpp_dec_biterr_cnt__ival                    ;
  logic                       ldpc_3gpp_dec_biterr_cnt__isop                    ;
  logic                       ldpc_3gpp_dec_biterr_cnt__ieop                    ;
  logic [pLLR_BY_CYCLE-1 : 0] ldpc_3gpp_dec_biterr_cnt__ibiterr [pCOL_BY_CYCLE] ;
  //
  logic                       ldpc_3gpp_dec_biterr_cnt__oval                    ;
  logic        [pERR_W-1 : 0] ldpc_3gpp_dec_biterr_cnt__oerr                    ;



  ldpc_3gpp_dec_biterr_cnt
  #(
    .pLLR_BY_CYCLE ( pLLR_BY_CYCLE ) ,
    .pCOL_BY_CYCLE ( pCOL_BY_CYCLE ) ,
    .pERR_W        ( pERR_W        )
  )
  ldpc_3gpp_dec_biterr_cnt
  (
    .iclk    ( ldpc_3gpp_dec_biterr_cnt__iclk    ) ,
    .ireset  ( ldpc_3gpp_dec_biterr_cnt__ireset  ) ,
    .iclkena ( ldpc_3gpp_dec_biterr_cnt__iclkena ) ,
    //
    .ival    ( ldpc_3gpp_dec_biterr_cnt__ival    ) ,
    .isop    ( ldpc_3gpp_dec_biterr_cnt__isop    ) ,
    .ieop    ( ldpc_3gpp_dec_biterr_cnt__ieop    ) ,
    .ibiterr ( ldpc_3gpp_dec_biterr_cnt__ibiterr ) ,
    //
    .oval    ( ldpc_3gpp_dec_biterr_cnt__oval    ) ,
    .oerr    ( ldpc_3gpp_dec_biterr_cnt__oerr    )
  );


  assign ldpc_3gpp_dec_biterr_cnt__iclk    = '0 ;
  assign ldpc_3gpp_dec_biterr_cnt__ireset  = '0 ;
  assign ldpc_3gpp_dec_biterr_cnt__iclkena = '0 ;
  assign ldpc_3gpp_dec_biterr_cnt__ival    = '0 ;
  assign ldpc_3gpp_dec_biterr_cnt__isop    = '0 ;
  assign ldpc_3gpp_dec_biterr_cnt__ieop    = '0 ;
  assign ldpc_3gpp_dec_biterr_cnt__ibiterr = '0 ;



*/

//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_biterr_cnt.sv
// Description   : wide bit vector error counter & accumulator
//

module ldpc_3gpp_dec_biterr_cnt
#(
  parameter int pLLR_BY_CYCLE =  1 ,
  parameter int pCOL_BY_CYCLE = 26 ,
  parameter int pERR_W        = 16
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  ieop    ,
  ibiterr ,
  //
  oval    ,
  oerr
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk                    ;
  input  logic                       ireset                  ;
  input  logic                       iclkena                 ;
  //
  input  logic                       ival                    ;
  input  logic                       isop                    ;
  input  logic                       ieop                    ;
  input  logic [pLLR_BY_CYCLE-1 : 0] ibiterr [pCOL_BY_CYCLE] ;
  //
  output logic                       oval                    ;
  output logic        [pERR_W-1 : 0] oerr                    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBIT_ERR_MAX = pCOL_BY_CYCLE * pLLR_BY_CYCLE;

  localparam int cSUM_36_NUM  = (cBIT_ERR_MAX/36) + ((cBIT_ERR_MAX % 36) != 0);

  localparam int cBIT_ERR_W   = cSUM_36_NUM * 36;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic              [3 : 0] val;
  logic              [3 : 0] sop;
  logic              [3 : 0] eop;
  logic   [cBIT_ERR_W-1 : 0] biterr_vector;

  logic                      biterr_val;
  logic                      biterr_sop;
  logic                      biterr_eop;
  logic       [pERR_W-1 : 0] biterr;

  //
  // 36 bits addres
  logic                      sum__ival    [cSUM_36_NUM];
  logic             [35 : 0] sum__ibiterr [cSUM_36_NUM];
  //
  logic                      sum__oval    [cSUM_36_NUM];
  logic       [pERR_W-1 : 0] sum__oerr    [cSUM_36_NUM];

  //------------------------------------------------------------------------------------------------------
  // data remap
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    biterr_vector = '0;
    for (int col = 0; col < pCOL_BY_CYCLE; col++) begin
      for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
        biterr_vector[col*pLLR_BY_CYCLE +: pLLR_BY_CYCLE] = ibiterr[col];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // input 36 bits adders :: 1 tick delay
  //------------------------------------------------------------------------------------------------------

  generate
    genvar g;
    for (g = 0; g < cSUM_36_NUM; g++) begin : gen_sum_36_inst
      ldpc_3gpp_dec_biterr_sum_36
      #(
        .pERR_W ( pERR_W )
      )
      sum
      (
        .iclk    ( iclk    ) ,
        .ireset  ( ireset  ) ,
        .iclkena ( iclkena ) ,
        //
        .ival    ( sum__ival    [g] ) ,
        .ibiterr ( sum__ibiterr [g] ) ,
        //
        .oval    ( sum__oval    [g] ) ,
        .oerr    ( sum__oerr    [g] )
      );

      assign sum__ival    [g] = ival ;
      assign sum__ibiterr [g] = biterr_vector[g*36 +: 36] ;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= '0;
    end
    else if (iclkena) begin
      val <= (val << 1) | ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= (sop << 1) | isop;
      eop <= (eop << 1) | ieop;
    end
  end

  generate
    if      (pLLR_BY_CYCLE == 1) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          biterr <= sum__oerr[0];
        end
      end
      //
      assign biterr_val = val[1];
      assign biterr_sop = sop[1];
      assign biterr_eop = eop[1];
    end
    else if (pLLR_BY_CYCLE == 2) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          biterr <= sum__oerr[0] + sum__oerr[1];
        end
      end
      //
      assign biterr_val = val[1];
      assign biterr_sop = sop[1];
      assign biterr_eop = eop[1];
    end
    else if (pLLR_BY_CYCLE == 4) begin
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          biterr <= sum__oerr[0] + sum__oerr[1] + sum__oerr[2];
        end
      end
      //
      assign biterr_val = val[1];
      assign biterr_sop = sop[1];
      assign biterr_eop = eop[1];
    end
    else if (pLLR_BY_CYCLE == 8) begin // 2 line sum
      logic [pERR_W-1 : 0] sum[2];
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          sum[0] <= sum__oerr[0] + sum__oerr[1] + sum__oerr[2];
          sum[1] <= sum__oerr[3] + sum__oerr[4] + sum__oerr[5];
          //
          biterr <= sum[0] + sum[1];
        end
      end
      //
      assign biterr_val = val[2];
      assign biterr_sop = sop[2];
      assign biterr_eop = eop[2];
    end
    else if (pLLR_BY_CYCLE == 16) begin // 3 line sum
      logic [pERR_W-1 : 0] sum0[4];
      logic [pERR_W-1 : 0] sum1[2];
      //
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          sum0[0] <= sum__oerr[0] + sum__oerr[ 1] + sum__oerr[ 2];
          sum0[1] <= sum__oerr[3] + sum__oerr[ 4] + sum__oerr[ 5];
          sum0[2] <= sum__oerr[6] + sum__oerr[ 7] + sum__oerr[ 8];
          sum0[3] <= sum__oerr[9] + sum__oerr[10] + sum__oerr[11];
          //
          sum1[0] <= sum0[0] + sum0[1];
          sum1[1] <= sum0[2] + sum0[3];
          //
          biterr  <= sum1[0] + sum1[1];
        end
      end
      //
      assign biterr_val = val[3];
      assign biterr_sop = sop[3];
      assign biterr_eop = eop[3];
    end
    else begin
      assign biterr[-1] = 1'bz; // incorrect pLLR_BY_CYCLE using
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // accumulator
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oval <= biterr_val & biterr_eop;
      if (biterr_val) begin
        oerr <= biterr_sop ? biterr : (oerr + biterr);
      end
    end
  end

endmodule
