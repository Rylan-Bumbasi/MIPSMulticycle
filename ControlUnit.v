`timescale 1ns / 1ps
module ControlUnit(input CLK, RST,                 
                   input [5:0] opcode, Funct,
                   output reg MtoRFsel,
                              RFDSel,
                              IDSel,
                              ALUIn1Sel,
                              IRWE,
                              DMWE,
                              PCWE,
                              Branch,
                              RFWE,
                   output reg[1:0] ALUIn2Sel, 
                                   PCSel,
                                   ALUOp,
                   output reg [3:0]ALUSel);

localparam S0 = 0;
localparam S1 = 1;
localparam S2 = 2;
localparam S3 = 3;
localparam S4 = 4;
localparam S5 = 5;
localparam S6 = 6;
localparam S7 = 7;
localparam S8 = 8;
localparam S9 = 9;
localparam S10 = 10;
localparam S11 = 11;

reg [3:0] state, next_state;

always@(posedge CLK) begin
if(RST) state <= S0;
else state <= next_state;
end

always@(*) begin
case (state)
S0: begin // Fetch State
// MtoRFsel = 1'bX;
// RFDSel = 1'bX;
IDSel = 1'b0; // IDSel = 0
ALUIn1Sel = 1'b0; // ALUIn1Sel = 0
ALUIn2Sel = 2'b01; //ALUIn2Sel =  01
ALUOp = 2'b00; // ALUOp = 00
PCSel = 2'b00; // PCSel = 00 
IRWE = 1'b1; // IRWE = 1
PCWE = 1'b1; // PCWE = 1
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b0;
next_state = S1; // Next State Decode
end

S1: begin // Decode State
// MtoRFsel = 1'bX;
// RFDSel = 1'bX;
// IDSel = 1'bX;
ALUIn1Sel = 1'b0; // ALUIn1Sel = 0
ALUIn2Sel = 2'b10; //ALUIn2Sel = 10
ALUOp = 2'b00; // ALUOp = 00
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0; // PCWE = 0
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b0;

    case(opcode)
    6'b100011: next_state = S2; // LW
    6'b101011: next_state = S2; // SW
    6'b000000: next_state = S6; // R-TYPE
    6'b001000: next_state = S10; // ADDI
    6'b000100: next_state = S8; // Branch
    6'b000010: next_state = S9; // Jump
    default: next_state = S0;
    endcase


end // end for S1

S2: begin // MemAdr
// MtoRFsel = 1'bX;
// RFDSel = 1'bX;
// IDSel = 1'bX;
ALUIn1Sel = 1'b1; // ALUIn1Sel = 1
ALUIn2Sel = 2'b10; //ALUIn2Sel =  10
ALUOp = 2'b00; // ALUOp = 00
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b0;

    case(opcode)
    6'b100011: next_state = S3;
    6'b101011: next_state = S5;
    endcase
end // end for S2

S3: begin // Mem Read
// MtoRFsel = 1'bX;
// RFDSel = 1'bX;
IDSel = 1'b1; // IDSel = 1
// ALUIn1Sel = 1'bX; 
// ALUIn2Sel = 2'bXX;
// ALUOp = 2'bXX;
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b0;

next_state = S4;
end

S4: begin //Mem Writeback
MtoRFsel = 1'b1; // MtoRFsel = 1
RFDSel = 1'b0; // RDFSel = 0
// IDSel = 1'bX; 
// ALUIn1Sel = 1'bX; 
// ALUIn2Sel = 2'bXX;
// ALUOp = 2'bXX;
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b1; // RFWE = 1
next_state = S0;
end // End for S4

S5: begin // DM Writeback
// MtoRFsel = 1'bX;
// RFDSel = 1'bX;
IDSel = 1'b1; // IDSel = 1
// ALUIn1Sel = 1'bX; 
// ALUIn2Sel = 2'bXX;
// ALUOp = 2'bXX;
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b1; // DMWE = 1
Branch = 1'b0;
RFWE = 1'b0;
next_state = S0;
end // end for S5

S6: begin // Execute
// MtoRFsel = 1'bX;
// RFDSel = 1'bX;
// IDSel = 1'bX;
ALUIn1Sel = 1'b1;  // ALUIn1Sel = 1
ALUIn2Sel = 2'b00; // ALUIn2Sel = 00
ALUOp = 2'b10; // ALUOp = 10
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b0;
case(opcode)
    6'b000000: next_state = S7; 
    default: next_state = S0;
    endcase
end // Send for S6

S7: begin // ALUWriteBack
MtoRFsel = 1'b0; // MtoRFsel = 0
RFDSel = 1'b1; // RFDSel = 1
// IDSel = 1'bX;
// ALUIn1Sel = 1'bX;  
// ALUIn2Sel = 2'bXX; 
//ALUOp = 2'bXX; 
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b1; // RFWE = 1
next_state = S0;
end

S8: begin // Branch
// MtoRFsel = 1'bX; 
// RFDSel = 1'bX; 
// IDSel = 1'bX;
ALUIn1Sel = 1'b1; //ALUIn1Sel = 1
ALUIn2Sel = 2'b00; //ALUIn2Sel = 00
ALUOp = 2'b01; //ALUOp = 01
PCSel = 2'b01;//PCSel = 01
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b1; // Branch = 1
RFWE = 1'b0; 
next_state = S0;
end

S9: begin
// MtoRFsel = 1'bX; 
// RFDSel = 1'bX; 
// IDSel = 1'bX;
// ALUIn1Sel = 1'bX;  
// ALUIn2Sel = 2'bXX; 
//ALUOp = 2'bXX; 
PCSel = 2'b10; //PCSel = 10
IRWE = 1'b0;
PCWE = 1'b1; // PCWE = 1
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b0; 
next_state = S0;
end // End for S9

S10: begin
// MtoRFsel = 1'bX; 
// RFDSel = 1'bX; 
// IDSel = 1'bX;
ALUIn1Sel = 1'b1; //ALUIn1Sel = 1
ALUIn2Sel = 2'b10; //ALUIn2Sel = 10
ALUOp = 2'b00; //ALUOp = 00
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b0;
next_state = S11;
end // S10

S11: begin
MtoRFsel = 1'b0; // MtoRFSel = 0 
RFDSel = 1'b0; //RFDSel = 0 
// IDSel = 1'bX;
// ALUIn1Sel = 1'bX;  
// ALUIn2Sel = 2'bXX; 
//ALUOp = 2'bXX; 
// PCSel = 2'bXX;
IRWE = 1'b0;
PCWE = 1'b0;
DMWE = 1'b0;
Branch = 1'b0;
RFWE = 1'b1; //RFWE = 1
next_state = S0;
end// End for S11
endcase // endcase for State case

case(ALUOp)// Case block for ALUOp
    2'b00: ALUSel = 4'b0000; // Add
    2'b01: ALUSel = 4'b0001; // Subtract
    2'b10: begin // Look at Func
    if(Funct == 6'b100000) ALUSel =  4'b0000; // add function
    else if(Funct == 6'b100010) ALUSel = 4'b0001; // subtract function
    else if(Funct == 6'b100100) ALUSel = 4'b0111; // And Function
    else if(Funct == 6'b100101) ALUSel = 4'b1000; // Or Function
    else if(Funct == 6'b000000) ALUSel = 4'b0010; // SLL Function
    else if(Funct == 6'b000100) ALUSel = 4'b0100; // SLLV Function
    else if(Funct == 6'b000111) ALUSel = 4'b1011; // SRAV Function
    // else if(Funct == 6'b101010) ALUSel = 4' // Set Less than function must fix late
    end
    default: ALUSel = 4'bXXXX; // Default, set ALU Sel to 15
    endcase
end // end for always @(*)
endmodule
