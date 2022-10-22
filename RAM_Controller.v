// mode : select which port to place 8 bit input
//   0 : input address, read mode
//   1 : input data
// flush : active low, write data to RAM
// userInput : 8 bit input
// A : output connect to RAM
// DQ : bidirectional input-output from/to RAM
// CE : output CE to RAM
// WE : output WE to RAM
// OE : output OE to RAM
// IE : input enable, active low
module RAM_Controller(mode, flush, IE, userInput, A, DQ, CE, WE, OE, dataFromRAM);
	output reg CE, WE, OE;
	input mode, flush, IE;
	
	output reg [7:0] A;
	inout [7:0] DQ;
	
	reg [7:0] data_out = 0;				// data write to RAM
	output reg [7:0] dataFromRAM;		// data read from RAM
	
	input [7:0] userInput;

	// output data_out during write mode
	assign DQ = (!CE && !WE) ? data_out : 8'bz;
	
	always @(*) begin
		if (!IE && mode == 0) begin
			CE = 0;
			WE = 1;
			OE = 0;
			A = userInput;
			dataFromRAM = DQ;
		end
		if (!IE && mode == 1) begin
			CE = 0;
			if (flush == 0) begin
				WE = 0;
				OE = 1;
			end
			else begin
				WE = 1;
				OE = 0;
			end
			
			data_out = userInput;
			dataFromRAM = DQ;
		end
	end
endmodule