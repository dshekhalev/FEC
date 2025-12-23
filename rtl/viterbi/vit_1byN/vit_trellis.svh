//
// Project       : viterbi 1byN
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_trellis.svh
// Description   : viterbi codec trellis defines and used functions
//

  //------------------------------------------------------------------------------------------------------
  // trellis base parameters
  //------------------------------------------------------------------------------------------------------

//************************************************
//**************** matlab ************************
//************************************************

//parameter int pCONSTR_LENGTH            = 3;                // trellis constraint length
//parameter int pCODE_GEN_NUM             = 2;                // number of code polynomes === output data
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{32'o6, 32'o7};  // code polynomes intself

//parameter int pCONSTR_LENGTH            = 5;
//parameter int pCODE_GEN_NUM             = 2;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o35, 'o31};

  parameter int pCONSTR_LENGTH            = 7;
  parameter int pCODE_GEN_NUM             = 2;
  parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o171, 'o133};

//************************************************
//**************** Sklyar ************************
//************************************************
//parameter int pCONSTR_LENGTH            = 4;
//parameter int pCODE_GEN_NUM             = 2;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o17, 'o13};

//parameter int pCONSTR_LENGTH            = 6;
//parameter int pCODE_GEN_NUM             = 2;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o57, 'o65};

//parameter int pCONSTR_LENGTH            = 8;
//parameter int pCODE_GEN_NUM             = 2;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o237, 'o345};

//parameter int pCONSTR_LENGTH            = 9;
//parameter int pCODE_GEN_NUM             = 2;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o657, 'o435};


//parameter int pCONSTR_LENGTH            = 3;
//parameter int pCODE_GEN_NUM             = 3;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o7, 'o7, 'o5};

//parameter int pCONSTR_LENGTH            = 4;
//parameter int pCODE_GEN_NUM             = 3;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o17, 'o13, 'o15};

//parameter int pCONSTR_LENGTH            = 5;
//parameter int pCODE_GEN_NUM             = 3;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o37, 'o33, 'o25};

//parameter int pCONSTR_LENGTH            = 6;
//parameter int pCODE_GEN_NUM             = 3;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o56, 'o65, 'o71}; -- [possible error)

//parameter int pCONSTR_LENGTH            = 7;
//parameter int pCODE_GEN_NUM             = 3;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o117, 'o127, 'o155};

//parameter int pCONSTR_LENGTH            = 8;
//parameter int pCODE_GEN_NUM             = 3;
//parameter int pCODE_GEN [pCODE_GEN_NUM] = '{'o357, 'o233, 'o251};

  //------------------------------------------------------------------------------------------------------
  // trellis constants
  //------------------------------------------------------------------------------------------------------

  localparam int cSTATE_NUM = 2**(pCONSTR_LENGTH-1);
  localparam int cSTATE_W   = pCONSTR_LENGTH-1;

  // code state
  typedef bit      [cSTATE_W-1 : 0] stateb_t;
  typedef bit [pCODE_GEN_NUM-1 : 0] boutputs_t;

  typedef struct {
    stateb_t   nextStates [cSTATE_NUM][2];
    boutputs_t outputs    [cSTATE_NUM][2];
  } trellis_t;

  trellis_t trel;

  always_comb begin
    trel = get_trellis (0);
  end

  //------------------------------------------------------------------------------------------------------
  // function's to get trellis
  //------------------------------------------------------------------------------------------------------

  function automatic trellis_t get_trellis (input int tmp);
    stateb_t    nstate;
    boutputs_t  outputs;
    trellis_t   result;
  begin
    for (int b = 0; b < 2; b++) begin
      for (int state = 0; state < cSTATE_NUM; state++) begin
        nstate = {b[0], state[cSTATE_W-1 : 1]};
        //
        for (int ob = 0; ob < pCODE_GEN_NUM; ob++) begin
          outputs[ob] = ^({b[0], state[cSTATE_W-1 : 0]} & pCODE_GEN[ob][cSTATE_W : 0]);
        end
        //
        result.nextStates [state][b] = nstate;
        result.outputs    [state][b] = outputs;
      end
    end
    return result;
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // function to get previous state from current state
  //  previous state is shift rigth for this trellis
  //------------------------------------------------------------------------------------------------------

  function automatic stateb_t get_pre_state(input stateb_t state, input logic decision);
    get_pre_state = {state[cSTATE_W-2 : 0], decision};
  endfunction

  //------------------------------------------------------------------------------------------------------
  // function to get input binary data
  //    data bit is msb of state for this trellis
  //------------------------------------------------------------------------------------------------------

  function automatic logic get_binput (input stateb_t state);
    get_binput = state[cSTATE_W-1];
  endfunction

