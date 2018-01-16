`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2017 06:03:48 PM
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


module main(
    output d0,d1,d2,d3,d4,d5,d6,d7,
    input a,b,c

    );
    assign d0 = ~a & ~b & ~c;
    assign d1 = ~a & ~b & c;
    assign d2 = ~a &  b & ~c;
    assign d3 = ~a & b & c;
    assign d4 = a & ~b &~c;
    assign d5 = a & ~b & c;
    assign d6 = a & b & ~c;
    assign d7 = a & b & c;
endmodule
