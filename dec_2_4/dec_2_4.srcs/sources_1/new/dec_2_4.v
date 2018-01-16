`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2017 03:59:35 PM
// Design Name: 
// Module Name: dec_2_4
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


module dec_2_4e(b,c,e,d0,d1,d2,d3);
    input b, c, e;
    output d0, d1,d2,d3;
    wire b_bar, c_bar;
    not not_1(b_bar, b);
    not not_2(c_bar, c);
    
    and and_0(d0, e, b_bar, c_bar);
    and and_1(d1, e, b_bar, c   );
    and and_2(d2, e, b,     c_bar);
    and and_3(d3, e, b,     c   );
    
endmodule


module dec_3_8(A, B, C, D0, D1, D2, D3, D4,D5, D6, D7);
    input A, B, C;
    output D0, D1, D2, D3, D4, D5, D6,D7;
    wire A_bar;
    not not_1(A_bar, A);
    
    dec_2_4e Low (B, C, A_bar, D0, D1, D2,D3);
    dec_2_4e High(B, C, A   ,  D4, D5, D6, D7);
endmodule


