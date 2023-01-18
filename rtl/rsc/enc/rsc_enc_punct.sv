/*



  parameter bit pWnY = 0;


  logic         rsc_enc_punct__iclk     ;
  logic         rsc_enc_punct__ireset   ;
  logic         rsc_enc_punct__iclkena  ;
  logic [3 : 0] rsc_enc_punct__icode    ;
  logic         rsc_enc_punct__isop     ;
  logic         rsc_enc_punct__ival     ;
  logic [1 : 0] rsc_enc_punct__idat     ;
  logic         rsc_enc_punct__oval     ;
  logic [1 : 0] rsc_enc_punct__odat     ;



  rsc_enc_punct
  #(
    .pWnY ( pWnY )
  )
  rsc_enc_punct
  (
    .iclk    ( rsc_enc_punct__iclk    ) ,
    .ireset  ( rsc_enc_punct__ireset  ) ,
    .iclkena ( rsc_enc_punct__iclkena ) ,
    .icode   ( rsc_enc_punct__icode   ) ,
    .isop    ( rsc_enc_punct__isop    ) ,
    .ival    ( rsc_enc_punct__ival    ) ,
    .idat    ( rsc_enc_punct__idat    ) ,
    .oval    ( rsc_enc_punct__oval    ) ,
    .odat    ( rsc_enc_punct__odat    )
  );


  assign rsc_enc_punct__iclk    = '0 ;
  assign rsc_enc_punct__ireset  = '0 ;
  assign rsc_enc_punct__iclkena = '0 ;
  assign rsc_enc_punct__icode   = '0 ;
  assign rsc_enc_punct__isop    = '0 ;
  assign rsc_enc_punct__ival    = '0 ;
  assign rsc_enc_punct__idat    = '0 ;



*/

//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_enc_punct.sv
// Description   : module to implement used puncture pattern for Y/W duobits
//

module rsc_enc_punct
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
  input  logic [3 : 0] icode    ; // 0           - 1/3,
                                  // [1 : 9]     - [1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8; 8/9; 9/10]
                                  // 10          - 2/5
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
    logic [8 : 0] y;
    logic [8 : 0] w;
    logic [3 : 0] s;
  } punct_t;

  localparam punct_t cPATTERN [0 : 12] = '{
    '{y : 9'b00000000_1, w : 9'b00000000_1, s : 0} , // 1/3
    '{y : 9'b00000000_1, w : 9'b00000000_0, s : 0} , // 1/2
    '{y : 9'b0000000_01, w : 9'b0000000_00, s : 1} , // 2/3
    '{y : 9'b000000_001, w : 9'b000000_000, s : 2} , // 3/4
    '{y : 9'b00000_0001, w : 9'b00000_0000, s : 3} , // 4/5
    '{y : 9'b0000_00001, w : 9'b0000_00000, s : 4} , // 5/6
    '{y : 9'b000_000001, w : 9'b000_000000, s : 5} , // 6/7
    '{y : 9'b00_0000001, w : 9'b00_0000000, s : 6} , // 7/8   special code rate !!!
    '{y : 9'b0_00000001, w : 9'b0_00000000, s : 7} , // 8/9
    '{y : 9'b_000000001, w : 9'b_000000000, s : 8} , // 9/10
    '{y : 9'b0000000_11, w : 9'b0000000_01, s : 1} , // 2/5
    '{y : 9'b000000_101, w : 9'b0000000_00, s : 2} , // 3/5
    '{y : 9'b000000_101, w : 9'b000000_101, s : 2}   // 3/7
  };

  logic [3 : 0] cnt;
  logic [2 : 0] cnt7;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        odat <= idat;
        //
        if (isop) begin
          cnt   <= (cPATTERN[icode].s != 0);
          cnt7  <= '0;
        end
        else if (cnt == cPATTERN[icode].s) begin
          cnt   <= '0;
          cnt7  <= (cnt7 == cPATTERN[7].s) ? '0 : (cnt7 + 1'b1);
        end
        else begin
          cnt <= cnt + 1'b1;
        end
      end
    end
  end

  wire [8 : 0] y_code7 = (cPATTERN[7].y << cnt7);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset)
      oval  <= 1'b0;
    else if (iclkena)
      if (icode == 7) begin
        oval  <= ival & (isop | y_code7[cnt]);
      end
      else begin
        oval  <= ival & (isop | (pWnY ? cPATTERN[icode].w[cnt] : cPATTERN[icode].y[cnt]));
      end
  end

endmodule
