`timescale 1ns / 1ps


module adder#(parameter WL = 32)
             (input [WL-1:0] in1, in2, 
              output reg [WL-1:0] out);
always @* out = in1 + in2;
endmodule

