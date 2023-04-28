
## CPU Clock Signal
create_generated_clock -name cpu_clk -source [get_pins cpu_clk_divider/clk_i] -divide_by 2 [get_pins cpu_clk_divider/clk_o]

## Controller Clock Signal
create_generated_clock -name controller_clk_i -source [get_pins controller_clk_divider/clk_i] -divide_by 16 [get_pins controller_clk_divider/clk_o]
