module pipeif( pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock ); 
	input [31:0] pc,bpc,da,jpc;
	input[1:0]pcsource;
	input mem_clock;
	output[31:0]npc,pc4,ins;
	wire [63:0] y86;
	reg [31:0] jump;
	reg [31:0] ins;
	initial
	begin
	jump[31:0]=32'b0;
	end
	//assign ins=y86[63:32];
	mux4x32 selectnpc(pc4,bpc,da,jpc,pcsource,npc);
	cla32 pcplus4(pc,jump,1'b0,pc4);
	lpm_rom_irom irom(pc[7:2],mem_clock,y86);
	always @ (*)
   case (y86[47:40])

	// irmovl ->addi
	8'h30:begin ins[31:26]<=6'b001000;ins[25:21]=5'b0;ins[20]<=0; ins[19:16]<=y86[35:32]+1; ins[15:8]<=8'b0; ins[7:0]<=y86[31:24]; jump[31:0]<=32'b11000;end
	// rmmovl ->sw
	8'h40:begin ins[31:26]=6'b101011; ins[25]=1'b0; ins[24:21]=y86[35:32]+1; ins[20]=0;ins[19:16]=y86[39:36]+1; ins[15:8]=8'b0; ins[7:0]=y86[31:24];  jump[31:0]<=32'b11000;end
	//mrmovl ->lw
	8'h50: begin ins[31:26]=6'b100011; ins[25]=1'b0;ins[24:21]=y86[35:32]+1;ins[20]=0;ins[19:16]=y86[39:36]+1;ins[15:8]=8'b0; ins[7:0]=y86[31:24]; jump[31:0]<=32'b11000;end 

	8'h00: begin

   //jmp->j
	if (y86[39:32]==8'h70)
	       begin 
			    ins[31:26]=6'b000010;ins[25:8]=16'b0; 
				 ins[7:0]=y86[31:24]; jump[31:0]<=32'b10100;
			 end 
			 //op->op
  else if(y86[15:8]==8'h60)
			 begin
			 ins[31:26]=6'b000000;
			 ins[25]=1'b0; ins[24:21]=y86[3:0]+1;
			 ins[20]=0; ins[19:16]=y86[7:4]+1; 
			 ins[15]=0; ins[14:11]=y86[3:0]+1; 
			 ins[10:6]=5'b00000;ins[5:0]=6'b100000; 
			 jump[31:0]<=32'b1000;
			 end 
  else if(y86[63:0]==64'b0)
          begin
	       ins[31:0]<=32'b0; 
	       jump[31:0]<=32'b100;
	       end 
	end
   endcase
endmodule 
