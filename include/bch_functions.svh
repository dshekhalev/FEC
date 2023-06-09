//
// Project       : bch
// Author        : Shekhalev Denis (des00)
// Workfile      : bch_functions.svh
// Description   : BCH functions to get BCH generation poly
//
  `include "bch_define.vh"
  `include "gf_functions.svh"

  //------------------------------------------------------------------------------------------------------
  // Compute the generator polynomial of a binary BCH code.
  // 1. Generate the cycle sets modulo 2**m - 1, cycle[][] =  (i, 2*i, 4*i, ..., 2^l*i).
  // 2. Determine those cycle sets that contain integers in the set of (d-1) consecutive integers {1..(d-1)} i.e. detect roots
  // 3. The generator polynomial is calculated as the product of linear factors of the form (x+alpha^i)
  //    for every i in the above cycle sets.
  // function prototype taken from MATLAB
  //------------------------------------------------------------------------------------------------------

  function gpoly_t generate_pol_coeficients (input int n, k, d, input rom_t index_of, alpha_to);
    uint_t ii, jj, ll, kaux;

    data_t aux;
    data_t test;
    data_t root;

//  data_t cycle [gf_n_max][gf_n_max]; // cycle sets modulo n indexes
//  data_t  size [gf_n_max];   // size of cycle sets

    data_t cycle [`__BCH_GEN_POLY_CYCLE_SET_MAX_NUM__][`__BCH_GEN_POLY_CYCLE_SET_MAX_SIZE__]; // cycle sets modulo n indexes
    data_t  size [`__BCH_GEN_POLY_CYCLE_SET_MAX_NUM__];   // size of cycle sets

    data_t  min  [gf_n_max];
    data_t  zeros[gf_n_max];

    data_t nocycles;                   // number of cycle sets modulo n
    data_t rdncy;                      // code redundancy
    data_t noterms;                    // number of used cycles sets

    data_t g [0 : gf_n_max-k_max]; // generated poly

    bit [1 : gf_n_max] ind ;

  begin
    generate_pol_coeficients = '0;
    //
    // Generate cycle sets modulo n, n = 2**m - 1
    //
    cycle[0][0] = 0;  size[0] = 1;
    cycle[1][0] = 1;  size[1] = 1;

    ind = '1; // clear check index flag

    jj = 1;
    ll = 1;
    do begin
      // count cycle sets modulo n entries
      ii = 0;

      ind [cycle[jj][ii]] = 1'b0;  // set check flag for 0 index (is always in cycle set)

      aux = (cycle[jj][ii] * 2) % n;   // cycle[][] =  (i, 2*i, 4*i, ..., 2^l*i) % 2^n-1
      while (aux != cycle[jj][0]) begin
        // new index
        ii++;
        cycle [jj][ii] = aux;
        size  [jj]++;
        ind [cycle[jj][ii]] = 0; // set check frag for other index
        // get new index
        aux = (cycle[jj][ii] * 2) % n;
      end

      for (ll = ll ; ll < (n-1); ll++) begin
        if (ind[ll] != 0) begin
          jj++;
          cycle[jj][0]  = ll;
          size[jj]      = 1;
          break;
        end
      end
    end
    while (ll < (n - 1)); // stop when all GF is in classes
    nocycles = jj;    // number of cycle sets modulo n
`ifdef __BCH_GEN_POLY_DEBUG_LOG__
    begin
      int max_size;
      $display("amount of cycle sets is %0d", nocycles);
      for (ii = 0; ii < nocycles; ii++) begin
        max_size = (size[ii] > max_size) ? size[ii] : max_size;
      end
      $display("max cycle sets is %0d", max_size);
    end
`endif
    //
    // define zeros : search cycle set include roots index 1,2,...d-1
    //
    kaux  = 0;
    rdncy = 0;
    for (ii = 1; ii <= nocycles; ii++) begin
      min[kaux] = 0;
      test = 0;
      for (jj = 0; ((jj < size[ii]) && !test); jj++) begin
        for (root = 1; ((root < d) && !test); root++) begin
          if (root == cycle[ii][jj])  begin // root is in current cycle set
            test = 1;
            min[kaux] = ii;           // store current cycle set index as used
            rdncy += size[min[kaux]]; // count redundancy for check code parameters
            kaux++;
          end
        end
      end
    end
    //
    // convert zeros from index form to alpha form
    //
    noterms = kaux;
    kaux = 1;
    for (ii = 0; ii < noterms; ii++) begin
      for (jj = 0; jj < size[min[ii]]; jj++) begin
        zeros[kaux] = alpha_to[cycle[min[ii]][jj]];
        kaux++;
      end
    end
    // synthesis translate_off
    assert ((n - rdncy) == k) else begin
      $error("%m BCH poly parameters invalid! This is a (%d, %d, %d) binary BCH code", n, n-rdncy, d);
    end
    // synthesis translate_on
    if ((n-rdncy) != k) begin
      return generate_pol_coeficients;
    end

    rdncy = n- k; // optimization for syn-thesis
    //
    // count generator poly
    //
    g[0] = zeros[1];
    g[1] = 1;       // g(x) = (X + zeros[1]) initially
    for (ii = 2; ii <= rdncy; ii++) begin
      g[ii] = 1;
      for (jj = ii - 1; jj > 0; jj--) begin
        if (g[jj] != 0)
          //g[jj] = gf_add(g[jj - 1], gf_mul(g[jj], zeros[ii], index_of, alpha_to));
          g[jj] = g[jj - 1] ^ gf_mult_a_by_b(g[jj], zeros[ii]);
        else
          g[jj] = g[jj - 1];
      end
      //g[0] = gf_mul(g[0], zeros[ii], index_of, alpha_to);
      g[0] = gf_mult_a_by_b(g[0], zeros[ii]);
    end

    //
    // assemble output poly
    //
    for (ii = 0; ii <= rdncy; ii++) begin
      generate_pol_coeficients[ii] = g[ii][0];
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // code generator poly functions used as table
  //  NOTE :: set as is (taken from MATLAB)
  //------------------------------------------------------------------------------------------------------

  function gpoly_t generate_pol_coeficients_tab (input int n, k, d, input rom_t index_of, alpha_to);
    gpoly_t result;
  begin
    if (n == 15) begin // GF(2^4)
      case (k)
        5   : result = 11'b10100110111; // x^10 + x^8 + x^5 + x^4 + x^2 + x + 1
        7   : result =  9'b111010001;   // x^8  + x^7 + x^6 + x^4 + 1
        11  : result =  5'b10011;       // x^4  + x + 1
      endcase
    end
    else if (n == 127) begin // GF(2^7)
      case (k)
        64  : result = 64'b1111010010000100010101010001100010111001010110000010101000011111;
        50  : result = 78'b101001000100110001111100001001101011000111101000011100000001101110111001101111;
        43  : result = 85'b1100110100001011000110000101000101110001011100000110100010110011011110000110001011101;
      endcase
    end
    else if (n == 255) begin // GF(2^8)
      case (k)
        131 : result = 125'b10011100110101110000101000001000110001000100111111101000010101010001101010010110000010010110011100110011011011010011110110001;
        155 : result = 101'b11011001111111101100101100101100010101001011110110000010101101111100000110100000011010010111110111111;
        171 : result =  85'b1111100110001100111000110001111110000111011100100011100101000100011000100111000011011;
        179 : result =  77'b10110100100000011001110000101011000100000111011110011100010011100101001101001;
        223 : result =  33'b101111110100001011011010011101111;
        231 : result =  25'b1010110110000101110111011;
        239 : result =  17'b11000110111101101;
      endcase
    end
    else if (n == 1023) begin
      case (k)
        1003 : result = 21'b100000001100001110111;
      endcase
    end
    else if (n == 2047) begin
//    case (k)
//      1959 : result = 12'b100000000101;// x^11+x^2+1 2053
//    endcase
    end
    else if (n == 8191) begin
      case (k)
//      g(x)= 1 + x^2 + x^3 + x^5 + x^6 + x^7 + x^8 + x^10 + x^11 + x^12 + x^13 + x^15 + x^17 + x^20 + x^21 + x^23 + x^24
//       + x^26 + x^28 + x^29 + x^30 + x^31 + x^33 + x^35 + x^36 + x^37 + x^39
        8152 : result = 40'b1011101011110101101100101011110111101101;
        8087 : result = 105'b100010101111110010001010011100000011110110000110000010011100001110100000111000101110001001111101100100011;
      endcase
    end
    else if (n == 16383) begin
      case (k)
        // DVB prim_poly = 16427
        16215 : result = {1'b1, 168'h4062DBEA9869B262CD23A39069528FE7D7D11905A5};
        // prim_poly = 17475 (!!!!!!)
//      16341 : result =  43'b1000011100111000011001000101000011110100011;
//      16215 : result = 169'b1001000001011101110100101010010010101011001101011101000100011000000000100101111110011010001011101011110101101110001111001111010101110001100110011000011000101011000001101;
      endcase
    end
    else if (n == 32767) begin
      // DVB prim poly = 32813
      case (k)
        32587 : result = {1'b1, 180'hA84BB7DB0018D0982039BF6A085335635742FC3D8410B};
        // DVB prim poly = 32771
//      32587 : result = {1'b1, 180'hF3CCCA1B16B1F8B1C4A9371685B35D1F0E168D8592B1B};
      endcase
    end
    else if (n == 65535) begin
      // DVB prim poly = 65581
      case (k)
        65407 : result = {1'b1, 128'h1C07255F712797BD19FC6D7504F9662B};
        65375 : result = {1'b1, 160'h60150CEDFC2A331F6A785703EFD12301B8BB6591};
        65343 : result = {1'b1, 192'h4E260E83845C511C50CF2CD8DC350889034785F7660255E7};
      endcase
    end
    generate_pol_coeficients_tab = result;
  end
  endfunction

