/*



  parameter int pR      = 6 ;
  parameter bit pEXT    = 1 ;
  parameter int pTAG_W  = 1 ;



  logic                hamming_dec__iclk      ;
  logic                hamming_dec__ireset    ;
  logic                hamming_dec__iclkena   ;
  logic                hamming_dec__isop      ;
  logic                hamming_dec__ival      ;
  logic                hamming_dec__ieop      ;
  logic [pTAG_W-1 : 0] hamming_dec__itag      ;
  logic                hamming_dec__idat      ;
  logic                hamming_dec__osop      ;
  logic                hamming_dec__oval      ;
  logic                hamming_dec__oeop      ;
  logic                hamming_dec__odecfail  ;
  logic [pTAG_W-1 : 0] hamming_dec__otag      ;
  logic                hamming_dec__odat      ;



  hamming_dec
  #(
    .pR     ( pR     ) ,
    .pEXT   ( pEXT   ) ,
    .pTAG_W ( pTAG_W )
  )
  hamming_dec
  (
    .iclk     ( hamming_dec__iclk     ) ,
    .ireset   ( hamming_dec__ireset   ) ,
    .iclkena  ( hamming_dec__iclkena  ) ,
    .isop     ( hamming_dec__isop     ) ,
    .ival     ( hamming_dec__ival     ) ,
    .ieop     ( hamming_dec__ieop     ) ,
    .itag     ( hamming_dec__itag     ) ,
    .idat     ( hamming_dec__idat     ) ,
    .osop     ( hamming_dec__osop     ) ,
    .oval     ( hamming_dec__oval     ) ,
    .oeop     ( hamming_dec__oeop     ) ,
    .odecfail ( hamming_dec__odecfail ) ,
    .otag     ( hamming_dec__otag     ) ,
    .odat     ( hamming_dec__odat     )
  );


  assign hamming_dec__iclk    = '0 ;
  assign hamming_dec__ireset  = '0 ;
  assign hamming_dec__iclkena = '0 ;
  assign hamming_dec__isop    = '0 ;
  assign hamming_dec__ival    = '0 ;
  assign hamming_dec__ieop    = '0 ;
  assign hamming_dec__itag    = '0 ;
  assign hamming_dec__idat    = '0 ;



*/

//
// Project       : hamming
// Author        : Shekhalev Denis (des00)
// Workfile      : hamming_enc.v
// Description   : Systematic extended hamming decoder with static code parameters
//


module hamming_dec
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  isop     ,
  ival     ,
  ieop     ,
  itag     ,
  idat     ,
  //
  osop     ,
  oval     ,
  oeop     ,
  odecfail ,
  otag     ,
  odat
);

  parameter bit pEXT    = 0; // extended hamming code (2^pR, 2^pR - pR) or not (2^pR - 1, 2^pR - pR - 1)
  parameter int pTAG_W  = 1;

  `include "hamming_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk      ;
  input  logic                ireset    ;
  input  logic                iclkena   ;
  //
  input  logic                isop      ;
  input  logic                ival      ;
  input  logic                ieop      ;
  input  logic [pTAG_W-1 : 0] itag      ;
  input  logic                idat      ;
  //
  output logic                osop      ;
  output logic                oval      ;
  output logic                oeop      ;
  output logic                odecfail  ;
  output logic [pTAG_W-1 : 0] otag      ;
  output logic                odat      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                sop;
  logic                val;
  logic                eop;
  logic                edat = '0;
  logic [pTAG_W-1 : 0] tag;
  logic [cCBITS-1 : 0] dat = '0;

  logic     [pR-1 : 0] syndrome;
  logic                even;
  logic                decfail;
  logic [cCBITS-1 : 0] fix_data;

  logic                do_output;
  logic     [pR-1 : 0] do_cnt;

  logic [cDBITS-1 : 0] dat_buffer;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  M_t M;
  P_t P;

  always_comb begin
    M = generate_M_matrix(0);
    P = generate_inv_permutation(0);
  end

  //------------------------------------------------------------------------------------------------------
  // asseble data
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= 1'b0;
    end
    else if (iclkena) begin
      val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= isop & ival;
      eop <= ieop & ival;
      if (ival) begin
        edat  <= idat;
        dat   <= pEXT ? {edat, dat[$high(dat) : 1]} : {idat, dat[$high(dat) : 1]};
        //
        if (isop) begin
          tag <= itag;
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // decode
  //------------------------------------------------------------------------------------------------------

  always_comb begin
    // count syndrome
    syndrome = get_syndrome(dat);
    even     = (^dat) ^ edat;
    // Fix error
    if (syndrome != 0) begin
      fix_data = dat ^ (1'b1 << P[syndrome]);
    end
    else begin
      fix_data = dat;
    end
    // detect number of erros
/*
    decfail = 1'b0;
    if (syndrome == 0 & !even)  // no error
      decfail = 1'b0;
    else if (syndrome != 0 & even)  // 1 error
      decfail = 1'b0;
    else if (syndrome == 0 & even)  // error in even bits
      decfail = 1'b0;
    else // if (syndrome != 0) & !even; // > 1 error
      decfail = 1'b1;
*/
    if (pEXT) begin
      decfail = (syndrome != 0) & !even;
    end
    else begin
      decfail = 1'b0; // can't decode valid oê not
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      do_output <= 1'b0;
      do_cnt    <= '0;
    end
    else if (iclkena) begin
      if (val & eop) begin
        do_output <= 1'b1;
        do_cnt    <= cDBITS-1;
      end
      else if (do_output) begin
        do_output <= (do_cnt != 0);
        do_cnt    <=  do_cnt - 1'b1;
      end
    end
  end

  assign oval = do_output;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osop <= val & eop;
      oeop <= do_output & (do_cnt == 1);
      //
      if (val & eop) begin
        dat_buffer <= fix_data[cDBITS-1 : 0];
      end
      else if (do_output) begin
        dat_buffer <= (dat_buffer >> 1);
      end
      //
      if (val & eop) begin
        odecfail  <= decfail;
        otag      <= tag;
      end
    end
  end

  assign odat = dat_buffer[0];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function logic [pR-1 : 0] get_syndrome (input logic [cCBITS-1 : 0] dat);
    get_syndrome = '0;
    for (int r = 0; r < pR; r++) begin
      get_syndrome[r] = ^(dat & M[r]);
    end
  endfunction

endmodule
