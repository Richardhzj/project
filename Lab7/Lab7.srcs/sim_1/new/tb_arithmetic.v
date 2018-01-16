`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2017 06:06:04 PM
// Design Name: 
// Module Name: tb_arithmetic
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


module tb_arithmetic;
    wire [3:0]Y; 
    wire C_out;
    reg [3:0]A,B,S;
    reg C_in;f0,f1,
    mult mlt1(A,B, C_in, S, C_out);
    arithmetic_unit au(A,B,C_in,S1);
    initial 
    begin
        $monitor($time,"A=%b, B=%b, 
           
endmodule
