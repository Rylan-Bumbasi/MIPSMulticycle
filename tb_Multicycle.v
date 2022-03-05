`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2022 11:14:13 AM
// Design Name: 
// Module Name: tb_Multicycle
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


module tb_Multicycle;
reg CLK,RST;

Multicycle DUT(.CLK(CLK), .RST(RST));

always #5 CLK <= ~CLK;

initial begin
CLK <= 0;
RST <= 1;
#10;
RST <= 0;
#5000;
$finish;
end
endmodule
