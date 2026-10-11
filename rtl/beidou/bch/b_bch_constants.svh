//
// Project       : BeiDou bch
// Author        : Shekhalev Denis (des00)
// Workfile      : b_bch_constants.svh
// Description   : bch codec constants, types, functions
//

  //------------------------------------------------------------------------------------------------------
  // bch settings
  //------------------------------------------------------------------------------------------------------

  localparam int cDBIT_NUM  [2] = '{6,  8};
  localparam int cBIT_NUM   [2] = '{21, 51};

  localparam bit [8 : 0] cGPOLY [2] = '{
                                      9'b0_0101_0111, // x^6 +       x^4 +       x^2 + x + 1
                                      9'b1_1001_1111  // x^8 + x^7 + x^4 + x^3 + x^2 + x + 1
                                      };

  //------------------------------------------------------------------------------------------------------
  // bit encoding
  //------------------------------------------------------------------------------------------------------

  function automatic logic encode_bit (logic [7 : 0] dat, bit Lcode);
  begin
    encode_bit = ^(dat ^ cGPOLY[Lcode]);
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // code word counter
  //------------------------------------------------------------------------------------------------------

  function automatic bit [20 : 0] encode_6bit (bit [5 : 0] dat);
    bit [5 : 0] tdat;
    bit         tbit;
  begin
    // remap data msb first for coding
    for (int i = 0; i < 6; i++) begin
      tdat[i] = dat[5-i];
    end
    // shift rigth encoding :: 0 bit to channel
    encode_6bit[5 : 0] = tdat;
    //
    for (int i = 6; i < 21; i++) begin
      tbit = encode_bit(tdat, 0);
      //
      encode_6bit[i] = tbit;
      tdat = {tbit, tdat[5 : 1]};
    end
  end
  endfunction

  function automatic bit [50 : 0] encode_8bit (bit [7 : 0] dat);
    bit [7 : 0] tdat;
    bit         tbit;
  begin
    // remap data msb first for coding
    for (int i = 0; i < 8; i++) begin
      tdat[i] = dat[7-i];
    end
    // shift rigth encoding :: 0 bit to channel
    encode_8bit[7 : 0] = tdat;
    //
    for (int i = 8; i < 51; i++) begin
      tbit = encode_bit(tdat, 1);
      //
      encode_8bit[i] = tbit;
      tdat = {tbit, tdat[7 : 1]};
    end
  end
  endfunction
