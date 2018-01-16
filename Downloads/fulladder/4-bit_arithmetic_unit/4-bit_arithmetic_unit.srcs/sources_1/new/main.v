`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2017 02:46:31 PM
// Design Name: 
// Module Name: main
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


module FullAdder(c_in, a, b, sum, c_out);
    input a, b, c_in;
    output sum, c_out;
    wire p, r, s;
    xor xor_1(p, a, b);
    xor xor_2(sum, p, c_in);
    and and_1(r, p, c_in);
    and and_2(s, a, b);
    or or_1(c_out, r, s);
endmodule

module mux_4_1(d0,d1,d2,d3,s0,s1,y);
    input d0,d1,d2,d3,s0,s1;
    output y;
    wire s0_b, s1_b, d0_b, d1_b, d2_b, d3_b;
    
    not not_0(s0_b, s0);
    not not_1(s1_b, s1);
    
    and and_0(d0_b, s0_b, s1_b, d0);
    and and_1(d1_b, s0,   s1_b, d1);
    and and_2(d2_b, s0_b, s1,   d2);
    and and_3(d3_b, s0,   s1,   d3);
    
    or or_0(y, d0_b, d1_b, d2_b, d3_b);
endmodule

module one_bit_arithmetic_unit(A, B, f0, f1, C_in, S, C_out);
    input A, B, f0, f1, C_in;
    output S, C_out;
    wire B_bar, notB;
    not not0(notB, B);
    mux_4_1 mux0(B, notB, 0, 1, f0, f1, B_bar);
    FullAdder FA0(C_in, A, B_bar, S, C_out);
endmodule

module four_bit_arithmetic_unit(A, B, F0, F1, C_in, S, C_out);
    input [3:0]A, B;
    input F0, F1, C_in;
    output [3:0] S;
    output C_out;
    wire [2:0]c;
    one_bit_arithmetic_unit AU0(A[0], B[0], F0, F1, C_in, S[0], c[0]);
    one_bit_arithmetic_unit AU1(A[1], B[1], F0, F1, c[0], S[1], c[1]);
    one_bit_arithmetic_unit AU2(A[2], B[2], F0, F1, c[1], S[2], c[2]);
    one_bit_arithmetic_unit AU3(A[3], B[3], F0, F1, c[2], S[3], C_out);
endmodule
    