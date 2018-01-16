##Buttons 
set_property PACKAGE_PIN U18 [get_ports c[0]] 
    set_property IOSTANDARD LVCMOS33 [get_ports c[0]] 
set_property PACKAGE_PIN T18 [get_ports c[4]] 
    set_property IOSTANDARD LVCMOS33 [get_ports c[4]] 
set_property PACKAGE_PIN W19 [get_ports c[3]] 
    set_property IOSTANDARD LVCMOS33 [get_ports c[3]] 
set_property PACKAGE_PIN T17 [get_ports c[2]] 
    set_property IOSTANDARD LVCMOS33 [get_ports c[2]] 
set_property PACKAGE_PIN U17 [get_ports c[1]] 
    set_property IOSTANDARD LVCMOS33 [get_ports c[1]] 
    
    
##7 segment display 
set_property PACKAGE_PIN W7 [get_ports {seg[0]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}] 
set_property PACKAGE_PIN W6 [get_ports {seg[1]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}] 
set_property PACKAGE_PIN U8 [get_ports {seg[2]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}] 
set_property PACKAGE_PIN V8 [get_ports {seg[3]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}] 
set_property PACKAGE_PIN U5 [get_ports {seg[4]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}] 
set_property PACKAGE_PIN V5 [get_ports {seg[5]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}] 
set_property PACKAGE_PIN U7 [get_ports {seg[6]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}] 
    
##connect control signals 
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

## led15
set_property PACKAGE_PIN L1 [get_ports {led15}]					
        set_property IOSTANDARD LVCMOS33 [get_ports {led15}]
        
## led
set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]