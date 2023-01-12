/*


  parameter int pBMAX     = 12 ;
  parameter int pDAT_W    =  8 ;
  parameter int pLLR_W    =  4 ;
  parameter bit pUSE_RAMB =  0 ;



  logic                       llr_odd_qam_demapper__iclk            ;
  logic                       llr_odd_qam_demapper__ireset          ;
  logic                       llr_odd_qam_demapper__iclkena         ;
  logic                       llr_odd_qam_demapper__ival            ;
  logic                       llr_odd_qam_demapper__isop            ;
  logic               [3 : 0] llr_odd_qam_demapper__iqam            ;
  logic signed [pDAT_W-1 : 0] llr_odd_qam_demapper__idat_re         ;
  logic signed [pDAT_W-1 : 0] llr_odd_qam_demapper__idat_im         ;
  logic                       llr_odd_qam_demapper__oval            ;
  logic                       llr_odd_qam_demapper__osop            ;
  logic               [3 : 0] llr_odd_qam_demapper__oqam            ;
  logic signed [pLLR_W-1 : 0] llr_odd_qam_demapper__oLLR   [0 : 11] ;



  llr_odd_qam_demapper
  #(
    .pBMAX     ( pBMAX     ) ,
    .pDAT_W    ( pDAT_W    ) ,
    .pLLR_W    ( pLLR_W    ) ,
    .pUSE_RAMB ( pUSE_RAMB )
  )
  llr_odd_qam_demapper
  (
    .iclk    ( llr_odd_qam_demapper__iclk    ) ,
    .ireset  ( llr_odd_qam_demapper__ireset  ) ,
    .iclkena ( llr_odd_qam_demapper__iclkena ) ,
    .ival    ( llr_odd_qam_demapper__ival    ) ,
    .isop    ( llr_odd_qam_demapper__isop    ) ,
    .iqam    ( llr_odd_qam_demapper__iqam    ) ,
    .idat_re ( llr_odd_qam_demapper__idat_re ) ,
    .idat_im ( llr_odd_qam_demapper__idat_im ) ,
    .oval    ( llr_odd_qam_demapper__oval    ) ,
    .osop    ( llr_odd_qam_demapper__osop    ) ,
    .oqam    ( llr_odd_qam_demapper__oqam    ) ,
    .oLLR    ( llr_odd_qam_demapper__oLLR    )
  );


  assign llr_odd_qam_demapper__iclk    = '0 ;
  assign llr_odd_qam_demapper__ireset  = '0 ;
  assign llr_odd_qam_demapper__iclkena = '0 ;
  assign llr_odd_qam_demapper__ival    = '0 ;
  assign llr_odd_qam_demapper__isop    = '0 ;
  assign llr_odd_qam_demapper__iqam    = '0 ;
  assign llr_odd_qam_demapper__idat_re = '0 ;
  assign llr_odd_qam_demapper__idat_im = '0 ;



*/

//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      : llr_odd_qam_demapper.sv
// Description   : Static configurated top level odd qam (BPSK, 8PSK, QAM32, QAM128, QAM512, QAM2048) LLR demapper for LLR == 4 bits only
//                 Module work with LSB first endian. Module delay is 5+2 tick.
//
//                 the actual parameter table
//
//                 pBMAX <= 4  -> pDAT_W >= 5
//                 pBMAX <= 6  -> pDAT_W >= 6
//                 pBMAX <= 8  -> pDAT_W >= 7
//                 pBMAX <= 10 -> pDAT_W >= 8
//                 pBMAX <= 12 -> pDAT_W >= 9
//

