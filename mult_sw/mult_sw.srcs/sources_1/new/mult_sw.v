`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2017 06:38:30 PM
// Design Name: 
// Module Name: mult_sw
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


module mult_sw(s0, s1, s2, s3, light);
    input s0, s1, s2, s3;
    output light;
    wire a1, b1, c1, d1, o1, o2, o3, o4, o5, o6, o7, o8;
    not not_a(a1, s0);
    not not_b(b1, s1);
    not not_c(c1, s2);
    not not_d(d1, s3);
    and and_1(o1, a1, b1, c1, s3);
    and and_2(o2, a1, b1, s2, d1);
    and and_3(o3, a1, s1, c1, d1);
    and and_4(o4, a1, s1, s2, s3);
    and and_5(o5, s0, b1, c1, d1);
    and and_6(o6, s0, b1, s2, s3);
    and and_7(o7, s0, s1, c1, s3);
    and and_8(o8, s0, s1, s2, d1);
    or  or_1(light, o1, o2, o3, o4, o5, o6, o7, o8);
endmodule


