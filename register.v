`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module register#(parameter WL = 32)
                (input CLK, RST, EN, 
                 input [WL-1:0] Din,
                 output reg [WL-1:0] Dout);
always@(posedge CLK) begin
    if (RST == 1) Dout <= 0; // active high reset
    else if (EN) Dout <= Din;
    end

endmodule
