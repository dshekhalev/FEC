/*



  parameter int pLLR_W  = 5 ;
  parameter int pEXTR_W = 5 ;



  logic                   btc_dec_eham_fchase__iclk              ;
  logic                   btc_dec_eham_fchase__ireset            ;
  logic                   btc_dec_eham_fchase__iclkena           ;
  //
  btc_code_mode_t         btc_dec_eham_fchase__imode             ;
  //
  logic                   btc_dec_eham_fchase__ival              ;
  strb_t                  btc_dec_eham_fchase__istrb             ;
  logic                   btc_dec_eham_fchase__iLapri_ptr        ;
  bit_idx_t               btc_dec_eham_fchase__iLpp_idx      [4] ;
  extr_t                  btc_dec_eham_fchase__iLpp_value    [4] ;
  state_t                 btc_dec_eham_fchase__isyndrome         ;
  logic                   btc_dec_eham_fchase__ieven             ;
  logic                   btc_dec_eham_fchase__ierr_idx          ;
  logic                   btc_dec_eham_fchase__idecfail          ;
  //
  extr_t                  btc_dec_eham_fchase__iLapri            ;
  logic                   btc_dec_eham_fchase__oLapri_rptr       ;
  bit_idx_t               btc_dec_eham_fchase__oLapri_raddr      ;
  //
  logic                   btc_dec_eham_fchase__odone             ;
  strb_t                  btc_dec_eham_fchase__ostrb             ;
  metric_t                btc_dec_eham_fchase__omin0             ;
  metric_t                btc_dec_eham_fchase__omin1             ;
  logic           [4 : 0] btc_dec_eham_fchase__oerr_bit_mask     ;
  bit_idx_t               btc_dec_eham_fchase__oerr_bit_idx  [5] ;
  //
  logic                   btc_dec_eham_fchase__odecfail          ;



  btc_dec_eham_fchase
  #(
    .pLLR_W  ( pLLR_W  ) ,
    .pEXTR_W ( pEXTR_W )
  )
  btc_dec_eham_fchase
  (
    .iclk          ( btc_dec_eham_fchase__iclk          ) ,
    .ireset        ( btc_dec_eham_fchase__ireset        ) ,
    .iclkena       ( btc_dec_eham_fchase__iclkena       ) ,
    //
    .imode         ( btc_dec_eham_fchase__imode         ) ,
    //
    .ival          ( btc_dec_eham_fchase__ival          ) ,
    .istrb         ( btc_dec_eham_fchase__istrb         ) ,
    .iLapri_ptr    ( btc_dec_eham_fchase__iLapri_ptr    ) ,
    .iLpp_idx      ( btc_dec_eham_fchase__iLpp_idx      ) ,
    .iLpp_value    ( btc_dec_eham_fchase__iLpp_value    ) ,
    .isyndrome     ( btc_dec_eham_fchase__isyndrome     ) ,
    .ieven         ( btc_dec_eham_fchase__ieven         ) ,
    .ierr_idx      ( btc_dec_eham_fchase__ierr_idx      ) ,
    .idecfail      ( btc_dec_eham_fchase__idecfail      ) ,
    //
    .iLapri        ( btc_dec_eham_fchase__iLapri        ) ,
    .oLapri_rptr   ( btc_dec_eham_fchase__oLapri_rptr   ) ,
    .oLapri_raddr  ( btc_dec_eham_fchase__oLapri_raddr  ) ,
    //
    .odone         ( btc_dec_eham_fchase__odone         ) ,
    .ostrb         ( btc_dec_eham_fchase__ostrb         ) ,
    .omin0         ( btc_dec_eham_fchase__omin0         ) ,
    .omin1         ( btc_dec_eham_fchase__omin1         ) ,
    .oerr_bit_mask ( btc_dec_eham_fchase__oerr_bit_mask ) ,
    .oerr_bit_idx  ( btc_dec_eham_fchase__oerr_bit_idx  ) ,
    //
    .odecfail      ( btc_dec_eham_fchase__odecfail      )
  );


  assign btc_dec_eham_fchase__iclk       = '0 ;
  assign btc_dec_eham_fchase__ireset     = '0 ;
  assign btc_dec_eham_fchase__iclkena    = '0 ;
  assign btc_dec_eham_fchase__imode      = '0 ;
  assign btc_dec_eham_fchase__ival       = '0 ;
  assign btc_dec_eham_fchase__istrb      = '0 ;
  assign btc_dec_eham_fchase__iLapri_ptr = '0 ;
  assign btc_dec_eham_fchase__iLpp_idx   = '0 ;
  assign btc_dec_eham_fchase__iLpp_value = '0 ;
  assign btc_dec_eham_fchase__isyndrome  = '0 ;
  assign btc_dec_eham_fchase__ieven      = '0 ;
  assign btc_dec_eham_fchase__ierr_idx   = '0 ;
  assign btc_dec_eham_fchase__idecfail   = '0 ;
  assign btc_dec_eham_fchase__iLapri     = '0 ;



*/

