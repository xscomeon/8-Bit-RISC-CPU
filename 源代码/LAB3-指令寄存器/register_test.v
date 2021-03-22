// TEST BENCH FOR 8-BIT REGISTER

`timescale 1ns/1ns 

module register_test;

wire [7:0] out;
reg [7:0] data;
reg load;
reg rst_;

//例化寄存器
register r1
(
.data(data),
.out(out),
.load(load),
.clk(clk),
.rst_(rst_)
);

//例化时钟
clock c1
(
.clk(clk)
);

//检测信号
initial begin
$timeformat(-9,1,"ns",9);
$monitor("time=%t, clk=%b, data=%h, load=%b, out=%h",
		$time,clk,data,load,out);
$dumpvars(2,register_test);
end

//添加激励
initial begin
@(negedge clk) //初始化信号
	rst_=0;
	data=0;
	load=0;

@(negedge clk)  //复位信号
	rst_=1;
	
@(negedge clk)  //load hex55
	data='h55;
	load=1;

@(negedge clk)  //load hexAA
	data='hAA;
	load=1;
	
@(negedge clk)  //Disable load but register
	data='hCC;
	load=0;

@(negedge clk)  //Terminate simulation
	$finish;
end

endmodule
	





