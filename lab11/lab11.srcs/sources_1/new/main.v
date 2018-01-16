`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2017 07:21:46 PM
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


module Lab11(cs, sck, mosi, miso, led);//, clk, S, an);
input cs, sck, mosi;
output miso;
output [15:0] led;    //for test purpose,


reg [4:0] bitcnt;     //input bit count
reg [7:0] in_byte;    //input byte from STM board
reg [7:0] out_byte;   //output byte to STM board


reg [7:0] byte_A;      //byte A received from the STM board
reg [7:0] byte_B;      //byte B received from the STM board
reg [7:0] ret_message; //message to the STM board
reg [7:0] stack [0:63]; //stack memory
reg [6:0] SP;           //Stack pointer

assign led[ 7:0] = byte_A;        // use LED for debugging
assign led[15:8] = ret_message;   // use LED for debugging
assign miso = out_byte[7];        // Serial out

wire clock;
assign clock = sck & (bitcnt[3] | bitcnt[4]);



 always @(posedge sck)
    begin
    if (cs == 0)
        begin
        in_byte <= {in_byte[6:0], mosi};
        if (bitcnt == 24)
            bitcnt <= 1;
        else
            bitcnt = bitcnt + 1;
        end
    end


always @(negedge sck)
    begin
    if (bitcnt == 8)
    begin
        byte_A <= in_byte[7:0];
    end
    if (bitcnt == 16)
    begin
        byte_B <= in_byte[7:0];
    end
    end

    

initial begin
    SP <= 64;
    end   
always @(posedge clock)
    begin
    case(byte_A)
        8'h04: case(bitcnt)
                    5'b01001: ret_message <= 1;
                endcase
        8'h08: case(bitcnt)
                    5'b01001: if(SP == 64 | SP > 64)
                            ret_message <= 1;
                        else
                            ret_message <= 2;
                endcase
        8'h09: case(bitcnt)
                    5'b01001: if(SP == 0)
                            ret_message <= 1;
                        else
                            ret_message <= 2;
                endcase
        8'h0a: case(bitcnt)
                    5'b10010: SP <= SP - 1;
                    5'b10011: stack[SP] <= byte_B;
                endcase
        8'h0b: case(bitcnt)
                    5'b01001: ret_message <= stack[SP];
                    5'b01010: SP = SP + 1;
                endcase
    endcase
    end
    
always @ (negedge sck)
        begin
        if (bitcnt == 16)
            out_byte <= ret_message;
        else
            out_byte <= {out_byte[6:0], out_byte[7]};
        end
        

    
endmodule

module seg7dec(B, out);
   input [3:0]B;
    output reg [6:0] out;
    always @ (B)
    begin
        case (B)
        0 : out = 7'b1000000;
        1 : out = 7'b1111001;
        2 : out = 7'b0100100;
        3 : out = 7'b0110000; 
        4 : out = 7'b0011001; 
        5 : out = 7'b0010010; 
        6 : out = 7'b0000010; 
        7 : out = 7'b1111000;
        8 : out = 7'b0000000; 
        9 : out = 7'b0010000;
        10 : out = 7'b0001000;
        11 : out = 7'b0000011;
        12 : out = 7'b1000110;
        13 : out = 7'b0100001;
        14 : out = 7'b0000110;
        15 : out = 7'b0001110;
        
        
        default : out = 7'b1111111;
        endcase
     end
 endmodule      


module main(cs, sck, mosi, miso, led, clk, S, an);
input cs, sck, mosi;
output miso;
output [15:0] led;    //for test purpose,
                      //to display received and sent bytes
output reg [3:0]an;
output [6:0]S;
input clk;

reg [25:0]q;
reg [3:0] b;
reg [1:0]dis;
reg [7:0] byte_A;      //byte A received from the STM board
reg [7:0] byte_B;      //byte B received from the STM board
reg [7:0] ret_message; //message to the STM board

assign led[ 7:0] = byte_A;        // use LED for debugging
assign led[15:8] = ret_message;   // use LED for debugging

Lab11 memory(cs, sck, mosi, miso, led);
seg7dec display(b, S);        
        
always @(posedge clk)
    begin
    q <= q+1;
    end
    
always @(posedge q[15])
    begin
    dis = dis + 1;
    case(dis)
        2'b00: begin b = byte_A[7:4];
                     an <= 4'b0111;
               end 
        2'b01: begin b = byte_A[3:0];
                     an = 4'b1011;
               end
        2'b10: begin b = ret_message[7:4];
                     an = 4'b1101;
                 end
        2'b11: begin b = ret_message[3:0];
                     an = 4'b1110;
                end
    endcase
     end
    
endmodule
