`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/11 14:02:48
// Design Name: 
// Module Name: Forwarding
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/11 10:52:45
// Design Name: 
// Module Name: forwarding
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Forwarding(
	RegWrite_MEMWB, RegWrite_EXMEM, reset,
	Databus1_Forw, Databus2_Forw, // control signals of Databus 1 and 2
	Read_register1, Read_register2, // IDEX stage
	Write_Register_EXMEM, Write_Register_MEMWB
);
	input reset;
	input RegWrite_MEMWB;
	input RegWrite_EXMEM;
	input [4:0] Write_Register_EXMEM;
	input [4:0] Write_Register_MEMWB;
	input [4:0] Read_register1;
	input [4:0] Read_register2;
	output reg [1:0] Databus1_Forw; // control the ALUin_1
	output reg [1:0] Databus2_Forw; // control the ALUin_2
	
	always @(*) begin
		if (reset) begin
			Databus1_Forw = 0;
			Databus2_Forw = 0;
		end
		else begin
			// EXMEM forwarding
			if ( RegWrite_EXMEM & (Write_Register_EXMEM == Read_register1) & (Write_Register_EXMEM != 0))
				Databus1_Forw = 1;
			else if ( RegWrite_MEMWB & (Write_Register_MEMWB == Read_register1) & (Write_Register_MEMWB != 0) & ( Read_register1 != Write_Register_EXMEM | ~RegWrite_EXMEM))
				Databus1_Forw = 2;
			else Databus1_Forw = 0;
			
			
			if ( RegWrite_EXMEM & (Write_Register_EXMEM == Read_register2) & (Write_Register_EXMEM != 0))
				Databus2_Forw = 1;
			else if ( RegWrite_MEMWB & (Write_Register_MEMWB == Read_register2) & (Write_Register_MEMWB != 0) & ( Read_register2 != Write_Register_EXMEM | ~RegWrite_EXMEM))
				Databus2_Forw = 2;
			else Databus2_Forw = 0;
		end
	end
endmodule

