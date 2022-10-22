// subMode: manual or auto clock
//   0 : manual
//   1 : auto
// clkSpeed : output the current clock speed
// clk : main clock for distribution to clock delay modules (usually 50MHz from FPGA board)
// clkOut: clk used for all other modules. Used to control the speed of the clock output.
// clrOut: main clear for all modules
// KEY_input: bit 0 manual clock
// KEY_input: bit 1 decrease auto clock
// KEY_input: bit 2 increase auto clock
// KEY_input: bit 3 main clear
// IE : Input Enable, active low. Updates all input from SW or KEY.
module ClockManager(subMode, clkSpeed, IE, clk, clkOut, clrOut, KEY_input);
	input subMode;
	input IE;
	input clk;
	output clrOut;
	output clkOut;
	output [3:0] clkSpeed;
	
	input [3:0] KEY_input;
	wire clkManual;
	wire clkAuto;

	assign clkOut = (subMode == 0) ? clkManual : clkAuto;
	assign clrOut = (!IE) ? KEY_input[3] : 1;
	assign clkAuto = (!IE) ? clkStore[clkSpeed] : 0;
	assign clkManual = (!IE) ? ~KEY_input[0] : 0;
	
	wire [3:0] clkStore;
	wire count_dir;
	
	genvar i;
	generate
		for(i=0; i<=3; i=i+1) begin:clkGen
			Clock100ms item(.clk(clk), .clkOut(clkStore[i]));
				defparam item.mul=(i+1);
		end
	endgenerate
	
	assign count_dir = (KEY_input[1] == 0) ? 1 : 0; 
	UpDownCounter #(.MAX(4)) counter(.clk(KEY_input[2] & KEY_input[1]), .clr(KEY_input[3]), .dir(count_dir), .Q(clkSpeed)); 
	
//	always @(KEY_input[2], KEY_input[1]) begin
//		count_dir = 0;
//		if (!IE) begin 		
//			if (KEY_input[2] == 0) count_dir = 0;
//			if (KEY_input[1] == 0) count_dir = 1;
//		end
//	end
endmodule