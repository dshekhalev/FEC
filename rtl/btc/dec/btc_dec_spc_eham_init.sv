/*



  parameter int pLLR_W  = 5 ;
  parameter int pEXTR_W = 5 ;



  logic           btc_dec_spc_eham_init__iclk               ;
  logic           btc_dec_spc_eham_init__ireset             ;
  logic           btc_dec_spc_eham_init__iclkena            ;
  //
  btc_code_mode_t btc_dec_spc_eham_init__imode              ;
  //
  logic           btc_dec_spc_eham_init__ival               ;
  strb_t          btc_dec_spc_eham_init__istrb              ;
  extr_t          btc_dec_spc_eham_init__iLapri             ;
  //
  logic           btc_dec_spc_eham_init__oLapri_hd_val      ;
  logic           btc_dec_spc_eham_init__oLapri_hd          ;
  //
  logic           btc_dec_spc_eham_init__oLapri_write       ;
  logic           btc_dec_spc_eham_init__oLapri_wptr        ;
  bit_idx_t       btc_dec_spc_eham_init__oLapri_waddr       ;
  extr_t          btc_dec_spc_eham_init__oLapri             ;
  //
  logic           btc_dec_spc_eham_init__odone              ;
  //
  logic           btc_dec_spc_eham_init__oLapri_ptr         ;
  //
  bit_idx_t       btc_dec_spc_eham_init__oLpp_idx       [4] ;
  extr_t          btc_dec_spc_eham_init__oLpp_value     [4] ;
  //
  logic           btc_dec_spc_eham_init__ospc_prod_sign     ;
  //
  state_t         btc_dec_spc_eham_init__oham_syndrome      ;
  logic           btc_dec_spc_eham_init__oham_even          ;
  bit_idx_t       btc_dec_spc_eham_init__oham_err_idx       ;
  logic           btc_dec_spc_eham_init__oham_decfail       ;



  btc_dec_spc_eham_init
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  btc_dec_spc_eham_init
  (
    .iclk           ( btc_dec_spc_eham_init__iclk           ) ,
    .ireset         ( btc_dec_spc_eham_init__ireset         ) ,
    .iclkena        ( btc_dec_spc_eham_init__iclkena        ) ,
    //
    .imode          ( btc_dec_spc_eham_init__imode          ) ,
    //
    .ival           ( btc_dec_spc_eham_init__ival           ) ,
    .istrb          ( btc_dec_spc_eham_init__istrb          ) ,
    .iLapri         ( btc_dec_spc_eham_init__iLapri         ) ,
    //
    .oLapri_hd_val  ( btc_dec_spc_eham_init__oLapri_hd_val  ) ,
    .oLapri_hd      ( btc_dec_spc_eham_init__oLapri_hd      ) ,
    //
    .oLapri_write   ( btc_dec_spc_eham_init__oLapri_write   ) ,
    .oLapri_wptr    ( btc_dec_spc_eham_init__oLapri_wptr    ) ,
    .oLapri_waddr   ( btc_dec_spc_eham_init__oLapri_waddr   ) ,
    .oLapri         ( btc_dec_spc_eham_init__oLapri         ) ,
    //
    .odone          ( btc_dec_spc_eham_init__odone          ) ,
    //
    .oLapri_ptr     ( btc_dec_spc_eham_init__oLapri_ptr     ) ,
    //
    .oLpp_idx       ( btc_dec_spc_eham_init__oLpp_idx       ) ,
    .oLpp_value     ( btc_dec_spc_eham_init__oLpp_value     ) ,
    //
    .ospc_prod_sign ( btc_dec_spc_eham_init__ospc_prod_sign ) ,
    //
    .oham_syndrome  ( btc_dec_spc_eham_init__oham_syndrome  ) ,
    .oham_even      ( btc_dec_spc_eham_init__oham_even      ) ,
    .oham_err_idx   ( btc_dec_spc_eham_init__oham_err_idx   ) ,
    .oham_decfail   ( btc_dec_spc_eham_init__oham_decfail   )
  );


  assign btc_dec_spc_eham_init__iclk    = '0 ;
  assign btc_dec_spc_eham_init__ireset  = '0 ;
  assign btc_dec_spc_eham_init__iclkena = '0 ;
  assign btc_dec_spc_eham_init__imode   = '0 ;
  assign btc_dec_spc_eham_init__ival    = '0 ;
  assign btc_dec_spc_eham_init__istrb   = '0 ;
  assign btc_dec_spc_eham_init__iLapri  = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_spc_eham_init.sv
// Description   : input data sorting unit for search Least Propable Positions in LLR row/col &
//                 SPC/eHAmmming soft decoder initialization
//

module btc_dec_spc_eham_init
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  imode          ,
  //
  ival           ,
  istrb          ,
  iLapri         ,
  //
  oLapri_hd_val  ,
  oLapri_hd      ,
  //
  oLapri_write   ,
  oLapri_wptr    ,
  oLapri_waddr   ,
  oLapri         ,
  //
  odone          ,
  ostrb          ,
  //
  oLapri_ptr     ,
  //
  oLpp_idx       ,
  oLpp_value     ,
  //
  ospc_prod_sign ,
  //
  oham_syndrome  ,
  oham_even      ,
  oham_err_idx   ,
  oham_decfail
);

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk               ;
  input  logic           ireset             ;
  input  logic           iclkena            ;
  //
  input  btc_code_mode_t imode              ;
  //
  input  logic           ival               ;
  input  strb_t          istrb              ;
  input  extr_t          iLapri             ;
  //
  output logic           oLapri_hd_val      ;
  output logic           oLapri_hd          ;
  //
  output logic           oLapri_write       ;
  output logic           oLapri_wptr   = '0 ; // can be any for work
  output bit_idx_t       oLapri_waddr       ;
  output extr_t          oLapri             ;
  //
  output logic           odone              ;
  output strb_t          ostrb              ;
  //
  output logic           oLapri_ptr         ;
  //
  output bit_idx_t       oLpp_idx       [4] ;
  output extr_t          oLpp_value     [4] ;
  //
  output logic           ospc_prod_sign     ;
  //
  output state_t         oham_syndrome      ;
  output logic           oham_even          ;
  output bit_idx_t       oham_err_idx       ;
  output logic           oham_decfail       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic     signLapri;

  logic     aLapri2sort_val;
  strb_t    aLapri2sort_strb;
  bit_idx_t aLapri2sort_idx;
  extr_t    aLapri;

  //------------------------------------------------------------------------------------------------------
  // get abs(Lapri) for sort &
  // save Lapri to decode in special format {signLapri, aLapri} to improve timing
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oLapri_write  <= ival;
//    oLapri        <= iLapri;
      //
      if (ival) begin
        oLapri_wptr  <= oLapri_wptr ^ istrb.sop; // wptr can be any at start
        oLapri_waddr <= istrb.sop ? '0 : (oLapri_waddr + 1'b1);
      end
      //
      aLapri2sort_val   <= ival;
      aLapri2sort_strb  <= istrb;
      aLapri            <= (iLapri >= 0) ? iLapri : -iLapri;
      signLapri         <= (iLapri  < 0);
      if (ival) begin
        aLapri2sort_idx <= istrb.sop ? '0 : (aLapri2sort_idx + 1'b1);
      end
    end
  end

  always_comb begin
    oLapri                = aLapri;
    oLapri[$high(oLapri)] = signLapri;
  end

  //------------------------------------------------------------------------------------------------------
  // do sorting
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      odone <= 1'b0;
    end
    else if (iclkena) begin
      odone <= aLapri2sort_val & aLapri2sort_strb.eop;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (aLapri2sort_val) begin
        ostrb <= aLapri2sort_strb.sop ? aLapri2sort_strb : (ostrb | aLapri2sort_strb);
        // sort itself
        if (aLapri2sort_strb.sop) begin
          oLpp_value[0]   <= aLapri;
          oLpp_idx  [0]   <= aLapri2sort_idx;
          for (int i = 1; i < 4; i++) begin
            oLpp_value[i] <= '1;
            oLpp_value[i][pEXTR_W-1] <= 1'b0;
          end
        end
        else begin
          if      (aLapri < oLpp_value[0]) begin
            oLpp_value[0]   <= aLapri;
            oLpp_idx  [0]   <= aLapri2sort_idx;
            oLpp_value[1:3] <= oLpp_value[0:2];
            oLpp_idx  [1:3] <= oLpp_idx  [0:2];
          end
          else if (aLapri < oLpp_value[1]) begin
            oLpp_value[1]   <= aLapri;
            oLpp_idx  [1]   <= aLapri2sort_idx;
            oLpp_value[2:3] <= oLpp_value[1:2];
            oLpp_idx  [2:3] <= oLpp_idx  [1:2];
          end
          else if (aLapri < oLpp_value[2]) begin
            oLpp_value[2]   <= aLapri;
            oLpp_idx  [2]   <= aLapri2sort_idx;
            oLpp_value[3]   <= oLpp_value[2];
            oLpp_idx  [3]   <= oLpp_idx  [2];
          end
          else if (aLapri < oLpp_value[3]) begin
            oLpp_value[3]   <= aLapri;
            oLpp_idx  [3]   <= aLapri2sort_idx;
          end
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // SPC prod sign
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (aLapri2sort_val) begin
        ospc_prod_sign <= aLapri2sort_strb.sop ? signLapri : (ospc_prod_sign ^ signLapri);
        // save used Lapri ram pointer for decoders
        if (aLapri2sort_strb.eop) begin
          oLapri_ptr <= oLapri_wptr;
        end
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // hamming initial : syndrome/even/decfail/error position
  //------------------------------------------------------------------------------------------------------

  state_t state;
  state_t syndrome;

  state_t used_poly;
  state_t used_state_mask;
  logic   used_state_msb;

  logic   even;

  always_comb begin
    used_poly       = cPRIM_POLY_8;
    used_state_msb  = state[2];
    //
    case (imode.size)
      cBSIZE_8  : begin used_poly = cPRIM_POLY_8;  used_state_msb = state[2]; used_state_mask = 8'h07; end
      cBSIZE_16 : begin used_poly = cPRIM_POLY_16; used_state_msb = state[3]; used_state_mask = 8'h0F; end
      cBSIZE_32 : begin used_poly = cPRIM_POLY_32; used_state_msb = state[4]; used_state_mask = 8'h1F; end
      cBSIZE_64 : begin used_poly = cPRIM_POLY_64; used_state_msb = state[5]; used_state_mask = 8'h3F; end
    endcase
  end

  wire hdLapri = (iLapri >= 0);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oLapri_hd_val <= 1'b0;
    end
    else if (iclkena) begin
      oLapri_hd_val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      oLapri_hd <= hdLapri;
      if (ival) begin
        even <= istrb.sop ? hdLapri : (even ^ hdLapri);
        //
        if (istrb.sop) begin
          state <= {7'h0, hdLapri};
        end
        else if (!istrb.eop) begin
          state <= (state << 1) ^ ({8{used_state_msb}} & used_poly) ^ {7'h0, hdLapri};
        end
      end
    end
  end

  assign syndrome = state & used_state_mask;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // aLapri2sort_val
      oham_syndrome <= syndrome;
      oham_even     <= even;
      oham_decfail  <= (syndrome != 0) & (even == 0);
      //
      case (imode.size)
        cBSIZE_8  : oham_err_idx <= cH_7_ERR_IDX_TAB [syndrome];
        cBSIZE_16 : oham_err_idx <= cH_15_ERR_IDX_TAB[syndrome];
        cBSIZE_32 : oham_err_idx <= cH_31_ERR_IDX_TAB[syndrome];
        cBSIZE_64 : oham_err_idx <= cH_63_ERR_IDX_TAB[syndrome];
      endcase
    end
  end

endmodule
