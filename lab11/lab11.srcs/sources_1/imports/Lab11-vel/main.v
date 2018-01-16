`timescale 1ns / 1ps
//--------------------------------------------------------
// Lab11: SPI communication and stack memory
// Implementation with system clock
//--------------------------------------------------------
module Lab11(cs, sck, mosi, miso, clk, seg, an, led);
   input cs, sck, clk, mosi; // sck = SPI clock, clk = system clock 100 MHz
   output miso;
   output reg [6:0] seg; // 7-segment display
   output reg [3:0] an; // anodes of 4 7-segment displays
   reg [7:0]        stack [0:255]; // stack memory
   reg [8:0]        mem_ptr; // Pointer to memory, stack pointer

   output [15:0] led;
   assign led[8:0] = mem_ptr[8:0];

   // synchronize sck to the FPGA clock q[5] using a 3-bit shift register
   reg [2:0]        sckr;
   always @(posedge q[5])
     sckr <= {sckr[1:0], sck};
   wire             sck_risingedge = (sckr[2:1] == 2'b01); // detect sck rising edge
   wire             sck_fallingedge = (sckr[2:1] == 2'b10); // detect sck falling edge

   // synchronize cs to the FPGA clock q[5] using a 3-bit shift register
   reg [2:0]        csr;
   always @(posedge q[5])
     csr <= {csr[1:0], cs};
   wire cs_active = ~csr[1]; // cs is active low
   wire             cs_startmessage = (csr[2:1] == 2'b10);
   //msg starts at falling edge
   wire             cs_endmessage = (csr[2:1] == 2'b01);
   // msg stops at rising edge

   // synchronize mosi to the FPGA clock q[5] using a 2-bit shift register
   reg [1:0]        mosir;
   always @(posedge q[5])
     mosir <= {mosir[0], mosi};
   wire             mosi_data = mosir[1];

   // receive 8-bits from STM board
   reg [4:0]        bitcnt;
   reg [7:0]        byte_A, byte_B; // bytes A and B received from STM board
   reg [7:0]        in_byte;

   always @(posedge q[5])
     begin
        if(~cs_active)
          bitcnt <= 5'b00000; // reset bit counter at the beginning
        else
          if(sck_risingedge)
            begin
               bitcnt <= bitcnt + 5'b00001;
               // shift-left, since we receive the MSB first
               in_byte <= {in_byte[6:0], mosi_data};
            end
     end

   always @(posedge q[5])
     begin
        if (cs_active && sck_risingedge && (bitcnt==5'b01000))
          byte_A <= in_byte;
        if (cs_active && sck_risingedge && (bitcnt==5'b10000))
          byte_B <= in_byte;
     end

   // Processing commands from the STM board
   reg [7:0] ret_message;
   always @(posedge q[5])
     begin
         if (sck_risingedge) begin
            case (byte_A)
            8'h04: // "stack ready"
                case ( bitcnt )
                5'h09: ret_message <= 8'h01; // message to the STM board
                endcase
            8'h08: // "stack empty"
                case ( bitcnt )
                5'h09:
                    if (mem_ptr == 0)
                    ret_message <= 1;
                    else
                    ret_message <= 2;
                endcase
            8'h09:
                case ( bitcnt ) // "stack full"
                5'h09:
                    if (mem_ptr == 9'h100)
                    ret_message <= 1;
                    else
                    ret_message <= 2;
                endcase
            8'h0a: // "stack push"
                case ( bitcnt )
                5'h12: mem_ptr <= mem_ptr - 1;
                5'h13: stack[ mem_ptr ] <= byte_B;
                endcase
            8'h0B: // "stack pop"
                case ( bitcnt )
                5'h09: ret_message <= stack[ mem_ptr ] ;
                5'h0A: mem_ptr <= mem_ptr + 1;
                endcase
                
            8'h0C: //"stack peek"
                case (bitcnt )
                5'b01001: ret_message <= stack[mem_ptr];
                endcase
            
            8'h10: //"and"
                case (bitcnt)
                5'b01001: begin
                    stack[mem_ptr +1] = stack[mem_ptr+1] & stack[mem_ptr];
                    mem_ptr = mem_ptr+1;
                    ret_message <= stack[mem_ptr];
                    end
                endcase
            
            8'h11: //"or"
                case (bitcnt)
                5'b01001:begin
                    stack[mem_ptr+1] = stack[mem_ptr+1] | stack[mem_ptr];
                    mem_ptr = mem_ptr+1;
                    ret_message <= stack[mem_ptr];
                    end
                endcase
            
            8'h12: //"not"
                case (bitcnt)
                5'b01001:begin
                stack[mem_ptr] = ~stack[mem_ptr];
                ret_message = stack[mem_ptr];
                end
                endcase
            8'h13: //"xor"
                case (bitcnt)
                5'b01001:begin
                stack[mem_ptr+1] = stack[mem_ptr+1]^stack[mem_ptr];
                mem_ptr = mem_ptr+1;
                ret_message <= stack[mem_ptr];
                end 
                endcase
                
            8'h20: //"add"
                case (bitcnt)
                5'b01001:begin
                stack[mem_ptr+1]= stack[mem_ptr] + stack[mem_ptr+1];
                mem_ptr = mem_ptr+1;
                ret_message <= stack[mem_ptr];
                end
                endcase
            8'h21: //"sbu"
                case(bitcnt)
                5'b01001:begin
                stack[mem_ptr+1] = stack[mem_ptr+1] - stack[mem_ptr];
                mem_ptr = mem_ptr+1;
                ret_message <= stack[mem_ptr];
                end 
                endcase
            
            8'h22:  //inc
                case(bitcnt)
                5'b01001:begin
                stack[mem_ptr] = stack[mem_ptr]+1;
                ret_message<=stack[mem_ptr];
                end
                endcase
                
            8'h23: //mult
                case (bitcnt)
                5'b01001:begin
                stack[mem_ptr+1]= stack[mem_ptr]*stack[mem_ptr+1];
                mem_ptr = mem_ptr+1;
                ret_message <= stack[mem_ptr];
                end
                endcase
             8'h24: //mod
                case (bitcnt)
                5'b01001:begin
                stack[mem_ptr+1]= stack[mem_ptr] % stack[mem_ptr + 1];
                mem_ptr = mem_ptr+1;
                ret_message <= stack[mem_ptr];
                end
                endcase
                 
            endcase            
        end
        end
     


   // Send byte C to the STM board, starting at bitcnt = 10h
   reg [7:0] out_byte;
   always @(posedge q[5])
     begin
        if(cs_active)
          begin
             if(bitcnt == 5'b10000)
               out_byte <= ret_message;
             else
               if(sck_fallingedge)
                 out_byte <= {out_byte[6:0], out_byte[7]};
          end
     end

   assign miso = out_byte[7];
   // activate displays
   reg [3:0] disp;
   always @(*)
     begin
        an = 4'b1111;
        case ( q[20:19] )
          2'b00:
            begin
               an = 4'b1110; // activate display 0
               disp = byte_B[3:0];
            end
          2'b01:
            begin
               an = 4'b1101; // activate display 1
               disp = byte_B[7:4];
            end
          2'b10:
            begin
               an = 4'b1011; // activate display 2
               disp = byte_A[3:0]; // send MSB first
            end
          2'b11:
            begin
               an = 4'b0111;
               disp = byte_A[7:4]; // hex digit to display
            end
        endcase
     end

   // 7-segment display
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

   // scale down the system clock
   reg [20:0] q;
   always @(posedge clk)
     begin
        q <= q + 1;
     end
endmodule
