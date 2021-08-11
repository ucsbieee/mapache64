
`ifndef __UCSBIEEE__TOP__RTL__TOP_V
`define __UCSBIEEE__TOP__RTL__TOP_V


`ifdef LINTER
    `include "../../address_bus/rtl/address_bus.v"
    `include "../../firmware/rtl/firmware.v"
    `include "../../gpu-reduced/rtl/gpu.v"
`endif

module top_m #(
    parameter FOREGROUND_NUM_OBJECTS = 4
) (
    input               clk_12_5875, rst,
    input        [15:0] cpu_address,
    inout         [7:0] data,
    input               write_enable_B,

    output wire  [14:0] output_address,
    output wire         fpga_data_enable,
    output wire         SELECT_ram_B,
    output wire         SELECT_rom_B,
    output wire         SELECT_controller,
    output wire         vblank_irq_B,

    output wire   [1:0] r, g, b,
    output wire         hsync, vsync
);

    // internal
    wire SELECT_vram, SELECT_firmware, SELECT_in_vblank, SELECT_clr_vblank_irq;

    // inputs
    assign write_enable = ~write_enable_B;

    // outputs
    assign SELECT_ram_B = ~SELECT_ram;
    assign SELECT_rom_B = ~SELECT_rom;
    assign vblank_irq_B = ~vblank_irq;

    assign fpga_data_enable = !write_enable && ( SELECT_firmware || SELECT_vram || SELECT_in_vblank || SELECT_clr_vblank_irq );


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

    gpu_m #(FOREGROUND_NUM_OBJECTS) gpu (
        clk_12_5875, rst,
        r,g,b, hsync, vsync,
        data, output_address[11:0], write_enable, SELECT_vram,
        SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
    );

endmodule


`endif
