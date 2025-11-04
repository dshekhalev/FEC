//
// Project       : DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_s2_tb_frame_size.svh
// Description   : DVB S2 frames sizes
//

  //------------------------------------------------------------------------------------------------------
  // code context types
  //------------------------------------------------------------------------------------------------------

  typedef struct packed {
    logic         vl_snr;
    logic [7 : 2] fmodcod;  // {dvb-s2x, modcod}
    logic [1 : 0] ftype;    // {frame_size, pilot}
  } tacm_code_t;

  //------------------------------------------------------------------------------------------------------
  // size functions
  //------------------------------------------------------------------------------------------------------

  function automatic int get_fec_data_words_num (input tacm_code_t acm_code, int dat_w = 1);
    int bit_num;
  begin
    if (acm_code.vl_snr) begin
      case (acm_code[3 : 0])
        // VL-SNR set 1
        0       : bit_num = (180-140)*360       - 12*16; // QPSK
        //
        1       : bit_num =   (90-72)*360 - 640 - 12*15;
        2       : bit_num =   (90-68)*360       - 12*15;
        3       : bit_num =   (90-60)*360       - 12*15;
        //
        4       : bit_num =   (45-36)*360 - 560 - 12*14;  // sf2
        5       : bit_num =   (45-34)*360       - 12*14;  // sf2
        // VL-SNR set 2
        9       : bit_num =   (45-36)*360 - 12*14;
        10      : bit_num =   (45-33)*360 - 12*14;
        11      : bit_num =   (45-30)*360 - 12*14;
      endcase
    end
    else if (acm_code.ftype[1]) begin // short frame don't have 9/10 coderate
      bit_num = 3072;
      case (acm_code.fmodcod)
        /* QPSK_1by4    */ 1  : bit_num = 3072;   // 6
        /* QPSK_1by3    */ 2  : bit_num = 5232;
        /* QPSK_2by5    */ 3  : bit_num = 6312;
        /* QPSK_1by2    */ 4  : bit_num = 7032;
        /* QPSK_3by5    */ 5  : bit_num = 9552;
        /* QPSK_2by3    */ 6  : bit_num = 10632;
        /* QPSK_3by4    */ 7  : bit_num = 11712;
        /* QPSK_4by5    */ 8  : bit_num = 12432;
        /* QPSK_5by6    */ 9  : bit_num = 13152;
        /* QPSK_8by9    */ 10 : bit_num = 14232;
        //
        /* PSK8_3by5    */ 12 : bit_num = 9552;   // 50
        /* PSK8_2by3    */ 13 : bit_num = 10632;
        /* PSK8_3by4    */ 14 : bit_num = 11712;
        /* PSK8_5by6    */ 15 : bit_num = 13152;
        /* PSK8_8by9    */ 16 : bit_num = 14232;
        //
        /* APSK16_2by3  */ 18 : bit_num = 10632;  // 74
        /* APSK16_3by4  */ 19 : bit_num = 11712;
        /* APSK16_4by5  */ 20 : bit_num = 12432;
        /* APSK16_5by6  */ 21 : bit_num = 13152;
        /* APSK16_8by9  */ 22 : bit_num = 14232;
        //
        /* APSK32_3by4  */ 24 : bit_num = 11712;  // 98
        /* APSK32_4by5  */ 25 : bit_num = 12432;
        /* APSK32_5by6  */ 26 : bit_num = 13152;
        /* APSK32_8by9  */ 27 : bit_num = 14232;
                      default : begin end
      endcase
    end
    else begin
      bit_num = 16008;
      case (acm_code.fmodcod)
        /* QPSK_1by4    */ 1  : bit_num = 16008;  // 4
        /* QPSK_1by3    */ 2  : bit_num = 21408;
        /* QPSK_2by5    */ 3  : bit_num = 25728;
        /* QPSK_1by2    */ 4  : bit_num = 32208;
        /* QPSK_3by5    */ 5  : bit_num = 38688;
        /* QPSK_2by3    */ 6  : bit_num = 43040;
        /* QPSK_3by4    */ 7  : bit_num = 48408;
        /* QPSK_4by5    */ 8  : bit_num = 51648;
        /* QPSK_5by6    */ 9  : bit_num = 53840;
        /* QPSK_8by9    */ 10 : bit_num = 57472;
        /* QPSK_9by10   */ 11 : bit_num = 58192;
        //
        /* PSK8_3by5    */ 12 : bit_num = 38688;  // 48
        /* PSK8_2by3    */ 13 : bit_num = 43040;
        /* PSK8_3by4    */ 14 : bit_num = 48408;
        /* PSK8_5by6    */ 15 : bit_num = 53840;
        /* PSK8_8by9    */ 16 : bit_num = 57472;
        /* PSK8_9by10   */ 17 : bit_num = 58192;
        //
        /* APSK16_2by3  */ 18 : bit_num = 43040;  //72
        /* APSK16_3by4  */ 19 : bit_num = 48408;
        /* APSK16_4by5  */ 20 : bit_num = 51648;
        /* APSK16_5by6  */ 21 : bit_num = 53840;
        /* APSK16_8by9  */ 22 : bit_num = 57472;
        /* APSK16_9by10 */ 23 : bit_num = 58192;
        //
        /* APSK32_3by4  */ 24 : bit_num = 48408;  //96
        /* APSK32_4by5  */ 25 : bit_num = 51648;
        /* APSK32_5by6  */ 26 : bit_num = 53840;
        /* APSK32_8by9  */ 27 : bit_num = 57472;
        /* APSK32_9by10 */ 28 : bit_num = 58192;
                      default : begin end
      endcase
    end
    //
    return bit_num/dat_w;
  end
  endfunction
