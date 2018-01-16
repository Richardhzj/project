`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2017 08:20:09 PM
// Design Name: 
// Module Name: tb_alu
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


module tb_alu;
    wire [3:0]S;
    wire C_out;
    reg [3:0] A, B;
    reg F0, F1, F2, C_in;
    four_bit_alu ALU1(F0, F1, F2, A, B, C_in, C_out, S);
    initial
    begin
        $monitor($time, " A = %b, B = %b, F0 = %b, F1 = %b, F2 = %b, S = %b, C_in = %b\n", A, B, F0, F1, F2, S, C_in);
        A = 2; B = 1; F0 = 0; F1 = 0; F2 = 0; C_in = 0;
        #5 F0 = 1; F1 = 0; C_in = 0; 
        #5 F0 = 1; F1 = 0; C_in = 1; 
        #5 F0 = 0; F1 = 1; C_in = 0;
        #5 F0 = 1; F1 = 1; C_in = 0;
        #5 F0 = 1; F1 = 0; F2 = 1;    
        #5 F0 = 1; F1 = 0; F2 = 1; 
        #5 F0 = 0; F1 = 1; F2 = 1; 
        #5 F0 = 1; F1 = 1; F2 = 1; 
        #5;
        $finish;
    end
endmodule