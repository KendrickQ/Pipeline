`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/07 16:38:31
// Design Name: 
// Module Name: ALU
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



module ALU(in1, in2, ALUCtl, OpCode_IDEX,
     Sign, out, zero);
	input [31:0] in1, in2;
	input [4:0] ALUCtl;
	input [5:0] OpCode_IDEX;
	input Sign;
	output reg [31:0] out;
	output zero;
	
//	assign zero = (out == 0);
    assign zero = (OpCode_IDEX == 6'h04 & out == 0) ? 1 :(OpCode_IDEX == 6'h05 & out != 0)? 1 : 
        (OpCode_IDEX == 6'h01 & out < 0) ? 1 : (OpCode_IDEX == 6'h06 & out <= 0) ? 1 : (OpCode_IDEX == 6'h07 & out>0) ? 1: 0;
	wire ss;
	assign ss = {in1[31], in2[31]};
	
	wire lt_31;
	assign lt_31 = (in1[30:0] < in2[30:0]);
	
	wire lt_signed;
	assign lt_signed = (in1[31] ^ in2[31])? 
		((ss == 2'b01)? 0: 1): lt_31;
	
	always @(*)
		case (ALUCtl)
			5'b00000: out <= in1 & in2;
			5'b00001: out <= in1 | in2;
			5'b00010: out <= in1 + in2;
			5'b00110: out <= in1 - in2;  // beq and sub
			5'b00111: out <= {31'h00000000, Sign? lt_signed: (in1 < in2)};
			5'b01100: out <= ~(in1 | in2);
			5'b01101: out <= in1 ^ in2;
			5'b10000: out <= (in2 << in1[4:0]);
			5'b11000: out <= (in2 >> in1[4:0]);
			5'b11001: out <= ({{32{in2[31]}}, in2} >> in1[4:0]);
			default: out <= 32'h00000000;
		endcase
	
endmodule
