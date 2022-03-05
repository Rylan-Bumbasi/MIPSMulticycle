`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2022 05:25:31 PM
// Design Name: 
// Module Name: mux
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// 
//////////////////////////////////////////////////////////////////////////////////


module mux#(WL=32)
           (input sel,
            input [WL-1:0] a,b,
            output reg [WL-1:0] out);
always @(sel,a,b) begin
    if (sel) out = a;
    else out = b;
end
endmodule
