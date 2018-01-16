`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2017 04:27:33 PM
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

module Slave(SCK, MOSI, CS, MISO, byte);
    input SCK, MOSI, CS;
    output MISO;
    output reg[7:0]byte;
    
    reg [7:0] data_in;
    reg [7:0] data_out;
    
    assign MISO = data_out[7];
    reg[3:0] i = 0;
    always @(posedge SCK)
    begin
        if(CS == 0)
        begin
            data_in <={data_in[6:0],MOSI};
            i<= i+1;
            if(i == 8)
                byte = data_in;
        end
    end
    
    always @(negedge SCK)
    begin
        if(CS == 0)
        begin
            if (i == 8)
                data_out <= data_in;
            else 
                data_out <= {data_out[6:0], data_out[7]};
        end
    end
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

module two7segment(clk, SCK, MISO, MOSI, CS, an, S);
    input clk;
    input SCK, MOSI, CS;
    output MISO;
    output [6:0]S;
    output reg[3:0]an;
    reg[25:0]q;
    wire[7:0]byte;
    reg[3:0]seg_in;

    always @(posedge clk)
    begin   
        q<= q+1;
    end
    always @(q[20])
    begin
        if(q[20] ==0)
        begin
            an <= 4'b1110;
            seg_in <=byte[3:0];
        end
        else
        begin
            an<= 4'b1101;
            seg_in <=byte[7:4];
        end
        end
        dec7seg S1(seg_in, S);
        Slave s1(SCK, MOSI, CS, MISO, byte);
endmodule
