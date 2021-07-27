
/* gpu.v */


`ifdef INCLUDE
    `include "video-timing.v"
    `include "foreground.sv"
    `include "background.sv"
    `include "headers/parameters.vh"
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

    wire [8:0] xp, yp;
    wire [9:0] hcounter, vcounter;
    wire visible, writable, foreground_valid;

    wire [1:0] foreground_r, foreground_g, foreground_b;
    wire [1:0] background_r, background_g, background_b;

    wire drawing = visible && (0 <= xp && xp < 256) && (0 <= yp && yp < 240);

    assign {r,g,b} = !drawing           ? 3'b0 :
                    foreground_valid    ? {foreground_r,foreground_g,foreground_b} :
                    {background_r,background_g,background_b};


    assign xp = hcounter[8:0] - 9'd32;
    assign yp = vcounter[9:1];

    video_timing_m video_timing (
        clk, rst,
        hsync, vsync,
        hcounter, vcounter,
        visible,
        writable
    );

    foreground_m foreground (
        clk, rst,
        xp[7:0], yp[7:0],
        visible, writable,
        foreground_r, foreground_g, foreground_b,
        foreground_valid,
        data, address
    );

    background_m background (
        clk, rst,
        xp[7:0], yp[7:0],
        visible, writable,
        background_r, background_g, background_b,
        data, address
    );

endmodule
