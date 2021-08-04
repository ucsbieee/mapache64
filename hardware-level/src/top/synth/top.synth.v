
`ifndef __UCSBIEEE__TOP__SYNTH__TOP_SYNTH_V
`define __UCSBIEEE__TOP__SYNTH__TOP_SYNTH_V


`ifdef LINTER
    `include "../rtl/top.v"
`endif


module top_synth_m (
    input               clk_in, rst,
    input        [15:0] cpu_address,
    input         [7:0] data_in,
    output wire   [7:0] data_out,
    input               write_enable,

    output wire  [14:0] output_address,
    output wire         SELECT_ram,
    output wire         SELECT_rom,
    output wire         SELECT_controller,
    output wire         vblank_irq,

    output wire   [1:0] r, g, b,
    output wire         hsync, vsync
);

    wire clk_12_5875;
    clk_freq_conversion_m clk_freq_conversion(clk_12_5875, clk_in);

    wire [7:0] data;
    assign data = write_enable ? data_in : {8{1'bz}};
    assign data_out = data;

    top_m top (
        clk_12_5875, rst,
        cpu_address,
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
