//Data Array of 128 cache blocks, 2 block per set.
//Each block will have 8 words
//BlockEnable and WordEnable are one-hot
//WriteEnable is one on writes and zero on reads

module DataArray_t(input clk, input rst, input Block_offset, input [15:0] DataIn, input Write, input [63:0] BlockEnable, input [7:0] WordEnable, output [15:0] DataOut);
        wire [31:0] Set_Data;
	Set set0[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(Write), .Enable(BlockEnable), .WordEnable(WordEnable), .Dout(Set_Data));
        assign DataOut = Block_offset ? Set_Data[31:16] : Set_Data[15:0];
endmodule

module Set( input clk,  input rst, input [15:0] Din, input WriteEnable, input Enable, input [7:0] WordEnable, output [31:0] Dout);
       Block blk0( .clk(clk),  .rst(rst), .Din(Din), .WriteEnable(WriteEnable), .Enable(Enable), .WordEnable(WordEnable), .Dout(Dout[15:0]));
       Block blk1( .clk(clk),  .rst(rst), .Din(Din), .WriteEnable(WriteEnable), .Enable(Enable), .WordEnable(WordEnable), .Dout(Dout[31:16]));
endmodule

//16 byte (8 word) cache block
module Block( input clk,  input rst, input [15:0] Din, input WriteEnable, input Enable, input [7:0] WordEnable, output [15:0] Dout);
	wire [7:0] WordEnable_real;
	assign WordEnable_real = {8{Enable}} & WordEnable; //Only for the enabled cache block, you enable the specific word
	DWord dw[7:0]( .clk(clk), .rst(rst), .Din(Din), .WriteEnable(WriteEnable), .Enable(WordEnable_real), .Dout(Dout));
endmodule


//Each word has 16 bits
module DWord( input clk,  input rst, input [15:0] Din, input WriteEnable, input Enable, output [15:0] Dout);
	DCell dc[15:0]( .clk(clk), .rst(rst), .Din(Din[15:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[15:0]));
endmodule


module DCell( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~WriteEnable) ? q:'bz;
	dff dffd(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));
endmodule
