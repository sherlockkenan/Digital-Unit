`timescale 1ps/1ps
module testbench;
reg RESETN,CLK,MEMCLK;
wire [31:0] PC,INST,EALU,MALU,WALU;
wire [31:0] out0,out1;
wire [31:0]  int0,int1;
assign int0=1,int1=1;
pipelined_computer pipelined_computer_inst
(
	.resetn(RESETN),
	.clock(CLK),
	.mem_clock(MEMCLK),
	.pc(PC),
	.inst(INST),
	.ealu(EALU),
	.malu(MALU),
	.walu(WALU),
	.out_port0(out0),
	.out_port1(out1),
	.in_port0(int0),
	.in_port1(int1)
);
initial
begin
	RESETN = 0;
	#10 RESETN = 1;
end
initial
begin
	CLK = 0;
	while (1) begin
		MEMCLK = ~CLK;
		#10 CLK = ~CLK;
	end
end

endmodule
