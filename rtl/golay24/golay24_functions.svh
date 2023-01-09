//
// Project       : golay24
// Author        : Shekhalev Denis (des00)
// Revision      : $Revision$
// Date          : $Date$
// Workfile      : golay24_functions.svh
// Description   : forward and backward table generation. g(x) = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1 (12'hC75). See Marelos-Saragosa
//

  // data (systematic) bits part of check marix
  localparam bit [11 : 0] cD_TAB[12] = '{12'h800, 12'h400, 12'h200, 12'h100,
                                         12'h080, 12'h040, 12'h020, 12'h010,
                                         12'h008, 12'h004, 12'h002, 12'h001};

  // parity bits part of check marix
  localparam bit [11 : 0] cB_TAB[12] = '{12'h7FF, 12'hEE2, 12'hDC5, 12'hB8B,
                                         12'hF16, 12'hE2D, 12'hC5B, 12'h8B7,
                                         12'h96E, 12'hADC, 12'hDB8, 12'hB71};

  bit [23 : 0] cFORWARD_ENCODER_TAB  [4096];
  bit [23 : 0] cBACKWARD_ENCODER_TAB [4096];

  always_comb begin
    int code;
    //
    cFORWARD_ENCODER_TAB  = '{default : '0};
    cBACKWARD_ENCODER_TAB = '{default : '0};
    //
    for (int data = 0; data < 4096; data++) begin
      code = '0;
      for (int i = 0; i < 12; i++) begin
        code[11 - i] = ^(data & cB_TAB[i]);
      end
      cFORWARD_ENCODER_TAB [data[11 : 0]] = {code[11 : 0], data[11 : 0]}; // lsb first
      cBACKWARD_ENCODER_TAB[code[11 : 0]] = {code[11 : 0], data[11 : 0]};
    end
  end

  bit [24 : 0] cSYNDROME_TAB   [4096];  // + 1 bit for missing error pattern {filed, error_vector}
  bit [15 : 0] cS_SYNDROME_TAB [4096];  // + 1 bit for missing error pattern {failed, error_idx[0:2]}

  always_comb begin
    bit [23 : 0] biterr;
    bit [11 : 0] syndrome;
    //
    cSYNDROME_TAB   = '{0 : 0,        default : 25'h1_000000};
    cS_SYNDROME_TAB = '{0 : 16'h7FFF, default : 16'hFFFF};
    // single  weigth error
    for (int i = 0; i < 24; i++) begin
      biterr    = (1 << i);
      syndrome  = get_syndrome(biterr);
      //
      cSYNDROME_TAB   [syndrome] = {1'b0, biterr};
      cS_SYNDROME_TAB [syndrome] = {1'b0, i[4:0], 5'h1F, 5'h1F};
    end
    // double  weigth error
    for (int i = 0; i < 24; i++) begin
      for (int j = i + 1; j < 24; j++) begin
        biterr    = (1 << i) | (1 << j);
        syndrome  = get_syndrome(biterr);
        //
        cSYNDROME_TAB   [syndrome] = {1'b0, biterr};
        cS_SYNDROME_TAB [syndrome] = {1'b0, i[4:0], j[4:0], 5'h1F};
      end
    end
    // tripple weigth error
    for (int i = 0; i < 24; i++) begin
      for (int j = i + 1; j < 24; j++) begin
        for (int k = j + 1; k < 24; k++) begin
          biterr    = (1 << i) | (1 << j) | (1 << k);
          syndrome  = get_syndrome(biterr);
          //
          cSYNDROME_TAB   [syndrome] = {1'b0, biterr};
          cS_SYNDROME_TAB [syndrome] = {1'b0, i[4:0], j[4:0], k[4:0]};
        end
      end
    end
  end

  function bit [23 : 0] encode (input bit [11 : 0] data);
    bit [11 : 0] code;
  begin
    for (int i = 0; i < 12; i++) begin
      code[11-i] = ^(data[11 : 0] & cB_TAB[i]);
    end
    encode = {code, data};
  end
  endfunction

  function bit [11 : 0] get_syndrome (input bit [23 : 0] data);
    for (int i = 0; i < 12; i++) begin
      get_syndrome[11-i] = ^({cB_TAB[i], cD_TAB[i]} & data);
//    get_syndrome[11-i] = ^(cB_TAB[i] & data[23 : 12]) ^ data[11-i];
    end
  endfunction

  function bit [3 : 0] weight (input bit [11 : 0] data);
    weight = 0;
    for (int i = 0; i < 12; i++) begin
      weight += data[i];
    end
  endfunction

