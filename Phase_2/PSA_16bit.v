module PSA_16bit (A, B, Sum, Error);
input [15:0] A, B; // Input data values
output [15:0] Sum; // Sum output
output Error; // To indicate overflows
wire [3:0] overflow;

addsub_4bit AS4_0 (.A(A[3:0]), .B(B[3:0]), .Sum_4bit(Sum[3:0]), .Ovfl(overflow[0]));
addsub_4bit AS4_1 (.A(A[7:4]), .B(B[7:4]), .Sum_4bit(Sum[7:4]), .Ovfl(overflow[1]));
addsub_4bit AS4_2 (.A(A[11:8]), .B(B[11:8]), .Sum_4bit(Sum[11:8]), .Ovfl(overflow[2]));
addsub_4bit AS4_3 (.A(A[15:12]), .B(B[15:12]), .Sum_4bit(Sum[15:12]), .Ovfl(overflow[3]));
assign Error = overflow[3] | overflow[2] | overflow[1] | overflow[0];

endmodule
