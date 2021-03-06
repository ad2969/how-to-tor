`define Reset 5'b00000
`define IF1 5'b00001
`define IF2 5'b00010
`define UpdatePC 5'b00011
`define Decode 5'b00100
`define MovImm 5'b00101
`define GetA 5'b00110
`define GetB 5'b00111
`define MovSh 5'b01000
`define Add 5'b01001
`define Cmp 5'b01010
`define And 5'b01011
`define Mvn 5'b01100

`define LoadAddr 5'b01101
`define LDR 5'b01110
`define STR 5'b01111
`define STR2 5'b10000
`define STR3 5'b10001

`define WriteReg 5'b10010
`define HALT 5'b10011

`define MNONE 2'b00
`define MWRITE 2'b01
`define MREAD 2'b10

module cpu(clk,reset,read_data,out,N,V,Z,w,mem_addr,mem_cmd, PC, state);
  input [15:0]    read_data; // connection from top to instruction register
  input           clk, reset;
  output [15:0]   out;
  output          N, V, Z, w;

  // Lab 7 additions
  output [8:0]    mem_addr; // connection from cpu to top
  output [1:0]    mem_cmd; // connection from state machine to top
  output [4:0]    state; // HEX display;

  // Instruction register
  wire [15:0]     irout;

  // Instruction decoder
  wire [15:0]     sximm5, sximm8;
  wire [2:0]      opcode, readnum, writenum;
  wire [1:0]      op, ALUop, shift;

  // State machine
  wire [2:0]      nsel; // one hot select
  wire [1:0]      vsel; // binary select for datapath in
  wire            loada, loadb, asel, bsel, loadc, loads, write;
  wire            load_ir;

  // Datapath
  wire [15:0]         datapath_out;
  output wire [8:0]   PC; // program counter
  wire [2:0]          stat_out; // status

  // Program counter
  wire            reset_pc, load_pc, addr_sel, load_addr; // new state machine outputs to pc section
  wire [8:0]      data_address; // contains address in memory
  wire [8:0]      added_pc = PC + 1'b1; // adds one to PC
  wire [8:0]      next_pc = reset_pc ? 9'b0 : added_pc; // if reset pc asserted next_pc = 0

  assign mem_addr = addr_sel ? PC : data_address; // selects address

  // Instantiations
  vDFFE #(16) IR(clk, load_ir, read_data, irout); // input changed to read_data
  vDFFE #(9) PCR(clk, load_pc, next_pc, PC); // instantiate pc
  vDFFE #(9) DAR(clk, load_addr, datapath_out[8:0], data_address); // instantiate data address register

  instruction_decoder ID(irout, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);

  state_machine SM(clk, reset, opcode, op, vsel, loada, loadb, asel, bsel, loadc, loads, write, nsel, w,
                   load_ir, load_pc, load_addr, addr_sel, reset_pc, mem_cmd, state);

  datapath DP(clk, readnum , vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
              writenum, write, read_data, sximm8, PC, sximm5, stat_out, datapath_out); // pls check

  // Status output
  assign Z = stat_out[0]; // Check code matches
  assign N = stat_out[1]; // Check code matches
  assign V = stat_out[2]; // Check code matches

  // Output
  assign out = datapath_out;
endmodule

// Instruction decoder
module instruction_decoder (irout, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);
  input [15:0]      irout;
  input [2:0]       nsel;
  output [15:0]     sximm5, sximm8;
  output [2:0]      opcode, readnum, writenum;
  output [1:0]      op, ALUop;
  output reg [1:0]  shift;

  wire [7:0] imm8 = irout[7:0];
  wire [4:0] imm5 = irout [4:0];
  wire [2:0] Rn = irout[10:8];
  wire [2:0] Rd = irout[7:5];
  wire [2:0] Rm = irout[2:0];

  Mux3 #(3) muxn(Rn, Rd, Rm, nsel, writenum);

  assign opcode = irout[15:13];
  assign op = irout[12:11];
  assign ALUop = irout[12:11];
  assign sximm5 = {{11{imm5[4]}}, imm5};
  assign sximm8 = {{8{imm8[7]}},imm8};

  always @(*) begin
    if (({opcode,op} == 5'b01100) | ({opcode,op} == 5'b10000)) shift = 2'b00;
    else shift = irout[4:3];
  end

  assign readnum = writenum;
endmodule

// State Machine
module state_machine(clk, reset, opcode, op, vsel, loada, loadb, asel, bsel, loadc, loads, write, nsel, w,
                     load_ir, load_pc, load_addr, addr_sel, reset_pc, mem_cmd, present_state);
  input [2:0]       opcode;
  input [1:0]       op;
  input             clk, reset;
  output reg [2:0]  nsel; // one hot select
  output reg [1:0]  vsel; // binary select for datapath in
  output reg        loada, loadb, asel, bsel, loadc, loads, write;
  output reg        w;
  output [4:0]      present_state;

  // Lab 7 additions
  output reg [1:0]  mem_cmd;
  output reg        load_ir, load_pc, load_addr, addr_sel, reset_pc;

  reg [4:0]         present_state, next_state;

  always @(posedge clk) begin
    if (reset) begin
                  next_state = `Reset;
                  reset_pc = 1'b1;
                  load_pc = 1'b1;
                end
    else begin
      case (present_state)
	`Reset: begin
		  next_state = `IF1;
                  vsel = 2'b00;
                  loada = 1'b0;
                  loadb = 1'b0;
                  asel = 1'b0;
                  bsel = 1'b0;
                  loadc = 1'b0;
                  loads = 1'b0;
                  write = 1'b0;
                  nsel = 3'b000;
                  w = 1'b1;
		  // added
		  mem_cmd = 2'b00;
		  load_ir = 1'b0;
		  load_addr = 1'b0;
		  addr_sel = 1'b0;
		end
        `IF1: begin
                next_state = `IF2;
                reset_pc = 1'b0;
                load_pc = 1'b0;
                addr_sel = 1'b1;
                mem_cmd = `MREAD; // read next instruction
                vsel = 2'b00;
                loada = 1'b0;
                loadb = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                write = 1'b0;
                nsel = 3'b000;
                w = 1'b1;
              end
        `IF2: begin
                next_state = `UpdatePC;
                load_ir = 1'b1;
              end
        `UpdatePC: begin
                     next_state = `Decode;
                     load_ir = 1'b0;
                     addr_sel = 1'b0;
                     mem_cmd = `MNONE;
                     load_pc = 1'b1;
                   end
        `Decode: begin
                   load_pc = 1'b0;
                   w = 1'b0;
                   if ({opcode,op} == 5'b11010) begin // Move immediate
                     next_state = `MovImm;
                   end
                   else if (({opcode,op} == 5'b11000) | ({opcode,op} == 5'b10111)) begin // Move shifted or move negative
                     next_state = `GetB;
                   end
                   else if ({opcode,op} == 5'b11100) begin
		     next_state = `HALT;
		   end
                   else begin // Add, compare or and
                      next_state = `GetA;
                   end
                 end
        `HALT: next_state = `HALT;
        `MovImm: begin
                     nsel = 3'b100; // selects Rn as register to write to
                     vsel = 2'b10; // selects sximm8 as data_in
                     write = 1'b1;
                     next_state = `IF1;
                  end
        `GetA: begin
                 nsel = 3'b100; // selects Rn
                 loada = 1'b1;
                 next_state = `GetB;
               end
        `GetB: begin
                 nsel = 3'b001; // selects Rm
                 loada = 1'b0;
                 loadb = 1'b1;
                 if ({opcode,op} == 5'b10100) begin // add
                   next_state = `Add;
                 end
                 else if ({opcode,op} == 5'b10101) begin // compare
                   next_state = `Cmp;
                 end
                 else if ({opcode,op} == 5'b10110) begin // and
                   next_state = `And;
                 end
                 else if ({opcode,op} == 5'b10111) begin // move negative
                   next_state = `Mvn;
                 end
                 else if ({opcode,op} == 5'b11000) begin // move shifted
                   next_state = `MovSh;
                 end
                 else if ({opcode,op} == 5'b01100) begin
                   next_state = `Add;
                 end
                 else if ({opcode,op} == 5'b10000) begin
                   next_state = `Add;
                 end
               end
        `Add: begin
                if ({opcode,op} == 5'b01100) begin // ldr
                  asel = 1'b0; // selects A
                  bsel = 1'b1; // selects B
                  loadb = 1'b0;
                  loadc = 1'b1; // enables C
                  next_state = `LoadAddr;
                end
                else if ({opcode,op} == 5'b10000) begin // str
                  asel = 1'b0; // selects A
                  bsel = 1'b1; // selects B
                  loadb = 1'b0;
                  loadc = 1'b1;
                  next_state = `LoadAddr;
                end
                else begin // Normal add
                  asel = 1'b0; // selects A
                  bsel = 1'b0; // selects B
                  loadb = 1'b0;
                  loadc = 1'b1;
                  next_state = `WriteReg;
                end
              end
        `LoadAddr: begin
                     load_addr = 1'b1; // enables data_address
                     addr_sel = 1'b0; // selects data_address
                     loadc = 1'b0;
                     if({opcode, op} == 5'b01100) next_state = `LDR;
                     else if({opcode, op} == 5'b10000) next_state = `STR;
                   end
        `Cmp: begin
                asel = 1'b0; // selects A
                bsel = 1'b0; // selects B
                loadb = 1'b0;
                loadc = 1'b1;
                loads = 1'b1; // output status
                next_state = `WriteReg;
              end
        `And: begin
                asel = 1'b0; // selects A
                bsel = 1'b0; // selects B
                loadb = 1'b0;
                loadc = 1'b1;
                next_state = `WriteReg;
              end
        `Mvn: begin
                asel = 1'b1; // selects zero
                bsel = 1'b0; // selects B
                loadb = 1'b0;
                loadc = 1'b1;
                next_state = `WriteReg;
              end
        `MovSh: begin
                  asel = 1'b1; // selects zero
                  bsel = 1'b0; // selects B
                  loadb = 1'b0;
                  loadc = 1'b1;
                  next_state = `WriteReg;
                end
        `LDR: begin
                //load_addr = 1'b1;
                mem_cmd = `MREAD;
                load_addr = 1'b0;
                next_state = `WriteReg;
              end
        `STR: begin
                load_addr = 1'b0;
                nsel = 3'b010; // selects Rd
                loadb = 1'b1;
                next_state = `STR2;
              end
        `STR2: begin
                 asel = 1'b1;
                 bsel = 1'b0;
                 loadb = 1'b0;
                 loadc = 1'b1;
                 next_state = `STR3;
               end
        `STR3: begin
                 mem_cmd = `MWRITE;
                 next_state = `IF1;
               end
        `WriteReg: begin
                     if ({opcode,op} == 5'b01100) begin
                       nsel = 3'b010; // selects Rd
                       vsel = 2'b11; // selects mdata
                       write = 1'b1;
                      // mem_cmd = `MNONE; // maybe move reset
                       next_state = `IF1;
                     end
                     else begin
                       nsel = 3'b010; // selects Rd
                       vsel = 2'b00; // selects datapath_out
                       write = 1'b1;
                       next_state = `IF1;
                     end
                   end
         default: begin
                  present_state = `IF1;
                  next_state = `IF1;
                  end
      endcase
    end
    present_state = next_state;
  end
endmodule

// 3 input multiplexer
module Mux3(a2, a1, a0, s, out) ;
  parameter k = 16; // width
  input [k-1:0] a0, a1, a2; // inputs
  input [2:0] s; // one-hot select
  output[k-1:0] out;
  wire [k-1:0] out = ({k{s[0]}} & a0) | ({k{s[1]}} & a1) | ({k{s[2]}} & a2);
endmodule
