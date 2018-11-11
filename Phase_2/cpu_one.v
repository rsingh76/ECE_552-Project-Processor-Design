module cpu(clk, rst_n, hlt, pc);
//IO ports
input clk;
input rst_n;
output hlt;
output [15:0] pc;

//all initializations
wire Inst_enable;
wire [15:0] Inst;
wire Inst_wr; //write for imem - tied off to 1'b0 - unused
wire [15:0] Inst_data_in; //Tied off to 16'b0 - unused
wire [3:0] opcode;
wire [3:0] DstReg;
wire [3:0] SrcReg1;
wire [3:0] SrcReg2;
wire [3:0] imm_4bit;
wire [7:0] imm_8bit;
wire [8:0] imm_9bit;
wire [2:0] br_condition; //branch condition encoding
wire [15:0] SrcData1;
wire [15:0] SrcData2;
wire [15:0] DstData;
wire [15:0] SrcData2_or_Imm;
wire [15:0] SrcData1_pre;
wire br_true; //If this is true, B/BR will be taken
wire [2:0] flags_in;
wire [2:0] flags_out;
wire MemtoReg;
wire MemRead;
wire MemWrite;
wire RegWrite;
wire pc_overflow; //unused currently
wire br_overflow; //unused currently
wire [15:0]branch_pc;
wire [15:0]next_pc;
wire pc_wen;
wire [15:0]br_offset;
wire [15:0]pc_in;
wire [15:0] Dmem_out;
wire [15:0] Dmem_in;
wire [15:0] ALUOut;
wire Z, N, V, flag_wen;

//Opcode assignment
assign opcode = Inst[15:12];

//checking reset
assign Inst_enable = (~rst_n) ? 1'b0 : 1'b1;

