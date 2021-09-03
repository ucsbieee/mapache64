
`ifndef __UCSBIEEE__GPU__SYNTH__TOP_SYNTH_V
`define __UCSBIEEE__GPU__SYNTH__TOP_SYNTH_V


`ifdef LINTER
    `include "hardware-level/rtl/gpu/rtl/headers/parameters.vh"
    `include "hardware-level/rtl/gpu/rtl/gpu.v"
    `include "hardware-level/rtl/gpu/tests/fill_vram.sv"
    `include "hardware-level/rtl/gpu/synth/misc/clk_100_TO_clk_12_5875.vh"
`endif


module top_synth_m #(
    parameter TEST = 1'b0
) (
    input               clk_100, rst,

    output wire   [1:0] r, g, b,
    output wire         hsync, vsync
);

    wire clk_12_5875;
    clk_100_TO_clk_12_5875_m clk_100_TO_clk_12_5875(clk_12_5875, clk_100);
    wire fill_vram_in_progress;

    wire controller_start_fetch;

    wire [7:0] data_in, data_out;
    wire [`VRAM_ADDR_WIDTH-1:0] address;
    wire write_enable;
    wire SELECT_vram = 1;

    wire SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq;

    gpu_m gpu (
        clk_12_5875, (fill_vram_in_progress|rst),
        r,g,b, hsync, vsync, controller_start_fetch,
        data_in, data_out, address, write_enable, SELECT_vram,
        SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
    );

    fill_vram_m fill_vram (
        clk_12_5875, rst,
        data_in, address, write_enable,
        fill_vram_in_progress
    );


endmodule


`endif
