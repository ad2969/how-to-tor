// TEST BENCH FOR LPT 2 Q1.v

  `define A 3'b000
  `define B 3'b001
  `define C 3'b010
  `define D 3'b011
  `define E 3'b100

module q1_tb();
  reg clk, reset; // inputs
  reg [1:0] in;
  
  wire [2:0] out; // outputs

  reg err; // error indicator

  // module instantiation
  top_module DUT(clk, reset, in, out);

  initial begin
    // first clock (reset)
    reset = 1'b1;
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
    reset = 1'b0;

      if(DUT.present_state !== `A) begin err = 1'b1; $display("State is wrong"); end
      #5;

    #20;

    // first case, in == 2'b00
    in = 2'b00;

    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;

      if(DUT.present_state !== `A) begin err = 1'b1; $display("State is wrong"); end
      #5;

      if(out !== 3'b001) begin err = 1'b1; $display("Out is wrong"); end
      #5;

    #20;

    // second case, in == 2'b10 (move to B)
    in = 2'b10;

    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;

      if(DUT.present_state !== `B) begin err = 1'b1; $display("State is wrong"); end
      #5;

      if(out !== 3'b011) begin err = 1'b1; $display("Out is wrong"); end
      #5;

    #20;

    // third case, in == 2'b01 (move to C)
    in = 2'b01;

    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;

      if(DUT.present_state !== `C) begin err = 1'b1; $display("State is wrong"); end
      #5;

      if(out !== 3'b110) begin err = 1'b1; $display("Out is wrong"); end
      #5;

    #20;

    // fourth case, in = 2'b00 (move to D)
    in = 2'b00;

    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;

      if(DUT.present_state !== `D) begin err = 1'b1; $display("State is wrong"); end
      #5;

      if(out !== 3'b010) begin err = 1'b1; $display("Out is wrong"); end
      #5;

    #20;

    // fifth case, in = 2'b10 (move back to C)
    in = 2'b10;

    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;

      if(DUT.present_state !== `C) begin err = 1'b1; $display("State is wrong"); end
      #5;

      if(out !== 3'b110) begin err = 1'b1; $display("Out is wrong"); end
      #5;

    #20;

    // sixth case, in = 2'b11 (move to D)
    in = 2'b11;

    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;

      if(DUT.present_state !== `D) begin err = 1'b1; $display("State is wrong"); end
      #5;

      if(out !== 3'b010) begin err = 1'b1; $display("Out is wrong"); end
      #5;

    #20;

    // seventh case, reset to A
    in = 2'b11;

    reset = 1'b1;
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
    reset = 1'b0;

      if(DUT.present_state !== `A) begin err = 1'b1; $display("State is wrong, reset wrong"); end
      #5;

      if(out !== 3'b001) begin err = 1'b1; $display("Out is wrong, reset wrong"); end
      #5;

    #20;

  end
endmodule

 

  
