module Clock100ms(clk, clkOut);
	parameter mul=1;
	
	input clk;
	output reg clkOut = 0;
	
	integer prescale = 0;
	integer clkMul = 2500000;
	
	always @(posedge clk) begin
		prescale <= prescale + 1;
		
		if (prescale >= clkMul*mul) begin
			prescale <= 0;
			clkOut <= ~clkOut;
		end
	end
endmodule