//hlt instruction
assign hlt = (opcode == 4'b1111);

//PC register
assign pc_wen = (~rst_n | hlt) ? 1'b0 : 1'b1;
dflipflop_16bit program_counter(.q(pc), .d(pc_in), .wen(pc_wen), .clk(clk), .rst(~rst_n)); // 16 bit register to hold current pc value

//Imem
assign Inst_wr = 1'b0;
assign Inst_data_in = 16'b0;
memory1c IMEM(.data_out(Inst), .data_in(Inst_data_in), .addr(pc), .enable(Inst_enable), .wr(Inst_wr), .clk(clk), .rst(~rst_n));


//Assigns for RegFile Inputs
assign SrcReg1 = Inst[7:4]; //Always source register SrcReg1 -- ALU Src1
assign SrcReg2 = ((opcode == 4'b1000) | (opcode == 4'b1001) | opcode == 4'b1011 | opcode == 4'b1010) ? Inst[11:8] : Inst[3:0]; //Inst[11:8] is source (value to be stored in memory) for sw instruction, and source for LLB, LHB instructions
assign DstReg = Inst[11:8]; //Always destination register
assign RegWrite = ((opcode == 4'b1001) | (opcode == 4'b1100) | (opcode == 4'b1101) | (opcode == 4'b1111)) ? 1'b0 : 1'b1;

//Immediate fields
assign imm_4bit = Inst[3:0]; //Always immediate 4-bit field for LW, SW
assign imm_8bit = Inst[7:0]; //Always immediate 8-bit field for LLB, LHB
assign imm_9bit = Inst[8:0]; //Always immediate 9-bit field for B
assign br_condition = Inst[11:9]; //Always immediate 3-bit branch condition for flag checking

//Regfile
RegisterFile Regfile(.clk(clk), .rst(~rst_n), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(DstReg), .WriteReg(RegWrite), .DstData(DstData), .SrcData1(SrcData1_pre), .SrcData2(SrcData2));

//Choose SrcData2 or Imm (only for LW/SW) as per opcode
assign SrcData2_or_Imm = (opcode[3]) ?  {{11{imm_4bit[3]}}, imm_4bit, 1'b0} : SrcData2; //ALU Src2

//Enforcing LSB of address is 1'b0 for LW/SW
assign SrcData1 = (opcode[3]) ? (SrcData1_pre & 16'hFFFE) : SrcData1_pre; 

//ALUOp = 1 for Add, sub, xor, red, sll, sra, ror, paddsb, lw, sw. 
//assign ALUOp = (~opcode[3] | opcode == 4'b1001 | opcode == 4'b1000) ?  1'b1 : 1'b0;

//ALU - for ADD, SUB, RED, ROR, PADDSB, SLL, SRA, XOR, LW, SW.
ALU ALU_LW_SW(.Inst(opcode), .ALUIn1(SrcData1), .ALUIn2(SrcData2_or_Imm), .Shift_Val(imm_4bit), .ALUOut(ALUOut), .Z(Z), .V(V), .N(N));

//Writing Flag Registers
assign flags_in = {Z, V, N};
assign flag_wen = (opcode[3:1] == 3'b000) | (opcode == 4'b0010) | (opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110);
   //Flag Register
Flags flag(.flags_out(flags_out), .clk(clk), .rst(~rst_n), .wen(flag_wen), .flags_in(flags_in));

//RegWrite == 1'b0 for SW, B, BR, HLT
assign RegWrite = ((~opcode[3]) | (~opcode[2] & ~opcode[0]) | (opcode[1] & ~opcode[0]) | (~opcode[2] & opcode[1])) ? 1'b1 : 1'b0;

assign MemWrite = (opcode == 4'b1001) ? 1'b1 : 1'b0; //1'b1 for SW
assign MemRead = (opcode == 4'b1000) ? 1'b1 : 1'b0; //1'b1 for LW
assign MemtoReg =  (opcode == 4'b1000) ? 1'b1 : 1'b0; //1'b1 for LW, similar to MemRead

//Dmem
data_memory1c DMEM(.data_out(Dmem_out), .data_in(SrcData2), .addr(ALUOut), .enable(MemRead), .wr(MemWrite), .clk(clk), .rst(~rst_n));

//PC_Next adder
Adder_16bit PC_add (.A(pc), .B(16'h0002), .cin(1'b0), .Sat_Sum(next_pc), .Ovfl(pc_overflow));

//Branch adder
assign br_offset = {{6{imm_9bit[8]}}, imm_9bit, 1'b0};
Adder_16bit Br_add (.A(next_pc), .B(br_offset), .cin(1'b0), .Sat_Sum(branch_pc), .Ovfl(br_overflow));

//Branch or not based on opcode and br_true.
assign pc_in = (opcode[3:1] == 3'b110) ? (opcode[0] ? (br_true ? SrcData1 : next_pc) : (br_true ? branch_pc : next_pc)) : next_pc;

//DstData storage - LW, SW, LLB, LHB, B, BR, PCS, HLT Instructions
//Nothing for SW, B, BR, HLT - because we don't need to write anything, RegWrite == 1'b0

assign DstData = (opcode == 4'b1110) ? next_pc : //PCS
                  MemtoReg ? Dmem_out : //LW
                 (opcode[3:1] == 3'b101) ? (opcode[0] ? ((SrcData2 & 16'h00FF) | {imm_8bit, {8{1'b0}}}) : ((SrcData2 & 16'hFF00) | {{8{1'b0}}, imm_8bit})): //LLB opcode - 1010, LHB opcode - 1011 
                  ALUOut; //ALU Instructions - ADD, SUB, XOR, RED, PADDSB, SLL, ROR, SRA. Don't care for SW, B, BR, HLT since RegWrite == 0.

//Flag register setting
//assign Z = ((opcode[3:1] == 3'b000) & (~(|ALU_out))) 						 ? 1'b1 :
//	   ((opcode == 4'b0010) & (~(|ALU_out)))					         ? 1'b1 :
//	   (((opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110)) & (~(|ALU_out))) ? 1'b1 : 1'b0;

//assign N = (opcode[3:1] == 3'b000) ? ALU_out[15] : flags[0];
//assign V = (opcode[3:1] == 3'b000) ? overflow	 : flags[1];

//B, BR check condition based on flags
branch_control BR1(.br_condition(br_condition), .flags_out(flags_out), .br_true(br_true));

endmodule
