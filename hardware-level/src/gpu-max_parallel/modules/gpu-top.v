
/* gpu-top.v */


`include "parameters.v"

`include "modules/ram.v"
`include "modules/gpu.v"

module gpu_top_m (
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

    // To Do

    // ram_m vram (
    //     address, data,
    //     we, oe, cs
    // );

    // gpu_m gpu (
    //     clk, rst,
    //     r,b,g, hsync, vsync,
    //     data, address, vram_read
    // );

endmodule
