module Shifter_2_bit_3_1(Shift_In, Mode_In, Enable, Shift_Out);

input[15:0] Shift_In;
input [1:0] Mode_In; 
input Enable;
output[15:0] Shift_Out;
reg [15:0] Shift_Out_pre;
//wire [1:0] Mode;

// mode 00:SLL
// mode 01:SRA
// mode 10:ROR

//assign Mode = (Mode_In == 2'b11) ? 2'b10 : Mode_In;

always @* begin
       case(Mode_In)
        2'b00: Shift_Out_pre = {{Shift_In[13:0]}, 2'b00};
        2'b01: Shift_Out_pre = {{2{Shift_In[15]}},Shift_In[15:2]};
        2'b10: Shift_Out_pre = {Shift_In[1:0],Shift_In[15:2]};
	default	: Shift_Out_pre = Shift_In;
	endcase
end 

assign Shift_Out = Enable ? Shift_Out_pre : Shift_In;

endmodule
