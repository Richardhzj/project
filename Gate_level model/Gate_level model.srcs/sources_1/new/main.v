`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2017 06:03:39 PM
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
    input e, b, c,
    output d0, d1, d2, d3
    );
    
    assign none = ~e;
    assign myd0 = e&~b&~c;
    assign myd1 = e&~b&c;
    assign myd2 = e&b&~c;
    assign myd3 = e&b&c;
endmodule
