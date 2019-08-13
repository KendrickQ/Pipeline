`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/07 00:27:43
// Design Name: 
// Module Name: InstructionMemory
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



module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		case (Address[9:2])
                    8'd0:     Instruction <= 32'h00008021;
                    8'd1:     Instruction <= 32'h00008821;
                    8'd2:     Instruction <= 32'h8e120000;
                    8'd3:     Instruction <= 32'h0012a021;
                    8'd4:     Instruction <= 32'h22100004;
                    8'd5:     Instruction <= 32'h0c100007;
                    8'd6:     Instruction <= 32'h08100034;
                    8'd7:     Instruction <= 32'h23bdffec;
                    8'd8:     Instruction <= 32'hafbf0010;
                    8'd9:     Instruction <= 32'hafb3000c;
                    8'd10:    Instruction <= 32'hafb20008;
                    8'd11:    Instruction <= 32'hafb10004;
                    8'd12:    Instruction <= 32'hafb00000;
                    8'd13:    Instruction <= 32'h00102021;
                    8'd14:    Instruction <= 32'h00122821;
                    8'd15:    Instruction <= 32'h00008021;
                    8'd16:    Instruction <= 32'h0205082a;
                    8'd17:    Instruction <= 32'h10200014;
                    8'd18:    Instruction <= 32'h2211ffff;
                    8'd19:    Instruction <= 32'h0220082a;
                    8'd20:    Instruction <= 32'h1420000f;
                    8'd21:    Instruction <= 32'h00114880;
                    8'd22:    Instruction <= 32'h00895020;
                    8'd23:    Instruction <= 32'h8d4b0000;
                    8'd24:    Instruction <= 32'h8d4c0004;
                    8'd25:    Instruction <= 32'h018b082a;
                    8'd26:    Instruction <= 32'h10200009;
                    8'd27:    Instruction <= 32'h00049021;
                    8'd28:    Instruction <= 32'h00059821;
                    8'd29:    Instruction <= 32'h00122021;
                    8'd30:    Instruction <= 32'h00112821;
                    8'd31:    Instruction <= 32'h0c10002d;
                    8'd32:    Instruction <= 32'h00122021;
                    8'd33:    Instruction <= 32'h00132821;
                    8'd34:    Instruction <= 32'h2231ffff;
                    8'd35:    Instruction <= 32'h08100013;
                    8'd36:    Instruction <= 32'h22100001;
                    8'd37:    Instruction <= 32'h08100010;
                    8'd38:    Instruction <= 32'h8fb00000;
                    8'd39:    Instruction <= 32'h8fb10004;
                    8'd40:    Instruction <= 32'h8fb20008;
                    8'd41:    Instruction <= 32'h8fb3000c;
                    8'd42:    Instruction <= 32'h8fbf0010;
                    8'd43:    Instruction <= 32'h23bd0014;
                    8'd44:    Instruction <= 32'h03e00008;
                    8'd45:    Instruction <= 32'h00054880;
                    8'd46:    Instruction <= 32'h00894820;
                    8'd47:    Instruction <= 32'h8d280000;
                    8'd48:    Instruction <= 32'h8d2a0004;
                    8'd49:    Instruction <= 32'had280004;
                    8'd50:    Instruction <= 32'had2a0000;
                    8'd51:    Instruction <= 32'h03e00008;
                    8'd52:    Instruction <= 32'h08100034;
			default: Instruction <= 32'h00000000;
		endcase
//        case(Address[9:2])
//        8'd0:Instruction <= 32'h20040003;
//		8'd1:Instruction <= 32'h0c100003;
//		8'd2:Instruction <= 32'h1000ffff;
//		8'd3:Instruction <=	32'h23bdfff8;
//		8'd4:Instruction <= 32'hafbf0004;
//		8'd5:Instruction <= 32'hafa40000;
//		8'd6:Instruction <= 32'h28880001;
//		8'd7:Instruction <= 32'h11000003;
//		8'd8:Instruction <= 32'h00001026;
//		8'd9:Instruction <= 32'h23bd0008;
//		8'd10:Instruction <= 32'h03e00008;
//		8'd11:Instruction <= 32'h2084ffff;
//		8'd12:Instruction <= 32'h0c100003;
//		8'd13:Instruction <= 32'h8fa40000;
//		8'd14:Instruction <= 32'h8fbf0004;
//		8'd15:Instruction <= 32'h23bd0008;
//		8'd16:Instruction <= 32'h00821020;
//		8'd17:Instruction <= 32'h03e00008;
//        default: Instruction <= 32'h00000000;
//    endcase
		
endmodule

