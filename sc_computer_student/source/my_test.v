`timescale 1 ps / 1 ps
module my_test ();

reg Resetn,Clock,Mem_clk;
wire [31:0] Pc,Inst,Aluout,Memout;
wire        Imem_clk,Dmem_clk;

sc_computer com (
  .pc(Pc),
  .inst(Inst),
  .aluout(Aluout),
  .memout(Memout),
  .imem_clk(Imem_clk),
  .dmem_clk(Dmem_clk)
);

initial
begin
  Resetn=1;
  while(1)
  begin
  #50 Resetn=1;
  end
end

initial
begin
  Clock=0;
  while(1)
  begin
    #20 Clock=~Clock;
  end
end

initial
begin
  Mem_clk=0;
  while(1)
  begin
    #10 Mem_clk=~Mem_clk;
  end
end

endmodule //my_test
