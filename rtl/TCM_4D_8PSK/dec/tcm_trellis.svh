//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_trellis.svh
// Description   : tcm viterbi codec trellis defines and used functions
//

  //------------------------------------------------------------------------------------------------------
  // trellis base parameters
  //------------------------------------------------------------------------------------------------------

  localparam int pCONSTR_LENGTH = 7;

  //------------------------------------------------------------------------------------------------------
  // trellis constants
  //------------------------------------------------------------------------------------------------------

  localparam int cSTATE_NUM = 2**(pCONSTR_LENGTH-1);
  localparam int cSTATE_W   = pCONSTR_LENGTH-1;

  // code state
  typedef bit [cSTATE_W-1 : 0] stateb_t;
  typedef bit          [3 : 0] boutputs_t;

  typedef struct {
    stateb_t   nextStates [cSTATE_NUM][8];
    stateb_t    preStates [cSTATE_NUM][8];
    boutputs_t  outputs   [cSTATE_NUM][8];
  } trellis_t;

  trellis_t trel;

  always_comb begin
    trel = get_trellis (0);
  end

  //------------------------------------------------------------------------------------------------------
  // function's to get trellis
  //------------------------------------------------------------------------------------------------------

  function trellis_t get_trellis (input int tmp);
    stateb_t nstate;
  begin
    for (int x3x2x1 = 0; x3x2x1 < 8; x3x2x1++) begin
      for (int state = 0; state < cSTATE_NUM; state++) begin
        nstate  = {state[0], state[cSTATE_W-1 : 2], state[1] ^ state[0]};
        nstate ^= 6'b0_10100 & {6{x3x2x1[2]}};
        nstate ^= 6'b0_01010 & {6{x3x2x1[1]}};
        nstate ^= 6'b0_00011 & {6{x3x2x1[0]}};
        //
        get_trellis.nextStates [state][x3x2x1] = nstate;
        get_trellis.outputs    [state][x3x2x1] = {x3x2x1[2 : 0], state[0]};
      end
    end
    //
    for (int x3x2x1 = 0; x3x2x1 < 8; x3x2x1++) begin
      for (int state = 0; state < cSTATE_NUM; state++) begin
        nstate = get_trellis.nextStates[state][x3x2x1];
        get_trellis.preStates[nstate][x3x2x1] = state[cSTATE_W-1 : 0];
      end
    end
  end
  endfunction

