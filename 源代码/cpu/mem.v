// 32*8 memory

`timescale 1ns/1ns 

module mem (data,addr,read,write);
inout [7:0] data;
input [4:0] addr;
input read;
input write;

reg[7:0] memory[0:31];

assign data=(read)?memory[addr]:8'hz;

always @(posedge write)
begin 
memory[addr]=data[7:0];
end

endmodule