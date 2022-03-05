`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Rylan Bumbasi
// Course: COMPE 475
// Module Description: ALU
//////////////////////////////////////////////////////////////////////////////////

           
module ALU#(parameter WL = 32, selBits = 4)
          (input signed [WL - 1:0] ALUin1, ALUin2,
           input [4:0] shamt,
           input [selBits-1:0] sel, 
           output reg signed [WL-1:0] ALUOut,
           output reg OVF, zero);
           

always @* begin
    OVF = 0;
    zero = 0;
    case(sel)
    4'b0000: begin 
        ALUOut = ALUin1 + ALUin2; // 0:ADDITION
            if( (ALUin1[WL-1]) & (ALUin2[WL-1]) & !(ALUOut[WL-1])) OVF = 2'b1; // If -A + -B = +Out, OVERFLOW
            else if( !(ALUin1[WL-1]) & !(ALUin2[WL-1]) & (ALUOut[WL-1]) ) OVF = 2'b1; // If A + B = -Out, OVERFLOW
    end
    4'b0001: begin
        ALUOut = ALUin1 - ALUin2; // 1:SUBTRACTION
           if( (ALUin1[WL-1]) & !(ALUin2[WL-1]) & !(ALUOut[WL-1]) ) OVF = 2'b1; // If -A - B = +Out, OVERFLOW
           else if( !(ALUin1[WL-1]) & (ALUin2[WL-1]) & (ALUOut[WL-1]) ) OVF = 2'b1; // If A - -B = -Out, OVERFLOW
    end // SUBSTRATION
    4'b0010: ALUOut = ALUin2 << shamt; // 2: LOGICAL LEFT SHIFT
    4'b0011: ALUOut = ALUin2 >> shamt; // 3:LOGICAL RIGHT SHIFT
    4'b0100: ALUOut = ALUin2 << ALUin1[4:0]; // 4: LOGICAL VARIABLE LEFT SHIFT
    4'b0101: ALUOut = ALUin2 >> ALUin1[4:0]; // 5: LOGICAL VARIABLE RIGHT SHIFT
    4'b0110: ALUOut = ALUin2 >>> shamt; // 6: ARITHMATIC RIGHT SHIFT
    4'b0111: ALUOut = ALUin1 & ALUin2; // 7: BITWISE AND
    4'b1000: ALUOut = ALUin1 | ALUin2; // 8: BITWISE OR
    4'b1001: ALUOut = ALUin1 ^ ALUin2; // 9: BITWISE XOR
    4'b1010: ALUOut = ALUin1 ~^ ALUin2; // 10: BITWISE XNOR
    4'b1011: ALUOut = ALUin2 >>> ALUin1[4:0]; // 11: ARITHMATIC VARIABLE RIGHT SHIFT
    default: ALUOut = 32'bXXXX;
   endcase
     if (ALUOut == 0) zero = 1'b1; // if ALUOut is 0, then raise zero flag
  end
endmodule
