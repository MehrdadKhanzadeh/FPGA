 `timescale 1 ns / 100 ps

  module TEST_FIR;
	reg aclk;
	reg s_axis_data_tvalid;
	reg signed [15:0] s_axis_data_tdata;
	wire s_axis_data_tready;
	wire m_axis_data_tvalid;
	  wire signed [15:0] m_axis_data_tdata;
	
	/*FIR_core U1(.aclk(aclk),.s_axis_data_tvalid(s_axis_data_tvalid),.s_axis_data_tdata(s_axis_data_tdata),
	.s_axis_data_tready(s_axis_data_tready),.m_axis_data_tvalid(m_axis_data_tvalid),
	.m_axis_data_tdata(m_axis_data_tdata));*/
	core_m U (
    .aclk(aclk), 
    .s_axis_data_tvalid(s_axis_data_tvalid), 
    .s_axis_data_tready(s_axis_data_tready), 
    .m_axis_data_tvalid(m_axis_data_tvalid), 
    .s_axis_data_tdata(s_axis_data_tdata), 
    .m_axis_data_tdata(m_axis_data_tdata)
    );
	
	initial begin
	aclk=0;s_axis_data_tvalid=0;
	end
	
	
	always begin #11338 aclk=~aclk; 
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
	
	always@(posedge aclk ) begin
	#5
		file_scan=$fscanf(file_open,"%b\n",data_in);
		s_axis_data_tvalid <=1;
		if(!$feof(file_open)) begin
			$display("%d\n",data_in);
			s_axis_data_tdata<=data_in;
			#100;
			//s_axis_data_tvalid <=0;
			
		end
		else begin
			$fclose(file_open);
			#200;
			$fclose(file_write);
			$finish;
		end
	end
	
	
	always@(m_axis_data_tdata)begin
		$fwrite(file_write,"%b\n",m_axis_data_tdata);
	end
	
  endmodule

