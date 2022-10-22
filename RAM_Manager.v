// acts as a multiplexer for the inout ports of SAP1 and RAM_Controller
module RAM_Manager(masterMode,
						A_Con, DQ_Con, CE_Con, WE_Con, OE_Con,
						A_SAP1, DQ_SAP1, CE_SAP1, WE_SAP1, OE_SAP1,
						A, DQ, CE, WE, OE);
	input [1:0] masterMode;
	
	input CE_Con, WE_Con, OE_Con;
	input [7:0] A_Con;
	inout [7:0] DQ_Con;
	
	input CE_SAP1, WE_SAP1, OE_SAP1;
	input [7:0] A_SAP1;				
	inout [7:0] DQ_SAP1;
	
	output  CE, WE, OE;
	output  [7:0] A;
	inout [7:0] DQ;
	
	reg [7:0] data_out; 
	reg [7:0] data_out_SAP;
	reg [7:0] data_out_Con;
	
	assign A  = (masterMode == 2) ? A_SAP1 : A_Con;
	assign CE = (masterMode == 2) ? CE_SAP1 : CE_Con;
	assign WE = (masterMode == 2) ? WE_SAP1 : WE_Con;
	assign OE = (masterMode == 2) ? OE_SAP1 : OE_Con;
	
	// output data_out during write mode
	assign DQ = (!CE && !WE) ? data_out : 8'bz;
	
	// output during read to SAP1
	assign DQ_SAP1 = (!CE_SAP1 && WE_SAP1  && !OE_SAP1) ? data_out_SAP : 8'bz;
	// output during read to Con
	assign DQ_Con =  (!CE_Con && WE_Con  && !OE_Con) ? data_out_Con : 8'bz;
	
	always @(*) begin
		if (masterMode == 2) begin
				data_out_SAP = DQ;
				data_out = DQ_SAP1;
		end 
		else begin
				data_out_Con = DQ;
				data_out = DQ_Con;
		end
	end
endmodule