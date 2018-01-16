#switch
set_property PACKAGE_PIN V17 [get_ports {a}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {a}]
set_property PACKAGE_PIN V16 [get_ports {b}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {b}]
 
 #LED
set_property PACKAGE_PIN U16 [get_ports {myAND}]					
     set_property IOSTANDARD LVCMOS33 [get_ports {myAND}]
 set_property PACKAGE_PIN E19 [get_ports {myNOT}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {myNOT}]
 set_property PACKAGE_PIN U19 [get_ports {myOR}]                
     set_property IOSTANDARD LVCMOS33 [get_ports {myOR}]