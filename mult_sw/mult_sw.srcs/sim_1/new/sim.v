`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2017 04:41:54 PM
// Design Name: 
// Module Name: sim
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

module sim;
    wire light;
    reg s0,s1,s2,s3;
mult_sw MS(s0,s1,s2,s3,light);
initial 
begin 
    $monitor ($time, " s0 = %b, s1 = %b, s2 = %b, s3 = %b, light = %b", s0,s1,s2,s3,light);
      s0=0; s1=0; s2=0; s3=0;
      #10 s0=1;
      #10 s1=1;
      #10 s2=1;
      #10 s3=1;
      #10;
        $finish;
    end
endmodule
