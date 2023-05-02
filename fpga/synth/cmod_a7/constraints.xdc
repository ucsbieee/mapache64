
# Artix-7
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# Bitstream
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

# CPU Clock Signal
create_generated_clock -name cpu_clk -source [get_pins cpu_clk_divider/clk_i] -divide_by 2 [get_pins cpu_clk_divider/clk_o]
set_false_path -from [get_clocks clk_12_5875_clk_mmcm] -to [get_clocks cpu_clk]

# Controller Clock Signal
create_generated_clock -name controller_clk -source [get_pins controller_clk_divider/clk_i] -divide_by 16 [get_pins controller_clk_divider/clk_o]
set_false_path -from [get_clocks clk_12_5875_clk_mmcm] -to [get_clocks controller_clk]

# VGA Speed
set_output_delay -clock clk_12_5875_clk_mmcm -max 2.0 [get_ports {pio28 pio27 pio30 pio29 pio32 pio31 pio33 pio34}]
