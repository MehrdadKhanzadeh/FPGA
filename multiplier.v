module mult (co, data, multresult);
//parameter n;
	input [15:0] co;
	input [15:0] data;
	output [31:0] multresult;

	assign multresult = co * data;

endmodule