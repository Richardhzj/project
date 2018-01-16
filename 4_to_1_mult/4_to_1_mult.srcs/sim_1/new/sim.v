`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2017 04:56:13 PM
// Design Name: 
// Module Name: sim
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

module sim;
wire y;
reg s0,s1,d0,d1,d2,d3;
mult mt(s0,s1,d0,d1,d2,d3,y);
initial 
begin
    $monitor($time, " s1 = %b, s0 = %b, d0 = %b, d1 = %b, d2 = %b, d3 = %b, y = %b\n", s0,s1,d0,d1,d2,d3,y);
        s0=0; s1=0; d0=0; d1=0; d2=0; d3=0;
    #15 s1=0; s0=0; 
    #15 d0=1;
    
    #15 s1=0; s0=1; 
    #15 d1=1;
    
    #15 s1=1; s0=0; 
    #15 d2=1;
    
    #15 s1=1; s0=1;
    #15 d3=1;   
        $finish;
        end
    endmodule