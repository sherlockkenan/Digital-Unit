module counter(clock,full,now,next);

	input clock,full;
	output now, next;
	reg [3:0] now;
	reg next;	
initial
   begin
	if (clock == 0)
	begin
		now <= now;
	end
	else
	begin
		now <= now + 1;
		next <= 0;
		if (now >= full)
			begin
				now <= 0;
				next <= 1;
			end
	end
	end
endmodule	