module pipelined_computer (resetn,clock,mem_clock, pc,inst,ealu,malu,walu,
	clrn,out_port0,out_port1,out_port2,out_port3,in_port0,in_port1,mem_dataout,io_read_data);//added line
	
	//IO
	input clrn;
	input [31:0] in_port0,in_port1;
	output [31:0] out_port0,out_port1,out_port2,out_port3;
	output [31:0] mem_dataout;
	output [31:0] io_read_data;
	//added part
	
	input resetn, clock, mem_clock;
	output [31:0] pc,inst,ealu,malu,walu;
	//模块用于仿真输出的观察信号。缺省为 wire 型。
	wire [31:0] bpc,jpc,npc,pc4,ins, inst;
	// IF 取指令阶段。
	wire [31:0] dpc4,da,db,dimm;
	// ID 指令译码阶段。
	wire [31:0] epc4,ea,eb,eimm;
	// EXE 指令运算阶段。
	wire [31:0] mb,mmo;
	// MEM 访问数据阶段。
	wire [31:0] wmo,wdi;
	//WB 回写寄存器阶段。
	wire [4:0] drn,ern0,ern,mrn,wrn;
	//模块间互联，通过流水线寄存器传递结果寄存器号的信号线，寄存器号（ 32 个）为 5bit。
	wire [3:0] daluc,ealuc;
	//ID 阶段向 EXE 阶段通过流水线寄存器传递的 aluc 控制信号， 4bit。
	wire [1:0] pcsource;
	//CU 模块向 IF 阶段模块传递的 PC 选择信号， 2bit。
	wire wpcir;
	// CU 模块发出的控制流水线停顿的控制信号，使 PC 和 IF/ID 流水线寄存器保持不变。
	wire dwreg,dm2reg,dwmem,daluimm,dshift,djal; // id stage
	// ID 阶段产生，需往后续流水级传播的信号。
	wire ewreg,em2reg,ewmem,ealuimm,eshift,ejal; // exe stage
	//来自于 ID/EXE 流水线寄存器， EXE 阶段使用，或需要往后续流水级传播的信号。
	wire mwreg,mm2reg,mwmem; // mem stage
	//来自于 EXE/MEM 流水线寄存器， MEM 阶段使用，或需要往后续流水级传播的信号。
	wire wwreg,wm2reg; // wb stage
	//来自于 MEM/WB 流水线寄存器， WB 阶段使用的信号。
	assign out_port2=in_port0;
	assign out_port3=in_port1;
	pipepc prog_cnt ( npc,wpcir,clock,resetn,pc );
	pipeif if_stage ( pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock ); // IF stage
	pipeir inst_reg ( pc4,ins,wpcir,clock,resetn,dpc4,inst ); // IF/ID 流水线寄存器
	pipeid id_stage ( mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
							wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn,
							bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,
							daluimm,da,db,dimm,drn,dshift,djal ); // ID stage
	pipedereg de_reg ( dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,
							djal,dpc4,clock,resetn,ewreg,em2reg,ewmem,ealuc,ealuimm,
							ea,eb,eimm,ern0,eshift,ejal,epc4 ); // ID/EXE 流水线寄存器
	pipeexe exe_stage ( ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,ern,ealu ); // EXE stage
	pipeemreg em_reg ( ewreg,em2reg,ewmem,ealu,eb,ern,clock,resetn,
							mwreg,mm2reg,mwmem,malu,mb,mrn); // EXE/MEM 流水线寄存器
	//pipemem mem_stage ( mwmem,malu,mb,clock,mem_clock,mmo ); // MEM stage
	pipemem mem_stage ( mwmem,malu,mb,clock,mem_clock,mmo, 
		clrn,out_port0,out_port1,in_port0,in_port1,mem_dataout,io_read_data);//added line
	
	pipemwreg mw_reg ( mwreg,mm2reg,mmo,malu,mrn,clock,resetn,
							wwreg,wm2reg,wmo,walu,wrn); // MEM/WB 流水线寄存器
	mux2x32 wb_stage ( walu,wmo,wm2reg,wdi ); // WB stage
endmodule