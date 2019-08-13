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


module PipeLine(clk, reset, cathodes);
	input clk,reset;
	output wire [7:0] cathodes;
	
	
	// Timing logic
	//IF
	reg [31:0] PC;
	reg [31:0] PC_next;
	reg [2:0] PCSrc_IDEX;
	reg IFID_Flush;
	reg PC_Hold;
    reg IFID_Hold;
    reg Control_Hazard;
	assign cathodes = PC[7:0];
	reg IRQ;
	wire [31:0] ILLOP;
	assign ILLOP = 32'h80000004;
	
	wire [31:0] XADR;
	assign XADR = 32'h80000008;
	//ID
    wire [1:0] RegDst;
    wire Branch;
    wire MemRead;
    wire [1:0] MemtoReg;
    wire [3:0] ALUOp;
    wire ExtOp;
    wire LuOp;
    wire MemWrite;
    wire ALUSrc1;
    wire ALUSrc2;
    wire RegWrite;
    wire [2:0] PCSrc;
	// Control registers
    reg [1:0] RegDst_IDEX;
    reg Branch_IDEX;
    reg MemRead_IDEX;
    reg [1:0] MemtoReg_IDEX;
    reg [3:0] ALUOp_IDEX;
    reg ExtOp_IDEX;
    reg LuOp_IDEX;
    reg MemWrite_IDEX;
    reg ALUSrc1_IDEX;
    reg ALUSrc2_IDEX;
    reg RegWrite_IDEX;
    // Data registers
    reg [31:0] Databus1_IDEX;
    reg [31:0] Databus2_IDEX;
    reg [31:0] Databus3_IDEX;
    reg [4:0] Shamt_IDEX;
    reg [5:0] Funct_IDEX;
    reg [31:0] Ext_out_IDEX;
    reg [15:0] Imm_IDEX; 
    reg [31:0] PC_Plus4_IDEX;
    reg [25:0] Label_IDEX;
    reg [4:0] Rs_IDEX;
    reg [4:0] Rt_IDEX;
    reg [4:0] Rd_IDEX;
    reg IDEX_Flush;
    reg EXMEM_Flush;
    wire MEMWB_Flush;
   wire [31:0] Jump_target;
    reg [31:0] Jump_target_IDEX;
        
	always @(posedge clk or posedge reset) begin
		if(reset)
			PC <= 32'h00000000;
			
