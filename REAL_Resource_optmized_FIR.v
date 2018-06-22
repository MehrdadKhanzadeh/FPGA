`timescale 1ns / 1ps
`timescale 1ns/100ps

module optimizedSourceFIRfilter(aclk, s_axis_data_tvalid, s_axis_data_tdata, 
                    s_axis_data_tready, m_axis_data_tvalid, m_axis_data_tdata);
         
    input aclk, s_axis_data_tvalid;
    input [15:0] s_axis_data_tdata;
    output s_axis_data_tready, m_axis_data_tvalid;
    output [15:0] m_axis_data_tdata;
    
    
    
    reg signed [15:0] coefficient [18:0];

	reg signed [15:0] b[17:0];
    reg signed [15:0] result;
    reg signed [31:0] temp_result;
    reg valid;

    reg [4:0] i;
    
	initial begin
	temp_result=0;
	coefficient [0]=16'd26;
	coefficient [1]=16'd270;
	coefficient [2]=16'd963;
	coefficient [3]=16'd2424;
	coefficient [4]=16'd4869;
	coefficient [5]=16'd8259;
	coefficient [6]=16'd12194;
	coefficient [7]=16'd15948;
	coefficient [8]=16'd18666;
	coefficient [9]=16'd19660;
	coefficient [10]=16'd18666;
	coefficient [11]=16'd15948;
	coefficient [12]=16'd12194;
	coefficient [13]=16'd8259;
	coefficient [14]=16'd4869;
	coefficient [15]=16'd2424;
	coefficient [16]=16'd963;
	coefficient [17]=16'd270;
	coefficient [18]=16'd26;
	b[0]=0;b[1]=0;b[2]=0;b[3]=0;b[4]=0;b[5]=0;b[6]=0;b[7]=0;b[8]=0;b[9]=0;
	b[10]=0;b[11]=0;b[12]=0;b[13]=0;b[14]=0;b[15]=0;b[16]=0;b[17]=0;
	end
    
	reg [31:0] a1;
	reg [15:0] m1, m2;
	reg [31:0] out;
	ALU m(a1, m1, m2, out);
	
	wire temp;
	assign temp=aclk && s_axis_data_tvalid;
    always @(posedge temp) begin
        valid <= 0;
			#5;
       // if (s_axis_data_tvalid) begin
            temp_result = s_axis_data_tdata * coefficient[0];
            
            for ( i = 1; i <= 18; i = i + 1) begin
			   a1 = temp_result;
			   m1 = b[i - 1];
			   m2 = coefficient[i];
			   temp_result = out;
            end
            
            for ( i = 17; i >= 1; i = i - 1) begin
                b[i] <= b[i - 1];
            end
            
            b[0] <= s_axis_data_tdata;
            
            result <= temp_result[15:0];
            
            valid <= 1;
       // end
    end
	 
    
    assign s_axis_data_tready = valid;
    assign m_axis_data_tvalid = valid;
    assign m_axis_data_tdata = result;
endmodule

module ALU (input [31:0] a1, input [15:0] m1, m2, output [31:0] out);
	reg [31:0] mul;
	assign mul = m1 * m2;
	assign out = a1 + mul;
endmodule