`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2017 03:28:24 PM
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

module reg4(d, clk, ce, rst, q);
output [3:0] q;
input [3:0] d;
input clk, ce, rst;

FDCE #(.INIT(1'b0)) FDCE_0 ( .Q(q[0]), .C(clk), .CE(ce), .CLR(rst), .D(d[0]));
FDCE #(.INIT(1'b0)) FDCE_1 ( .Q(q[1]), .C(clk), .CE(ce), .CLR(rst), .D(d[1]));
FDCE #(.INIT(1'b0)) FDCE_2 ( .Q(q[2]), .C(clk), .CE(ce), .CLR(rst), .D(d[2]));
FDCE #(.INIT(1'b0)) FDCE_3 ( .Q(q[3]), .C(clk), .CE(ce), .CLR(rst), .D(d[3]));
endmodule

module mux_4_1(d0, d1, d2, d3, s0, s1, y);
    input d0, d1, d2, d3, s0, s1;
    output y;
    wire w1, w2, w3, w4, w5, w6;
    
    not not1(w1, s0);
    not not2(w2, s1);
    
    and and0(w3, w1, w2, d0);
    and and1(w4, s0, w2, d1);
    and and2(w5, w1, s1, d2);
    and and3(w6, s0, s1, d3);
    
    or or1(y, w3, w4, w5, w6);
endmodule

module regfiled4X4(A,W,clk,rst, s1,s0,B);
    input [3:0]A,W;
    input clk, rst, s1, s0;
    output [3:0]B;
    wire [3:0]R0,R1,R2,R3;
    reg4 reg4_0(A, clk, W[0], rst, R0);
    reg4 reg4_1(A, clk, W[1], rst, R1);
    reg4 reg4_2(A, clk, W[2], rst, R2);
    reg4 reg4_3(A, clk, W[3], rst, R3);
    
    mux_4_1 mux0(R0[0], R1[0], R2[0], R3[0], s0, s1, B[0]);
    mux_4_1 mux1(R0[1], R1[1], R2[1], R3[1], s0, s1, B[1]);
    mux_4_1 mux2(R0[2], R1[2], R2[2], R3[2], s0, s1, B[2]);
    mux_4_1 mux3(R0[3], R1[3], R2[3], R3[3], s0, s1, B[3]);
    
endmodule


module dec7seg(B,S);
    input [3:0]B;
    output reg [6:0]S;
    always @(B)
    begin
        case(B)
        0 : S = 7'b0000001;
        1 : S = 7'b1001111;
        2 : S = 7'b0010010;
        3 : S = 7'b0000110;
        4 : S = 7'b1001100;
        5 : S = 7'b0100100;
        6 : S = 7'b0100000;
        7 : S = 7'b0001111;
        8 : S = 7'b0000000;
        9 : S = 7'b0000100; 
       10 : S = 7'b0001000; 
       11 : S = 7'b1100000;
       12 : S = 7'b1110010;
       13 : S = 7'b1000010;
       14 : S = 7'b0110000;
       15 : S = 7'b0111000;
        
        default: S = 7'b1111111;
        endcase
     end
endmodule


module dec_2_4(s1, s0, d0, d1, d2, d3);
    input s1, s0;
    output d0, d1, d2, d3;
    wire w1, w2;
    not not1(w1, s0);
    
    not not2(w2, s1);
    and and1(d0, w1, w2);
    and and2(d1, s0, w2);
    and and3(d2, w1, s1);
    and and4(d3, s0, s1);
endmodule 
module display(A, W, clk, rst, S, an);
    input clk, rst;
    input[3:0]A,W;
    output[6:0]S;
    output[3:0]an;
    reg[25:0]q;
    wire s1, s0;
    wire[3:0]B, d;
    assign s1 = q[20];
    assign s0 = q[15];
    always@(posedge clk)
    begin 
        q<=q+1;
    end
    regfiled4X4 regfiled1(A, W, clk, rst, s1, s0, B);
    dec7seg seg(B, S);
    dec_2_4 dec1(s1, s0, d[0], d[1], d[2], d[3]);
    assign an = ~d;
endmodule

    
    

