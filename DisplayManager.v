// masterMode : identifies which mode is currently on display
//   0 : Read from RAM
//   1 : Write to RAM
//   2 : Run SAP1, display values
//    submode:
//       0 (PC) : PC-xx   1 (MAR): Ar-xx   2 (MDR): dr-xx
// 		3 (IR) : ir-xx   4 (A)  : A-xx    5 (TMP): t-xx
// 		6 (OUT): o-xx
//   3 : Auto/Manual selection mode
//    submode:
//       0 : Manual, 1 : Auto
// 		display: A0--S0
// 		A0 : manual   A1: auto
// 		S0 : slowest  S3: fastest (display from 0 to 3 250ms increment)
// userInput: used to select the subMode for each masterMode
// clkIn : captures the current clock for display
// clkMode : set the current clock mode for auto or manual
// clkSpeed: set the clkSpeed for display
module DisplayManager(masterMode, userInput, clkIn, clkMode, clkSpeed,
	A, DQ, CE, WE, OE,
	PC, MAR, MDR, IR, AReg, TMP, OUT, TState,
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	LEDR);
	
	input [1:0]	masterMode;
	input [7:0] userInput;
	input clkIn, clkMode;
	input [4:0] clkSpeed;
	
	input CE, WE, OE;
	input [7:0] A;
	input [7:0] DQ;
	
	input [7:0] PC, MAR, MDR, IR, AReg, TMP, OUT, TState;

	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;
	
	reg [4:0] HEX0_data;
	reg [4:0] HEX1_data;
	reg [4:0] HEX2_data;
	reg [4:0] HEX3_data;
	reg [4:0] HEX4_data;
	reg [4:0] HEX5_data;
	
	Bin2HexEx h0(.sel(HEX0_data), .leds(HEX0));
	Bin2HexEx h1(.sel(HEX1_data), .leds(HEX1));
	Bin2HexEx h2(.sel(HEX2_data), .leds(HEX2));
	Bin2HexEx h3(.sel(HEX3_data), .leds(HEX3));
	Bin2HexEx h4(.sel(HEX4_data), .leds(HEX4));
	Bin2HexEx h5(.sel(HEX5_data), .leds(HEX5));
	
	Bin2LedFill leds(.sel(TState), .leds(LEDR[5:0]));
	Bit2Led leds3(.sel({CE,WE,OE}), .leds(LEDR[9:7]));
	
	assign LEDR[6] = clkIn;
	
	always @(*) begin
		if (masterMode == 0 || masterMode == 1) begin // Read-Write mode
			// display Axxdxx
			HEX0_data = DQ[3:0];
			HEX1_data = DQ[7:4];
			HEX2_data = 4'd13; // d
			HEX3_data = A[3:0];
			HEX4_data = A[7:4];
			HEX5_data = 4'd10; // A
		end 
		else if (masterMode == 2) begin // SAP1 mode, display values
		// 0 (PC) : PC-xx   1 (MAR): Ar-xx   2 (MDR): dr-xx
		// 3 (IR) : ir-xx   4 (A)  : A-xx    5 (TMP): t-xx
		// 6 (OUT): o-xx
			if (userInput == 0) begin
				HEX0_data = PC[3:0];
				HEX1_data = PC[7:4];
				HEX2_data = 5'd17;
				HEX3_data = 5'd19; // c
				HEX4_data = 5'd18; // P
				HEX5_data = 5'd16;
			end else if (userInput == 1) begin
				HEX0_data = MAR[3:0];
				HEX1_data = MAR[7:4];
				HEX2_data = 5'd17;
				HEX3_data = 5'd20; // r
				HEX4_data = 5'd10; // A
				HEX5_data = 5'd16;
			end else if (userInput == 2) begin
				HEX0_data = MDR[3:0];
				HEX1_data = MDR[7:4];
				HEX2_data = 5'd17;
				HEX3_data = 5'd20; // r
				HEX4_data = 5'd13; // d
				HEX5_data = 5'd16;
			end else if (userInput == 3) begin
				HEX0_data = IR[3:0];
				HEX1_data = IR[7:4];
				HEX2_data = 5'd17;
				HEX3_data = 5'd20; // r
				HEX4_data = 5'd23; // i
				HEX5_data = 5'd16;
			end else if (userInput == 4) begin
				HEX0_data = AReg[3:0];
				HEX1_data = AReg[7:4];
				HEX2_data = 5'd17;
				HEX3_data = 5'd10; // A
				HEX4_data = 5'd16; // 
				HEX5_data = 5'd16;
			end else if (userInput == 5) begin
				HEX0_data = TMP[3:0];
				HEX1_data = TMP[7:4];
				HEX2_data = 5'd17;
				HEX3_data = 5'd21; // t
				HEX4_data = 5'd16; // 
				HEX5_data = 5'd16;
			end else if (userInput == 6) begin
				HEX0_data = OUT[3:0];
				HEX1_data = OUT[7:4];
				HEX2_data = 5'd17;
				HEX3_data = 5'd22; // o
				HEX4_data = 5'd16; // 
				HEX5_data = 5'd16;
			end
			else begin // no display
				HEX0_data = 5'd17;
				HEX1_data = 5'd17;
				HEX2_data = 5'd17;
				HEX3_data = 5'd17;
				HEX4_data = 5'd17;
				HEX5_data = 5'd17;
			end
		end else if (masterMode == 3) begin // clock select mode
		// display: A0--S0
		// A0 : manual   A1: auto
		// S0 : slowest  S9: fastest (display from 0 to 3 250ms increment)
			HEX0_data = clkSpeed;
			HEX1_data = 5'd05;
			HEX2_data = 5'd16; // S
			HEX3_data = 5'd16;
			HEX4_data = clkMode;
			HEX5_data = 5'd10; // A
		end
	end
	
endmodule