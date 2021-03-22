// clock.v

`timescale 1ns/1ns
module clock (clk);
output clk;
reg clk;
initial begin
	clk=0;
	forever begin
	#10 clk=1'b1;
	#10 clk=1'b0;
	end
end 
endmodule 