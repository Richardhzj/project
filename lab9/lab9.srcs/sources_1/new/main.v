`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 01:32:38 PM
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
module lab9(clk, c, led, led15, seg, an);
 input clk;
 input [4:0] c; // call buttons from flor 1, 2, 3, 4
// c[0] is reset
 output reg [6:0] seg; // segments on 7-segment display
 output reg [3:0] an; // anodes
 output [3:0] led; // I used 4 LEDs for debugging
 output led15; // I used led15 to indicate if clock is running

 reg [25:0] q;
 reg [4:0] state; // current state
 reg [4:0] next_state;
 reg [3:0] led;

// State definitions
 parameter
 F1 = 5'd0, // car is on floor 1, waiting for a call
 F11 = 5'd1,
 F12 = 5'd2,
 F13 = 5'd3,
 F14 = 5'd4,
 F2 = 5'd5,
 F21 = 5'd6,
 F22 = 5'd7,
 F23 = 5'd8,
 F24 = 5'd9,
 F3 = 5'd10,
 F31 = 5'd11,
 F32 = 5'd12,
 F33 = 5'd13,
 F34 = 5'd14,
 F4 = 5'd15,
 F41 = 5'd16,
 F42 = 5'd17,
 F43 = 5'd18,
 F44 = 5'd19;
 
 // Divide input clk = 100 MHz
  assign led15 = q[25];
    always @(posedge clk)
  begin
      //state <= next_state;
      q <= q+1;
  end 
  always @(posedge q[24])
  begin
  if (c[0])
      state <= F1;
  else
      state <= next_state;
      //q <= q+1;
  end 
  
  // Next state function
   always @(*)
   begin
   next_state = state;
   case (state)
   F1: begin
        if (c[2])
            next_state = F12;
        else if (c[3])
            next_state = F13;
        else if (c[4])
            next_state = F14;
        end
  
    F11: next_state = F1;
    F12: next_state = F22;
    F13: next_state = F23;
    F14: next_state = F24;
   F2: begin
         if (c[1])
             next_state = F21;
         else if (c[3])
             next_state = F23;
         else if (c[4])
             next_state = F24;
         end
    F21: next_state = F11;
    F22: next_state = F2;
    F23: next_state = F33;
    F24: next_state = F34;
   F3: begin
          if (c[1])
              next_state = F31;
          else if (c[2])
              next_state = F32;
          else if (c[4])
              next_state = F34;
          end
     F31: next_state = F21;
     F32: next_state = F22;
     F33: next_state = F3;
     F34: next_state = F44;


   F4: begin
         if (c[1])
             next_state = F41;
         else if (c[2])
             next_state = F42;
         else if (c[3])
             next_state = F43;
         end  
    F41: next_state = F31;
    F42: next_state = F32;
    F43: next_state = F33;
    F44: next_state = F4;
       endcase
       end
  // Output function
        always @(*)
        begin
            led = 4'b0001; // Default values
            an = 4'b1111;
            seg = 7'b1111111;
            case (state)
            F1: begin
                 led = 4'b0001; // For initial debugging
                 an = 4'b1110; // Illuminate display 1
                 seg = 7'b1000011; // door open
                end
     
            F2: begin
                    led = 4'b0010; // For initial debugging
                    an = 4'b1101; // Illuminate display 1
                    seg = 7'b1000011; // door open
                end
     
            F3:begin
                   led = 4'b0100; // For initial debugging
                   an = 4'b1011; // Illuminate display 1
                   seg = 7'b1000011; // door open
               end
     
            F4:begin
                   led = 4'b1000; // For initial debugging
                   an = 4'b0111; // Illuminate display 1
                   seg = 7'b1000011; // door open
               end
     
     
     
               
            F11:begin
                  led = 4'b0001; // For initial debugging
                  an = 4'b1110; // Illuminate display 1
                  seg = 7'b0100011; // door open
              end 
              
            F12:begin
                     led = 4'b0011; // For initial debugging
                     an = 4'b1110; // Illuminate display 1
                     seg = 7'b0100011; // door open
                 end
     
            F13:begin
                  led = 4'b0101; // For initial debugging
                  an = 4'b1110; // Illuminate display 1
                  seg = 7'b0100011; // door open
              end
            F14:begin
                    led = 4'b1001; // For initial debugging
                    an = 4'b1110; // Illuminate display 1
                    seg = 7'b0100011; // door open
                end            
     
            F21:begin
                  led = 4'b0011; // For initial debugging
                  an = 4'b1101; // Illuminate display 1
                  seg = 7'b0100011; // door open
              end  
       
            F22:begin
                    led = 4'b0010; // For initial debugging
                    an = 4'b1101; // Illuminate display 1
                    seg = 7'b0100011; // door open
                end  
                
            F23:begin
                    led = 4'b0110; // For initial debugging                      
                     an = 4'b1101; // Illuminate display 1
                     seg = 7'b0100011; // door open
                  end
     
            F24:begin
                  led = 4'b1010; // For initial debugging
                  an = 4'b1101; // Illuminate display 1
                  seg = 7'b0100011; // door open
              end
              
              
            F31:begin
                    led = 4'b0101; // For initial debugging
                    an = 4'b1011; // Illuminate display 1
                    seg = 7'b0100011; // door open
                end  
         
              F32:begin
                      led = 4'b0110; // For initial debugging
                      an = 4'b1011; // Illuminate display 1
                      seg = 7'b0100011; // door open
             end
                  
              F33:begin
                        led = 4'b0100; // For initial debugging
                        an = 4'b1011; // Illuminate display 1
                        seg = 7'b0100011; // door open
                    end
       
              F34:begin
                    led = 4'b1100; // For initial debugging
                    an = 4'b1011; // Illuminate display 1
                    seg = 7'b0100011; // door open
                end
     
            F41:begin
                  led = 4'b1001; // For initial debugging
                  an = 4'b0111; // Illuminate display 1
                  seg = 7'b0100011; // door open
              end  
       
            F42:begin
                    led = 4'b1010; // For initial debugging
                    an = 4'b0111; // Illuminate display 1
                    seg = 7'b0100011; // door open
                end  
                
            F43:begin
                      led = 4'b1100; // For initial debugging
                      an = 4'b0111; // Illuminate display 1
                      seg = 7'b0100011; // door open
                end
     
            F44:begin
                      led = 4'b1000; // For initial debugging
                      an = 4'b0111; // Illuminate display 1
                      seg = 7'b0100011; // door open
              end
              endcase
              end
       
     endmodule