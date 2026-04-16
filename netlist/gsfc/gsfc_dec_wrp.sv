/*



  logic           gsfc_dec_wrp__iclk            ;
  logic           gsfc_dec_wrp__ireset          ;
  //
  logic   [3 : 0] gsfc_dec_wrp__iNiter          ;
  logic           gsfc_dec_wrp__ifmode          ;
  //
  logic           gsfc_dec_wrp__s_axis_aclk     ;
  logic           gsfc_dec_wrp__s_axis_aresetn  ;
  logic           gsfc_dec_wrp__s_axis_tvalid   ;
  logic [127 : 0] gsfc_dec_wrp__s_axis_tdata    ;
  logic           gsfc_dec_wrp__s_axis_tlast    ;
  //
  logic   [7 : 0] gsfc_dec_wrp__s_axis_tid      ;
  logic   [3 : 0] gsfc_dec_wrp__s_axis_tdest    ;
  logic   [3 : 0] gsfc_dec_wrp__s_axis_tuser    ;
  logic           gsfc_dec_wrp__s_axis_tready   ;
  //
  logic           gsfc_dec_wrp__m_axis_aclk     ;
  logic           gsfc_dec_wrp__m_axis_aresetn  ;
  logic           gsfc_dec_wrp__m_axis_tready   ;
  logic           gsfc_dec_wrp__m_axis_tvalid   ;
  logic  [15 : 0] gsfc_dec_wrp__m_axis_tdata    ;
  logic           gsfc_dec_wrp__m_axis_tlast    ;
  //
  logic   [7 : 0] gsfc_dec_wrp__m_axis_tid      ;
  logic   [3 : 0] gsfc_dec_wrp__m_axis_tdest    ;
  logic   [3 : 0] gsfc_dec_wrp__m_axis_tuser    ;
  //
  logic           gsfc_dec_wrp__obusy           ;
  //
  logic           gsfc_dec_wrp__oframe_in_error ;
  logic           gsfc_dec_wrp__oframe_out_done ;
  //
  logic  [15 : 0] gsfc_dec_wrp__obiterr         ;
  logic           gsfc_dec_wrp__odecfail        ;
  logic   [3 : 0] gsfc_dec_wrp__oused_niter     ;



  gsfc_dec_wrp
  gsfc_dec_wrp
  (
    .iclk            ( gsfc_dec_wrp__iclk            ) ,
    .ireset          ( gsfc_dec_wrp__ireset          ) ,
    //
    .iNiter          ( gsfc_dec_wrp__iNiter          ) ,
    .ifmode          ( gsfc_dec_wrp__ifmode          ) ,
    //
    .s_axis_aclk     ( gsfc_dec_wrp__s_axis_aclk     ) ,
    .s_axis_aresetn  ( gsfc_dec_wrp__s_axis_aresetn  ) ,
    .s_axis_tvalid   ( gsfc_dec_wrp__s_axis_tvalid   ) ,
    .s_axis_tdata    ( gsfc_dec_wrp__s_axis_tdata    ) ,
    .s_axis_tlast    ( gsfc_dec_wrp__s_axis_tlast    ) ,
    //
    .s_axis_tid      ( gsfc_dec_wrp__s_axis_tid      ) ,
    .s_axis_tdest    ( gsfc_dec_wrp__s_axis_tdest    ) ,
    .s_axis_tuser    ( gsfc_dec_wrp__s_axis_tuser    ) ,
    .s_axis_tready   ( gsfc_dec_wrp__s_axis_tready   ) ,
    //
    .m_axis_aclk     ( gsfc_dec_wrp__m_axis_aclk     ) ,
    .m_axis_aresetn  ( gsfc_dec_wrp__m_axis_aresetn  ) ,
    .m_axis_tready   ( gsfc_dec_wrp__m_axis_tready   ) ,
    .m_axis_tvalid   ( gsfc_dec_wrp__m_axis_tvalid   ) ,
    .m_axis_tdata    ( gsfc_dec_wrp__m_axis_tdata    ) ,
    .m_axis_tlast    ( gsfc_dec_wrp__m_axis_tlast    ) ,
    //
    .m_axis_tid      ( gsfc_dec_wrp__m_axis_tid      ) ,
    .m_axis_tdest    ( gsfc_dec_wrp__m_axis_tdest    ) ,
    .m_axis_tuser    ( gsfc_dec_wrp__m_axis_tuser    ) ,
    //
    .obusy           ( gsfc_dec_wrp__obusy           ) ,
    //
    .oframe_in_error ( gsfc_dec_wrp__oframe_in_error ) ,
    .oframe_out_done ( gsfc_dec_wrp__oframe_out_done ) ,
    //
    .obiterr         ( gsfc_dec_wrp__obiterr         ) ,
    .odecfail        ( gsfc_dec_wrp__odecfail        ) ,
    .oused_niter     ( gsfc_dec_wrp__oused_niter     )
  );


  assign gsfc_dec_wrp__iclk           = '0 ;
  assign gsfc_dec_wrp__ireset         = '0 ;
  assign gsfc_dec_wrp__iNiter         = '0 ;
  assign gsfc_dec_wrp__ifmode         = '0 ;
  assign gsfc_dec_wrp__s_axis_aclk    = '0 ;
  assign gsfc_dec_wrp__s_axis_aresetn = '0 ;
  assign gsfc_dec_wrp__s_axis_tvalid  = '0 ;
  assign gsfc_dec_wrp__s_axis_tdata   = '0 ;
  assign gsfc_dec_wrp__s_axis_tstrb   = '0 ;
  assign gsfc_dec_wrp__s_axis_tid     = '0 ;
  assign gsfc_dec_wrp__s_axis_tdest   = '0 ;
  assign gsfc_dec_wrp__s_axis_tuser   = '0 ;
  assign gsfc_dec_wrp__m_axis_aclk    = '0 ;
  assign gsfc_dec_wrp__m_axis_aresetn = '0 ;
  assign gsfc_dec_wrp__m_axis_tready  = '0 ;



*/

