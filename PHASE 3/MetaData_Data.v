//Tag Array of 128  blocks
//Each block will have 1 byte
//BlockEnable is one-hot
//WriteEnable is one on writes and zero on reads

module MetaDataArray_Data(input clk, input rst, input [15:0] DataIn, input Write, input Lru_en, input [63:0] BlockEnable_0, input [63:0] BlockEnable_1, output [15:0] DataOut);
  MBlock_Data Mblk0[63:0]( .clk(clk), .rst(rst), .Din(DataIn[7:0]), .WriteEnable(Write), .Lru_en(Lru_en), .Enable(BlockEnable_0[63:0]), .Dout(DataOut[7:0]));
  MBlock_Data Mblk1[63:0]( .clk(clk), .rst(rst), .Din(DataIn[15:8]), .WriteEnable(Write), .Lru_en(Lru_en), .Enable(BlockEnable_1[63:0]), .Dout(DataOut[15:8]));
endmodule

module MBlock_Data( input clk, input rst, input [7:0] Din, input WriteEnable, input Lru_en, input Enable, output [7:0] Dout);
	MCell_t mc0( .clk(clk), .rst(rst), .Din(Din[0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[0]));
	MCell_t mc1( .clk(clk), .rst(rst), .Din(Din[1]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[1]));
	MCell_t mc2( .clk(clk), .rst(rst), .Din(Din[2]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[2]));
	MCell_t mc3( .clk(clk), .rst(rst), .Din(Din[3]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[3]));
	MCell_t mc4( .clk(clk), .rst(rst), .Din(Din[4]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[4]));
	MCell_t mc5( .clk(clk), .rst(rst), .Din(Din[5]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[5]));
	MCell_t mc6( .clk(clk), .rst(rst), .Din(Din[6]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[6]));
        MCell_t lru( .clk(clk), .rst(rst), .Din(Din[7]), .WriteEnable(WriteEnable | Lru_en), .Enable(Enable), .Dout(Dout[7]));
endmodule

module MCell_t( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~(WriteEnable)) ? q:'bz;
	dff dffm(.q(q), .d(Din), .wen(Enable & (WriteEnable)), .clk(clk), .rst(rst));
endmodule

/*module MCell_lru( input clk,  input rst, input Din, input WriteEnable, input Lru_en, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~(Lru_en | WriteEnable)) ? q:'bz;
	dff dffm(.q(q), .d(Din), .wen(Enable & (Lru_en | WriteEnable)), .clk(clk), .rst(rst)
