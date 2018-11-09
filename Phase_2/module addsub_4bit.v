module addsub_4bit (A, B, Sum_4bit, Ovfl);
input signed [3:0] A, B; //Input values
output signed [3:0] Sum_4bit; //sum output
output Ovfl; //To indicate overflow
wire [3:0] ripple;
full_adder_1bit FA0 (.bit_A(A[0]), .bit_B(B[0]), .bit_Cin(1'b0), .bit_Sum(Sum_4bit[0]), .bit_Cout(ripple[0]));
full_adder_1bit FA1 (.bit_A(A[1]), .bit_B(B[1]), .bit_Cin(ripple[0]), .bit_Sum(Sum_4bit[1]), .bit_Cout(ripple[1]));
full_adder_1bit FA2 (.bit_A(A[2]), .bit_B(B[2]), .bit_Cin(ripple[1]), .bit_Sum(Sum_4bit[2]), .bit_Cout(ripple[2]));
full_adder_1bit FA3 (.bit_A(A[3]), .bit_B(B[3]), .bit_Cin(ripple[2]), .bit_Sum(Sum_4bit[3]), .bit_Cout(ripple[3]));
assign Ovfl = ripple[2] ^ ripple[3];
endmodule