module llr_odd_qam_demapper
#(
  parameter int pBMAX     = 12 ,
  parameter int pDAT_W    =  9 , // fixed, don't change
  parameter int pLLR_W    =  4 , // fixed, don't change
  parameter bit pUSE_RAMB =  1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ival    ,
  isop    ,
  iqam    ,
  idat_re ,
  idat_im ,
  //
  oval    ,
  osop    ,
  oqam    ,
  oLLR
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                       iclk            ;
  input  logic                       ireset          ;
  input  logic                       iclkena         ;
  //
  input  logic                       ival            ;
  input  logic                       isop            ;
  input  logic               [3 : 0] iqam            ;
  input  logic signed [pDAT_W-1 : 0] idat_re         ;
  input  logic signed [pDAT_W-1 : 0] idat_im         ;
  //
  output logic                       oval            ;
  output logic                       osop            ;
  output logic               [3 : 0] oqam            ;
  output logic signed [pLLR_W-1 : 0] oLLR   [0 : 11] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------


  logic                val;
  logic                sop;
  logic        [3 : 0] qam;
  logic [pDAT_W-1 : 0] dat_re;
  logic [pDAT_W-1 : 0] dat_im;

  logic signed [4 : 0] bpsk_8psk_demapper__idat_re  ;
  logic signed [4 : 0] bpsk_8psk_demapper__idat_im  ;
  logic signed [3 : 0] bpsk_8psk_demapper__oLLR [3] ;

  logic signed [5 : 0] qam32_demapper__idat_re      ;
  logic signed [5 : 0] qam32_demapper__idat_im      ;
  logic                qam32_demapper__oval         ;
  logic                qam32_demapper__osop         ;
  logic        [3 : 0] qam32_demapper__oqam         ;
  logic signed [3 : 0] qam32_demapper__oLLR     [5] ;

  logic signed [6 : 0] qam128_demapper__idat_re     ;
  logic signed [6 : 0] qam128_demapper__idat_im     ;
  logic signed [3 : 0] qam128_demapper__oLLR    [7] ;

  logic signed [7 : 0] qam512_demapper__idat_re     ;
  logic signed [7 : 0] qam512_demapper__idat_im     ;
  logic signed [3 : 0] qam512_demapper__oLLR    [9] ;

  logic signed [8 : 0] qam2048_demapper__idat_re    ;
  logic signed [8 : 0] qam2048_demapper__idat_im    ;
  logic signed [3 : 0] qam2048_demapper__oLLR  [11] ;

  //------------------------------------------------------------------------------------------------------
  // delay yo align with even qam demapper
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      val    <= ival;
      sop    <= isop;
      qam    <= iqam;
      dat_re <= idat_re;
      dat_im <= idat_im;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // bpsk/8psk
  //------------------------------------------------------------------------------------------------------

  llr_bpsk_8psk_demapper
  #(
    .pDAT_W ( 5 ) ,
    .pLLR_W ( 4 )
  )
  bpsk_8psk_demapper
  (
    .iclk    ( iclk                        ) ,
    .ireset  ( ireset                      ) ,
    .iclkena ( iclkena                     ) ,
    //
    .ival    ( val                         ) ,
    .isop    ( sop                         ) ,
    .iqam    ( qam                         ) ,
    .idat_re ( bpsk_8psk_demapper__idat_re ) ,
    .idat_im ( bpsk_8psk_demapper__idat_im ) ,
    //
    .oval    (  ) , // n.u.
    .osop    (  ) , // n.u.
    .oqam    (  ) , // n.u.
    .oLLR    ( bpsk_8psk_demapper__oLLR )
  );

  // register is inside module
  generate
    if (pDAT_W > 5) begin
      assign bpsk_8psk_demapper__idat_re = dat_re[pDAT_W-1 -: 5] + ((dat_re[pDAT_W-1 -: 5] == 5'b0_1111) ? 1'b0 : dat_re[pDAT_W-6]); // look ahead saturation like
      assign bpsk_8psk_demapper__idat_im = dat_im[pDAT_W-1 -: 5] + ((dat_im[pDAT_W-1 -: 5] == 5'b0_1111) ? 1'b0 : dat_im[pDAT_W-6]); // look ahead saturation like
    end
    else begin
      assign bpsk_8psk_demapper__idat_re = dat_re;
      assign bpsk_8psk_demapper__idat_im = dat_im;
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // qam32
  //------------------------------------------------------------------------------------------------------

  generate
    if (pBMAX > 4) begin
      llr_qam32_demapper
      #(
        .pUSE_RAMB ( pUSE_RAMB )
      )
      qam32_demapper
      (
        .iclk    ( iclk                    ) ,
        .ireset  ( ireset                  ) ,
        .iclkena ( iclkena                 ) ,
        //
        .ival    ( val                     ) ,
        .isop    ( sop                     ) ,
        .iqam    ( qam                     ) ,
        .idat_re ( qam32_demapper__idat_re ) ,
        .idat_im ( qam32_demapper__idat_im ) ,
        //
        .oval    ( qam32_demapper__oval    ) ,
        .osop    ( qam32_demapper__osop    ) ,
        .oqam    ( qam32_demapper__oqam    ) ,
        .oLLR    ( qam32_demapper__oLLR    )
      );

      // register is inside module
      if (pDAT_W > 6) begin
        assign qam32_demapper__idat_re = dat_re[pDAT_W-1 -: 6] + ((dat_re[pDAT_W-1 -: 6] == 6'b01_1111) ? 1'b0 : dat_re[pDAT_W-7]); // look ahead saturation like
        assign qam32_demapper__idat_im = dat_im[pDAT_W-1 -: 6] + ((dat_im[pDAT_W-1 -: 6] == 6'b01_1111) ? 1'b0 : dat_im[pDAT_W-7]); // look ahead saturation like
      end
      else begin
        assign qam32_demapper__idat_re = dat_re;
        assign qam32_demapper__idat_im = dat_im;
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // qam128
  //------------------------------------------------------------------------------------------------------

  generate
    if (pBMAX > 6) begin
      llr_qam128_demapper
      #(
        .pUSE_RAMB ( pUSE_RAMB )
      )
      qam128_demapper
      (
        .iclk    ( iclk                     ) ,
        .ireset  ( ireset                   ) ,
        .iclkena ( iclkena                  ) ,
        //
        .ival    ( val                      ) ,
        .isop    ( sop                      ) ,
        .iqam    ( qam                      ) ,
        .idat_re ( qam128_demapper__idat_re ) ,
        .idat_im ( qam128_demapper__idat_im ) ,
        //
        .oval    (  ) , // n.u.
        .osop    (  ) , // n.u.
        .oqam    (  ) , // n.u.
        .oLLR    ( qam128_demapper__oLLR )
      );

      // register is inside module
      if (pDAT_W > 7) begin
        assign qam128_demapper__idat_re = dat_re[pDAT_W-1 -: 7] + ((dat_re[pDAT_W-1 -: 7] == 7'b011_1111) ? 1'b0 : dat_re[pDAT_W-8]); // look ahead saturation like
        assign qam128_demapper__idat_im = dat_im[pDAT_W-1 -: 7] + ((dat_im[pDAT_W-1 -: 7] == 7'b011_1111) ? 1'b0 : dat_im[pDAT_W-8]); // look ahead saturation like
      end
      else begin
        assign qam128_demapper__idat_re = dat_re;
        assign qam128_demapper__idat_im = dat_im;
      end
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // qam512
  //------------------------------------------------------------------------------------------------------

  generate
    if (pBMAX > 8) begin
      llr_qam512_demapper
      #(
        .pUSE_RAMB ( pUSE_RAMB )
      )
      qam512_demapper
      (
        .iclk    ( iclk    ) ,
        .ireset  ( ireset  ) ,
        .iclkena ( iclkena ) ,
        //
        .ival    ( val                      ) ,
        .isop    ( sop                      ) ,
        .iqam    ( qam                      ) ,
        .idat_re ( qam512_demapper__idat_re ) ,
        .idat_im ( qam512_demapper__idat_im ) ,
        //
        .oval    (  ) , // n.u.
        .osop    (  ) , // n.u.
        .oqam    (  ) , // n.u.
        .oLLR    ( qam512_demapper__oLLR    )
      );

      // register is inside module
      if (pDAT_W > 8) begin
        assign qam512_demapper__idat_re = dat_re[pDAT_W-1 -: 8] + ((dat_re[pDAT_W-1 -: 8] == 8'b0111_1111) ? 1'b0 : dat_re[pDAT_W-9]); // look ahead saturation like
        assign qam512_demapper__idat_im = dat_im[pDAT_W-1 -: 8] + ((dat_im[pDAT_W-1 -: 8] == 8'b0111_1111) ? 1'b0 : dat_im[pDAT_W-9]); // look ahead saturation like
      end
      else begin
        assign qam512_demapper__idat_re = dat_re;
        assign qam512_demapper__idat_im = dat_im;
      end

    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // qam2048
  //------------------------------------------------------------------------------------------------------

  generate
    if (pBMAX > 10) begin
      llr_qam2048_demapper
      #(
        .pUSE_RAMB ( pUSE_RAMB )
      )
      qam2048_demapper
      (
        .iclk    ( iclk    ) ,
        .ireset  ( ireset  ) ,
        .iclkena ( iclkena ) ,
        //
        .ival    ( val                       ) ,
        .isop    ( sop                       ) ,
        .iqam    ( qam                       ) ,
        .idat_re ( qam2048_demapper__idat_re ) ,
        .idat_im ( qam2048_demapper__idat_im ) ,
        //
        .oval    (  ) , // n.u.
        .osop    (  ) , // n.u.
        .oqam    (  ) , // n.u.
        .oLLR    ( qam2048_demapper__oLLR    )
      );

      assign qam2048_demapper__idat_re = dat_re;
      assign qam2048_demapper__idat_im = dat_im;

    end
  endgenerate


  //------------------------------------------------------------------------------------------------------
  // output muxer
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= qam32_demapper__oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (qam32_demapper__oval) begin
        osop <= qam32_demapper__osop;
        oqam <= qam32_demapper__oqam;
        //
        oLLR[11]     <= '0;
        oLLR[0 : 10] <= qam2048_demapper__oLLR;
        case (qam32_demapper__oqam)
          4'd1    : oLLR[0]     <= bpsk_8psk_demapper__oLLR[0];
          4'd3    : oLLR[0 : 2] <= bpsk_8psk_demapper__oLLR;
          4'd5    : begin
            if (pBMAX > 4) begin
              oLLR[0 : 4] <= qam32_demapper__oLLR;
            end
          end
          4'd7    : begin
            if (pBMAX > 6) begin
              oLLR[0 : 6] <= qam128_demapper__oLLR;
            end
          end
          4'd9    : begin
            if (pBMAX > 8) begin
              oLLR[0 : 8] <= qam512_demapper__oLLR;
            end
          end
        endcase
      end
    end
  end

endmodule
