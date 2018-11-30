//One hot 64 bit
module Shifter_64bit(address_in, Shift_Out); //Choosing block-enable in data array
input [15:0] address_in;
wire [5:0] set = address_in[10:5]; //Set index bits

output [63:0] Shift_Out; //Final one hot output

wire [3:0] Shift_Val = set[3:0];
wire [15:0] Shift_Out_imm;

Shifter_16bit S0(.Shift_In(16'h0001), .Mode(2'b00), .Shift_Val(Shift_Val), .Shift_Out(Shift_Out_imm)); //SLL mode is 00

assign Shift_Out[15:0] = ((set[5] == 0) && (set[4] == 0)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[31:16] = ((set[5] == 0) && (set[4] == 1)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[47:32] = ((set[5] == 1) && (set[4] == 0)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[63:48] = ((set[5] == 1) && (set[4] == 1)) ? Shift_Out_imm : 16'h0000;

endmodule

//One hot 128 bit
module Shifter_128bit(address_in, Shift_Out); //Choosing block-enable in data array
input [15:0] address_in;
wire [6:0] set;
//assign [6:1] set = [10:5]address_in; //Set index bits 6 bits
assign set = {address_in[10:5], 1'b0};
output [127:0] Shift_Out; //Final one hot output

wire [3:0] Shift_Val = set[3:0];
wire [15:0] Shift_Out_imm;

Shifter_16bit S0(.Shift_In(16'h0001), .Mode(2'b00), .Shift_Val(Shift_Val), .Shift_Out(Shift_Out_imm)); //SLL mode is 00

assign Shift_Out[15:0] = ((set[6] == 0) && (set[5] == 0) && (set[4] == 0)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[31:16] = ((set[6] == 0) && (set[5] == 0) && (set[4] == 1)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[47:32] = ((set[6] == 0) && (set[5] == 1) && (set[4] == 0)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[63:48] = ((set[6] == 0) && (set[5] == 1) && (set[4] == 1)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[79:64] = ((set[6] == 1) && (set[5] == 0) && (set[4] == 0)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[95:80] = ((set[6] == 1) && (set[5] == 0) && (set[4] == 1)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[111:96] = ((set[6] == 1) && (set[5] == 1) && (set[4] == 0)) ? Shift_Out_imm : 16'h0000;
assign Shift_Out[127:112] = ((set[6] == 1) && (set[5] == 1) && (set[4] == 1)) ? Shift_Out_imm : 16'h0000;

endmodule
