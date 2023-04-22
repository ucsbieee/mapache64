
/* gpu.v */

`ifndef __UCSBIEEE__GPU__RTL__GPU_V
`define __UCSBIEEE__GPU__RTL__GPU_V


`ifdef LINTER
    `include "hardware-level/rtl/gpu/rtl/video-timing.v"
    `include "hardware-level/rtl/gpu/rtl/text.sv"
    `include "hardware-level/rtl/gpu/rtl/foreground.sv"
    `include "hardware-level/rtl/gpu/rtl/background.sv"
    `include "hardware-level/rtl/gpu/rtl/vram_parameters.v"
`endif


module gpu_m #(
        parameter FOREGROUND_NUM_OBJECTS = 64
) (
    input                           gpu_clk,
    input                           cpu_clk,
    input                           rst,

    // video output
    output wire               [1:0] r, g, b,
    output wire                     hsync, vsync,
    output wire                     controller_start_fetch,

    // VRAM interface
    input                     [7:0] data_in,
    output                    [7:0] data_out,
    input    [`VRAM_ADDR_WIDTH-1:0] vram_address,
    input                           write_enable,
    input                           SELECT_vram,
    input                           SELECT_pmf,
    input                           SELECT_pmb,
    input                           SELECT_ntbl,
    input                           SELECT_obm,
    input                           SELECT_txbl,

    input                           SELECT_in_vblank,
    input                           SELECT_clr_vblank_irq,
    output reg                      vblank_irq
);

    // for vblank irw
    wire writable;

    // data out
    wire [7:0] text_data_out, foreground_data_out, background_data_out;
    assign data_out =
        (SELECT_in_vblank)          ? {7'b0,writable}       :
        (SELECT_txbl)               ? text_data_out         :
        (SELECT_pmf||SELECT_obm)    ? foreground_data_out   :
        (SELECT_pmb||SELECT_ntbl)   ? background_data_out   :
        {8{1'bz}};

    // for vblank irw
    reg writable_prev;
    initial writable_prev = 0;

    always @ ( posedge gpu_clk ) begin
        if ( write_enable && SELECT_clr_vblank_irq )
            vblank_irq <= 0;
        else if ( rst || (writable_prev != writable) )
            vblank_irq <= 1;
        writable_prev <= writable;
    end


    wire [8:0] current_x, current_y;
    wire [8:0] next_x, next_y;
    wire [9:0] hcounter, vcounter;
    wire visible, foreground_valid;

    wire text_color, text_valid;
    wire [1:0] foreground_r, foreground_g, foreground_b;
    wire [1:0] background_r, background_g, background_b;

    wire drawing = visible && (0 <= current_x && current_x < 256) && (0 <= current_y && current_y < 240);

    assign {r,g,b} =
        !drawing            ? 6'b0                                      :
        text_valid          ? {6{text_color}}                           :
        foreground_valid    ? {foreground_r,foreground_g,foreground_b}  :
        {background_r,background_g,background_b};


    assign current_x = hcounter[8:0] - 9'd32;
    assign current_y = vcounter[9:1];
    assign next_x = (current_x == 511) ? (0) : (current_x+1);
    assign next_y = (current_y == 262) ? (0) : (current_y+1);

    video_timing_m video_timing (
        gpu_clk, rst,
        hsync, vsync,
        hcounter, vcounter,
        visible,
        writable
    );

    assign controller_start_fetch = ( hcounter < 10'h20 ) && ( vcounter == 10'b0 );

    wire vram_write_enable = write_enable; // should be anding with "writable", but oh well!

    text_m text (
        gpu_clk, cpu_clk,
        current_x[7:0], current_y[7:0],
        text_color, text_valid,
        data_in, text_data_out, vram_address, vram_write_enable, SELECT_txbl
    );

    foreground_m #(
        .NUM_OBJECTS(FOREGROUND_NUM_OBJECTS),
        .LINE_REPEAT(2),
        .NUM_ROWS(523)
    ) foreground (
        gpu_clk, cpu_clk, rst,
        current_x, current_y,
        next_x, next_y,
        hsync,
        foreground_r, foreground_g, foreground_b,
        foreground_valid,
        data_in, foreground_data_out, vram_address, vram_write_enable,
        SELECT_pmf, SELECT_obm
    );

    background_m background (
        gpu_clk, cpu_clk, rst,
        current_x[7:0], current_y[7:0],
        next_x, next_y,
        background_r, background_g, background_b,
        data_in, background_data_out, vram_address, vram_write_enable,
        SELECT_pmb, SELECT_ntbl
    );

endmodule


`endif
