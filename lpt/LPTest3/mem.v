// *** DO NOT CHANGE OR SUBMIT THIS FILE ***
module LPT3RAM(clk,addr,write,din,dout);
  parameter data_width = 9; 
  parameter addr_width = 3;
  parameter filename = "data.txt";

  input  clk;
  input  [addr_width-1:0] addr;
  input  write;
  input  [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg    [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  assign dout = mem[addr];
  always @ (posedge clk) begin
    if (write)
      mem[addr] <= din;
  end 
endmodule

module vDFFE(clk,load,in,out);
  parameter k=1;
  input clk, load;
  input [k-1:0] in; 
  output reg [k-1:0] out;
  wire [k-1:0] next_out = load ? in : out;
  always @(posedge clk)
    out = next_out;
endmodule

module vDFF(clk,in,out);
  parameter k=1;
  input clk;
  input [k-1:0] in; 
  output reg [k-1:0] out;
  always @(posedge clk)
    out <= in; 
endmodule
