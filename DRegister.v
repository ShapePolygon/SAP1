module DREgister(D, IE, OE, clk, clr, Q);
	input [7:0] D;
	output [7:0] Q;
	input IE, OE;
	input clk, clr;
	
	reg [7:0] data = 0;
	
	assign Q = (OE) ? data : 8'bz;
	
	always @(posedge clk, negedge clr) begin
		if (!clr) 
			data <= 0;
		else begin
			if (IE) data <= D;
		end
	end
	
endmodule