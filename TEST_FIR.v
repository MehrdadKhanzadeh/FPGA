`timescale 1ns / 1ps
// Verilog Test Fixture Template

  `timescale 1 ns / 100 ps

  module TEST_FIR;
	reg aclk;
	reg s_axis_data_tvalid;
	reg signed [15:0] s_axis_data_tdata;
	wire s_axis_data_tready;
	wire m_axis_data_tvalid;
	wire signed [15:0] m_axis_data_tdata;
	
	
	optimizedSourceFIRfilter U1(.aclk(aclk),.s_axis_data_tvalid(s_axis_data_tvalid),.s_axis_data_tdata(s_axis_data_tdata),
	.s_axis_data_tready(s_axis_data_tready),.m_axis_data_tvalid(m_axis_data_tvalid),
	.m_axis_data_tdata(m_axis_data_tdata));
	
	initial begin
	aclk=0;s_axis_data_tvalid=0;
	end

	always begin #10 aclk=~aclk;
	end
	
  
	integer file_open;
	integer file_scan;
	integer file_write;
	reg signed [15:0] data_in;
	
	initial begin
		file_open=$fopen("Audio_Noisy_Binary.txt","r");
		if(file_open==0) begin
			$display("can not open file");
			$finish;
		end
		file_write=$fopen("output_FIR.txt","w");
		if(file_write==0) begin
			$display("can not open file");
			$finish;
		end
	end
	
	wire temp;
	assign temp=aclk && !s_axis_data_tvalid ;
	always@(posedge temp ) begin
	#5
		file_scan=$fscanf(file_open,"%b\n",data_in);
		if(!$feof(file_open)) begin
			$display("%d\n",data_in);
			s_axis_data_tdata<=data_in;
			s_axis_data_tvalid <=1;
			#10;
			s_axis_data_tvalid <=0;
		end
		else begin
			$fclose(file_open);
			#200;
			$fclose(file_write);
			$finish;
		end
		
	end
	

	always@(posedge m_axis_data_tvalid)begin
		$fwrite(file_write,"%b\n",m_axis_data_tdata);
	end
  endmodule

