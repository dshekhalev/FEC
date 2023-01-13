//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_functions.svh
// Description   : Common for encoder and decoder functions
//

  //------------------------------------------------------------------------------------------------------
  // address bit reverse function
  //------------------------------------------------------------------------------------------------------

  function bit_addr_t reverse_bit (input bit_addr_t addr, int used_nlog2 = cNLOG2);
    reverse_bit = '0;
    for (int i = 0; i < used_nlog2; i++) begin
      reverse_bit[used_nlog2-1-i] = addr[i];
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // 3GPP CRC function
  //------------------------------------------------------------------------------------------------------

  function bit [4 : 0] get_crc (input bit [4 : 0] crc, bit dat);
    get_crc = {crc[0], crc[4 : 1] ^ {3'b000, dat}};
  endfunction

  //------------------------------------------------------------------------------------------------------
  // polar coding 8x8 engine. reverse bit order only
  //------------------------------------------------------------------------------------------------------

  function automatic bit [7 : 0] do_ns_encode_8x8 (input bit [7 : 0] datb);
    bit [7 : 0] codeb;
  begin
    codeb[0]  = datb[0];
    codeb[1]  = datb[4];
    codeb[2]  = datb[2];
    codeb[3]  = datb[6];

    codeb[4]  = datb[1];
    codeb[5]  = datb[5];
    codeb[6]  = datb[3];
    codeb[7]  = datb[7];
    // layer 2
    codeb[0] ^= codeb[1];
    codeb[2] ^= codeb[3];
    codeb[4] ^= codeb[5];
    codeb[6] ^= codeb[7];
    // layer 1
    codeb[0] ^= codeb[2];
    codeb[1] ^= codeb[3];
    codeb[4] ^= codeb[6];
    codeb[5] ^= codeb[7];
    // layer 0
    codeb[0] ^= codeb[4];
    codeb[1] ^= codeb[5];
    codeb[2] ^= codeb[6];
    codeb[3] ^= codeb[7];
    //
    do_ns_encode_8x8 = codeb;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // comb 8 encoding engine. reverse bit order only
  //------------------------------------------------------------------------------------------------------

  function automatic bit [7 : 0] do_comb8 (input bit [7 : 0] bitL, bitR, bit bsel);
    bit [7 : 0] codeb;
  begin
    if (bsel) begin
      {codeb[6], codeb[4], codeb[2], codeb[0]} = bitL[4 +: 4] ^ bitR[4 +: 4];
      {codeb[7], codeb[5], codeb[3], codeb[1]} =                bitR[4 +: 4];
    end
    else begin
      {codeb[6], codeb[4], codeb[2], codeb[0]} = bitL[0 +: 4] ^ bitR[0 +: 4];
      {codeb[7], codeb[5], codeb[3], codeb[1]} =                bitR[0 +: 4];
    end
    //
    do_comb8 = codeb;
  end
  endfunction
