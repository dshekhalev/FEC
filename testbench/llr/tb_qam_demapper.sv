//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : tb_qam_demapper.sv
// Description   : testbench for qams mapper/demapper
//

module tb_qam_demapper ;

  parameter int pBMAX   = 12 ;
  parameter int pDAT_W  =  9 ;
  parameter int pLLR_W  =  4 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit                         iclk            ;
  bit                         ireset          ;
  bit                         iclkena         ;
  //
  logic                       isop             ;
  logic                       ival             ;
  logic                       ieop             ;
  logic              [3 : 0]  iqam             ;
  logic        [pBMAX-1 : 0]  idat             ;
  //
  logic                       mapper__osop     ;
  logic                       mapper__oval     ;
  logic                       mapper__oeop     ;
  logic              [3 : 0]  mapper__oqam     ;
  logic      [pBMAX/2-1 : 0]  mapper__odat_re  ;
  logic      [pBMAX/2-1 : 0]  mapper__odat_im  ;
  //
  logic                       demapper__ival    ;
  logic                       demapper__isop    ;
  logic               [3 : 0] demapper__iqam    ;
  logic signed [pDAT_W-1 : 0] demapper__idat_re ;
  logic signed [pDAT_W-1 : 0] demapper__idat_im ;
  //
  logic                       even_qam__oval             ;
  logic                       even_qam__osop             ;
  logic               [3 : 0] even_qam__oqam             ;
  logic signed [pLLR_W-1 : 0] even_qam__oLLR    [0 : 11] ;
  //
  logic                       odd_qam__oval             ;
  logic                       odd_qam__osop             ;
  logic               [3 : 0] odd_qam__oqam             ;
  logic signed [pLLR_W-1 : 0] odd_qam__oLLR    [0 : 11] ;

  //------------------------------------------------------------------------------------------------------
  // bit mapper
  //------------------------------------------------------------------------------------------------------

  gray_bit_mapper
  #(
    .pBMAX ( pBMAX )
  )
  mapper
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .isop    ( isop    ) ,
    .ival    ( ival    ) ,
    .ieop    ( ieop    ) ,
    .iqam    ( iqam    ) ,
    .idat    ( idat    ) ,
    //
    .osop    ( mapper__osop    ) ,
    .oval    ( mapper__oval    ) ,
    .oeop    ( mapper__oeop    ) ,
    .oqam    ( mapper__oqam    ) ,
    .odat_re ( mapper__odat_re ) ,
    .odat_im ( mapper__odat_im )
  );

  //------------------------------------------------------------------------------------------------------
  // modulator
  //------------------------------------------------------------------------------------------------------

  localparam int cQPSK_POINT = 2**(pDAT_W-2);

  assign demapper__ival = mapper__oval;
  assign demapper__isop = mapper__osop;
  assign demapper__iqam = mapper__oqam;

  always_comb begin
    demapper__idat_re = '0;
    demapper__idat_im = '0;
    case (mapper__oqam)
      1  : begin
        demapper__idat_re = do_qpsk_modulation(mapper__odat_re[0]);
        demapper__idat_im = do_qpsk_modulation(mapper__odat_im[0]);
      end
      2  : begin
        demapper__idat_re = do_qpsk_modulation(mapper__odat_re[0]);
        demapper__idat_im = do_qpsk_modulation(mapper__odat_im[0]);
      end
      3 : begin
        demapper__idat_re = do_8psk_modulation(mapper__odat_re[1 : 0]);
        demapper__idat_im = do_8psk_modulation(mapper__odat_im[1 : 0]);
      end
      4 : begin
        demapper__idat_re = do_qam16_modulation(mapper__odat_re[1 : 0]);
        demapper__idat_im = do_qam16_modulation(mapper__odat_im[1 : 0]);
      end
      5 : begin
        demapper__idat_re = do_qam32_modulation(mapper__odat_re[2 : 0]);
        demapper__idat_im = do_qam32_modulation(mapper__odat_im[2 : 0]);
      end
      6 : begin
        demapper__idat_re = do_qam64_modulation(mapper__odat_re[2 : 0]);
        demapper__idat_im = do_qam64_modulation(mapper__odat_im[2 : 0]);
      end
      7 : begin
        demapper__idat_re = do_qam128_modulation(mapper__odat_re[3 : 0]);
        demapper__idat_im = do_qam128_modulation(mapper__odat_im[3 : 0]);
      end
      8 : begin
        demapper__idat_re = do_qam256_modulation(mapper__odat_re[3 : 0]);
        demapper__idat_im = do_qam256_modulation(mapper__odat_im[3 : 0]);
      end
      9 : begin
        demapper__idat_re = do_qam512_modulation(mapper__odat_re[4 : 0]);
        demapper__idat_im = do_qam512_modulation(mapper__odat_im[4 : 0]);
      end
      10 : begin
        demapper__idat_re = do_qam1024_modulation(mapper__odat_re[4 : 0]);
        demapper__idat_im = do_qam1024_modulation(mapper__odat_im[4 : 0]);
      end
      11 : begin
        demapper__idat_re = do_qam2048_modulation(mapper__odat_re[5 : 0]);
        demapper__idat_im = do_qam2048_modulation(mapper__odat_im[5 : 0]);
      end
      12 : begin
        demapper__idat_re = do_qam4096_modulation(mapper__odat_re[5 : 0]);
        demapper__idat_im = do_qam4096_modulation(mapper__odat_im[5 : 0]);
      end
    endcase
  end

  function automatic int do_qpsk_modulation (bit data);
    do_qpsk_modulation = data ? cQPSK_POINT : -cQPSK_POINT;
  endfunction

  function automatic int do_8psk_modulation (bit [1 : 0] data);
    int coe [4] = '{-167, -69, 69, 167}; // cQPSK_POINT/2 * sqrt(2) * cos([1:3]*pi/8)
  begin
    do_8psk_modulation = coe[data];
  end
  endfunction

  function automatic int do_qam16_modulation (bit [1 : 0] data);
    do_qam16_modulation = (-3 + 2*data)*cQPSK_POINT/2;
  endfunction

  function automatic int do_qam32_modulation (bit [2 : 0] data);
    do_qam32_modulation = (-5 + 2*data)*cQPSK_POINT/4;
  endfunction

  function automatic int do_qam64_modulation (bit [2 : 0] data);
    do_qam64_modulation = (-7 + 2*data)*cQPSK_POINT/4;
  endfunction

  function automatic int do_qam128_modulation (bit [3 : 0] data);
    do_qam128_modulation = (-11 + 2*data)*cQPSK_POINT/8;
  endfunction

  function automatic int do_qam256_modulation (bit [3 : 0] data);
    do_qam256_modulation = (-15 + 2*data)*cQPSK_POINT/8;
  endfunction

  function automatic int do_qam512_modulation (bit [4 : 0] data);
    do_qam512_modulation = (-23 + 2*data)*cQPSK_POINT/16;
  endfunction

  function automatic int do_qam1024_modulation (bit [4 : 0] data);
    do_qam1024_modulation = (-31 + 2*data)*cQPSK_POINT/16;
  endfunction

  function automatic int do_qam2048_modulation (bit [5 : 0] data);
    do_qam2048_modulation = (-47 + 2*data)*cQPSK_POINT/32;
  endfunction

  function automatic int do_qam4096_modulation (bit [5 : 0] data);
    do_qam4096_modulation = (-63 + 2*data)*cQPSK_POINT/32;
  endfunction

  //------------------------------------------------------------------------------------------------------
  // LLR demapper
  //------------------------------------------------------------------------------------------------------

  llr_even_qam_demapper
  #(
    .pBMAX  ( pBMAX  ) ,
    .pDAT_W ( pDAT_W ) ,
    .pLLR_W ( pLLR_W )
  )
  even_qam
  (
    .iclk    ( iclk              ) ,
    .ireset  ( ireset            ) ,
    .iclkena ( iclkena           ) ,
    //
    .ival    ( demapper__ival    ) ,
    .isop    ( demapper__isop    ) ,
    .iqam    ( demapper__iqam    ) ,
    .idat_re ( demapper__idat_re ) ,
    .idat_im ( demapper__idat_im ) ,
    //
    .oval    ( even_qam__oval     ) ,
    .osop    ( even_qam__osop     ) ,
    .oqam    ( even_qam__oqam     ) ,
    .oLLR    ( even_qam__oLLR     )
  );

  llr_odd_qam_demapper
  #(
    .pBMAX     ( pBMAX  ) ,
    .pDAT_W    ( pDAT_W ) ,
    .pLLR_W    ( pLLR_W ) ,
    .pUSE_RAMB ( 1      )
  )
  odd_qam
  (
    .iclk    ( iclk              ) ,
    .ireset  ( ireset            ) ,
    .iclkena ( iclkena           ) ,
    //
    .ival    ( demapper__ival    ) ,
    .isop    ( demapper__isop    ) ,
    .iqam    ( demapper__iqam    ) ,
    .idat_re ( demapper__idat_re ) ,
    .idat_im ( demapper__idat_im ) ,
    //
    .oval    ( odd_qam__oval     ) ,
    .osop    ( odd_qam__osop     ) ,
    .oqam    ( odd_qam__oqam     ) ,
    .oLLR    ( odd_qam__oLLR     )
  );

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  initial begin
    iclk <= 1'b0;
    #5ns forever #5ns iclk = ~iclk;
  end

  assign ireset = 1'b0;
  assign iclkena = 1'b1;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  bit [pBMAX-1 : 0] dat;

  always_comb begin
    dat = '0;
    for (int i = 0; i < pBMAX; i++) begin
      if (i < odd_qam__oqam) begin
        dat[i] = odd_qam__oqam[0] ? (odd_qam__oLLR[i] >= 0) : (even_qam__oLLR[i] >= 0);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  int TEST_BPS_QAM [] = '{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};

  int err;

  initial begin : main
    ival    <= '0;
    isop    <= '0;
    ieop    <= '0;
    idat    <= '0;
    iqam    <= '0;

    repeat (20) @(posedge iclk);

    err = 0;

    fork
      // generator
      begin
        foreach (TEST_BPS_QAM[i]) begin
          iqam <= TEST_BPS_QAM[i];
          for (int b = 0; b < 2**TEST_BPS_QAM[i]; b++) begin
            ival    <= 1'b1;
            idat    <= b;
            @(posedge iclk);
            ival    <= 1'b0;
          end
        end
      end
      // checker
      begin
        foreach (TEST_BPS_QAM[i]) begin
          for (int b = 0; b < 2**TEST_BPS_QAM[i]; b++) begin
            @(posedge iclk iff odd_qam__oval);
            if (b != dat) begin
              err++;
            end
          end
        end
      end
    join


    repeat (20) @(posedge iclk);

    $display("test_done = %0d errors", err);

    $stop;
  end

endmodule
