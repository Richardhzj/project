`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2017 06:34:47 PM
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
    output y0,y1,y2,y3,
    input s0,s1,d
    );
    assign y0 = ~s1&~s0&d;
    assign y1 = ~s1&s0&d;
    assign y2 = s1&~s0&d;
    assign y3 = s1&s0&d;
endmodule
