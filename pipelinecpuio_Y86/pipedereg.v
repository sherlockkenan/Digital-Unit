module pipedereg( dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,
							djal,dpc4,clock,resetn,ewreg,em2reg,ewmem,ealuc,ealuimm,
							ea,eb,eimm,ern0,eshift,ejal,epc4 ); // ID/EXE 流水线寄存器
	input clock,resetn,dwreg,dm2reg,dwmem,djal,daluimm,dshift;
	input [31:0]da,db,dimm,dpc4;
	input [3:0]daluc;
	input [4:0]drn;
	
	output reg ewreg,em2reg,ewmem,ejal,ealuimm,eshift;
	output reg[31:0] ea,eb,epc4,eimm;
	output reg[3:0] ealuc;
	output reg[4:0] ern0;
	
	always@(negedge resetn or posedge clock)
		if(resetn==0)
			begin
				ewreg<=0;
				em2reg<=0;
				ewmem<=0;
				ejal<=0;
				ealuc<=0;
				ealuimm<=0;
				eshift<=0;
				epc4<=0;
				ea<=0;
				eb<=0;
				ern0<=0;
				eimm<=0;
			end
		else
			begin
				ewreg<=dwreg;
				em2reg<=dm2reg;
				ewmem<=dwmem;
				ejal<=djal;
				ealuc<=daluc;
				ealuimm<=daluimm;
				eshift<=dshift;
				epc4<=dpc4;
				ea<=da;
				eb<=db;
				eimm<=dimm;
				ern0<=drn;
			end
endmodule