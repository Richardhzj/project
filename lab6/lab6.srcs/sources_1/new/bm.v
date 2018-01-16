`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2017 06:22:55 PM
// Design Name: 
// Module Name: bm
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


module bm(A,B,C_in,S);
    input [3:0]A, B; 
    input C_in;
    output reg [3:0]S;
    always @(A or B or C_in)
    S=A+B;
    
endmodule
