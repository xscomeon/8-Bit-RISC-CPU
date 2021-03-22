// mux.v

`timescale 1ns/1ns
`celldefine

module mux(out,sel,a,b);

output out;
input sel;
input a;
input b;

not(sel_,sel);
and(selb,sel,b);
and(sela,sel_,a);
or(out,selb,sela);
endmodule
`endcelldefine