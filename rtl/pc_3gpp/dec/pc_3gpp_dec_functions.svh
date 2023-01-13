//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_functions.svh
// Description   : Decoder high, medium and low level functions
//

  //------------------------------------------------------------------------------------------------------
  // F4 decoding stage. reverse bit order only
  //------------------------------------------------------------------------------------------------------

  function automatic alpha_hw_t do_F4 (input alpha_w_t alpha);
    alpha_hw_t alphaL, alphaR;
    alpha_hw_t cnode_llr;
  begin
    alphaL = '{alpha[0], alpha[2], alpha[4], alpha[6]};
    alphaR = '{alpha[1], alpha[3], alpha[5], alpha[7]};

    for (int beta = 0; beta < 4; beta++) begin
      cnode_llr[beta] = cnode(alphaL[beta], alphaR[beta]);
    end
    //
    return cnode_llr;
  end
  endfunction

  function automatic alpha_hw_t do_F4_chLLR (input llr_w_t llr);
    alpha_w_t  alpha;
  begin
    for (int i = 0; i < 8; i++) alpha[i] = $signed(llr[i]);
    //
    do_F4_chLLR = do_F4(alpha);
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // G4 decoding stage. reverse bit order only
  //------------------------------------------------------------------------------------------------------

  function automatic alpha_hw_t do_G4 (input alpha_w_t alpha, input bit [7 : 0] decodeb, bit bsel);
    alpha_hw_t    alphaL, alphaR;
    alpha_hw_t    vnode_llr;
    logic [3 : 0] decodebL;
    bit           u_p;
  begin
    alphaL = '{alpha[0], alpha[2], alpha[4], alpha[6]};
    alphaR = '{alpha[1], alpha[3], alpha[5], alpha[7]};
    //
    decodebL = bsel ? decodeb[4 +: 4] : decodeb[0 +: 4];
    //
    for (int beta = 0; beta < 4; beta++) begin
      u_p = decodebL[beta];
      //
      vnode_llr[beta] = vnode(alphaL[beta], alphaR[beta], u_p);
    end
    //
    return vnode_llr;
  end
  endfunction

  function automatic alpha_hw_t do_G4_chLLR (input llr_w_t llr, input bit [7 : 0] decodeb, bit bsel);
    alpha_w_t  alpha;
  begin
    for (int i = 0; i < 8; i++) alpha[i] = $signed(llr[i]);
    //
    do_G4_chLLR = do_G4(alpha, decodeb, bsel);
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // Comb 4 function. reverse bit only
  //------------------------------------------------------------------------------------------------------

  function automatic bit [7 : 0] do_comb4 (input bit [3 : 0] bitL, bitR);
  begin
    {do_comb4[6], do_comb4[4], do_comb4[2], do_comb4[0]} = bitL ^ bitR;
    {do_comb4[7], do_comb4[5], do_comb4[3], do_comb4[1]} = bitR;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // polar 4x4 decode.
  //------------------------------------------------------------------------------------------------------

  // reverse bit order only
  function automatic bit [3 : 0] do_ns_decode_4x4(input alpha_hw_t alpha, bit [3 : 0] frozenb);
    bit [3 : 0] decodeb;
    alpha_hw_t  alpha2dec;
    bit [3 : 0] bit2out;
  begin
    alpha2dec = '{alpha[0], alpha[2],
                  alpha[1], alpha[3]};

