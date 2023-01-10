/*



  logic         ccsds_turbo_enc_punct__iclk        ;
  logic         ccsds_turbo_enc_punct__ireset      ;
  logic         ccsds_turbo_enc_punct__iclkena     ;
  logic [1 : 0] ccsds_turbo_enc_punct__icode       ;
  logic         ccsds_turbo_enc_punct__isop        ;
  logic         ccsds_turbo_enc_punct__ival        ;
  logic [3 : 0] ccsds_turbo_enc_punct__idat    [2] ;
  logic         ccsds_turbo_enc_punct__oval        ;
  logic         ccsds_turbo_enc_punct__odat        ;



  ccsds_turbo_enc_punct
  ccsds_turbo_enc_punct
  (
    .iclk    ( ccsds_turbo_enc_punct__iclk    ) ,
    .ireset  ( ccsds_turbo_enc_punct__ireset  ) ,
    .iclkena ( ccsds_turbo_enc_punct__iclkena ) ,
    .icode   ( ccsds_turbo_enc_punct__icode   ) ,
    .isop    ( ccsds_turbo_enc_punct__isop    ) ,
    .ival    ( ccsds_turbo_enc_punct__ival    ) ,
    .idat    ( ccsds_turbo_enc_punct__idat    ) ,
    .oval    ( ccsds_turbo_enc_punct__oval    ) ,
    .odat    ( ccsds_turbo_enc_punct__odat    )
  );


  assign ccsds_turbo_enc_punct__iclk    = '0 ;
  assign ccsds_turbo_enc_punct__ireset  = '0 ;
  assign ccsds_turbo_enc_punct__iclkena = '0 ;
  assign ccsds_turbo_enc_punct__icode   = '0 ;
  assign ccsds_turbo_enc_punct__isop    = '0 ;
  assign ccsds_turbo_enc_punct__ival    = '0 ;
  assign ccsds_turbo_enc_punct__idat    = '0 ;



*/

//
// Project       : ccsds_turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_enc_punct.v
// Description   : module to implement used puncture pattern for 1/2, 1/3, 1/4, 1/6 coderates
//

module ccsds_turbo_enc_punct
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  //
  isop    ,
  ival    ,
  ieop    ,
  idat    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat
);

  `include "../ccsds_turbo_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk        ;
  input  logic         ireset      ;
  input  logic         iclkena     ;
  //
  input  logic [1 : 0] icode       ;
  //
  input  logic         isop        ;
  input  logic         ival        ;
  input  logic         ieop        ;
  input  logic [3 : 0] idat    [2] ;
  //
  output logic         osop        ;
  output logic         oval        ;
  output logic         oeop        ;
  output logic         odat        ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic         sop;
  logic [5 : 0] val;
  logic [5 : 0] eop;

  logic         sel;
  logic [5 : 0] dat;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      sop <= 1'b0;
      val <= '0;
      eop <= '0;
    end
    else if (iclkena) begin
      sop <= isop & ival;
      if (ival) begin
        case (icode)
          cCODE_1by2 : begin val <= 6'b0000_11; eop <= 6'b0000_10 & {6{ieop}}; end
          cCODE_1by3 : begin val <= 6'b0001_11; eop <= 6'b0001_00 & {6{ieop}}; end
          cCODE_1by4 : begin val <= 6'b0011_11; eop <= 6'b0010_00 & {6{ieop}}; end
          cCODE_1by6 : begin val <= 6'b1111_11; eop <= 6'b1000_00 & {6{ieop}}; end
        endcase
      end
      else begin
        val <= (val >> 1);
        eop <= (eop >> 1);
      end
    end
  end

  assign osop = sop;
  assign oval = val[0];
  assign oeop = eop[0];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        sel <= isop ? 1'b1 : !sel;
        case (icode)
          //
          cCODE_1by2 : begin
            dat[0] <= idat[0][0];
            dat[1] <= isop ? idat[0][1] : idat[sel][1];
            //
            dat[2] <= 1'b0;
            dat[3] <= 1'b0;
            dat[4] <= 1'b0;
            dat[5] <= 1'b0;
          end
          //
          cCODE_1by3 : begin
            dat[0] <= idat[0][0];
            dat[1] <= idat[0][1];
            dat[2] <= idat[1][1];
            //
            dat[3] <= 1'b0;
            dat[4] <= 1'b0;
            dat[5] <= 1'b0;
          end
          //
          cCODE_1by4 : begin
            dat[0] <= idat[0][0];
            dat[1] <= idat[0][2];
            dat[2] <= idat[0][3];
            dat[3] <= idat[1][1];
            //
            dat[4] <= 1'b0;
            dat[5] <= 1'b0;
          end
          //
          cCODE_1by6 : begin
            dat[0] <= idat[0][0];
            dat[1] <= idat[0][1];
            dat[2] <= idat[0][2];
            dat[3] <= idat[0][3];
            //
            dat[4] <= idat[1][1];
            dat[5] <= idat[1][3];
          end
        endcase
      end
      else begin
        dat <= (dat >> 1);
      end
    end
  end

  assign odat = dat[0];

endmodule
