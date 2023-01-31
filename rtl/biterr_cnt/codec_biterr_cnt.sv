/*



  parameter int pBIT_ERR_W = 36 ;
  parameter int pERR_W     = 16 ;



  logic                    codec_biterr_cnt__iclk    ;
  logic                    codec_biterr_cnt__ireset  ;
  logic                    codec_biterr_cnt__iclkena ;
  //
  logic                    codec_biterr_cnt__ival    ;
  logic                    codec_biterr_cnt__isop    ;
  logic                    codec_biterr_cnt__ieop    ;
  logic [pBIT_ERR_W-1 : 0] codec_biterr_cnt__ibiterr ;
  //
  logic                    codec_biterr_cnt__oval    ;
  logic     [pERR_W-1 : 0] codec_biterr_cnt__oerr    ;



  codec_biterr_cnt
  #(
    .pBIT_ERR_W ( pBIT_ERR_W ) ,
    .pERR_W     ( pERR_W     )
  )
  codec_biterr_cnt
  (
    .iclk    ( codec_biterr_cnt__iclk    ) ,
    .ireset  ( codec_biterr_cnt__ireset  ) ,
    .iclkena ( codec_biterr_cnt__iclkena ) ,
    //
    .ival    ( codec_biterr_cnt__ival    ) ,
    .isop    ( codec_biterr_cnt__isop    ) ,
    .ieop    ( codec_biterr_cnt__ieop    ) ,
    .ibiterr ( codec_biterr_cnt__ibiterr ) ,
    //
    .oval    ( codec_biterr_cnt__oval    ) ,
    .oerr    ( codec_biterr_cnt__oerr    )
  );


  assign codec_biterr_cnt__iclk    = '0 ;
  assign codec_biterr_cnt__ireset  = '0 ;
  assign codec_biterr_cnt__iclkena = '0 ;
  assign codec_biterr_cnt__ival    = '0 ;
  assign codec_biterr_cnt__isop    = '0 ;
  assign codec_biterr_cnt__ieop    = '0 ;
  assign codec_biterr_cnt__ibiterr = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_biterr_cnt.sv
// Description   : wide bit vector error counter & accumulator
//

module codec_biterr_cnt
#(
  parameter int pBIT_ERR_W = 36 ,
  parameter int pERR_W     = 16
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

  input  logic                    iclk    ;
  input  logic                    ireset  ;
  input  logic                    iclkena ;
  //
  input  logic                    ival    ;
  input  logic                    isop    ;
  input  logic                    ieop    ;
  input  logic [pBIT_ERR_W-1 : 0] ibiterr ;
  //
  output logic                    oval    ;
  output logic     [pERR_W-1 : 0] oerr    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cSUM_36_NUM      = (pBIT_ERR_W/36) + ((pBIT_ERR_W % 36) != 0);

  localparam int cBIT_ERR_W       = cSUM_36_NUM * 36;

  localparam int cADDER_TREE_NUM  = 2**$clog2(cSUM_36_NUM);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  //
  // 36 bits addres
  logic                    sum__ival                 ;
  logic                    sum__isop                 ;
  logic                    sum__ieop                 ;
  logic           [35 : 0] sum__ibiterr [cSUM_36_NUM];
  //
  logic                    sum__oval    [cSUM_36_NUM];
  logic                    sum__osop    [cSUM_36_NUM];
  logic                    sum__oeop    [cSUM_36_NUM];
  logic     [pERR_W-1 : 0] sum__oerr    [cSUM_36_NUM];

  //
  // adder tree
  logic                    adder__ival                    ;
  logic                    adder__isop                    ;
  logic                    adder__ieop                    ;
  logic     [pERR_W-1 : 0] adder__ierr  [cADDER_TREE_NUM] ;
  //
  logic                    adder__oval                    ;
  logic                    adder__osop                    ;
  logic                    adder__oeop                    ;
  logic     [pERR_W-1 : 0] adder__oerr                    ;

  //------------------------------------------------------------------------------------------------------
  // data remap
  //------------------------------------------------------------------------------------------------------

  assign sum__ival = ival ;
  assign sum__isop = isop ;
  assign sum__ieop = ieop ;

  always_comb begin
    logic [cBIT_ERR_W-1 : 0] bvector;
    //
    bvector = ibiterr; // unsigned extended
    for (int i = 0; i < cSUM_36_NUM; i++) begin
      sum__ibiterr[i] = bvector[i*36 +: 36];
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
  assign adder__isop = sum__osop[0] ;
  assign adder__ieop = sum__oeop[0] ;

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
  // accumulator
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oval <= adder__oval & adder__oeop;
      if (adder__oval) begin
        oerr <= adder__osop ? adder__oerr : (oerr + adder__oerr);
      end
    end
  end

endmodule
