// controller 

`timescale 1ns/1ns
`define HLT 3'b000
`define SKZ 3'b001
`define ADD 3'b010
`define AND 3'b011
`define XOR 3'b100
`define LDA 3'b101
`define STO 3'b110
`define JMP 3'b111

module control
(
rd,
wr,
ld_ir,
ld_ac,
ld_pc,
inc_pc,
halt,
data_e,
sel,
opcode,
zero,
clk,
rst_
);

output rd;
output wr;
output ld_ir;
output ld_ac;
output ld_pc;
output inc_pc;
output halt;
output data_e;
output sel;
input [2:0] opcode;
input zero;
input clk;
input rst_;

reg rd;
reg wr;
reg ld_ir;
reg ld_ac;
reg ld_pc;
reg inc_pc;
reg halt;
reg data_e;
reg sel;
reg [2:0] nextstate;
reg [2:0] state;

//时序控制
always @(posedge clk or negedge rst_)
	if(rst_)
	state<=3'b000;
	else
	state<=nextstate;
	
//状态转移
always @ (negedge clk)		//必须使用格雷码编码，否则综合不过，独热码也可以，但综合效率低
begin
case(state)
3'b000 : nextstate <= 3'b001;
3'b001 : nextstate <= 3'b011 ;
3'b011 : nextstate <= 3'b010 ;
3'b010 : nextstate <= 3'b110 ;
3'b110 : nextstate <= 3'b111 ;
3'b111 : nextstate <= 3'b101 ;
3'b101 : nextstate <= 3'b100 ;
3'b100 : nextstate <= 3'b000 ;
endcase
end


always @(opcode or state or zero)
	begin:blk
	reg alu_op;
	alu_op = opcode==`ADD||opcode==`AND||opcode==`XOR||opcode==`LDA;
	
	case(state)
	3'b000: //0
		begin
		sel<=0;
		rd<=alu_op;
		ld_ir<=0;
		inc_pc<=(opcode==`SKZ)&zero|(opcode==`JMP);
		halt<=0;
		ld_pc<=opcode==`JMP;
		data_e<=!alu_op;
		ld_ac<=alu_op;
		wr<=opcode==`STO;
		end
	3'b001: //1
		begin
		{sel,rd,ld_ir,inc_pc,halt,ld_pc,data_e,ld_ac,wr}<=9'b1_0_0_0_0_0_0_0_0;
		end
	3'b010: //2
		begin
		{sel,rd,ld_ir,inc_pc,halt,ld_pc,data_e,ld_ac,wr}<=9'b1_1_0_0_0_0_0_0_0;
		end
	3'b011: //3
		begin
		{sel,rd,ld_ir,inc_pc,halt,ld_pc,data_e,ld_ac,wr}<=9'b1_1_1_0_0_0_0_0_0;
		end
	3'b100: //4
		begin
		{sel,rd,ld_ir,inc_pc,halt,ld_pc,data_e,ld_ac,wr}<=9'b1_1_1_0_0_0_0_0_0;
		end
	3'b101: //5
		begin
		{sel,rd,ld_ir,inc_pc,ld_pc,data_e,ld_ac,wr}<=8'b0_0_0_1_0_0_0_0;
		halt<=opcode==`HLT;
		end
	3'b110: //6
		begin
		{sel,ld_ir,inc_pc,halt,ld_pc,data_e,ld_ac,wr}<=8'b0_0_0_0_0_0_0_0;
		rd<=alu_op;
		end
	3'b111: //7
		begin
		sel<=0;
		rd<=alu_op;
		ld_ir<=0;
		inc_pc<=(opcode==`SKZ)&zero;
		halt<=0;
		ld_pc<=opcode==`JMP;
		data_e<=!alu_op;
		ld_ac<=0;
		wr<=0;
		end
	endcase
end
endmodule