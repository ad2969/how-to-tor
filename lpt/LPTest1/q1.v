// question 1 of lab proficiency test 1
// author: Clarence Adrian
// sn: 60595170

module detect_cover(ain, bin, f);
	input[5:0] ain, bin;
	output[5:0] f;
	
	wire [5:0] checkain;
	wire [5:0] fdraft;
	wire checkall;
	
	assign checkain = ~ain | (ain & bin);
	assign checkall = &checkain[5:0];
	assign fdraft = ain & bin;
	assign f[5] = fdraft[5] & checkall;
	assign f[4] = fdraft[4] & checkall;
	assign f[3] = fdraft[3] & checkall;
	assign f[2] = fdraft[2] & checkall;
	assign f[1] = fdraft[1] & checkall;
	assign f[0] = fdraft[0] & checkall;

endmodule


module detect_tb();
	reg [5:0] inn;
	reg [5:0] inn2;
	wire [5:0] final;
	
	detect_cover dut(inn, inn2, final);

	initial begin
		inn = 6'b110000;
		inn2 = 6'b100100;
		#100;
		$display("final is %b", final);
	
		inn = 6'b110000;
		inn2 = 6'b110000;
		#100;
		$display("final is %b", final);

		inn = 6'b000010;
		inn2 = 6'b010110;
		#100;
		$display("final is %b", final);

		inn = 6'b111010;
		inn2 = 6'b110111;
		#100;
		$display("final is %b", final);

		inn = 6'b111010;
		inn2 = 6'b111111;
		#100;
		$display("final is %b", final);
	end
	
endmodule


	
	