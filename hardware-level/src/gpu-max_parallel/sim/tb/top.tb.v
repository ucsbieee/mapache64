
`ifndef SIM
    `ERROR__SIM_undefined
    exit
`endif

`ifdef LINTER
    `include "../../rtl/gpu.v"
    `include "../../rtl/headers/parameters.vh"
    `include "../headers/timing.vh"
`endif

`timescale `TIMESCALE

module top_tb_m ();

reg clk_12_5875 = 1;
always #( `GPU_CLK_PERIOD / 2 ) clk_12_5875 = ~clk_12_5875;

reg rst;
wire [1:0] r, g, b;
wire hsync, vsync;
reg [7:0] data;
reg [`VRAM_ADDR_WIDTH-1:0] address;

gpu_m gpu (
    clk_12_5875, rst,
    r,g,b, hsync, vsync,
    data, address
);

/* Test */
initial begin
$dumpfile( "dump.fst" );
$dumpvars();
$timeformat( -3, 6, "ms", 0);
//\\ =========================== \\//

rst = 1;
#( `GPU_CLK_PERIOD * 1.5 )
rst = 0;

#( 0.02 )
// #( 0.001 )

//\\ =========================== \\//
$finish ;
end

endmodule
