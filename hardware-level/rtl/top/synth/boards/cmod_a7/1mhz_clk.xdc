
## Controller Clock Signal
create_generated_clock -name controller_clk_in -source [get_pins clk_src/inst/clk_8] -divide_by 16 [get_pins controller_clk_divider/clk_out_INST_0/O]

## CPU Clock Signal
create_generated_clock -name cpu_clk -source [get_pins clk_src/inst/clk_8] -divide_by 8 [get_pins cpu_clk_divider/clk_out_INST_0/O]
