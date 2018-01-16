`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2017 06:42:56 PM
// Design Name: 
// Module Name: 4-bit logic unit
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


module mux_41(d0,d1,d2,d3,s0,s1,y);
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

module one_bit_logic_unit(A, B, f1, f0, S);
    input A, B, f0, f1;
    output S;
    wire [3:0]w;
    and and0(w[0], A, B);
    or or0(w[1], A, B);
    xor xor0(w[2], A, B);
    not not0(w[3], A);
    mux_41 mux1(w[0], w[1], w[2], w[3], f0, f1, S);
endmodule

module four_bit_logic_unit(A, B, F1, F0, S);
    input [3:0]A, B;
    input F0, F1;
    output [3:0]S;
    one_bit_logic_unit one0(A[0], B[0], F1, F0, S[0]);
    one_bit_logic_unit one1(A[1], B[1], F1, F0, S[1]);
    one_bit_logic_unit one2(A[2], B[2], F1, F0, S[2]);
    one_bit_logic_unit one3(A[3], B[3], F1, F0, S[3]);
endmodule