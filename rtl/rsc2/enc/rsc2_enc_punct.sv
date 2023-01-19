/*



  parameter bit pWnY = 0;


  logic         rsc2_enc_punct__iclk     ;
  logic         rsc2_enc_punct__ireset   ;
  logic         rsc2_enc_punct__iclkena  ;
  logic [3 : 0] rsc2_enc_punct__icode    ;
  logic         rsc2_enc_punct__isop     ;
  logic         rsc2_enc_punct__ival     ;
  logic [1 : 0] rsc2_enc_punct__idat     ;
  logic         rsc2_enc_punct__oval     ;
  logic [1 : 0] rsc2_enc_punct__odat     ;



  rsc2_enc_punct
  #(
    .pWnY ( pWnY )
  )
  rsc2_enc_punct
  (
    .iclk    ( rsc2_enc_punct__iclk    ) ,
    .ireset  ( rsc2_enc_punct__ireset  ) ,
    .iclkena ( rsc2_enc_punct__iclkena ) ,
    .icode   ( rsc2_enc_punct__icode   ) ,
    .isop    ( rsc2_enc_punct__isop    ) ,
    .ival    ( rsc2_enc_punct__ival    ) ,
    .idat    ( rsc2_enc_punct__idat    ) ,
    .oval    ( rsc2_enc_punct__oval    ) ,
    .odat    ( rsc2_enc_punct__odat    )
  );


  assign rsc2_enc_punct__iclk    = '0 ;
  assign rsc2_enc_punct__ireset  = '0 ;
  assign rsc2_enc_punct__iclkena = '0 ;
  assign rsc2_enc_punct__icode   = '0 ;
  assign rsc2_enc_punct__isop    = '0 ;
  assign rsc2_enc_punct__ival    = '0 ;
  assign rsc2_enc_punct__idat    = '0 ;



*/

//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_enc_punct.sv
// Description   : module to implement used puncture pattern for Y/W duobits
//

module rsc2_enc_punct
#(
  parameter bit pWnY = 0  // 0/1 y/w bit
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  icode   ,
  //
  isop    ,
  ival    ,
  idat    ,
  //
  oval    ,
  odat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk     ;
  input  logic         ireset   ;
  input  logic         iclkena  ;
  //
  input  logic [3 : 0] icode    ; // coderate [0 : 7] - [1/3; 1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8]
  //
  input  logic         isop     ;
  input  logic         ival     ;
  input  logic [1 : 0] idat     ;
  //
  output logic         oval     ;
  output logic [1 : 0] odat     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef struct {
    logic [27 : 0] y;
    logic [27 : 0] w;
    logic  [4 : 0] s;  // up to 32
  } punct_t;

  localparam punct_t cPATTERN [0 : 7] = '{
    '{y : 28'b000000000000000000000000000_1, w : 28'b000000000000000000000000000_1, s :  0} , // 1/3
    '{y : 28'b000000000000000000000000000_1, w : 28'b000000000000000000000000000_0, s :  0} , // 1/2
    '{y : 28'b00000000000000000000000000_01, w : 28'b00000000000000000000000000_00, s :  1} , // 2/3
    '{y : 28'b0000000000000000000000_000101, w : 28'b0000000000000000000000_000000, s :  5} , // 3/4
    '{y : 28'b000000000000000000000000_0001, w : 28'b000000000000000000000000_0000, s :  3} , // 4/5
    '{y : 28'b00000000_00000001000100010001, w : 28'b00000000_00000000000000000000, s : 19} , // 5/6
    '{y : 28'b0000000000000000_000000010001, w : 28'b0000000000000000_000000000000, s : 11} , // 6/7
    '{y : 28'b_0000000100000001000000010001, w : 28'b_0000000000000000000000000000, s : 27}   // 7/8
  };

  logic [4 : 0] cnt;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        odat <= idat;
        //
        if (isop)
          cnt <= (cPATTERN[icode].s != 0);
        else if (cnt == cPATTERN[icode].s)
          cnt <= '0;
        else
          cnt <= cnt + 1'b1;
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset)
      oval  <= 1'b0;
    else if (iclkena)
      oval  <= ival & (isop | (pWnY ? cPATTERN[icode].w[cnt] : cPATTERN[icode].y[cnt]));
  end

endmodule
