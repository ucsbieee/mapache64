
/* gpu.v */


`include "parameters.v"

module gpu_m (
    input                           clk, // 12.5875 MHz
    input                           rst,

    output                    [1:0] r, g, b,
    output                          hsync, vsync,

    input                     [7:0] data,
    output   [`VRAM_ADDR_WIDTH-1:0] address,
    output                          vram_read
);

    // To Do

endmodule
