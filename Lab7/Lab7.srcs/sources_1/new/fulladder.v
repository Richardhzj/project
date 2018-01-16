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

module arithmetic_unit(A,B,f0,f1,S,C_out);
    input A, B, f0, f1;
    output S, C_out;
    wire notb,Y;
    not not0(notb, b);
    mult mux_1(f0, f1, B, not0, 0, 1, Y);
    fulladder FA_1(1, A, Y, S, C_out);
endmodule

module arithmetic_unit4_to_1(A, B, f0, f1, S, C_out);
    input [3:0]A,B;
    input f0, f1;
    output [3:0]S;
    output C_out;
    wire [3:0]Y,notb;
    mult mux_1(f0, f1, B[0], notb[0], 0, 1, Y[0]);
    mult mux_2(f0, f1, B[1], notb[1], 0, 1, Y[1]);
    mult mux_3(f0, f1, B[2], notb[2], 0, 1, Y[2]);
    mult mux_4(f0, f1, B[3], notb[3], 0, 1, Y[3]);
    fulladder FA_1(1, A[0], Y[0], S[0], C_out);
    fulladder FA_2(1, A[1], Y[1], S[1], C_out);
    fulladder FA_3(1, A[2], Y[2], S[2], C_out);
    fulladder FA_4(1, A[3], Y[3], S[3], C_out);
endmodule