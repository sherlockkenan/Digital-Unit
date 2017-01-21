module debounce(clk,in,out);
input  clk,in;
output out;

integer cnt;
reg state;

always @ (posedge clk) 
begin
if (in==state) cnt = cnt + 1'b1;
else cnt <= 0;

state<=in;
end
assign out= (cnt>=1000000) ? state : ~state;


endmodule