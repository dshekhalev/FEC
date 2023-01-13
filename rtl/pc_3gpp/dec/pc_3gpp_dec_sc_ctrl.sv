/*



  parameter int pN_MAX  = 1024 ;
  parameter int pWORD_W =    8 ;



  logic          pc_3gpp_dec_sc_ctrl__iclk                   ;
  logic          pc_3gpp_dec_sc_ctrl__ireset                 ;
  logic          pc_3gpp_dec_sc_ctrl__iclkena                ;
  logic          pc_3gpp_dec_sc_ctrl__isource_ram_full       ;
  logic          pc_3gpp_dec_sc_ctrl__osource_ram_rempty     ;
  beta_w_addr_t  pc_3gpp_dec_sc_ctrl__osource_ram_rLLR_addr  ;
  beta_w_addr_t  pc_3gpp_dec_sc_ctrl__osource_ram_rfrzb_addr ;
  logic          pc_3gpp_dec_sc_ctrl__isink_ram_empty        ;
  logic          pc_3gpp_dec_sc_ctrl__osink_ram_wfull        ;
  beta_w_addr_t  pc_3gpp_dec_sc_ctrl__obeta_raddr            ;
  logic          pc_3gpp_dec_sc_ctrl__obeta_rsel             ;
  beta_w_addr_t  pc_3gpp_dec_sc_ctrl__obeta_waddr            ;
  logic          pc_3gpp_dec_sc_ctrl__obeta_wsel             ;
  beta_w_addr_t  pc_3gpp_dec_sc_ctrl__oalpha_raddr           ;
  logic          pc_3gpp_dec_sc_ctrl__oalpha_rsel            ;
  beta_w_addr_t  pc_3gpp_dec_sc_ctrl__oalpha_waddr           ;
  logic          pc_3gpp_dec_sc_ctrl__oalpha_wsel            ;
  beta_w_addr_t  pc_3gpp_dec_sc_ctrl__oaddr2write            ;
  frozenb_type_t pc_3gpp_dec_sc_ctrl__ialu_frzb_type         ;
  logic          pc_3gpp_dec_sc_ctrl__ialu_frzb_dec_done     ;
  alu_opcode_t   pc_3gpp_dec_sc_ctrl__oalu_opcode            ;
  logic          pc_3gpp_dec_sc_ctrl__obusy                  ;



  pc_3gpp_dec_sc_ctrl
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W )
  )
  pc_3gpp_dec_sc_ctrl
  (
    .iclk                   ( pc_3gpp_dec_sc_ctrl__iclk                   ) ,
    .ireset                 ( pc_3gpp_dec_sc_ctrl__ireset                 ) ,
    .iclkena                ( pc_3gpp_dec_sc_ctrl__iclkena                ) ,
    .isource_ram_full       ( pc_3gpp_dec_sc_ctrl__isource_ram_full       ) ,
    .osource_ram_rempty     ( pc_3gpp_dec_sc_ctrl__osource_ram_rempty     ) ,
    .osource_ram_rLLR_addr  ( pc_3gpp_dec_sc_ctrl__osource_ram_rLLR_addr  ) ,
    .osource_ram_rfrzb_addr ( pc_3gpp_dec_sc_ctrl__osource_ram_rfrzb_addr ) ,
    .isink_ram_empty        ( pc_3gpp_dec_sc_ctrl__isink_ram_empty        ) ,
    .osink_ram_wfull        ( pc_3gpp_dec_sc_ctrl__osink_ram_wfull        ) ,
    .obeta_raddr            ( pc_3gpp_dec_sc_ctrl__obeta_raddr            ) ,
    .obeta_rsel             ( pc_3gpp_dec_sc_ctrl__obeta_rsel             ) ,
    .obeta_waddr            ( pc_3gpp_dec_sc_ctrl__obeta_waddr            ) ,
    .obeta_wsel             ( pc_3gpp_dec_sc_ctrl__obeta_wsel             ) ,
    .oalpha_raddr           ( pc_3gpp_dec_sc_ctrl__oalpha_raddr           ) ,
    .oalpha_rsel            ( pc_3gpp_dec_sc_ctrl__oalpha_rsel            ) ,
    .oalpha_waddr           ( pc_3gpp_dec_sc_ctrl__oalpha_waddr           ) ,
    .oalpha_wsel            ( pc_3gpp_dec_sc_ctrl__oalpha_wsel            ) ,
    .oaddr2write            ( pc_3gpp_dec_sc_ctrl__oaddr2write            ) ,
    .ialu_frzb_type         ( pc_3gpp_dec_sc_ctrl__ialu_frzb_type         ) ,
    .ialu_frzb_dec_done     ( pc_3gpp_dec_sc_ctrl__ialu_frzb_dec_done     ) ,
    .oalu_opcode            ( pc_3gpp_dec_sc_ctrl__oalu_opcode            ) ,
    .obusy                  ( pc_3gpp_dec_sc_ctrl__obusy                  )
  );


  assign pc_3gpp_dec_sc_ctrl__iclk                = '0 ;
  assign pc_3gpp_dec_sc_ctrl__ireset              = '0 ;
  assign pc_3gpp_dec_sc_ctrl__iclkena             = '0 ;
  assign pc_3gpp_dec_sc_ctrl__isource_ram_full    = '0 ;
  assign pc_3gpp_dec_sc_ctrl__isink_ram_empty     = '0 ;
  assign pc_3gpp_dec_sc_ctrl__ialu_frzb_type      = '0 ;
  assign pc_3gpp_dec_sc_ctrl__ialu_frzb_dec_done  = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_sc_ctrl.sv
// Description   : Polar deocder 2^10 successive canstellation decoding algorithm controller
//

`include "define.vh"

module pc_3gpp_dec_sc_ctrl
(
  iclk                   ,
  ireset                 ,
  iclkena                ,
  //
  isource_ram_full       ,
  osource_ram_rempty     ,
  osource_ram_rLLR_addr  ,
  osource_ram_rfrzb_addr ,
  //
  isink_ram_empty        ,
  osink_ram_wfull        ,
  //
  obeta_raddr            ,
  obeta_rsel             ,
  obeta_waddr            ,
  obeta_wsel             ,
  //
  oalpha_raddr           ,
  oalpha_rsel            ,
  oalpha_waddr           ,
  oalpha_wsel            ,
  //
  oaddr2write            ,
  //
  ialu_frzb_type         ,
  ialu_frzb_dec_done     ,
  oalu_opcode            ,
  //
  obusy
);

  `include "pc_3gpp_dec_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk                   ;
  input  logic         ireset                 ;
  input  logic         iclkena                ;
  //
  input  logic         isource_ram_full       ;
  output logic         osource_ram_rempty     ;
  output beta_w_addr_t osource_ram_rLLR_addr  ;
  output beta_w_addr_t osource_ram_rfrzb_addr ;
  //
  input  logic         isink_ram_empty        ;
  output logic         osink_ram_wfull        ;
  //
  output beta_w_addr_t obeta_raddr            ;
  output logic         obeta_rsel             ;
  output beta_w_addr_t obeta_waddr            ;
  output logic         obeta_wsel             ;
  //
  output beta_w_addr_t oalpha_raddr           ;
  output logic         oalpha_rsel            ;
  output beta_w_addr_t oalpha_waddr           ;
  output logic         oalpha_wsel            ;
  //
  output beta_w_addr_t oaddr2write            ;
  //
  input frozenb_type_t ialu_frzb_type         ;
  input logic          ialu_frzb_dec_done     ;
  output alu_opcode_t  oalu_opcode            ;
  //
  output logic         obusy                  ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLAMBDA_OFFSET [8] = '{128, 64, 32, 16, 8, 4, 2, 1};
  localparam int cBETA_MAX      [8] = '{126, 62, 30, 14, 6, 2, 0, 0};   //  cLAMBDA_OFFSET - 2
  localparam int cLSHIFT_INDEX  [8] = '{0,    6,  5,  4, 3, 2, 1, 0};

  localparam int cPHI_MAX     = pN_MAX/pWORD_W;
  localparam int cPHI_CNT_W   = clog2(cPHI_MAX);

  localparam int cBETA_CNT_W  = clog2(cPHI_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // FSM
  logic [12 : 0] state__br    ;
  logic [15 : 0] state__out   ;
  logic [15 : 0] state__out_r ;

  //
  logic phi_clear;
  logic phi_incr;

  struct packed {
    logic                    done;
    logic [cPHI_CNT_W-1 : 0] val;
  } phi_cnt;

  logic [cPHI_CNT_W-1 : 0] phi_zeros;
  logic [cPHI_CNT_W-1 : 0] phi_latch;
  logic [cPHI_CNT_W-1 : 0] phi_srl;

  //
  logic beta_clear;
  logic beta_incr;

  struct packed {
    logic                     done;
    logic [cBETA_CNT_W-1 : 0] val;
  } beta_cnt;

  //
  logic [2 : 0] used_lambda;
  logic [2 : 0] used_lambda_m1;
  logic [3 : 0] alu_opcode;

  logic source_ram_rempty;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_dec_sc_ctrl_state
  state
  (
    .iclk     ( iclk         ) ,
    .isclr    ( 1'b0         ) ,
    .ireset   ( ireset       ) ,
    .iclkena  ( iclkena      ) ,
    //
    .br       ( state__br    ) ,
    .out      ( state__out   ) ,
    .out_r    ( state__out_r )
  );

  // branches
  assign state__br[0] = isource_ram_full;
  assign state__br[1] = isink_ram_empty;

  assign state__br[2] = beta_cnt.done;

  assign state__br[3] = phi_zeros[0];
  assign state__br[4] = phi_zeros[1];
  assign state__br[5] = phi_zeros[2];
  assign state__br[6] = phi_zeros[3];
  assign state__br[7] = phi_zeros[4];
  assign state__br[8] = phi_zeros[5];

  assign state__br[9] = phi_srl[0];

  assign state__br[10] = ialu_frzb_dec_done;

  assign state__br[11] = (ialu_frzb_type == cDEC_RATE0_8)     | (ialu_frzb_type == cDEC_RATE1_8);
  assign state__br[12] = (ialu_frzb_type == cDEC_RATE0_4_X_4) | (ialu_frzb_type == cDEC_X_4_RATE0_4);

  // outputs
  assign osource_ram_rempty = state__out[0];

  assign osink_ram_wfull    = state__out[1];

  assign obusy              = !state__out[2];

  assign phi_clear          = state__out[4];
  assign phi_incr           = state__out[5];
  assign beta_clear         = state__out[6];
  assign beta_incr          = state__out[7];

  assign used_lambda        = state__out[10 : 8];

  assign used_lambda_m1     = used_lambda-1;

  assign alu_opcode         = state__out[15 : 12];

  //------------------------------------------------------------------------------------------------------
  // FSM counters and contols
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (phi_clear) begin
        phi_cnt <= '0;
      end
      else if (phi_incr) begin
        phi_cnt.done  <= (phi_cnt.val == cPHI_MAX-2);
        phi_cnt.val   <=  phi_cnt.val + 1'b1;
      end
      //
      if (beta_clear) begin
        beta_cnt <= '0;
      end
      else if (beta_incr) begin
        beta_cnt.done <= (beta_cnt.val == cBETA_MAX[used_lambda_m1]);
        beta_cnt.val  <= beta_cnt.done ? '0 : (beta_cnt.val + 1'b1);
      end
      //
      if (phi_incr) begin
        phi_latch <= phi_cnt.val;
        phi_srl   <= phi_cnt.val;
        phi_zeros <= get_phi_zeros(phi_cnt.val);
      end
      else if (beta_clear | (beta_incr & beta_cnt.done)) begin
        phi_srl <= (phi_srl >> 1);
      end
    end
  end

  function logic [cPHI_CNT_W-1 : 0] get_phi_zeros (input logic [cPHI_CNT_W-1 : 0] phi);
  begin
    get_phi_zeros[0] = !phi[0];
    for (int i = 1; i < cPHI_CNT_W; i++) begin
      get_phi_zeros[i] = get_phi_zeros[i-1] & !phi[i];
    end
  end
  endfunction

  //------------------------------------------------------------------------------------------------------
  // source data/beta ram access
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // read LLR at F512/G512
      // read LLR & frozen bits at Comb512(hd decision, channel error counter, reencode)
      osource_ram_rLLR_addr   <= beta_cnt.val;

      // read frozen bits to detect bit pattern for component code
      osource_ram_rfrzb_addr  <= phi_latch;

      // write at Comb512 to output ram
      oaddr2write             <= beta_cnt.val;

      // read/write at F/G functions
      oalpha_raddr            <= cLAMBDA_OFFSET[used_lambda_m1] +  beta_cnt.val;
      oalpha_waddr            <= cLAMBDA_OFFSET[used_lambda]    + (beta_cnt.val >> 1);
      oalpha_wsel             <= beta_cnt.val[0];

      // read at G/Comb functions
      obeta_raddr             <= cLAMBDA_OFFSET[used_lambda]    + (beta_cnt.val >> 1);
      obeta_rsel              <= beta_cnt.val[0];

      obeta_waddr             <= cLAMBDA_OFFSET[used_lambda_m1] +  beta_cnt.val;
      obeta_wsel              <= phi_srl[0];  // 1/2/3/4/5/6/7
    end
  end

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oalu_opcode <= cNOP;
    end
    else if (iclkena) begin
      oalu_opcode <= alu_opcode;
      // select F/G operation
      case (alu_opcode)               // 6/5/4/3/2/1/0
        cCALC_F4    : oalu_opcode <= phi_latch[cLSHIFT_INDEX[used_lambda]] ? cCALC_G4    : cCALC_F4;
        cCALC_F4LLR : oalu_opcode <= phi_latch[cLSHIFT_INDEX[used_lambda]] ? cCALC_G4LLR : cCALC_F4LLR;
      endcase
    end
  end

endmodule
