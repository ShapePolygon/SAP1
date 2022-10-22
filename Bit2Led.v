// active low LEDs
module Bit2Led(sel, leds);
	input [9:0] sel;
	output reg [9:0] leds;
	
	always @(sel)
		leds = ~sel;
endmodule