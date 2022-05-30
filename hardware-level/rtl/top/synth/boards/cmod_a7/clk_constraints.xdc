
## CPU Clock Signal
create_generated_clock -name cpu_clk -source [get_pins cpu_clk_divider/clk_in] -divide_by 2 [get_pins cpu_clk_divider/clk_out]

## Controller Clock Signal
create_generated_clock -name controller_clk_in -source [get_pins controller_clk_divider/clk_in] -divide_by 16 [get_pins controller_clk_divider/clk_out]
