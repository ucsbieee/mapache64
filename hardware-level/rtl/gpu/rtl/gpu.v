
/* gpu.v */

`ifndef __UCSBIEEE__GPU__RTL__GPU_V
`define __UCSBIEEE__GPU__RTL__GPU_V


`ifdef LINTER
    `include "hardware-level/rtl/gpu/rtl/video-timing.v"
    `include "hardware-level/rtl/gpu/rtl/foreground.sv"
    `include "hardware-level/rtl/gpu/rtl/background.sv"
    `include "hardware-level/rtl/gpu/rtl/vram_parameters.v"
`endif


module gpu_m #(
        parameter FOREGROUND_NUM_OBJECTS = 64
) (
    input                           clk, // 12.5875 MHz
    input                           rst,

    // video output
    output wire               [1:0] r, g, b,
    output wire                     hsync, vsync,
    output wire                     controller_start_fetch,

    // VRAM interface
    input                     [7:0] data_in,
    output                    [7:0] data_out,
    input    [`VRAM_ADDR_WIDTH-1:0] address,
    input                           write_enable,
    input                           SELECT_vram,

    input                           SELECT_in_vblank,
    input                           SELECT_clr_vblank_irq,
    output reg                      vblank_irq
);

    // VBLANK IRQ
    wire writable;
    assign data_out = SELECT_in_vblank ? {7'b0,writable} : {8{1'bz}};

    reg writable_prev;
    initial writable_prev = 0;

    always @ ( posedge clk ) begin

        if ( write_enable && SELECT_clr_vblank_irq )
            vblank_irq <= 0;
        else if ( rst || (writable_prev != writable) )
            vblank_irq <= 1;
        else
            vblank_irq <= vblank_irq;

        writable_prev <= writable;
    end


    wire [8:0] current_x, current_y;
    wire [9:0] hcounter, vcounter;
    wire visible, foreground_valid;

    wire [1:0] foreground_r, foreground_g, foreground_b;
    wire [1:0] background_r, background_g, background_b;

    wire drawing = visible && (0 <= current_x && current_x < 256) && (0 <= current_y && current_y < 240);

    assign {r,g,b} = !drawing           ? 3'b0 :
                    foreground_valid    ? {foreground_r,foreground_g,foreground_b} :
                    {background_r,background_g,background_b};


    assign current_x = hcounter[8:0] - 9'd32;
    assign current_y = vcounter[9:1];

    video_timing_m video_timing (
        clk, rst,
        hsync, vsync,
        hcounter, vcounter,
        visible,
        writable
    );

    assign controller_start_fetch = ( hcounter < 10'd10 ) && ( vcounter == 10'b0 );

    foreground_m #(FOREGROUND_NUM_OBJECTS) foreground (
        clk, rst,
        current_x[7:0], current_y[7:0],
        writable,
        foreground_r, foreground_g, foreground_b,
        foreground_valid,
        data_in, address, (write_enable&SELECT_vram)
    );

    background_m background (
        clk, rst,
        current_x[7:0], current_y[7:0],
        writable,
        background_r, background_g, background_b,
        data_in, address, (write_enable&SELECT_vram)
    );

endmodule


`endif
