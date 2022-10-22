module Counter(clk, clr, E, Q);
	input clk, clr, E;
	output reg [7:0] Q;
	
	always @(posedge clk, negedge clr) begin
		if (!clr) 
			Q <= 0;
		else begin
			if (E) Q <= Q + 1;
		end
	end
endmodule