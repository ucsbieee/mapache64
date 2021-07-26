
/* gpu.v */


`ifdef LINTER
    `include "video-timing.v"
    `include "foreground.sv"
    `include "background.sv"
    `include "../headers/parameters.vh"
`endif


module gpu_m (
    input                           clk, // 12.5875 MHz
    input                           rst,

    // video output
    output wire               [1:0] r, g, b,
    output wire                     hsync, vsync,

    // VRAM interface
    input                     [7:0] data,
    input    [`VRAM_ADDR_WIDTH-1:0] address
);

    wire [7:0] xp, yp;
    wire visible, writable, foreground_valid;

    wire [1:0] foreground_r, foreground_g, foreground_b;
    wire [1:0] background_r, background_g, background_b;

    assign {r,g,b} = foreground_valid ? {foreground_r,foreground_g,foreground_b} : {background_r,background_g,background_b};

    video_timing_m video_timing (
        clk, rst,
        hsync, vsync,
        xp, yp,
        visible,
        writable
    );

    assign foreground_valid = 1'b0;
    // foreground_m foreground (
    //     clk, rst,
    //     xp, yp,
    //     visible, writable,
    //     foreground_r, foreground_g, foreground_b,
    //     foreground_valid,
    //     data, address
    // );

    background_m background (
        clk, rst,
        xp, yp,
        visible, writable,
        background_r, background_g, background_b,
        data, address
    );

endmodule
