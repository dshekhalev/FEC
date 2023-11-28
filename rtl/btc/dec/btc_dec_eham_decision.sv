/*



  parameter int pLLR_W  = 5 ;
  parameter int pEXTR_W = 5 ;



  logic                   btc_dec_eham_decision__iclk               ;
  logic                   btc_dec_eham_decision__ireset             ;
  logic                   btc_dec_eham_decision__iclkena            ;
  //
  btc_code_mode_t         btc_dec_eham_decision__imode              ;
  logic                   btc_dec_eham_decision__ival               ;
  strb_t                  btc_dec_eham_decision__istrb              ;
  metric_t                btc_dec_eham_decision__imin0              ;
  logic           [4 : 0] btc_dec_eham_decision__ierr0_bit_mask     ;
  bit_idx_t               btc_dec_eham_decision__ierr0_bit_idx  [5] ;
  //
  metric_t                btc_dec_eham_decision__imin1              ;
  logic           [4 : 0] btc_dec_eham_decision__ierr1_bit_mask     ;
  bit_idx_t               btc_dec_eham_decision__ierr1_bit_idx  [5] ;
  //
  metric_t                btc_dec_eham_decision__imax               ;
  logic           [4 : 0] btc_dec_eham_decision__ierrm_bit_mask     ;
  bit_idx_t               btc_dec_eham_decision__ierrm_bit_idx  [5] ;
  //
  logic                   btc_dec_eham_decision__idecfail           ;
  //
  logic                   btc_dec_eham_decision__ihd                ;
  logic                   btc_dec_eham_decision__ohd_read           ;
  //
  logic                   btc_dec_eham_decision__opre_val           ;
  //
  logic                   btc_dec_eham_decision__oval               ;
  strb_t                  btc_dec_eham_decision__ostrb              ;
  extr_t                  btc_dec_eham_decision__oLextr             ;
  logic                   btc_dec_eham_decision__obitdat            ;
  //
  logic                   btc_dec_eham_decision__odecfail           ;
  logic                   btc_dec_eham_decision__odecfail_val       ;



  btc_dec_eham_decision
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  btc_dec_eham_decision
  (
    .iclk           ( btc_dec_eham_decision__iclk           ) ,
    .ireset         ( btc_dec_eham_decision__ireset         ) ,
    .iclkena        ( btc_dec_eham_decision__iclkena        ) ,
    //
    .imode          ( btc_dec_eham_decision__imode          ) ,
    .ival           ( btc_dec_eham_decision__ival           ) ,
    .istrb          ( btc_dec_eham_decision__istrb          ) ,
    //
    .imin0          ( btc_dec_eham_decision__imin0          ) ,
    .ierr0_bit_mask ( btc_dec_eham_decision__ierr0_bit_mask ) ,
    .ierr0_bit_idx  ( btc_dec_eham_decision__ierr0_bit_idx  ) ,
    //
    .imin1          ( btc_dec_eham_decision__imin1          ) ,
    .ierr1_bit_mask ( btc_dec_eham_decision__ierr1_bit_mask ) ,
    .ierr1_bit_idx  ( btc_dec_eham_decision__ierr1_bit_idx  ) ,
    //
    .imax           ( btc_dec_eham_decision__imax           ) ,
    .ierrm_bit_mask ( btc_dec_eham_decision__ierrm_bit_mask ) ,
    .ierrm_bit_idx  ( btc_dec_eham_decision__ierrm_bit_idx  ) ,
    //
    .idecfail       ( btc_dec_eham_decision__idecfail       )
    //
    .ihd            ( btc_dec_eham_decision__ihd            ) ,
    .ohd_read       ( btc_dec_eham_decision__ohd_read       ) ,
    //
    .opre_val       ( btc_dec_eham_decision__opre_val       ) ,
    //
    .oval           ( btc_dec_eham_decision__oval           ) ,
    .ostrb          ( btc_dec_eham_decision__ostrb          ) ,
    .oLextr         ( btc_dec_eham_decision__oLextr         ) ,
    .obitdat        ( btc_dec_eham_decision__obitdat        ) ,
    //
    .odecfail      ( btc_dec_eham_decision__odecfail        ) ,
    .odecfail_val  ( btc_dec_eham_decision__odecfail_val    )
  );


  assign btc_dec_eham_decision__iclk           = '0 ;
  assign btc_dec_eham_decision__ireset         = '0 ;
  assign btc_dec_eham_decision__iclkena        = '0 ;
  assign btc_dec_eham_decision__imode          = '0 ;
  assign btc_dec_eham_decision__ival           = '0 ;
  assign btc_dec_eham_decision__istrb          = '0 ;
  assign btc_dec_eham_decision__imin0          = '0 ;
  assign btc_dec_eham_decision__ierr0_bit_mask = '0 ;
  assign btc_dec_eham_decision__ierr0_bit_idx  = '0 ;
  assign btc_dec_eham_decision__imin1          = '0 ;
  assign btc_dec_eham_decision__ierr1_bit_mask = '0 ;
  assign btc_dec_eham_decision__ierr1_bit_idx  = '0 ;
  assign btc_dec_eham_decision__imax           = '0 ;
  assign btc_dec_eham_decision__ierrm_bit_mask = '0 ;
  assign btc_dec_eham_decision__ierrm_bit_idx  = '0 ;
  assign btc_dec_eham_decision__idecfail       = '0 ;
  assign btc_dec_eham_decision__ihd            = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_eham_decision.sv
// Description   : extended hamming code fast chase decision
//

module btc_dec_eham_decision
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  imode          ,
  //
  ival           ,
  istrb          ,
  //
  imin0          ,
  ierr0_bit_mask ,
  ierr0_bit_idx  ,
  //
  imin1          ,
  ierr1_bit_mask ,
  ierr1_bit_idx  ,
  //
  imax           ,
  ierrm_bit_mask ,
  ierrm_bit_idx  ,
  //
  idecfail       ,
  //
  iLapri         ,
  oLapri_read    ,
  //
  opre_val       ,
  //
  oval           ,
  ostrb          ,
  oLextr         ,
  obitdat        ,
  //
  odecfail       ,
  odecfail_val
);

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk               ;
  input  logic                   ireset             ;
  input  logic                   iclkena            ;
  //
  input  btc_code_mode_t         imode              ;
  // fast chase interface
  input  logic                   ival               ;
  input  strb_t                  istrb              ;
  //
  input  metric_t                imin0              ;
  input  logic           [4 : 0] ierr0_bit_mask     ;
  input  bit_idx_t               ierr0_bit_idx  [5] ;
  //
  input  metric_t                imin1              ;
  input  logic           [4 : 0] ierr1_bit_mask     ;
  input  bit_idx_t               ierr1_bit_idx  [5] ;
  //
  input  metric_t                imax               ;
  input  logic           [4 : 0] ierrm_bit_mask     ;
  input  bit_idx_t               ierrm_bit_idx  [5] ;
  //
  input  logic                   idecfail           ;
  // Lapri hard decision ram reading interface
  input  extr_t                  iLapri             ;
  output logic                   oLapri_read        ;
  // look ahead oval
  output logic                   opre_val           ;
  // output interface
  output logic                   oval               ;
  output strb_t                  ostrb              ;
  output extr_t                  oLextr             ;
  output logic                   obitdat            ;
  //
  output logic                   odecfail           ;
  output logic                   odecfail_val       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic     zero;
    logic     done;
    bit_idx_t value;
  } cnt;

  bit_idx_t     length_m2 ;

  strb_t        strb      ;

  metric_t      sub_min;
  metric_t      sub_max;

  logic [4 : 0] err0_bit_mask    ;
  bit_idx_t     err0_bit_idx  [5];

  logic [4 : 0] err1_bit_mask    ;
  bit_idx_t     err1_bit_idx  [5];

  logic [4 : 0] errm_bit_mask    ;
  bit_idx_t     errm_bit_idx  [5];

  logic         bit0_inv_mask;
  logic         bit1_inv_mask;
  logic         bitm_inv_mask;

  logic         hd_val;
  logic         hd_inv_mask;
  strb_t        hd_strb;

  logic         dec1_inv_mask;
  logic         decm_inv_mask;

  metric_t      sub_min_reg;
  metric_t      sub_med_reg;
  metric_t      sub_max_reg;
  metric_t      Lextr;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state  <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE  : state <= ival               ? cDO_STATE     : cRESET_STATE;
        cDO_STATE     : state <= (cnt.done & !ival) ? cRESET_STATE  : cDO_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  // fixed for decode cycle
  assign length_m2 = get_code_bits(imode) - 2;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cRESET_STATE : begin
          if (ival) begin // hold new results
            cnt           <= '0;
            cnt.zero      <= 1'b1;
            //
            strb          <= istrb;
            //
            sub_min       <= imin1 - imin0;
            sub_max       <= imax  - imin0;
            //
            err0_bit_mask <= ierr0_bit_mask;
            err0_bit_idx  <= ierr0_bit_idx;
            //
            err1_bit_mask <= ierr1_bit_mask;
            err1_bit_idx  <= ierr1_bit_idx;
            //
            errm_bit_mask <= ierrm_bit_mask;
            errm_bit_idx  <= ierrm_bit_idx;
          end
        end
        //
        cDO_STATE : begin
          if (ival) begin
            cnt           <= '0;
            cnt.zero      <= 1'b1;
            //
            strb          <= istrb;
            //
            sub_min       <= imin1 - imin0;
            sub_max       <= imax  - imin0;
            //
            err0_bit_mask <= ierr0_bit_mask;
            err0_bit_idx  <= ierr0_bit_idx;
            //
            err1_bit_mask <= ierr1_bit_mask;
            err1_bit_idx  <= ierr1_bit_idx;
            //
            errm_bit_mask <= ierrm_bit_mask;
            errm_bit_idx  <= ierrm_bit_idx;
          end
          else begin
            cnt.value <=  cnt.done ? '0 : (cnt.value + 1'b1);
            cnt.done  <= (cnt.value == length_m2);
            cnt.zero  <=  cnt.done;
          end
        end
      endcase
    end
  end

  assign oLapri_read = (state == cDO_STATE);

  //------------------------------------------------------------------------------------------------------
  // Pipeline/align delay Lapri hard decision bit inversion mask and Lextr saturation.
  // hd FIFO read latency is 1 tick (!!!)
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      hd_val <= 1'b0;
    end
    else if (iclkena) begin
      hd_val <= (state == cDO_STATE);
    end
  end

  always_comb begin
    bit0_inv_mask = 1'b0;
    bit1_inv_mask = 1'b0;
    bitm_inv_mask = 1'b0;
    for (int i = 0; i < 5; i++) begin
      if (cnt.value == err0_bit_idx[i]) begin
        bit0_inv_mask |= err0_bit_mask[i];
      end
      if (cnt.value == err1_bit_idx[i]) begin
        bit1_inv_mask |= err1_bit_mask[i];
      end
      if (cnt.value == errm_bit_idx[i]) begin
        bitm_inv_mask |= errm_bit_mask[i];
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      hd_inv_mask   <= bit0_inv_mask;
      // regenerate strobes
      hd_strb.sof   <= strb.sof & cnt.zero;
      hd_strb.sop   <= cnt.zero;
      hd_strb.eop   <= cnt.done;
      hd_strb.eof   <= strb.eof & cnt.done;
      //
      dec1_inv_mask <= bit1_inv_mask;
      decm_inv_mask <= bitm_inv_mask;
      //
      sub_min_reg   <=  sub_min;
      sub_med_reg   <=  sub_min + 1;
      sub_max_reg   <= (sub_max >>> 2); // 1/num_eras pos
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Do decision and gen Lextr
  //------------------------------------------------------------------------------------------------------

  assign opre_val = hd_val; // look ahead oval

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval <= 1'b0;
    end
    else if (iclkena) begin
      oval <= hd_val;
    end
  end

  wire hd     = (iLapri >= 0);
  wire bitdat = hd ^ hd_inv_mask;

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      ostrb <= hd_strb;
      //
      if (hd_inv_mask ^ dec1_inv_mask) begin
        Lextr <= (bitdat ? sub_min_reg : -sub_min_reg) - iLapri;
      end
//    else if (hd_inv_mask ^ decm_inv_mask) begin
//      Lextr <= (bitdat ? sub_med_reg : -sub_med_reg) - iLapri;
//    end
      else begin
        Lextr <= bitdat ? sub_max_reg : -sub_max_reg;
      end
      //
      obitdat <= bitdat;
    end
  end

  // there is register outside of module
  assign oLextr = do_saturation(Lextr);

  //------------------------------------------------------------------------------------------------------
  // decfail based upon Lextr gradient
  //------------------------------------------------------------------------------------------------------

  logic Lapri_zero;
  logic Lapri_sign;

  logic Lextr_zero;
  logic Lextr_sign;

  assign Lextr_zero = (Lextr == -1) | (Lextr == 0) | (Lextr == 1);
  assign Lextr_sign = (Lextr <  0);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // align Lextr delay
      Lapri_zero <= (iLapri == -1) | (iLapri == 0) | (iLapri == 1);
      Lapri_sign <= (iLapri <  0);
      //
      if (oval) begin
        odecfail <= (ostrb.sop ? 1'b0 : odecfail) | (Lextr_zero | Lapri_zero | (Lextr_sign ^ Lapri_sign));
      end
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      odecfail_val <= 1'b0;
    end
    else if (iclkena) begin
      odecfail_val <= oval & ostrb.eop;
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  function extr_t do_saturation (input metric_t data);
    logic poverflow;
    logic noverflow;
  begin
    poverflow     = (data >  (2**(pEXTR_W-1)-1));
    noverflow     = (data < -(2**(pEXTR_W-1)-1));
    do_saturation = data[pEXTR_W-1 : 0];
    //
    if (poverflow) begin
      do_saturation =  (2**(pEXTR_W-1)-1);
    end
    else if (noverflow) begin
      do_saturation = -(2**(pEXTR_W-1)-1);
    end
  end
  endfunction

endmodule
