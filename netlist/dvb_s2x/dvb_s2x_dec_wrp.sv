/*



  logic          dvb_s2x_dec_wrp__iclk               ;
  logic          dvb_s2x_dec_wrp__ireset             ;
  //
  logic          dvb_s2x_dec_wrp__s_axis_aclk        ;
  logic          dvb_s2x_dec_wrp__s_axis_aresetn     ;
  logic          dvb_s2x_dec_wrp__s_axis_tvalid      ;
  logic [31 : 0] dvb_s2x_dec_wrp__s_axis_tdata       ;
  logic          dvb_s2x_dec_wrp__s_axis_tlast       ;
  //
  logic  [7 : 0] dvb_s2x_dec_wrp__s_axis_tid         ;
  logic  [3 : 0] dvb_s2x_dec_wrp__s_axis_tdest       ;
  logic [17 : 0] dvb_s2x_dec_wrp__s_axis_tuser       ;
  logic          dvb_s2x_dec_wrp__s_axis_tready      ;
  //
  logic          dvb_s2x_dec_wrp__m_axis_aclk        ;
  logic          dvb_s2x_dec_wrp__m_axis_aresetn     ;
  logic          dvb_s2x_dec_wrp__m_axis_tready      ;
  logic          dvb_s2x_dec_wrp__m_axis_tvalid      ;
  logic  [7 : 0] dvb_s2x_dec_wrp__m_axis_tdata       ;
  logic          dvb_s2x_dec_wrp__m_axis_tlast       ;
  //
  logic  [7 : 0] dvb_s2x_dec_wrp__m_axis_tid         ;
  logic  [3 : 0] dvb_s2x_dec_wrp__m_axis_tdest       ;
  logic [17 : 0] dvb_s2x_dec_wrp__m_axis_tuser       ;
  //
  logic          dvb_s2x_dec_wrp__obusy              ;
  //
  logic          dvb_s2x_dec_wrp__oframe_in_done     ;
  logic [15 : 0] dvb_s2x_dec_wrp__oframe_in_bitnum   ;
  logic          dvb_s2x_dec_wrp__oframe_in_error    ;
  logic          dvb_s2x_dec_wrp__oframe_in_overflow ;
  //
  logic          dvb_s2x_dec_wrp__oframe_out_done    ;
  logic [15 : 0] dvb_s2x_dec_wrp__oframe_out_bitnum  ;
  //
  logic [15 : 0] dvb_s2x_dec_wrp__oldpc_biterr       ;
  logic          dvb_s2x_dec_wrp__oldpc_decfail      ;
  logic  [7 : 0] dvb_s2x_dec_wrp__oldpc_used_niter   ;
  //
  logic  [3 : 0] dvb_s2x_dec_wrp__obch_biterr        ;
  logic          dvb_s2x_dec_wrp__obch_decfail       ;



  dvb_s2x_dec_wrp
  dvb_s2x_dec_wrp
  (
    .iclk               ( dvb_s2x_dec_wrp__iclk               ) ,
    .ireset             ( dvb_s2x_dec_wrp__ireset             ) ,
    //
    .s_axis_aclk        ( dvb_s2x_dec_wrp__s_axis_aclk        ) ,
    .s_axis_aresetn     ( dvb_s2x_dec_wrp__s_axis_aresetn     ) ,
    .s_axis_tvalid      ( dvb_s2x_dec_wrp__s_axis_tvalid      ) ,
    .s_axis_tdata       ( dvb_s2x_dec_wrp__s_axis_tdata       ) ,
    .s_axis_tlast       ( dvb_s2x_dec_wrp__s_axis_tlast       ) ,
    //
    .s_axis_tid         ( dvb_s2x_dec_wrp__s_axis_tid         ) ,
    .s_axis_tdest       ( dvb_s2x_dec_wrp__s_axis_tdest       ) ,
    .s_axis_tuser       ( dvb_s2x_dec_wrp__s_axis_tuser       ) ,
    .s_axis_tready      ( dvb_s2x_dec_wrp__s_axis_tready      ) ,
    //
    .m_axis_aclk        ( dvb_s2x_dec_wrp__m_axis_aclk        ) ,
    .m_axis_aresetn     ( dvb_s2x_dec_wrp__m_axis_aresetn     ) ,
    .m_axis_tready      ( dvb_s2x_dec_wrp__m_axis_tready      ) ,
    .m_axis_tvalid      ( dvb_s2x_dec_wrp__m_axis_tvalid      ) ,
    .m_axis_tdata       ( dvb_s2x_dec_wrp__m_axis_tdata       ) ,
    .m_axis_tlast       ( dvb_s2x_dec_wrp__m_axis_tlast       ) ,
    //
    .m_axis_tid         ( dvb_s2x_dec_wrp__m_axis_tid         ) ,
    .m_axis_tdest       ( dvb_s2x_dec_wrp__m_axis_tdest       ) ,
    .m_axis_tuser       ( dvb_s2x_dec_wrp__m_axis_tuser       ) ,
    //
    .obusy              ( dvb_s2x_dec_wrp__obusy              ) ,
    //
    .oframe_in_done     ( dvb_s2x_dec_wrp__oframe_in_done     ) ,
    .oframe_in_bitnum   ( dvb_s2x_dec_wrp__oframe_in_bitnum   ) ,
    .oframe_in_error    ( dvb_s2x_dec_wrp__oframe_in_error    ) ,
    .oframe_in_overflow ( dvb_s2x_dec_wrp__oframe_in_overflow ) ,
    //
    .oframe_out_done    ( dvb_s2x_dec_wrp__oframe_out_done    ) ,
    .oframe_out_bitnum  ( dvb_s2x_dec_wrp__oframe_out_bitnum  ) ,
    //
    .oldpc_biterr       ( dvb_s2x_dec_wrp__oldpc_biterr       ) ,
    .oldpc_decfail      ( dvb_s2x_dec_wrp__oldpc_decfail      ) ,
    .oldpc_used_niter   ( dvb_s2x_dec_wrp__oldpc_used_niter   ) ,
    //
    .obch_biterr        ( dvb_s2x_dec_wrp__obch_biterr        ) ,
    .obch_decfail       ( dvb_s2x_dec_wrp__obch_decfail       )
  );


  assign dvb_s2x_dec_wrp__iclk           = '0 ;
  assign dvb_s2x_dec_wrp__ireset         = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_aclk    = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_aresetn = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_tvalid  = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_tdata   = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_tstrb   = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_tid     = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_tdest   = '0 ;
  assign dvb_s2x_dec_wrp__s_axis_tuser   = '0 ;
  assign dvb_s2x_dec_wrp__m_axis_aclk    = '0 ;
  assign dvb_s2x_dec_wrp__m_axis_aresetn = '0 ;
  assign dvb_s2x_dec_wrp__m_axis_tready  = '0 ;



*/

