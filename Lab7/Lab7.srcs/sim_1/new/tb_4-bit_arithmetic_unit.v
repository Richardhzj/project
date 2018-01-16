`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2017 04:59:40 PM
// Design Name: 
// Module Name: tb_4-bit_arithmetic_unit
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


module tb_four_bit_arithmetic_unit;
    wire [3:0]S;
    wire C_out;
    reg [3:0] A, B;
    reg F0, F1, C_in;
    four_bit_arithmetic_unit AU(A, B, F0, F1, C_in, S, C_out);
    initial
    begin
        $monitor($time, " A = %b, B = %b, F0 = %b, F1 = %b, S = %b, C_in = %b\n", A, B, F0, F1, S, C_in);
        A = 2; B = 1; F0 = 0; F1 = 0; C_in = 0;
        #5 F0 = 1; F1 = 0; C_in = 0;
        #5 F0 = 1; F1 = 0; C_in = 1;
        #5 F0 = 0; F1 = 1; C_in = 0;
        #5 F0 = 1; F1 = 1; C_in = 0;
        #5;
        $finish;
    end
endmodule
