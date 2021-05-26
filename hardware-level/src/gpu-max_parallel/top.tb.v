
`include "modules/gpu-top.v"

`include "parameters.v"

module top ();

reg clk_12_5875 = 1;
always #( `GPU_CLK_PERIOD / 2 ) clk_12_5875 = ~clk_12_5875;

reg rst;
wire [1:0] r, g, b;
wire hsync, vsync;
reg [7:0] data;
reg [`VRAM_ADDR_WIDTH-1:0] address;
reg cs;

gpu_top_m gpu_top (
    clk_12_5875, rst,
    r,g,b, hsync, vsync,
    data, address, cs
);

/* Test */
initial begin
$dumpfile( "dump.vcd" );
$dumpvars( );
//\\ =========================== \\//

#( 0.020 )

//\\ =========================== \\//
$finish ;
end

endmodule