//
// Project       : DVB-S2
// Author        : Shekhalev Denis (des00)
// Workfile      : dvb_s2x_dec_wrp.sv
// Description   : DVB-S2 decoder wrapper with axi-stream interfaces for
//                 Support only :
//                  QPSK/8PSK (simple demapper) short frame DVB-S2
//                    acm code = '{6,10,14,18,22,26,30,34,38,42,50,54,58,62,66} + 0/1
//                  DVB-S2X VL-SNR only
//                    acm_code = '{257,258,259,260,261, // VL-SNR set 1 {1, 2, 3, 4, 5} (BPSK only)
//                                265,266,267}          // VL-SNR set 2 {9, 10, 11}
//

module dvb_s2x_dec_wrp
(
  iclk               ,
  ireset             ,
  //
  s_axis_aclk        ,
  s_axis_aresetn     ,
  s_axis_tvalid      ,
  s_axis_tdata       ,
  s_axis_tlast       ,
  //
  s_axis_tid         ,
  s_axis_tdest       ,
  s_axis_tuser       ,
  s_axis_tready      ,
  //
  m_axis_aclk        ,
  m_axis_aresetn     ,
  m_axis_tready      ,
  m_axis_tvalid      ,
  m_axis_tdata       ,
  m_axis_tlast       ,
  //
  m_axis_tid         ,
  m_axis_tdest       ,
  m_axis_tuser       ,
  //
  obusy              ,
  //
  oframe_in_done     ,
  oframe_in_bitnum   ,
  oframe_in_error    ,
  oframe_in_overflow ,
  //
  oframe_out_done    ,
  oframe_out_bitnum  ,
  //
  oldpc_biterr       ,
  oldpc_decfail      ,
  oldpc_used_niter   ,
  //
  obch_biterr        ,
  obch_decfail
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk               ;  // LDPC core clock
  input  logic          ireset             ;
  //
  input  logic          s_axis_aclk        ;
  input  logic          s_axis_aresetn     ;
  input  logic          s_axis_tvalid      ;
  input  logic [31 : 0] s_axis_tdata       ;
  input  logic          s_axis_tlast       ;
  //
  input  logic  [7 : 0] s_axis_tid         ;
  input  logic  [3 : 0] s_axis_tdest       ;
  input  logic [17 : 0] s_axis_tuser       ;
  output logic          s_axis_tready      ;
  //
  input  logic          m_axis_aclk        ;
  input  logic          m_axis_aresetn     ;
  input  logic          m_axis_tready      ;
  output logic          m_axis_tvalid      ;
  output logic  [7 : 0] m_axis_tdata       ;
  output logic          m_axis_tlast       ;
  //
  output logic  [7 : 0] m_axis_tid         ;
  output logic  [3 : 0] m_axis_tdest       ;
  output logic  [8 : 0] m_axis_tuser       ;
  //
  output logic          obusy              ;
  //
  output logic          oframe_in_done     ;
  output logic [15 : 0] oframe_in_bitnum   ;
  output logic          oframe_in_error    ;
  output logic          oframe_in_overflow ;
  //
  output logic          oframe_out_done    ;
  output logic [15 : 0] oframe_out_bitnum  ;
  //
  output logic [15 : 0] oldpc_biterr       ;
  output logic          oldpc_decfail      ;
  output logic  [7 : 0] oldpc_used_niter   ;
  //
  output logic  [3 : 0] obch_biterr        ;
  output logic          obch_decfail       ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  dvb_s2x_dec_stub
  dec
  (
    .iclk               ( iclk               ) ,
    .ireset             ( ireset             ) ,
    //
    .s_axis_aclk        ( s_axis_aclk        ) ,
    .s_axis_aresetn     ( s_axis_aresetn     ) ,
    .s_axis_tvalid      ( s_axis_tvalid      ) ,
    .s_axis_tdata       ( s_axis_tdata       ) ,
    .s_axis_tlast       ( s_axis_tlast       ) ,
    //
    .s_axis_tid         ( s_axis_tid         ) ,
    .s_axis_tdest       ( s_axis_tdest       ) ,
    .s_axis_tuser       ( s_axis_tuser       ) ,
    .s_axis_tready      ( s_axis_tready      ) ,
    //
    .m_axis_aclk        ( m_axis_aclk        ) ,
    .m_axis_aresetn     ( m_axis_aresetn     ) ,
    .m_axis_tready      ( m_axis_tready      ) ,
    .m_axis_tvalid      ( m_axis_tvalid      ) ,
    .m_axis_tdata       ( m_axis_tdata       ) ,
    .m_axis_tlast       ( m_axis_tlast       ) ,
    //
    .m_axis_tid         ( m_axis_tid         ) ,
    .m_axis_tdest       ( m_axis_tdest       ) ,
    .m_axis_tuser       ( m_axis_tuser       ) ,
    //
    .obusy              ( obusy              ) ,
    //
    .oframe_in_done     ( oframe_in_done     ) ,
    .oframe_in_bitnum   ( oframe_in_bitnum   ) ,
    .oframe_in_error    ( oframe_in_error    ) ,
    .oframe_in_overflow ( oframe_in_overflow ) ,
    //
    .oframe_out_done    ( oframe_out_done    ) ,
    .oframe_out_bitnum  ( oframe_out_bitnum  ) ,
    //
    .oldpc_biterr       ( oldpc_biterr       ) ,
    .oldpc_decfail      ( oldpc_decfail      ) ,
    .oldpc_used_niter   ( oldpc_used_niter   ) ,
    //
    .obch_biterr        ( obch_biterr        ) ,
    .obch_decfail       ( obch_decfail       )
  );

endmodule
