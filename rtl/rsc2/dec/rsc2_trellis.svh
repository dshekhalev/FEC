//
// Project       : rsc2
// Author        : Shekhalev Denis (des00)
// Workfile      : rsc2_trellis.svh
// Description   : file with RSC2 trellis generate functions
//

  //------------------------------------------------------------------------------------------------------
  // define types and functions to get RSC2 trellis
  //------------------------------------------------------------------------------------------------------

  typedef struct {
    bit [3 : 0] nextStates [16][4];
    bit [3 : 0] preStates  [16][4];
    bit [1 : 0] outputs    [16][4];
    bit         outputsy   [16][4];
    bit         outputsw   [16][4];
  } trellis_t;

  trellis_t trel;

  always_comb begin
    trel = get_rsc2_trellis (0);
  end

  //------------------------------------------------------------------------------------------------------
  // function's to get RSC2 trellis
  //------------------------------------------------------------------------------------------------------

  function trellis_t get_rsc2_trellis (input int tmp);
    trellis_t   trel;
    bit [3 : 0] nstate;
    bit         y, w;
  begin
    for (int ab = 0; ab < 4; ab++) begin
      for (int state = 0; state < 16; state++) begin
        nstate = {ab[1] ^ state[0] ^ state[1], state[3:1]}; // feedback poly [1 0 0 1 1]
        nstate = nstate ^ {ab[0], ab[0], 1'b0, ab[0]};

        y = nstate[3] ^ state[3] ^ state[2] ^            state[0]; // poly [1 1 1 0 1]
        w = nstate[3] ^            state[2] ^ state[1] ^ state[0]; // poly [1 0 1 1 1]
        //
        trel.nextStates[state][ab] = nstate;
        trel.outputsy  [state][ab] = y;
        trel.outputsw  [state][ab] = w;
        trel.outputs   [state][ab] = {y, w};
      end
    end
    //
    for (int ab = 0; ab < 4; ab++) begin
      for (int state = 0; state < 16; state++) begin
        nstate = trel.nextStates[state][ab];
        trel.preStates[nstate][ab] = state[3 : 0];
      end
    end
    //
    get_rsc2_trellis = trel;
  end
  endfunction

