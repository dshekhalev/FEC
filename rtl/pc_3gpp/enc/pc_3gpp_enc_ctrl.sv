/*



  parameter int pN_MAX  = 1024 ;
  parameter int pWORD_W =    8 ;



  logic         pc_3gpp_enc_ctrl__iclk                ;
  logic         pc_3gpp_enc_ctrl__ireset              ;
  logic         pc_3gpp_enc_ctrl__iclkena             ;
  logic         pc_3gpp_enc_ctrl__isource_ram_full    ;
  logic         pc_3gpp_enc_ctrl__osource_ram_rempty  ;
  beta_w_addr_t pc_3gpp_enc_ctrl__osource_ram_raddr   ;
  logic         pc_3gpp_enc_ctrl__isink_ram_empty     ;
  logic         pc_3gpp_enc_ctrl__osink_ram_wfull     ;
  beta_w_addr_t pc_3gpp_enc_ctrl__obeta_raddr         ;
  logic         pc_3gpp_enc_ctrl__obeta_rsel          ;
  beta_w_addr_t pc_3gpp_enc_ctrl__obeta_waddr         ;
  logic         pc_3gpp_enc_ctrl__obeta_wsel          ;
  alu_opcode_t  pc_3gpp_enc_ctrl__oalu_opcode         ;
  logic         pc_3gpp_enc_ctrl__obusy               ;



  pc_3gpp_enc_ctrl
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pWORD_W ( pWORD_W )
  )
  pc_3gpp_enc_ctrl
  (
    .iclk               ( pc_3gpp_enc_ctrl__iclk               ) ,
    .ireset             ( pc_3gpp_enc_ctrl__ireset             ) ,
    .iclkena            ( pc_3gpp_enc_ctrl__iclkena            ) ,
    .isource_ram_full   ( pc_3gpp_enc_ctrl__isource_ram_full   ) ,
    .osource_ram_rempty ( pc_3gpp_enc_ctrl__osource_ram_rempty ) ,
    .osource_ram_raddr  ( pc_3gpp_enc_ctrl__osource_ram_raddr  ) ,
    .isink_ram_empty    ( pc_3gpp_enc_ctrl__isink_ram_empty    ) ,
    .osink_ram_wfull    ( pc_3gpp_enc_ctrl__osink_ram_wfull    ) ,
    .obeta_raddr        ( pc_3gpp_enc_ctrl__obeta_raddr        ) ,
    .obeta_rsel         ( pc_3gpp_enc_ctrl__obeta_rsel         ) ,
    .obeta_waddr        ( pc_3gpp_enc_ctrl__obeta_waddr        ) ,
    .obeta_wsel         ( pc_3gpp_enc_ctrl__obeta_wsel         ) ,
    .oalu_opcode        ( pc_3gpp_enc_ctrl__oalu_opcode        ) ,
    .obusy              ( pc_3gpp_enc_ctrl__obusy              )
  );


  assign pc_3gpp_enc_ctrl__iclk             = '0 ;
  assign pc_3gpp_enc_ctrl__ireset           = '0 ;
  assign pc_3gpp_enc_ctrl__iclkena          = '0 ;
  assign pc_3gpp_enc_ctrl__isource_ram_full = '0 ;
  assign pc_3gpp_enc_ctrl__isink_ram_empty  = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_enc_ctrl.sv
// Description   : Recursive polar encoder controler.
//


module pc_3gpp_enc_ctrl
(
  iclk               ,
  ireset             ,
  iclkena            ,
  //
  isource_ram_full   ,
  osource_ram_rempty ,
  osource_ram_raddr  ,
  //
  isink_ram_empty    ,
  osink_ram_wfull    ,
  //
  obeta_raddr        ,
  obeta_rsel         ,
  obeta_waddr        ,
  obeta_wsel         ,
  oalu_opcode        ,
  //
  obusy
);

  `include "pc_3gpp_enc_types.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic         iclk               ;
  input  logic         ireset             ;
  input  logic         iclkena            ;
  //
  input  logic         isource_ram_full   ;
  output logic         osource_ram_rempty ;
  output beta_w_addr_t osource_ram_raddr  ;
  //
  input  logic         isink_ram_empty    ;
  output logic         osink_ram_wfull    ;
  //
  output beta_w_addr_t obeta_raddr        ;
  output logic         obeta_rsel         ;
  output beta_w_addr_t obeta_waddr        ;
  output logic         obeta_wsel         ;
  output alu_opcode_t  oalu_opcode        ;
  //
  output logic         obusy              ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cLAMBDA_OFFSET [8] = '{0,   64, 32, 16, 8, 4, 2, 1};
  localparam int cBETA_MAX      [8] = '{126, 62, 30, 14, 6, 2, 0, 0};  //  cLAMBDA_OFFSET - 2

  localparam int cPHI_MAX     = pN_MAX/pWORD_W;
  localparam int cPHI_CNT_W   = $clog2(cPHI_MAX);

  localparam int cBETA_CNT_W  = $clog2(cPHI_MAX);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // FSM
  logic  [3 : 0] state__br    ;
  logic [14 : 0] state__out   ;
  logic [14 : 0] state__out_r ;

  //
  logic phi_clear;
  logic phi_incr;

  struct packed {
    logic                    done;
    logic [cPHI_CNT_W-1 : 0] val;
  } phi_cnt;

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
  logic [2 : 0] alu_opcode;

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  pc_3gpp_enc_ctrl_state
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

  assign state__br[3] = phi_srl[1];

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

  assign alu_opcode         = state__out[14 : 12];

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
        phi_srl <= phi_cnt.val;
      end
      else if (beta_clear | (beta_incr & beta_cnt.done)) begin
        phi_srl <= (phi_srl >> 1);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // source data/beta ram access
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      osource_ram_raddr <= phi_cnt.val;
      //
      obeta_raddr       <= cLAMBDA_OFFSET[used_lambda] + (beta_cnt.val >> 1);
      obeta_rsel        <= beta_cnt.val[0];

      obeta_waddr       <= cLAMBDA_OFFSET[used_lambda_m1] + beta_cnt.val;
      obeta_wsel        <= phi_srl[1];
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
    end
  end

endmodule
