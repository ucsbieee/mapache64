

`ifdef LINTER
    `include "../headers/parameters.vh"
    `include "../rtl/gpu.v"
`endif

module top_m (
    input               clk, rst,
    output wire   [1:0] r,g,b,
    output wire         hsync, vsync
);

    wire [7:0] data = 8'b0;
    wire [`VRAM_ADDR_WIDTH-1:0] address = {`VRAM_ADDR_WIDTH{1'b0}};

    gpu_m gpu (
        clk_12_5875, rst,
        r,g,b, hsync, vsync,
        data, address
    );

endmodule
