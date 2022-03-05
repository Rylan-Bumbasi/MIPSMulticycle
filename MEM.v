`timescale 1ns / 1ps                                                                                
//////////////////////////////////////////////////////////////////////////////////                  
// Name: Rylan Bumbasi                                                                              
// Course: COMPE 475                                                                                
// Module Description: Data Memory                                                           
//////////////////////////////////////////////////////////////////////////////////                                                                                                                   
module MEM#(parameter WL = 32)                                                                       
        (input CLK, MWE,
         input [WL-1:0] MRA, MWD,                                                                        
         output [WL-1:0] MRD);                                                                 
                                                                                                    
     
                                                                                                    
 initial $readmemb("MEM.mem", ROM);      

reg [WL-1:0] ROM [0:2**10-1]; // Decalre an array to hold all of the values from the .mem file                                                        

always @(posedge CLK) begin
    if(MWE) begin
    ROM[MRA] <= MWD;
    end
end                                                                                 
assign MRD = ROM[MRA];                                                                                    
                                                                                           
endmodule                                                                                           
                                                                                                    