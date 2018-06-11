`timescale 1ns/100ps

module optimizedSourceFIRfilter(aclk, s_axis_data_tvalid, s_axis_data_tdata, 
                    s_axis_data_tready, m_axis_data_tvalid, m_axis_data_tdata);
         
    input aclk, s_axis_data_tvalid;
    input [15:0] s_axis_data_tdata;
    output s_axis_data_tready, m_axis_data_tvalid;
    output [15:0] m_axis_data_tdata;
    
    
    parameter signed [0:16 * 19 - 1] b = {16'd26, 16'd270, 16'd963, 16'd2424, 16'd4869, 16'd8259, 16'd12194, 16'd15948, 16'd18666, 16'd19660, 16'd15948,
	 				16'd12194, 16'd8259, 16'd4869, 16'd2424, 16'd963, 16'd270, 16'd26};
    
    reg signed [15:0] coefficient [17:0]; //18 registers to save inputs
    reg signed [15:0] result;
    reg signed [31:0] temp_result;
    reg valid;

    reg [4:0] i;
    
    
    always @(posedge aclk) begin
        valid <= 0;
        if (s_axis_data_tvalid) begin
            temp_result = s_axis_data_tdata * b[0];
            
            for ( i = 1; i <= 18; i = i + 1) begin
               temp_result = temp_result + b[(i - 1) * 16+:15] * coefficient[i - 1]; 
            end
            
            for ( i = 17; i >= 1; i = i - 1) begin
                coefficient[i] <= coefficient[i - 1];
            end
            
            coefficient[0] <= s_axis_data_tdata;
            
            result <= temp_result[15:0];
            
            valid <= 1;
            
        end
    end
    
    assign s_axis_data_tready = valid;
    assign m_axis_data_tvalid = valid;
    
endmodule
