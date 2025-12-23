/*



  parameter int pR      = 6 ;
  parameter bit pEXT    = 1 ;
  parameter int pTAG_W  = 1 ;



  logic                hamming_enc__iclk     ;
  logic                hamming_enc__ireset   ;
  logic                hamming_enc__iclkena  ;
  logic                hamming_enc__isop     ;
  logic                hamming_enc__ival     ;
  logic                hamming_enc__ieop     ;
  logic                hamming_enc__ieof     ;
  logic [pTAG_W-1 : 0] hamming_enc__itag     ;
  logic                hamming_enc__idat     ;
  logic                hamming_enc__osop     ;
  logic                hamming_enc__oval     ;
  logic                hamming_enc__oeop     ;
  logic [pTAG_W-1 : 0] hamming_enc__otag     ;
  logic                hamming_enc__odat     ;



  hamming_enc
  #(
    .pR     ( pR     ) ,
    .pTAG_W ( pTAG_W )
  )
  hamming_enc
  (
    .iclk    ( hamming_enc__iclk    ) ,
    .ireset  ( hamming_enc__ireset  ) ,
    .iclkena ( hamming_enc__iclkena ) ,
    .isop    ( hamming_enc__isop    ) ,
    .ival    ( hamming_enc__ival    ) ,
    .ieop    ( hamming_enc__ieop    ) ,
    .ieof    ( hamming_enc__ieof    ) ,
    .itag    ( hamming_enc__itag    ) ,
    .idat    ( hamming_enc__idat    ) ,
    .osop    ( hamming_enc__osop    ) ,
    .oval    ( hamming_enc__oval    ) ,
    .oeop    ( hamming_enc__oeop    ) ,
    .otag    ( hamming_enc__otag    ) ,
    .odat    ( hamming_enc__odat    )
  );


  assign hamming_enc__iclk    = '0 ;
  assign hamming_enc__ireset  = '0 ;
  assign hamming_enc__iclkena = '0 ;
  assign hamming_enc__isop    = '0 ;
  assign hamming_enc__ival    = '0 ;
  assign hamming_enc__ieop    = '0 ;
  assign hamming_enc__ieof    = '0 ;
  assign hamming_enc__itag    = '0 ;
  assign hamming_enc__idat    = '0 ;



*/

//
// Project       : hamming
// Author        : Shekhalev Denis (des00)
// Workfile      : hamming_enc.sv
// Description   : Systematic extended hamming encoder with static code parameters. The extended even bit output contolled by ieof flag.
//                 If ieof is at 2^pR-1 position it's perfect hamming code if ieof is at 2^pR positions it's extended perfect hamming code
//


module hamming_enc
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ival    ,
  ieop    ,
  ieof    ,
  itag    ,
  idat    ,
  //
  osop    ,
  oval    ,
  oeop    ,
  otag    ,
  odat
);

  parameter int pTAG_W  = 1;

  `include "hamming_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk     ;
  input  logic                ireset   ;
  input  logic                iclkena  ;
  //
  input  logic                isop     ;  // start of payload/frame
  input  logic                ieop     ;  // end of payload
  input  logic                ieof     ;  // end of frame
  input  logic                ival     ;  // valid of frame
  input  logic [pTAG_W-1 : 0] itag     ;
  input  logic                idat     ;  // frame data
  //
  output logic                osop     ;  // start of packet
  output logic                oval     ;  // valid of packet
  output logic                oeop     ;  // end of packet
  output logic [pTAG_W-1 : 0] otag     ;
  output logic                odat     ;  // packet data

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_W = $clog2(cCBITS);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                data_n_check;

  logic [cCNT_W-1 : 0] bcnt;

  logic     [pR   : 0] rbits; // {even, rbits}

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  M_t M;

  always_comb begin
    M = generate_M_matrix(1); // generate systematic form
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (ival) begin
        // "FSM"
        if (isop) begin
          data_n_check  <= 1'b1;
          otag          <= itag;
        end
        else if (ieop) begin
          data_n_check  <= 1'b0;
        end
        //
        osop <=  isop;
        odat <= (isop | data_n_check) ? idat : rbits[0];
        oeop <=  ieof;
        // encoding
        if (isop) begin
          bcnt <= 1'b1;
          for (int r = 0; r < pR; r++) begin
            rbits[r] <= idat & M[r][0];
          end
          rbits[pR] <= idat;
        end
        else if (data_n_check) begin
          bcnt <= bcnt + 1'b1;
          for (int r = 0; r < pR; r++) begin
            rbits[r] <= rbits[r] ^ (idat & M[r][bcnt]);
          end
          rbits[pR] <= rbits[pR] ^ idat;
        end
        else begin
          for (int r = 0; r < pR; r++) begin
            rbits[r] <= (r == pR-1) ? ^rbits : rbits[r+1];
          end
        end
      end
    end
  end

endmodule
