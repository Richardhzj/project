`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2017 06:56:53 PM
// Design Name: 
// Module Name: tb_4_bit_logic_unit
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


module tb_4_bit_logic_unit;
    wire [3:0]S;
    reg [3:0] A, B;
    reg F0, F1;
    four_bit_logic_unit AU0(A, B, F1, F0, S);
    initial
    begin
        $monitor($time, " A = %b, B = %b, F0 = %b, F1 = %b, S = %b\n", A, B, F0, F1, S);
        A = 2; B = 1; F0 = 0; F1 = 0; 
        #5 F0 = 1; F1 = 0; 
        #5 F0 = 1; F1 = 0; 
        #5 F0 = 0; F1 = 1; 
        #5 F0 = 1; F1 = 1; 
        #5;
        $finish;
    end
endmodule
