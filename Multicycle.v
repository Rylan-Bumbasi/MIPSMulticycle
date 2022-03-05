`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module Multicycle(input CLK, RST);

// Instruction Decoder Wires
wire [5:0] opcode, Funct;
wire [4:0] rs, rt, rd, shamt;
wire [15:0] imm;
wire [25:0] jumpt;

// Control Unit Wires
wire MtoRFsel;
wire RFDSel;
wire IDSel;
wire ALUIn1Sel;
wire IRWE;
wire DMWE;
wire PCWE;
wire Branch;
wire RFWE;
wire [1:0] ALUIn2Sel, PCSel, ALUOp;
wire [3:0] ALUSel;

//Memory File Wires
wire [31:0] MRDOut;

//RF Wires
wire[31:0] RFRD1Out, RFRD2Out;

// ALU Wires
wire [31:0] ALUOut;
wire zero, OVF;

wire [31:0] SEOut; // Sign Extension Out

// Register Wires
wire [31:0] DROut; 
wire [31:0] PCOut; 
wire [31:0] ALUOutROut;
wire [31:0] IROut;
wire [31:0] AOut;
wire [31:0] BOut;
wire [31:0] DROut;

//Mux Wires
wire [31:0] IDSelOut;
wire [31:0] RFDSelOut;
wire [31:0] ALUIn1SelOut;
wire [31:0] ALUIn2SelOut;
wire [31:0] PCSelOut;
wire [31:0] MtoRFSelOut;

//Jumpaddr Wires
wire [31:0] Jaddr;
assign Jaddr = {PCOut[31:26], jumpt};


InstructionDecoder ID1(.Inst(IROut),
                       .opcode(opcode), .Funct(Funct), .rs(rs), .rt(rt), .rd(rd), 
                       .shamt(shamt), .imm(imm), .jumpt(jumpt));
                       
ControlUnit CU1(.CLK(CLK), .RST(RST), .opcode(opcode), .Funct(Funct),
                .MtoRFsel(MtoRFsel), .RFDSel(RFDSel), .IDSel(IDSel), 
                .ALUIn1Sel(ALUIn1Sel), .IRWE(IRWE), .DMWE(DMWE), .PCWE(PCWE), 
                .Branch(Branch), .RFWE(RFWE), .ALUIn2Sel(ALUIn2Sel), .PCSel(PCSel), .ALUOp(ALUOp), .ALUSel(ALUSel));

MEM MEM(.CLK(CLK), .MWE(DMWE), .MWD(BOut), .MRA(IDSelOut), 
        .MRD(MRDOut));

SE SE1(.Imm(imm),
       .SImm(SEOut));

RF RF1(.CLK(CLK), .RFWE(RFWE), .RFR1(rs), .RFR2(rt), .RFWA(RFDSelOut), .RFWD(MtoRFSelOut),
       .RFRD1(RFRD1Out), .RFRD2(RFRD2Out));
       
ALU ALU1(.ALUin1(ALUIn1SelOut), .ALUin2(ALUIn2SelOut), .shamt(shamt), .sel(ALUSel),
         .zero(zero), .OVF(OVF), .ALUOut(ALUOut));
        
//Registers
register PC(.CLK(CLK), .RST(RST), .EN( (PCWE)|(Branch & zero) ), .Din(PCSelOut),
            .Dout(PCOut));

register IR(.CLK(CLK), .RST(0), .EN(IRWE), .Din(MRDOut),
            .Dout(IROut));
            
register DR(.CLK(CLK), .RST(0), .EN(1), .Din(MRDOut),
           .Dout(DROut));

register A(.CLK(CLK), .RST(0), .EN(1), .Din(RFRD1Out),
           .Dout(AOut));
           
register B(.CLK(CLK), .RST(0), .EN(1), .Din(RFRD2Out),
           .Dout(BOut));

register ALUOutReg(.CLK(CLK), .RST(0), .EN(1), .Din(ALUOut),
                   .Dout(ALUOutROut));

// Mux's
mux IDSelMUX(.sel(IDSel), .a((ALUOutROut) + 29), .b(PCOut),
             .out(IDSelOut));
             
mux RFDSelMUX(.sel(RFDSel), .a(rd), .b(rt),
              .out(RFDSelOut));
              
mux ALUIn1SelMUX(.sel(ALUIn1Sel), .a(AOut), .b(PCOut),
                 .out(ALUIn1SelOut));
                 
mux MtoRFSelMUX(.sel(MtoRFsel), .a(DROut), .b(ALUOutROut), 
             .out(MtoRFSelOut));
                 
TwoBitMux ALUIn2SelMUX(.sel(ALUIn2Sel), .a(BOut), .b(1), .c(SEOut), .d(0),
                       .out(ALUIn2SelOut));
                  
TwoBitMux PCSelMUX(.sel(PCSel), .a(ALUOut), .b(ALUOutROut), .c(Jaddr), .d(0),
                   .out(PCSelOut));
    
endmodule // End of Module
