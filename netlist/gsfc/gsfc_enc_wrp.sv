/*



  logic          gsfc_enc_wrp__iclk            ;
  logic          gsfc_enc_wrp__ireset          ;
  //
  logic          gsfc_enc_wrp__s_axis_aclk     ;
  logic          gsfc_enc_wrp__s_axis_aresetn  ;
  logic          gsfc_enc_wrp__s_axis_tvalid   ;
  logic [15 : 0] gsfc_enc_wrp__s_axis_tdata    ;
  logic          gsfc_enc_wrp__s_axis_tlast    ;
  //
  logic  [7 : 0] gsfc_enc_wrp__s_axis_tid      ;
  logic  [3 : 0] gsfc_enc_wrp__s_axis_tdest    ;
  logic  [3 : 0] gsfc_enc_wrp__s_axis_tuser    ;
  logic          gsfc_enc_wrp__s_axis_tready   ;
  //
  logic          gsfc_enc_wrp__m_axis_aclk     ;
  logic          gsfc_enc_wrp__m_axis_aresetn  ;
  logic          gsfc_enc_wrp__m_axis_tready   ;
  logic          gsfc_enc_wrp__m_axis_tvalid   ;
  logic [15 : 0] gsfc_enc_wrp__m_axis_tdata    ;
  logic          gsfc_enc_wrp__m_axis_tlast    ;
  //
  logic  [7 : 0] gsfc_enc_wrp__m_axis_tid      ;
  logic  [3 : 0] gsfc_enc_wrp__m_axis_tdest    ;
  logic  [3 : 0] gsfc_enc_wrp__m_axis_tuser    ;
  //
  logic          gsfc_enc_wrp__obusy           ;
  //
  logic          gsfc_enc_wrp__oframe_in_error ;


  gsfc_enc_wrp
  gsfc_enc_wrp
  (
    .iclk            ( gsfc_enc_wrp__iclk            ) ,
    .ireset          ( gsfc_enc_wrp__ireset          ) ,
    //
    .s_axis_aclk     ( gsfc_enc_wrp__s_axis_aclk     ) ,
    .s_axis_aresetn  ( gsfc_enc_wrp__s_axis_aresetn  ) ,
    .s_axis_tvalid   ( gsfc_enc_wrp__s_axis_tvalid   ) ,
    .s_axis_tdata    ( gsfc_enc_wrp__s_axis_tdata    ) ,
    .s_axis_tlast    ( gsfc_enc_wrp__s_axis_tlast    ) ,
    //
    .s_axis_tid      ( gsfc_enc_wrp__s_axis_tid      ) ,
    .s_axis_tdest    ( gsfc_enc_wrp__s_axis_tdest    ) ,
    .s_axis_tuser    ( gsfc_enc_wrp__s_axis_tuser    ) ,
    .s_axis_tready   ( gsfc_enc_wrp__s_axis_tready   ) ,
    //
    .m_axis_aclk     ( gsfc_enc_wrp__m_axis_aclk     ) ,
    .m_axis_aresetn  ( gsfc_enc_wrp__m_axis_aresetn  ) ,
    .m_axis_tready   ( gsfc_enc_wrp__m_axis_tready   ) ,
    .m_axis_tvalid   ( gsfc_enc_wrp__m_axis_tvalid   ) ,
    .m_axis_tdata    ( gsfc_enc_wrp__m_axis_tdata    ) ,
    .m_axis_tlast    ( gsfc_enc_wrp__m_axis_tlast    ) ,
    //
    .m_axis_tid      ( gsfc_enc_wrp__m_axis_tid      ) ,
    .m_axis_tdest    ( gsfc_enc_wrp__m_axis_tdest    ) ,
    .m_axis_tuser    ( gsfc_enc_wrp__m_axis_tuser    ) ,
    //
    .obusy           ( gsfc_enc_wrp__obusy           ) ,
    //
    .oframe_in_error ( gsfc_enc_wrp__oframe_in_error )
  );


  assign gsfc_enc_wrp__iclk           = '0 ;
  assign gsfc_enc_wrp__ireset         = '0 ;
  assign gsfc_enc_wrp__s_axis_aclk    = '0 ;
  assign gsfc_enc_wrp__s_axis_aresetn = '0 ;
  assign gsfc_enc_wrp__s_axis_tvalid  = '0 ;
  assign gsfc_enc_wrp__s_axis_tdata   = '0 ;
  assign gsfc_enc_wrp__s_axis_tlast   = '0 ;
  assign gsfc_enc_wrp__s_axis_tid     = '0 ;
  assign gsfc_enc_wrp__s_axis_tdest   = '0 ;
  assign gsfc_enc_wrp__s_axis_tuser   = '0 ;
  assign gsfc_enc_wrp__m_axis_aclk    = '0 ;
  assign gsfc_enc_wrp__m_axis_aresetn = '0 ;
  assign gsfc_enc_wrp__m_axis_tready  = '0 ;



*/

