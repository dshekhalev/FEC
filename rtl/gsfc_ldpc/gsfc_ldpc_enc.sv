/*



  parameter int pDAT_W  = 7 ;
  parameter     pTAG_W  = 1 ;



  logic                gsfc_ldpc_enc__iclk     ;
  logic                gsfc_ldpc_enc__ireset   ;
  logic                gsfc_ldpc_enc__iclkena  ;
  logic                gsfc_ldpc_enc__isop     ;
  logic                gsfc_ldpc_enc__ieop     ;
  logic                gsfc_ldpc_enc__ieof     ;
  logic                gsfc_ldpc_enc__ival     ;
  logic [pTAG_W-1 : 0] gsfc_ldpc_enc__itag     ;
  logic [pDAT_W-1 : 0] gsfc_ldpc_enc__idat     ;
  logic                gsfc_ldpc_enc__obusy    ;
  logic                gsfc_ldpc_enc__ordy     ;
  logic                gsfc_ldpc_enc__osop     ;
  logic                gsfc_ldpc_enc__oeop     ;
  logic                gsfc_ldpc_enc__oeof     ;
  logic                gsfc_ldpc_enc__oval     ;
  logic [pTAG_W-1 : 0] gsfc_ldpc_enc__otag     ;
  logic [pDAT_W-1 : 0] gsfc_ldpc_enc__odat     ;



  gsfc_ldpc_enc
  #(
    .pDAT_W ( pDAT_W ) ,
    .pTAG_W ( pTAG_W )
  )
  gsfc_ldpc_enc
  (
    .iclk    ( gsfc_ldpc_enc__iclk    ) ,
    .ireset  ( gsfc_ldpc_enc__ireset  ) ,
    .iclkena ( gsfc_ldpc_enc__iclkena ) ,
    .isop    ( gsfc_ldpc_enc__isop    ) ,
    .ieop    ( gsfc_ldpc_enc__ieop    ) ,
    .ieof    ( gsfc_ldpc_enc__ieof    ) ,
    .ival    ( gsfc_ldpc_enc__ival    ) ,
    .itag    ( gsfc_ldpc_enc__itag    ) ,
    .idat    ( gsfc_ldpc_enc__idat    ) ,
    .obusy   ( gsfc_ldpc_enc__obusy   ) ,
    .ordy    ( gsfc_ldpc_enc__ordy    ) ,
    .osop    ( gsfc_ldpc_enc__osop    ) ,
    .oeop    ( gsfc_ldpc_enc__oeop    ) ,
    .oeof    ( gsfc_ldpc_enc__oeof    ) ,
    .oval    ( gsfc_ldpc_enc__oval    ) ,
    .otag    ( gsfc_ldpc_enc__otag    ) ,
    .odat    ( gsfc_ldpc_enc__odat    )
  );


  assign gsfc_ldpc_enc__iclk    = '0 ;
  assign gsfc_ldpc_enc__ireset  = '0 ;
  assign gsfc_ldpc_enc__iclkena = '0 ;
  assign gsfc_ldpc_enc__isop    = '0 ;
  assign gsfc_ldpc_enc__ieop    = '0 ;
  assign gsfc_ldpc_enc__ieof    = '0 ;
  assign gsfc_ldpc_enc__ival    = '0 ;
  assign gsfc_ldpc_enc__itag    = '0 ;
  assign gsfc_ldpc_enc__idat    = '0 ;



*/


//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_enc.sv
// Description   : LDPC encoder with fixed encoding parameters and variable word length 1/7/73/511.
//