//
// Project       : GSFC ldpc (7136, 8160)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_dec_wrp.sv
// Description   : NASA GSFC encoder wrapper for with axi-stream interfaces
//                 maximum number of iterations is 8 (!!!)
//

module gsfc_dec_wrp
(
  iclk               ,
  ireset             ,
  //
  iNiter             ,
  ifmode             ,
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
  oframe_in_error    ,
  oframe_out_done    ,
  //
  obiterr            ,
  odecfail           ,
  oused_niter
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic           iclk            ;  // LDPC core clock
  input  logic           ireset          ;
  //
  input  logic   [3 : 0] iNiter          ;
  input  logic           ifmode          ;
  //
  input  logic           s_axis_aclk     ;
  input  logic           s_axis_aresetn  ;
  input  logic           s_axis_tvalid   ;
  input  logic [127 : 0] s_axis_tdata    ;
  input  logic           s_axis_tlast    ;
  //
  input  logic   [7 : 0] s_axis_tid      ;
  input  logic   [3 : 0] s_axis_tdest    ;
  input  logic   [3 : 0] s_axis_tuser    ;
  output logic           s_axis_tready   ;
  //
  input  logic           m_axis_aclk     ;
  input  logic           m_axis_aresetn  ;
  input  logic           m_axis_tready   ;
  output logic           m_axis_tvalid   ;
  output logic  [15 : 0] m_axis_tdata    ;
  output logic           m_axis_tlast    ;
  //
  output logic   [7 : 0] m_axis_tid      ;
  output logic   [3 : 0] m_axis_tdest    ;
  output logic   [3 : 0] m_axis_tuser    ;
  //
  output logic           obusy           ;
  //
  output logic           oframe_in_error ;
  output logic           oframe_out_done ;
  //
  output logic  [15 : 0] obiterr         ;
  output logic           odecfail        ;
  output logic   [3 : 0] oused_niter     ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  gsfc_dec_stub
  dec
  (
    .iclk            ( iclk            ) ,
    .ireset          ( ireset          ) ,
    //
    .iNiter          ( iNiter          ) ,
    .ifmode          ( ifmode          ) ,
    //
    .s_axis_aclk     ( s_axis_aclk     ) ,
    .s_axis_aresetn  ( s_axis_aresetn  ) ,
    .s_axis_tvalid   ( s_axis_tvalid   ) ,
    .s_axis_tdata    ( s_axis_tdata    ) ,
    .s_axis_tlast    ( s_axis_tlast    ) ,
    //
    .s_axis_tid      ( s_axis_tid      ) ,
    .s_axis_tdest    ( s_axis_tdest    ) ,
    .s_axis_tuser    ( s_axis_tuser    ) ,
    .s_axis_tready   ( s_axis_tready   ) ,
    //
    .m_axis_aclk     ( m_axis_aclk     ) ,
    .m_axis_aresetn  ( m_axis_aresetn  ) ,
    .m_axis_tready   ( m_axis_tready   ) ,
    .m_axis_tvalid   ( m_axis_tvalid   ) ,
    .m_axis_tdata    ( m_axis_tdata    ) ,
    .m_axis_tlast    ( m_axis_tlast    ) ,
    //
    .m_axis_tid      ( m_axis_tid      ) ,
    .m_axis_tdest    ( m_axis_tdest    ) ,
    .m_axis_tuser    ( m_axis_tuser    ) ,
    //
    .obusy           ( obusy           ) ,
    //
    .oframe_in_error ( oframe_in_error ) ,
    .oframe_out_done ( oframe_out_done ) ,
    //
    .obiterr         ( obiterr         ) ,
    .odecfail        ( odecfail        ) ,
    .oused_niter     ( oused_niter     )
  );

endmodule
