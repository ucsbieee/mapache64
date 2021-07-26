

`ifdef LINTER
    `include "../headers/parameters.vh"
    `include "../rtl/gpu.v"
`endif


module top_m (
    input               clk_100, rst,
    output wire   [1:0] r,g,b,
    output wire         hsync, vsync
);

    clk_freq_conversion_m clk_freq_conversion(clk_12_5875, clk_100);

    wire [7:0] data = 8'b0;
    wire [`VRAM_ADDR_WIDTH-1:0] address = {`VRAM_ADDR_WIDTH{1'b0}};

    gpu_m gpu (
        clk_12_5875, rst,
        r,g,b, hsync, vsync,
        data, address
    );

endmodule
