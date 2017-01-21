module pipeexe( ealuc,ealuimm,ea,eb,eimm,eshift,
						ern0,epc4,ejal,ern,ealu ); // EXE stage
	input ejal,ealuimm,eshift;
	input [3:0] ealuc;
	input [31:0] epc4,ea,eb,eimm;
	input [4:0] ern0;
	
	output [31:0] ealu;
	output [4:0] ern;
	
	wire [31:0] alua,alub,sa,ealu0,epc8;
	wire z;
	
	assign sa={eimm[5:0],eimm[31:6]};
	cla32 ret_addr(epc4,32'h4,1'b0,epc8);//epac8<=epc4+4
	mux2x32 alu_ina(ea,sa,eshift,alua);
	mux2x32 alu_inb(eb,eimm,ealuimm,alub);
	mux2x32 save_pc8(ealu0,epc8,ejal,ealu);
	assign ern= ern0 | {5{ejal}}; //清零 或 ern=ern0
	alu exealu(alua,alub,ealuc,ealu0,z);
	
endmodule