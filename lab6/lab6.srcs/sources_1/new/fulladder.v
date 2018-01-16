`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2017 05:04:54 PM
// Design Name: 
// Module Name: fulladder
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

module fulladder(c_in, a, b, sum, c_out);
    input c_in, a, b;
    output sum, c_out;
    wire a_bar, b_bar, c_bar;
    xor xor_1(a_bar, a, b);
    xor xor_2(sum, a_bar,c_in);
    and and_1(b_bar, a_bar,c_in);
    and and_2(c_bar, a,b);
    or or_1(c_out, b_bar, c_bar); 
endmodule



module paradd4(A,B, C_in, S, C_out);
    input [3:0]A, B; 
    input C_in;
    output [3:0]S;
    output C_out;
    wire [2:0]w;
    fulladder f1(C_in, A[0], B[0], S[0], w[0]);
    fulladder f2(w[0], A[1], B[1], S[1], w[1]);
    fulladder f3(w[1], A[2], B[2], S[2], w[2]);
    fulladder f4(w[2], A[2], B[3], S[3], C_out);
endmodule