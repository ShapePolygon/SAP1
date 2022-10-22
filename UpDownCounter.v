// dir: 0 - count up
//      1 - count down
module UpDownCounter(clk, clr, dir, Q); 
	parameter MAX = 8;
	input clk, clr, dir;
	output reg [MAX-1:0] Q;
	
	always @(posedge clk, negedge clr) begin
		if (!clr) Q <= 0;
		else begin
			if (dir == 0)
				if (Q >= MAX-1) Q <= 0;
				else Q <= Q + 1;
			else
				if (Q == 0) Q <= MAX-1;
				else Q <= Q - 1;
		end
	end
endmodule