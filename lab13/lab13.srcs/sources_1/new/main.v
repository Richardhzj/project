`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2017 03:06:07 PM
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


module final_project(cs, sck, mosi, miso, clk, rst, seg, an);
input cs, sck, mosi, clk, rst;
output miso;
output reg [6:0] seg;                                 // 7- segment display
output reg [3:0] an;                              // anodes of 4 7-segment display

// Memory & Display
reg [7:0] memory [0:255];                         // main memory
reg [7:0] IO_Mem[0:1];                             // Input / Output Address Space
reg [8:0] mem_ptr= 9'h1ff;                        // Memory Pointer
reg [20:0] q;                                     // divider for system clock / clk
reg [3:0] disp;                                   // hex digit to display
reg [1:0] display_clk;                            // clock for display
reg [7:0] in, out;
// Microprocessor Registers
reg [7:0] A;                                      // accumulator
reg [7:0] B;                                      // general purpose register
reg [7:0] T;                                      // temporary register
reg [7:0] AR;                                     // address register memory
reg [7:0] DR;                                     // data register memory
reg [7:0] PC;                                     // program counter
reg [7:0] AP;                                     // address pointer
reg [7:0] IR;                                     // instruction register
reg [3:0] PSW     = 4'b1000;                      // program status word : contains halt, trace, zero, and carry bits
reg [3:0] car;                                    // control address register
reg       fetch   = 0;                            // fetch = 1, instruction fetch
reg       execute = 0;                            // execute = 1, instruction execute

// PSW Bits Definitions
`define CARRY PSW[0]                               
`define ZERO  PSW[1]                               
`define TRACE PSW[2]                               
`define HALT  PSW[3]                               

// Microprocessor uses q[5] as a clock, frequency = 100Mhz / 64

reg [2:0] sckr;
always @ (posedge q[5])
    sckr <= {sckr[1:0], sck};
    wire sck_risingedge = (sckr[2:1] == 2'b01); //sck rising edge
    wire sck_fallingedge = (sckr[2:1] == 2'b10); // sck falling edge
    
    //sync cs to FPA clock q[5] using 3-bit shift register
     reg [2:0] csr;
       always @(posedge q[5])
           csr <= {csr[1:0], cs};
       wire cs_active = ~csr[1];                    // cs is active low
       wire cs_startmessage = (csr[2:1] == 2'b10);  // message starts at falling edge
       wire cs_endmessage = (csr[2:1] == 2'b01);  // message stops at rising edge      
          // sync 'mosi' to FPGA clock q[5] using 2-bit shift register
         reg [1:0] mosir;
         always @(posedge q[5])
             mosir <= {mosir[0], mosi};
         wire mosi_data = mosir[1];
         
         // Receive message from STM board
         reg [11:0] bitcnt;             // counter for bits received via SPI
         reg [7:0] byte_A;             // byte_A received from STM board
         reg [7:0] byte_B;             // byte_B received from STM board
         reg [7:0] in_byte;
         always @(posedge q[5])
             begin
             if (~cs_active)
                 bitcnt <= 5'b00000;   // reset bit counter at the beginning
             else
                 if (sck_risingedge)
                     begin
                     bitcnt <= bitcnt + 5'b00001;
                     // shift-left, since we receive the MSB first
                     in_byte <= {in_byte[6:0], mosi_data};
                     end
             end
             
         // Extract byte_A and byte_B from the input message
        always @(posedge q[5])
        begin
             if (cs_active && (bitcnt == 5'b01000))
                 byte_A <= in_byte;
             if (cs_active && (bitcnt == 5'b10000))
                 byte_B <= in_byte;
             end
     
         // SPI communication --------------------------------------------
         // Transmit message to the STM board
         // Send byte_C to the STM board, starting at bitcnt = 10h
         reg [7:0] ret_msg;                  // message to the STM board
         reg [7:0] out_byte;
         always @(posedge q[5])
             begin
             if (cs_active)
                 begin
                 if ((bitcnt % 8)==0)//bitcnt == 5'b10000)
                     out_byte <= ret_msg;
                 else
                     if (sck_fallingedge)
                         out_byte <= {out_byte[6:0], out_byte[7]};
                 end
            end
            
         assign miso = out_byte[7];               // send MSB first  
          
          
         

always @ (posedge q[5])
    begin
    // enter reset state
    if (rst)
        begin
        PC      <= 0;
        PSW     <= 4'b1000;                        // microprocessor is halted
        car     <= 1;
        fetch   <= 0;
        execute <= 0;
        end
    else
    begin
    if (sck_fallingedge)
    begin
        case (byte_A)
                
        8'h04:
        case (bitcnt)
        5'h09: ret_msg <= 8'h01;
        endcase
                
        8'h08:
        case (bitcnt)
        5'h09:
        if (mem_ptr == 0)
        ret_msg <= 1;
        else
        ret_msg <= 2;
        endcase  
                                
        8'h09:
        case (bitcnt)
        5'h09:
        if (mem_ptr == 9'h100)
        ret_msg <= 1;
        else
        ret_msg <= 2;
        endcase  
                                  
        8'h0A:
        case (bitcnt)
        5'h12: mem_ptr <= mem_ptr + 1;
        5'h13: memory[mem_ptr] <= byte_B;
        endcase  
                             
        8'h0B:
        case (bitcnt)
        5'h09: ret_msg <= memory[mem_ptr];
        5'h0A: mem_ptr <= mem_ptr - 1;
        endcase   
                            
        8'h0C:
        case (bitcnt)
        5'h09: ret_msg <= memory[mem_ptr];// - 1];
        endcase  
                              
        8'h40:
        if ((bitcnt == 5'h09) && `HALT)
        begin
        `HALT   <= 0;
        PC      <= 0;
        PSW     <= 0;
        car     <= 1;
        fetch   <= 1;
        execute <= 0;
        end   
                           
        8'h41:
        if ((bitcnt == 5'h09) && `TRACE)
        begin
        car     <= 1;
        fetch   <= 1;
        execute <= 0;
        end

        8'h42:
        case (bitcnt)
        12'd08: ret_msg <= A;
        12'd16: ret_msg <= B;
        12'd24: ret_msg <= AR;
        12'd32: ret_msg <= DR;
        12'd40: ret_msg <= PC;
        12'd48: ret_msg <= AP;
        12'd56: ret_msg <= IR;
        12'd64: ret_msg <= T;
        12'd72: ret_msg <= PSW;
         endcase

        
        8'h43:
        begin//case (bitcnt)
        mem_ptr <= (bitcnt - 8)/8;
        ret_msg <= memory[mem_ptr];       
        end
           
       endcase
     end
    end

         
        // fetch instruction
        if (~ `HALT && fetch)
            begin
            case (car)
               4'h1:
                    begin
                    AR <= PC;
                    car <= car + 1;
                    end
               4'h2:
                    begin
                    DR <= memory[AR];
                    PC <= PC + 1;
                    car <= car + 1;
                    end
               4'h3:
                    begin
                    IR <= DR;
                    fetch <= 0;
                    execute <= 1;
                    car <= car + 1;
                    end
                endcase
                end
         // execute instruction
           if (~`HALT && execute) 
                   begin
                   case (IR)
                   
       // DATA TRANSFER INSTRUCTIONS
       8'h11:
           case (car)
               4'h4: begin                      
           AR <= PC;
           car <= car + 1;
            end 
            4'h5: begin
            DR <= memory[AR];      
            PC <= PC + 1;
            car <= car + 1;
            end
            4'h6: begin
            AR <= DR;
            car <= car + 1;
            end 
            4'h7: begin
            DR <= memory[AR];      
            car <= car + 1;
            end
            4'h8: begin
            A <= DR;
            execute <= 0;
            car <= 1;
            if (~PSW[2]) fetch <= 1;    
            end
            endcase
       8'h13:  
             case (car)
              4'h4: begin                      
              AR <= PC;
              car <= car + 1;
               end 
               4'h5: begin
               DR <= memory[AR];      
               PC <= PC + 1;
               car <= car + 1;
               end
               4'h6: begin
               AR <= DR;
               car <= car + 1;
               end 
               4'h7: begin
               DR <= memory[AR];      
               car <= car + 1;
               end
               4'h8: begin
               AP <= DR;
               execute <= 0;
               car <= 1;
               if (~PSW[2]) fetch <= 1;    
               end
               endcase
      
           
                
      8'h19:        
                case (car)
                4'h4: begin                      
                AR <= PC;
                car <= car + 1;
                end 
                4'h5: begin
                DR <= memory[AR]; 
                PC <= PC + 1;     
                car <= car + 1;
                end
                4'h6: begin
                A <= DR;
               execute <= 0;
                car <= 1;
              if (~PSW[2]) fetch <= 1;
                end             
                endcase
                
      8'h1B:  
              case (car)
              4'h4: begin                      
               AR <= PC;
               car <= car + 1;
               end 
               4'h5: begin
              DR <= memory[AR]; 
              PC <= PC + 1;     
              car <= car + 1;
              end
              4'h6: begin
              AP <= DR;
              execute <= 0;
              car <= 1;
              if (~PSW[2]) fetch <= 1;
              end            
              endcase
              
      8'h14:  
              case (car)
              4'h4: begin                      
              AR <= AP;
              car <= car + 1;
             end 
             'h5: begin
              DR <= memory[AR]; 
              //PC <= PC + 1;     
              car <= car + 1;
              end
              4'h6: 
              begin
              A <= DR;
              execute <= 0;
              car <= 1;
              if (~PSW[2]) fetch <= 1;
              end            
              endcase
       8'h1C:
          case (car)
          4'h4: begin
                AR <= PC;
                car <= car + 1;
                end
          4'h5: begin
                DR <= memory[AR];
                PC <= PC + 1;
                car <= car + 1;
                end
          4'h6:
              begin
              B <= DR;
              execute <= 0;
              car <= 1;
              if (~PSW[2]) fetch <= 1;
              execute <= 0;
              car <= 1;
              end
         endcase
                                   
      // ARITHMETIC INSTRUCTIONS
      8'h31:  
                case (car)
                4'h4: begin                                          
                AR <= PC;
                car <= car + 1;
                end 
                4'h5: begin
                DR <= memory[AR]; 
                PC <= PC + 1;     
                car <= car + 1;
                end
                4'h6: begin
                AR <= DR;
                car <= car + 1;
                end
                4'h7: begin
                DR <= memory[AR];
                car <= car + 1;
                end
                4'h8: begin
                {`CARRY, A} <= A + DR;      
                car <= car + 1;
                end  
                4'h9: begin
                if (A == 0) `ZERO <= 1;  
                if (~`TRACE) fetch <= 1; 
                execute <= 0;
                car <= 1;
                end 
                endcase
                
         8'h39:  
                case (car)
                4'h4: begin                      
                AR <= PC;
                car <= car + 1;
                end 
                4'h5: begin
                DR <= memory[AR]; 
                PC <= PC + 1;     
                car <= car + 1;
                end
                4'h6: begin
                {`CARRY, A} <= A + DR; 
                car <= car + 1;
                end  
                4'h7: begin
                if (A == 0) `ZERO <= 1; 
                if (~`TRACE) fetch <= 1;
                execute <= 0;
                car <= 1;
                end                       
                endcase
                
         8'h41:  
                 case (car)
                 4'h4: begin                                          
                 AR <= PC;
                 car <= car + 1;
                 end 
                4'h5: begin
                DR <= memory[AR]; 
                PC <= PC + 1;     
                car <= car + 1;
                end
                4'h6: begin
                AR <= DR;
                car <= car + 1;
                end
                4'h7: begin
                DR <= memory[AR];
                car <= car + 1;
                end
                4'h8: begin
                {`CARRY, A} <= A - DR;  
                car <= car + 1;
                end  
                4'h9: begin
                if (A == 0) `ZERO <= 1;   
                if (~`TRACE) fetch <= 1;  
                execute <= 0;
                car <= 1;
                end
                endcase       
                
         8'h49:  
               case (car)
               4'h4: begin                      
               AR <= PC;
               car <= car + 1;
               end 
               4'h5: begin
               DR <= memory[AR]; 
               PC <= PC + 1;     
               car <= car + 1;
               end
               4'h6: begin
               {`CARRY, A} <= A - DR;
               if ((A - DR) == 0) `ZERO <= 1;
               if (~PSW[2]) fetch <= 1; 
               execute <= 0;
               car <= 1;
               end 
               endcase
               
         8'h3B:  
               case (car)
               4'h4: begin                      
               AR <= PC;
               car <= car + 1;
               end 
               4'h5: begin
               DR <= memory[AR]; 
               PC <= PC + 1;     
               car <= car + 1;
               end
               4'h6: begin
               {`CARRY, AP} <= AP + DR; 
               car <= car + 1;
               end  
               4'h7: begin
               if (AP == 0) `ZERO <= 1; 
               if (~`TRACE) fetch <= 1;
               execute <= 0;
               car <= 1;
               end  
               endcase        
               
         8'h4B:  
               case (car)
               4'h4: begin                      
               AR <= PC;
               car <= car + 1;
               end 
               4'h5: begin
               DR <= memory[AR]; 
               PC <= PC + 1;     
               car <= car + 1;
               end
               4'h6: begin
               {`CARRY, AP} <= AP - DR; 
               if ((AP - DR) == 0) `ZERO <= 1;  
               if (~PSW[2]) fetch <= 1;   
               execute <= 0;
               car <= 1;
              end 
             endcase        
        8'h4C:  
              case (car)
              4'h4: begin                      
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR]; 
                    PC <= PC + 1;     
                    car <= car + 1;
                    end
              4'h6: begin
                    {`CARRY, B} <= B - DR;
                    if ((B - DR) == 0) `ZERO <= 1;
                    if (~PSW[2]) fetch <= 1; 
                    execute <= 0;
                    car <= 1;
                    end
              endcase        
         8'h34:  
              case (car)
              4'h4: begin                      
                    AR <= AP;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR];      
                    car <= car + 1;
                    end
              4'h6: begin
                    {`CARRY, A} <= A + DR;
                    car <= car + 1;
                    end 
              4'h7: begin
                    if (A == 0) `ZERO <= 1;
                    if (~`TRACE) fetch <= 1;
                    execute <= 0;
                    car <= 1;
                    end
              endcase        
        8'h44:  
              case (car)
              4'h4: begin                      
                    AR <= AP;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR];      
                    car <= car + 1;
                    end
              4'h6: begin
                    {`CARRY, A} <= A - DR;
                    car <= car + 1;
                    end 
              4'h7: begin
                    if (A == 0) `ZERO <= 1;
                    if (~`TRACE) fetch <= 1;
                    execute <= 0;
                    car <= 1;
                    end
              endcase        
         // Logic Instructions
         8'h50 :                                
              case (car)
              4'h4: begin                      
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR]; 
                    PC <= PC + 1;     
                    car <= car + 1;
                    end
              4'h6: begin
                    A <= ~A;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;
                    end             
              endcase              
          8'h90:                                
              case (car)
              4'h4: begin                      
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR]; 
                    PC <= PC + 1;     
                    car <= car + 1;
                    end
              4'h6: begin
                    A <= A >> 1;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;
                    end             
              endcase 
          8'h61:                                
              case (car)
              4'h4: begin          
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR];      
                    PC <= PC + 1;
                    car <= car + 1;
                    end
              4'h6: begin
                    AR <= DR;
                    car <= car + 1;
                    end 
              4'h7: begin
                    DR <= memory[AR];            
                    car <= car + 1;
                    end
              4'h8: begin
                    A <= A | DR;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;     
                    end
              endcase
          8'h71:                                
              case (car)
              4'h4: begin          
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR];      
                    PC <= PC + 1;
                    car <= car + 1;
                    end
              4'h6: begin
                    AR <= DR;
                    car <= car + 1;
                    end 
              4'h7: begin
                    DR <= memory[AR];            
                    car <= car + 1;
                    end
              4'h8: begin
                    A <= A & DR;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;     
                    end
              endcase
          8'h81:                               
              case (car)
              4'h4: begin          
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR];      
                    PC <= PC + 1;
                    car <= car + 1;
                    end
              4'h6: begin
                    AR <= DR;
                    car <= car + 1;
                    end 
              4'h7: begin
                    DR <= memory[AR];            
                    car <= car + 1;
                    end
              4'h8: begin
                    A <= A ^ DR;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;     
                    end
              endcase
          8'h69:                                
              case (car)
              4'h4: begin                      
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR]; 
                    PC <= PC + 1;     
                    car <= car + 1;
                    end
              4'h6: begin
                    A <= A | DR;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;
                    end             
              endcase
              
          8'h79:                                
              case (car)
              4'h4: begin                      
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR]; 
                    PC <= PC + 1;     
                    car <= car + 1;
                    end
              4'h6: begin
                    A <= A & DR;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;
                    end             
              endcase

          8'h89:                                
              case (car)
              4'h4: begin                      
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR]; 
                    PC <= PC + 1;     
                    car <= car + 1;
                    end
              4'h6: begin
                    A <= A ^ DR;
                    execute <= 0;
                    car <= 1;
                    if (~PSW[2]) fetch <= 1;
                    end             
              endcase              

        8'hA1:
             case(car)
             4'h4: begin
                   AR <= PC;
                   car <= car + 1;
                   end
             4'h5: begin
                   DR <= memory[AR];
                   PC <= PC + 1;
                   car <= car + 1;
                   end
             4'h6: begin
                   PC <= DR;
                   if (~PSW[2]) fetch <= 1;
                   execute <= 0;
                   car <= 1;
                   end
             endcase               
              
              
        8'hA5:                                 
              case ( car )
              4'h4: begin
                    AR <= PC;
                    car <= car + 1;
                    end 
              4'h5: begin
                    DR <= memory[AR];
                    PC <= PC + 1;
                    car <= car + 1;
                    end
              4'h6: begin
                    if (PSW[1]) PC <= DR;     
                    if (~PSW[2]) fetch <= 1; 
                    execute <= 0;
                    car <= 1;
                    end
              endcase
         
       8'hA9:
             case(car)
             4'h4: begin
                   AR <= PC;
                   car <= car + 1;
                   end
             4'h5: begin
                   DR <= memory[AR];
                   PC <= PC + 1;
                   car <= car + 1;
                   end
             4'h6: begin
                   if (PSW[0]) PC <= DR;
                   if (~PSW[2]) fetch <= 1;
                   execute <= 0;
                   car <= 1;
                   end
             endcase


             
      8'hE0:
             case(car)
             4'h4: begin
                   AR <= PC;
                   car <= car + 1;
                   end
             4'h5: begin
                   DR <= memory[AR];
                   PC <= PC + 1;
                   car <= car + 1;
                   end
             4'h6: begin
                   if (DR == 0) in = A;
                   if (DR == 1) out = A;
                   if (~PSW[2]) fetch <= 1;
                   execute <= 0;
                   car <= 1;                   
                   end
             endcase      
      8'h00:
            case(car)
            4'h4: begin
                  if (~PSW[2]) fetch <= 1;
                  execute <= 0;
                  car <= 1;
                  end
            endcase
      8'hF0:
           case(car)
           4'h4: begin
                 PSW[3] <= 1;
                 PSW[2] <= 0;
                 car <= 1;
                 execute <= 0;
                 fetch <= 1;
                 end
           endcase
     8'hF1:
           case(car)
           4'h4: begin
                 PSW[3] <= 0;
                 PSW[2] <= 1;
                 car <= 1;
                 execute <= 0;
                 fetch <= 1;
                 end
           endcase                              
          endcase
          end
      end                      

   always @(*)
     begin
        an = 4'b1111;
        case ( q[20:19] )
          2'b00:
            begin
               an = 4'b1110; // activate display 0
               disp = out[3:0];
            end
          2'b01:
            begin
               an = 4'b1101; // activate display 1
               disp = out[7:4];
            end
          2'b10:
            begin
               an = 4'b1011; // activate display 2
               disp = in[3:0]; // send MSB first
            end
          2'b11:
            begin
               an = 4'b0111;
               disp = in[7:4]; // hex digit to display
            end
        endcase
     end
     

    
   always @(*)
  begin
     case (disp)
       4'b0000: seg = 7'b1000000;
       4'b0001: seg = 7'b1111001;
       4'b0010: seg = 7'b0100100;
       4'b0011: seg = 7'b0110000;
       4'b0100: seg = 7'b0011001;
       4'b0101: seg = 7'b0010010;
       4'b0110: seg = 7'b0000010;
       4'b0111: seg = 7'b1111000;
       4'b1000: seg = 7'b0000000;
       4'b1001: seg = 7'b0010000;
       4'b1010: seg = 7'b0001000;
       4'b1011: seg = 7'b0000011;
       4'b1100: seg = 7'b1000110;
       4'b1101: seg = 7'b0100001;
       4'b1110: seg = 7'b0000110;
       4'b1111: seg = 7'b0001110;
     endcase
  end        
                
   always @(posedge clk)
    begin
       q <= q + 1;
    end        
    
endmodule


