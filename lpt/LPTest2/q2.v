module fab(clk, reset, s, in, op, out, done);
  input clk, reset, s;
  input [7:0] in;
  input [1:0] op;
  output [7:0] out;
  output done;

  reg done;
  reg [7:0] out;

  // define states
  `define Wait 4'b0000
  `define INIT1 4'b0001
  `define INIT2 4'b0010
  `define FIB1 4'b0011
  `define FIB2 4'b0100
  `define FIB3 4'b0101
  `define FIB4 4'b0110
  `define FACT1 4'b0111
  `define FACT2 4'b1000
  `define FACT3 4'b1001
  `define Pond 4'b1010
  
  reg [2:0] present_state, next_state;
  reg [7:0] A, B, C, sum;
  
  always @(posedge clk) begin
    if(reset) begin
      present_state = `Wait;
      next_state = `Wait;
      done = 1'b0;
    end // if reset
    else begin
      case(present_state)
	`Wait: begin
	  if(s == 1 & op == 2'b00) begin
	    next_state = `INIT1;
	  end
	  else if(s == 1 & op == 2'b01) begin
	    next_state = `FIB1;
	  end
	  else if(s == 1 & op == 2'b10) begin
	    next_state = `FACT1;
	  end
	  else next_state = `Wait;
	end

	`INIT1: begin
	  A = 8'b00000000;
	  B = 8'b00000001;
	  C = in;
	  next_state = `INIT2;
	  out = B;
	  done = 1'b1;
	end

	`INIT2: begin
	  next_state = `Pond;
	end

	`FIB1: begin
	  next_state = `FIB2;
	  sum = A + B;
	  C = in;
	 end

	`FIB2: begin
	  if(C !== 0) begin
	    A = B;
	    next_state = `FIB3;
	  end
	  else begin
	    next_state = `FIB4;
	    done = 1'b1;
	    out = B;
	  end
	end

	`FIB3: begin
	  B = sum;
	  C = C - 1;
	  next_state = `FIB2;
	end

	`FIB4: begin
	  next_state = `Pond;
	end

	`FACT1: begin
	  if(C !== 0) begin
	    B = B * C;
	    next_state = `FACT2;
	  end
	  else begin
	    done = 1'b1;
	    out = B;
	    next_state = `FACT3;
	  end
	end

	`FACT2: begin
	  C = C-1;
	  next_state = `FACT1;
	end

	`FACT3: begin
	  next_state = `Pond;
	end

	`Pond: begin
	  if(s == 1) next_state = `Pond;
	  else next_state = `Wait;
	end

      endcase
    end // reset if
  end //always block
endmodule