//
// Project       : GSFC ldpc (7136, 8160)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_enc_wrp.sv
// Description   : NASA GSFC encoder wrapper for with axi-stream interfaces
//

module gsfc_enc_wrp
(
  iclk            ,
  ireset          ,
  //
  s_axis_aclk     ,
  s_axis_aresetn  ,
  s_axis_tvalid   ,
  s_axis_tdata    ,
  s_axis_tlast    ,
  //
  s_axis_tid      ,
  s_axis_tdest    ,
  s_axis_tuser    ,
  s_axis_tready   ,
  //
  m_axis_aclk     ,
  m_axis_aresetn  ,
  m_axis_tready   ,
  m_axis_tvalid   ,
  m_axis_tdata    ,
  m_axis_tlast    ,
  //
  m_axis_tid      ,
  m_axis_tdest    ,
  m_axis_tuser    ,
  //
  obusy           ,
  //
  oframe_in_error
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic          iclk              ; // LDPC core clock
  input  logic          ireset            ;
  //
  input  logic          s_axis_aclk       ;
  input  logic          s_axis_aresetn    ;
  input  logic          s_axis_tvalid     ;
  input  logic [15 : 0] s_axis_tdata      ;
  input  logic          s_axis_tlast      ;
  //
  input  logic  [7 : 0] s_axis_tid        ;
  input  logic  [3 : 0] s_axis_tdest      ;
  input  logic  [3 : 0] s_axis_tuser      ;
  output logic          s_axis_tready     ;
  //
  input  logic          m_axis_aclk       ;
  input  logic          m_axis_aresetn    ;
  input  logic          m_axis_tready     ;
  output logic          m_axis_tvalid     ;
  output logic [15 : 0] m_axis_tdata      ;
  output logic          m_axis_tlast      ;
  //
  output logic  [7 : 0] m_axis_tid        ;
  output logic  [3 : 0] m_axis_tdest      ;
  output logic  [3 : 0] m_axis_tuser      ;
  // s_axis_aclk
  output logic          obusy             ;
  // s_axis_aclk
  output logic          oframe_in_error   ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  gsfc_enc_stub
  enc
  (
    .iclk              ( iclk              ) ,
    .ireset            ( ireset            ) ,
    //
    .s_axis_aclk       ( s_axis_aclk       ) ,
    .s_axis_aresetn    ( s_axis_aresetn    ) ,
    .s_axis_tvalid     ( s_axis_tvalid     ) ,
    .s_axis_tdata      ( s_axis_tdata      ) ,
    .s_axis_tlast      ( s_axis_tlast      ) ,
    //
    .s_axis_tid        ( s_axis_tid        ) ,
    .s_axis_tdest      ( s_axis_tdest      ) ,
    .s_axis_tuser      ( s_axis_tuser      ) ,
    .s_axis_tready     ( s_axis_tready     ) ,
    //
    .m_axis_aclk       ( m_axis_aclk       ) ,
    .m_axis_aresetn    ( m_axis_aresetn    ) ,
    .m_axis_tready     ( m_axis_tready     ) ,
    .m_axis_tvalid     ( m_axis_tvalid     ) ,
    .m_axis_tdata      ( m_axis_tdata      ) ,
    .m_axis_tlast      ( m_axis_tlast      ) ,
    //
    .m_axis_tid        ( m_axis_tid        ) ,
    .m_axis_tdest      ( m_axis_tdest      ) ,
    .m_axis_tuser      ( m_axis_tuser      ) ,
    //
    .obusy             ( obusy             ) ,
    .oframe_in_error   ( oframe_in_error   )
  );

endmodule
