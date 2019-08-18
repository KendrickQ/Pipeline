module InstructionMemory(Address, Instruction, check_bit);
	input [31:0] Address;
	output reg [31:0] Instruction;
	output wire check_bit;
	assign check_bit = Address[31];
	
	always @(*)
		case (Address[30:2]) // the initial is Address[9:2]
//		    31'd0:     Instruction <= {6'h23, 5'd0, 5'd4, 16'h0004 };
//			31'd1:     Instruction <= {6'h23, 5'd0, 5'd5,  16'h0008};
//			31'd2:     Instruction <= {6'h2b, 5'd0, 5'd4, 16'h008};
//			31'd3:     Instruction <= {6'h2b, 5'd0, 5'd5,  16'h004};
//			31'd4:     Instruction <= {6'h02, 26'h04};
			29'h00000000:    Instruction <= {6'h02, 26'h0000003}; // j Main( address = 32'h0000000c)
			29'h00000001:    Instruction <= {6'h02, 26'h0200035}; // j Interruption
			29'h00000002:    Instruction <= {6'h02, 26'h0300000}; // j Exception
		//Main:
			29'h00000003:     Instruction <= 32'h00008021; //move $s0, $0
			29'h00000004:     Instruction <= 32'h00008821; // move $s1, $0
			29'h00000005:     Instruction <= 32'h8e120000; // lw $s2, 0($s0)
			29'h00000006:     Instruction <= 32'h0012a021; // move $s4, $s2
			29'h00000007:     Instruction <= 32'h22100004; // addi $s0, $s0, 4
			29'h00000008:     Instruction <= 32'h0c100007; // jal bsort
			29'h00000009:     Instruction <= 32'h08100034; // j exit 
		//bsort (Address = 0x0040001c)
			29'h00100007:     Instruction <= 32'h23bdffec; // addi $sp, $sp, -20
			29'h00100008:     Instruction <= 32'hafbf0010; // sw $ra, 16($sp)
            29'h00100009:     Instruction <= 32'hafb3000c; // sw $s3, 12($sp)
			29'h0010000a:    Instruction <= 32'hafb20008; // sw $s2, 8($sp)
			29'h0010000b:    Instruction <= 32'hafb10004;// sw $s1, 4($sp) 
			29'h0010000c:    Instruction <= 32'hafb00000; // sw $s0, 0($sp)
			29'h0010000d:    Instruction <= 32'h00102021; //move $a0, $s0
			29'h0010000e:    Instruction <= 32'h00122821; // move $a1, $s2
			29'h0010000f:    Instruction <= 32'h00008021; // move $s0, $0
		// loopbody 1
			29'h00100010:    Instruction <= 32'h0205082a; // bge $s0, $a1, exit1
			29'h00100011:    Instruction <= 32'h10200014;
			29'h00100012:    Instruction <= 32'h2211ffff; // addi $s1, $s0, -1
		// loopbody 2
			29'h00100013:    Instruction <= 32'h0220082a; // blt $s1, $0, exit2
			29'h00100014:    Instruction <= 32'h1420000f; 
			29'h00100015:    Instruction <= 32'h00114880; // sll $t1, $s1, 2
			29'h00100016:    Instruction <= 32'h00895020; // add $t2, $a0, $t1
			29'h00100017:    Instruction <= 32'h8d4b0000; // lw $t3, 0($t2)
			29'h00100018:    Instruction <= 32'h8d4c0004; // lw $t4, 4($t2)
			29'h00100019:    Instruction <= 32'h018b082a;// ble $t3, $t4, exit2
			29'h0010001a:    Instruction <= 32'h10200009;
			29'h0010001b:    Instruction <= 32'h00049021; //move $s2, $a0
			29'h0010001c:    Instruction <= 32'h00059821; // move $s3, $a1
			29'h0010001d:    Instruction <= 32'h00122021; // move $a0, $s2
			29'h0010001e:    Instruction <= 32'h00112821; // move $a1, $s1
			29'h0010001f:    Instruction <= 32'h0c10002d; //jal swap
			29'h00100020:    Instruction <= 32'h00122021; // move $a0, $s2
			29'h00100021:    Instruction <= 32'h00132821; // move $a1, $s3
			29'h00100022:    Instruction <= 32'h2231ffff; // addi $s1, $s1, -1
			29'h00100023:    Instruction <= 32'h08100013; //j loopbody2
		// exit 2 
			29'h00100024:    Instruction <= 32'h22100001; // addi $s0, $s0, 1
			29'h00100025:    Instruction <= 32'h08100010; // j loopbody1
		// exit1
			29'h00100026:    Instruction <= 32'h8fb00000; // lw $s0, 0($sp)
			29'h00100027:    Instruction <= 32'h8fb10004; //lw $s1, 4($sp)
			29'h00100028:    Instruction <= 32'h8fb20008; //lw $s2, 8($sp)
			29'h00100029:    Instruction <= 32'h8fb3000c; //lw $s3, 12($sp)
			29'h0010002a:    Instruction <= 32'h8fbf0010; //lw $ra, 16($sp)
			29'h0010002b:    Instruction <= 32'h23bd0014; // addi $sp, $sp, 20
			29'h0010002c:    Instruction <= 32'h03e00008; //jr $ra
		// swap
			29'h0010002d:    Instruction <= 32'h00054880; // sll $t1, $a1, 2
			29'h0010002e:    Instruction <= 32'h00894820;
			29'h0010002f:    Instruction <= 32'h8d280000;
			29'h00100030:    Instruction <= 32'h8d2a0004;
			29'h00100031:    Instruction <= 32'had280004;
			29'h00100032:    Instruction <= 32'had2a0000;
			29'h00100033:    Instruction <= 32'h03e00008;
		//exit 
			29'h00100034:    Instruction <= 32'h08100034;
//            29'h00100034:    Instruction <= 32'h01111111;
			
		//Interruption (Address = 0x00200035)
		     29'h00200035:    Instruction <=32'h03400008; // jr $26
		     
		// Exception
		     29'h00300000:    Instruction <= {6'h02, 26'h0300000};
		     29'h00300001:    Instruction <=32'h03400008; // jr $26
		default: Instruction <= 32'h00000000;
		endcase
		
endmodule
