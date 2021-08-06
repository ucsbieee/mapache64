
# Connect clk_in to 100 MHz CLK
set_property PACKAGE_PIN E3 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]


# Connect rst_in_B to CPU RESET
set_property PACKAGE_PIN C12 [get_ports rst_in_B]
set_property IOSTANDARD LVCMOS33 [get_ports rst_in_B]


# Connect cpu_address to JA and JB
set_property PACKAGE_PIN H16 [get_ports {cpu_address_in[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[15]}]
set_property PACKAGE_PIN G13 [get_ports {cpu_address_in[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[14]}]
set_property PACKAGE_PIN F13 [get_ports {cpu_address_in[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[13]}]
set_property PACKAGE_PIN E16 [get_ports {cpu_address_in[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[12]}]
set_property PACKAGE_PIN H14 [get_ports {cpu_address_in[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[11]}]
set_property PACKAGE_PIN G16 [get_ports {cpu_address_in[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[10]}]
set_property PACKAGE_PIN F16 [get_ports {cpu_address_in[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[9]}]
set_property PACKAGE_PIN D14 [get_ports {cpu_address_in[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[8]}]
set_property PACKAGE_PIN G18 [get_ports {cpu_address_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[7]}]
set_property PACKAGE_PIN F18 [get_ports {cpu_address_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[6]}]
set_property PACKAGE_PIN E17 [get_ports {cpu_address_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[5]}]
set_property PACKAGE_PIN D17 [get_ports {cpu_address_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[4]}]
set_property PACKAGE_PIN G17 [get_ports {cpu_address_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[3]}]
set_property PACKAGE_PIN E18 [get_ports {cpu_address_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[2]}]
set_property PACKAGE_PIN D18 [get_ports {cpu_address_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[1]}]
set_property PACKAGE_PIN C17 [get_ports {cpu_address_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_in[0]}]


# Display cpu_address on LEDs
set_property PACKAGE_PIN V11 [get_ports {cpu_address_out[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[15]}]
set_property PACKAGE_PIN V12 [get_ports {cpu_address_out[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[14]}]
set_property PACKAGE_PIN V14 [get_ports {cpu_address_out[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[13]}]
set_property PACKAGE_PIN V15 [get_ports {cpu_address_out[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[12]}]
set_property PACKAGE_PIN T16 [get_ports {cpu_address_out[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[11]}]
set_property PACKAGE_PIN U14 [get_ports {cpu_address_out[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[10]}]
set_property PACKAGE_PIN T15 [get_ports {cpu_address_out[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[9]}]
set_property PACKAGE_PIN V16 [get_ports {cpu_address_out[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[8]}]
set_property PACKAGE_PIN U16 [get_ports {cpu_address_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[7]}]
set_property PACKAGE_PIN U17 [get_ports {cpu_address_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[6]}]
set_property PACKAGE_PIN V17 [get_ports {cpu_address_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[5]}]
set_property PACKAGE_PIN R18 [get_ports {cpu_address_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[4]}]
set_property PACKAGE_PIN N14 [get_ports {cpu_address_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[3]}]
set_property PACKAGE_PIN J13 [get_ports {cpu_address_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[2]}]
set_property PACKAGE_PIN K15 [get_ports {cpu_address_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[1]}]
set_property PACKAGE_PIN H17 [get_ports {cpu_address_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cpu_address_out[0]}]


# Connect data to JC
set_property PACKAGE_PIN E6  [get_ports {data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[7]}]
set_property PACKAGE_PIN J4  [get_ports {data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[6]}]
set_property PACKAGE_PIN J3  [get_ports {data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[5]}]
set_property PACKAGE_PIN E7  [get_ports {data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[4]}]
set_property PACKAGE_PIN G6  [get_ports {data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[3]}]
set_property PACKAGE_PIN J2  [get_ports {data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[2]}]
set_property PACKAGE_PIN F6  [get_ports {data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[1]}]
set_property PACKAGE_PIN K1  [get_ports {data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[0]}]


# JD
# V G x 3 2 1
# V G a 9 8 7

# 1
set_property PACKAGE_PIN H4  [get_ports rst_out_B]
set_property IOSTANDARD LVCMOS33 [get_ports rst_out_B]

# 2
set_property PACKAGE_PIN H1  [get_ports vblank_irq_B]
set_property IOSTANDARD LVCMOS33 [get_ports vblank_irq_B]

# 3
set_property PACKAGE_PIN G1  [get_ports write_enable_B]
set_property IOSTANDARD LVCMOS33 [get_ports write_enable_B]

# 4
set_property PACKAGE_PIN G3  [get_ports SELECT_controller]
set_property IOSTANDARD LVCMOS33 [get_ports SELECT_controller]

# 7
set_property PACKAGE_PIN H2  [get_ports SELECT_ram_B]
set_property IOSTANDARD LVCMOS33 [get_ports SELECT_ram_B]

# 8
set_property PACKAGE_PIN G4  [get_ports ram_OE_B]
set_property IOSTANDARD LVCMOS33 [get_ports ram_OE_B]

# 9
set_property PACKAGE_PIN G2  [get_ports SELECT_rom_B]
set_property IOSTANDARD LVCMOS33 [get_ports SELECT_rom_B]


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

