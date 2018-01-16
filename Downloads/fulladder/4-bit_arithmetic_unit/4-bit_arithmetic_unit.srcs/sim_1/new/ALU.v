`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2017 07:45:03 PM
// Design Name: 
// Module Name: ALU
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


module mux_21(d0, d1, f, y);
    input d0, d1, f;
    output y;
    wire nf, d0_b, d1_b;
    not notf(nf, f);
    and andm0(d0_b, nf, d0);
    and andm1(d1_b, f, d1);
    or orm0(y, d0_b, d1_b);
endmodule

module one_bit_alu(f0, f1, f2, A, B, C_in, C_out, S);
    input f0, f1, f2, A, B, C_in;
    output C_out, S;
    wire y1, y2;
    one_bit_arithmetic_unit AU1(A, B, f0, f1, C_in, y1, C_out);
    one_bit_logic_unit LU1(A, B, f1, f0, y2);
    mux_21 m1(y1, y2, f2, S);
endmodule

module four_bit_alu(F0, F1, F2, A, B, C_in, C_out, S);
    input F0, F1, F2, C_in;
    input [3:0]A, B;
    output C_out;
    output [3:0]S;
    wire [2:0]c;
    one_bit_alu alu1(F0, F1, F2, A[0], B[0], C_in, c[0], S[0]);
    one_bit_alu alu2(F0, F1, F2, A[1], B[1], c[0], c[1], S[1]);
    one_bit_alu alu3(F0, F1, F2, A[2], B[2], c[1], c[2], S[2]);
    one_bit_alu alu4(F0, F1, F2, A[3], B[3], c[2], C_out, S[3]);
    
endmodule