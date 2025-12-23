//
// Project       : hamming
// Author        : Shekhalev Denis (des00)
// Workfile      : hamming_parameters.svh
// Description   : Hamming codec parameters and functions
//

  parameter int pR      = 5; // number of check bits

  localparam int cDBITS = 2 ** pR - 1 - pR;  // number of data bits
  localparam int cCBITS = 2 ** pR - 1;       // number of frame bits except even bit for extended code

  typedef bit [cCBITS-1 : 0] M_t [pR]; // check matrix

  typedef int P_t [2 ** pR]; // permutation matrix

  //------------------------------------------------------------------------------------------------------
  // function to generate matrix
  //------------------------------------------------------------------------------------------------------

  function M_t generate_M_matrix (input bit nul);
    M_t   tmpM;
    P_t   perm;
  begin
    // generate H matrix
    for (int i = 1; i <= cCBITS; i++) begin
      for (int r = 0; r < pR; r++) begin
        tmpM[r][i-1] = i[r];
      end
    end
    // convert matrix to systematic view
    // it's not canonical matrix H = [Hk, In-k], matrix order is H = [In-k, Hk]
    // because vector has [msb:lsb] format (!!!)
    perm = generate_permutation(0);
    for (int i = 0; i < cCBITS; i++) begin
      for (int r = 0; r < pR; r++) begin
        generate_M_matrix[r][i] = tmpM[r][perm[i]];
      end
    end
  end
  endfunction

  function P_t generate_permutation (input bit nul);
    int j, k;
    int check_idx [pR];
    int inside_ok;
  begin
    for (int r = 0; r < pR; r++) begin
      check_idx[r] = 2**r-1;
    end
    //
    j = 0; k = 0;
    //
    for (int i = 0; i < cCBITS; i++) begin
      for (int r = 0; r < pR; r++) begin
        inside_ok = (r == 0) ? (i == check_idx[r]) : (inside_ok | (i == check_idx[r]));
      end
      if (inside_ok) begin
        generate_permutation[cDBITS + k++] = i;
      end
      else begin
        generate_permutation[j++] = i;
      end
    end
  end
  endfunction

  function P_t generate_inv_permutation (input bit nul);
    int j, k;
    int check_idx [pR];
    int inside_ok;
  begin
    for (int r = 0; r < pR; r++) begin
      check_idx[r] = 2**r-1;
    end
    //
    j = 0; k = 0;
    //
    for (int i = 0; i < cCBITS; i++) begin
      for (int r = 0; r < pR; r++) begin
        inside_ok = (r == 0) ? (i == check_idx[r]) : (inside_ok | (i == check_idx[r]));
      end
      if (inside_ok) begin
        generate_inv_permutation[i+1] = cDBITS + k++; // + 1 offset for syndrome == 0
      end
      else begin
        generate_inv_permutation[i+1] = j++;
      end
    end
  end
  endfunction

