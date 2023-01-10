//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : gf_functions.svh
// Description   : galua field GF(2^m) arithmetic functions
//

  //------------------------------------------------------------------------------------------------------
  // galua field GF(2^m) based upon irreducible poly irrpol generation
  //------------------------------------------------------------------------------------------------------

  function automatic rom_t generate_gf_alpha_to_power (input uint_t irp = irrpol);
    int i;
    //rom_t alpha_to;
    data_t alpha_to [0 : gf_n_max];  // questa hack
  begin
    // initialization
    for (i = 0; i < m; i++) begin
      alpha_to[i] = 1 << i;
    end

    alpha_to[m] = irp[m-1 : 0];

    for (i = m + 1; i <= gf_n_max; i++) begin
      if (alpha_to[i - 1][m-1]) begin  // if poly element degree is more a^(m-1)
        alpha_to[i] = alpha_to[m] ^ (alpha_to[i - 1] << 1);  // take it by module 2^m (msb removed at shift left of bit vector [m-1 : 0]
                                                             // and mult by z
      end
      else begin
        alpha_to[i] = alpha_to[i - 1] << 1; // mult by z
      end
    end
    generate_gf_alpha_to_power = alpha_to;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // index table of GF(2^m) generation for galua multiply and divide arithmetic
  //------------------------------------------------------------------------------------------------------

  function automatic rom_t generate_gf_index_of_alpha (input rom_t alpha_to);
    //rom_t result;
    data_t result    [0 : gf_n_max];
  begin
    result[0] = 0;
    for (int i = 0; i <= gf_n_max; i++) begin
      result[alpha_to[i]] = i;
    end
    generate_gf_index_of_alpha = result;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // galua arithmetic behaviour functions
  //------------------------------------------------------------------------------------------------------

  function automatic uint_t gf_add (input uint_t a, b);
    gf_add = a ^ b;
  endfunction

  function automatic uint_t gf_mul (input uint_t a, b, input rom_t index_of, alpha_to);
    if ((a == 0) || (b == 0))
      gf_mul = 0;
    else
      gf_mul = alpha_to[(index_of[a] + index_of[b]) % gf_n_max];
  endfunction

  function automatic uint_t gf_div (input uint_t a, b, input rom_t index_of, alpha_to);
    int index_of_a;
    int index_of_b;
    int index_of_div;
  begin
    index_of_a    = index_of[a];
    index_of_b    = index_of[b];
    index_of_div  = index_of_a - index_of_b;
    //
    if ((a == 0) || (b == 0)) begin
      gf_div = 0;
    end
    else begin
      gf_div = alpha_to[(gf_n_max + index_of_div) % gf_n_max];
    end
  end
  endfunction

  function automatic rom_t generate_gf_alpha_to_inv_alpha (input rom_t index_of, alpha_to);
    //rom_t result;
    data_t result [0 : gf_n_max];
  begin
    for (int b = 0; b < $size(result); b++) begin
      result[b] = gf_div(1, b, index_of, alpha_to);
    end
    generate_gf_alpha_to_inv_alpha = result;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // galua arithmetic synthesis functions
  //------------------------------------------------------------------------------------------------------

  function automatic logic [m-1 : 0] gf_mult_a_by_b_const (input logic [m-1 : 0] a, b_const, input logic [m : 0] irp = irrpol);
    logic [m-1 : 0] mult        [0 : m-1];
    logic [m-1 : 0] mult_chain  [0 : m-1];
  begin
    // simple algorithm
    // b = b0 + b1*a + b2*a^2 + b3*a^3
    // a * b = 0 + b0*a + b1*a^2 + b2*a^3 + b3*a^4
    //    generate alpha_to(a^n) using piece of generate_gf_alpha_to_power() code
    //
    // generate mult[0 : m] == [a...a^n]
    mult[0] = b_const;                              // from index(b)
    for (int i = 1; i < m; i++) begin               // to   index(b) + m-1
      if (mult[i-1][m-1]) begin                    // ===  alpha_to[i-1] >= mask
        mult[i] = (mult[i-1] << 1) ^ irp[m-1 : 0];  // === (alpha_to[i-1] << 1) ^ alpha_to[m]
      end
      else begin
        mult[i] = (mult[i-1] << 1);                 // === (alpha_to[i-1] << 1)
      end
    end
    //
    // substitute a ^ n in mult result formula & assemble it
    mult_chain[0] = {m{a[0]}} & mult[0];
    for (int i = 1; i < m; i++) begin
      mult_chain[i] = mult_chain[i-1] ^ ({m{a[i]}} & mult[i]);
    end
    //
    gf_mult_a_by_b_const = mult_chain[m-1];
  end
  endfunction

  function automatic logic [m-1 : 0] gf_mult_a_by_b (input logic [m-1 : 0] a, b, input logic [m : 0] irp = irrpol);
    data_t result;
  begin
    result = '0;
    for (int i = m-1; i >= 0; i--) begin
      result = gf_mult_a_by_b_const(result, 2, irp) ^ ({m{a[i]}} & b); // b_const === alpha_to[1] == 2
    end
    gf_mult_a_by_b = result;
  end
  endfunction



