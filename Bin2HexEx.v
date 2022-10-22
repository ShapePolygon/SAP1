module Bin2HexEx(sel, leds);
	input [4:0] sel;
	output reg [7:0] leds;
	
	always @(sel)
	case (sel)
	   //           gfedcba      
		0: leds = 7'b1000000;   // 0 
		1: leds = 7'b1111001;   // 1 
		2: leds = 7'b0100100;   // 2 
		3: leds = 7'b0110000;   // 3 
		4: leds = 7'b0011001;   // 4 
		5: leds = 7'b0010010;   // 5 
		6: leds = 7'b0000010;   // 6 
		7: leds = 7'b1111000;   // 7 
		8: leds = 7'b0000000;   // 8 
		9: leds = 7'b0011000;   // 9 
		10: leds = 7'b0001000;  // A
		11: leds = 7'b0000011;  // b
		12: leds = 7'b1000110;  // C
		13: leds = 7'b0100001;  // d
		14: leds = 7'b0000110;  // E
		15: leds = 7'b0001110;  // F
		16: leds = 7'b1111111;  // 
		17: leds = 7'b0111111;  // -
		18: leds = 7'b0001100;  // P
		19: leds = 7'b0100111;  // c
		20: leds = 7'b0101111;  // r
		21: leds = 7'b0000111;  // t
		22: leds = 7'b0100011;  // o
		23: leds = 7'b1111011;  // i
		24: leds = 7'b1111111;  // 
		25: leds = 7'b1111111;  // 
		26: leds = 7'b1111111;  // 
		27: leds = 7'b1111111;  // 
		28: leds = 7'b1111111;  // 
		29: leds = 7'b1111111;  // 
		30: leds = 7'b1111111;  // 
		31: leds = 7'b1111111;  // 
	endcase
endmodule