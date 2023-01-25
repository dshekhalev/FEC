//
// Project       : ldpc 3gpp TS 38.212 v15.7.0
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_3gpp_dec_hc.svh
// Description   : decoder check matrix optimization functions
//

  //------------------------------------------------------------------------------------------------------
  // detect unused node ram block for split Hb by pROW_BY_CYCLE. can use any grapth
  //------------------------------------------------------------------------------------------------------

  typedef bit maskHc_t [pROW_BY_CYCLE][cCOL_BY_CYCLE];  // use 26/14 columns for graph1/graph2

  localparam maskHc_t cHC_MASK = get_Hc_mask(pIDX_GR);

  //
  // idxGr == 0 use graph1/graph2 else use graph2 only
  //
  function maskHc_t get_Hc_mask (input logic idxGr);
  begin
    get_Hc_mask = '{default : '{default : 1}};
    //
    for (int row = 0; row < ((pCODE < cGR_MAX_ROW[1]) ? pCODE : cGR_MAX_ROW[1]); row++) begin
      for (int col = 0; col < 14; col++) begin
        get_Hc_mask[row % pROW_BY_CYCLE][col] &= (gr2_Hc_LS0[row][col] < 0);
      end
    end
    //
    if (idxGr == 0) begin
      for (int row = 0; row < ((pCODE < cGR_MAX_ROW[0]) ? pCODE : cGR_MAX_ROW[0]); row++) begin
        for (int col = 0; col < 26; col++) begin
          get_Hc_mask[row % pROW_BY_CYCLE][col] &= (gr1_Hc_LS0[row][col] < 0);
        end
      end
    end
  end
  endfunction

