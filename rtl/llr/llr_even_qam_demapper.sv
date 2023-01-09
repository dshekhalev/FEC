/*


  parameter int pBMAX   = 12 ;
  parameter int pDAT_W  =  8 ;
  parameter int pLLR_W  =  4 ;



  logic                       llr_even_qam_demapper__iclk            ;
  logic                       llr_even_qam_demapper__ireset          ;
  logic                       llr_even_qam_demapper__iclkena         ;
  logic                       llr_even_qam_demapper__ival            ;
  logic                       llr_even_qam_demapper__isop            ;
  logic               [3 : 0] llr_even_qam_demapper__iqam            ;
  logic signed [pDAT_W-1 : 0] llr_even_qam_demapper__idat_re         ;
  logic signed [pDAT_W-1 : 0] llr_even_qam_demapper__idat_im         ;
  logic                       llr_even_qam_demapper__oval            ;
  logic                       llr_even_qam_demapper__osop            ;
  logic               [3 : 0] llr_even_qam_demapper__oqam            ;
  logic signed [pLLR_W-1 : 0] llr_even_qam_demapper__oLLR   [0 : 11] ;



  llr_even_qam_demapper
  #(
    .pBMAX  ( pBMAX  ) ,
    .pDAT_W ( pDAT_W ) ,
    .pLLR_W ( pLLR_W )
  )
  llr_even_qam_demapper
  (
    .iclk    ( llr_even_qam_demapper__iclk    ) ,
    .ireset  ( llr_even_qam_demapper__ireset  ) ,
    .iclkena ( llr_even_qam_demapper__iclkena ) ,
    .ival    ( llr_even_qam_demapper__ival    ) ,
    .isop    ( llr_even_qam_demapper__isop    ) ,
    .iqam    ( llr_even_qam_demapper__iqam    ) ,
    .idat_re ( llr_even_qam_demapper__idat_re ) ,
    .idat_im ( llr_even_qam_demapper__idat_im ) ,
    .oval    ( llr_even_qam_demapper__oval    ) ,
    .osop    ( llr_even_qam_demapper__osop    ) ,
    .oqam    ( llr_even_qam_demapper__oqam    ) ,
    .oLLR    ( llr_even_qam_demapper__oLLR    )
  );


  assign llr_even_qam_demapper__iclk    = '0 ;
  assign llr_even_qam_demapper__ireset  = '0 ;
  assign llr_even_qam_demapper__iclkena = '0 ;
  assign llr_even_qam_demapper__ival    = '0 ;
  assign llr_even_qam_demapper__isop    = '0 ;
  assign llr_even_qam_demapper__iqam    = '0 ;
  assign llr_even_qam_demapper__idat_re = '0 ;
  assign llr_even_qam_demapper__idat_im = '0 ;



*/

//
// Project       : FEC library
// Author        : Shekhalev Denis (des00)
// Workfile      :
// Description   : Static configurated top level even qam (QPSK, QAM16, QAM64, QAM256, QAM1024) LLR demapper
//                 Module work with LSB first endian. Module delay is 6+1 tick.
//