//
// Project       : wimax BTC
// Author        : Shekhalev Denis (des00)
// Workfile      : btc_dec_eham_fchase.sv
// Description   : extended hamming code fast chase algorithm unit
//                 use 8 candidates for code size 8 and 16 for others
//

module btc_dec_eham_fchase
(
  iclk          ,
  ireset        ,
  iclkena       ,
  //
  imode         ,
  //
  ival          ,
  istrb         ,
  iLapri_ptr    ,
  iLpp_idx      ,
  iLpp_value    ,
  isyndrome     ,
  ieven         ,
  ierr_idx      ,
  idecfail      ,
  //
  iLapri        ,
  oLapri_read   ,
  oLapri_rptr   ,
  oLapri_raddr  ,
  //
  odone         ,
  ostrb         ,
  omin0         ,
  omin1         ,
  oerr_bit_mask ,
  oerr_bit_idx  ,
  //
  odecfail
);

  `include "../btc_parameters.svh"
  `include "btc_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                   iclk              ;
  input  logic                   ireset            ;
  input  logic                   iclkena           ;
  //
  input  btc_code_mode_t         imode             ;
  //
  input  logic                   ival              ;
  input  strb_t                  istrb             ;
  input  logic                   iLapri_ptr        ;
  input  bit_idx_t               iLpp_idx      [4] ;
  input  extr_t                  iLpp_value    [4] ;
  input  state_t                 isyndrome         ;
  input  logic                   ieven             ;
  input  bit_idx_t               ierr_idx          ;
  input  logic                   idecfail          ;
  //
  input  extr_t                  iLapri            ;
  output logic                   oLapri_read       ;
  output logic                   oLapri_rptr       ;
  output bit_idx_t               oLapri_raddr      ;
  //
  output logic                   odone             ;
  output strb_t                  ostrb             ;
  output metric_t                omin0             ;
  output metric_t                omin1             ;
  output logic           [4 : 0] oerr_bit_mask     ;
  output bit_idx_t               oerr_bit_idx  [5] ;
  //
  output logic                   odecfail          ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_MAX = 16;

  localparam int cCNT_W   = $clog2(cCNT_MAX);

  // only [0:14] needed
  localparam int cEHAM_NEXT_ERAS_POS_IDX  [16] = '{0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0,   0};
  localparam bit cEHAM_NEXT_ERAS_POS_PLUS [16] = '{1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0,   0};

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic                zero;
    logic                done;
    logic [cCNT_W-1 : 0] value;
  } cnt;

  strb_t        strb      ;

  logic         Lapri_ptr ;

  bit_idx_t     Lpp_idx      [4] ;
  extr_t        Lpp_value    [4] ;
  state_t       syndrome         ;
  logic         even             ;
  bit_idx_t     err_idx          ;
  logic         decfail          ;

  logic         decfail2out;

  logic [1 : 0] next_eras_pos_idx;
  logic         next_eras_pos_plus;
  bit_idx_t     next_eras_pos;
  metric_t      wacc;

  extr_t        absLapri;
  logic         code_weigth_dec_val;
  logic         code_weigth_dec_sop;
  metric_t      code_weigth_dec;
  logic [3 : 0] code_weigth_dec_eras_idx;
  bit_idx_t     code_weigth_dec_err_idx;
  logic         code_weigth_dec_err_mask;

  logic         code_weigth_val;
  logic         code_weigth_sop;
  metric_t      code_weigth;
  logic [3 : 0] code_weigth_eras_idx;
  bit_idx_t     code_weigth_err_idx;
  logic         code_weigth_err_mask;

  logic         chase_val;
  logic         chase_dec_val;
  strb_t        chase_strb;

  bit_idx_t     chase_Lpp_idx      [4] ;
  logic         chase_decfail;

  metric_t      min0;
  logic [3 : 0] min0_eras_idx;
  bit_idx_t     min0_err_idx;
  logic         min0_err_mask;

  metric_t      min1;

  logic         sort_val;
  strb_t        sort_strb;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE  : state <= ival               ? cDO_STATE     : cRESET_STATE;
        cDO_STATE     : state <= (cnt.done & !ival) ? cRESET_STATE  : cDO_STATE;
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  always_ff @(posedge iclk) begin
    if (ival) begin
      if (state == cDO_STATE & !cnt.done) begin
        $error("%m FSM handshake error");
        $stop;
      end
    end
  end
  // synthesis translate_on

  //------------------------------------------------------------------------------------------------------
  // FSM counters
  //------------------------------------------------------------------------------------------------------

  wire [cCNT_W-1 : 0] cnt_max_m2 = (imode.size == cBSIZE_8) ? (8-2) : (16-2);

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      case (state)
        cRESET_STATE : begin
          cnt       <= '0;
          cnt.zero  <= 1'b1;
          //
          strb      <= istrb;
          //
          Lapri_ptr <= iLapri_ptr;
        end
        //
        cDO_STATE : begin
          if (ival) begin
            cnt       <= '0;
            cnt.zero  <= 1'b1;
            //
            strb      <= istrb;
            //
            Lapri_ptr <= iLapri_ptr;
          end
          else begin
            cnt.value <=  cnt.done ? '0 : (cnt.value + 1'b1);
            cnt.done  <= (cnt.value == cnt_max_m2);
            cnt.zero  <=  cnt.done;
          end
        end
      endcase
    end
  end

  assign oLapri_read  = (state == cDO_STATE);
  assign oLapri_rptr  = Lapri_ptr;

  //------------------------------------------------------------------------------------------------------
  // fast chase
  //------------------------------------------------------------------------------------------------------

  logic     no_error;
  logic     error_not_in_lpp_list;

  state_t   tsyndrome ;
  logic     teven     ;
  bit_idx_t terr_idx  ;
  logic     tdecfail  ;
  metric_t  twacc     ;

  //
  // fast chase logic