module gsfc_ldpc_enc
#(
  parameter int pDAT_W  = 7 ,
  parameter int pTAG_W  = 1
)
(
  iclk    ,
  ireset  ,
  iclkena ,
  //
  isop    ,
  ieop    ,
  ieof    ,
  ival    ,
  itag    ,
  idat    ,
  //
  obusy   ,
  ordy    ,
  //
  osop    ,
  oeop    ,
  oeof    ,
  oval    ,
  otag    ,
  odat
);

  `include "gsfc_ldpc_parameters.svh"

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk    ;
  input  logic                ireset  ;
  input  logic                iclkena ;
  //
  input  logic                isop    ;
  input  logic                ieop    ;
  input  logic                ieof    ;
  input  logic                ival    ;
  input  logic [pTAG_W-1 : 0] itag    ;
  input  logic [pDAT_W-1 : 0] idat    ;
  //
  output logic                obusy   ;
  output logic                ordy    ;
  //
  output logic                osop    ;
  output logic                oeop    ;
  output logic                oeof    ;
  output logic                oval    ;
  output logic [pTAG_W-1 : 0] otag    ;
  output logic [pDAT_W-1 : 0] odat    ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cNBITS   = cLDPC_DNUM;
  localparam int cNWORDS  = cNBITS/pDAT_W;
  localparam int cNMOD    = pZF/pDAT_W;

  localparam int cNMOD_W  = $clog2(cNMOD);

  localparam int cPBITS   = cLDPC_NUM - cLDPC_DNUM;
  localparam int cPWORDS  = cPBITS/pDAT_W;

  typedef bit [pZF-1 : 0] dat_t;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  logic                val;
  logic                sop;
  logic                eop;
  logic                eof;
  logic [pDAT_W-1 : 0] dat;
  logic [pTAG_W-1 : 0] tag;

  struct packed {
    logic [cNMOD_W-1 : 0] val;
    logic                 done;
  } midx;

  enum bit {
    cDATA_STATE,
    cPARITY_STATE
  } state;

  //
  // fbsrl unitns
  logic                fbsrl__iload               ;
  logic        [3 : 0] fbsrl__iload_idx           ;
  logic                fbsrl__ishift              ;
  logic [pDAT_W-1 : 0] fbsrl__obdat     [pC][pZF] ;

  logic                val2enc;
  logic                sop2enc;
  logic                eop2enc;
  logic                eof2enc;
  logic [pDAT_W-1 : 0] dat2enc;
  logic [pTAG_W-1 : 0] tag2enc;

  dat_t pbits [pC];

  //------------------------------------------------------------------------------------------------------
  // data parsing
  //------------------------------------------------------------------------------------------------------

  assign obusy = 1'b0;
  assign ordy  = 1'b1;

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val <= 1'b0;
    end
    else if (iclkena) begin
      val <= ival;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop <= isop;
      eop <= ieop;
      eof <= ieof;
      dat <= idat;
      tag <= itag;
      //
      fbsrl__iload  <= ival & (isop | midx.done);
      fbsrl__ishift <= ival;
      //
      if (ival) begin
        midx.val          <= (isop | midx.done) ? 1'b0 : (midx.val + 1'b1);
        midx.done         <= isop ? 1'b0  : (midx.val == cNMOD-2);
        fbsrl__iload_idx  <= isop ? '0    : (fbsrl__iload_idx + midx.done);
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // pattern FBSRL generator's
  //------------------------------------------------------------------------------------------------------

  generate
    genvar i;
    for (i = 0; i < pC; i++) begin : fbsrl_inst_gen
      gsfc_ldpc_enc_fbsrl
      #(
        .pDAT_W ( pDAT_W ) ,
        .pIDX   ( i      )
      )
      fbsrl
      (
        .iclk      ( iclk             ) ,
        .ireset    ( ireset           ) ,
        .iclkena   ( iclkena          ) ,
        //
        .iload     ( fbsrl__iload     ) ,
        .iload_idx ( fbsrl__iload_idx ) ,
        .ishift    ( fbsrl__ishift    ) ,
        //
        .obdat     ( fbsrl__obdat [i] )
      );
    end
  endgenerate

  //------------------------------------------------------------------------------------------------------
  // align FBSRL delay
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      val2enc <= 1'b0;
    end
    else if (iclkena) begin
      val2enc <= val;
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      sop2enc <= sop;
      eop2enc <= eop;
      eof2enc <= eof;
      dat2enc <= dat;
      tag2enc <= tag;
    end
  end

  //------------------------------------------------------------------------------------------------------
  // encoding engine
  //------------------------------------------------------------------------------------------------------

  always @(posedge iclk) begin
    if (iclkena) begin
      if (val2enc) begin
        if (sop2enc) begin
          state <= cDATA_STATE;
        end
        else if (eop2enc) begin
          state <= cPARITY_STATE;
        end
      end
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (val2enc) begin
        if (sop2enc | (state == cDATA_STATE)) begin
          for (int c = 0; c < pC; c++) begin
            for (int z = 0; z < pZF; z++) begin
              pbits[c][z] <= (sop2enc ? 1'b0 : pbits[c][z]) ^ (^(dat2enc & fbsrl__obdat[c][z]));
            end // j
          end // i
        end
        else begin // state == cPARITY_STATE
          {pbits[1], pbits[0]} <= {{pDAT_W{1'b0}}, pbits[1], pbits[0][pZF-1 : pDAT_W]}; // rigth shift
        end
      end// val2enc
    end // iclkena
  end

  //------------------------------------------------------------------------------------------------------
  // output maping
  //------------------------------------------------------------------------------------------------------

  always @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      oval  <= 1'b0;
    end
    else if (iclkena) begin
      oval  <= val2enc;
    end
  end

  always @(posedge iclk) begin
    if (iclkena) begin
      if (val2enc) begin
        osop <= sop2enc;
        oeop <= eop2enc;
        oeof <= eof2enc;
        odat <= (sop2enc | state == cDATA_STATE) ? dat2enc : pbits[0][pDAT_W-1 : 0];
        otag <= tag2enc;
      end
    end
  end

endmodule
