
# 100 MHz CLK
set_property PACKAGE_PIN E3 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]


# BTNU
set_property PACKAGE_PIN M18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]


# Switches
set_property PACKAGE_PIN V10 [get_ports {cpu_address[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[15]}]
set_property PACKAGE_PIN U11 [get_ports {cpu_address[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[14]}]
set_property PACKAGE_PIN U12 [get_ports {cpu_address[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[13]}]
set_property PACKAGE_PIN H6  [get_ports {cpu_address[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[12]}]
set_property PACKAGE_PIN T13 [get_ports {cpu_address[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[11]}]
set_property PACKAGE_PIN R16 [get_ports {cpu_address[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[10]}]
set_property PACKAGE_PIN U8  [get_ports {cpu_address[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[9]}]
set_property PACKAGE_PIN T8  [get_ports {cpu_address[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[8]}]
set_property PACKAGE_PIN R13 [get_ports {cpu_address[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[7]}]
set_property PACKAGE_PIN U18 [get_ports {cpu_address[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[6]}]
set_property PACKAGE_PIN T18 [get_ports {cpu_address[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[5]}]
set_property PACKAGE_PIN R17 [get_ports {cpu_address[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[4]}]
set_property PACKAGE_PIN R15 [get_ports {cpu_address[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[3]}]
set_property PACKAGE_PIN M13 [get_ports {cpu_address[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[2]}]
set_property PACKAGE_PIN L16 [get_ports {cpu_address[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[1]}]
set_property PACKAGE_PIN J15 [get_ports {cpu_address[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address[0]}]


# JA
# V G 6 4 2 0
# V G 7 5 3 1
set_property PACKAGE_PIN G18 [get_ports {data_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[7]}]
set_property PACKAGE_PIN G17 [get_ports {data_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[6]}]
set_property PACKAGE_PIN F18 [get_ports {data_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[5]}]
set_property PACKAGE_PIN E18 [get_ports {data_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[4]}]
set_property PACKAGE_PIN E17 [get_ports {data_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[3]}]
set_property PACKAGE_PIN D18 [get_ports {data_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[2]}]
set_property PACKAGE_PIN D17 [get_ports {data_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[1]}]
set_property PACKAGE_PIN C17 [get_ports {data_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[0]}]


# LEDs
set_property PACKAGE_PIN U16 [get_ports {data_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[7]}]
set_property PACKAGE_PIN U17 [get_ports {data_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[6]}]
set_property PACKAGE_PIN V17 [get_ports {data_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[5]}]
set_property PACKAGE_PIN R18 [get_ports {data_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[4]}]
set_property PACKAGE_PIN N14 [get_ports {data_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[3]}]
set_property PACKAGE_PIN J13 [get_ports {data_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[2]}]
set_property PACKAGE_PIN K15 [get_ports {data_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[1]}]
set_property PACKAGE_PIN H17 [get_ports {data_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[0]}]


# BTNC
set_property PACKAGE_PIN N17 [get_ports write_enable]
set_property IOSTANDARD LVCMOS33 [get_ports write_enable]


# JD           JC
# V G e c a 8  V G 6 4 2 0
# V G z d b 9  V G 7 5 3 1
set_property PACKAGE_PIN G3  [get_ports {output_address[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[14]}]
set_property PACKAGE_PIN G2 [get_ports {output_address[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[13]}]
set_property PACKAGE_PIN G1  [get_ports {output_address[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[12]}]
set_property PACKAGE_PIN G4 [get_ports {output_address[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[11]}]
set_property PACKAGE_PIN H1 [get_ports {output_address[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[10]}]
set_property PACKAGE_PIN H2  [get_ports {output_address[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[9]}]
set_property PACKAGE_PIN H4  [get_ports {output_address[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[8]}]
set_property PACKAGE_PIN E6  [get_ports {output_address[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[7]}]
set_property PACKAGE_PIN G6  [get_ports {output_address[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[6]}]
set_property PACKAGE_PIN J4  [get_ports {output_address[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[5]}]
set_property PACKAGE_PIN J2  [get_ports {output_address[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[4]}]
set_property PACKAGE_PIN J3  [get_ports {output_address[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[3]}]
set_property PACKAGE_PIN F6  [get_ports {output_address[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[2]}]
set_property PACKAGE_PIN E7  [get_ports {output_address[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[1]}]
set_property PACKAGE_PIN K1  [get_ports {output_address[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_address[0]}]


# JB
# V G 6 4 2 0
# V G 7 5 3 1

# 0
set_property PACKAGE_PIN D14 [get_ports SELECT_ram]
set_property IOSTANDARD LVCMOS33 [get_ports SELECT_ram]

# 1
set_property PACKAGE_PIN E16 [get_ports SELECT_rom]
set_property IOSTANDARD LVCMOS33 [get_ports SELECT_rom]

# 2
set_property PACKAGE_PIN F16 [get_ports SELECT_controller]
set_property IOSTANDARD LVCMOS33 [get_ports SELECT_controller]

# 3
set_property PACKAGE_PIN F13 [get_ports vblank_irq]
set_property IOSTANDARD LVCMOS33 [get_ports vblank_irq]


# VGA
set_property PACKAGE_PIN A4 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN C5 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]

set_property PACKAGE_PIN A6 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN B6 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]

set_property PACKAGE_PIN D8 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN D7 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]

set_property PACKAGE_PIN B11 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]

set_property PACKAGE_PIN B12 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

