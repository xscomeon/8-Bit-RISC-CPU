//TEST BNECH FOR SCALABLE MUX

`define width 8
`timescale 1ns/1ns

module mux_test;
reg[`width:1] a,b;
wire[`width:1] out;
reg sel;

//Instantiate the mux. Named mapping allows the designer to have freedom 
//with the order of port declarations.  #8 overrides the parameter(not a delay),
//and give the designer flexibility naming the parameter

scale_mux #(`width) m1(.out(out), .sel(sel), .a(a), .b(b));

initial 
	begin 
	// display results to the screen,and store them in an SHM  database
	
	$monitor ($stime,,"sel=%b a=%b b=%b out=%b",sel,a,b,out);
	$dumpvars(2,mux_test);
	
	// provide stimulus for the design 
	
		sel=0; b={`width{1'b0}}; a={`width{1'b1}};
	#5  sel=0; b={`width{1'b1}}; a={`width{1'b0}};
	#5  sel=1; b={`width{1'b0}}; a={`width{1'b1}};
	#5  sel=1; b={`width{1'b1}}; a={`width{1'b0}};
	#5  $finish;
	end
endmodule