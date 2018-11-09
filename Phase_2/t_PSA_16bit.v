`timescale 1ns/1ns
module t_PSA_16bit();
 	reg [15:0] stim_A;
        reg [15:0] stim_B;
	wire psa_error; 
        wire [15:0] hw_sum;
	integer i, S1, S2, S3, S4;

	// instantiate UUT
	PSA_16bit iDUT_PSA(.A(stim_A), .B(stim_B), .Sum(hw_sum), .Error(psa_error));
	
	// monitor statement
	initial $monitor("%t:A=%b B=%b Sum=%b Error=%b",$time, stim_A, stim_B, hw_sum, psa_error);

	// stimulus generation
	initial begin
     for (i = 0; i<10; i = i+1) begin
		stim_A[15:0]= $random;
                stim_B[15:0]= $random;
		#10;
          S1 = $signed(stim_A[3:0]) + $signed(stim_B[3:0]);
          S2 = $signed(stim_A[7:4]) + $signed(stim_B[7:4]);
          S3 = $signed(stim_A[11:8]) + $signed(stim_B[11:8]); 
          S4 = $signed(stim_A[15:12]) + $signed(stim_B[15:12]); 
          if (S1 == $signed(hw_sum[3:0]) && S2 == $signed(hw_sum[7:4]) && S3 == $signed(hw_sum[11:8]) && S4 == $signed(hw_sum[15:12]) && psa_error == 1'b0)
	    $display("Correct PSA.");
          else 
            $display("Incorrect PSA.");
          end
         #10 $stop;
	end
endmodule
