`timescale 1ns/1ns
module sc_computer_test;
reg CLOCK_50M;
reg RST_N;
reg MM_CLK;
wire [31:0] pc_,inst_;
wire clrn;
wire [31:0] in_port0,in_port1;
wire [31:0] out_port0,out_port1,out_port2,out_port3;
wire [31:0] mem_dataout;
wire [31:0] io_read_data;
wire [31:0] ealu,malu,walu;
assign in_port0=32'b1;
assign in_port1=32'b1;
assign clrn=1;
pipelined_computer  sc_computer_inst
(
.clock(CLOCK_50M),
.resetn(RST_N),
.mem_clock(MM_CLK),
.inst(inst_),
.pc(pc_),
.clrn(clrn),
.in_port0(in_port0),
.in_port1(in_port1),
.out_port0(out_port0),
.out_port1(out_port1),
.out_port2(out_port2),
.out_port3(out_port3),
.mem_dataout(mem_dataout),
.io_read_data(io_read_data),
.ealu(ealu),
.malu(malu),
.walu(walu)
);
initial
begin
CLOCK_50M = 0;
while (1)
MM_CLK = ~CLOCK_50M;
#20 CLOCK_50M = ~CLOCK_50M;
end
initial
begin
RST_N = 1;
while (1)
#20 RST_N = 1;
end

endmodule
