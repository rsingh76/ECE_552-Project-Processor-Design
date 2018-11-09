module full_adder_1bit (bit_A, bit_B, bit_Cin, bit_Sum, bit_Cout );
input bit_A, bit_B;
input bit_Cin;
output bit_Sum;
output bit_Cout;
assign bit_Sum = bit_A ^ bit_B ^ bit_Cin;
assign bit_Cout = ((bit_A ^ bit_B) & bit_Cin) | (bit_A & bit_B);
endmodule
