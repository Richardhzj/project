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


module final_project(cs, sck, mosi, miso, clk, rst, seg, an, led);
input cs, sck, mosi, clk, rst;
output miso;
output reg [6:0] seg;                                 // 7- segment display
output reg [3:0] an;                              // anodes of 4 7-segment display
output [15:0] led;                                // utilized for testing

// Memory & Display
reg [7:0] memory [0:255];                         // main memory
reg [7:0] IO_Mem[0:1];                             // Input / Output Address Space
reg [8:0] mem_pointer= 9'h1ff;                        // Memory Pointer
reg [20:0] q;                                     // divider for system clock / clk
reg [3:0] disp;                                   // hex digit to display
reg [1:0] display_clk;                            // clock for display
reg [7:0] x, y;
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

// Data Transfer Instructions
parameter MOV_A_ADD  =  8'h11,
          MOV_AP_ADD =  8'h13,
          MOV_A_OP   =  8'h19,
          MOV_AP_OP  =  8'h1B,
          MOV_A_AP   =  8'h14,
          MOV_B_OP   =  8'h1C,
// Arithmetic Instructions
          ADD_A_ADD  =  8'h31,
          ADD_A_OP   =  8'h39,
          SUB_A_ADD  =  8'h41,
          SUB_A_OP   =  8'h49,
          ADD_AP_OP  =  8'h3B,
          SUB_AP_OP  =  8'h4B,
          SUB_B_OP   =  8'h4C,
          ADD_A_AP   =  8'h34,
          SUB_A_AP   =  8'h44,
// Logic Instructions
          NOT        =  8'h50,
          SH_RIGHT   =  8'h90,
          OR_A_ADDR  =  8'h61,
          AND_A_ADDR =  8'h71,
          XOR_A_ADDR =  8'h81,
          OR_A_OP    =  8'h69,
          AND_A_OP   =  8'h79,
          XOR_A_OP   =  8'h89,
// Output Instructions
          OUT_ADDR_A =  8'hE0,
// Program Control Instructions
          JMP_ADDR   =  8'hA1,
          JMP_Z_ADDR =  8'hA5,
          JMP_C_ADDR =  8'hA9,
// Microprocessor Control Instructions
          NO_OP      =  8'h00,
          HALT       =  8'hF0,
          TRACE      =  8'hF1,
// Interface to STM
          READY      =  8'h04,
          EMPTY      =  8'h08,
          FULL       =  8'h09,
          PUSH       =  8'h0A,
          POP        =  8'h0B,
          PEEK       =  8'h0C,
          RUN        =  8'h40,
          STEP       =  8'h41,
          REG        =  8'h42,
          DUMP       =  8'h43;
 
// sync sck to FPGA clock q[5] using 3-bit shift register
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
          
          
         
// I/O


