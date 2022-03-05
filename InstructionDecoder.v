`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////


module InstructionDecoder(input [31:0] Inst,
                          output [5:0] opcode, Funct,
                          output [4:0] rs, rt, rd, shamt,
                          output [15:0] imm,
                          output [25:0] jumpt);

assign opcode = Inst[31:26]; // assign opcode to 6 MSB

// assignment for R-type Instructions
assign Funct = Inst[5:0];  // assign funt to 6 LSB
assign shamt = Inst[10:6]; // assign shamt to 5 nest 5 LSB
assign rd = Inst[15:11]; // assign rd to next 5 LSB
assign rt = Inst[20:16]; // assign rt to next 5 LSB
assign rs = Inst[25:21]; // assign rs to next 5 LSB

assign imm = Inst[15:0]; // Assign imm to 16 LSB

assign jumpt = Inst[25:0];
endmodule
