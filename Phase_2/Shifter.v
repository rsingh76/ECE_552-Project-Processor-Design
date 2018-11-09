module Shifter (Shift_Out, Shift_In, Shift_Val, Mode);
input signed [15:0] Shift_In; // This is the input data to perform shift operation on
input [3:0] Shift_Val; // Shift amount (used to shift the input data)
input Mode; // To indicate 0=SLL or 1=SRA
output reg signed [15:0] Shift_Out; // Shifted output data

always @* begin
       case(Mode)
        1'b0: begin
	     case(Shift_Val)
			4'b0000 : Shift_Out = {Shift_In[15:0]};
			4'b0001 : Shift_Out = {Shift_In[14:0], 1'b0};
			4'b0010 : Shift_Out = {Shift_In[13:0], {2{1'b0}}};
			4'b0011 : Shift_Out = {Shift_In[12:0], {3{1'b0}}};
			4'b0100	: Shift_Out = {Shift_In[11:0], {4{1'b0}}};
			4'b0101	: Shift_Out = {Shift_In[10:0], {5{1'b0}}};
			4'b0110	: Shift_Out = {Shift_In[9:0], {6{1'b0}}};
			4'b0111	: Shift_Out = {Shift_In[8:0], {7{1'b0}}};
			4'b1000	: Shift_Out = {Shift_In[7:0], {8{1'b0}}};
			4'b1001	: Shift_Out = {Shift_In[6:0], {9{1'b0}}};
			4'b1010	: Shift_Out = {Shift_In[5:0], {10{1'b0}}};
			4'b1011	: Shift_Out = {Shift_In[4:0], {11{1'b0}}};
			4'b1100	: Shift_Out = {Shift_In[3:0], {12{1'b0}}};
			4'b1101	: Shift_Out = {Shift_In[2:0], {13{1'b0}}};
			4'b1110	: Shift_Out = {Shift_In[1:0], {14{1'b0}}};
			4'b1111	: Shift_Out = {Shift_In[0], {15{1'b0}}};
			default	: Shift_Out = Shift_In;
	      endcase
	end
	1'b1 : begin
	      case(Shift_Val)
			4'b0000 : Shift_Out = {{Shift_In[15:0]}};
			4'b0001 : Shift_Out = {Shift_In[15], Shift_In[15:1]};
			4'b0010 : Shift_Out = {{2{Shift_In[15]}}, Shift_In[15:2]};
			4'b0011 : Shift_Out = {{3{Shift_In[15]}}, Shift_In[15:3]};
			4'b0100 : Shift_Out = {{4{Shift_In[15]}}, Shift_In[15:4]};
			4'b0101	: Shift_Out = {{5{Shift_In[15]}}, Shift_In[15:5]};
			4'b0110 : Shift_Out = {{6{Shift_In[15]}}, Shift_In[15:6]};
			4'b0111 : Shift_Out = {{7{Shift_In[15]}}, Shift_In[15:7]};
			4'b1000 : Shift_Out = {{8{Shift_In[15]}}, Shift_In[15:8]};
			4'b1001 : Shift_Out = {{9{Shift_In[15]}}, Shift_In[15:9]};
			4'b1010 : Shift_Out = {{10{Shift_In[15]}}, Shift_In[15:10]};
			4'b1011 : Shift_Out = {{11{Shift_In[15]}}, Shift_In[15:11]};
			4'b1100 : Shift_Out = {{12{Shift_In[15]}}, Shift_In[15:12]};
			4'b1101 : Shift_Out = {{13{Shift_In[15]}}, Shift_In[15:13]};
			4'b1110	: Shift_Out = {{14{Shift_In[15]}}, Shift_In[15:14]};
			4'b1111	: Shift_Out = {{15{Shift_In[15]}}, Shift_In[15]};
			default	: Shift_Out = Shift_In;
	     endcase
	end
	default : Shift_Out = Shift_In;
	endcase
end
endmodule
