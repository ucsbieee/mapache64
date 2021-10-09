
`ifndef __UCSBIEEE__TOP__RTL__TOP_V
`define __UCSBIEEE__TOP__RTL__TOP_V


`ifdef LINTER
    `include "hardware-level/rtl/address_bus/rtl/address_bus.v"
    `include "hardware-level/rtl/firmware/rtl/firmware.v"
    `include "hardware-level/rtl/gpu/rtl/gpu.v"
    `include "hardware-level/rtl/controller_interface/rtl/controller_interface.sv"
`endif

module top_m #(
    parameter FOREGROUND_NUM_OBJECTS = 64
) (
    input               clk_12_5875,
    input               cpu_clk, cpu_clk_enable,
    input               rst,
    input        [15:0] cpu_address,
    input         [7:0] data_in,
    output wire   [7:0] data_out,
    output wire         fpga_data_enable,
    input               write_enable_B,

    output wire         SELECT_ram_B,
    output wire         ram_OE_B,
    output wire         SELECT_rom_B,

    output wire         vblank_irq_B,

    output wire   [1:0] r, g, b,
    output wire         hsync, vsync,

    input               controller_clk_in_enable,
    output wire         controller_clk_out_enable,
    output wire         controller_latch,
    input               controller_1_data_in_B,
    input               controller_2_data_in_B,
    output wire   [7:0] controller_1_buttons_out,
    output wire   [7:0] controller_2_buttons_out
);

    // internal
    wire SELECT_vram, SELECT_firmware, SELECT_vectors, SELECT_in_vblank, SELECT_clr_vblank_irq, SELECT_controller_1, SELECT_controller_2, controller_start_fetch;

    // inputs
    wire write_enable = ~write_enable_B;

    // outputs
    wire SELECT_ram;
    wire SELECT_rom;
    wire vblank_irq;
    assign SELECT_ram_B = ~SELECT_ram;
    assign SELECT_rom_B = ~SELECT_rom;
    assign vblank_irq_B = ~vblank_irq;

    assign ram_OE_B = ~( !write_enable && SELECT_ram );
    assign fpga_data_enable = !write_enable && (
        SELECT_firmware         ||
        SELECT_vram             ||
        SELECT_vectors          ||
        SELECT_in_vblank        ||
        SELECT_clr_vblank_irq   ||
        SELECT_controller_1     ||
        SELECT_controller_2
    );


    address_bus_m address_bus (
        cpu_address,
        SELECT_ram,
        SELECT_vram,
        SELECT_firmware,
        SELECT_rom,
        SELECT_vectors,

        SELECT_in_vblank,
        SELECT_clr_vblank_irq,
        SELECT_controller_1,
        SELECT_controller_2
    );



    wire [7:0] firmware_data_out, gpu_data_out;
    // wire [7:0] controller_2_buttons_out, controller_1_buttons_out;

    assign data_out =
        SELECT_firmware         ? firmware_data_out         :
        SELECT_vectors          ? firmware_data_out         :
        SELECT_in_vblank        ? gpu_data_out              :
        SELECT_controller_1     ? controller_1_buttons_out  :
        SELECT_controller_2     ? controller_2_buttons_out  :
        {8{1'bz}};



    firmware_m firmware (
        cpu_address[13:0], firmware_data_out, SELECT_firmware, SELECT_vectors
    );



    wire [11:0] gpu_address = ( cpu_address - 16'h3700 );
    gpu_m #(FOREGROUND_NUM_OBJECTS) gpu (
        clk_12_5875, cpu_clk, cpu_clk_enable, rst,
        r,g,b, hsync, vsync, controller_start_fetch,
        data_in, gpu_data_out, gpu_address, write_enable, SELECT_vram,
        SELECT_in_vblank, SELECT_clr_vblank_irq, vblank_irq
    );

    controller_interface_m #(2) controller_interface (
        cpu_clk, controller_clk_in_enable, rst,
        controller_start_fetch,

        controller_clk_out_enable,
        controller_latch,

        {controller_2_data_in_B,controller_1_data_in_B},

        {controller_2_buttons_out,controller_1_buttons_out}
    );

endmodule


`endif
