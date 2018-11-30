//Tag Array of 128  blocks
//Each block will have 1 byte
//BlockEnable is one-hot
//WriteEnable is one on writes and zero on reads

module MetaDataArray_t(input clk, input rst, input [15:0] DataIn, input Write, input Lru_en, input [63:0] BlockEnable, output [15:0] DataOut);
	MSet mset0[63:0]( .clk(clk), .rst(rst), .Din(DataIn[15:0]), .WriteEnable(Write), .Lru_en(Lru_en), .Enable(BlockEnable[63:0]), .Dout(DataOut[15:0]));
endmodule

module MSet(input clk, input rst, input [15:0] DataIn, input Write, input Lru_en, input Enable, output [15:0] DataOut);
	MBlock Mblk0 ( .clk(clk), .rst(rst), .Din(DataIn[7:0]), .WriteEnable(Write), .Lru_en(Lru_en), .Enable(Enable), .Dout(DataOut[7:0]));
	MBlock Mblk1 ( .clk(clk), .rst(rst), .Din(DataIn[15:8]), .WriteEnable(Write), .Lru_en(Lru_en), .Enable(Enable), .Dout(DataOut[15:8]));
endmodule


module MBlock( input clk,  input rst, input [7:0] Din, input WriteEnable, input Lru_en, input Enable, output [7:0] Dout);
	MCell mc[6:0]( .clk(clk), .rst(rst), .Din(Din[6:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[7:0]));
        MCell_lru lru( .clk(clk), .rst(rst), .Din(Din[7]), .Lru_en(Lru_en), .Enable(Enable), .Dout(Dout[7:0]));
endmodule

module MCell( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~WriteEnable) ? q:'bz;
	dff dffm(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));
endmodule

module MCell_lru( input clk,  input rst, input Din, input WriteEnable, input Lru_en, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~(Lru_en | WriteEnable)) ? q:'bz;
	dff dffm(.q(q), .d(Din), .wen(Enable & (Lru_en | WriteEnable)), .clk(clk), .rst(rst));
endmodule
