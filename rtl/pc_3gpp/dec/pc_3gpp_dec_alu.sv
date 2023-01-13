/*



  parameter int pN_MAX   = 1024 ;
  parameter int pLLR_W   =    4 ;
  parameter int pWORD_W  =    8 ;



  logic           pc_3gpp_dec_alu__iclk               ;
  logic           pc_3gpp_dec_alu__ireset             ;
  logic           pc_3gpp_dec_alu__iclkena            ;
  alu_opcode_t    pc_3gpp_dec_alu__iopcode            ;
  frozenb_type_t  pc_3gpp_dec_alu__ofrzb_type         ;
  logic           pc_3gpp_dec_alu__ofrzb_dec_done     ;
  llr_w_t         pc_3gpp_dec_alu__iLLR               ;
  beta_w_dat_t    pc_3gpp_dec_alu__ifrzb              ;
  beta_w_addr_t   pc_3gpp_dec_alu__ibeta_raddr        ;
  logic           pc_3gpp_dec_alu__ibeta_rsel         ;
  beta_w_dat_t    pc_3gpp_dec_alu__ibeta_rdat     [2] ;
  alpha_w_addr_t  pc_3gpp_dec_alu__ialpha_raddr       ;
  logic           pc_3gpp_dec_alu__ialpha_rsel        ;
  alpha_w_t       pc_3gpp_dec_alu__ialpha_rdat        ;
  beta_w_addr_t   pc_3gpp_dec_alu__iaddr2write        ;
  logic           pc_3gpp_dec_alu__isel2write         ;
  logic           pc_3gpp_dec_alu__ifull2write        ;
  beta_w_dat_t    pc_3gpp_dec_alu__ifrzb2write        ;
  logic           pc_3gpp_dec_alu__obeta_write        ;
  beta_w_addr_t   pc_3gpp_dec_alu__obeta_waddr        ;
  logic           pc_3gpp_dec_alu__obeta_wsel         ;
  beta_w_dat_t    pc_3gpp_dec_alu__obeta_wdat         ;
  logic           pc_3gpp_dec_alu__oalpha_write       ;
  alpha_w_addr_t  pc_3gpp_dec_alu__oalpha_waddr       ;
  logic           pc_3gpp_dec_alu__oalpha_wsel        ;
  alpha_hw_dat_t  pc_3gpp_dec_alu__oalpha_wdat        ;
  logic           pc_3gpp_dec_alu__owfull             ;
  logic           pc_3gpp_dec_alu__owrite             ;
  beta_w_addr_t   pc_3gpp_dec_alu__owaddr             ;
  beta_w_dat_t    pc_3gpp_dec_alu__owdat              ;
  err_t           pc_3gpp_dec_alu__oerr               ;



  pc_3gpp_dec_alu
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pLLR_W  ( pLLR_W  ) ,
    .pWORD_W ( pWORD_W )
  )
  pc_3gpp_dec_alu
  (
    .iclk           ( pc_3gpp_dec_alu__iclk           ) ,
    .ireset         ( pc_3gpp_dec_alu__ireset         ) ,
    .iclkena        ( pc_3gpp_dec_alu__iclkena        ) ,
    .iopcode        ( pc_3gpp_dec_alu__iopcode        ) ,
    .ofrzb_type     ( pc_3gpp_dec_alu__ofrzb_type     ) ,
    .ofrzb_dec_done ( pc_3gpp_dec_alu__ofrzb_dec_done ) ,
    .iLLR           ( pc_3gpp_dec_alu__iLLR           ) ,
    .ifrzb          ( pc_3gpp_dec_alu__ifrzb          ) ,
    .ibeta_raddr    ( pc_3gpp_dec_alu__ibeta_raddr    ) ,
    .ibeta_rsel     ( pc_3gpp_dec_alu__ibeta_rsel     ) ,
    .ibeta_rdat     ( pc_3gpp_dec_alu__ibeta_rdat     ) ,
    .ialpha_raddr   ( pc_3gpp_dec_alu__ialpha_raddr   ) ,
    .ialpha_rsel    ( pc_3gpp_dec_alu__ialpha_rsel    ) ,
    .ialpha_rdat    ( pc_3gpp_dec_alu__ialpha_rdat    ) ,
    .iaddr2write    ( pc_3gpp_dec_alu__iaddr2write    ) ,
    .isel2write     ( pc_3gpp_dec_alu__isel2write     ) ,
    .ifull2write    ( pc_3gpp_dec_alu__ifull2write    ) ,
    .ifrzb2write    ( pc_3gpp_dec_alu__ifrzb2write    ) ,
    .obeta_write    ( pc_3gpp_dec_alu__obeta_write    ) ,
    .obeta_waddr    ( pc_3gpp_dec_alu__obeta_waddr    ) ,
    .obeta_wsel     ( pc_3gpp_dec_alu__obeta_wsel     ) ,
    .obeta_wdat     ( pc_3gpp_dec_alu__obeta_wdat     ) ,
    .oalpha_write   ( pc_3gpp_dec_alu__oalpha_write   ) ,
    .oalpha_waddr   ( pc_3gpp_dec_alu__oalpha_waddr   ) ,
    .oalpha_wsel    ( pc_3gpp_dec_alu__oalpha_wsel    ) ,
    .oalpha_wdat    ( pc_3gpp_dec_alu__oalpha_wdat    ) ,
    .owfull         ( pc_3gpp_dec_alu__owfull         ) ,
    .owrite         ( pc_3gpp_dec_alu__owrite         ) ,
    .owaddr         ( pc_3gpp_dec_alu__owaddr         ) ,
    .owdat          ( pc_3gpp_dec_alu__owdat          ) ,
    .oerr           ( pc_3gpp_dec_alu__oerr           )
  );


  assign pc_3gpp_dec_alu__iclk         = '0 ;
  assign pc_3gpp_dec_alu__ireset       = '0 ;
  assign pc_3gpp_dec_alu__iclkena      = '0 ;
  assign pc_3gpp_dec_alu__iopcode      = '0 ;
  assign pc_3gpp_dec_alu__iLLR         = '0 ;
  assign pc_3gpp_dec_alu__ifrzb        = '0 ;
  assign pc_3gpp_dec_alu__ibeta_raddr  = '0 ;
  assign pc_3gpp_dec_alu__ibeta_rsel   = '0 ;
  assign pc_3gpp_dec_alu__ibeta_rdat   = '0 ;
  assign pc_3gpp_dec_alu__ialpha_raddr = '0 ;
  assign pc_3gpp_dec_alu__ialpha_rsel  = '0 ;
  assign pc_3gpp_dec_alu__ialpha_rdat  = '0 ;
  assign pc_3gpp_dec_alu__iaddr2write  = '0 ;
  assign pc_3gpp_dec_alu__isel2write   = '0 ;
  assign pc_3gpp_dec_alu__ifull2write  = '0 ;
  assign pc_3gpp_dec_alu__ifrzb2write  = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_alu.sv
// Description   : Recursive polar decoder arithmetic unit
//

`include "define.vh"

module pc_3gpp_dec_alu
(
  iclk           ,
  ireset         ,
  iclkena        ,
  //
  iopcode        ,
  ofrzb_type     ,
  ofrzb_dec_done ,
  //
  iLLR           ,
  ifrzb          ,
  //
  ibeta_raddr    ,
  ibeta_rsel     ,
  ibeta_rdat     ,
  ibeta_waddr    ,
  ibeta_wsel     ,
  //
  ialpha_raddr   ,
  ialpha_rsel    ,
  ialpha_rdat    ,
  ialpha_waddr   ,
  ialpha_wsel    ,
  //
  iaddr2write    ,
  ifrzb2write    ,
  ifull2write    ,
  //
  obeta_write    ,
  obeta_waddr    ,
  obeta_wsel     ,
  obeta_wdat     ,
  //
  oalpha_write   ,
  oalpha_waddr   ,
  oalpha_wsel    ,
  oalpha_wdat    ,
  //
  owfull         ,
  owrite         ,
  owaddr         ,
  owdat          ,
  //
  oerr
);

  `include "pc_3gpp_dec_types.svh"
  `include "pc_3gpp_dec_functions.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk             ;
  input  logic          ireset           ;
  input  logic          iclkena          ;
  //
  input  alu_opcode_t   iopcode          ;
  output frozenb_type_t ofrzb_type       ;
  output logic          ofrzb_dec_done   ;
  //
  input  llr_w_t        iLLR             ;
  input  beta_w_dat_t   ifrzb            ;
  //
  input  beta_w_addr_t  ibeta_raddr      ;
  input  logic          ibeta_rsel       ;
  input  beta_w_dat_t   ibeta_rdat   [2] ;
  input  beta_w_addr_t  ibeta_waddr      ;
  input  logic          ibeta_wsel       ;
  //
  input  alpha_w_addr_t ialpha_raddr     ;
  input  logic          ialpha_rsel      ;
  input  alpha_w_t      ialpha_rdat      ;
  input  alpha_w_addr_t ialpha_waddr     ;
  input  logic          ialpha_wsel      ;
  //
  input  beta_w_addr_t  iaddr2write      ;
  input  logic          ifull2write      ;
  input  beta_w_dat_t   ifrzb2write      ;
  //
  output logic          obeta_write      ;
  output beta_w_addr_t  obeta_waddr      ;
  output logic          obeta_wsel       ;
  output beta_w_dat_t   obeta_wdat       ;
  //
  output logic          oalpha_write     ;
  output alpha_w_addr_t oalpha_waddr     ;
  output logic          oalpha_wsel      ;
  output alpha_hw_t     oalpha_wdat      ;
  //
  output logic          owfull           ;
  output logic          owrite           ;
  output beta_w_addr_t  owaddr           ;
  output beta_w_dat_t   owdat            ;
  //
  output err_t          oerr             ;

  //------------------------------------------------------------------------------------------------------
  // beta processing part (comb8)
  //------------------------------------------------------------------------------------------------------

  // fssc decoder 8x8
  logic           alu_8x8__ialpha_val  ;
  alpha_w_t       alu_8x8__ialpha      ;

  beta_w_dat_t    alu_8x8__ifrzb       ;
  frozenb_type_t  alu_8x8__ifrzb_type  ;

  logic           alu_8x8__obeta_val   ;
  beta_w_dat_t    alu_8x8__obeta       ;

  //
  alpha_hw_t   calcF4_llr_rslt;
  alpha_hw_t   calcF4_ext_rslt;

  alpha_hw_t   calcG4_llr_rslt;
  alpha_hw_t   calcG4_int_rslt;
  alpha_hw_t   calcG4_ext_rslt;

  beta_w_dat_t comb8_ext_rslt;
  beta_w_dat_t comb8_int_rslt;

  beta_w_dat_t wdat_frzb_mask;

  beta_w_dat_t hd;

  alpha_w_t    alpha_cache;

  beta_w_dat_t alu_8x8_rslt_reg [2];

  //------------------------------------------------------------------------------------------------------
  // base engine functions
  //------------------------------------------------------------------------------------------------------

  assign calcF4_llr_rslt  = do_F4_chLLR (iLLR);
  assign calcF4_ext_rslt  = do_F4       (ialpha_rdat);

  assign calcG4_llr_rslt  = do_G4_chLLR (iLLR,                ibeta_rdat[0],       ibeta_rsel);
  assign calcG4_ext_rslt  = do_G4       (ialpha_rdat,         ibeta_rdat[0],       ibeta_rsel);
  assign calcG4_int_rslt  = do_G4       (ialpha_rdat,         alu_8x8_rslt_reg[1], ibeta_rsel);

  assign comb8_int_rslt   = do_comb8    (alu_8x8_rslt_reg[0], alu_8x8_rslt_reg[1], ibeta_rsel);
  assign comb8_ext_rslt   = do_comb8    (ibeta_rdat      [0], ibeta_rdat      [1], ibeta_rsel);

  //------------------------------------------------------------------------------------------------------
  // decode engine 8x8
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_alu_8x8
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pLLR_W  ( pLLR_W  ) ,
    .pWORD_W ( pWORD_W )
  )
  alu_8x8
  (
    .iclk       ( iclk                ) ,
    .ireset     ( ireset              ) ,
    .iclkena    ( iclkena             ) ,
    //
    .ialpha_val ( alu_8x8__ialpha_val ) ,
    .ialpha     ( alu_8x8__ialpha     ) ,
    //
    .ifrzb      ( alu_8x8__ifrzb      ) ,
    .ifrzb_type ( alu_8x8__ifrzb_type ) ,
    //
    .obeta_val  ( alu_8x8__obeta_val  ) ,
    .obeta      ( alu_8x8__obeta      )
  );

  assign alu_8x8__ifrzb = ifrzb;

  always_comb begin
    if (ifrzb == 8'hFF)
      alu_8x8__ifrzb_type = cDEC_RATE0_8;
    else if (ifrzb == 8'h00)
      alu_8x8__ifrzb_type = cDEC_RATE1_8;
    else if (ifrzb[0 +: 4] == 4'hF)
      alu_8x8__ifrzb_type = cDEC_X_4_RATE0_4;
    else if (ifrzb[4 +: 4] == 4'hF)
      alu_8x8__ifrzb_type = cDEC_RATE0_4_X_4;
    else
      alu_8x8__ifrzb_type = cDEC_X_8;
  end

  assign ofrzb_type           = alu_8x8__ifrzb_type;
  assign ofrzb_dec_done       = alu_8x8__obeta_val;

  assign alu_8x8__ialpha_val  = (iopcode == cDO_8x8);
  assign alu_8x8__ialpha      = alpha_cache;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

// synthesis translate_off

  bit pCMD_LOG = 0;

  int          fp;
  alu_opcode_e opcode;

  assign opcode = alu_opcode_e'(iopcode);

  initial begin
    if (pCMD_LOG) begin
      fp = $fopen("%m_rtl_cmd_log.log", "w");
    end
  end
// synthesis translate_on

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      owaddr          <= iaddr2write;
      //
      obeta_waddr     <= ibeta_waddr;
      obeta_wsel      <= ibeta_wsel;
      //
      oalpha_waddr    <= ialpha_waddr;
      oalpha_wsel     <= ialpha_wsel;
      //
      wdat_frzb_mask  <= ifrzb2write;
      //
      unique case (iopcode)
        cDO_8x8, cDO_8x8_W : begin
          if (alu_8x8__obeta_val) begin
            alu_8x8_rslt_reg[1] <= alu_8x8__obeta;
            alu_8x8_rslt_reg[0] <= alu_8x8_rslt_reg[1];
            // synthesis translate_off
            if (pCMD_LOG) begin
              if (iopcode == cDO_8x8)
                $fdisplay(fp, "Decode %0p (opcode %b) -> %b", alpha_cache, ifrzb, alu_8x8__obeta);
              else
                $fdisplay(fp, "Decode %0p (opcode %b) -> %b", alpha_cache, alu_8x8.frozenb, alu_8x8__obeta);
            end
            // synthesis translate_on
          end
        end

        cCALC_F4 : begin
          oalpha_wdat <= calcF4_ext_rslt;
          //
          if (ialpha_wsel)
            alpha_cache[4 +: 4] <= calcF4_ext_rslt;
          else
            alpha_cache[0 +: 4] <= calcF4_ext_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "F4 [%0d]-> [%0d][%0d]. %0p", ialpha_raddr, ialpha_waddr, ialpha_wsel, ialpha_rdat);
          end
          // synthesis translate_on
        end

        cCALC_F4LLR : begin
          oalpha_wdat <=  calcF4_llr_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "F4 LLR -> [%0d][%0d]", ialpha_waddr, ialpha_wsel);
          end
          // synthesis translate_on
        end

        cCALC_G4 : begin
          oalpha_wdat <= calcG4_ext_rslt;
          //
          if (ialpha_wsel)
            alpha_cache[4 +: 4] <= calcG4_ext_rslt;
          else
            alpha_cache[0 +: 4] <= calcG4_ext_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "G4 [%0d] & [%0d][%0d]-> [%0d][%0d]. %0p & %b -> %0p", ialpha_raddr,
                      ibeta_raddr, ibeta_rsel, ialpha_waddr, ialpha_wsel, ialpha_rdat, ibeta_rdat[0][ibeta_rsel*4 +: 4], calcG4_ext_rslt);
          end
          // synthesis translate_on
        end

        cCALC_G4_int : begin
          oalpha_wdat <= calcG4_int_rslt;
          //
          if (ialpha_wsel)
            alpha_cache[4 +: 4] <= calcG4_int_rslt;
          else
            alpha_cache[0 +: 4] <= calcG4_int_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "G4 [%0d] & [%0d][%0d]-> [%0d][%0d]. %0p & %b -> %0p", ialpha_raddr,
                      ibeta_raddr, ibeta_rsel, ialpha_waddr, ialpha_wsel, ialpha_rdat, alu_8x8_rslt_reg[1][ibeta_rsel*4 +: 4], calcG4_int_rslt);
          end
          // synthesis translate_on
        end

        cCALC_G4LLR : begin
          oalpha_wdat <= calcG4_llr_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "G4 LLR -> [%0d][%0d]", ialpha_waddr, ialpha_wsel);
          end
          // synthesis translate_on
        end

        cCOMB_int : begin
          obeta_wdat <= comb8_int_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "COMB8 [%0d][%0d]-> [%0d][%0d]. %b vs %b",
                      ibeta_raddr, ibeta_rsel, ibeta_waddr, ibeta_wsel, alu_8x8_rslt_reg[0][ibeta_rsel*4 +: 4], alu_8x8_rslt_reg[1][ibeta_rsel*4 +: 4]);
          end
          // synthesis translate_on
        end

        cCOMB_ext : begin
          obeta_wdat <= comb8_ext_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "COMB8 [%0d][%0d]-> [%0d][%0d]. %b vs %b",
                      ibeta_raddr, ibeta_rsel, ibeta_waddr, ibeta_wsel, ibeta_rdat[0][ibeta_rsel*4 +: 4], ibeta_rdat[1][ibeta_rsel*4 +: 4]);
          end
          // synthesis translate_on
        end

        cCOMB_last : begin
          obeta_wdat <= comb8_ext_rslt;
          // synthesis translate_off
          if (pCMD_LOG) begin
            $fdisplay(fp, "COMB8 [%0d][%0d]-> [%0d][%0d]. %b vs %b = %b",
                      ibeta_raddr, ibeta_rsel, ibeta_waddr, 0, ibeta_rdat[0][ibeta_rsel*4 +: 4], ibeta_rdat[1][ibeta_rsel*4 +: 4], comb8_ext_rslt);
          end
          // synthesis translate_on
        end
        default : begin end
      endcase
    end
  end

  assign owdat = obeta_wdat & ~wdat_frzb_mask;  // clear frozen bits for re ecnode

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oalpha_write  <= 1'b0;
      obeta_write   <= 1'b0;
      owrite        <= 1'b0;
      owfull        <= 1'b0;
    end
    else if (iclkena) begin
      oalpha_write  <= (iopcode == cCALC_F4) | (iopcode == cCALC_F4LLR) | (iopcode == cCALC_G4) | (iopcode == cCALC_G4_int) | (iopcode == cCALC_G4LLR);
      obeta_write   <= (iopcode == cCOMB_int) | (iopcode == cCOMB_ext);
      owrite        <= (iopcode == cCOMB_last);
      owfull        <= ifull2write;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // error counter
  //------------------------------------------------------------------------------------------------------

  err_t err;

  always_comb begin
    for (int i = 0; i < pWORD_W; i++) begin
      hd[i] = iLLR[i][pLLR_W-1]; // metric inversion
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      err <= '0;
      if (iopcode == cCOMB_last)
        err <= err + get_err(comb8_ext_rslt ^ hd);
      //
      if (ifull2write) begin  // has offset for 1 cycle
        oerr <= err;
      end
    end
  end

  function automatic err_t get_err (input beta_w_dat_t dat);
    get_err = 0;
    for (int i = 0; i < pWORD_W; i++) begin
      get_err = get_err + dat[i];
    end
  endfunction

endmodule