//assign next_eras_pos_idx  = cEHAM_NEXT_ERAS_POS_IDX [cnt.value];
//assign next_eras_pos_plus = cEHAM_NEXT_ERAS_POS_PLUS[cnt.value];
//assign next_eras_pos      = Lpp_idx[next_eras_pos_idx];
  assign no_error           = (syndrome == 0) & (even == 0);

  always_comb begin
    //
    // condition decoding
    error_not_in_lpp_list  = (err_idx != Lpp_idx[0]);
    error_not_in_lpp_list &= (err_idx != Lpp_idx[1]);
    error_not_in_lpp_list &= (err_idx != Lpp_idx[2]);
    if (imode.size != cBSIZE_8) begin
      error_not_in_lpp_list &= (err_idx != Lpp_idx[3]);
    end
    //
    // fast chase step
    teven = !even;
    //
    case (imode.size)
      cBSIZE_8  : begin
        tsyndrome = syndrome[2 : 0] ^ cH_7_TAB [next_eras_pos[2 : 0]];
        terr_idx  = cH_7_ERR_IDX_TAB [tsyndrome[2 : 0]];
      end
      //
      cBSIZE_16 : begin
        tsyndrome = syndrome[3 : 0] ^ cH_15_TAB [next_eras_pos[3 : 0]];
        terr_idx  = cH_15_ERR_IDX_TAB[tsyndrome[3 : 0]];
      end
      //
      cBSIZE_32 : begin
        tsyndrome = syndrome[4 : 0] ^ cH_31_TAB [next_eras_pos[4 : 0]];
        terr_idx  = cH_31_ERR_IDX_TAB[tsyndrome[4 : 0]];
      end
      //
      cBSIZE_64 : begin
        tsyndrome = syndrome[5 : 0] ^ cH_63_TAB [next_eras_pos[5 : 0]];
        terr_idx  = cH_63_ERR_IDX_TAB[tsyndrome[5 : 0]];
      end
      //
      default : begin
        tsyndrome = syndrome;
        terr_idx  = '0;
      end
    endcase
    //
    tdecfail = (tsyndrome != 0) & (teven == 0);
    //
    twacc    = next_eras_pos_plus ? (wacc + Lpp_value[next_eras_pos_idx]) :
                                    (wacc - Lpp_value[next_eras_pos_idx]);
  end

  assign oLapri_raddr = err_idx;


  //
  // fast chase registers

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      chase_dec_val <= 1'b0;
    end
    else if (iclkena) begin
      chase_dec_val <= (state == cDO_STATE) & cnt.done;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      code_weigth_dec_val <= 1'b0;
      code_weigth_dec_sop <= 1'b0;
      //
      case (state)
        cRESET_STATE : begin
          if (ival) begin // init chase
            // hold chase context
            Lpp_idx             <= iLpp_idx;
            Lpp_value           <= iLpp_value;
            // init chase
            syndrome            <= isyndrome;
            even                <= ieven;
            err_idx             <= ierr_idx;
            decfail             <= idecfail;
            wacc                <= '0;
            // latch initial for fast decision
            decfail2out         <= idecfail;
            // look ahead decision
            next_eras_pos_idx   <=          cEHAM_NEXT_ERAS_POS_IDX [0];
            next_eras_pos_plus  <=          cEHAM_NEXT_ERAS_POS_PLUS[0];
            next_eras_pos       <= iLpp_idx[cEHAM_NEXT_ERAS_POS_IDX [0]];
          end
        end
        //
        cDO_STATE : begin
          if (ival) begin // init chase
            // hold chase context
            Lpp_idx             <= iLpp_idx;
            Lpp_value           <= iLpp_value;
            // init chase
            syndrome            <= isyndrome;
            even                <= ieven;
            err_idx             <= ierr_idx;
            decfail             <= idecfail;
            wacc                <= '0;
            // latch initial for fast decision
            decfail2out         <= idecfail;
            // look ahead decision
            next_eras_pos_idx   <=          cEHAM_NEXT_ERAS_POS_IDX [0];
            next_eras_pos_plus  <=          cEHAM_NEXT_ERAS_POS_PLUS[0];
            next_eras_pos       <= iLpp_idx[cEHAM_NEXT_ERAS_POS_IDX [0]];
          end
          else begin // chase step
            syndrome            <= tsyndrome;
            even                <= teven;
            err_idx             <= terr_idx;
            decfail             <= tdecfail;
            wacc                <= twacc;
            // look ahead decision
            next_eras_pos_idx   <=         cEHAM_NEXT_ERAS_POS_IDX [cnt.value + 1'b1];
            next_eras_pos_plus  <=         cEHAM_NEXT_ERAS_POS_PLUS[cnt.value + 1'b1];
            next_eras_pos       <= Lpp_idx[cEHAM_NEXT_ERAS_POS_IDX [cnt.value + 1'b1]];
          end
          //
          // chase decode
          code_weigth_dec_sop         <= cnt.zero;
          code_weigth_dec_val         <= !decfail & (no_error | error_not_in_lpp_list);
          code_weigth_dec_eras_idx    <= cnt.value;
          code_weigth_dec             <= wacc;
          if (no_error) begin
            code_weigth_dec_err_idx   <= '0;
            code_weigth_dec_err_mask  <= 1'b0; // no error
          end
          else /*if (error_not_in_lpp_list)*/ begin
            code_weigth_dec_err_idx   <= err_idx;
            code_weigth_dec_err_mask  <= 1'b1; // is error at err idx
          end
          //
          // hold chase context
          if (cnt.done) begin
            chase_strb    <= strb;
            chase_Lpp_idx <= Lpp_idx;
            chase_decfail <= decfail2out;
          end
        end
      endcase
    end
  end

  //------------------------------------------------------------------------------------------------------
  // Lapri ram reading is 1 tick
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      chase_val <= 1'b0;
    end
    else if (iclkena) begin
      chase_val <= chase_dec_val;
    end
  end

  assign absLapri = {1'b0, iLapri[$high(iLapri)-1 : 0]}; // Lapri in {sign, abs} format (!!!)

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      code_weigth_val      <= code_weigth_dec_val;
      code_weigth_sop      <= code_weigth_dec_sop;
      code_weigth          <= code_weigth_dec + (code_weigth_dec_err_mask ? absLapri : 0);
      //
      code_weigth_eras_idx <= code_weigth_dec_eras_idx;
      code_weigth_err_idx  <= code_weigth_dec_err_idx;
      code_weigth_err_mask <= code_weigth_dec_err_mask;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // metric sorting to search maximim probably codeword
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      sort_val <= 1'b0;
    end
    else if (iclkena) begin
      sort_val <= chase_val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (code_weigth_sop) begin
        if (code_weigth_val) begin
          min0          <= code_weigth;
          min0_eras_idx <= code_weigth_eras_idx;
          min0_err_idx  <= code_weigth_err_idx;
          min0_err_mask <= code_weigth_err_mask;
        end
        else begin
          // set maximim
          min0              <= '1;
          min0[$high(min0)] <= 1'b0;
        end
        // set maximim
        min1              <= '1;
        min1[$high(min1)] <= 1'b0;
      end
      else if (code_weigth_val) begin
        if (code_weigth < min0) begin
          min0          <= code_weigth;
          min0_eras_idx <= code_weigth_eras_idx;
          min0_err_idx  <= code_weigth_err_idx;
          min0_err_mask <= code_weigth_err_mask;
          //
          min1          <= min0;
        end
        else if (code_weigth < min1) begin
          min1          <= code_weigth;
        end
      end // code_weigth_val
    end // iclkena
  end // iclk

  //------------------------------------------------------------------------------------------------------
  // decoding results
  // chase_Lpp_idx/chase_strb/chase_decfail hold at least 6 ticks
  // all signals latched inside hamm_decision unit
  //------------------------------------------------------------------------------------------------------

  assign odone                = sort_val;

  assign ostrb                = chase_strb;

  assign omin0                = min0;
  assign omin1                = min1;

  assign oerr_bit_idx [0 : 3] = chase_Lpp_idx;
  assign oerr_bit_mask[3 : 0] = (min0_eras_idx >> 1) ^ min0_eras_idx; // bin2gray

  assign oerr_bit_mask[4]     = min0_err_mask;
  assign oerr_bit_idx [4]     = min0_err_idx;

  assign odecfail             = chase_decfail;

endmodule
