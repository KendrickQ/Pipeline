`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/06 12:12:34
// Design Name: 
// Module Name: Control
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


// this module is about controling signals.
module Control(OpCode, Funct, IRQ,
	PCSrc, Branch, RegWrite, RegDst, 
	MemRead, MemWrite, MemtoReg, 
	ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUOp);
	input IRQ;
//	input XADR;
	input [5:0] OpCode;
	input [5:0] Funct;
	output reg [2:0] PCSrc; // to use the 'case' clauses, I change the wire to the reg type;
	output reg Branch;
	output reg RegWrite;
	output reg [1:0] RegDst;
	output reg MemRead;
	output reg MemWrite;
	output reg [1:0] MemtoReg;
	output reg ALUSrc1;
	output reg ALUSrc2;
	output reg ExtOp;
	output reg LuOp;
	output [3:0] ALUOp;
	
	// Your code below
	always @(*) begin
	   if (IRQ) begin
	       PCSrc = 3'b011;
	   end
	  
	    else begin
            case(OpCode)
                6'd0:begin//R-type operation
                    if(Funct >= 6'h20 && Funct <= 6'h27) begin
                        PCSrc = 3'b000;
                        Branch = 0;
                        RegWrite = 1;
                        RegDst = 2'b01;
                        MemWrite = 0;
                        MemtoReg = 2'b00;
                        ALUSrc1 = 0;
                        ALUSrc2 = 0;
                    end
                    if(Funct== 6'h00 || Funct== 6'h02 || Funct == 6'h03 )begin
                        PCSrc = 3'b000;
                        Branch = 0;
                        RegWrite = 1;
                        RegDst = 2'b01;
                        MemWrite = 0;
                        MemtoReg = 2'b00;
                        ALUSrc1 = 1;
                        ALUSrc2 = 0;
                    end
                    if(Funct == 6'h2a || Funct == 6'h2b)begin
                        PCSrc = 3'b000;
                        Branch = 0;
                        RegWrite = 1;
                        RegDst = 2'b01;
                        MemWrite = 0;
                        MemtoReg = 2'b00;
                        ALUSrc1 = 0;
                        ALUSrc2 = 0;
                    end
                    if(Funct == 6'h08 )begin
                        PCSrc = 3'b010;
                        Branch = 0;
                        RegWrite = 0;
                        MemWrite = 0;
                        
                    end
                    if(Funct == 6'h09 )begin
                        PCSrc = 3'b010;
                        Branch = 0;
                        RegWrite =1;
                        RegDst = 2'b10;
                        // MemRead =1;
                        MemWrite = 0;
                        MemtoReg = 2'b10;
                        
                    end
                end
                6'h23:begin // lw
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    MemRead = 1;
                    MemWrite = 0;
                    MemtoReg = 2'b01;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    ExtOp = 1;
                    LuOp = 0;
                end
                6'h2b:begin // sw
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 0;
                    // RegDst = 2'b00;
                    MemRead = 0;
                    MemWrite = 1;
                    // MemtoReg = 2'b01;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    ExtOp = 1;
                    LuOp = 0;
                end
                6'h0f:begin // lui
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    // MemRead =0;
                    MemWrite =0;
                    MemtoReg = 2'b00;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    LuOp = 1;
                end
                6'h08:begin
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    MemWrite = 2'b00;
                    MemtoReg = 2'b00;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    ExtOp = 1;
                    LuOp = 0;
                end
                6'h09:begin
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    MemWrite = 2'b00;
                    MemtoReg = 2'b00;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    ExtOp = 1;
                    LuOp = 0;
                end
                6'h0c:begin
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    MemWrite = 2'b00;
                    MemtoReg = 2'b00;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    ExtOp = 0;
                    LuOp = 0;
                end
                6'h0a:begin // slti
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    MemWrite =0;
                    MemtoReg = 2'b00;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    ExtOp = 1;
                    LuOp = 0;
                end
                6'h0b:begin //sltiu
                    PCSrc = 3'b000;
                    Branch = 0;
                    RegWrite = 1;
                    RegDst = 2'b00;
                    MemWrite =0;
                    MemtoReg = 2'b00;
                    ALUSrc1 = 0;
                    ALUSrc2 = 1;
                    ExtOp = 1;
                    LuOp = 0;
                end
                6'h04:begin // beq
                    PCSrc = 3'b000;
                    Branch = 1;
                    RegWrite = 0;
                    MemWrite = 0;
                    ALUSrc1 = 0;
                    ALUSrc2 = 0;
                end
                6'h02:begin // j
                    PCSrc = 1;
                    Branch = 0;
                    RegWrite = 0;
                    MemWrite = 0;
                    
                end
                6'h03:begin //jal
                    PCSrc = 1;
                    Branch = 0;
                    RegWrite =1;
                    RegDst = 2'd2;
                    MemWrite = 0;
                    MemtoReg = 2'd2;
                end
            endcase
		end
	end
	// Your code above
	
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		3'b000;
		
	assign ALUOp[3] = OpCode[0];
	
endmodule