// Microprocessor
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
//    case (byte_A)
//        REG:
//        case (bitcnt)
//        12'd08: ret_msg <= A;
//        12'd16: ret_msg <= B;
//        12'd24: ret_msg <= AR;
//        12'd32: ret_msg <= DR;
//        12'd40: ret_msg <= PC;
//        12'd48: ret_msg <= AP;
//        12'd56: ret_msg <= IR;
//        12'd64: ret_msg <= T;
//        12'd72: ret_msg <= PSW;
//        endcase
//    endcase
    
    // Process Commands from STM board
    if (sck_fallingedge)
    begin
        case (byte_A)
                
        READY:
        case (bitcnt)
        5'h09: ret_msg <= 8'h01;
        endcase
                
        EMPTY:
        case (bitcnt)
        5'h09:
        if (mem_pointer == 0)
        ret_msg <= 1;
        else
        ret_msg <= 2;
        endcase  
                                
        FULL:
        case (bitcnt)
        5'h09:
        if (mem_pointer == 9'h100)
        ret_msg <= 1;
        else
        ret_msg <= 2;
        endcase  
                                  
        PUSH:
        case (bitcnt)
        5'h12: mem_pointer <= mem_pointer + 1;
        5'h13: memory[mem_pointer] <= byte_B;
        endcase  
                             
        POP:
        case (bitcnt)
        5'h09: ret_msg <= memory[mem_pointer];
        5'h0A: mem_pointer <= mem_pointer - 1;
        endcase   
                            
        PEEK:
        case (bitcnt)
        5'h09: ret_msg <= memory[mem_pointer];// - 1];
        endcase  
                              
        RUN:
        if ((bitcnt == 5'h09) && `HALT)
        begin
        `HALT   <= 0;
        PC      <= 0;
        PSW     <= 0;
        car     <= 1;
        fetch   <= 1;
        execute <= 0;
        end   
                           
        STEP:
        if ((bitcnt == 5'h09) && `TRACE)
        begin
        car     <= 1;
        fetch   <= 1;
        execute <= 0;
        end

        REG:
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
//    endcase
        
        DUMP:
        begin//case (bitcnt)
        mem_pointer <= (bitcnt - 8)/8;
        ret_msg <= memory[mem_pointer];       
        end
           
       endcase
     end
    end
  // end
         
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
       MOV_A_ADD:
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
          
        MOV_B_OP:
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
           
        MOV_AP_ADD :  
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
                
      MOV_A_OP:        
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
                
      MOV_AP_OP:  
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
              
      MOV_A_AP:  
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
              4'h6: begin
              A <= DR;
              execute <= 0;
              car <= 1;
              if (~PSW[2]) fetch <= 1;
              end            
              endcase
                                   
      // ARITHMETIC INSTRUCTIONS
      ADD_A_ADD:  
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
                
         ADD_A_OP:  
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
                
         SUB_A_ADD:  
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
                
         SUB_A_OP:  
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
               
         ADD_AP_OP:  
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
               
         SUB_AP_OP:  
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
         SUB_B_OP:  
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
         ADD_A_AP:  
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
        SUB_A_AP:  
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
         NOT :                                
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
          SH_RIGHT:                                
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
          OR_A_ADDR:                                
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
          AND_A_ADDR:                                
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
          XOR_A_ADDR:                               
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
          OR_A_OP:                                
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
              
          AND_A_OP:                                
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

          XOR_A_OP:                                
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
              
              
              
        JMP_Z_ADDR:                                 
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
                    if (PSW[1]) PC <= DR;    // Jump if Zero set 
                    if (~PSW[2]) fetch <= 1; // Continue if Trace is off
                    execute <= 0;
                    car <= 1;
                    end
              endcase
         
       JMP_C_ADDR:
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

       JMP_ADDR:
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
             
      OUT_ADDR_A:
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
                   if (DR == 0) x = A;
                   if (DR == 1) y = A;
                   if (~PSW[2]) fetch <= 1;
                   execute <= 0;
                   car <= 1;                   
                   end
             endcase      
      NO_OP:
            case(car)
            4'h4: begin
                  if (~PSW[2]) fetch <= 1;
                  execute <= 0;
                  car <= 1;
                  end
            endcase
      HALT:
           case(car)
           4'h4: begin
                 PSW[3] <= 1;
                 PSW[2] <= 0;
                 car <= 1;
                 execute <= 0;
                 fetch <= 1;
                 end
           endcase
     TRACE:
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



//end

  // activate displays
//   reg [3:0] disp;
   always @(*)
     begin
        an = 4'b1111;
        case ( q[20:19] )
          2'b00:
            begin
               an = 4'b1110; // activate display 0
               disp = y[3:0];
            end
          2'b01:
            begin
               an = 4'b1101; // activate display 1
               disp = y[7:4];
            end
          2'b10:
            begin
               an = 4'b1011; // activate display 2
               disp = x[3:0]; // send MSB first
            end
          2'b11:
            begin
               an = 4'b0111;
               disp = x[7:4]; // hex digit to display
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





//module seg7dec(B, out);
//   input [3:0]B;
//    output reg [6:0] out;
//    always @ (B)
//    begin
//        case (B)
//        0 : out = 7'b1000000;
//        1 : out = 7'b1111001;
//        2 : out = 7'b0100100;
//        3 : out = 7'b0110000; 
//        4 : out = 7'b0011001; 
//        5 : out = 7'b0010010; 
//        6 : out = 7'b0000010; 
//        7 : out = 7'b1111000;
//        8 : out = 7'b0000000; 
//        9 : out = 7'b0010000;
//        10 : out = 7'b0001000;
//        11 : out = 7'b0000011;
//        12 : out = 7'b1000110;
//        13 : out = 7'b0100001;
//        14 : out = 7'b0000110;
//        15 : out = 7'b0001110;
        
        
//        default : out = 7'b1111111;
//        endcase
//     end
// endmodule  




