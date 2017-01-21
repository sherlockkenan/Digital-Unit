module io_output(indt,outdt1,outdt0);
	input [31:0] indt;
	output [6:0] outdt1,outdt0;
	
	reg [3:0] num1,num0;
	

	sevenseg display_dt_1( num1, outdt1 );
	sevenseg display_dt_0( num0, outdt0 );
	
	always @ (indt)
	begin

		num1 = ( indt/10 ) % 10;
		num0 = indt % 10;
	end
	
endmodule