module llr_even_qam_demapper
#(
  parameter int pBMAX   = 12 ,
  parameter int pDAT_W  =  9 , // must be pLLR_W + (bits_per_symbol/2-1)
  parameter int pLLR_W  =  4   //
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

  input  logic                       iclk             ;
  input  logic                       ireset           ;
  input  logic                       iclkena          ;
  //
  input  logic                       ival             ;
  input  logic                       isop             ;
  input  logic               [3 : 0] iqam             ;
  input  logic signed [pDAT_W-1 : 0] idat_re          ;
  input  logic signed [pDAT_W-1 : 0] idat_im          ;
  //
  output logic                       oval             ;
  output logic                       osop             ;
  output logic               [3 : 0] oqam             ;
  output logic signed [pLLR_W-1 : 0] oLLR    [0 : 11] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                       even_qam_llr__oval        ;
  logic                       even_qam_llr__osop        ;
  logic               [3 : 0] even_qam_llr__oqam        ;
  logic signed [pLLR_W-1 : 0] even_qam_llr__oLLR_re [6] ;
  logic signed [pLLR_W-1 : 0] even_qam_llr__oLLR_im [6] ;

  //------------------------------------------------------------------------------------------------------
  // partial demappers
  //------------------------------------------------------------------------------------------------------

  llr_even_qam_demapper_core
  #(
    .pBMAX  ( pBMAX  ) ,
    .pDAT_W ( pDAT_W ) ,
    .pLLR_W ( pLLR_W )
  )
  even_qam_llr_re
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .ival    ( ival    ) ,
    .isop    ( isop    ) ,
    .iqam    ( iqam    ) ,
    .idat    ( idat_re ) ,
    //
    .oval    ( even_qam_llr__oval    ) ,
    .osop    ( even_qam_llr__osop    ) ,
    .oqam    ( even_qam_llr__oqam    ) ,
    .oLLR    ( even_qam_llr__oLLR_re )
  );

  llr_even_qam_demapper_core
  #(
    .pBMAX  ( pBMAX  ) ,
    .pDAT_W ( pDAT_W ) ,
    .pLLR_W ( pLLR_W )
  )
  even_qam_llr_im
  (
    .iclk    ( iclk    ) ,
    .ireset  ( ireset  ) ,
    .iclkena ( iclkena ) ,
    //
    .ival    ( ival    ) ,
    .isop    ( isop    ) ,
    .iqam    ( iqam    ) ,
    .idat    ( idat_im ) ,
    //
    .oval    (  ) , // n.u.
    .osop    (  ) , // n.u.
    .oqam    (  ) , // n.u.
    .oLLR    ( even_qam_llr__oLLR_im )
  );

  //------------------------------------------------------------------------------------------------------
  // assemble units for qams.
  //  remember the bit order is inverted !!! the least index is main
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= even_qam_llr__oval;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      //
      oLLR[11] <= even_qam_llr__oLLR_im[0];
      oLLR[10] <= even_qam_llr__oLLR_im[1];
      oLLR[9]  <= even_qam_llr__oLLR_im[2];
      oLLR[8]  <= even_qam_llr__oLLR_im[3];
      oLLR[7]  <= even_qam_llr__oLLR_im[4];
      oLLR[6]  <= even_qam_llr__oLLR_im[5];

      oLLR[5]  <= even_qam_llr__oLLR_re[0];
      oLLR[4]  <= even_qam_llr__oLLR_re[1];
      oLLR[3]  <= even_qam_llr__oLLR_re[2];
      oLLR[2]  <= even_qam_llr__oLLR_re[3];
      oLLR[1]  <= even_qam_llr__oLLR_re[4];
      oLLR[0]  <= even_qam_llr__oLLR_re[5];
      //
      case (even_qam_llr__oqam)
        2   : begin
          oLLR[1]  <= even_qam_llr__oLLR_im[0];
          oLLR[0]  <= even_qam_llr__oLLR_re[0];
        end
        4   : begin
          oLLR[3]  <= even_qam_llr__oLLR_im[0];
          oLLR[2]  <= even_qam_llr__oLLR_im[1];

          oLLR[1]  <= even_qam_llr__oLLR_re[0];
          oLLR[0]  <= even_qam_llr__oLLR_re[1];
        end
        6   : begin
          if (pBMAX > 4) begin
            oLLR[5]  <= even_qam_llr__oLLR_im[0];
            oLLR[4]  <= even_qam_llr__oLLR_im[1];
            oLLR[3]  <= even_qam_llr__oLLR_im[2];

            oLLR[2]  <= even_qam_llr__oLLR_re[0];
            oLLR[1]  <= even_qam_llr__oLLR_re[1];
            oLLR[0]  <= even_qam_llr__oLLR_re[2];
          end
        end
        8   : begin
          if (pBMAX > 6) begin
            oLLR[7]  <= even_qam_llr__oLLR_im[0];
            oLLR[6]  <= even_qam_llr__oLLR_im[1];
            oLLR[5]  <= even_qam_llr__oLLR_im[2];
            oLLR[4]  <= even_qam_llr__oLLR_im[3];

            oLLR[3]  <= even_qam_llr__oLLR_re[0];
            oLLR[2]  <= even_qam_llr__oLLR_re[1];
            oLLR[1]  <= even_qam_llr__oLLR_re[2];
            oLLR[0]  <= even_qam_llr__oLLR_re[3];
          end
        end
        10  : begin
          if (pBMAX > 8) begin
            oLLR[9]  <= even_qam_llr__oLLR_im[0];
            oLLR[8]  <= even_qam_llr__oLLR_im[1];
            oLLR[7]  <= even_qam_llr__oLLR_im[2];
            oLLR[6]  <= even_qam_llr__oLLR_im[3];
            oLLR[5]  <= even_qam_llr__oLLR_im[4];

            oLLR[4]  <= even_qam_llr__oLLR_re[0];
            oLLR[3]  <= even_qam_llr__oLLR_re[1];
            oLLR[2]  <= even_qam_llr__oLLR_re[2];
            oLLR[1]  <= even_qam_llr__oLLR_re[3];
            oLLR[0]  <= even_qam_llr__oLLR_re[4];
          end
        end
//      12 : begin
//        oLLR[11] <= even_qam_llr__oLLR_im[0];
//        oLLR[10] <= even_qam_llr__oLLR_im[1];
//        oLLR[9]  <= even_qam_llr__oLLR_im[2];
//        oLLR[8]  <= even_qam_llr__oLLR_im[3];
//        oLLR[7]  <= even_qam_llr__oLLR_im[4];
//        oLLR[6]  <= even_qam_llr__oLLR_im[5];
//
//        oLLR[5]  <= even_qam_llr__oLLR_re[0];
//        oLLR[4]  <= even_qam_llr__oLLR_re[1];
//        oLLR[3]  <= even_qam_llr__oLLR_re[2];
//        oLLR[2]  <= even_qam_llr__oLLR_re[3];
//        oLLR[1]  <= even_qam_llr__oLLR_re[4];
//        oLLR[0]  <= even_qam_llr__oLLR_re[5];
//      end
      endcase
      //
      osop <= even_qam_llr__osop;
      oqam <= even_qam_llr__oqam;
    end
  end

endmodule
