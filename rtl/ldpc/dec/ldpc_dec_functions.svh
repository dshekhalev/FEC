//
// Project       : ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : ldpc_dec_functions.svh
// Description   : decoder functions for address generation tables
//

  function automatic addr_tab_t get_addr_tab (input bit do_print = 0, short_print = 0);
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
      fp = $fopen("../rtl/ldpc/dec/ldpc_dec_addr_gen_tab.svh");
      $fdisplay(fp, "//");
      if (short_print) begin
        $fdisplay(fp, "// (!!!) IT'S GENERATED short table for %p coderate, %0d bits do %0d LLR per cycle(!!!)", ldpc_code_t'(pCODE), pN, pLLR_BY_CYCLE);
      end
      else begin
        $fdisplay(fp, "// (!!!) IT'S GENERATED full table for %p coderate, %0d bits do %0d LLR per cycle(!!!)", ldpc_code_t'(pCODE), pN, pLLR_BY_CYCLE);
      end
      $fdisplay(fp, "//");
    end
    // synthesis translate_on
    for (int c = 0; c < pC; c++) begin
      for (int t = 0; t < pT; t++) begin
        for (int z = 0; z < cZ_MAX; z++) begin
          // generate all address
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            if (Hb[c][t] < 0) begin
              taddr = (llra + pZF + z*pLLR_BY_CYCLE) % pZF;
            end
            else begin
              taddr = (Hb[c][t] + llra + pZF + z*pLLR_BY_CYCLE) % pZF;
            end

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
          get_addr_tab[c][t][z].baddr = maddr[0];
          for (int llra = 0; llra < pLLR_BY_CYCLE; llra++) begin
            get_addr_tab[c][t][z].offset  [llra] = offset  [llra];
            get_addr_tab[c][t][z].offsetm [llra] = offsetm [llra];
            get_addr_tab[c][t][z].sela    [llra] = sela    [llra];
            get_addr_tab[c][t][z].invsela [llra] = invsela [llra];
          end
          // synthesis translate_off
          if (do_print) begin
            if (!short_print) begin
              $fdisplay(fp, "  addr_tab[%0d][%0d][%0d] = %p;", c, t, z, get_addr_tab[c][t][z]);
            end
            else if (z == 0) begin
              $fdisplay(fp, "  addr_tab[%0d][%0d][%0d] = %p;", c, t, z, get_addr_tab[c][t][z]);
            end
          end
          // synthesis translate_on
        end
      end
    end
    // synthesis translate_off
    if (do_print) begin
      $fclose(fp);
    end
    // synthesis translate_on
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // function to pipeline decoder by pNODE_BY_CYCLE processing
  //------------------------------------------------------------------------------------------------------

  typedef paddr_t maddr_tab_t   [pC][pNODE_BY_CYCLE][0 : cT_MAX-1][cZ_MAX]; // full table
  typedef paddr_t maddr_tab_s_t [pC][pNODE_BY_CYCLE][0 : cT_MAX-1];         // short table

  function automatic maddr_tab_t get_maddr_tab (input addr_tab_t taddr_tab);
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        for (int t = 0; t < cT_MAX; t++) begin
          get_maddr_tab[c][n][t] = taddr_tab[c][n*cT_MAX + t];
        end
      end
    end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // function to generate bitmask table. optimal for high unrolled decoder realization
  //------------------------------------------------------------------------------------------------------

  function automatic bitmask_tab_t get_bitmask_tab (input int code);
    bit bitmask [pC][pT];
  begin
    // get bitmask table
    for (int c = 0; c < pC; c++) begin
      for (int t = 0; t < pT; t++) begin
        bitmask   [c][t]  = 1'b1;
        if (Hb[c][t] >= 0) begin
          bitmask [c][t]  = 1'b0;
        end
      end
    end
    // take into acount pNODE_BY_CYCLE split factor
    for (int c = 0; c < pC; c++) begin
      for (int n = 0; n < pNODE_BY_CYCLE; n++) begin
        for (int t = 0; t < cT_MAX; t++) begin
          if (t == 0) begin
            get_bitmask_tab[c][n]  = bitmask[c][n*cT_MAX + t];
          end
          else begin
            get_bitmask_tab[c][n] &= bitmask[c][n*cT_MAX + t];
          end
        end
      end
    end
  end
  endfunction

