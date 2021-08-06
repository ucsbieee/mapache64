
`ifndef __UCSBIEEE__TOP__SYNTH__TOP_SYNTH_V
`define __UCSBIEEE__TOP__SYNTH__TOP_SYNTH_V


`ifdef LINTER
    `include "../rtl/top.v"
`endif


module top_synth_m (
    input               clk_in, rst_in_B,
    output wire         rst_out_B,
    input        [15:0] cpu_address_in,
    output wire  [15:0] cpu_address_out,
    inout         [7:0] data,
    input               write_enable_B,

    output wire         SELECT_ram_B,
    output wire         ram_OE_B,
    output wire         SELECT_rom_B,
    output wire         SELECT_controller,
    output wire         vblank_irq_B,

    output wire   [1:0] r, g, b,
    output wire         hsync, vsync
);

    wire clk_12_5875;
    clk_freq_conversion_m clk_freq_conversion(clk_12_5875, clk_in);

    assign rst_out_B = rst_in_B;
    wire rst_in = ~rst_in_B;

    assign cpu_address_out = cpu_address_in;
    // assign data_out = data;

    wire write_enable = ~write_enable_B;


    assign ram_OE_B = ~(!write_enable && SELECT_ram_B);

    wire [14:0] output_address; // not connected

    wire SELECT_ram;
    wire SELECT_rom;
    wire SELECT_irq;

    assign SELECT_ram_B = ~SELECT_ram;
    assign SELECT_rom_B = ~SELECT_rom;
    assign vblank_irq_B = ~SELECT_irq;


    top_m top (
        clk_12_5875, rst_in,
        cpu_address_in,
        data,
        write_enable,

        output_address,
        SELECT_ram,
        SELECT_rom,
        SELECT_controller,
        vblank_irq,

        r, g, b,
        hsync, vsync
    );

endmodule


`endif
