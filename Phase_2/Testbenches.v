///////////////////////// TB_ADDER ////////////////////////////////////////////////////////

module tb_16bit_adder();
reg [15:0] stm_a, stm_b;		//stimulus inputs		
wire [15:0] sum_mon;		//sum output
wire ov_mon;			// overflow value from DUT
reg [15:0]sum_check;
reg result;
reg cin;
Adder_16bit iDUT(.A(stm_a), .B(stm_b), .Sat_Sum(sum_mon),.Ovfl(ov_mon), .cin(cin));

always begin

stm_a = $random();
   stm_b = $random();
   cin = 0;
#5 cin = 1;		

assign sum_check = cin ? (stm_a - stm_b) : (stm_a + stm_b) ; 
assign result = (sum_check == sum_mon)? 1:0;
end
endmodule

////////////////////////////////// TB_XOR /////////////////////////////////////////////////////

module tb_xor();

reg [15:0] A,B;
wire [15:0] out;

xor_16bit x1(.A(A), .B(B), .OUT(OUT));

always begin
#5 A = $random();
#5 B = $random();
end

endmodule


////////////////////////////// TB_PSA /////////////////////////////////////////////////////////////

module tb_PADDSB();

reg [15:0] A,B;
wire [15:0] out;
reg [15:0] sum_check;
reg result;
PADDSB PSA(.Sat_Sum(out), .A(A), .B(B));

always begin
#5 A = $random();
 B = $random();
	 sum_check[3:0] =  A[3:0] + B[3:0];
	 sum_check[7:4] =  A[7:4] + B[7:4]; 
	 sum_check[11:8] =  A[11:8] + B[11:8]; 
	 sum_check[15:12] =  A[15:12] + B[15:12];

	assign result = (sum_check == out)? 1:0;
end

endmodule

///////////////////////////// TB__REDUCTION ////////////////////////////////////////////////////////////

module tb_red();
reg [15:0] A,B;
wire [15:0] out;

RED reduction(.OUT(out), .A(A), .B(B));

always begin
#5 A = $random();
   B = $random();
end

endmodule


/////////////////////////////TB__ALU ///////////////////////////////////////////////////////////////////////
module tb_alu();

reg enable;
reg [3:0] opcode;
reg [15:0]A,B;

ALU DUT(.Inst(opcode), .ALUIn1(A), .ALUIn2(B), .ALUOut(), .Z(), .V(), .N());

initial begin

opcode = 4'b0000;				//add
A = $random();
B = $random();

#10
opcode = 4'b0001;				//sub
A = $random();
B = $random();

#10
opcode = 4'b0010;				//xor
A = $random();
B = $random();

#10
opcode = 4'b0011;				//red
A = $random();
B = $random();

#10
opcode = 4'b0100;				//sll
A = $random();
B = 16'h0003;

#10
opcode = 4'b0101;				//sra
A = $random();
B = 16'h0003;

#10
opcode = 4'b0110;				//ror
A = $random();
B = 16'h0003;

#10
opcode = 4'b0111;				//PADDSB
A = $random();
B = $random();

#10
opcode = 4'b1000;				//load
A = $random();
B = $random();


#10
opcode = 4'b1001;				// store
A = $random();
B = $random();
end


endmodule
