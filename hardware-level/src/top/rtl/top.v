
`ifndef __UCSBIEEE__TOP__RTL__TOP_V
`define __UCSBIEEE__TOP__RTL__TOP_V


`ifdef LINTER
    `include "../../address_bus/rtl/address_bus.v"
    `include "../../firmware/rtl/firmware.v"
    `include "../../gpu-reduced/rtl/gpu.v"
`endif

module top_m (
    input               clk_12_5875, rst,
    input        [15:0] cpu_address,
    inout         [7:0] data,
    input               write_enable,

    output wire  [14:0] output_address,
    output wire         SELECT_ram,
    output wire         SELECT_rom,
    output wire         SELECT_controller,
    output wire         vblank_irq,

    output wire   [1:0] r, g, b,
    output wire         hsync, vsync
);

    wire SELECT_vram, SELECT_firmware, SELECT_in_vblank, SELECT_clr_vblank_irq;

    address_bus_m address_bus (
        cpu_address,
        output_address,
        SELECT_ram,
        SELECT_vram,
        SELECT_firmware,
        SELECT_rom,
        SELECT_in_vblank,
        SELECT_clr_vblank_irq,
        SELECT_controller
    );

    firmware_m firmware (
        output_address[13:0], data, SELECT_firmware
    );

    gpu_m #(1) gpu (
        clk_12_5875, rst,
        r,g,b, hsync, vsync,
        data, output_address[11:0], write_enable, SELECT_vram,
        SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
    );

endmodule


`endif
