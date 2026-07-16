/*



  parameter int pADDR_W   = 1 ;
  parameter int pDAT_W    = 2 ;
  parameter int pTAG_W    = 4 ;
  //
  parameter bit pDEC_MODE = 0 ;



  logic                     b_nb_ldpc_sink__iclk      ;
  logic                     b_nb_ldpc_sink__ireset    ;
  logic                     b_nb_ldpc_sink__iclkena   ;
  //
  code_idx_t                b_nb_ldpc_sink__icode_idx ;
  //
  logic                     b_nb_ldpc_sink__irfull    ;
  gf_data_t                 b_nb_ldpc_sink__irdat     ;
  logic      [pTAG_W-1 : 0] b_nb_ldpc_sink__irtag     ;
  logic                     b_nb_ldpc_sink__orempty   ;
  logic     [pADDR_W-1 : 0] b_nb_ldpc_sink__oraddr    ;
  //
  logic                     b_nb_ldpc_sink__ireq      ;
  logic                     b_nb_ldpc_sink__ofull     ;
  //
  logic                     b_nb_ldpc_sink__osop      ;
  logic                     b_nb_ldpc_sink__oeop      ;
  logic                     b_nb_ldpc_sink__oval      ;
  logic      [pDAT_W-1 : 0] b_nb_ldpc_sink__odat      ;
  logic      [pTAG_W-1 : 0] b_nb_ldpc_sink__otag      ;



  b_nb_ldpc_sink
  #(
    .pADDR_W   ( pADDR_W   ) ,
    .pDAT_W    ( pDAT_W    ) ,
    .pTAG_W    ( pTAG_W    ) ,
    //
    .pDEC_MODE ( pDEC_MODE )
  )
  b_nb_ldpc_sink
  (
    .iclk      ( b_nb_ldpc_sink__iclk      ) ,
    .ireset    ( b_nb_ldpc_sink__ireset    ) ,
    .iclkena   ( b_nb_ldpc_sink__iclkena   ) ,
    //
    .icode_idx ( b_nb_ldpc_sink__icode_idx ) ,
    //
    .irfull    ( b_nb_ldpc_sink__irfull    ) ,
    .irdat     ( b_nb_ldpc_sink__irdat     ) ,
    .irtag     ( b_nb_ldpc_sink__irtag     ) ,
    .orempty   ( b_nb_ldpc_sink__orempty   ) ,
    .oraddr    ( b_nb_ldpc_sink__oraddr    ) ,
    //
    .ireq      ( b_nb_ldpc_sink__ireq      ) ,
    .ofull     ( b_nb_ldpc_sink__ofull     ) ,
    //
    .osop      ( b_nb_ldpc_sink__osop      ) ,
    .oeop      ( b_nb_ldpc_sink__oeop      ) ,
    .oval      ( b_nb_ldpc_sink__oval      ) ,
    .odat      ( b_nb_ldpc_sink__odat      ) ,
    .otag      ( b_nb_ldpc_sink__otag      )
  );


  assign b_nb_ldpc_sink__iclk      = '0 ;
  assign b_nb_ldpc_sink__ireset    = '0 ;
  assign b_nb_ldpc_sink__iclkena   = '0 ;
  assign b_nb_ldpc_sink__icode_idx = '0 ;
  assign b_nb_ldpc_sink__irfull    = '0 ;
  assign b_nb_ldpc_sink__irdat     = '0 ;
  assign b_nb_ldpc_sink__irtag     = '0 ;
  assign b_nb_ldpc_sink__ireq      = '0 ;



*/

//
// Project       : BeiDou non binaray ldpc
// Author        : Shekhalev Denis (des00)
// Workfile      : b_nb_ldpc_sink.svh
// Description   : codec sink unit with DWC (6->1) option
//

