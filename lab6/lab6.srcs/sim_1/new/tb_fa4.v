`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2017 05:17:58 PM
// Design Name: 
// Module Name: tb_fa4
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


module tb_fa4;
    wire [3:0]S, S1; 
    wire C_out;
    reg [3:0]A,B;
    reg C_in;
    integer i,j;
    paradd4 pa4(A,B, C_in, S, C_out);
    bm bm1(A,B,C_in,S1);
    initial 
    begin
            C_in = 0; A=0; B=0;i=0;j=0;
            for(i=0; i<16; i=i+1)
            begin
              A=i;
                for (j=0;j<16; j=j+1)
                begin 
                B=j;
            
            #5   
              if (S != S1)
            begin
            $display ("S=%b, S1=%b, A=%b, B=%b\n ",S,S1,A,B);
            $finish;
 
            end
                             
                end
             end
            
             #5 $finish;
    end
    endmodule
    
   