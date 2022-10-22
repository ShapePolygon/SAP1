// masterMode : controls the mode of SAP1
//   0 : Read from RAM
//   1 : Write to RAM
//   2 : Run SAP1, display values
//    submode:
//       0 :
//   3 : Auto/Manual selection mode
//    submode:
//       0 : Manual, 1 : Auto
// SW_input : bit 8 & 9 are reserved for masterMode selection, other bits are used for input
// 	subMode0 : mode for RAM_Controller
// 	subMode3 : mode for ClockManager
// KEY_input : capture the input device to be distributed to other modules via KEY_out
// KEY_out   : a forward input mechanism from KEY_input (optional as inputs may tap directly from KEY_input, see Top file)
// IE : provides IE for other submodules, active low
//    0 : SAP1
//    1 : RAM_Controller
//    2 : Clock Manager
module InputManager(masterMode, subMode0, subMode3, IE, SW_input, KEY_input, SW_out, KEY_out);
	input [9:0] SW_input;
	input [3:0] KEY_input;
	
	output reg [7:0] SW_out = 0;
	output reg [3:0] KEY_out = 0;
	
	output [1:0] masterMode;
	output reg subMode0 = 0, subMode3 = 0;
	output reg [3:0] IE = 4'hf;
	
	assign masterMode = {SW_input[9], SW_input[8]};
	
	always @(SW_input, KEY_input, masterMode) begin
		IE = 4'hf;	
		SW_out = SW_input;
		KEY_out = KEY_input;
		
		// Read from RAM Mode
		if (masterMode == 0) begin
			// enable RAM Controller inputs
			IE[0] = 1;
			IE[1] = 0;
			IE[2] = 1;
			subMode0 = 0;
		end
		// Write to RAM Mode
		else if (masterMode == 1) begin
			// enable RAM Controller inputs
			IE[0] = 1;
			IE[1] = 0;
			IE[2] = 1;
			
			subMode0 = 1;
		end
		// Run Mode
		// Enable SAP1 and ClockManager
		else if (masterMode == 2) begin
			// enable SAP1 and Clock Manager only
			IE[0] = 0;
			IE[1] = 1;
			IE[2] = 0;
		end
		// Clock Select mode
		else if (masterMode == 3) begin
			// enable Clock Manager only
			IE[0] = 1;
			IE[1] = 1;
			IE[2] = 0;
			
			// subMode3 : 0 (manual), 1 (auto)
			if (SW_input[0] == 0) subMode3 = 0;
			else subMode3 = 1;
		end
		else
			IE = 4'hf;
	end
endmodule