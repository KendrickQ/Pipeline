##100MHz
#set_property PACKAGE_PIN P17 [get_ports sysclk]
#set_property IOSTANDARD LVCMOS33 [get_ports sysclk]
#create_clock -name clk -period 100.000 [get_ports sysclk]

#100MHz
set_property PACKAGE_PIN P17 [get_ports clk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {reset_IBUF}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name clk -period 10.000 [get_ports clk]

#S6
set_property PACKAGE_PIN R17 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

#cathodes
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports {cathodes[7]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {cathodes[6]}]
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {cathodes[5]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {cathodes[4]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {cathodes[3]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {cathodes[2]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {cathodes[1]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {cathodes[0]}]