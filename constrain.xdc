#100MHz
set_property PACKAGE_PIN P17 [get_ports sysclk]
set_property IOSTANDARD LVCMOS33 [get_ports sysclk]
create_clock -name clk -period 100.000 [get_ports sysclk]