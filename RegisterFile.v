`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/07 00:31:11
// Design Name: 
// Module Name: RegisterFile
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



module RegisterFile(reset, clk, RegWrite, Read_register1, Read_register2, Write_register, Write_data, Read_data1, Read_data2);
	input reset, clk;
	input RegWrite;
	input [4:0] Read_register1, Read_register2, Write_register;
	input [31:0] Write_data;
	output reg [31:0] Read_data1, Read_data2;
	
	reg [31:0] RF_data[31:1];
	always @(*)begin
	   Read_data1 <= (Read_register1 == 5'b00000)? 32'h00000000: RF_data[Read_register1];
	   Read_data2 <= (Read_register2 == 5'b00000)? 32'h00000000: RF_data[Read_register2];
	end
	
	integer i;
	always @(*)
		if (reset) begin
			for (i = 1; i < 32; i = i + 1)
				RF_data[i] = 32'h10000000;
			RF_data[4] = 32'h00000000;
		end
		else if (RegWrite && (Write_register != 5'b00000))
			RF_data[Write_register] = Write_data;

endmodule
			