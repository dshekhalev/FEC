// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module gsfc_dec_stub(iclk, ireset, iNiter, ifmode, s_axis_aclk, 
  s_axis_aresetn, s_axis_tvalid, s_axis_tdata, s_axis_tlast, s_axis_tid, s_axis_tdest, 
  s_axis_tuser, s_axis_tready, m_axis_aclk, m_axis_aresetn, m_axis_tready, m_axis_tvalid, 
  m_axis_tdata, m_axis_tlast, m_axis_tid, m_axis_tdest, m_axis_tuser, obusy, oframe_in_error, 
  oframe_out_done, obiterr, odecfail, oused_niter)
/* synthesis syn_black_box black_box_pad_pin="iclk,ireset,iNiter[3:0],ifmode,s_axis_aclk,s_axis_aresetn,s_axis_tvalid,s_axis_tdata[127:0],s_axis_tlast,s_axis_tid[7:0],s_axis_tdest[3:0],s_axis_tuser[3:0],s_axis_tready,m_axis_aclk,m_axis_aresetn,m_axis_tready,m_axis_tvalid,m_axis_tdata[15:0],m_axis_tlast,m_axis_tid[7:0],m_axis_tdest[3:0],m_axis_tuser[3:0],obusy,oframe_in_error,oframe_out_done,obiterr[15:0],odecfail,oused_niter[3:0]" */;
  input iclk;
  input ireset;
  input [3:0]iNiter;
  input ifmode;
  input s_axis_aclk;
  input s_axis_aresetn;
  input s_axis_tvalid;
  input [127:0]s_axis_tdata;
  input s_axis_tlast;
  input [7:0]s_axis_tid;
  input [3:0]s_axis_tdest;
  input [3:0]s_axis_tuser;
  output s_axis_tready;
  input m_axis_aclk;
  input m_axis_aresetn;
  input m_axis_tready;
  output m_axis_tvalid;
  output [15:0]m_axis_tdata;
  output m_axis_tlast;
  output [7:0]m_axis_tid;
  output [3:0]m_axis_tdest;
  output [3:0]m_axis_tuser;
  output obusy;
  output oframe_in_error;
  output oframe_out_done;
  output [15:0]obiterr;
  output odecfail;
  output [3:0]oused_niter;
endmodule
