
`ifndef __UCSBIEEE__GPU_OPTIMIZED__SYNTH__TOP_V
`define __UCSBIEEE__GPU_OPTIMIZED__SYNTH__TOP_V


`ifdef LINTER
    `include "../rtl/headers/parameters.vh"
    `include "../rtl/gpu.v"
`endif


module top_m #(
    parameter TEST = 0
) (
    input                           clk_in, rst,

    output wire               [1:0] r,g,b,
    output wire                     hsync, vsync,

    inout                     [7:0] data,
    input    [`VRAM_ADDR_WIDTH-1:0] address,
    input                           write_enable,

    input                           SELECT_in_vblank,
    input                           SELECT_clr_vblank_irq,
    output wire                     vblank_irq
);

    wire clk_12_5875;
    clk_freq_conversion_m clk_freq_conversion(clk_12_5875, clk_in);

    generate
        if ( TEST ) begin : fill_vram_input

            `ifdef LINTER
                `include "../tests/fill_vram.sv"
            `endif

            wire [7:0] data_fill_vram;
            wire [`VRAM_ADDR_WIDTH-1:0] address_fill_vram;
            wire write_enable_fill_vram;

            wire fill_vram_in_progress;

            gpu_m gpu (
                clk_12_5875, (fill_vram_in_progress|rst),
                r,g,b, hsync, vsync,
                data_fill_vram, address_fill_vram, write_enable_fill_vram,
                SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
            );

            fill_vram_m fill_vram (
                clk_12_5875, rst,
                data_fill_vram, address_fill_vram, write_enable_fill_vram,
                fill_vram_in_progress
            );

        end else begin : top_port_input

            gpu_m gpu (
                clk_12_5875, rst,
                r,g,b, hsync, vsync,
                data, address, write_enable,
                SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
            );

        end
    endgenerate


endmodule


`endif
