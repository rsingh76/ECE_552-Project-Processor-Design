//Data and Meta-Data Array instantiations

module inst_cache(clk, rst, inst_addr, Write_tag_array, Write_data_array, metadataIn, DataIn, miss_inst_cache, DataOut);
input clk;
input rst;
input [15:0] inst_addr;
input Write_tag_array; //Write enable to write missing entry in data_array and metadata_array
input Write_data_array;
input [5:0] metadataIn; //Metadata array input from PC[15:10] address - 6 Tag bits 
input [15:0] DataIn; //Data input for data array from memory IMEM - 2 bytes (1 word)
//input [127:0] Shift_out; //from Shifter_128bit
output reg miss_inst_cache;
output [15:0] DataOut; //16 bits data array output
reg Lru_en;
reg Write_en;
reg [15:0] DataIn_imm; //LRU, Valid, Tag bits for 2 blocks = 1 Set
wire [15:0] metadataOut; //1 Set = 2 blocks metadat array output
//wire Shift_Out_two;
reg hit;
wire BlockEnable;
wire WordEnable;
//wire BlockEnable_data_final;
//wire BlockEnable_data;
reg Block_offset;
reg Write_en_data_array;


//assign BlockEnable = sel ? Shift_out : Shift_Out_two;
Shifter_64bit block_decoder(.address_in(inst_addr), .Shift_Out(BlockEnable));

MetaDataArray_t MDH(.clk(clk), .rst(~rst), .DataIn(DataIn_imm), .Write(Write_en), .Lru_en(Lru_en), .BlockEnable(BlockEnable), .DataOut(metadataOut));


//assign Shift_Out_two = Shift_out << 1;

always @ (inst_addr) begin
//BlockEnable = Shift_out;
Lru_en = 1'b0;
Write_en = 1'b0;
hit = 1'b0;
miss_inst_cache = 1'b0;
Write_en_data_array = 1'b0;
Block_offset = 1'b0;
//BlockEnable_data = {;

case((metadataOut[14] == 1'b1) && (metadataOut[13:8] == metadataIn)) //Valid and tag is equal //CACHE HIT OR MISS CASE
	1'b1: begin hit = 1'b1; //BLOCK 1 HIT OR MISS
	DataIn_imm = {1'b0, metadataOut[14:8], 1'b1, metadataOut[6:0]};
	Lru_en = 1'b1;
        Block_offset = 1'b1;
	end
	1'b0: begin //BLOCK 0 HIT OR MISS
		//BlockEnable = Shift_Out_two;
	case((metadataOut[6] == 1'b1) && (metadataOut[5:0] == metadataIn)) //Valid and tag is equal 
		1'b1: begin hit = 1'b1;
			DataIn_imm = {1'b1, metadataOut[14:8], 1'b0, metadataOut[6:0]};
			Lru_en = 1'b1;
                        Block_offset = 1'b0;
			end
		1'b0: begin
                      miss_inst_cache = 1'b1;
            		case(DataOut[14])  // check the valid bit of Block 1  //VALID BIT CHECK ON MISS CASE
              			1'b0: begin
                                      DataIn_imm = {1'b0, 1'b1, metadataIn, 1'b1, metadataOut[6:0]};
                                      Write_en = Write_tag_array;
                                      Write_en_data_array = Write_data_array;
                                      Lru_en = 1'b1;
                                      Block_offset = 1'b1;
                                      end
             		 	1'b1: begin
                		      case(DataOut[15])	// check the lru if valid is 1 for block 1 //LRU BIT CHECK ON MISS CASE
                			     1'b1: begin
                                                   DataIn_imm = {1'b0, 1'b1, metadataIn, 1'b1, metadataOut[6:0]}; // if this is lru then evict
                    		                   Write_en = Write_tag_array;
                                                   Write_en_data_array = Write_data_array;
                                                   Lru_en = 1'b1;
                                                   Block_offset = 1'b1;
                                                   end
                			     1'b0: begin
                                                   DataIn_imm = {1'b1, metadataOut[14:8], 1'b0, 1'b1, metadataIn}; // if this is not lru then irrespective of valid bit evict the other block
                    		                   Write_en = Write_tag_array;
                                                   Write_en_data_array = Write_data_array;
                                                   Lru_en = 1'b1;
                                                   Block_offset = 1'b0;
                                                   end
                                            default: begin
                                                     DataIn_imm = metadataOut;
                                                     Lru_en = 1'b0;
                                                     Write_en = 1'b0;
                                                     end
                                      endcase
                                      end
                                default: begin
                                         DataIn_imm = metadataOut;
                                         Lru_en = 1'b0;
                                         Write_en = 1'b0; 
                                         end
                        endcase
                     end
                default: begin 
                         DataIn_imm = metadataOut;
                         Lru_en = 1'b0;
                         Write_en = 1'b0;  
                         end
	endcase
      end
  default: begin
           DataIn_imm = metadataOut;
           Lru_en = 1'b0;
           Write_en = 1'b0; 
           end                
endcase
end //for starting always

//Shifter_128bit shifter128b(.address_in(inst_addr), .Shift_Out(BlockEnable_data));

//assign BlockEnable_data_final = Block_offset ? BlockEnable_data : BlockEnable_data << 1;

word_decoder wd(.addr(inst_addr[4:1]), .word_enable(WordEnable));

DataArray_t DAH(.clk(clk), .rst(~rst), .Block_offset(Block_offset), .DataIn(DataIn), .Write(Write_en_data_array), .BlockEnable(BlockEnable), .WordEnable(WordEnable), .DataOut(DataOut));

endmodule
