
/* gpu.v */


`include "modules/gpu-counters.v"

`include "parameters.v"

module gpu_m (
    input                           clk, // 12.5875 MHz
    input                           rst,

    // DVI output
    output                    [1:0] r, g, b,
    output                          hsync, vsync,

    // VRAM interface
    input                     [7:0] data,
    input    [`VRAM_ADDR_WIDTH-1:0] address,
    input                           cs
);


    wire [9:0] hcounter, vcounter;
    wire hvisible, vvisible;

    gpu_counters_m gpu_counters (
        clk, rst,
        hcounter, hvisible, hsync,
        vcounter, vvisible, vsync
    );


    assign r = 0;
    assign g = 0;
    assign b = 0;

endmodule
