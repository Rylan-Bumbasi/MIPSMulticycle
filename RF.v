`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Rylan Bumbasi
// Course: COMPE 475
// Module Description: Register File
//////////////////////////////////////////////////////////////////////////////////


module RF#(parameter AWL = 5, DWL = 32)
          (input CLK, RFWE,
           input [AWL-1:0] RFR1, RFR2, RFWA,
           input [DWL-1:0] RFWD,
           output[DWL-1:0] RFRD1, RFRD2);
           
 initial $readmemb("RFAllZeros.mem", RFMEM); 
           
reg [DWL-1:0] RFMEM [31:0]; // 32 bit array with 32 locations 
always @(posedge CLK) begin
    if(RFWE) begin
    RFMEM[RFWA] <= RFWD;
    end
end

assign RFRD1 = RFMEM[RFR1];
assign RFRD2 = RFMEM[RFR2];


endmodule
