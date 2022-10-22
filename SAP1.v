// clk: positive edge clock
// clr: active low, does not clear if SAP_CE is disabled
// SAP_CE : active low SAP1 enable
module SAP1(clk, clr, SAP_CE, A, DQ, CE, WE, OE,
	PC, MAR, MDR, IR, AReg, TMP, OUT3, OUT4,
	TState);
	
	input clk, clr, SAP_CE;
	inout [7:0] DQ;
	output CE, WE, OE;
	output [7:0] A;
	
	output [7:0] PC, MAR;
	output [7:0] MDR, IR, AReg, TMP, OUT3, OUT4;
	output reg [7:0] TState = 1;
	
	reg mode = 0, flush = 1;
	reg [7:0] userInput = 0;
	wire [7:0] DRam;
	
	reg [4:0] IR_H = 0, IR_L = 0;
	reg isHalted = 0;
	
	RAM_Controller rc(.mode(mode), .flush(flush), .userInput(userInput), .A(A), .DQ(DQ), .CE(CE), .WE(WE), .OE(OE));
	
	reg [7:0] bus;
	reg isEnabled = 0;
	
	Counter Pc(.clk(clk), .clr(clr), .E(Cp), .Q(PC));
	DREgister Mar (.D(bus), .IE(Lm),   .OE(1), .clk(clk), .clr(clr), .Q(MAR));
	DREgister Mdr (.D(bus), .IE(Lmdr), .OE(1), .clk(clk), .clr(clr), .Q(MDR));
	DREgister Ir  (.D(bus), .IE(Lir),  .OE(1), .clk(clk), .clr(clr), .Q(IR));
	DREgister Areg(.D(bus), .IE(La),   .OE(1), .clk(clk), .clr(clr), .Q(AReg));
	DREgister tmp (.D(bus), .IE(Ltmp), .OE(1), .clk(clk), .clr(clr), .Q(TMP));
	DREgister Out (.D(bus), .IE(Lout), .OE(1), .clk(clk), .clr(clr), .Q(OUT3));
	
	
	// Control Lines
	reg Cp = 0;       // PC
	reg Lm = 0;       // MAR
	reg Lmdr = 0;     // MDR
	reg Lir = 0;      // IR
	reg La = 0;       // A
	reg Ltmp = 0;     // TMP
	reg Lout = 0;     // OUT3
	
	always @(SAP_CE) begin
		isEnabled = !SAP_CE;
	end
	
	always @(posedge clk, negedge clr) begin
		if (!clr)
			TState <= 1;
		else begin
				if (TState >= 6)
					TState  <= 1;
				else
					if (!isHalted && isEnabled) TState <= TState + 1;
		end
	end
	
	always @(*) begin
		if (!clr) begin
				userInput = 0;
				isHalted = 0;
		end
		else begin
			if (!isHalted && isEnabled) begin
				Cp = 0;
				Lm = 0;
				Lmdr = 0;
				Lir = 0;
				La = 0;
				Ltmp = 0;
				Lout = 0;
	
				if (TState == 1) begin
					bus = PC;
					Lm = 1;
					userInput = MAR;
				end
				else if (TState == 2)
					Cp = 1;
				else if (TState == 3) begin
					userInput = MAR;
					bus = DQ;
					Lmdr = 1;
					Lir = 1;
					IR_H = DQ[7:4];
					IR_L = DQ[3:0];
				end
				else if (TState == 4) begin				
					if (IR_H == 0 || IR_H == 1 || IR_H == 2) begin // LDA, ADD, SUB Routine
						bus = {4'h0, IR_L};
						Lm = 1;
						userInput = MAR;
					end
					else if (IR_H == 4'hE) begin // OUT Routine
						bus = AReg;
						Lout = 1;
					end
					else if (IR_H == 4'hF) // HLT Routine
						isHalted = 1;
				end
				else if (TState == 5) begin
					if (IR_H == 0) begin // LDA Routine
						userInput = MAR;
						bus = DQ;
						Lmdr = 1;
						La = 1;
					end
					if (IR_H == 1 || IR_H == 2) begin // ADD or SUB Routine
						userInput = MAR;
						bus = DQ;
						Lmdr = 1;
						Ltmp = 1;
					end
				end
				else if (TState == 6) begin
					if (IR_H == 1) begin // ADD Routine
						bus = AReg+TMP;
						La = 1;
					end
					if (IR_H == 2) begin // SUB Routine
						bus = AReg-TMP;
						La = 1;
					end	
				end
			end
		end
	end
endmodule