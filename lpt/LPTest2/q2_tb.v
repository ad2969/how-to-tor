module q2_check_tb;
  reg clk, reset, s;
  reg [7:0] in;
  reg [1:0] op;
  wire [7:0] out;
  wire done;
  reg err;

  fab DUT(clk, reset, s, in, op, out, done);

  initial forever begin
    clk = 0; #5;
    clk = 1; #5;
  end

  initial begin
    err = 1'b0;
    reset = 1'b1;
    s = 1'b0;
    #10;              // your FSM should be reset 
    reset = 1'b0; 

    // 1. Test that wait state actually waits...
    #40;
    if (done) begin
      $display("ERROR ** done should not be set to 1 until your circuit is given an operation to perform");
      err = 1'b1;
      $stop;
    end

    // 2. Test INIT instruction
    op = 2'b00;
    in = 8'd4; 
    s = 1'b1;
    @(posedge done);  // waiting for circuit to finish INIT instruction (done should go to 1)
    @(negedge clk);
    // check that results of INIT look correct
    if (out !== 8'b1) begin  // recall !== is like != but does not let "don't cares" match 0 and 1
      $display("ERROR ** out should be 8'b00000001 after INIT");
      err = 1'b1;
      $stop;
    end
    // set input s to zero, should go back to waiting state 
    s = 1'b0;
    #10;
    if (done) begin
      $display("ERROR ** done should go back to zero after INIT when s is set to zero.");
      err = 1'b1;
      $stop;
    end
    if (~err) $display("INTERFACE OK");
    if (~err) $display("INIT simple check OK (NOTE: this test does NOT verify C was set correctly; do that manually)");

    // 2. Test FIB instruction
    op = 2'b01;
    in = {8{1'bx}};
    s =  1'b1;
    @(posedge done);  // waiting for circuit to finish FIB instruction (done should go to 1)
    @(negedge clk);
    // check that results of FIB look correct
    if ( (out !== 8'd5) & (out !== 8'd8) ) begin
      // Expect 5 because FIB goes 0, 1, 1, 2, 3, 5, 8, 13, ... and 0 and first one 1 are loaded by INIT;
      // We will also accept 8 (i.e., one extra cycle)
      $display("ERROR ** out looks incorrect after FIB instruction test (out = %b)", out);
      err = 1'b1;
      $stop;
    end
    // set input s to zero, should go back to waiting state 
    s = 1'b0;
    #10;
    if (done) begin
      $display("ERROR ** done should go back to zero after FIB when s is set to zero.");
      err = 1'b1;
      $stop;
    end
    if (~err) $display("very simple FIB test passes (does not mean autograder will pass all FIB tests).");
   
    // 3. INIT instruction for FACT
    op = 2'b00;
    in = 8'd3; 
    s = 1'b1;
    @(posedge done);  // waiting for circuit to finish INIT instruction (done should go to 1)
    @(negedge clk);
    // check that results of INIT look correct
    if (out !== 8'b1) begin  // recall !== is like != but does not let "don't cares" match 0 and 1
      $display("ERROR ** out should be 8'b00000001 after INIT");
      err = 1'b1;
      $stop;
    end
    // set input s to zero, should go back to waiting state 
    s = 1'b0;
    #10;
    if (done) begin
      $display("ERROR ** done should go back to zero after INIT when s is set to zero.");
      err = 1'b1;
      $stop;
    end
    if (~err) $display("INIT (2) simple check OK (NOTE: this test does NOT verify C was set correctly; do that manually)");


    // 4. Test FACT instruction
    op = 2'b10;
    in = {8{1'bx}};
    s =  1'b1;
    @(posedge done);  // waiting for circuit to finish FACT instruction (done should go to 1)
    @(negedge clk);
    // check that results of FACT look correct
    if (out !== 8'd6) begin // expect out to be equal to 3 factorial (3!) which is 3 * 2 * 1 which is equal to 6
      $display("ERROR ** out and/or ovf look incorrect after FACT instruction test (out = %b)", out);
      err = 1'b1;
      $stop;
    end
    // set input s to zero, should go back to waiting state 
    s = 1'b0;
    #10;
    if (done) begin
      $display("ERROR ** done should go back to zero after FACT when s is set to zero.");
      err = 1'b1;
      $stop;
    end
    if (~err) $display("very simple FACT test passes (does not mean autograder will pass all FACT tests).");
    #10;
    $stop;
  end
endmodule

