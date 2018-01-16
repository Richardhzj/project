`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2017 05:52:31 PM
// Design Name: 
// Module Name: 4_to_1_mult
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


module mult(s0, s1, d0, d1, d2, d3, y);
    input s0, s1, d0, d1, d2, d3;
    output y;
    wire wo, w1, a, b, c, d;
    not not_0(w0, s0);
    not not_1(w1, s1);
    and and_1(a, w0, w1, d0);
    and and_2(b, s0, w1, d1);
    and and_3(c, w0, s1, d2);
    and and_4(d, s0, s1, d3);
    or  or_1 (y, a, b, c, d);
endmodule
