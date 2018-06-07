`timescale 1ns/100ps
module FIR(input aclk ,s_axis_data_tvalid,input [15:0] s_axis_data_tdata,
output s_axis_data_tready,m_axis_data_tvalid,output [33:0] m_axis_data_tdata);
	reg [15:0] b [18:0];
	reg [15:0] inp [18:0];
	wire [31:0] haselezarb;
	//reg [33:0] haselejam;
	reg [4:0] clkCount;

	always @(posedge aclk) begin

		if (s_axis_data_tvalid )begin
			inp[0] = s_axis_data_tdata;
			inp << 1;
		end
		
		clkCount = clkCount + 1;
		
		if (clkCount > 19)
			m_axis_data_tvalid = 1;
		
	end

	initial begin
	
		s_axis_data_tready = 1;
		m_axis_data_tvalid = 0;
		
		clkCount = 0;

		b[0]=26;
		b[1]=270;	
		b[2]=963;
		b[3]=2424;
		b[4]=4869;
		b[5]=8259;
		b[6]=12194;
		b[7]=15948;
		b[8]=1866;
		b[9]=19660;
		b[10]=18666;
		b[11]=15948;
		b[12]=12194;
		b[13]=8259;
		b[14]=4869;
		b[15]=2424;
		b[16]=963;
		b[17]=270;
		b[18]=26;

	end

	genvar i;
	generate
	
		for (i = 0; i < 19; i = i + 1) begin
			mult(.co(b[i]),.data(inp[i]) , .multresult(haselezarb));
			adder(.a(haselezarb),.b(m_axis_data_tdata), .sum(m_axis_data_tdata));
		end
		
	endgenerate
	
	always @(negedge aclk) begin
		m_axis_data_tvalid = 0;
	end
	
endmodule
























