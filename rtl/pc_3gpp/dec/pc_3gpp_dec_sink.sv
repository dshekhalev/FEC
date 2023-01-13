/*



  parameter int pN_MAX    = 1024 ;
  parameter bit pUSE_CRC  =    1 ;
  parameter int pTAG_W    =    4 ;



  logic       pc_3gpp_dec_sink__iclk      ;
  logic       pc_3gpp_dec_sink__ireset    ;
  logic       pc_3gpp_dec_sink__iclkena   ;
  dlen_t      pc_3gpp_dec_sink__idlen     ;
  err_t       pc_3gpp_dec_sink__ierr      ;
  logic       pc_3gpp_dec_sink__ifull     ;
  logic       pc_3gpp_dec_sink__irdat     ;
  tag_t       pc_3gpp_dec_sink__irtag     ;
  logic       pc_3gpp_dec_sink__orempty   ;
  bit_addr_t  pc_3gpp_dec_sink__oraddr    ;
  logic       pc_3gpp_dec_sink__ireq      ;
  logic       pc_3gpp_dec_sink__ofull     ;
  logic       pc_3gpp_dec_sink__osop      ;
  logic       pc_3gpp_dec_sink__oval      ;
  logic       pc_3gpp_dec_sink__oeop      ;
  logic       pc_3gpp_dec_sink__odat      ;
  tag_t       pc_3gpp_dec_sink__otag      ;
  err_t       pc_3gpp_dec_sink__oerr      ;
  logic       pc_3gpp_dec_sink__ocrc_err  ;



  pc_3gpp_dec_sink
  #(
    .pN_MAX   ( pN_MAX   ) ,
    .pUSE_CRC ( pUSE_CRC ) ,
    .pTAG_W   ( pTAG_W   )
  )
  pc_3gpp_dec_sink
  (
    .iclk     ( pc_3gpp_dec_sink__iclk     ) ,
    .ireset   ( pc_3gpp_dec_sink__ireset   ) ,
    .iclkena  ( pc_3gpp_dec_sink__iclkena  ) ,
    .idlen    ( pc_3gpp_dec_sink__idlen    ) ,
    .ierr     ( pc_3gpp_dec_sink__ierr     ) ,
    .ifull    ( pc_3gpp_dec_sink__ifull    ) ,
    .irdat    ( pc_3gpp_dec_sink__irdat    ) ,
    .irtag    ( pc_3gpp_dec_sink__irtag    ) ,
    .orempty  ( pc_3gpp_dec_sink__orempty  ) ,
    .oraddr   ( pc_3gpp_dec_sink__oraddr   ) ,
    .ireq     ( pc_3gpp_dec_sink__ireq     ) ,
    .ofull    ( pc_3gpp_dec_sink__ofull    ) ,
    .osop     ( pc_3gpp_dec_sink__osop     ) ,
    .oval     ( pc_3gpp_dec_sink__oval     ) ,
    .oeop     ( pc_3gpp_dec_sink__oeop     ) ,
    .odat     ( pc_3gpp_dec_sink__odat     ) ,
    .otag     ( pc_3gpp_dec_sink__otag     ) ,
    .oerr     ( pc_3gpp_dec_sink__oerr     ) ,
    .ocrc_err ( pc_3gpp_dec_sink__ocrc_err )
  );


  assign pc_3gpp_dec_sink__iclk    = '0 ;
  assign pc_3gpp_dec_sink__ireset  = '0 ;
  assign pc_3gpp_dec_sink__iclkena = '0 ;
  assign pc_3gpp_dec_sink__idlen   = '0 ;
  assign pc_3gpp_dec_sink__ifull   = '0 ;
  assign pc_3gpp_dec_sink__irdat   = '0 ;
  assign pc_3gpp_dec_sink__irtag   = '0 ;
  assign pc_3gpp_dec_sink__ireq    = '0 ;



*/

//
// Project       : polar code 3gpp
// Author        : Shekhalev Denis (des00)
// Workfile      : pc_3gpp_dec_sink.sv
// Description   : Polar deoder sink module. Do output "handshake", info bits assemble, optional CRC check
//