module b_nb_ldpc_sink
#(
  parameter int pDAT_W    = 6 ,
  parameter int pADDR_W   = 8 ,
  parameter int pTAG_W    = 4 ,
  //
  parameter bit pDEC_MODE = 0   // encoder(0)/decoder(1) mode
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  icode_idx ,
  //
  irfull    ,
  irdat     ,
  irtag     ,
  orempty   ,
  oraddr    ,
  //
  ireq      ,
  ofull     ,
  //
  osop      ,
  oeop      ,
  oval      ,
  odat      ,
  otag
);

  `include "b_nb_ldpc_constants.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  // synthesis translate_off
  initial begin
    assert (pDAT_W inside {1, 6}) else begin
      $fatal("unsupported data width = %0d", pDAT_W);
    end
  end
  // synthesis translate_on

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                      iclk      ;
  input  logic                      ireset    ;
  input  logic                      iclkena   ;
  //
  input  code_idx_t                 icode_idx ;
  //
  input  logic                      irfull    ;
  input  gf_data_t                  irdat     ;
  input  logic       [pTAG_W-1 : 0] irtag     ;
  output logic                      orempty   ;
  output logic      [pADDR_W-1 : 0] oraddr    ;
  //
  input  logic                      ireq      ;
  output logic                      ofull     ;
  //
  output logic                      osop      ;
  output logic                      oeop      ;
  output logic                      oval      ;
  output logic       [pDAT_W-1 : 0] odat      ;
  output logic       [pTAG_W-1 : 0] otag      ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBCNT_MAX = 6;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit {
    cRESET_STATE,
    cDO_STATE
  } state;

  struct packed {
    logic done;
    col_t value;
  } wcnt;

  struct packed {
    logic         zero;
    logic         done;
    logic [2 : 0] value;
  } bcnt;

  logic [2 : 0] val;
  logic [2 : 0] eop;

  logic [1 : 0] set_sf; // set sop/full

  //------------------------------------------------------------------------------------------------------
  // FSM
  //------------------------------------------------------------------------------------------------------

  wire done  = wcnt.done & bcnt.done;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=  irfull       ? cDO_STATE    : cRESET_STATE;
        cDO_STATE    : state <= (ireq & done) ? cRESET_STATE : cDO_STATE;
      endcase
    end
  end

  assign orempty = (state == cDO_STATE & ireq & done);

  //------------------------------------------------------------------------------------------------------
  // counters
  //------------------------------------------------------------------------------------------------------

  generate
    if (pDAT_W == 1) begin : bit_cnt_logic
      always_ff @(posedge iclk) begin
        if (iclkena) begin
          if (state == cRESET_STATE) begin
            bcnt      <= '0;
            bcnt.zero <= 1'b1;
          end
          else if (state == cDO_STATE & ireq) begin
            bcnt.value <=  bcnt.done ? '0 : (bcnt.value + 1'b1);
            bcnt.done  <= (bcnt.value == (cBCNT_MAX-2));
            bcnt.zero  <= bcnt.done;
          end
        end
      end
    end
    else begin
      assign bcnt.zero = 1'b1;
      assign bcnt.done = 1'b1;
    end
  endgenerate

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        wcnt <= '0;
      end
      else if (state == cDO_STATE & ireq) begin
        if (bcnt.done) begin
          wcnt.value <=  wcnt.done ? '0 : (wcnt.value + 1'b1);
          //
          if (pDEC_MODE) begin
            wcnt.done <= (wcnt.value == (cROW_TAB[icode_idx] - 2));
          end
          else begin
            wcnt.done <= (wcnt.value == (cCOL_TAB[icode_idx] - 2));
          end
        end
      end
    end
  end

  assign oraddr = wcnt.value[pADDR_W-1 : 0];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  wire start = (state == cRESET_STATE & irfull);

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val     <= '0;
      set_sf  <= '0;
      //
      ofull   <= 1'b0;
      osop    <= 1'b0;
    end
    else if (iclkena) begin
      val     <= (val     << 1) | (state == cDO_STATE & ireq & bcnt.zero);
      //
      set_sf  <= (set_sf  << 1) | start;
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

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      eop <= (eop << 1) | (state == cDO_STATE & done);
      //
      if (start) begin
        otag <= irtag;
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // data logic
  //------------------------------------------------------------------------------------------------------

  generate
    if (pDAT_W == 6) begin : dat6_logic
      assign oval = val[2];

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          odat <= irdat;
        end
      end

      assign oeop = eop[2];
    end
    else begin : dwc_logic
      gf_data_t val2out;
      gf_data_t dat2out;

      always_ff @(posedge iclk) begin
        if (iclkena) begin
          val2out <= val[1] ? '1    : (val2out << 1);
          dat2out <= val[1] ? irdat : (dat2out << 1); // msb first
        end
      end

      assign oval = val2out[$high(val2out)];
      assign odat = dat2out[$high(dat2out)];

      assign oeop = eop[2];

    end
  endgenerate

endmodule
