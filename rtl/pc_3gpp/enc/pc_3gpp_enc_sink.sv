/*



  parameter int pN_MAX  = 1024 ;
  parameter int pADDR_W =    8 ;
  parameter int pDAT_W  =    1 ;
  parameter int pTAG_W  =    4 ;



  logic                 pc_3gpp_enc_sink__iclk     ;
  logic                 pc_3gpp_enc_sink__ireset   ;
  logic                 pc_3gpp_enc_sink__iclkena  ;
  logic                 pc_3gpp_enc_sink__ifull    ;
  logic  [pDAT_W-1 : 0] pc_3gpp_enc_sink__irdat    ;
  tag_t                 pc_3gpp_enc_sink__irtag    ;
  logic                 pc_3gpp_enc_sink__orempty  ;
  logic [pADDR_W-1 : 0] pc_3gpp_enc_sink__oraddr   ;
  logic                 pc_3gpp_enc_sink__ireq     ;
  logic                 pc_3gpp_enc_sink__ofull    ;
  logic                 pc_3gpp_enc_sink__osop     ;
  logic                 pc_3gpp_enc_sink__oval     ;
  logic                 pc_3gpp_enc_sink__oeop     ;
  logic  [pDAT_W-1 : 0] pc_3gpp_enc_sink__odat     ;
  tag_t                 pc_3gpp_enc_sink__otag     ;



  pc_3gpp_enc_sink
  #(
    .pN_MAX  ( pN_MAX  ) ,
    .pADDR_W ( pADDR_W ) ,
    .pDAT_W  ( pDAT_W  ) ,
    .pTAG_W  ( pTAG_W  )
  )
  pc_3gpp_enc_sink
  (
    .iclk    ( pc_3gpp_enc_sink__iclk    ) ,
    .ireset  ( pc_3gpp_enc_sink__ireset  ) ,
    .iclkena ( pc_3gpp_enc_sink__iclkena ) ,
    .ifull   ( pc_3gpp_enc_sink__ifull   ) ,
    .irdat   ( pc_3gpp_enc_sink__irdat   ) ,
    .irtag   ( pc_3gpp_enc_sink__irtag   ) ,
    .orempty ( pc_3gpp_enc_sink__orempty ) ,
    .oraddr  ( pc_3gpp_enc_sink__oraddr  ) ,
    .ireq    ( pc_3gpp_enc_sink__ireq    ) ,
    .ofull   ( pc_3gpp_enc_sink__ofull   ) ,
    .osop    ( pc_3gpp_enc_sink__osop    ) ,
    .oval    ( pc_3gpp_enc_sink__oval    ) ,
    .oeop    ( pc_3gpp_enc_sink__oeop    ) ,
    .odat    ( pc_3gpp_enc_sink__odat    ) ,
    .otag    ( pc_3gpp_enc_sink__otag    )
  );


  assign pc_3gpp_enc_sink__iclk    = '0 ;
  assign pc_3gpp_enc_sink__ireset  = '0 ;
  assign pc_3gpp_enc_sink__iclkena = '0 ;
  assign pc_3gpp_enc_sink__ifull   = '0 ;
  assign pc_3gpp_enc_sink__irdat   = '0 ;
  assign pc_3gpp_enc_sink__irtag   = '0 ;
  assign pc_3gpp_enc_sink__ireq    = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_enc_sink.sv
// Description   : Encoder sink unit. Do output encoder synchronization & output encoded frame.
//


module pc_3gpp_enc_sink
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  ifull   ,
  irdat   ,
  irtag   ,
  orempty ,
  oraddr  ,
  //
  ireq    ,
  ofull   ,
  //
  osop    ,
  oval    ,
  oeop    ,
  odat    ,
  otag
);

  `include "pc_3gpp_enc_types.svh"

  parameter int pADDR_W = 8;
  parameter int pDAT_W  = 1;  // pDAT_W must be multiple of pWORD_W

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk     ;
  input  logic                 ireset   ;
  input  logic                 iclkena  ;
  //
  input  logic                 ifull    ;
  input  logic  [pDAT_W-1 : 0] irdat    ;
  input  tag_t                 irtag    ;
  output logic                 orempty  ;
  output logic [pADDR_W-1 : 0] oraddr   ;
  //
  input  logic                 ireq     ;
  output logic                 ofull    ;
  //
  output logic                 osop     ;
  output logic                 oval     ;
  output logic                 oeop     ;
  output logic  [pDAT_W-1 : 0] odat     ;
  output tag_t                 otag     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cCNT_MAX = 2**pADDR_W;
  localparam int cCNT_W   = pADDR_W;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE ,
    cDO_STATE
  } state ;

  struct packed {
    logic                done;
    logic [cCNT_W-1 : 0] val;
  } cnt;

  logic        [1 : 0] val;
  logic        [1 : 0] eop;

  logic        [1 : 0] set_sf; // set sop/full

  //------------------------------------------------------------------------------------------------------
  // control FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=  ifull            ? cDO_STATE    : cRESET_STATE;
        cDO_STATE    : state <= (ireq & cnt.done) ? cRESET_STATE : cDO_STATE;
      endcase
    end
  end

  assign orempty = (state == cDO_STATE) & ireq & cnt.done;

  //------------------------------------------------------------------------------------------------------
  // read ram side
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        cnt     <= '0;
        oraddr  <= '0;
      end
      else if (state == cDO_STATE & ireq) begin
        cnt.val   <=  cnt.val + 1'b1;
        cnt.done  <= (cnt.val == (cCNT_MAX-2));
        //
        oraddr <= oraddr + 1'b1;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // ram read latency is 2 tick
  //------------------------------------------------------------------------------------------------------

  wire start = (state == cRESET_STATE & ifull);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val     <= '0;
      set_sf  <= '0;
      ofull   <= 1'b0;
      osop    <= 1'b0;
    end
    else if (iclkena) begin
      val <= (val << 1) | (state == cDO_STATE & ireq);
      //
      set_sf <= (set_sf << 1) | start;
      //
      if (set_sf[1]) begin
        ofull <= 1'b1;
      end
      else if (orempty) begin
        ofull <= 1'b0;
      end
      //
      if (set_sf[1]) begin
        osop <= 1'b1;
      end
      else if (oval) begin
        osop <= 1'b0;
      end
    end
  end

  assign oval = val[1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      eop <= (eop << 1) | ((state == cDO_STATE) &  cnt.done);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start) begin
        otag  <= irtag;
      end
      // 1 tick output ram read latency
      odat    <= irdat;
    end
  end

  assign oeop = eop[1];

endmodule
