//
// Project       : ccsds turbo
// Author        : Shekhalev Denis (des00)
// Workfile      : ccsds_turbo_trellis.svh
// Description   : file with trellis generate functions
//

  //------------------------------------------------------------------------------------------------------
  // define types and functions to get trellis
  //------------------------------------------------------------------------------------------------------

  typedef struct {
    bit [3 : 0] nextStates [16][2];
    bit [3 : 0] preStates  [16][2];
    bit [2 : 0] outputs    [16][2];
    bit         outputsa1  [16][2];
    bit         outputsa2  [16][2];
    bit         outputsa3  [16][2];
  } trellis_t;

  localparam trellis_t trel = get_trellis (0);

  //------------------------------------------------------------------------------------------------------
  // function's to get rsc trellis
  //------------------------------------------------------------------------------------------------------

  function trellis_t get_trellis (input int tmp);
    trellis_t   trel;
    bit [3 : 0] nstate;
    bit         a1, a2, a3;
  begin
    for (int a0 = 0; a0 < 2; a0++) begin
      for (int state = 0; state < 16; state++) begin
        nstate = {a0[0] ^ state[1] ^ state[0], state[3:1]}; // feedback [1 0 0 1 1] G0

        a1 = nstate[3] ^ state[3] ^            state[1] ^ state[0]; // [1 1 0 1 1] G1
        a2 = nstate[3] ^            state[2] ^            state[0]; // [1 0 1 0 1] G2
        a3 = nstate[3] ^ state[3] ^ state[2] ^ state[1] ^ state[0]; // [1 1 1 1 1] G3

        //
        trel.nextStates[state][a0] = nstate;
        trel.outputsa1 [state][a0] = a1;
        trel.outputsa2 [state][a0] = a2;
        trel.outputsa3 [state][a0] = a3;
        trel.outputs   [state][a0] = {a3, a2, a1};
      end
    end
    //
    for (int a0 = 0; a0 < 2; a0++) begin
      for (int state = 0; state < 16; state++) begin
        nstate = trel.nextStates[state][a0];
        trel.preStates[nstate][a0] = state[3 : 0];
      end
    end
    //
    get_trellis = trel;
  end
  endfunction

  // synthesis translate_off
  function automatic void log_trellis (input int do_print = 1);
    int fp;
  begin
    if (do_print) begin
      fp = $fopen("ccsdc_trellis.log", "w");
      //
      for (int state = 0; state < 16; state++) begin
        for (int b = 0; b < 2; b++) begin
          $fdisplay(fp, "trel[%0d][%b] -> %0d (state) %b(output) %0d (pre_state)", state[3 : 0], b[0], trel.nextStates[state][b], trel.outputs[state][b], trel.preStates[state][b]);
        end
        $fdisplay(fp,"");
      end
      //
      $fclose(fp);
    end
    else begin
      for (int state = 0; state < 16; state++) begin
        for (int b = 0; b < 2; b++) begin
          $display("trel[%0d][%b] -> %0d (state) %b(output) %0d (pre_state)", state[3 : 0], b[0], trel.nextStates[state][b], trel.outputs[state][b], trel.preStates[state][b]);
        end
        $display("");
      end
    end
  end
  endfunction
  // synthesis translate_on

  function logic [8 : 0] do_encode (input logic a0, input logic [3 : 0] state);
    logic [3 : 0] nstate;
    logic         a1, a2, a3;
    logic         term;
  begin
    nstate = {a0 ^ state[1] ^ state[0], state[3:1]}; // feedback [1 0 0 1 1] G0

    a1 = nstate[3] ^ state[3] ^            state[1] ^ state[0]; // [1 1 0 1 1] G1
    a2 = nstate[3] ^            state[2] ^            state[0]; // [1 0 1 0 1] G2
    a3 = nstate[3] ^ state[3] ^ state[2] ^ state[1] ^ state[0]; // [1 1 1 1 1] G3

    term = nstate[1] ^ nstate[0];

    do_encode = {term, a3, a2, a1, a0, nstate};
  end
  endfunction





