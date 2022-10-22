module Mux4to1(W0, W1, W2, W3, sel, f);
	input [3:0] W0, W1, W2, W3;
	input [1:0] sel;
	output reg [3:0] f = 0;
	
	always @(*) begin
		case (sel)
			0: f = W0;
			1: f = W1;
			2: f = W2;
			3: f = W3;
		endcase
	end
endmodule