//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_dec_functions.v
// Description   : decoder functions for address generation tables
//

  function addr_tab_t get_addr_tab (input bit do_print = 0, short_print = 0);
    int taddr ;
    //
    int addr    [pLLR_BY_CYCLE];
    int maddr   [pLLR_BY_CYCLE];
    int sela    [pLLR_BY_CYCLE];
    int invsela [pLLR_BY_CYCLE];
    int offset  [pLLR_BY_CYCLE];
    int offsetm [pLLR_BY_CYCLE];
    //
    int fp;
  begin
    // synthesis translate_off
    if (do_print) begin
      fp = $fopen("../rtl/gsfc_ldpc/dec/gsfc_ldpc_dec_addr_gen_tab.svh");
      $fdisplay(fp, "//");
      if (short_print)
        $fdisplay(fp, "// (!!!) IT'S GENERATED short table for %0d/%0d coderate, %0d bits do %0d LLR per cycle(!!!)", pCODE, pCODE+1, pN, pLLR_BY_CYCLE);
      else
        $fdisplay(fp, "// (!!!) IT'S GENERATED full table for %0d/%0d coderate, %0d bits do %0d LLR per cycle(!!!)", pCODE, pCODE+1, pN, pLLR_BY_CYCLE);
      $fdisplay(fp, "//");
    end
    // synthesis translate_on
    for (int c = 0; c < pC; c++) begin
      for (int w = 0; w < pW; w++) begin
        for (int t = 0; t < pT; t++) begin
          for (int z = 0; z < cZ_MAX; z++) begin
            // generate all address
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              taddr = (Hb[c][t][w] + llra + pZF + z*pLLR_BY_CYCLE) % pZF;
              //
              addr[llra] = taddr / pLLR_BY_CYCLE;
              sela[llra] = taddr % pLLR_BY_CYCLE;
            end
            // get muxed address
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              maddr   [sela[llra]] = addr[llra];
              invsela [sela[llra]] = llra;
            end
            // detect offsets and masked offsets
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              offset  [llra] = maddr[llra] - maddr[0];
              offsetm [llra] = (offset [llra] == 0) ? 0 : -1;
            end
            //
            get_addr_tab[c][w][t][z].baddr = maddr[0];
            for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
              get_addr_tab[c][w][t][z].offset  [llra] = offset  [llra];
              get_addr_tab[c][w][t][z].offsetm [llra] = offsetm [llra];
              get_addr_tab[c][w][t][z].sela    [llra] = sela    [llra];
              get_addr_tab[c][w][t][z].invsela [llra] = invsela [llra];
            end
            // synthesis translate_off
            if (do_print) begin
              if (!short_print)
                $fdisplay(fp, "  addr_tab[%0d][%0d][%0d][%0d] = %p;", c, w, t, z, get_addr_tab[c][w][t][z]);
              else if (z == 0)
                $fdisplay(fp, "  addr_tab[%0d][%0d][%0d][%0d] = %p;", c, w, t, z, get_addr_tab[c][w][t][z]);
            end
            // synthesis translate_on
          end
        end
      end
    end
    // synthesis translate_off
    if (do_print)
      $fclose(fp);
    // synthesis translate_on
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // function to pipeline decoder by pNODE_BY_CYCLE processing
  //------------------------------------------------------------------------------------------------------

  typedef paddr_t maddr_tab_t   [pC][pW][pNODE_BY_CYCLE][cT_MAX][cZ_MAX]; // full table
  typedef paddr_t maddr_tab_s_t [pC][pW][pNODE_BY_CYCLE][cT_MAX];         // short table

  function maddr_tab_t get_maddr_tab (input addr_tab_t taddr_tab);
    for (int c = 0; c < pC; c++) begin
      for (int w = 0; w < pW; w++) begin
        for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
          for (int t = 0; t < cT_MAX; t++) begin
            get_maddr_tab[c][w][n][t] = taddr_tab[c][w][n*cT_MAX + t];
          end
        end
      end
    end
  endfunction

