set_property file_type "Verilog Header" [get_files vram_parameters.v]
set_property is_global_include true [get_files vram_parameters.v]

set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
