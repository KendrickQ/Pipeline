`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/07 09:56:56
// Design Name: 
// Module Name: testbench
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


module testbench();
	
	reg reset;
	reg clk;
	PipeLine pipeline1(.clk(clk), .reset(reset));
	
	initial begin
		reset = 1;
		clk =1;
		#100 reset =  0;
	end
	
	always #1000 clk = ~clk;
	
	
endmodule
