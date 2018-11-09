`timescale 1ns /1ns

module t_RegisterFile();
reg stim_clk;
reg stim_rst;   
reg [3:0] stim_SrcReg1;
reg [3:0] stim_SrcReg2;
reg [3:0] stim_DstReg;
reg stim_WriteReg; 
reg [15:0] stim_DstData;
wire [15:0] stim_SrcData1;
wire [15:0] stim_SrcData2;
        

//Instantiate UUT
RegisterFile iDUT(.clk(stim_clk), .rst(stim_rst), .SrcReg1(stim_SrcReg1), .SrcReg2(stim_SrcReg2), .DstReg(stim_DstReg), .WriteReg(stim_WriteReg), .DstData(stim_DstData), .SrcData1(stim_SrcData1), .SrcData2(stim_SrcData2));
	
// monitor statement
initial $monitor("%t: clk=%b rst=%b SrcReg1=%b SrcReg2=%b DstReg=%b WriteReg=%b DstData=%b SrcData1=%b SrcData2=%b",$time, stim_clk, stim_rst, stim_SrcReg1, stim_SrcReg2, stim_DstReg, stim_WriteReg, stim_DstData, stim_SrcData1, stim_SrcData2);

  initial begin
      stim_rst = 1; //Intially reset
      stim_clk = 1;
      #120 stim_rst = 0; //Deassert reset slightly after 1 clock cycle
    end

    always #50 begin   // delay 1/2 clock period each time thru loop
      stim_clk = ~stim_clk;
    end
	
    always @(posedge stim_clk) begin
	//stim_SrcReg1 = $random;
        //stim_SrcReg2 = $random;
        stim_DstReg = 4'b0000;
        stim_DstData = 16'b1010101010101010;
        stim_WriteReg = 1'b1;
        stim_SrcReg1 = stim_DstReg;
        stim_SrcReg2 = $random;
        #500 $stop;
    end
endmodule
