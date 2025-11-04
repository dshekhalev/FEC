// --------------------------------------------------------------------------------
// Device      : xc7k325tffv900-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module dvb_s2x_dec_stub(iclk, ireset, s_axis_aclk, s_axis_aresetn, 
  s_axis_tvalid, s_axis_tdata, s_axis_tlast, s_axis_tid, s_axis_tdest, s_axis_tuser, 
  s_axis_tready, m_axis_aclk, m_axis_aresetn, m_axis_tready, m_axis_tvalid, m_axis_tdata, 
  m_axis_tlast, m_axis_tid, m_axis_tdest, m_axis_tuser, obusy, oframe_in_done, 
  oframe_in_bitnum, oframe_in_error, oframe_in_overflow, oframe_out_done, 
  oframe_out_bitnum, oldpc_biterr, oldpc_decfail, oldpc_used_niter, obch_biterr, 
  obch_decfail)
/* synthesis syn_black_box black_box_pad_pin="iclk,ireset,s_axis_aclk,s_axis_aresetn,s_axis_tvalid,s_axis_tdata[31:0],s_axis_tlast,s_axis_tid[7:0],s_axis_tdest[3:0],s_axis_tuser[17:0],s_axis_tready,m_axis_aclk,m_axis_aresetn,m_axis_tready,m_axis_tvalid,m_axis_tdata[7:0],m_axis_tlast,m_axis_tid[7:0],m_axis_tdest[3:0],m_axis_tuser[8:0],obusy,oframe_in_done,oframe_in_bitnum[15:0],oframe_in_error,oframe_in_overflow,oframe_out_done,oframe_out_bitnum[15:0],oldpc_biterr[15:0],oldpc_decfail,oldpc_used_niter[7:0],obch_biterr[3:0],obch_decfail" */;
  input iclk;
  input ireset;
  input s_axis_aclk;
  input s_axis_aresetn;
  input s_axis_tvalid;
  input [31:0]s_axis_tdata;
  input s_axis_tlast;
  input [7:0]s_axis_tid;
  input [3:0]s_axis_tdest;
  input [17:0]s_axis_tuser;
  output s_axis_tready;
  input m_axis_aclk;
  input m_axis_aresetn;
  input m_axis_tready;
  output m_axis_tvalid;
  output [7:0]m_axis_tdata;
  output m_axis_tlast;
  output [7:0]m_axis_tid;
  output [3:0]m_axis_tdest;
  output [8:0]m_axis_tuser;
  output obusy;
  output oframe_in_done;
  output [15:0]oframe_in_bitnum;
  output oframe_in_error;
  output oframe_in_overflow;
  output oframe_out_done;
  output [15:0]oframe_out_bitnum;
  output [15:0]oldpc_biterr;
  output oldpc_decfail;
  output [7:0]oldpc_used_niter;
  output [3:0]obch_biterr;
  output obch_decfail;
endmodule