//		else if(PCSrc)
//		    PC <= 32'd0;
		else begin
			if(~PC_Hold) 
				PC <= PC_next;
			// PCHold here
		end
	end 
	
    wire Zero;
    
    
	wire [31:0] Instruction;
	InstructionMemory instruction_memory1(.Address(PC), .Instruction(Instruction));
	
	reg [31:0] Ins_IFID;
	wire is_lw;
	wire [4:0] lw_target;
	reg is_lw_IDEX;
	reg [4:0] lw_target_IDEX;
	assign is_lw = (Ins_IFID[31:26] == 6'h23) ? 1 : 0;
	assign lw_target = Ins_IFID[20:16];
	
	wire Load_use;
	assign Load_use = (is_lw_IDEX & (lw_target_IDEX == Ins_IFID[25:21] | lw_target_IDEX == Ins_IFID[20:16])) ? 1 : 0;
	// load use hazard and stall the pipeline
	
	
	always @(*)begin
		if (reset | ~Load_use ) begin
			PC_Hold = 0;
			IFID_Hold = 0;
			Control_Hazard = 0;
		end
		else begin
			if(Load_use) begin
				PC_Hold = 1;
				IFID_Hold = 1;
				//Control_Hazard = 1;
			end
			
		end
	end
	
	
	
	reg [31:0] PC_Plus4_IFID;
	always @(posedge clk or posedge reset) begin
	   if (reset | IFID_Flush) begin
		  Ins_IFID <= 32'h000000;
		  PC_Plus4_IFID <= 32'h00000000;
		  
		  
		  end
        else begin
          if( ~IFID_Flush & ~IFID_Hold) begin
            Ins_IFID <= Instruction;
            PC_Plus4_IFID <= PC + 4;
          end
		  // else begin
		      // Ins_IFID <= 32'h00000000;
		      // PC_Plus4_IFID <= 32'h00000000;
		  // end
		
		  end
	end 
	
	Control control1(//control signals
		.OpCode(Ins_IFID[31:26]), .Funct(Ins_IFID[5:0]), .IRQ(IRQ),
		.PCSrc(PCSrc), .Branch(Branch), .RegWrite(RegWrite), .RegDst(RegDst), 
		.MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUOp(ALUOp));
	
	reg [4:0] Write_register_IDEX;
	reg [4:0] Write_register_EXMEM;
	reg [4:0] Write_register_MEMWB;
	
//	always @(posedge clk or posedge reset) begin
//	   if(reset) begin
//	       Write_register_IDEX = 0;
//	   end
//	end
    
    	
	wire [31:0] Databus1, Databus2, Databus3;
	wire [4:0] Write_register;
	reg RegWrite_MEMWB;
//	reg [31:0] Databus3_WB;
//    always @(negedge clk)begin
//       Databus3_WB <= Databus3;
//    end
    assign Write_register = (RegDst == 2'b00)? Ins_IFID[20:16]: (RegDst == 2'b01)? Ins_IFID[15:11]: 5'b11111;
    
    
	RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(RegWrite_MEMWB), 
		.Read_register1(Ins_IFID[25:21]), .Read_register2(Ins_IFID[20:16]), .Write_register(Write_register_MEMWB),
		.Write_data(Databus3), .Read_data1(Databus1), .Read_data2(Databus2));
	
	wire [31:0] Ext_out;
	assign Ext_out = {ExtOp? {16{Ins_IFID[15]}}: 16'h0000, Ins_IFID[15:0]};// extended number 
	
	// Command Flush
	always @(*) begin
//	   if(PCSrc == 2'd1)
//	       IFID_Flush = 1;
//	   else begin
//	       IFID_Flush = 0;
//	   end
        if(reset) begin
            IFID_Flush = 0;
            IDEX_Flush = 0;
            EXMEM_Flush = 0;
            
            IRQ = 0;
        end
        else begin
            IFID_Flush = (PCSrc != 0 | (Branch_IDEX & Zero))?1:0;
            IDEX_Flush = (Branch_IDEX & Zero)?1:0;
        end
	end
//    assign EXMEM_Flush = (PCSrc == 0) ? 0 : 1;
	reg [5:0] OpCode_IDEX;
	always @(posedge clk or posedge reset)begin
//	   if(reset | IDEX_Flush | Control_Hazard)begin
	   
	    if(reset | IDEX_Flush | Control_Hazard)begin
            PCSrc_IDEX = 0;
            Branch_IDEX = 0;
            PC_Plus4_IDEX = 32'h00000000;
            Branch_IDEX = 0;
            MemRead_IDEX = 0;
            MemtoReg_IDEX = 0;
            ALUOp_IDEX = 0;
            ExtOp_IDEX = 0;
            LuOp_IDEX = 0;
            MemWrite_IDEX = 0;
            ALUSrc1_IDEX = 0;
            ALUSrc2_IDEX = 0;
            RegWrite_IDEX = 0;
            Databus2_IDEX = 0;
            Shamt_IDEX = 0;
            Funct_IDEX = 0;
            Databus3_IDEX = 0;
            Ext_out_IDEX = 0;
            Imm_IDEX = 0;
            Databus1_IDEX = 0;
            Write_register_IDEX = 0;
			is_lw_IDEX = 0;
			lw_target_IDEX = 0;
			OpCode_IDEX = 0;
	   end
	   else if (~IDEX_Flush)begin
            RegDst_IDEX <= RegDst;
            MemRead_IDEX <= MemRead;
            MemtoReg_IDEX <= MemtoReg;
            ALUOp_IDEX <= ALUOp;
            ExtOp_IDEX <= ExtOp;
            LuOp_IDEX <= LuOp;
            MemWrite_IDEX <= MemWrite;
            ALUSrc1_IDEX <= ALUSrc1;
            ALUSrc2_IDEX <= ALUSrc2;
            RegWrite_IDEX <= RegWrite;
            Databus1_IDEX <= Databus1;
            Databus2_IDEX <= Databus2;
            //		Databus3_IDEX <= Databus3;
            Shamt_IDEX <= Ins_IFID[10:6];
            Rs_IDEX <= Ins_IFID[25:21];
            Rt_IDEX <= Ins_IFID[20:16];
            Rd_IDEX <= Ins_IFID[15:11];
            Funct_IDEX <= Ins_IFID[5:0];
            Ext_out_IDEX <= Ext_out;
            Imm_IDEX <= Ins_IFID[15:0];
            Label_IDEX <= Ins_IFID[25:0];
            PCSrc_IDEX <= PCSrc;
            Branch_IDEX <= Branch;
            Jump_target_IDEX <= Jump_target;
            PC_Plus4_IDEX <= PC_Plus4_IFID;
            Write_register_IDEX <= Write_register;
			is_lw_IDEX <= is_lw;
			lw_target_IDEX <= lw_target;
			OpCode_IDEX <= Ins_IFID[31:26];
		end
	end 
	
	wire [1:0] Databus1_Forw;
	wire [1:0] Databus2_Forw;
    reg RegWrite_EXMEM;
	
	Forwarding forwarding1 (
	  .RegWrite_EXMEM(RegWrite_EXMEM), .RegWrite_MEMWB(RegWrite_MEMWB), .reset(reset), 
	  .Databus1_Forw(Databus1_Forw), .Databus2_Forw(Databus2_Forw),
	  .Read_register1(Rs_IDEX),. Read_register2(Rt_IDEX),
	  .Write_Register_EXMEM(Write_register_EXMEM),. Write_Register_MEMWB(Write_register_MEMWB)
	);
	
	
	//EX
	reg MemWrite_EXMEM;
	reg MemRead_EXMEM;
	reg [1:0] RegDst_EXMEM;
	reg [1:0] MemtoReg_EXMEM;
	reg [31:0] ALU_out_EXMEM;
	reg [31:0] Databus2_EXMEM;
	reg [31:0] PC_Plus4_EXMEM;
	reg [4:0] Rt_EXMEM;
	reg [4:0] Rd_EXMEM;
	
	wire [31:0] LU_out;
	assign LU_out = LuOp_IDEX? {Imm_IDEX, 16'h0000}: Ext_out_IDEX;
	
	wire [4:0] ALUCtl;
	wire Sign;
	
	ALUControl alu_control1(.ALUOp(ALUOp_IDEX), .Funct(Funct_IDEX),
	.ALUCtl(ALUCtl), .Sign(Sign));
	
	wire [31:0] ALU_out;
	wire [31:0] ALU_in1;
	wire [31:0] ALU_in1_target;
	wire [31:0] ALU_in2;
	wire [31:0] ALU_in2_target;
	
	assign ALU_in1_target = ALUSrc1_IDEX? {17'h00000, Shamt_IDEX}: Databus1_IDEX;
	assign ALU_in1 = (Databus1_Forw == 2'b10) ? Databus3 : (Databus1_Forw == 2'b01)? ALU_out_EXMEM : ALU_in1_target; 
	assign ALU_in2_target = ALUSrc2_IDEX? LU_out: Databus2_IDEX;
	assign ALU_in2 = (Databus2_Forw == 2'b10) ? Databus3 : (Databus2_Forw == 2'b01)? ALU_out_EXMEM : ALU_in2_target; 
	
	ALU alu1(.in1(ALU_in1), .in2(ALU_in2), .ALUCtl(ALUCtl), .OpCode_IDEX(OpCode_IDEX),
	.Sign(Sign), .out(ALU_out), .zero(Zero));
	
	reg [31:0] Branch_target;
	always @(*)begin
	   if(reset)
	       Branch_target = 32'd0;
	   else
	       Branch_target = (Branch_IDEX & Zero)? (PC_Plus4_IDEX) + {LU_out[29:0], 2'b00}: (PC + 32'd4); 
	end
 // attention to the wire connection
	

	assign Jump_target = {PC_Plus4_IFID[31:28], Ins_IFID[25:0], 2'b00};
	
	always @(*)begin
	   if (reset)
	       PC_next = 32'd0;
	   else
	       PC_next = (PCSrc == 2'b00)? Branch_target: (PCSrc == 2'b01)? Jump_target: Databus1;
//            PC_next = (PCSrc == 2'b00)? Branch_target: (PCSrc == 2'b01)? Jump_target: Databus1_IDEX;
	end
	
	always @(posedge clk or posedge reset)begin
	   if(reset)begin
            MemWrite_EXMEM = 0; 
            MemRead_EXMEM = 0;
            RegWrite_EXMEM = 0;
            RegDst_EXMEM = 0;
            MemtoReg_EXMEM = 0;
            ALU_out_EXMEM = 0;
            Databus2_EXMEM = 0;
            PC_Plus4_EXMEM = 0;
            Write_register_EXMEM = 0;
	   end
	   else if(~EXMEM_Flush)begin
            MemWrite_EXMEM <= MemWrite_IDEX;
            MemRead_EXMEM <= MemRead_IDEX;
            MemtoReg_EXMEM <= MemtoReg_IDEX;
            ALU_out_EXMEM <= ALU_out;
            Databus2_EXMEM <= Databus2_IDEX;
            PC_Plus4_EXMEM <= PC_Plus4_IDEX;
            RegWrite_EXMEM <= RegWrite_IDEX;
            RegDst_EXMEM <= RegDst_IDEX;
            Rt_EXMEM <= Rt_IDEX;
            Rd_EXMEM <= Rd_IDEX;
            Write_register_EXMEM <= Write_register_IDEX;
		end
		else begin
            MemWrite_EXMEM <= 0;
            MemRead_EXMEM <= 0;
            MemtoReg_EXMEM <= 0;
            ALU_out_EXMEM <= 0;
            Databus2_EXMEM <= 0;
            PC_Plus4_EXMEM <= 0;
            RegWrite_EXMEM <= 0;
            RegDst_EXMEM <= 0;
            Rt_EXMEM <= 0;
            Rd_EXMEM <= 0;
            Write_register_EXMEM <= 0;
		end
	end 
	//MEM
	wire [31:0] Read_data;
	
	
	
	DataMemory data_memory1(.reset(reset), .clk(clk), .Address(ALU_out_EXMEM), 
	.Write_data(Databus2_EXMEM), .Read_data(Read_data), .MemRead(MemRead_EXMEM), .MemWrite(MemWrite_EXMEM));
	
	reg [1:0] MemtoReg_MEMWB;
    reg [31:0] Read_data_MEMWB;
    reg [31:0] PC_Plus4_MEMWB;
	reg [31:0] ALU_out_MEMWB;
	reg [1:0] RegDst_MEMWB;
	reg [4:0] Rt_MEMWB;
	reg [4:0] Rd_MEMWB;
	
	always @(negedge clk)begin
	   if(reset)begin
            MemtoReg_MEMWB = 0;
            Read_data_MEMWB = 0;
            PC_Plus4_MEMWB = 0;
            ALU_out_MEMWB = 0;
            RegWrite_MEMWB = 0;
            RegDst_MEMWB = 0;
            Write_register_MEMWB = 0;
	   end
	   else begin
            MemtoReg_MEMWB <= MemtoReg_EXMEM;
            Read_data_MEMWB <= Read_data;
            RegWrite_MEMWB <= RegWrite_EXMEM;
            ALU_out_MEMWB <= ALU_out_EXMEM;
            PC_Plus4_MEMWB <= PC_Plus4_EXMEM;
            RegDst_MEMWB <= RegDst_EXMEM;
            Rt_MEMWB <= Rt_EXMEM;
            Rd_MEMWB <= Rd_EXMEM;
            Write_register_MEMWB <= Write_register_EXMEM;
		end
	end
	//WB
	
	assign Databus3 = (MemtoReg_MEMWB == 2'b00)? ALU_out_MEMWB: (MemtoReg_MEMWB == 2'b01)? Read_data_MEMWB: PC_Plus4_MEMWB;

endmodule