//  decodeb = do_ns_decode_4x4_sc(alpha2dec, frozenb);
//  decodeb = do_ns_decode_4x4_fssc2(alpha2dec, frozenb);
    decodeb = do_ns_decode_4x4_fssc4(alpha2dec, frozenb);

    bit2out = {decodeb[3], decodeb[1],
               decodeb[2], decodeb[0]};

    return bit2out;
  end
  endfunction

  // classic SC decode. linear order
  function automatic bit [3 : 0] do_ns_decode_4x4_sc (input alpha_hw_t llr, bit [3 : 0] frozenb);
    alpha_dat_t sLLR [2][4];
    bit         b    [2][4];
  begin
    sLLR[0][0] = cnode(llr[0], llr[2]);
    sLLR[0][1] = cnode(llr[1], llr[3]);
    //
    //
    sLLR[1][0] = cnode(sLLR[0][0], sLLR[0][1]);
    b   [1][0] = frozenb[0] ? 1'b0 : ((sLLR[1][0] >= 0) ? 0 : 1);
    //
    sLLR[1][1] = vnode(sLLR[0][0], sLLR[0][1], b[1][0]);
    b   [1][1] = frozenb[1] ? 1'b0 : ((sLLR[1][1] >= 0) ? 0 : 1);
    //
    b[0][0] = b[1][0] ^ b[1][1];
    b[0][1] = b[1][1];
    //
    sLLR[0][2] = vnode(llr[0], llr[2], b[0][0]);
    sLLR[0][3] = vnode(llr[1], llr[3], b[0][1]);
    //
    sLLR[1][2] = cnode(sLLR[0][2], sLLR[0][3]);
    b   [1][2] = frozenb[2] ? 1'b0 : ((sLLR[1][2] >= 0) ? 0 : 1);
    //
    sLLR[1][3] = vnode(sLLR[0][2], sLLR[0][3], b[1][2]);
    b   [1][3] = frozenb[3] ? 1'b0 : ((sLLR[1][3] >= 0) ? 0 : 1);
    //
    b[0][2] = b[1][2] ^ b[1][3];
    b[0][3] = b[1][3];
    //
    do_ns_decode_4x4_sc[0] = b[0][0] ^ b[0][2];
    do_ns_decode_4x4_sc[1] = b[0][1] ^ b[0][3];
    do_ns_decode_4x4_sc[2] = b[0][2];
    do_ns_decode_4x4_sc[3] = b[0][3];
  end
  endfunction

  // fast by 2 SC decode. linear order
  function automatic bit [3 : 0] do_ns_decode_4x4_fssc2 (input alpha_hw_t llr, bit [3 : 0] frozenb);
    alpha_dat_t sLLR [4][2];
    bit [3 : 0] b    ;
  begin
    sLLR[0][0] = cnode(llr[0], llr[2]);
    sLLR[1][0] = cnode(llr[1], llr[3]);

    sLLR[2][0] = vnode(llr[0], llr[2], 0);
    sLLR[3][0] = vnode(llr[1], llr[3], 0);

    sLLR[2][1] = vnode(llr[0], llr[2], 1);
    sLLR[3][1] = vnode(llr[1], llr[3], 1);
    //
    b[1 : 0] = do_ns_decode_2x2_fssc2('{sLLR[0][0], sLLR[1][0]}, frozenb[1 : 0]);
    //
//  sLLR[2] = vnode(llr[0], llr[2], b[0]);
//  sLLR[3] = vnode(llr[1], llr[3], b[1]);
    //
    b[3 : 2] = do_ns_decode_2x2_fssc2('{sLLR[2][b[0]], sLLR[3][b[1]]}, frozenb[3 : 2]);
    //
    do_ns_decode_4x4_fssc2[0] = b[0] ^ b[2];
    do_ns_decode_4x4_fssc2[1] = b[1] ^ b[3];
    do_ns_decode_4x4_fssc2[2] = b[2];
    do_ns_decode_4x4_fssc2[3] = b[3];
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // polar 4x4 fast sc by 4 bits decode. linear order
  //------------------------------------------------------------------------------------------------------

  function automatic bit [3 : 0] do_ns_decode_4x4_fssc4 (input alpha_dat_t alpha [4], bit [3 : 0] frozenb);
    bit [3 : 0] decodeb;
  begin
    decodeb = decode_Rate1_4(alpha);
    //
    case (frozenb)
//    4'b1111   : begin
//      decodeb = decode_Rate0_4(alpha);
//    end
      4'b0000   : begin
        decodeb = decode_Rate1_4(alpha);
      end
      4'b0111   : begin
        decodeb = decode_Rep_4(alpha);
      end
      4'b0001   : begin
        decodeb = decode_Spc_4(alpha);
      end
      4'b0011   : begin
        decodeb = decode_Rate0_2_Rate1_2(alpha);
      end
      4'b0101   : begin
        decodeb = decode_Rep_2_Rep_2(alpha);
      end

      default : begin
        // synthesis translate_off
        $display("unknown opcode use sc %b", frozenb);
        $stop;
        // synthesis translate_on
      end
    endcase

    return decodeb;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // polar 2x2 fast sc decode. linear order
  //------------------------------------------------------------------------------------------------------

  function automatic bit [1 : 0] do_ns_decode_2x2_fssc2 (input alpha_dat_t alpha [2], bit [1 : 0] frozenb);
    alpha_tdat_t  sum;
    alpha_dat_t   sign_cnode;
    logic [1 : 0] decodeb;
  begin
    sum         = alpha[0] + alpha[1];
    //
    sign_cnode  = sign_alpha(alpha[0]) ^ sign_alpha(alpha[1]);
    //
    case (frozenb)
      // Rate 1
      2'b00 : begin
        decodeb[0] = sign_alpha(alpha[0]);
        decodeb[1] = sign_alpha(alpha[1]);
      end
      // Rep2
      2'b01 : begin
        decodeb[0] = sign_talpha(sum);
        decodeb[1] = sign_talpha(sum);
      end
      // Spc2
      2'b10 : begin
        decodeb[0] = sign_cnode;
        decodeb[1] = 0;
      end
      // Rate0
      default : decodeb = 2'b00;
    endcase

    return decodeb;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // fast decode 8 bit functions : linear order
  //------------------------------------------------------------------------------------------------------

  // 8'b11111111
  function automatic bit [7 : 0] decode_Rate0_8 (input alpha_dat_t alpha [8]);
    decode_Rate0_8 = 8'h00;
  endfunction

  // 8'b00000000
  function automatic bit [7 : 0] decode_Rate1_8 (input alpha_dat_t alpha [8]);
    for (int i = 0; i < 8; i++) begin
      decode_Rate1_8[i] = sign_alpha(alpha[i]); // (alpha[i] >= 0) ? 0 : 1;
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // fast decode 4 bit functions : linear order
  //------------------------------------------------------------------------------------------------------

  // 4'b1111
  function automatic bit [3 : 0] decode_Rate0_4 (input alpha_dat_t alpha [4]);
    decode_Rate0_4 = 4'h0;
  endfunction

  // 4'b0000
  function automatic bit [3 : 0] decode_Rate1_4 (input alpha_dat_t alpha [4]);
    for (int i = 0; i < 4; i++) begin
      decode_Rate1_4[i] = sign_alpha(alpha[i]); // (alpha[i] >= 0) ? 0 : 1;
    end
  endfunction

  // 4'b0111
  function automatic bit [3 : 0] decode_Rep_4 (input alpha_dat_t alpha [4]);
    alpha_tdat_t sum;
  begin
    sum = alpha[0] + alpha[1] + alpha[2] + alpha[3];
    for (int i = 0; i < 4; i++) begin
      decode_Rep_4[i] = sign_talpha(sum); // (sum >= 0) ? 0 : 1;
    end
  end
  endfunction

  // 4'b0001
  function automatic bit [3 : 0] decode_Spc_4 (input alpha_dat_t alpha [4]);
    logic       pc;
    //
    alpha_dat_t abs_llr     [4];
    alpha_dat_t min_llr     [2];
    bit [1 : 0] min_llr_idx [2];
    //
    bit [1 : 0] min_rslt       ;
  begin
    for (int i = 0; i < 4; i++) begin
      decode_Spc_4[i] = sign_alpha(alpha[i]); // (alpha[i] >= 0) ? 0 : 1;
    end
    pc = ^decode_Spc_4;
    //
    for (int i = 0; i < 4; i++) begin
      abs_llr[i] = abs_alpha(alpha[i]);
    end

    min_llr     [0] = (abs_llr[1] > abs_llr[0]) ? abs_llr[0] : abs_llr[1];
    min_llr_idx [0] = (abs_llr[1] > abs_llr[0]) ?         0  :         1 ;

    min_llr     [1] = (abs_llr[3] > abs_llr[2]) ? abs_llr[3] : abs_llr[2];
    min_llr_idx [1] = (abs_llr[3] > abs_llr[2]) ?         3  :         2 ;
    //
    min_rslt = (min_llr[1] > min_llr[0]) ? min_llr_idx[0] : min_llr_idx[1];
    //
    decode_Spc_4[min_rslt] ^= pc;
  end
  endfunction

  // 4'b0011
  function automatic bit [3 : 0] decode_Rate0_2_Rate1_2 (input alpha_dat_t alpha [4]);
    alpha_tdat_t sum [2];
  begin
    sum[0] = alpha[0] + alpha[2]; // vnode(alpha[0], alpha[2], 0);
    sum[1] = alpha[1] + alpha[3]; // vnode(alpha[1], alpha[3], 0);
    //
    decode_Rate0_2_Rate1_2[0] = sign_talpha(sum[0]);  //(sum_llr[0] >= 0) ? 0 : 1;
    decode_Rate0_2_Rate1_2[2] = sign_talpha(sum[0]);  //(sum_llr[0] >= 0) ? 0 : 1;
    //
    decode_Rate0_2_Rate1_2[1] = sign_talpha(sum[1]);  //(sum_llr[1] >= 0) ? 0 : 1;
    decode_Rate0_2_Rate1_2[3] = sign_talpha(sum[1]);  //(sum_llr[1] >= 0) ? 0 : 1;
  end
  endfunction

  // 4'b0101
  function automatic bit [3 : 0] decode_Rep_2_Rep_2 (input alpha_dat_t alpha [4]);
    alpha_dat_t   nodeL [2] ;
    alpha_tdat_t  sumL      ;

    alpha_tdat_t  nodeR [2] ;

    bit           bit0;
    bit           bit1;
  begin
    nodeL[0] = cnode(alpha[0], alpha[2]);
    nodeL[1] = cnode(alpha[1], alpha[3]);
    sumL     = nodeL[0] + nodeL[1];       // rep

    nodeR[0] = alpha[2] + alpha[0] + alpha[3] + alpha[1]; // vnode(alpha[0], alpha[2], 0) + vnode(alpha[1], alpha[3], 0);
    nodeR[1] = alpha[2] - alpha[0] + alpha[3] - alpha[1]; // vnode(alpha[0], alpha[2], 1) + vnode(alpha[1], alpha[3], 1);

    bit0      = sign_talpha(sumL);
    bit1      = sign_talpha(nodeR[bit0]);;

    decode_Rep_2_Rep_2[0] = bit1 ^ bit0;
    decode_Rep_2_Rep_2[1] = bit1 ^ bit0;

    decode_Rep_2_Rep_2[2] = bit1;  // rep
    decode_Rep_2_Rep_2[3] = bit1;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // node functions
  //------------------------------------------------------------------------------------------------------

  function automatic alpha_dat_t cnode (input alpha_dat_t aL, aR);
//  cnode = cnode_ref(aL, aR);
    cnode = cnode_fast(aL, aR);
  endfunction

  function automatic alpha_dat_t cnode_ref (input alpha_dat_t aL, aR);
    alpha_dat_t abs_aL,  abs_aR;
    logic       sign_aL, sign_aR;
    //
    alpha_dat_t abs;
  begin
    sign_aL   = sign_alpha(aL); // (aL < 0);
    sign_aR   = sign_alpha(aR); // (aR < 0);
    //
    abs_aL    = abs_alpha(aL);  // sign_aL ? -aL : aL;
    abs_aR    = abs_alpha(aR);  // sign_aR ? -aR : aR;
    //
    abs       = (abs_aL < abs_aR) ? abs_aL : abs_aR;
    //
    cnode_ref = (sign_aL ^ sign_aR) ? -abs: abs;
  end
  endfunction

  function automatic alpha_dat_t cnode_fast (input alpha_dat_t aL, aR);
    alpha_dat_t abs_aL,  abs_aR;
    logic       sign_aL, sign_aR;
    //
    alpha_dat_t add, sub;
    logic       sign_add, sign_sub;
  begin
    sign_aL   = sign_alpha(aL); // (aL < 0);
    sign_aR   = sign_alpha(aR); // (aR < 0);

    {sign_add, add} = (aL + aR);
    {sign_sub, sub} = (aL - aR);
    //
    case ({sign_aL, sign_aR})
      2'b01 : cnode_fast = sign_add ? -aL : aR;
      2'b10 : cnode_fast = sign_add ? -aR : aL;
      //
      2'b00 : cnode_fast = sign_sub ?  aL : aR;
      2'b11 : cnode_fast = sign_sub ? -aR : -aL;
    endcase
  end
  endfunction

  function automatic alpha_dat_t vnode (alpha_dat_t aL, aR, bit bL);
    logic signed [cALPHA_W : 0] tmp;      // +1 bit
    logic signed [cALPHA_W : 0] max_neg;  // +1 bit
  begin
    //
    tmp   = bL ? (aR - aL) : (aR + aL);
    vnode = tmp[cALPHA_W-1 : 0];
    // saturate if need
    if (cALPHA_TRUE_W > cALPHA_W) begin
      max_neg = {2'b11, {{cALPHA_W-1}{1'b0}}};
      //
      if (tmp == max_neg) begin
        vnode = {1'b1, {{cALPHA_W-2}{1'b0}}, 1'b1};
      end
      else if (tmp[cALPHA_W] ^ tmp[cALPHA_W-1]) begin
        if (tmp[cALPHA_W]) // negative overflow
          vnode = {1'b1, {{cALPHA_W-2}{1'b0}}, 1'b1};
        else // positive overflow
          vnode = {1'b0, {{cALPHA_W-2}{1'b1}}, 1'b1};
      end
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // useful functions
  //------------------------------------------------------------------------------------------------------

  function automatic alpha_dat_t abs_alpha (input alpha_dat_t dat);
    abs_alpha = (dat ^ {cALPHA_W{dat[cALPHA_W-1]}}) ^ dat[cALPHA_W-1];
  endfunction

  function automatic alpha_dat_t abs_LLR (input llr_t dat);
    abs_LLR = (dat ^ {pLLR_W{dat[pLLR_W-1]}}) ^ dat[pLLR_W-1];
  endfunction

  function automatic logic sign_alpha (input alpha_dat_t dat);
    sign_alpha = dat[cALPHA_W-1];
  endfunction

  function automatic logic sign_talpha (input alpha_tdat_t dat);
    sign_talpha = dat[cALPHA_TRUE_W-1];
  endfunction

