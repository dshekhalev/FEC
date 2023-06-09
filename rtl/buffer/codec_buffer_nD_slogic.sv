/*



  parameter int pBNUM_W = 1 ;



  logic                 codec_buffer_nD_slogic__iclk      ;
  logic                 codec_buffer_nD_slogic__ireset    ;
  logic                 codec_buffer_nD_slogic__iclkena   ;
  //
  logic                 codec_buffer_nD_slogic__iwfull    ;
  logic [pBNUM_W-1 : 0] codec_buffer_nD_slogic__ob_wused  ;
  //
  logic                 codec_buffer_nD_slogic__irempty   ;
  logic [pBNUM_W-1 : 0] codec_buffer_nD_slogic__ob_rused  ;
  //
  logic                 codec_buffer_nD_slogic__oempty    ;
  logic                 codec_buffer_nD_slogic__oemptya   ;
  logic                 codec_buffer_nD_slogic__ofull     ;
  logic                 codec_buffer_nD_slogic__ofulla    ;



  codec_buffer_nD_slogic
  #(
    .pBNUM_W ( pBNUM_W )
  )
  codec_buffer_nD_slogic
  (
    .iclk     ( codec_buffer_nD_slogic__iclk     ) ,
    .ireset   ( codec_buffer_nD_slogic__ireset   ) ,
    .iclkena  ( codec_buffer_nD_slogic__iclkena  ) ,
    //
    .iwfull   ( codec_buffer_nD_slogic__iwfull   ) ,
    .ob_wused ( codec_buffer_nD_slogic__ob_wused ) ,
    //
    .irempty  ( codec_buffer_nD_slogic__irempty  ) ,
    .ob_rused ( codec_buffer_nD_slogic__ob_rused ) ,
    //
    .oempty   ( codec_buffer_nD_slogic__oempty   ) ,
    .oemptya  ( codec_buffer_nD_slogic__oemptya  ) ,
    .ofull    ( codec_buffer_nD_slogic__ofull    ) ,
    .ofulla   ( codec_buffer_nD_slogic__ofulla   )
  );


  assign codec_buffer_nD_slogic__iclk    = '0 ;
  assign codec_buffer_nD_slogic__ireset  = '0 ;
  assign codec_buffer_nD_slogic__iclkena = '0 ;
  //
  assign codec_buffer_nD_slogic__iwfull  = '0 ;
  //
  assign codec_buffer_nD_slogic__irempty = '0 ;



*/

//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : codec_buffer_nD_slogic.sv
// Description   : Single clock multi buffering logic for RAM address pointers
//


module codec_buffer_nD_slogic
#(
  parameter int pBNUM_W = 1 // 2**pBNUM_W - number of buffers
)
(
  iclk     ,
  ireset   ,
  iclkena  ,
  //
  iwfull   ,
  ob_wused ,
  //
  irempty  ,
  ob_rused ,
  //
  oempty   ,
  oemptya  ,
  ofull    ,
  ofulla
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                 iclk      ;
  input  logic                 ireset    ;
  input  logic                 iclkena   ;
  //
  input  logic                 iwfull    ;
  output logic [pBNUM_W-1 : 0] ob_wused  ;  // bank used for write
  //
  input  logic                 irempty   ;
  output logic [pBNUM_W-1 : 0] ob_rused  ;  // bank used for read read
  //
  output logic                 oempty    ;  // any bank is empty
  output logic                 oemptya   ;  // all banks is empty
  output logic                 ofull     ;  // any bank is full
  output logic                 ofulla    ;  // all banks is full

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  localparam int cBNUM = 2**pBNUM_W;

  logic   [cBNUM-1 : 0] b_is_busy ; // bank busy
  logic [pBNUM_W-1 : 0] b_wused   ; // bank write used
  logic [pBNUM_W-1 : 0] b_rused   ; // bank read used

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk or posedge ireset) begin : flip_flop_logic
    if (ireset) begin
      b_is_busy <= '0;
      b_wused   <= '0;
      b_rused   <= '0;
    end
    else if (iclkena) begin
      for (int i = 0; i < cBNUM; i++) begin
        if (iwfull & (b_wused == i)) begin
          b_is_busy[i] <= 1'b1;
        end
        else if (irempty & (b_rused == i)) begin
          b_is_busy[i] <= 1'b0;
        end
      end
      // switch only if there is next empty bank or full bank is ready to empty
      if ((iwfull & irempty) | (iwfull & ~b_is_busy[b_wused + 1'b1]) | (irempty & b_is_busy[b_wused])) begin
        b_wused <= b_wused + 1'b1;
      end
      // switch only if there is next full bank
      if ((iwfull & irempty) | (irempty & b_is_busy[b_rused])) begin
        b_rused <= b_rused + 1'b1;
      end
    end
  end

  assign ob_wused = b_wused;
  assign ob_rused = b_rused;

  assign oempty   = |(~b_is_busy);
  assign oemptya  = &(~b_is_busy);

  assign ofull    = |b_is_busy;
  assign ofulla   = &b_is_busy;

endmodule

