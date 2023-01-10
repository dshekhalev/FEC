//
// Project       : RS
// Author        : Shekhalev Denis (des00)
// Workfile      : rs_functions.svh
// Description   : RS code generation function
//

  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  // code generator poly
  //  NOTE :: generation poly order is inverted, that is [check..0] = x^0..x^check.
  //  Take it into account at encoder architecture
  //------------------------------------------------------------------------------------------------------

  function automatic gpoly_t generate_pol_coeficients (input uint_t genstart, rootspace, lcheck, input rom_t index_of, alpha_to);
    uint_t  tcheck;
    data_t  gg    [0 : check];
    data_t  ggmul [0 : check];
    uint_t  alpha;
    uint_t  alpha_step;
  begin
    tcheck = (lcheck < 2) ? 2 : lcheck;
    // initialization
    alpha_step = alpha_to[rootspace];

    gg[0] = 1;
    gg[1] = alpha_to[(genstart*rootspace) % gf_n_max];
    for (int i = 2; i <= check; i++) gg [i] = 0;

    alpha = alpha_to[((genstart + 1)*rootspace) % gf_n_max];

    for (int j = 0; j <= tcheck-2; j++) begin
      for (int p = 1; p <= j+2; p++) begin
        //ggmul[p] = gf_mul(gg[p-1], alpha, index_of, alpha_to);
        ggmul[p] = gf_mult_a_by_b(gg[p-1], alpha);
      end

      for (int p = 1; p <= j+2; p++) begin
        //gg[p] = gf_add(gg[p], ggmul[p]);
        gg[p] = gg[p] ^ ggmul[p];
      end

      //alpha = gf_mul(alpha, alpha_step, index_of, alpha_to);
      alpha = gf_mult_a_by_b(alpha, alpha_step);
    end
    generate_pol_coeficients = gg;
  end
  endfunction

  function automatic gpoly_t clear_gpoly (input data_t val = 0);
    for (int i = 0; i < $size(clear_gpoly); i++) begin
      clear_gpoly[i] = val;
    end
  endfunction


