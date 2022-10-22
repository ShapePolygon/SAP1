// Converts a binary value to fill (similar to progress bar) leds.
module Bin2LedFill(sel, leds);
	input [3:0] sel;
	output reg [9:0] leds;
	
	always @(sel)
	case (sel)
		0: leds = 10'b0000000000;    // 0 
		1: leds = 10'b0000000001;    // 1 
		2: leds = 10'b0000000011;    // 2 
		3: leds = 10'b0000000111;    // 3 
		4: leds = 10'b0000001111;    // 4 
		5: leds = 10'b0000011111;    // 5 
		6: leds = 10'b0000111111;    // 6 
		7: leds = 10'b0001111111;    // 7 
		8: leds = 10'b0011111111;    // 8 
		9: leds = 10'b0111111111;    // 9 
		10: leds = 10'b1111111111;   // 10 		
		default: leds = 10'b1111111111;
	endcase
endmodule