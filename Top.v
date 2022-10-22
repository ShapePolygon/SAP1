module Top(clk, SW_input, KEY_input,
	A, DQ, CE, WE, OE,
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	LEDR);
	
	input clk;
	input [9:0] SW_input;
	input [3:0] KEY_input;
	
	output  CE, WE, OE;
	output  [7:0] A;
	inout [7:0] DQ;
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;
	
	wire [1:0] masterMode;
	wire modeCon, modeClockManager;
	wire [3:0] clkSpeed_w;
	
	wire [3:0] IE_w;
	wire [7:0] SW_out_w;
	wire [3:0] KEY_out_w;
	wire clkOut_w, clrOut_w;
	
	wire [7:0] A_SAP1_w, DQ_SAP1_w;
	wire CE_SAP1_w, WE_SAP1_w, OE_SAP1_w;
	wire [7:0] A_Con_w, DQ_Con_w;
	wire CE_Con_w, WE_Con_w, OE_Con_w;
	wire [7:0] DRam;

	wire [7:0] PC, MAR;
	wire [7:0] MDR, IR, AReg, TMP, OUT3, OUT4;
	wire [7:0] TState;
	
	DisplayManager dm(.masterMode(masterMode), .userInput(SW_input[7:0]), .clkIn(clkOut_w), .clkMode(modeClockManager), .clkSpeed(clkSpeed_w),
	.A(A), .DQ(DQ), .CE(CE), .WE(WE), .OE(OE),
	.PC(PC), .MAR(MAR), .MDR(MDR), .IR(IR), .AReg(AReg), .TMP(TMP), .OUT(OUT3), .TState(TState),
	.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
	.LEDR(LEDR)
	);
	
	InputManager im(.masterMode(masterMode), .subMode0(modeCon), .subMode3(modeClockManager), 
		.IE(IE_w), .SW_input(SW_input), .KEY_input(KEY_input), .SW_out(SW_out_w), .KEY_out(KEY_out_w));
	
	SAP1 sap(.clk(clkOut_w), .clr(clrOut_w), .SAP_CE(IE_w[0]), .A(A_SAP1_w), .DQ(DQ_SAP1_w), .CE(CE_SAP1_w), .WE(WE_SAP1_w), .OE(OE_SAP1_w),
			.PC(PC), .MAR(MAR), .MDR(MDR), .IR(IR), .AReg(AReg), .TMP(TMP), .OUT3(OUT3), .OUT4(OUT4), .TState(TState));
			
	ClockManager cm(.subMode(modeClockManager), .clkSpeed(clkSpeed_w), .IE(IE_w[2]), .clk(clk), .clkOut(clkOut_w), .clrOut(clrOut_w), .KEY_input(KEY_input));
	
	RAM_Controller rc(.mode(modeCon), .flush(KEY_input[0]), .IE(IE_w[1]), .userInput(SW_input[7:0]), 
	.A(A_Con_w), .DQ(DQ_Con_w), .CE(CE_Con_w), .WE(WE_Con_w), .OE(OE_Con_w));
	
	RAM_Manager rm(.masterMode(masterMode),
						.A_Con(A_Con_w), .DQ_Con(DQ_Con_w), .CE_Con(CE_Con_w), .WE_Con(WE_Con_w), .OE_Con(OE_Con_w),
						.A_SAP1(A_SAP1_w), .DQ_SAP1(DQ_SAP1_w), .CE_SAP1(CE_SAP1_w), .WE_SAP1(WE_SAP1_w), .OE_SAP1(OE_SAP1_w),
						.A(A), .DQ(DQ), .CE(CE), .WE(WE), .OE(OE));
endmodule