`include "define.vh"

module pc_3gpp_dec_sink
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  idlen    ,
  ierr     ,
  //
  ifull    ,
  irdat    ,
  irtag    ,
  orempty  ,
  oraddr   ,
  //
  ireq     ,
  ofull    ,
  //
  osop     ,
  oval     ,
  oeop     ,
  odat     ,
  otag     ,
  //
  oerr     ,
  ocrc_err
);

  `include "pc_3gpp_dec_types.svh"

  parameter bit pUSE_CRC  = 0 ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic      iclk     ;
  input  logic      ireset   ;
  input  logic      iclkena  ;
  //
  input  dlen_t     idlen    ;
  input  err_t      ierr     ;
  //
  input  logic      ifull    ;
  input  logic      irdat    ;
  input  tag_t      irtag    ;
  output logic      orempty  ;
  output bit_addr_t oraddr   ;
  //
  input  logic      ireq     ;
  output logic      ofull    ;
  //
  output logic      osop     ;
  output logic      oval     ;
  output logic      oeop     ;
  output logic      odat     ;
  output tag_t      otag     ;
  //
  output err_t      oerr     ;
  output logic      ocrc_err ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  `include "../pc_3gpp_ts_38_212_tab.svh"

  localparam int cCNT_W = cNLOG2;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  enum bit [1 : 0] {
    cRESET_STATE ,
    cDO_STATE    ,
    cCRC_STATE   ,
    cDONE_STATE
  } state /* synthesis syn_encoding = "sequential" */;

  struct packed {
    logic                done;
    logic [cCNT_W-1 : 0] val;
  } cnt;

  bit_addr_t     dlen;
  bit_addr_t     raddr_la ; // look ahead read addres

  err_t          err;

  logic  [1 : 0] val;
  logic  [1 : 0] eop;

  logic  [1 : 0] set_sf; // set sop/full

  logic dat_val;
  logic crc_val;
  crc_t crc;
  crc_t crc_ref;

  //------------------------------------------------------------------------------------------------------
  // control FSM
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset) begin
      state <= cRESET_STATE;
    end
    else if (iclkena) begin
      case (state)
        cRESET_STATE : state <=  ifull            ? cDO_STATE                             : cRESET_STATE;
        cDO_STATE    : state <= (ireq & cnt.done) ? (pUSE_CRC ? cCRC_STATE : cDONE_STATE) : cDO_STATE;
        cCRC_STATE   : state <=         cnt.done  ? cDONE_STATE                           : cCRC_STATE;
        cDONE_STATE  : state <= cRESET_STATE;
      endcase
    end
  end

  always_ff @(posedge iclk or posedge ireset) begin
    if (ireset)
      orempty <= 1'b0;
    else if (iclkena)
      orempty <= pUSE_CRC ? (state == cCRC_STATE & cnt.done) : (state == cDO_STATE & ireq & cnt.done);
  end

  //------------------------------------------------------------------------------------------------------
  // read ram side
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (state == cRESET_STATE) begin
        cnt       <= '0;
        dlen      <= idlen;
        //
        oraddr    <= bits_addr_tab[0];
        raddr_la  <= 1'b1;
      end
      else if ((state == cDO_STATE & ireq) | (state == cCRC_STATE)) begin
        cnt.val   <= cnt.done ? '0 : (cnt.val + 1'b1);
        cnt.done  <= (state == cCRC_STATE) ? (cnt.val == (cCRC_W-2)) : (cnt.val == (dlen-2));
        //
        raddr_la  <= raddr_la + 1'b1;
        oraddr    <= bits_addr_tab[raddr_la];
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
      eop     <= '0;
      set_sf  <= '0;
      ofull   <= 1'b0;
      osop    <= 1'b0;
    end
    else if (iclkena) begin
      val     <= (val << 1) | (pUSE_CRC ? ((state == cDO_STATE & ireq & !cnt.done) | (state == cCRC_STATE & cnt.done)) : (state == cDO_STATE & ireq));
      eop     <= (eop << 1) | (pUSE_CRC ? (state == cCRC_STATE & cnt.done) : (state == cDO_STATE & ireq & cnt.done));
      //
      set_sf  <= (set_sf << 1) | start;
      //
      if (set_sf[1])
        ofull <= 1'b1;
      else if (orempty)
        ofull <= 1'b0;
      //
      if (set_sf[1])
        osop <= 1'b1;
      else if (oval)
        osop <= 1'b0;
    end
  end

  assign oval = val[1];
  assign oeop = eop[1];

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      dat_val <= (state == cDO_STATE & ireq);
      crc_val <= (state == cCRC_STATE);
    end
  end

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (start) begin
        otag  <= irtag;
        oerr  <= ierr;
      end
      // 1 tick output ram read latency
      if (dat_val) begin
        odat <= irdat;
      end
    end
  end

  //
  // crc checker
  always_ff @(posedge iclk) begin
    if (iclkena) begin
      // 1 tick output ram read latency
      if (pUSE_CRC) begin
        if (start) begin
          crc       <= '0;
          crc_ref   <= '0;
          ocrc_err  <= 1'b0;
        end
        else begin
          if (dat_val) begin
            crc <= get_crc(crc, irdat);
          end
          if (crc_val) begin
            crc_ref   <= {irdat, crc_ref[cCRC_W-1 : 1]};
            ocrc_err  <= (crc != {irdat, crc_ref[cCRC_W-1 : 1]}); // look ahead
          end
        end
      end
      else begin
        ocrc_err <= 1'b0;
      end
    end
  end

endmodule
