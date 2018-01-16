##7 segment display 
set_property PACKAGE_PIN W7 [get_ports {S[6]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {S[6]}] 
set_property PACKAGE_PIN W6 [get_ports {S[5]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {S[5]}] 
set_property PACKAGE_PIN U8 [get_ports {S[4]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {S[4]}] 
set_property PACKAGE_PIN V8 [get_ports {S[3]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {S[3]}] 
set_property PACKAGE_PIN U5 [get_ports {S[2]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {S[2]}] 
set_property PACKAGE_PIN V5 [get_ports {S[1]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {S[1]}] 
set_property PACKAGE_PIN U7 [get_ports {S[0]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {S[0]}] 

set_property PACKAGE_PIN U2 [get_ports {an[0]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}] 
set_property PACKAGE_PIN U4 [get_ports {an[1]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}] 
set_property PACKAGE_PIN V4 [get_ports {an[2]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}] 
set_property PACKAGE_PIN W4 [get_ports {an[3]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}] 

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
##Pmod Header JA
    ##Sch name = JA1
    set_property PACKAGE_PIN J1 [get_ports {SCK}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {SCK}]
    ##Sch name = JA2
    set_property PACKAGE_PIN L2 [get_ports {MISO}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {MISO}]
    ##Sch name = JA3
    set_property PACKAGE_PIN J2 [get_ports {MOSI}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {MOSI}]
    ##Sch name = JA4
    set_property PACKAGE_PIN G2 [get_ports {CS}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {CS}]
        

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SCK_IBUF] 

