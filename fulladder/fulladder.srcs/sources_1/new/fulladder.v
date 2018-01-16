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

module hierarchical_fulladder(A0, A1, A2, A3, B0, B1, B2, B3, C_in, S0, S1, S2, S3, C_out);
    input A0, A1, A2, A3, B0, B1, B2, B3, C_in;
    output S0, S1, S2, S3, C_out;
    wire w1, w2, w3;
    fulladder f1(C_in, A0, B0, S0, w1);
    fulladder f2(w1, A1, B1, S1, w2);
    fulladder f3(w2, A2, B2, S2, w3);
    fulladder f4(w3, A3, B3, S3, C_out);
endmodule
