

`ifdef LINTER
    `include "../rtl/top.v"
`endif


module top_synth_m (
    input               clk_in, rst,
    output wire   [1:0] r,g,b,
    output wire         hsync, vsync
);

    wire clk_12_5875;
    clk_freq_conversion_m clk_freq_conversion(clk_12_5875, clk_in);

    top_m top ();

endmodule
