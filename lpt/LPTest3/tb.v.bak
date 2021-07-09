module tb;
  reg clk, reset;
  wire [2:0] pc;
 
  top_module DUT(clk,reset,pc);
  
  initial forever begin
      clk = 0; #5;
      clk = 1; #5;
  end

  initial begin
    reset = 1'b1;
    #10;
    if ( (DUT.MEM.mem[0] !== 9'b100101010) | 
         (DUT.MEM.mem[1] !== 9'b110111000) | 
         (DUT.MEM.mem[2] !== 9'b110111010) |
         (DUT.MEM.mem[3] !== 9'b000000000) |
         (DUT.MEM.mem[4] !== 9'b000000001) |
         (DUT.MEM.mem[5] !== 9'b000000101) |
         (DUT.MEM.mem[6] !== 9'b000000000) |
         (DUT.MEM.mem[7] !== 9'b111111111) ) begin
      $display("ERROR ** Memory not initialized properly");
      $stop;
    end
    reset = 1'b0;
    #10;
    if (pc !== 0) begin
      $display("ERROR ** PC did not reset to zero. (PC=%h)", pc);
      $stop;
    end
    #780;
    $display("INTERFACE OK.  NOTE: You are responsible for verifying the contents of DUT.MEM.mem are correct.");
    $stop; 
  end
endmodule
