`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:41 06/21/2018 
// Design Name: 
// Module Name:    core_m 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module core_m( aclk, s_axis_data_tvalid, s_axis_data_tready, m_axis_data_tvalid, s_axis_data_tdata, m_axis_data_tdata
    );
  input aclk;
  input s_axis_data_tvalid;
  output s_axis_data_tready;
  output m_axis_data_tvalid;
  input [15 : 0] s_axis_data_tdata;
  output [33 : 0] m_axis_data_tdata;
	FIR_core U1(.aclk(aclk),.s_axis_data_tvalid(s_axis_data_tvalid),.s_axis_data_tdata(s_axis_data_tdata),
	.s_axis_data_tready(s_axis_data_tready),.m_axis_data_tvalid(m_axis_data_tvalid),
	.m_axis_data_tdata(m_axis_data_tdata));

endmodule
