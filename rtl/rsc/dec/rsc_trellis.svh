//
// Project       : rsc
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc_trellis.svh
// Description   : file with RSC trellis generate functions
//

  //------------------------------------------------------------------------------------------------------
  // define types and functions to get RSC trellis
  //------------------------------------------------------------------------------------------------------

  typedef struct {
    bit [2 : 0] nextStates [8][4];
    bit [2 : 0] preStates  [8][4];
    bit [1 : 0] outputs    [8][4];
    bit         outputsy   [8][4];
    bit         outputsw   [8][4];
  } trellis_t;

  trellis_t trel;

  always_comb begin
    trel = get_rsc_trellis (0);
  end

  //------------------------------------------------------------------------------------------------------
  // function's to get rsc trellis
  //------------------------------------------------------------------------------------------------------

  function trellis_t get_rsc_trellis (input int tmp);
    trellis_t   trel;
    bit [2 : 0] nstate;
    bit         y, w;
  begin
    for (int ab = 0; ab < 4; ab++) begin
      for (int state = 0; state < 8; state++) begin
        nstate = {ab[1] ^ state[2] ^ state[0], state[2:1]}; // feedback poly [1 1 0 1]
        nstate = nstate ^ {3{ab[0]}};

        y = nstate[2] ^ state[1] ^ state[0]; // poly [1 0 1 1]
        w = nstate[2] ^            state[0]; // poly [1 0 0 1]
        //
        trel.nextStates[state][ab] = nstate;
        trel.outputsy  [state][ab] = y;
        trel.outputsw  [state][ab] = w;
        trel.outputs   [state][ab] = {y, w};
      end
    end
    //
    for (int ab = 0; ab < 4; ab++) begin
      for (int state = 0; state < 8; state++) begin
        nstate = trel.nextStates[state][ab];
        trel.preStates[nstate][ab] = state[2 : 0];
      end
    end
    //
    get_rsc_trellis = trel;
  end
  endfunction

  function logic [4 : 0] do_encode (input logic a, b, input logic [2 : 0] state);
    logic [2 : 0] nstate;
    logic         y, w;
  begin
    nstate = {a ^ state[2] ^ state[0], state[2:1]}; // feedback poly [1 1 0 1]
    nstate = nstate ^ {3{b}};

    y = nstate[2] ^ state[1] ^ state[0]; // poly [1 0 1 1]
    w = nstate[2] ^            state[0]; // poly [1 0 0 1]

    do_encode = {y, w, nstate};
  end
  endfunction
