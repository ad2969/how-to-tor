// question 2 of lab proficiency test 1
// author: Clarence Adrian
// sn: 60595170


module q2_tb;
	reg a, b;
	reg [1:0] c;
	
	initial begin
		a = 1'b1;
		b = 1'b1;
		c = 2'b01;
		#5;
		a = 1'b0;
		#5;
		b = 1'b0;
		#5;
		b = 1'b1;
		c = 2'b11;
		#10;
		a = 1'b1;
		b = 1'b0;
		#5;
		a = 1'b0;
		b = 1'b1;
		c = 2'b00;
		#5;
		a = 1'b1;
		#5;
	end
endmodule
