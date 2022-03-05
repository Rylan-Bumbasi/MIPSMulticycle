`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2022 06:34:58 PM
// Design Name: 
// Module Name: TwoBitMux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TwoBitMux#(WL=32)
           (input[1:0] sel,
            input [WL-1:0] a,b,c,d,
            output reg [WL-1:0] out);
always @(sel,a,b,c,d) begin
    case(sel)
    2'b00: out = a;
    2'b01: out = b;
    2'b10: out = c;
    2'b11: out = d;
    default: out = 32'b00000000000000000000000000000000;
    endcase
end
endmodule
