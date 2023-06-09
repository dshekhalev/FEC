//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_dvb_fix_parameters.svh
// Description   : DVB-S2/S2X bch parameters
//

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  parameter bit [1 : 0] pCODEGR   = 0;
  parameter bit [4 : 0] pCODERATE = 0;
  parameter bit         pXMODE    = 0;

  //------------------------------------------------------------------------------------------------------
  // DVB code types & code context
  //------------------------------------------------------------------------------------------------------

  // DVB-S2 code hierarhy
  typedef enum bit [3 : 0] {
    cCODERATE_1by4  = 0  ,
    cCODERATE_1by3  = 1  ,
    cCODERATE_2by5  = 2  ,
    cCODERATE_1by2  = 3  ,
    cCODERATE_3by5  = 4  ,
    cCODERATE_2by3  = 5  ,
    cCODERATE_3by4  = 6  ,
    cCODERATE_4by5  = 7  ,
    cCODERATE_5by6  = 8  ,
    cCODERATE_8by9  = 9  ,
    cCODERATE_9by10 = 10
  } coderate_t;

  // DVB-S2X code hierarhy
  typedef enum bit [2 : 0] {
    cXCODERATE_S_11by45 = 0 ,
    cXCODERATE_S_4by15  = 1 ,
    cXCODERATE_S_14by45 = 2 ,
    cXCODERATE_S_7by15  = 3 ,
    cXCODERATE_S_8by15  = 4 ,
    cXCODERATE_S_26by45 = 5 ,
    cXCODERATE_S_32by45 = 6
  } xcoderate_short_t;

  typedef enum bit [2 : 0] {
    cXCODERATE_M_1by5    = 0  ,
    cXCODERATE_M_11by45  = 1  ,
    cXCODERATE_M_1by3    = 2
  } xcoderate_med_t;

  typedef enum bit [4 : 0] {
    cXCODERATE_L_2by9     = 0  ,
    cXCODERATE_L_13by45   = 1  ,
    cXCODERATE_L_9by20    = 2  ,
    cXCODERATE_L_90by180  = 3  ,
    cXCODERATE_L_96by180  = 4  ,
    cXCODERATE_L_11by20   = 5  ,
    cXCODERATE_L_100by180 = 6  ,
    cXCODERATE_L_26by45   = 7  ,
    cXCODERATE_L_104by180 = 8  ,
    cXCODERATE_L_18by30   = 9  ,
    cXCODERATE_L_28by45   = 10 ,
    cXCODERATE_L_23by36   = 11 ,
    cXCODERATE_L_116by180 = 12 ,
    cXCODERATE_L_20by30   = 13 ,
    cXCODERATE_L_124by180 = 14 ,
    cXCODERATE_L_25by36   = 15 ,
    cXCODERATE_L_128by180 = 16 ,
    cXCODERATE_L_13by18   = 17 ,
    cXCODERATE_L_132by180 = 18 ,
    cXCODERATE_L_22by30   = 19 ,
    cXCODERATE_L_135by180 = 20 ,
    cXCODERATE_L_140by180 = 21 ,
    cXCODERATE_L_7by9     = 22 ,
    cXCODERATE_L_154by180 = 23
  } xcoderate_large_t;

  //------------------------------------------------------------------------------------------------------
  // size hierarhy
  //------------------------------------------------------------------------------------------------------

  typedef enum bit [1 : 0] {
    cCODEGR_SHORT  = 0,
    cCODEGR_LARGE  = 1,
    cCODEGR_MEDIUM = 2
  } code_gr_t;

  //------------------------------------------------------------------------------------------------------
  // used functions
  //------------------------------------------------------------------------------------------------------

  localparam int cGF_IRRPOL [4] = '{16427, 65581, 32813, 65581};  // see code_gr_t definition. extend for defaults
  localparam int cGF_M      [4] = '{   14,    16,    15,    16};

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  //
  // function to get amount of check bits
  //
  function automatic int get_t_num (input int codegr, coderate, bit xmode);
  begin
    get_t_num = 12;
    //
    if (xmode) begin
      get_t_num = 12; // for all modes GF(2^14/15/16)
    end
    else begin
      get_t_num = 12; // GF(2^14) and a lot of modes GF(2^16)
      case (codegr)
        cCODEGR_LARGE : begin // GF(2^16);
          case (coderate)
            cCODERATE_2by3, cCODERATE_5by6  : get_t_num = 10 ;
            cCODERATE_8by9, cCODERATE_9by10 : get_t_num =  8 ;
          endcase
        end
      endcase
    end
  end
  endfunction

  //
  // function to get amount of check bits
  //
  function automatic int get_check_bits_num(input int codegr, coderate, bit xmode);
    int bits_num;
  begin
    bits_num = get_t_num(codegr, coderate, xmode) * 16; // GF(2^16);
    //
    case (codegr)
      cCODEGR_SHORT   : bits_num = get_t_num(codegr, coderate, xmode) * 14; // GF(2^14);
      cCODEGR_MEDIUM  : bits_num = get_t_num(codegr, coderate, xmode) * 15; // GF(2^15);
      cCODEGR_LARGE   : bits_num = get_t_num(codegr, coderate, xmode) * 16; // GF(2^16);
    endcase
    //
    get_check_bits_num = bits_num;
  end
  endfunction

  //
  // functions to get maxumum amount of data bits
  //
  function automatic int get_data_max_bits_num (input int codegr, coderate, bit xmode);
    int bits_num;
  begin
    bits_num = 2**16 - 1 - get_check_bits_num(codegr, coderate, xmode);
    //
    case (codegr)
      cCODEGR_SHORT   : bits_num = 2**14 - 1 - get_check_bits_num(codegr, coderate, xmode);
      cCODEGR_MEDIUM  : bits_num = 2**15 - 1 - get_check_bits_num(codegr, coderate, xmode);
      cCODEGR_LARGE   : bits_num = 2**16 - 1 - get_check_bits_num(codegr, coderate, xmode);
    endcase
    //
    get_data_max_bits_num = bits_num;
  end
  endfunction

  //
  // function to gen number of data bits
  //
  function automatic int get_data_bits_num (input int codegr, coderate, bit xmode);
    int bits_num;
  begin
    bits_num = get_data_max_bits_num (codegr, coderate, xmode);
    if (xmode) begin
      case (codegr)
        cCODEGR_SHORT : begin
          case (coderate)
             cXCODERATE_S_11by45 : bits_num =  3792;
             cXCODERATE_S_4by15  : bits_num =  4152;
             cXCODERATE_S_14by45 : bits_num =  4872;
             cXCODERATE_S_7by15  : bits_num =  7392;
             cXCODERATE_S_8by15  : bits_num =  8472;
             cXCODERATE_S_26by45 : bits_num =  9192;
             cXCODERATE_S_32by45 : bits_num = 11352;
          endcase
        end
        //
        cCODEGR_MEDIUM : begin
          case (coderate)
            cXCODERATE_M_1by5   : bits_num =  5660; // remember about LDPC shortening (+640 bits)
            cXCODERATE_M_11by45 : bits_num =  7740;
            cXCODERATE_M_1by3   : bits_num = 10620;
          endcase
        end
        //
        cCODEGR_LARGE : begin
          case (coderate)
            cXCODERATE_L_2by9     : bits_num = 14208;
            cXCODERATE_L_13by45   : bits_num = 18528;
            cXCODERATE_L_9by20    : bits_num = 28968;
            cXCODERATE_L_90by180  : bits_num = 32208;
            cXCODERATE_L_96by180  : bits_num = 34368;
            cXCODERATE_L_11by20   : bits_num = 35448;
            cXCODERATE_L_100by180 : bits_num = 35808;
            cXCODERATE_L_26by45   : bits_num = 37248;
            cXCODERATE_L_104by180 : bits_num = 37248;
            cXCODERATE_L_18by30   : bits_num = 38688;
            cXCODERATE_L_28by45   : bits_num = 40128;
            cXCODERATE_L_23by36   : bits_num = 41208;
            cXCODERATE_L_116by180 : bits_num = 41568;
            cXCODERATE_L_20by30   : bits_num = 43008;
            cXCODERATE_L_124by180 : bits_num = 44448;
            cXCODERATE_L_25by36   : bits_num = 44808;
            cXCODERATE_L_128by180 : bits_num = 45888;
            cXCODERATE_L_13by18   : bits_num = 46608;
            cXCODERATE_L_132by180 : bits_num = 47328;
            cXCODERATE_L_22by30   : bits_num = 47328;
            cXCODERATE_L_135by180 : bits_num = 48408;
            cXCODERATE_L_140by180 : bits_num = 50208;
            cXCODERATE_L_7by9     : bits_num = 50208;
            cXCODERATE_L_154by180 : bits_num = 55248;
          endcase
        end
      endcase
    end
    else begin
      case (codegr)
        cCODEGR_SHORT : begin
          case (coderate)
            cCODERATE_1by4 : bits_num = 3072;
            cCODERATE_1by3 : bits_num = 5232;
            cCODERATE_2by5 : bits_num = 6312;
            cCODERATE_1by2 : bits_num = 7032;
            cCODERATE_3by5 : bits_num = 9552;
            cCODERATE_2by3 : bits_num = 10632;
            cCODERATE_3by4 : bits_num = 11712;
            cCODERATE_4by5 : bits_num = 12432;
            cCODERATE_5by6 : bits_num = 13152;
            cCODERATE_8by9 : bits_num = 14232;
          endcase
        end
        cCODEGR_LARGE : begin
          case (coderate)
            cCODERATE_1by4  : bits_num = 16008;
            cCODERATE_1by3  : bits_num = 21408;
            cCODERATE_2by5  : bits_num = 25728;
            cCODERATE_1by2  : bits_num = 32208;
            cCODERATE_3by5  : bits_num = 38688;
            cCODERATE_2by3  : bits_num = 43040;
            cCODERATE_3by4  : bits_num = 48408;
            cCODERATE_4by5  : bits_num = 51648;
            cCODERATE_5by6  : bits_num = 53840;
            cCODERATE_8by9  : bits_num = 57472;
            cCODERATE_9by10 : bits_num = 58192;
          endcase
        end
      endcase
    end
    //
    get_data_bits_num = bits_num;
  end
  endfunction

  //
  // function to gen number of frame bits
  //
  function automatic int get_code_bits_num (input int codegr, coderate, bit xmode);
    get_code_bits_num = get_data_bits_num(codegr, coderate, xmode) + get_check_bits_num(codegr, coderate, xmode);
  endfunction

